//
//  CurrentWeatherData.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CurrentWeatherData.h"

BOOL isUsingHeWeatherData = YES;


@implementation CurrentWeatherData
-(instancetype)init{
    self = [super init];
    if (self) {
        _weather = [Weather new];
        _city = [City new];
        _Temperature = [Temperature new];
        _sunrizeSunset = [SunrizeAndSunset new];

    }

    return self;
}
@end
