//
//  UIView+SetRect.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/1.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  UIScreen width.
 */
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
/**
 *  UIScreen height.
 */
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

/**
 *  iPhone4 or iPhone4s
 */
#define  iPhone4_4s     (WIDTH == 320.f && HEIGHT == 480.f ? YES : NO)

/**
 *  iPhone5 or iPhone5s
 */
#define  iPhone5_5s     (WIDTH == 320.f && HEIGHT == 568.f ? YES : NO)

/**
 *  iPhone6 or iPhone6s
 */
#define  iPhone6_6s     (WIDTH == 375.f && HEIGHT == 667.f ? YES : NO)

/**
 *  iPhone6Plus or iPhone6sPlus
 */
#define  iPhone6_6sPlus (WIDTH == 414.f && HEIGHT == 736.f ? YES : NO)

@interface UIView (SetRect)

/**
 *  @author ctd.leonard, 15-09-02 00:09:40
 *
 *  @brief  capsulation of  self.frame.size
 */
@property (nonatomic, assign) CGSize size;
/**
 *  @author ctd.leonard, 15-09-02 00:09:40
 *
 *  @brief  capsulation of  self.frame.origin.
 */
@property (nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, readonly) CGFloat midX;
@property (nonatomic, readonly) CGFloat midY;
@property (nonatomic, readonly) CGPoint boundsCenter;
@end
