//
//  SnowView.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//


#import "EmitterLayerView.h"

@interface SnowView : EmitterLayerView

@property (nonatomic, strong) UIImage *snowImage;

@property (nonatomic, assign) CGFloat   lifetime;   // 生命周期
@property (nonatomic, assign) CGFloat   birthRate;  // 出生率
@property (nonatomic, assign) CGFloat   speed;      // 雪花速率
@property (nonatomic, assign) CGFloat   speedRange; // 速率变化范围 [speed - speedRange , speed + speedRange]
@property (nonatomic, assign) CGFloat   gravity;    // 重力
@property (nonatomic, strong) UIColor  *snowColor;  // 雪花颜色

- (void)showSnow;
- (void)show;
- (void)hide;
- (void)configType:(EMitterType)type;

@end
