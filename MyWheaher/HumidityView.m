//
//  HumidityView.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/16.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "HumidityView.h"
#import "UIColor+CustomColor.h"
#import "UIView+SetRect.h"
#import "CycleView.h"
#import "NumberView.h"
#import "MoveTitleLabel.h"

@interface HumidityView ()<NumberViewDelegate>

@end
@implementation HumidityView{
    CycleView *_cycleView;
    NumberView * _numberView;
    MoveTitleLabel *_titleView;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        if (frame.size.width != frame.size.height) {
            self = nil;
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"view width must equal its height " userInfo:nil];
            

            
        }
    }
    return self;
}


-(void)buildView{
    _cycleView = [[CycleView alloc]initWithFrame:ScaleRectMake(45, 55, 115, 115)];
    _cycleView.percent = self.Humidity?self.Humidity:60;
    [self addSubview:_cycleView];
    [_cycleView buildView];
    
    _numberView = [[NumberView alloc] initWithFrame:ScaleRectMake(35, 55, 138, 138)];
    _numberView.number = self.Humidity?self.Humidity:60;
    _numberView.delegate = self;
  
    [self addSubview:_numberView];
    [_numberView buildView];
    
    _titleView = [[MoveTitleLabel alloc] initWithFrame:ScaleRectMake(20, 10, 0,0)];
    _titleView.title = NSLocalizedString(@"HumidityViewTitle", @"Humidity");
    _titleView.font = [UIFont fontWithName:@"Avenir-Light" size:MOD(20)];
    _titleView.startOffset = ScalePointMake(-30, 0);
    _titleView.endOffset = ScalePointMake(30, 0);
    [self addSubview:_titleView ];
    [_titleView buildView];
    
}


-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_cycleView showByDuration:duration delay:delay];
    [_numberView showByDuration:duration delay:delay];
    [_titleView showByDuration:duration delay:delay];
    
    [super showByDuration:duration delay:delay];
}


-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_cycleView hideByDuration:duration delay:delay];
    [_numberView hideByDuration:duration delay:delay];
    [_titleView hideByDuration:duration delay:delay];
    
    [super hideByDuration:duration delay:delay];
}
#pragma mark - properties
-(void)setHumidity:(CGFloat)Humidity{
    _Humidity = Humidity;
    _cycleView.percent = Humidity;
    _numberView.number = Humidity;

}

#pragma mark - NumberViewDelegate
-(NSAttributedString*)NumberView:(NumberView*)numberView accessNumber:(CGFloat)number{
    NSString *numberStr = [NSString stringWithFormat:@"%2lu",(unsigned long)number];
    NSString *totalStr = [NSString stringWithFormat:@"%@%%",numberStr];
    
    NSRange numberRange = [totalStr rangeOfString:numberStr];
    NSRange PerRange = [totalStr rangeOfString:@"%"];
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString  alloc]initWithString:totalStr];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
    paragraph.alignment = NSTextAlignmentCenter;
    [AttributedStr addAttributes:@{
                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:40],
                                   NSForegroundColorAttributeName:[UIColor blackColor],
                                   NSBaselineOffsetAttributeName: @(10),
                                   NSParagraphStyleAttributeName:paragraph
                                   }
                           range:numberRange];
    [AttributedStr addAttributes:@{
                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir" size:19],
                                   NSForegroundColorAttributeName:[UIColor colorWithWhite:0.4 alpha:1],
                                   //NSBaselineOffsetAttributeName: @(10),
                                   NSParagraphStyleAttributeName:paragraph,
                                   }
                           range:PerRange];
    
    return AttributedStr;
}
-(void)additionShowAnimationToView:(UIView *)view byDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay{
    if (view == _numberView) {
        view.transform = CGAffineTransformMakeScale(1.2, 1.2);
        [UIView animateWithDuration:duration
                         animations:^{
                             view.transform = CGAffineTransformIdentity;
                         }];
    }
}

-(void)additionHideAnimationToView:(UIView *)view byDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay{
    if (view == _numberView) {
        CGAffineTransform transform = self.transform;
        [UIView animateWithDuration:duration
                         animations:^{
                             view.transform = CGAffineTransformMakeScale(1.2, 1.2);
                         } completion:^(BOOL finished) {
                             view.transform = transform;
                         }];
    }
}
@end
