//
//  CityTitleView.h
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/15.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"


typedef void(^MoreItemHandler)();
typedef void(^ShareItemHandler)();
typedef void(^RightButtonHandler)();

@class City;
@interface CityTitleView : BaseWheatherView
@property(nonnull,nonatomic,strong) City  *city;
@property(nonnull,nonatomic,copy) NSString *wheather;
@property(nonnull,nonatomic,strong) NSDate *updateTime;
@property(nullable,nonatomic,copy) NSString *station;
@property(nonnull,nonatomic,copy)MoreItemHandler moreItemHandler;
@property(nonatomic,nonnull,copy)ShareItemHandler shareItemHandler;
@property(nonatomic,nonnull,copy)RightButtonHandler rightButtonHandler;

@end
