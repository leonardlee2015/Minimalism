//
//  WeatherNumberMeaningTransform.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/19.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EmitterLayerView.h"
//#define EMITTER

@interface WeatherNumberMeaningTransform : NSObject

+ (nullable NSString *)fontTextWeatherNumber:(nonnull NSNumber *)number;
+ (nullable UIColor *)iconColor:(nonnull NSNumber *)number;


+(nullable UIColor*)heIconColor:(nonnull NSNumber*)number;
+ (BOOL)flashFlagByWeatherCode:(nonnull NSNumber*)code;

#ifdef EMITTER
+ (EMitterType)emitterTypeWithNumber:(NSNumber *)number;

#endif
@end
