//
//  ThreeBladeView.h
//  WheatherAppTest
//
//  Created by 李南 on 16/3/15.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"

@interface ThreeBladeView : BaseWheatherView
/**
 *  一秒钟旋转几圈
 */
@property (nonatomic) CGFloat circleByOneSecond;

/**
 *  风的速度
 */
@property (nonatomic) CGFloat windSpeed;
/**
 *  @brief 转动扇叶
 */
-(void)rotateBladeWithCirleByOneSecond;
@end
