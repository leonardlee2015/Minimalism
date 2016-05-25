//
//  SunRizeView.m
//  WheatherAppTest
//
//  Created by 李南 on 16/3/29.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "SunRizeView.h"
#import "SunView+subviewOpacity.h"

@interface SunRizeView ()

@end

@implementation SunRizeView
-(void)buildView{
    
    
    [self transparentizeTimeSeparatorView];
    [self transparentizeSunMoonView];
    [self resetSunMoonViewLocation];
    _timeLabel.origin = ScalePointMake(0, 50);
    _timeLabel.centerX = self.boundsCenter.x;
    
    
}

-(void)resetSunMoonViewLocation{
    _sunImageView.y = _width;
    _moonImageView.y =  0;

}
-(void)setSunMoonViewShowedLocation{
    _sunImageView.y = 0;
    _moonImageView.y = - _width;
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [self opaqueSunMoonView];
    [self transparentizeTimeSeparatorView];
    [self resetSunMoonViewLocation];
    
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self setSunMoonViewShowedLocation];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self opaqueTimeSeparatorView];
        }
    }];

    
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [self transparentizeTimeSeparatorView];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self resetSunMoonViewLocation];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self transparentizeSunMoonView];
        }
    }];
}
@end
