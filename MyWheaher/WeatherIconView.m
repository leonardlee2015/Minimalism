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
    UIImageView *_coudIconView;
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
                                      initWithString:NSLocalizedString(@"WeatherIconVTitle", @"Weather")
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

    _coudIconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"100"]];
    _coudIconView.contentMode = UIViewContentModeScaleAspectFill;
    _coudIconView.frame  = ScaleRectMake(0, 0, 110, 110);
    _coudIconView.center = _upLabel.center;
    _coudIconView.x = _coudIconView.x - MOD(10);
    _coudIconView.y = _coudIconView.y - MOD(10);

    _coudIconView.alpha = 0.f;


    if (isUsingHeWeatherData) {
        [self addSubview:_coudIconView];

    }else{

        [self addSubview:_upLabel];


    }

    
    
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{

    [_titleLabel hideByDuration:duration delay:delay ];

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        _coudIconView.alpha  = 0.f;
        _upLabel.alpha = 0.f;
    } completion:nil];

    [_upLabel pop_removeAllAnimations];
    [_coudIconView pop_removeAllAnimations];
    
    [super hideByDuration:duration delay:delay];
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{

    [_titleLabel showByDuration:duration delay:delay];

    _upLabel.alpha = 0.f;
    _coudIconView.alpha = 0.f;

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        _upLabel.alpha = 1.f;
        _coudIconView.alpha = 1.f;
    } completion:nil];

    if (_flash) {
        if (isUsingHeWeatherData) {
            POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
            anim.duration =    2.f;
            anim.autoreverses = YES;
            anim.repeatForever = YES;
            anim.fromValue = @(0.75f);
            anim.toValue = @(0.f);
            [_coudIconView pop_addAnimation:anim forKey:nil];


        }else{
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

        }


    [super showByDuration:duration delay:delay];
}

-(void)setWheatherCode:(NSNumber*)wheatherCode{
    _wheatherCode = wheatherCode;
    if (_wheatherCode) {
        if (isUsingHeWeatherData) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",wheatherCode]];
            image = [image imageWithGradientTintColor:[WeatherNumberMeaningTransform heIconColor:wheatherCode]];
            
            _coudIconView.image = image;
            _flash = [WeatherNumberMeaningTransform flashFlagByWeatherCode:wheatherCode];


        }else{

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
}

-(CGFloat)scaleConst{
    return self.width/ 207;
}
@end
