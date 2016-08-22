//
//  WheatherView.h
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/17.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"

@class WeatherView;
@class CurrentWeatherData;


@protocol WeatherViewDelegate <BaseWheatherViewDelegate>
-(void)weatherViewPullUp:(nonnull WeatherView*)weatherView;
-(void)weatherViewPullDown:(nonnull WeatherView*)weatherView;
-(void)weatherViewDidPressMoreItem:(nonnull WeatherView*)weatherView;
-(void)weatherViewDidPressShareItem:(nonnull WeatherView *)weatherView;
-(void)weatherViewDidPressRightButton:(nonnull WeatherView *)weatherView;

@end
@interface WeatherView : BaseWheatherView

@property(nonatomic,strong,nonnull)CurrentWeatherData *weatherData;

@property(nullable,nonatomic,weak) id<WeatherViewDelegate> delegate;

@end
