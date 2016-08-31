//
//  MyWheaherTests.m
//  MyWheaherTests
//
//  Created by  Leonard on 16/4/17.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SearchCityData.h"
#import "MWHeWeatherClient.h"
#import "AFNetworkActivityLogger.h"
#import "GetHeWeatherData.h"
#import "GetHeForcastWeatherData.h"
#import "CurrentWeatherData.h"
#import "ForcastWeatherData.h"
#import "CityDbData.h"
#import "WeatherNumberMeaningTransform.h"
#import "Analysitcs.h"

#import <SDWebImage/SDWebImageManager.h>
NSString *const ADDKey = @"add";

@interface MyWheaherTests : XCTestCase<SearchCityDataDelegate,MWHeWeatherClientDelegate, GetHeWeatherDataDelegate, GetHeForcastWeatherDataDelegate>
@property(nullable,nonatomic,strong) OpenWeatherClient* client;
@property(nonatomic,strong)XCTestExpectation *expectation;
@property(nonatomic)dispatch_group_t group;
@end
@implementation MyWheaherTests


- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _client = [OpenWeatherClient shareClient];
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:ADDKey options:NSKeyValueObservingOptionNew context:NULL];

    [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelInfo;
    [[AFNetworkActivityLogger sharedLogger]startLogging];
    self.group = dispatch_group_create();




}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _client = nil;
    [[AFNetworkActivityLogger sharedLogger] stopLogging];
    [super tearDown];
}

- (void)testTest {
    self.expectation = [self expectationWithDescription:@"expection"];


    __weak typeof(self) weakSlef = self;
    _client.getCompletedBlock = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject){
        [weakSlef.expectation fulfill];
        NSLog(@"%@",responseObject);
        \
        XCTAssertNotNil(responseObject,@"responseObject is null");

    };

    _client.getFailBlock = ^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        [weakSlef.expectation fulfill];
        XCTAssertNil(error,@"an error appear!");
    };
    [_client getCurrentweatherDataByCityName:@"Guangzhou"];
    id str = [[NSUserDefaults standardUserDefaults] valueForKey:@"CFBundleVersion"];
    NSLog(@"aaaa: %@", str);




    [self waitForExpectationsWithTimeout:31 handler:nil];

}

-(void)testCitiesReauest{
    NSString *basePath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    NSLog(@"%@",basePath);

    
}

- (void)testUIImage{
    [self measureBlock:^{
        UIImage *image = [[UIImage imageNamed:@"cover"] imageWithGradientTintColor:[UIColor yellowColor]];

    }];
}
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.

}
-(void)testChange{
    [[NSUserDefaults standardUserDefaults] setObject:@"addafa" forKey:ADDKey];
}

-(void)testFindCity{
    self.expectation = [self expectationWithDescription:@"expection"];
    
    SearchCityData *search = [[SearchCityData alloc]init];
    search.delegate = self;
    [search searchCityByName:@"广州"];
    [self waitForExpectationsWithTimeout:31 handler:nil];

}

-(void)testResult{
    NSString *str = @"    aaaa    ";

    NSLog(@"[%@]    ", [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);

    NSMutableString *str2 = [@"" mutableCopy];
    [str2 appendFormat:@"adaKKKK %@", str ];

    NSLog(@"--[%@]", str2);


}

-(void)testString{
    NSArray *cityIds = @[@"1231231",@"12412542",@"135732"];

    NSMutableString * str = [@"" mutableCopy];
    for (NSString *cityID in cityIds) {
        [str appendFormat:@"%@,",cityID];
        if (cityID == cityIds.lastObject) {
            [str deleteCharactersInRange:NSMakeRange(str.length-1, 1)];
        }
    }

}

-(void)testNSDictionary{
    NSDictionary *dic = @{
                          @"key":@"key",
                          @"cnt":[NSNull null]

                          };
    NSUInteger cnt = [dic[@"cnt"] integerValue];
    
}

-(void)testEnum{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"https" ofType:@"cer"];
    NSLog(@"path: %@", path );
}



-(void)testMWHeWeatherRequest{

    // 使测试等待接收到数据才结束
    self.expectation = [self expectationWithDescription:@"expectation"];

    MWHeWeatherClient *clent = [MWHeWeatherClient client];
    clent.delegate = self;
    [clent getAllWorldCityList];

    __weak typeof(self) weakSlef = self;;
    [self waitForExpectationsWithTimeout:200 handler:^(NSError * _Nullable error) {

    }];


}

-(void)testTime{
    NSDate *date = [self dateFromTodayTime:@"10:15"];

    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"time :  %@", [formatter stringFromDate:date]);

}

