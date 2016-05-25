//
//  ForecastWeatherView.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/26.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineBackgroundView.h"

@interface ForecastWeatherView : UIView

/**
 *  城市编号码
 */
@property (nonatomic, strong) NSString *countryCode;

/**
 *  城市名字
 */
@property (nonatomic, strong) NSString *cityName;

/**
 *  创建出view
 */
- (void)buildView;

- (void)show;
- (void)hide;

@end
