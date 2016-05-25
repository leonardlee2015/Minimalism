//
//  NumberAnimation.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/25.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <pop/POP.h>

@class NumberAnimation;

@protocol NumberAnimationDelegate <NSObject>
@required
/**
 *  @abstract NumberAnimation,需实现 该方法才可和实现视图动画
 *  @brief  须实现该方法才可实现视图的数字动画
 *
 *  @param view   view to display the current number
 *  @param number current number to bisplay bu view .
 */
-(void)animation:(NumberAnimation*)animation ByCurrentNumber:(CGFloat)number;

@end

@interface NumberAnimation : NSObject
/**
 *  @abstract 委托
 *  @discussion 该数字动画引擎的委托，必须实现该委托才可实现动画效果。
 */
@property(nonatomic,weak) id<NumberAnimationDelegate> delegate;
/**
 *  @brief  初始值
 */
@property (nonatomic,strong) __kindof NSValue  *fromValue;
/**
 *  @brief  结束值
 */
@property (nonatomic,strong) __kindof NSValue  *toValue;
/**
 *  @brief  动画时间
 */
@property (nonatomic,assign) CGFloat duration;
/**
 *  @brief  动画
 */
@property (nonatomic,strong) POPBasicAnimation *animation;
/**
 *  @brief  开始动画
 */
-(void)startAnimation;
@end
