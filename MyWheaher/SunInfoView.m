//
//  SunInfoView.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/13.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "SunInfoView.h"
#import "SunView.h"
#import "MoveTitleLabel.h"
#import "AddedFont.h"
#import "SunrizeAndSunset.h"
@interface SunInfoView (){
    MoveTitleLabel *_titleLablel;
    SunView *_sunrizeView;
    SunView *_sunsetView;
}
@end
@implementation SunInfoView
-(void)buildView{
    // 创建标题视图
    _titleLablel = [[MoveTitleLabel alloc]initWithFrame:ScaleRectMake(20, 10, 0, 0)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                      initWithString:NSLocalizedString(@"SSSRViewTitle", @"Sunrize/Sunset")
                                      attributes:@{
                                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:MOD(19)],
                                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.3 alpha:1.0f]
                                                   }];
    _titleLablel.attributedTitle = str;
    _titleLablel.startOffset = ScalePointMake(-30,0);
    _titleLablel.endOffset = ScalePointMake(30, 0);
    [self addSubview:_titleLablel];
    [_titleLablel buildView];
    
    // 初始化sunrize view.
    _sunrizeView = [SunView sunViewWithFrame:ScaleRectMake(50, 55, 50, 100) Stype:SunStypeSunRize];
    [self addSubview:_sunrizeView];
    [_sunrizeView buildView];
    
    // 初始化sunset view.
    _sunsetView = [SunView sunViewWithFrame:ScaleRectMake(110, 60, 50, 100) Stype:SunStypeSunSet];
    [self addSubview:_sunsetView];
    [_sunsetView buildView];

    
}

-(void)setSunrizeAndSunset:(SunrizeAndSunset *)sunrizeAndSunset{
    _sunrizeAndSunset = sunrizeAndSunset;

    if (_sunrizeAndSunset) {
        _sunrizeView.sunrizeSunsetTime = _sunrizeAndSunset.sunrize;
        _sunsetView.sunrizeSunsetTime = _sunrizeAndSunset.sunset;
    }
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_titleLablel  showByDuration:duration delay:delay];
    [_sunrizeView showByDuration:duration delay:delay];
    [_sunsetView showByDuration:duration delay:delay];
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_titleLablel hideByDuration:duration delay:delay];
    [_sunsetView hideByDuration:duration delay:delay];
    [_sunrizeView hideByDuration:duration delay:delay];
    
}
@end
