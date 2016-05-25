//
//  ThreeBladeView.m
//  WheatherAppTest
//
//  Created by 李南 on 16/3/15.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "ThreeBladeView.h"
#import "BladeView.h"
#import <pop/POP.h>
#import "Categories.h"
#import "ForcastViewController.h"


@interface ThreeBladeView (){
    BladeView *firstBladeView ;
    BladeView *secondBladeView;
    BladeView *thridBladeView;

    UIImage *bladeImage;
}

@end
@implementation ThreeBladeView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 检查是否是否为正方形。
        [self checkSizeWithFrame:frame];

        
        // 新建
        [[NSNotificationCenter defaultCenter]addObserverForName:DismissForcastViewCNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            [self rotateBladeWithCirleByOneSecond];

        }];
    }
    return self;
}

-(void)buildView{
    bladeImage = [UIImage imageNamed:@"WindSpeed"];
    
    // build扇叶
    firstBladeView =  [self createBladeViewByAngle:0];
    secondBladeView = [self createBladeViewByAngle:120];
    thridBladeView = [self createBladeViewByAngle:240];


    //self.layer.masksToBounds  = YES;
}

-(BladeView*)createBladeViewByAngle:(CGFloat)angle{


    // 获取扇叶宽度
    CGFloat width = self.height * (bladeImage.size.width / bladeImage.size.height) /2;
    // 获取扇叶content rect.
    CGRect frame = CGRectMake(0, 0, width, self.bounds.size.height);
    
    //创建扇叶view
    BladeView *bladeView = [[BladeView alloc]initWithFrame:frame];
    [bladeView buildView];
    bladeView.center = self.boundsCenter;
    [self addSubview:bladeView];
    // 设置扇叶显示样式
    if (angle != 0.f) {
        bladeView.transform = CGAffineTransformMakeRotation(radian(angle));
    }
    
    return bladeView;
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [firstBladeView showByDuration:duration delay:delay];
    [secondBladeView showByDuration:duration delay:delay];
    [thridBladeView showByDuration:duration delay:delay];
    
    [super showByDuration:duration delay:delay];
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [firstBladeView hideByDuration:duration delay:delay];
    [secondBladeView hideByDuration:duration delay:delay];
    [thridBladeView hideByDuration:duration delay:delay];
    
    
    [super hideByDuration:duration delay:delay];
}

static NSString *rotationKey = @"rotation";
-(void)rotateBladeWithCirleByOneSecond{

    CGFloat  circleByOneSecond = _circleByOneSecond <= 0? 0.001: _circleByOneSecond;
#define POP_ANIMATON
#ifdef POP_ANIMATION
    // 启动一个不停止旋转的pop动画

    POPBasicAnimation *rotateAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotateAnim.fromValue = @0.f;
    rotateAnim.toValue = @(M_PI*2*10000);
    rotateAnim.duration = (1/circleByOneSecond) *10000;
    
    rotateAnim.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer pop_addAnimation:rotateAnim forKey:nil];
#else
    [self.layer removeAnimationForKey:rotationKey];

    CABasicAnimation *rotaionAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    rotaionAnim.fromValue = @0.f;
    rotaionAnim.toValue = @(M_PI*2*10000);
    rotaionAnim.duration = (1/circleByOneSecond) *10000;
    
    rotaionAnim.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:rotaionAnim forKey:rotationKey];
#endif
}


@end
