//
//  ForcastWeather.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "ForcastWeather.h"

@implementation ForcastWeather
-(instancetype)init{
    self = [super init];
    if (self) {
        self.temp = [Temperature new];
        self.weather = [Weather new];
    }
    return self;
}
@end
