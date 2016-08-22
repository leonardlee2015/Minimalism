//
//  WeatherViewPageControl.m
//  MyWheaher
//
//  Created by  Leonard on 16/7/28.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "WeatherViewPageControl.h"

@implementation WeatherViewPageControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)layoutSubviews{
    [super layoutSubviews];

    //  新建一个指sh
    UIView *firstDot = self.subviews[0];
    CGRect firstDotRect =  firstDot.frame;

    UIImage *locationImage = [UIImage imageNamed:@"Location" size:firstDotRect.size];
    UIImageView *LocationView = [[UIImageView alloc]initWithImage:locationImage];
    LocationView.frame  = firstDotRect;

    [firstDot removeFromSuperview];
    [self insertSubview:LocationView atIndex:0];




}

@end