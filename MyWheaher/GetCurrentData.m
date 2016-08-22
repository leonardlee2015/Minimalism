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
#import "CityDbData.h"


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
};
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

-(void)requestWithCityIds:(NSArray<NSString *> *)cityIds{

    [self.client getCurrentweatherDataByCityIDs:cityIds];

}
-(OpenWeatherClient *)client{
    if (!_client) {
        _client = [OpenWeatherClient getOpenWeatherClient];
        _client.delegate = self;

    }
    return _client;
}

#pragma mark - OpenWeatherClientDelegate
-(void)WeatherClient:(OpenWeatherClient *)client didUpdateSucessWithWeather:(id)weather{

    if ([weather[@"cnt"] integerValue] == 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(GetCurrentData:getDataSuccessWithWeatherData:)]) {
            [self.delegate GetCurrentData:self getDataSuccessWithWeatherData:[self curentWeatherDataWithWeather:weather]];
        }
    }else if ([weather[@"cnt"] integerValue]>0){
        if (_delegate && [_delegate respondsToSelector:@selector(GetCurrentDatas:getDataSuccessWithWeatherDatas:)]) {
            [self.delegate GetCurrentDatas:self getDataSuccessWithWeatherDatas:[self curentWeatherDatasWithWeather:weather]];
        }
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

        if ([weatherData.city.country isEqualToString:@"CN"]
            || [weatherData.city.country isEqualToString:@"China"]) {
            NSString *zhName = [[CityDbData shareCityDbData] requestZhCityNameByCityName:weatherData.city.cityName];
            weatherData.city.ZHCityName = [zhName stringByAppendingString:@"市"];

        }
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

-(nonnull NSDictionary<NSString*,CurrentWeatherData *>* )curentWeatherDatasWithWeather:(id)weather{
    NSMutableDictionary<NSString*,CurrentWeatherData *>* weatherDatas = [NSMutableDictionary dictionary];
    // 如果取得天气数据非空，创建weatherData并用下载到的天气数据为weatherData赋值
    if (weather) {

        NSUInteger cnt = [weather[@"cnt"] integerValue];

        for (NSUInteger i=0; i<cnt; i++) {

            CurrentWeatherData *weatherData = [CurrentWeatherData new];

            // 获取weather数据
            NSDictionary *cityWeather = weather[@"list"][i];

            NSDictionary *subWeather = cityWeather[@"weather"][0];
            weatherData.weather.main = (NSString *)subWeather[@"main"];
            weatherData.weather.weatherDescription = (NSString *)subWeather[@"description"];
            weatherData.weather.weatherCode = subWeather[@"id"];
            weatherData.weather.iconName = (NSString *)subWeather[@"icon"];

            // 获取城市数据
            weatherData.city.cityName = (NSString *)cityWeather[@"name"];
            weatherData.city.cityId = (NSString *)cityWeather[@"id"];
            weatherData.city.coordinate.lat = [(NSNumber *)cityWeather[@"coord"][@"lat"] stringValue];
            weatherData.city.coordinate.lon = [(NSNumber *)cityWeather[@"coord"][@"lon"] stringValue];
            weatherData.city.country = cityWeather[@"sys"][@"country"];
            weatherData.city.ZHCityName = self.ZNCithName;
            // 获取基站数据
            weatherData.station = (NSString *)cityWeather[@"base"];


            // 获取天气数据
            weatherData.Temperature.temp = (NSNumber*)cityWeather[@"main"][@"temp"];
            weatherData.Temperature.maxTemp = (NSNumber*)cityWeather[@"main"][@"temp_max"];
            weatherData.Temperature.minTemp = (NSNumber*)cityWeather[@"main"][@"temp_min"];

            // 获取日出日落信息
            NSNumber *sunrize = cityWeather[@"sys"][@"sunrise"];
            NSNumber *sunset = cityWeather[@"sys"][@"sunset"];
            weatherData.sunrizeSunset.sunrize = [NSDate dateWithTimeIntervalSince1970:[sunrize doubleValue]];
            weatherData.sunrizeSunset.sunset = [NSDate dateWithTimeIntervalSince1970:[sunset doubleValue]];

            // 获取湿度 unit:％
            weatherData.humidity = cityWeather[@"main"][@"humidity"];

            //获取 风速 meter/sec
            weatherData.windSpeed = cityWeather[@"wind"][@"speed"];
            
            //获取更新时间
            NSNumber *updateTime = cityWeather[@"dt"];
            weatherData.updateTime = [NSDate  dateWithTimeIntervalSince1970:[updateTime doubleValue]];

            [weatherDatas setObject:weatherData forKey:weatherData.city.cityId];

        }

        
    }
    
    return [weatherDatas copy];
}
@end
