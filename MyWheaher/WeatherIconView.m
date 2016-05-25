//
//  WheatherIconView.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/18.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "WeatherIconView.h"
#import "MoveTitleLabel.h"
#import "WheatherViewAnimationState.h"
#import "WeatherNumberMeaningTransform.h"
#import "Categories.h"
#import "AddedFont.h"
#import <pop/POP.h>


@interface WeatherIconView (){
    
    MoveTitleLabel *_titleLabel;
    UILabel *_upLabel;
    UILabel *_downLabel;
    BOOL _flash;
}
@property(nonnull,copy,nonatomic) NSString *weatherText;
@property(nonatomic,nonnull,strong) UIColor *upColor;
@property(nonnull,nonatomic,strong) UIColor *downColor;
@end
@implementation WeatherIconView
-(void)buildView{
    //self.backgroundColor = [UIColor blackColor];
    _titleLabel = [[MoveTitleLabel alloc]initWithFrame:ScaleRectMake(20, 10, 0, 0)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                      initWithString:@"Weather"
                                      attributes:@{
                                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:MOD(19)],
                                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.3 alpha:1.0f]
                                                   }];
    _titleLabel.attributedTitle = str;
    _titleLabel.startOffset = ScalePointMake(-30,0);
    _titleLabel.endOffset = ScalePointMake(30, 0);
    [self addSubview:_titleLabel];
    [_titleLabel buildView];
    
    _upLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(8, 14, 207, 207)];
    _upLabel.font = [UIFont fontWithName:WEATHER_TIME size:MOD(110)];
    _upLabel.text = self.weatherText;
    _upLabel.textColor = self.upColor;
    _upLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_upLabel];
    
    
    
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{

    [_titleLabel hideByDuration:duration delay:delay ];

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        _upLabel.alpha = 0.f;
    } completion:nil];

    [_upLabel pop_removeAllAnimations];
    
    [super hideByDuration:duration delay:delay];
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{

    [_titleLabel showByDuration:duration delay:delay];

    _upLabel.alpha = 0.f;
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        _upLabel.alpha = 1.f;
    } completion:nil];

    if (_flash) {
        //POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLabelTextColor];
        anim.duration = 2.f;
        anim.autoreverses = YES;
        anim.repeatForever = YES;

        anim.fromValue = [UIColor clearColor];
        anim.toValue = _upLabel.textColor;
        //anim.fromValue = @1.f;
        //anim.toValue = @0.f;

        [_upLabel pop_addAnimation:anim forKey:nil];
    }

    [super showByDuration:duration delay:delay];
}

-(void)setWheatherCode:(NSNumber*)wheatherCode{
    _wheatherCode = wheatherCode;
    if (_wheatherCode) {
        NSString *wheatherStr = [WeatherNumberMeaningTransform fontTextWeatherNumber:_wheatherCode];
        _upLabel.text = wheatherStr;
        _downLabel.text = wheatherStr;
        
        UIColor *color = [WeatherNumberMeaningTransform iconColor:_wheatherCode];
        _upLabel.textColor = color;
        
        
        if ([color isEqualColor:[UIColor redColor]] ) {
            _flash = YES;
        }
        
    }
}

-(CGFloat)scaleConst{
    return self.width/ 207;
}
@end
