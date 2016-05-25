//
//  GetCurrentData.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "GetCurrentData.h"
#import "OpenWeatherClient.h"
#import "CurrentWeatherData.h"
#import "Weather.h"
#import "City.h"
#import "Temperature.h"
#import "SunrizeAndSunset.h"

@interface GetCurrentData ()<OpenWeatherClientDelegate>
@property (nonatomic,weak)OpenWeatherClient * client;
@end

@implementation GetCurrentData
-(instancetype)initWithDelegate:(id<GetCurrentDataDelegate>)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }

    return self;
}

-(void)requestWithLocation{
    if (_location) {
        [self requestWithCoordinate:_location];
    }
}
-(void)requestWithCityId{
    if (_cityId) {
        [self requestWithCityId:_cityId];
    }
}
-(void)requestWithCityName{
    if (_cityName) {
        [self requestWithCityName:_cityName];
    }
}
-(void)requestWithCoordinate:(Coordinate *)corrdinate{
    
    [self.client getCurrentweatherDataByCoordinate:corrdinate];
}

-(void)requestWithCityId:(NSString *)cityId{

    [self.client getCurrentweatherDataByCityId:cityId];
}

-(void)requestWithCityName:(NSString *)cityName{

    [self.client getCurrentweatherDataByCityName:cityName];
}
-(OpenWeatherClient *)client{
    if (!_client) {
        _client = [OpenWeatherClient shareClient];
        _client.delegate = self;

    }
    return _client;
}

#pragma mark - OpenWeatherClientDelegate
-(void)WeatherClient:(OpenWeatherClient *)client didUpdateSucessWithWeather:(id)weather{

    if (self.delegate && [self.delegate respondsToSelector:@selector(GetCurrentData:getDataSuccessWithWeatherData:)]) {
        [self.delegate GetCurrentData:self getDataSuccessWithWeatherData:[self curentWeatherDataWithWeather:weather]];
    }
}

-(void)WeatherClient:(OpenWeatherClient *)client didUpdateSucessFailWithError:(NSError *)error{

    if (self.delegate && [self.delegate respondsToSelector:@selector(GetCurrentData:getDataFailWithError:)]) {
        [self.delegate GetCurrentData:self getDataFailWithError:error];
    }
}

-(CurrentWeatherData * _Nullable )curentWeatherDataWithWeather:(id)weather{
    CurrentWeatherData *weatherData;
    // 如果取得天气数据非空，创建weatherData并用下载到的天气数据为weatherData赋值
    if (weather) {


        weatherData = [CurrentWeatherData new];

        // 获取weather数据
        NSDictionary *subWeather = weather[@"weather"][0];
        weatherData.weather.main = (NSString *)subWeather[@"main"];
        weatherData.weather.weatherDescription = (NSString *)subWeather[@"description"];
        weatherData.weather.weatherCode = subWeather[@"id"];
        weatherData.weather.iconName = (NSString *)subWeather[@"icon"];

        // 获取城市数据
        weatherData.city.cityName = (NSString *)weather[@"name"];
        weatherData.city.cityId = (NSString *)weather[@"id"];
        weatherData.city.coordinate.lat = [(NSNumber *)weather[@"coord"][@"lat"] stringValue];
        weatherData.city.coordinate.lon = [(NSNumber *)weather[@"coord"][@"lon"] stringValue];
        weatherData.city.country = weather[@"sys"][@"country"];
        weatherData.city.ZHCityName = self.ZNCithName;
        // 获取基站数据
        weatherData.station = (NSString *)weather[@"base"];


        // 获取天气数据
        weatherData.Temperature.temp = (NSNumber*)weather[@"main"][@"temp"];
        weatherData.Temperature.maxTemp = (NSNumber*)weather[@"main"][@"temp_max"];
        weatherData.Temperature.minTemp = (NSNumber*)weather[@"main"][@"temp_min"];

        // 获取日出日落信息
        NSNumber *sunrize = weather[@"sys"][@"sunrise"];
        NSNumber *sunset = weather[@"sys"][@"sunset"];
        weatherData.sunrizeSunset.sunrize = [NSDate dateWithTimeIntervalSince1970:[sunrize doubleValue]];
        weatherData.sunrizeSunset.sunset = [NSDate dateWithTimeIntervalSince1970:[sunset doubleValue]];

        // 获取湿度 unit:％
        weatherData.humidity = weather[@"main"][@"humidity"];

        //获取 风速 meter/sec
        weatherData.windSpeed = weather[@"wind"][@"speed"];

        //获取更新时间
        NSNumber *updateTime = weather[@"dt"];
        weatherData.updateTime = [NSDate  dateWithTimeIntervalSince1970:[updateTime doubleValue]];


    }

    return weatherData;
}
@end
