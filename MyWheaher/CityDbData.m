
//
//  CityDBData.m
//  MyWheaher
//
//  Created by  Leonard on 16/5/7.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CityDbData.h"
#import "City.h"
#import <FMDB.h>
#import "MWHeWeatherClient.h"


static NSString * const ImportCityDataFlag = @"LadCityDataFlag";
static NSString * const ImportCityConvertFlag = @"Import City Convert Flag";
static NSString * const ImportCityListFlag = @"Import City List Flag";
static NSString * const ImportHeCityListFlag = @"Import he City List Flag";
static NSString * const ImportHeUpdateTimeFlag = @"Import he update time Flag";



@interface CityDbData ()<MWHeWeatherClientDelegate>
@property(nonnull,nonatomic,copy) NSString *dbPath;
@property(nonnull,nonatomic,strong) FMDatabase *db;
@property(nonatomic,nonnull,strong) FMDatabaseQueue *dbQueue;
@property(nonnull,nonatomic,strong) MWHeWeatherClient *client;
@end
@implementation CityDbData
+(CityDbData *)shareCityDbData{
    static CityDbData *cityData;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cityData = [[CityDbData alloc] init];
    });

    return cityData;
    
}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.dbPath = [self createDcoumentsPath:@"weather.db"];

        NSFileManager *fileManager = [NSFileManager defaultManager];

        if (![fileManager fileExistsAtPath:self.dbPath]) {
            NSString *srcPath = [[NSBundle mainBundle]pathForResource:@"weather" ofType:@"db"];

            NSError *error ;
            [fileManager copyItemAtPath:srcPath toPath:self.dbPath error:&error];

            if (error) {
                NSString *msg =[NSString stringWithFormat:@"move weather.db from %@ to %@ failed.", srcPath, self.dbPath];
                [NSException exceptionWithName:NSInternalInconsistencyException reason:msg userInfo:nil];

                return nil;
            }







        }
        

        // 获取数据库路径
        self.dbPath = [self createDcoumentsPath:@"weather.db"];
        self.db = [FMDatabase databaseWithPath:self.dbPath];

        if (self.db == nil) {
            return nil;
        }

        self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];

        if (self.dbQueue == nil) {
            return nil;
        }

    }
    return self;
}

-(NSString*)createDcoumentsPath:(NSString*)path{
    NSString *documentPath = [self documentPath];




    return [documentPath stringByAppendingPathComponent:path];
}

-(NSString*)documentPath{
    // return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];

}

