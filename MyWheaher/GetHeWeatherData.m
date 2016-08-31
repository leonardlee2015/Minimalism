//
//  GetHeWeatherData.m
//  MyWheaher
//
//  Created by  Leonard on 16/8/15.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "GetHeWeatherData.h"
#import "MWHeWeatherClient.h"
#import "CurrentWeatherData.h"
#import "CityDbData.h"

@interface GetHeWeatherData ()<MWHeWeatherClientDelegate>{
    BOOL _multiReqeust;
    NSUInteger _multiReqCount;
    NSMutableDictionary<NSString*,CurrentWeatherData*>* _multiWeatherDatas;
    NSMutableArray<CurrentWeatherData*> *_inMultiWeatherDatas;

    dispatch_group_t _group;


}

@property (nonatomic,strong,readonly)MWHeWeatherClient * client;

@property (nonatomic,strong) NSArray *cityIDs;

@end

@implementation GetHeWeatherData
-(instancetype)initWithDelegate:(__weak id<GetHeWeatherDataDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }

    return self;
}
-(void)requestWithCityId:(NSString *)cityId{
    [self canncelPreviousTasks];

    self.cityId = cityId;
    [self.client requestCityWeatherdataByID:cityId];
}
-(void)requestWithCityId{
    [self canncelPreviousTasks];
    
    [self.client requestCityWeatherdataByID:self.cityId];

}
-(void)requestWithCityName:(NSString *)cityName{
    [self canncelPreviousTasks];

    self.cityName = cityName;
    [self.client requestCityWeatherdataByName:cityName];
}

-(void)requestWithCityName{
    [self canncelPreviousTasks];

    [self.client requestCityWeatherdataByName:self.cityName];
}
-(void)requestWithCityIds:(NSArray<NSString *> *)cityIds{
    // 请求前如果还有任务未完成取消任务。
    [self canncelPreviousTasks];

    // 重置重复请求申请。
    _multiReqeust = YES;
    _multiReqCount = 0;
    _cityIDs = cityIds;
    _multiWeatherDatas = [NSMutableDictionary dictionaryWithCapacity:cityIds.count];
    _inMultiWeatherDatas = [NSMutableArray arrayWithCapacity:cityIds.count];


    _group = dispatch_group_create();

    for (NSString *cityId in cityIds) {
        if (![cityId isEqual:[NSNull null]]) {
            dispatch_group_enter(_group);
            [self.client requestCityWeatherdataByID:cityId];

        }

    }
    //[self.client requestCityWeatherdataByID:cityIds[0]];

    dispatch_group_notify(_group, dispatch_get_main_queue(), ^{
        if (_inMultiWeatherDatas.count == cityIds.count) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(GetHeWeatherData:getDataSuccessWithWeatherDatas:)]) {
                [self.delegate GetHeWeatherData:self getDataSuccessWithWeatherDatas:[_multiWeatherDatas copy]];
            }

        }else{
            if (self.delegate && [self.delegate respondsToSelector:@selector(GetHeWeatherData:getDataFailWithError:)]) {
                [self.delegate GetHeWeatherData:self getDataFailWithError:NULL];
            }

        }


    });
}

-(void)canncelPreviousTasks{
    for (NSURLSessionTask *task in self.client.dataTasks) {
        [task cancel];
    }
}

#pragma mark - MWHeWeatherClient
@synthesize client = _client;
-(MWHeWeatherClient *)client{
    if (!_client) {
        _client = [MWHeWeatherClient client];
        _client.delegate  = self;
    }

    return _client;
}


-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessFailWithError:(NSError *)error{

    if (_multiReqeust) {
        dispatch_group_leave(_group);
    }else{

        if (self.delegate && [self.delegate respondsToSelector:@selector(GetHeWeatherData:getDataFailWithError:)]) {
            [self.delegate GetHeWeatherData:self getDataFailWithError:error];
        }
    }




}
-(void)MWWeatherClient:(MWHeWeatherClient *)client didUpdateSucessWithWeatherData:(id)weather type:(MWHeDataType)type{
    if (_multiReqeust) {
        _multiReqCount++;
        CurrentWeatherData *weatherData = [self curentWeatherDataWithWeather:weather];
        [_multiWeatherDatas setObject:weatherData forKey:weatherData.city.cityId];
        [_inMultiWeatherDatas addObject:weatherData];

        dispatch_group_leave(_group);
        //[self.client requestCityWeatherdataByID:_cityIDs[_multiReqCount]];


    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(GetHeWeatherData:getDataSuccessWithWeatherData:)]) {
            [self.delegate GetHeWeatherData:self getDataSuccessWithWeatherData:[self curentWeatherDataWithWeather:weather]];
        }

    }
}


