//
//  ForcastWeatherData.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "ForcastWeatherData.h"

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


@end