-(void)updateHeCityList{
    [self initialHeCityData];
}
-(void)initialHeCityData{

    __block BOOL isUpdateHeData = [[[NSUserDefaults standardUserDefaults]valueForKey:ImportHeCityListFlag] doubleValue];

    // 创建和天气城市表
    if (![_db open]) {
        [NSException exceptionWithName:NSInternalInconsistencyException reason:@"open db weather.db fail." userInfo:nil];
    }
    BOOL success = [_db executeUpdate:@"create table IF NOT EXISTS he_city_list (city TEXT,cnty TEXT,id TEXT PRIMARY KEY,lat FLOAT,lon FLOAT)"];
    if (!success) {
        [_db close];
        return;
    }
    [_db close];

    // 表存在或者创建成功，若未更新，更新数据库。
    if (!isUpdateHeData) {


        __weak typeof(self) weakSlef = self;;
        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *path = [[NSBundle mainBundle]pathForResource:@"he_city_list" ofType:@"plist"];

            NSArray *cities = [NSArray arrayWithContentsOfFile:path];

            BOOL sucess = [db executeUpdate:@"DELETE FROM he_city_list"];

            if (!sucess) {
                *rollback = YES;
                return ;
            }


            for (NSDictionary *city in cities) {

                BOOL success = [db executeUpdate:@"INSERT INTO he_city_list VALUES(?,?,?,?,?)",
                                city[@"city"],
                                city[@"cnty"],
                                city[@"id"],
                                @([city[@"lat"] floatValue]),
                                @([city[@"lon"] floatValue])];

                if (!success) {
                    *rollback = YES;
                    return ;
                }

            }


            weakSlef.isUpdateCityListSuccess = YES;

            isUpdateHeData = YES;

            [[NSUserDefaults standardUserDefaults] setObject:@(isUpdateHeData) forKey:ImportCityListFlag];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];

        
    }

}
-(void)initializationDB{


    // 获取是否已经导入数据标识。

    __block BOOL isImportCityData = [[[NSUserDefaults standardUserDefaults]valueForKey:ImportCityDataFlag] boolValue];

    __block BOOL isImportCityConvertData = [[NSUserDefaults standardUserDefaults]valueForKey:ImportCityConvertFlag];
    __block BOOL isImportCityListData = [[NSUserDefaults standardUserDefaults]valueForKey:ImportCityListFlag];



    //如果未获取成功，检测
    if (!isImportCityData) {


        // 如果表未存在 创建表
        if (![_db open]) {

            return;
        }

        BOOL success = [_db executeUpdate:@"create table IF NOT EXISTS CN_CITY_INFO  (label TEXT, name TEXT PRIMARY KEY , pinyin TEXT,zip TEXT)"];
        if (!success) {

            [_db close];
            return;
        }
        success = [_db executeUpdate:@"create table  if not exists  OPEN_WEATHER_CITY_IFNO (id text ,name text ,country text, lat text, lon text , PRIMARY KEY(id,name))"];
        if (!success) {
            [_db close];
            return;
        }
        [_db close];

        // 表创建成功后 导入数据。

        dispatch_group_t group = dispatch_group_create();
        if (!isImportCityConvertData) {




            dispatch_group_enter(group);
            [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

                // 取json数据。
                NSString *path = [[NSBundle mainBundle]pathForResource:@"city_name_convert" ofType:@"json"];

                NSData *data = [NSData dataWithContentsOfFile:path];

                NSError *error;
                NSMutableArray *cityData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

                if (error || !cityData) {
                    NSLog(@"serialization city_name_convert json data fail. [%@]", [error localizedDescription]);
                    *rollback = YES;
                    dispatch_group_leave(group);
                    return ;
                }



                // 逐条从json data 中插入数据库查处数据
                BOOL success;
                for (NSDictionary *cityDic in cityData) {

                    success = [db executeUpdate:@"insert into CN_CITY_INFO values(?,?,?,?)", cityDic[@"label" ],cityDic[@"name"],cityDic[@"pinyin" ],cityDic[@"zip" ]];

                    if (!success) {

                        *rollback = YES;
                        NSLog(@"insert  data into CN_CITY_INFO fail.error: %@ . city dictionary:\n%@", db.lastErrorMessage, cityDic);
                        *rollback = YES;

                        dispatch_group_leave(group);
                        return;
                    }


                }

                isImportCityConvertData = YES;
                [[NSUserDefaults standardUserDefaults]setObject:@(isImportCityConvertData) forKey:ImportCityConvertFlag];
                [[NSUserDefaults standardUserDefaults]synchronize];



                dispatch_group_leave(group);
            }];


        }

        if (!isImportCityListData) {
            dispatch_group_enter(group);
            [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

                // 取City list JSON数据
                NSString *path = [[NSBundle mainBundle] pathForResource:@"city2.list" ofType:@"json"];
                NSData *data = [NSData dataWithContentsOfFile:path];

                NSError *error ;
                NSMutableArray *cityList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                if (error || !cityList) {
                    NSLog(@"serialize city list fail . %@", [error localizedDescription]);

                    dispatch_group_leave(group);
                    return ;
                }

                // 逐条插入数据。
                BOOL success;
                for (NSDictionary *cityDic in cityList) {
                    success = [db executeUpdate:@"insert into OPEN_WEATHER_CITY_IFNO values (?,?,?,?,?)", cityDic[@"_id"], cityDic[@"name"], cityDic[@"country"], cityDic[@"coord"][@"lat"], cityDic[@"coord"][@"lon"]];

                    if (!success) {
                        *rollback = YES;
                        NSLog(@"insert  data into OPEN_WEATHER_CITY_IFNO fail.error: %@ . city dictionary:\n%@", db.lastErrorMessage, cityDic);

                        dispatch_group_leave(group);
                        return;
                    }
                }

                isImportCityListData = YES;
                [[NSUserDefaults standardUserDefaults] setObject:@(isImportCityListData) forKey:ImportCityListFlag];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                dispatch_group_leave(group);
            }];
            
            
        }
        
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [_dbQueue close];
            
            if (isImportCityListData && isImportCityConvertData) {
                
                isImportCityData = YES;
                
                [[NSUserDefaults standardUserDefaults]  setObject:@(isImportCityData) forKey:ImportCityDataFlag];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        });
        
        
    }

    // 跟新he city lists.
    [self initialHeCityData];



    
}