-(void)testLocate{
    NSArray *ids = [NSLocale availableLocaleIdentifiers];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@ OR SELF CONTAINS [c] %@",@"CN", @"ZH"];
    NSLog(@"%@", [ids filteredArrayUsingPredicate:predicate]);
    NSLog(@"curr %@", [NSLocale currentLocale].localeIdentifier);
}
-(NSDate*)dateFromTodayTime:(NSString*)time{
    NSDateFormatter *toStrFormatter = [NSDateFormatter new];
    //toStrFormatter.locale = [NSLocale currentLocale];
    [toStrFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *day = [toStrFormatter stringFromDate:[NSDate date]];
    NSString *fullTime = [NSString stringWithFormat:@"%@ %@:00", day, time];

    NSDateFormatter *toDateFormatter = [NSDateFormatter new];
    [toDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [toDateFormatter dateFromString:fullTime];

    return date;
}

-(void)testGetHeWeatherData{
    self.expectation = [self expectationWithDescription:@"id"];

    GetHeWeatherData *getData = [[GetHeWeatherData alloc]initWithDelegate:self];

    [getData requestWithCityId:@"CN101010100"];

    [self waitForExpectationsWithTimeout:41 handler:nil];;
}
-(void)testHeByIDs{
    self.expectation = [self expectationWithDescription:@"id"];

    GetHeWeatherData *getData = [[GetHeWeatherData alloc]initWithDelegate:self];

    [getData requestWithCityIds:@[@"CN101010100",@"CN101010200"]];

    [self waitForExpectationsWithTimeout:41 handler:nil];;
}

-(void)testUpdateCityList{
    self.expectation = [self expectationWithDescription:@"testUpdateCityList"];

    CityDbData *db = [CityDbData shareCityDbData];
    [db updateHeCityList];
    [self waitForExpectationsWithTimeout:41 handler:nil];;

}

-(void)testGetForcast{
    self.expectation = [self expectationWithDescription:@"testGetForcast"];

    GetHeForcastWeatherData *get = [[GetHeForcastWeatherData alloc]initWithDelegate:self];
    [get requestWithCityId:@"CN101010100"];

    [self waitForExpectationsWithTimeout:40 handler:nil];
}

-(void)testDB{
    CityDbData *db = [CityDbData shareCityDbData];

    City *city = [db requestHeWeatherCNCityByPinyin:@"guangzhou"];

    City *city2 = [db requestHeWeatherCityByName:@"london"];

    City *city3 = [db requestHeWeatherCNCityByCityID:@"JP1850147"];

    
}

-(void)testOpenWeatherDB{
    CityDbData *db = [CityDbData shareCityDbData];
    City *city = [db requestCityByCityName:@"shanghai"];
    

}

-(void)testSearchDB{
    CityDbData *db = [CityDbData shareCityDbData];
    NSArray <City*>*ar = [db searchHeCitiesByCondition:@"lon"];

}

-(void)testImageWrite{
    NSString *DocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    NSString *path = [DocPath stringByAppendingPathComponent:@"sun.jpg"];

    UIImage *sun = [UIImage imageNamed:@"sun"];
    [UIImageJPEGRepresentation(sun, 1.0) writeToFile:path atomically:YES];

    NSLog(@"%@",DocPath);

    NSFileManager *manager =[NSFileManager defaultManager];
    NSLog(@"%@", [manager contentsOfDirectoryAtPath:DocPath error:NULL]);

}


-(void)testDownPng{
        self.expectation = [self expectationWithDescription:@"all coud"];

    NSString *DocPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    NSString *path = [DocPath stringByAppendingPathComponent:@"couds.plist"];
    NSLog(@"path :%@",path);

    NSArray<NSDictionary*>*couds = [NSArray arrayWithContentsOfFile:path];

    SDWebImageManager *downloader = [SDWebImageManager sharedManager];

    for (NSDictionary *coud in couds) {

        dispatch_group_enter(self.group);



        NSURL *url = [NSURL URLWithString:coud[@"icon"]];

        [downloader
         downloadImageWithURL:url
         options:0
         progress:nil
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
             NSString *iconName = imageURL.lastPathComponent;
             NSString *iconPathDoc = [DocPath stringByAppendingPathComponent:@"icons"];

             NSString *iconPath = [DocPath stringByAppendingPathComponent:iconName];

             [UIImagePNGRepresentation(image) writeToFile:iconPath atomically:YES];

             dispatch_group_leave(self.group);

         }];
        
    }

    dispatch_group_notify(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self.expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:400 handler:nil];

}
-(void)testDownAllCoud{
    self.expectation = [self expectationWithDescription:@"all coud"];

    MWHeWeatherClient *client = [MWHeWeatherClient client];
    client.delegate = self;

    [client getAllCondList];

    [self waitForExpectationsWithTimeout:500 handler:nil];
}

-(void)testArray{
    NSArray *array = @[@"all", @"coud", @"leonard", @"test"];

    XCTAssert([array containsObject:@"coud"], @"is no ture");
}

-(void)testTransformWeatherCode{
    BOOL flash = [WeatherNumberMeaningTransform flashFlagByWeatherCode :@(100)];
    XCTAssert(flash, @"flash cannot work");

}
-(void)testCheckZHenvironment{
    // 从NSUserDefaults中取语言环境信息。
    NSArray *appleLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];

    // 判断是否包含中文语言ID。若包含返回YES ,否则返回NO.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS [c] %@", @"zh-"];

    NSArray *resultArray = [appleLanguages filteredArrayUsingPredicate:predicate];

    BOOL result = resultArray.count>0 ? YES: NO;

    XCTAssert(result , @"test predicate failed");
}

