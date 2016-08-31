//
//  GridView.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "GridView.h"
#import "Categories.h"
#import <pop/POP.h>

@interface GridView ()
@property (nonatomic,strong) CALayer *maskLayer;
@property (nonatomic) CGFloat startPositionX;
@property (nonatomic) CGFloat endPositionX;

@end

@implementation GridView
-(void)buildView{
    if (_spaceWidth <= 0) {
        _spaceWidth = 30;
    }
    
    // 计算横线和竖线和横线长度
    CGFloat HLineLength = 5 * _spaceWidth;
    CGFloat VLineLength = 4 * _spaceWidth;
    

    // 调整视图frame.
    self.frame = CGRectMake(self.x, self.y, HLineLength, VLineLength);
    
    // 生成竖线
    for (int i = 1; i < 4; i++) {
        UIView *HLine = [[UIView alloc] initWithFrame:CGRectMake(0, i*_spaceWidth, HLineLength, 0.5)];
        HLine.backgroundColor = [UIColor blackColor];
        HLine.alpha  = 0.5;
        [self addSubview:HLine];
    }
    // 生成横线
    for (int i = 1; i < 5; i++) {
        UIView *VLine = [[UIView alloc] initWithFrame:CGRectMake(i*_spaceWidth ,0, 0.5f, VLineLength)];
        VLine.backgroundColor = [UIColor blackColor];
        VLine.alpha  = 0.5f;
        [self addSubview:VLine];
    }
    
    // 生成mask layer .
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = self.bounds;
    
    maskLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,(__bridge id)[UIColor whiteColor].CGColor, (__bridge id)[UIColor clearColor].CGColor];
    maskLayer.locations = @[@0.20f, @0.6f,@0.80f];
    maskLayer.startPoint = CGPointMake(0, 0.5f);
    maskLayer.endPoint = CGPointMake(1, 0.5f);
    
    self.layer.mask = maskLayer;
    // 计算maskLayer的启始的，动画后Rect。
    self.endPositionX = HLineLength/2;
    self.startPositionX = -HLineLength/2;
    
    CGPoint postion = self.maskLayer.position;
    postion.x = self.startPositionX;
    self.maskLayer.position = postion;
    self.maskLayer = maskLayer;
    
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [self.maskLayer pop_removeAllAnimations];
    
    POPBasicAnimation *animation = [POPBasicAnimation linearAnimation ];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    animation.duration = duration;
    //animation.beginTime = delay;
    
    animation.fromValue = @(self.startPositionX);
    animation.toValue = @(self.endPositionX);
    
    __weak typeof(self) weakSelf = self;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
       // NSLog(@"%@", NSStringFromCGRect(weakSelf.maskLayer.frame));
    };
    [self.maskLayer pop_addAnimation:animation forKey:nil];
    
    
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [self.maskLayer pop_removeAllAnimations];
    
    POPBasicAnimation *animation = [POPBasicAnimation linearAnimation ];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionX];
    animation.duration = duration;
    animation.beginTime = delay;
    
    animation.fromValue = @(self.endPositionX);
    animation.toValue = @(self.startPositionX);
    __weak typeof(self) weakSelf = self;
    animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
        //NSLog(@"%@", NSStringFromCGRect(weakSelf.maskLayer.frame));
    };

    [self.maskLayer pop_addAnimation:animation forKey:nil];
    
}
@end