-(NSString *)requestZhCityNameByCityName:(NSString *)cityName{
    NSString *zhCityName;

    if (![_db open]) {
        return nil;
    }
    FMResultSet *resultSet = [_db executeQuery:@"select name from CN_CITY_INFO where pinyin = ? COLLATE NOCASE",cityName];

    if (!resultSet) {
        NSLog(@"request %@ chinese name from CN_CITY_INFO fail.[%@] ",cityName, _db.lastErrorMessage);

        [_db close];
        return nil;
    }

    if ([resultSet next]) {

        zhCityName = [resultSet stringForColumn:@"name"];
    }

    [_db close];
    
    return zhCityName;

}

-(NSString *)requestCityNameByZHCityName:(NSString *)zhCityName{
    NSString *cityName;

    if (![_db open]) {
        NSLog(@"打开数据库失败。[%@]", _db.lastErrorMessage);
        return nil;
    }

    FMResultSet *resultSet = [_db executeQuery:@"SELECT PINYIN FROM CN_CITY_INFO WHERE NAME = ?", zhCityName];

    if (resultSet == nil) {
        [_db close];

        return nil;
    }

    if ([resultSet next]) {
        cityName = [resultSet stringForColumn:@"PINYIN"];
    }

    return cityName;
}

-(City *)requestHeWeatherCNCityByPinyin:(NSString *)pingying{
    City *city;

    if (![_db open]) {
        return nil;
    }

    NSString *querySql = @"SELECT  he_city_list.id,he_city_list.city,cn_city_info.pinyin  FROM cn_city_info,he_city_list WHERE cn_city_info.pinyin = ? COLLATE NOCASE AND trim(he_city_list.city)= trim(cn_city_info.name)";

    FMResultSet *resultSet = [_db executeQuery:querySql, pingying];

    if (!resultSet) {
        NSLog(@"requery  chinese He Weather  city info faild.error:%@", _db.lastErrorMessage);
        return nil;
    }

    if ([resultSet next]) {
        city = [City new];

        city.cityName = [resultSet stringForColumn:@"pinyin"];
        city.ZHCityName = [resultSet stringForColumn:@"city"];
        city.cityId =  [resultSet stringForColumn:@"id"];
        city.country = [city.cityId substringWithRange:NSMakeRange(0, 2)];
    }

    return city;
    
}

