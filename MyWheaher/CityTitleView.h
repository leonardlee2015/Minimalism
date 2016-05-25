//
//  CityTitleView.h
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/15.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"

@class City;
@interface CityTitleView : BaseWheatherView
@property(nonatomic,strong) City  *city;
@property(nonatomic,copy) NSString *wheather;
@property(nonatomic,strong) NSDate *updateTime;
@property(nonatomic,copy) NSString *station;

@end
