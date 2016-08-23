//
//  WindSpeedView.m
//  WheatherAppTest
//
//  Created by 李南 on 16/3/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "WindSpeedView.h"
#import "MoveTitleLabel.h"
#import "ThreeBladeView.h"
#import "NumberView.h"
#import "UIImage+BitMap.h"
#import <pop/POP.h>

@interface WindSpeedView ()<NumberViewDelegate>{
    MoveTitleLabel *_titleLablel;
    UIView *_pillarView;
    ThreeBladeView *_threeBladeView;
    UIImageView *_pointView;
    NumberView *_windSpeedView;
    CGPoint _pillarStart;
    CGPoint _pillarEnd;
    
}

@end

@implementation WindSpeedView




-(void)buildView{
    // 创建标题视图
     _titleLablel = [[MoveTitleLabel alloc]initWithFrame:ScaleRectMake(20, 10, 0, 0)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                      initWithString:NSLocalizedString(@"WindSpeedTitle", @"Wind Speed")
                                      attributes:@{
                                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:MOD(19)],
                                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.3 alpha:1.0f]
                                                   }];
    _titleLablel.attributedTitle = str;
    _titleLablel.startOffset = ScalePointMake(-30,0);
    _titleLablel.endOffset = ScalePointMake(30, 0);
    [self addSubview:_titleLablel];
    [_titleLablel buildView];
    
    // 创建 扇叶视图
    //CGFloat windOffsetX = MOD(40.f) ;
    //CGFloat windOffsetY = MOD(50.f);
    CGRect windFrame = ScaleRectMake(40.f, 55.f, 70.f, 70.f);
    
    _threeBladeView = [[ThreeBladeView alloc]initWithFrame:windFrame];
    [_threeBladeView buildView];
    _threeBladeView.circleByOneSecond = self.circleByOneSecond;
    [self addSubview:_threeBladeView];
    _threeBladeView.alpha = 0.f;
    
    // 创建支柱
    CGRect pillarFrame = ScaleRectMake(0, 0, 2, 75);
    _pillarView = [[UIView alloc]initWithFrame:pillarFrame];
    _pillarView.origin = _threeBladeView.center;
    _pillarView.x -= 1.f;
    _pillarView.backgroundColor = [UIColor blackColor];
    
    [self addSubview:_pillarView];
    _pillarView.alpha = 0.f;
    
    _pillarEnd = _pillarView.center;
    _pillarView.centerY += 75.f;
    _pillarStart = _pillarView.center;
    
    // 创建 原点
    _pointView = [[UIImageView alloc]initWithImage:[UIImage ovalImageBySize:ScaleSizeMake(4, 4) color:[UIColor blackColor]]];
    _pointView.frame = ScaleRectMake(0, 0, 4, 4);
    _pointView.center = _threeBladeView.center;
    [self addSubview:_pointView];
    _pointView.alpha = 0.f;
    
    
    // 创建风速计数器。
    _windSpeedView = [[NumberView alloc]initWithNumber:self.windSpeed];
    _windSpeedView.frame = ScaleRectMake(93, 150, 93, 15);
    _windSpeedView.delegate = self;
    [_windSpeedView buildView];
    [self addSubview:_windSpeedView];

    
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_threeBladeView.layer removeAllAnimations];
    [_threeBladeView pop_removeAllAnimations];
    
    [UIView animateWithDuration:duration animations:^{
        _pillarView.center = _pillarStart;
        _pillarView.alpha = 0.f;
        
        _pointView.alpha = 0.f;
        _threeBladeView.alpha = 0.f;
    }];
    
    [_titleLablel hideByDuration:duration delay:delay];
    [_threeBladeView hideByDuration:duration delay:delay];
    [_windSpeedView hideByDuration:duration delay:delay];
    [super hideByDuration:duration delay:delay];
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [UIView animateWithDuration:duration animations:^{
        _pillarView.center = _pillarEnd;
        _pillarView.alpha = 1.f;
        
        _pointView.alpha = 1.f;
        _threeBladeView.alpha = 1.f;
    }];
    

    [_titleLablel showByDuration:duration delay:delay];
    [_windSpeedView showByDuration:duration delay:delay];
    
    [_threeBladeView showByDuration:duration delay:delay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [_threeBladeView rotateBladeWithCirleByOneSecond];
    });

    
    [super showByDuration:duration delay:delay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setWindSpeed:(CGFloat)windSpeed{
    _windSpeed = windSpeed;
    _windSpeedView.number = _windSpeed;
}
-(void)setCircleByOneSecond:(CGFloat)circleByOneSecond{
    _circleByOneSecond = circleByOneSecond;
    _threeBladeView.circleByOneSecond = _circleByOneSecond;
}
-(NSAttributedString *)NumberView:(NumberView *)numberView accessNumber:(CGFloat)number{
    NSString *numStr = [NSString stringWithFormat:@"%.2f",number*3.6];
    NSString *unitStr = [NSString stringWithFormat:@"kmph"];
    NSString *totalStr = [numStr stringByAppendingString:unitStr];
    
    NSRange unitRange = [totalStr rangeOfString:unitStr];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:totalStr \
                                                                           attributes:@{
                                                                                        NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:MOD(12)],
                                                                                        NSForegroundColorAttributeName:[UIColor blackColor]
                                                                                        }];
    
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AppleSDGothicNeo-UltraLight" size:MOD(10)] range:unitRange];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:unitRange];
    
    return [str copy];
    
}

@end