-(CurrentWeatherData * _Nullable )curentWeatherDataWithWeather:(id)weather{
    CurrentWeatherData *weatherData;
    // 如果取得天气数据非空，创建weatherData并用下载到的天气数据为weatherData赋值
    if (weather) {


        weatherData = [CurrentWeatherData new];

        // 获取weather数据
        NSDictionary *cityWeather = weather[weatherHeaderKey][0];

        // 获取城市数据

        weatherData.city.cityId = (NSString *)cityWeather[@"basic"][@"id"];
        weatherData.city.country = [cityWeather[@"basic"][@"id"] substringWithRange:NSMakeRange(0, 2)];

        if ([weatherData.city.country isEqualToString:@"CN"]) {
            City *city = [[CityDbData shareCityDbData] requestHeWeatherCNCityByCityID:weatherData.city.cityId];

            weatherData.city.cityName = city.cityName;
            weatherData.city.ZHCityName = city.ZHCityName;
        }else{
            weatherData.city.cityName = (NSString *)cityWeather[@"basic"][@"city"];

        }

        weatherData.weather.weatherDescription = (NSString *)cityWeather[@"now"][@"cond"][@"txt"];
        weatherData.weather.weatherCode = cityWeather[@"now"][@"cond"][@"code"];

        weatherData.city.coordinate.lat = [cityWeather[@"basic"][@"lat"] mutableCopy];
        weatherData.city.coordinate.lon = [cityWeather[@"basic"][@"lon"] mutableCopy];


        // 获取基站数据
        weatherData.station = @"stations";


        // 获取天气数据
        NSDictionary *nowCityWeather = cityWeather[@"daily_forecast"][0];



        weatherData.Temperature.temp = @([cityWeather[@"now"][@"tmp"] integerValue]);
        weatherData.city.temperature = @([cityWeather[@"now"][@"tmp"] integerValue]);

        weatherData.Temperature.maxTemp = @([nowCityWeather[@"tmp"][@"max"] integerValue]);
        weatherData.Temperature.minTemp = @([nowCityWeather[@"tmp"][@"min"] integerValue]);;

        // 获取日出日落信息
        NSString *sunrize = nowCityWeather[@"astro"][@"sr"];
        NSString *sunset = nowCityWeather[@"astro"][@"ss"];
        weatherData.sunrizeSunset.sunrize = [self dateFromTodayTime:sunrize];
        weatherData.sunrizeSunset.sunset = [self dateFromTodayTime:sunset];

        // 获取湿度 unit:％
        weatherData.humidity = cityWeather[@"now"][@"hum"];

        //获取 风速 meter/sec
         float windSpeed = [cityWeather[@"now"][@"wind"][@"spd"] floatValue];
        windSpeed = windSpeed *(1 / 3.6);

        weatherData.windSpeed = @(windSpeed);
        //获取更新时间
        weatherData.updateTime = [NSDate date];
        
        
    }
    
    return weatherData;
}

-(NSDate*)dateFromTodayTime:(NSString*)time{
    NSDateFormatter *toStrFormatter = [NSDateFormatter new];
    toStrFormatter.locale = [NSLocale currentLocale];
    [toStrFormatter setDateFormat:@"yyyy-MM-dd"];

    NSString *day = [toStrFormatter stringFromDate:[NSDate date]];
    NSString *fullTime = [NSString stringWithFormat:@"%@ %@:00", day, time];

    NSDateFormatter *toDateFormatter = [NSDateFormatter new];
    [toDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [toDateFormatter dateFromString:fullTime];

    return date;
 }

@end