-(City *)requestHeWeatherCNCityByCityID:(NSString *)cityID{
    City *city;

    if (![_db open]) {
        return nil;
    }

    NSString *querySql = @"SELECT  he_city_list.id,he_city_list.city,cn_city_info.pinyin  FROM cn_city_info,he_city_list WHERE he_city_list.id = ? COLLATE NOCASE AND trim(he_city_list.city)= trim(cn_city_info.name)";

    FMResultSet *resultSet = [_db executeQuery:querySql, cityID];

    if (!resultSet) {
        NSLog(@"requery  chinese He Weather  city info faild.error:%@", _db.lastErrorMessage);
        return nil;
    }

    if ([resultSet next]) {
        city = [City new];

        city.cityName = [resultSet stringForColumn:@"pinyin"];
        city.ZHCityName = [resultSet stringForColumn:@"city"];
        city.cityId =  [resultSet stringForColumn:@"id"];
        city.country = [city.cityId substringWithRange:NSMakeRange(0, 2)];
    }

    return city;
    
}

-(City *)requestCityByCityName:(NSString *)name{
    City *city;

    if (![_db open]) {
        return nil;
    }

    NSString *querySql = @"SELECT id , name , country FROM OPEN_WEATHER_CITY_IFNO WHERE name = ? COLLATE NOCASE";

    FMResultSet *resultSet = [_db executeQuery:querySql, name];

    if (!resultSet) {
        NSLog(@"requery  city info in table OPEN_WEATHER_CITY_IFNO faild.error:%@", _db.lastErrorMessage);
        return nil;
    }

    if ([resultSet next]) {
        city = [City new];

        city.cityName = [resultSet stringForColumn:@"name"];
        city.country = [resultSet stringForColumn:@"country"];
        city.cityId =  [resultSet stringForColumn:@"id"];
    }

    if (city.cityId == nil) {
        return nil;
    }

    if ([city.country isEqualToString:@"CN"]) {
        querySql = @" SELECT name From CN_CITY_INFO WHERE pinyin = ? COLLATE NOCASE";

        resultSet = [_db executeQuery:querySql, city.cityName];

        if (!resultSet) {
            NSLog(@"requery  city info in table OPEN_WEATHER_CITY_IFNO faild.error:%@", _db.lastErrorMessage);
        }

        if ([resultSet next]) {
            city.ZHCityName = [resultSet stringForColumn:@"name"];

            city.country = [city.cityId substringWithRange:NSMakeRange(0, 2)];
        }

    }
    return city;
}

-(City *)requestCityByZHCityName:(NSString *)ZHname provinceName:(NSString *)provinceName{
    City *city ;

    if (![_db open]) {
        DLog(@"open db failed: %@",[_db lastErrorMessage]);
        return nil;
    }

    NSString *sql = @"SELECT  CN_CITY_INFO.name as name,pinyin,OPEN_WEATHER_CITY_IFNO.id an id,country  from CN_CITY_INFO,OPEN_WEATHER_CITY_IFNO  WHERE CN_CITY_INFO.NAME = ? AND PROVINCE = ? AND OPEN_WEATHER_CITY_IFNO.name = pinyin COLLATE NOCASE";

    FMResultSet *result = [_db executeQuery:sql, ZHname, provinceName];

    if (!result) {
        DLog(@"query data failed : %@", [_db lastErrorMessage]);
        return nil;
    }

    if ([result next]) {
        city = [City new];

        city.cityId = [result stringForColumn:@"id"];
        city.cityName = [result stringForColumn:@"pinyin"];
        city.ZHCityName = [result stringForColumn:@"name"];
        city.country = [result stringForColumn:@"country"];
    }

    return city;

}

-(City *)requestHeWeatherCityByName:(NSString *)name{
    City *city ;

    if (![_db open]) {
        return nil;
    }


    NSString *querySql = @"SELECT city , id  FROM he_city_list WHERE city = ? COLLATE NOCASE";

    FMResultSet *resultSet = [_db executeQuery:querySql, name];

    if (!resultSet) {
        NSLog(@"requery He Weather city info faild.error:%@", _db.lastErrorMessage);
        return nil;
    }

    if ([resultSet next]) {
        city = [City new];
        city.cityName = [resultSet stringForColumn:@"city"];
        city.cityId = [resultSet stringForColumn:@"id"];
        city.country = [city.cityId substringWithRange:NSMakeRange(0, 2)];
    }

    return city;
}

