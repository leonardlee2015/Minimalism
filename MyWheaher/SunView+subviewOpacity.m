//
//  SunView+subviewOpacity.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/13.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "SunView+subviewOpacity.h"

@implementation SunView (subviewOpacity)
-(void)opaqueSunMoonView{
    _sunImageView.alpha = 1.f;
    _moonImageView.alpha = 1.f;
}
-(void)opaqueTimeSeparatorView{
    _timeLabel.alpha = 1.f;
    _separatorLine.alpha = 1.f;
}

-(void)transparentizeSunMoonView{
    _sunImageView.alpha = 0.f;
    _moonImageView.alpha = 0.f;
}

-(void)transparentizeTimeSeparatorView{
    _separatorLine.alpha = 0.f;
    _timeLabel.alpha = 0.f;
}
@end
