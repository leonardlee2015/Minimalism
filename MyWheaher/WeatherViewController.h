//
//  WheatherViewController.h
//  MyWheaher
//
//  Created by  Leonard on 16/7/28.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WeatherViewStyle){
    WeatherViewStyleLocationCity,
    WeatherViewstyleTargetCity,
};

typedef NS_ENUM(NSUInteger, WeatherViewStatus) {
    WeatherViewStatusNormal,
    WeatherViewRequesting,
    WeatherViewfailed
};

@class WeatherViewController;
@protocol WeatherViewControllerDelegate <NSObject>

-(void)viewContoller:(nonnull WeatherViewController*)vc StatusDidChange:(WeatherViewStatus)status;

@end

@interface WeatherViewController : UIViewController
@property(nonnull,copy,nonatomic) City *city;
@property(nonatomic) WeatherViewStatus status;
@property(nullable,nonatomic,weak)id<WeatherViewControllerDelegate> delegate;

-(nullable instancetype)initWithStyle:(WeatherViewStyle)style;

-(void)reflesh;
@end
