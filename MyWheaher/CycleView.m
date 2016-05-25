//
//  CycleView.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/16.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "CycleView.h"
#import "UIView+SetRect.h"
#import <POP/POP.h>

@interface CycleView ()
@property(nonatomic,strong) CAShapeLayer *backgroundCycle;
@property(nonatomic,strong) CAShapeLayer *percentCycle;

@property(nonatomic,assign) CGFloat originPositionX;
@property(nonatomic,assign) CGFloat targetPositionX;

@end
@implementation CycleView

#define CYCLESTYKE_PERCENT 0.75f

-(void)buildView{
    
    self.alpha = 0.f;
    
    // create backgroundCycleView and percentCycleView.
    self.backgroundCycle = [self cycleWithColor:[UIColor grayColor]];
    [self.layer addSublayer:self.backgroundCycle];
    
    self.percentCycle = [self cycleWithColor:[UIColor blackColor]];
 
    [self.layer addSublayer:self.percentCycle];
}

-(CAShapeLayer*)cycleWithColor:(UIColor*)color{
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.lineWidth = self.lineWidth? self.lineWidth : 2;
    
    layer.strokeColor = color.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeEnd = 0;
    
    return layer;
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    // rotate the view .
    POPBasicAnimation *rotateAnimaion = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotateAnimaion.toValue = @(M_PI_4);
    rotateAnimaion.duration = duration;
    
    POPBasicAnimation *BGCycleStokeEndAnimaion = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    BGCycleStokeEndAnimaion.fromValue = @(0.f);
    BGCycleStokeEndAnimaion.toValue = @(_baseStokeEnd?_baseStokeEnd:CYCLESTYKE_PERCENT);
    BGCycleStokeEndAnimaion.duration = duration;
    
    POPBasicAnimation *PerCycleStokeEndAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    PerCycleStokeEndAnimation.fromValue = @(0.f);
    PerCycleStokeEndAnimation.toValue = @((_baseStokeEnd?_baseStokeEnd:CYCLESTYKE_PERCENT) *self.percent);
    PerCycleStokeEndAnimation.duration = duration;

    
    
    [self.backgroundCycle pop_addAnimation:BGCycleStokeEndAnimaion forKey:@"BGcycleStokeendShowAnimaiton"];
    [self.percentCycle pop_addAnimation:PerCycleStokeEndAnimation forKey:@"perCycleStokeendShowAnimation"];
    [self.layer pop_addAnimation:rotateAnimaion forKey:@"viewRotationShowAnimation"];
    

    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1.0f;
    }];
    
    [super showByDuration:duration delay:delay];
}
-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    // rotate the view .
    POPBasicAnimation *rotateAnimaion = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotateAnimaion.toValue = @(0);
    rotateAnimaion.duration = duration;
    
    POPBasicAnimation *BGCycleStokeEndAnimaion = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    BGCycleStokeEndAnimaion.toValue = @(0);
    BGCycleStokeEndAnimaion.duration = duration;
    
    POPBasicAnimation *PerCycleStokeEndAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    PerCycleStokeEndAnimation.toValue = @(0);
    PerCycleStokeEndAnimation.duration = duration;


    
    
    [self.backgroundCycle pop_addAnimation:BGCycleStokeEndAnimaion forKey:@"BGcycleStokeendHideAnimaiton"];
    [self.percentCycle pop_addAnimation:PerCycleStokeEndAnimation forKey:@"perCycleStokeendHideAnimation"];
    [self.layer pop_addAnimation:rotateAnimaion forKey:@"viewRotationHideAnimation"];
    

    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.0f;
    }];
    [super hideByDuration:duration delay:delay];
}

-(void)setPercent:(CGFloat)percent{
    // clamp enter percent to [0, 100];
    if (percent>=100 ) {
        percent = 100;
    }else if (percent < 1){
        percent = 0;
    }
        
    _percent = percent/100;
    
}
@end