-(City *)requestHeWeatherCityByZHName:(NSString *)ZHName province:(NSString *)province{

    City *city ;

    if (![_db open]) {
        DLog(@"open db failed: %@",[_db lastErrorMessage]);
        return nil;
    }

    NSString *sql = @"select * from CN_CITY_INFO WHERE NAME = ? AND province = ?";

    FMResultSet *result = [_db executeQuery:sql, ZHName, province];

    if (!result) {
        DLog(@"query data failed : %@", [_db lastErrorMessage]);
        return nil;
    }

    if ([result next]) {
        city  =  [City new];

        city.cityId = [result stringForColumn:@"id"];
        city.cityName = [result stringForColumn:@"pinyin"];
        city.ZHCityName = [result stringForColumn:@"name"];
        city.country = [city.cityId substringWithRange:NSMakeRange(0, 2)];

    }

    return city;

}

-(NSArray<City *> *)searchHeCitiesByCondition:(NSString *)condition{

    NSMutableArray *cities = [NSMutableArray array];


    NSString *querySQL;
    
    if ([self containsChinese:condition]) {
        querySQL = [NSString stringWithFormat:@"SELECT * FROM he_city_list  where city like '%%%@%%' COLlATE NOCASE AND length(id) = 11",condition];
    }else{
        querySQL = [NSString stringWithFormat:@"SELECT * FROM he_city_list  where city like '%%%@%%' COLlATE NOCASE ",condition];

    }



    if (![_db open]) {
        return nil;
    }

    FMResultSet *resultSet = [_db executeQuery:querySQL];

    if (!resultSet) {
        NSLog(@"search He Weather city info faild.error:%@", _db.lastErrorMessage);

        return nil;
    }

    while ([resultSet next]) {
        City *city = [City new];
        city.cityId = [resultSet stringForColumn:@"id"];
        city.country = [city.cityId substringWithRange:NSMakeRange(0, 2)];

        NSString *name = [resultSet stringForColumn:@"city"];

        if ([city.country isEqualToString:@"CN"]) {
            city.ZHCityName = name;

            NSString *enName = [self requestCityNameByZHCityName:name];

            if (enName && ![enName isEqualToString:@""]) {
                city.cityName = enName;

            }else{
                city.cityName = name;
            }
        }else{
            city.cityName = name;
        }

        city.coordinate.lat = [resultSet stringForColumn:@"lat"];
        city.coordinate.lon = [resultSet stringForColumn:@"lon"];

        [cities addObject:city];
    }

    return [cities copy];




}

-(BOOL)containsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    } return NO;
}
#pragma mark -  He City data 


-(MWHeWeatherClient *)client{
    if (!_client) {
        _client = [MWHeWeatherClient client];
        _client.delegate = self;
    }

    return _client;
}

-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessFailWithError:(NSError *)error{


    _isUpdateCityListSuccess = NO;

}

-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessWithWeatherData:(id)weather type:(MWHeDataType)type{


    if (type == MWHeDataTypeCities) {
        NSArray *cities = weather[@"city_info"];

        __weak typeof(self) weakSlef = self;;

        [_dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {

            BOOL sucess = [_db executeUpdate:@"DELETE FROM he_city_list"];

            if (!sucess) {
                *rollback = YES;
                return ;
            }

            for (NSDictionary *city in cities) {

                BOOL success = [_db executeUpdate:@"INSERT INTO he_city_list VALUE(?,?,?,?,?)",
                 city[@"city"],
                 city[@"cnty"],
                 [city[@"lat"] floatValue],
                 [city[@"lon"] floatValue]];

                if (!success) {
                    *rollback = YES;
                    return ;
                }


                weakSlef.isUpdateCityListSuccess = YES;
            }
        }];
    }
}
@end


