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

+ (NSString *)fontTextWeatherNumber:(NSNumber *)number;
+ (UIColor *)iconColor:(NSNumber *)number;
#ifdef EMITTER
+ (EMitterType)emitterTypeWithNumber:(NSNumber *)number;
#endif
@end
