//
//  ForcastWeatherData.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "ForcastWeatherData.h"
#import "CityDbData.h"


@interface ForcastWeatherData ()
@end

@implementation ForcastWeatherData
+(ForcastWeatherData *)ForcastWeatherDataFromWeatherData:(NSDictionary *)weatherData{
    if (!weatherData) {
        return nil;
    }

    ForcastWeatherData * forcastWeatherData = [ForcastWeatherData new];

    forcastWeatherData.city = [City new];

    // 获取城市信息
    forcastWeatherData.city.cityId = [weatherData valueForKeyPath:@"city.id"];
    forcastWeatherData.city.cityName = [weatherData valueForKeyPath:@"city.name"];
    forcastWeatherData.city.coordinate.lat = [weatherData valueForKeyPath:@"city.coord.lat"];
    forcastWeatherData.city.coordinate.lon = [weatherData valueForKeyPath:@"city.coord.lon"];
    forcastWeatherData.city.country = [weatherData valueForKeyPath:@"city.country"];


    // 获取list 计数
    forcastWeatherData.cnt = [weatherData valueForKeyPath:@"cnt"];
    if ([forcastWeatherData.cnt integerValue] > 0) {
        NSMutableArray *forcastWeatherList = [NSMutableArray arrayWithCapacity:10];

        NSArray *tempWeatherList = [ weatherData valueForKey:@"list"];
        [tempWeatherList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 获取一天的weather数据，并存入数据库
            ForcastWeather *weather = [ForcastWeather new];

            weather.temp.temp = [obj valueForKeyPath:@"temp.day"];
            weather.temp.maxTemp = [obj valueForKeyPath:@"temp.max"];
            weather.temp.minTemp = [obj valueForKeyPath:@"temp.min"];

            weather.weather.main = [[obj valueForKeyPath:@"weather.main"] firstObject];
            weather.weather.weatherDescription = [[obj valueForKeyPath:@"weather.description"] firstObject];
            weather.weather.iconName = [[obj valueForKeyPath:@"weather.icon"] firstObject];
            weather.weather.weatherCode = [[obj valueForKeyPath:@"weather.id"] firstObject];

            weather.dt = [NSDate dateWithTimeIntervalSince1970:[obj[@"dt"] doubleValue]];

            weather.humidity = obj[@"humidity"];
            weather.windSpeed = obj[@"speed"];

            [forcastWeatherList addObject:weather];

        }];

        forcastWeatherData.forcastWeatherList = [forcastWeatherList copy];

        
    }


    return forcastWeatherData;

}

+(ForcastWeatherData *)ForcastWeatherDataFromHeWeatherData:(NSDictionary *)weatherData{
    if (!weatherData) {
        return nil;
    }

    ForcastWeatherData * forcastWeatherData = [ForcastWeatherData new];

    forcastWeatherData.city = [City new];

    // 获取城市信息
    NSDictionary *cityWeather = weatherData[@"HeWeather data service 3.0"][0];

    forcastWeatherData.city.cityId = (NSString *)cityWeather[@"basic"][@"id"];
    forcastWeatherData.city.country = [cityWeather[@"basic"][@"id"] substringWithRange:NSMakeRange(0, 2)];

    if ([forcastWeatherData.city.country isEqualToString:@"CN"]) {
        City *city = [[CityDbData shareCityDbData] requestHeWeatherCNCityByCityID:forcastWeatherData.city.cityId];

        forcastWeatherData.city.cityName = city.cityName;
        forcastWeatherData.city.ZHCityName = city.ZHCityName;
    }else{
        forcastWeatherData.city.cityName = (NSString *)cityWeather[@"basic"][@"city"];

    }


    forcastWeatherData.city.coordinate.lat = cityWeather[@"basic"][@"lat"];
    forcastWeatherData.city.coordinate.lon = cityWeather[@"basic"][@"lon"];



    // 获取list 计数
    forcastWeatherData.cnt = @(6);
    if ([forcastWeatherData.cnt integerValue] > 0) {
        NSMutableArray *forcastWeatherList = [NSMutableArray arrayWithCapacity:7];

        NSArray *tempWeatherList = [[ cityWeather valueForKey:@"daily_forecast"] subarrayWithRange:NSMakeRange(1, 6)];

        [tempWeatherList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            // 获取一天的weather数据，并存入数据库
            ForcastWeather *weather = [ForcastWeather new];

            weather.temp.maxTemp = @([[obj valueForKeyPath:@"tmp.max"] integerValue]);
            weather.temp.minTemp = @([[obj valueForKeyPath:@"tmp.min"] integerValue]);

            weather.weather.weatherDescription = [obj valueForKeyPath:@"cond.txt_d"] ;
            weather.weather.weatherCode = [obj valueForKeyPath:@"cond.code_d"];

            weather.dt = [self dateFromDay:obj[@"date"]];

            weather.humidity = @([obj[@"hum"] integerValue]);

            CGFloat windSpeed = [obj[@"wind"][@"spd"] floatValue];
            windSpeed = windSpeed * (1 / 3.6);
            weather.windSpeed = @(windSpeed);

            [forcastWeatherList addObject:weather];

        }];

        forcastWeatherData.forcastWeatherList = [forcastWeatherList copy];
        
        
    }
    
    
    return forcastWeatherData;
}

+(NSDate*)dateFromDay:(NSString*)day{


    NSDateFormatter *toDateFormatter = [NSDateFormatter new];
    [toDateFormatter setDateFormat:@"yyyy-MM-dd"];
    toDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];

    NSDate *date = [toDateFormatter dateFromString:day];

    return date;
}
@end
