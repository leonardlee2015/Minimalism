//
//  sunView.m
//  WheatherAppTest
//
//  Created by 李南 on 16/3/28.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "SunView.h"
#import "SunSetView.h"
#import "SunRizeView.h"
#import "Categories.h"
#import "AddedFont.h"

@implementation SunView
+(SunView *)sunViewWithFrame:(CGRect)frame Stype:(SunStype)sunstype{
    SunView *sunView;
    
    switch (sunstype) {
        case SunStypeSunSet:{
            sunView = [[SunRizeView alloc]initWithFrame:frame];
            break;
        }
        case SunStypeSunRize:{
            sunView = [[SunSetView alloc] initWithFrame:frame];
            break;
        }

            
        default:{
            sunView = nil;
            break;
        }
    }
    
    return sunView;
}
-(instancetype)init{
    NSString *reason = @"you must create by [sunViewWithFrame:Stype:] instead of";
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
}

-(instancetype)initWithFrame:(CGRect)frame{
    [self checkSizeWithFrame:frame];
    
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat width = frame.size.width;
        _width = width;
        
        _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,width, width)];
        _upView.backgroundColor = [UIColor clearColor];
        _upView.clipsToBounds = YES;
        [self addSubview:_upView];
        
        _downView = [[UIView alloc]initWithFrame:CGRectMake(0, width, width, width)];
        _downView.backgroundColor = [UIColor clearColor];
        _downView.clipsToBounds = YES;
        [self addSubview:_downView];
        
        _separatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, width-0.5, width, 1)];
        _separatorLine.backgroundColor = [UIColor blackColor];
        _separatorLine.alpha = 0.f;
        _separatorLine.center = self.boundsCenter;
        [self addSubview:_separatorLine];
        
        CGSize size = CGSizeMake(width, width);
        
        UIImage *sunImage = [UIImage imageNamed:@"sun" size:size];
        _sunImageView = [[UIImageView alloc]initWithImage:sunImage];
        [_upView addSubview:_sunImageView];
        
        UIImage *moonImage = [UIImage imageNamed:@"moon" size:size];
        _moonImageView = [[UIImageView alloc]initWithImage:moonImage];
        [_downView addSubview:_moonImageView];
        
        _timeLabel = [[UILabel alloc]initWithFrame:ScaleRectMake(0, 0, 50, 25)];
        _timeLabel.text = @"10:40";
        _timeLabel.font = [UIFont fontWithName:@"Lato-Bold" size:MOD(10)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.alpha = 0.f;
        [self addSubview:_timeLabel];
        
        
        
        
        
    }
    return  self;
}

-(void)setSunrizeSunsetTime:(NSDate *)sunrizeSunsetTime{
    _sunrizeSunsetTime = sunrizeSunsetTime;

    if (_sunrizeSunsetTime) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.locale = [NSLocale currentLocale];
        formatter.dateFormat = @"hh:mm";

        _timeLabel.text = [formatter stringFromDate:_sunrizeSunsetTime];
    }
}

-(void)checkSizeWithFrame:(CGRect)frame{
    if ((2*CGRectGetWidth(frame)) != CGRectGetHeight(frame)) {
        NSString *msg = @"wrong frame for create sunView, the frame's Height be two times of width.";
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:msg userInfo:nil];
 
    }

}

-(CGFloat)scaleConst{
    return self.width / 50;
}

@end

