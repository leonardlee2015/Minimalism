//
//  CurrentWeatherData.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//



#import "Weather.h"
#import "City.h"
#import "Temperature.h"
#import "SunrizeAndSunset.h"
#import "Coordinate.h"

extern BOOL isUsingHeWeatherData;

@interface CurrentWeatherData : NSObject

@property(nonatomic,strong )Weather *weather;
@property(nonatomic,strong) City *city;
@property(nonatomic,strong) Temperature *Temperature;
@property(nonatomic,strong) SunrizeAndSunset *sunrizeSunset;
@property(nonatomic,strong) NSDate *updateTime;

/**
 *  Humidity, %
 */
@property(nonatomic,strong) NSNumber *humidity;
/**
 *   wind speed. unit:meter/sec,
 */
@property(nonatomic,strong) NSNumber *windSpeed;
@property(nonatomic,copy) NSString *station;
@end
