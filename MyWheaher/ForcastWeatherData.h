//
//  ForcastWeatherData.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "Weather.h"
#import "City.h"
#import "ForcastWeather.h"

#import "Coordinate.h"

@interface ForcastWeatherData : NSObject
@property(nonatomic,strong, nonnull) City *city;
@property(nonatomic,strong,nonnull) NSNumber *cnt;
@property(nonatomic,strong,nonnull) NSArray<ForcastWeather*>* forcastWeatherList;

+(ForcastWeatherData* __nullable)ForcastWeatherDataFromWeatherData:(nonnull NSDictionary*)weatherData;
@end
