//
//  ForcastWeather.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/27.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Temperature.h"
#import "Weather.h"

@interface ForcastWeather : NSObject
/**
 *  Temperature of data forecasted
 */
@property(nonatomic,strong)Temperature *temp;
@property(nonatomic,strong)Weather *weather;
/**
 *  Time of data forecasted
 */
@property(nonatomic,strong)NSDate *dt;
/**
 *  humidity of data forecasted
 */
@property(nonatomic,strong) NSNumber *humidity;
/**
 *  wind speed of data forecasted
 */
@property(nonatomic,strong) NSNumber *windSpeed;
@end
