//
//  WindSpeedView.h
//  WheatherAppTest
//
//  Created by 李南 on 16/3/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"

@interface WindSpeedView : BaseWheatherView
/**
 *  @brief 每秒旋转的圈数
 */
@property (nonatomic) CGFloat circleByOneSecond;

/**
 *  @brief 风速
 */
@property (nonatomic) CGFloat windSpeed;
@end
