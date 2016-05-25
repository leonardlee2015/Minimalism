//
//  SunInfoView.h
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/13.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"

@class SunrizeAndSunset;
@interface SunInfoView : BaseWheatherView
@property(nonnull,nonatomic,strong) SunrizeAndSunset *sunrizeAndSunset;
@end