-(void)testUM{
    Class cls = NSClassFromString(@"UMANUtil");
    SEL deviceIDSelector = @selector(openUDIDString);
    NSString *deviceID = nil;
    if(cls && [cls respondsToSelector:deviceIDSelector]){
        deviceID = [cls performSelector:deviceIDSelector];
    }
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];

    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);

    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:0];

    [objects addObject:[NSNull null]];

    NSString *str = [objects firstObject];

    XCTAssert([str isEqual:[NSNull null]] ,@"");


}
-(void)testIsContainChinese{

    NSString * chinese = @"adfa ";

    XCTAssert([self IsChinese:chinese], @"fun not work");
}

-(BOOL)IsChinese:(NSString *)str {
    for(int i=0; i< [str length];i++)
    {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    } return NO;
}
#pragma mark - delegate

-(void)searchCityData:(SearchCityData *)searchCityData didUpdateSucessWithData:(NSArray *)cities{
    [self.expectation fulfill];

}

-(void)searchCityData:(SearchCityData *)searchCityData didUpdateFailWithError:(NSError *)error{
    [self.expectation fulfill];
    
}

-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessWithWeatherData:(id)weather type:(MWHeDataType)type{

    NSString *basePath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];


    if (type == MWHeDataTypeCouds) {
        NSArray <NSDictionary*>* couds = weather[@"cond_info"];

        NSString *path = [basePath stringByAppendingPathComponent:@"couds.plist"];
        [couds writeToFile:path atomically:YES];

        NSArray <NSString*>*coudUrls = [couds valueForKeyPath:@"icon"];
        NSString *iconPathDoc = [basePath stringByAppendingPathComponent:@"icons"];

        SDWebImageManager *downloader = [SDWebImageManager sharedManager];
        NSLog(@"%@",path);


        for (NSString *url in coudUrls) {

            dispatch_group_enter(self.group);




            [downloader
             downloadImageWithURL:[NSURL URLWithString:url]
             options:0
             progress:nil
            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                NSString *iconName = imageURL.lastPathComponent;
                NSString *iconPath = [basePath stringByAppendingPathComponent:iconName];

                [UIImagePNGRepresentation(image) writeToFile:iconPath atomically:YES];

                dispatch_group_leave(self.group);

             }];

        }

        dispatch_group_notify(self.group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            [self.expectation fulfill];


        });


    }else{


        NSString *path = [basePath stringByAppendingPathComponent:@"he_city_list.plist"];

        NSArray *cities = weather[@"city_info"];
        [cities writeToFile:path atomically:YES];
        NSLog(@"%@",path);





    }




}
-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessFailWithError:(NSError *)error{
    [self.expectation fulfill];
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    NSLog(@"get change.");
}

-(void)GetHeForcastWeather:(GetHeForcastWeatherData *)getData didUpdateSucessWithData:(ForcastWeatherData *)weatherData{

    


    [self.expectation fulfill];

}
-(void)GetHeForcastWeather:(GetHeForcastWeatherData *)getData didUpdateFailWithError:(NSError *)error{

    [self.expectation fulfill];

}

-(void)GetHeWeatherData:(GetHeWeatherData *)getData getDataFailWithError:(NSError *)error{

    [self.expectation fulfill];

}

-(void)GetHeWeatherData:(GetHeWeatherData *)getData getDataSuccessWithWeatherData:(CurrentWeatherData *)weatherData{

    [self.expectation fulfill];

}

-(void)GetHeWeatherData:(GetHeWeatherData *)getData getDataSuccessWithWeatherDatas:(NSDictionary<NSString *,CurrentWeatherData *> *)weatherDatas{

    [self.expectation fulfill];

}


@end
