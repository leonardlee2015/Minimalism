//
//  CityDBData.m
//  MyWheaher
//
//  Created by  Leonard on 16/5/7.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CityDbData.h"
#import <FMDB.h>
static NSString * const ImportCityDataFlag = @"LadCityDataFlag";
static NSString * const ImportCityConvertFlag = @"Import City Convert Flag";
static NSString * const ImportCityListFlag = @"Import City List Flag";

@interface CityDbData ()
@property(nonnull,nonatomic,copy) NSString *dbPath;
@property(nonnull,nonatomic,strong) FMDatabase *db;
@property(nonatomic,nonnull,strong) FMDatabaseQueue *dbQueue;
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
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
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
                
                dispatch_group_leave(group);
            }];
            
            
        }
        
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [_dbQueue close];
            
            if (isImportCityListData && isImportCityConvertData) {
                
                isImportCityData = YES;
                
                [[NSUserDefaults standardUserDefaults]  setObject:@(isImportCityData) forKey:ImportCityDataFlag];
            }
        });
        
        
    }

    
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
@end
