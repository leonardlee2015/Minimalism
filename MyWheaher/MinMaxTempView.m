//
//  MinMaxTempView.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "MinMaxTempView.h"
#import "MoveTitleLabel.h"
#import "NumberView.h"
#import "GridView.h"
#import "AddedFont.h"
#import "WheatherViewAnimationState.h"
#import "Categories.h"

@interface MinMaxTempView ()<NumberViewDelegate>{
    @private
    MoveTitleLabel *_titleLabel;
    NumberView *_minNumView;
    WheatherViewAnimationState *_minNumViewState;
    
    NumberView *_maxNumView;
    WheatherViewAnimationState *_maxNumViewState;
    
    
    UIView *_minRectView;
    WheatherViewAnimationState *_minRectViewState;
    
    UIView *_maxRectView;
    WheatherViewAnimationState *_maxRectViewState;
    
    UIView *_separatorLine;
    WheatherViewAnimationState *_separatorLineState;
    
    GridView *_gridView;
    
    CGFloat _gridWidth;
}
@end

@implementation MinMaxTempView
#pragma mark - SuperClass Methods.
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _maxRectViewState = [WheatherViewAnimationState new];
        _minRectViewState = [WheatherViewAnimationState new];
        _minNumViewState = [WheatherViewAnimationState new];
        _maxNumViewState = [WheatherViewAnimationState new];
        _separatorLineState = [WheatherViewAnimationState new];
    }
    return self;
}
-(void)buildView{
    // 标题视图
    _titleLabel = [[MoveTitleLabel alloc]initWithFrame:ScaleRectMake(20, 10, 0, 0)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                      initWithString:@"Min/Max Temp"
                                      attributes:@{
                                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:MOD(19)],
                                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.3 alpha:1.0f]
                                                   }];
    _titleLabel.attributedTitle = str;
    _titleLabel.startOffset = ScalePointMake(-30,0);
    _titleLabel.endOffset = ScalePointMake(30, 0);
    [self addSubview:_titleLabel];
    [_titleLabel buildView];
    
    //创建container View.
    UIView *containerView = [[UIView alloc]initWithFrame:ScaleRectMake(30, 53, 180, 150)];
    containerView.clipsToBounds = YES;
    [self addSubview:containerView];
    
    // 设置gridwidth;
    CGFloat gridWidth = 30;
    _gridWidth = gridWidth;
    
    //创建_gridView;
    _gridView = [[GridView alloc]initWithFrame:ScaleRectMake(0, 0, 180, 150)];
    _gridView.spaceWidth = MOD(gridWidth);
    [_gridView buildView];
    [containerView addSubview:_gridView];
    _gridView.alpha = 0.f;
    
    //创建 max Rect View;
    _maxRectView = [[UIView alloc]initWithFrame:ScaleRectMake(gridWidth*3, gridWidth*2, gridWidth, 0)];
    _maxRectView.backgroundColor = [UIColor blackColor];
    _maxRectView.alpha = 0.f;
    [containerView addSubview:_maxRectView];

    _maxRectViewState.startState = [NSValue valueWithCGRect:_maxRectView.frame];
    _maxRectViewState.endState = [NSValue valueWithCGRect:_maxRectView.frame];
    _maxRectViewState.midState = [NSValue valueWithCGRect:_maxRectView.frame];
    
    //创建 min Rect View;
    _minRectView = [[UIView alloc]initWithFrame:ScaleRectMake(gridWidth, gridWidth*2, gridWidth, 0)];
    _minRectView.backgroundColor = [UIColor blackColor];
    _minRectView.alpha = 0.f;
    [containerView addSubview:_minRectView];
    
    _minRectViewState.startState = [NSValue valueWithCGRect:_minRectView.frame];
    _minRectViewState.endState = [NSValue valueWithCGRect:_minRectView.frame];
    _minRectViewState.midState = [NSValue valueWithCGRect:_minRectView.frame];

    
    // 创建 min temp view.
    _minNumView = [[NumberView alloc]initWithNumber:self.minTemp];
    _minNumView.delegate = self;
    _minNumView.frame = ScaleRectMake(gridWidth, gridWidth, gridWidth, gridWidth);
    _minNumView.alpha = 0.f;
    [_minNumView buildView];
    [containerView addSubview:_minNumView];
    
    _minNumViewState.startState = [NSValue valueWithCGRect:_minNumView.frame];
    _minNumViewState.endState = [NSValue valueWithCGRect:_minNumView.frame];
    _minNumViewState.midState = [NSValue valueWithCGRect:_minNumView.frame];

    
    // 创建 min temp view.
    _maxNumView = [[NumberView alloc]initWithNumber:self.maxTemp];
    _maxNumView.delegate = self;
    _maxNumView.frame = ScaleRectMake(gridWidth*3, gridWidth, gridWidth, gridWidth);
    _maxNumView.alpha = 0.f;
    [_maxNumView buildView];
    [containerView addSubview:_maxNumView];
    
    _maxNumViewState.startState = [NSValue valueWithCGRect:_maxNumView.frame];
    _maxNumViewState.endState = [NSValue valueWithCGRect:_maxNumView.frame];
    _maxNumViewState.midState = [NSValue valueWithCGRect:_maxNumView.frame];
    
    //创建 中间分割线
    _separatorLine = [[UIView alloc]initWithFrame:ScaleRectMake(0, 60, gridWidth*5, 1)];
    _separatorLine.backgroundColor = [UIColor blackColor];
    _separatorLine.alpha = 0.f;
    [containerView addSubview:_separatorLine];
    
    _separatorLineState.midState = [NSValue valueWithCGRect:_separatorLine.frame];
    
    _separatorLine.width = 0.f;
    _separatorLineState.startState = [NSValue valueWithCGRect:_separatorLine.frame];
    _separatorLineState.endState = [NSValue valueWithCGRect:_separatorLine.frame];
    
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_titleLabel showByDuration:duration delay:delay];
    [_gridView showByDuration:duration delay:delay   ];
    [_minNumView showByDuration:duration delay:delay];
    [_maxNumView showByDuration:duration delay:delay];
    
    [self ToAnimationStartState];
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self ToAnimationMidState];
    } completion:^(BOOL finished) {
        if (!finished) {
            [self ToAnimationEndState];
        }
    }];
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [_titleLabel hideByDuration:duration delay:delay];
    [_gridView hideByDuration:duration delay:delay];
    [_maxNumView hideByDuration:duration delay:delay];
    [_minNumView hideByDuration:duration delay:delay];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        [self ToAnimationEndState];
    } completion:^(BOOL finished) {
        if (!finished) {
            [self ToAnimationMidState];
        }
    }];
}

-(void)ToAnimationStartState{
    _separatorLine.alpha = 0.f;
    _separatorLine.frame = [_separatorLineState CGRectStartState];
    
    _maxNumView.alpha = 0.5f;
    _maxNumView.frame = [_maxNumViewState CGRectStartState];
    
    _minNumView.alpha = 0.5f;
    _minNumView.frame = [_minNumViewState CGRectStartState];
    
    _maxRectView.alpha = 0.f;
    _maxRectView.frame = [_maxRectViewState CGRectStartState];
    
    _minRectView.alpha  = 0.f;
    _minRectView.frame = [_minRectViewState CGRectStartState];
    
    _gridView.alpha = 0.f;
    
}

-(void)ToAnimationMidState{
    _separatorLine.alpha = 1.f;
    _separatorLine.frame = [_separatorLineState CGRectMidState];
    
    _maxNumView.alpha = 1.f;
    _maxNumView.frame = [_maxNumViewState CGRectMidState];
    
    _minNumView.alpha = 1.f;
    _minNumView.frame = [_minNumViewState CGRectMidState];
    
    _maxRectView.alpha = 1.f;
    _maxRectView.frame = [_maxRectViewState CGRectMidState];
    
    _minRectView.alpha  = 1.f;
    _minRectView.frame = [_minRectViewState CGRectMidState];

        _gridView.alpha = 1.f;
}

-(void)ToAnimationEndState{
    _separatorLine.alpha = 0.f;
    _separatorLine.frame = [_separatorLineState CGRectEndState];

    _maxNumView.alpha = 0.0f;
    _maxNumView.frame = [_maxNumViewState CGRectEndState];
    
    _minNumView.alpha = 0.0f;
    _minNumView.frame = [_minNumViewState CGRectEndState];
    
    _maxRectView.alpha = 0.f;
    _maxRectView.frame = [_maxRectViewState CGRectEndState];
    
    _minRectView.alpha  = 0.f;
    _minRectView.frame = [_minRectViewState CGRectEndState];
    
        _gridView.alpha = 0.f;
}
#pragma mark - Properties
-(void)setMinTemp:(CGFloat)minTemp{
    _minTemp = minTemp;
    _minNumView.number = _minTemp;
    // 根据温度挑战minRect和minNum的动画状态保存器。
    if (_minTemp >=0) {
        _minNumViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth, _gridWidth-_minTemp, _gridWidth, _gridWidth)];
        _minRectViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth,_gridWidth*2 - _minTemp, _gridWidth, _minTemp)];
    }else{
        
        _minNumViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth, _gridWidth*2+ fabs(_minTemp), _gridWidth, _gridWidth)];
        _minNumViewState.startState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth, _gridWidth*2, _gridWidth, _gridWidth)];
        _minNumViewState.endState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth, _gridWidth*2, _gridWidth, _gridWidth)];
        
        _minRectViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth,_gridWidth*2, _gridWidth, fabs(_minTemp))];
        
    }
}

-(void)setMaxTemp:(CGFloat)maxTemp{
    _maxTemp = maxTemp;
    _maxNumView.number = _maxTemp;
    // 根据温度挑战maxRect和maxNum的动画状态保存器。
    if (_maxTemp >=0) {
        _maxNumViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth*3, _gridWidth-_maxTemp, _gridWidth, _gridWidth)];
        _maxRectViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth*3,_gridWidth*2 - _maxTemp, _gridWidth, _maxTemp)];
    }else{
        
        _maxNumViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth*3, _gridWidth*2+ fabs(_maxTemp), _gridWidth, _gridWidth)];
        _maxNumViewState.startState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth*3, _gridWidth*2, _gridWidth, _gridWidth)];
        _maxNumViewState.endState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth*3, _gridWidth*2, _gridWidth, _gridWidth)];
        
        _maxRectViewState.midState = [NSValue valueWithCGRect:ScaleRectMake(_gridWidth*3,_gridWidth*2, _gridWidth, fabs(_maxTemp))];
        
    }
}
#pragma mark - NumberViewDelegate
-(NSAttributedString *)NumberView:(NumberView *)numberView accessNumber:(CGFloat)number{
    NSMutableAttributedString *str;
    
    NSString *numberStr = [NSString stringWithFormat:@"%ld˚",(long)number];
    if (_minNumView == numberView) {
        NSString *prefix = @"Min";
        NSString *totalStr = [NSString stringWithFormat:@"%@ %@", prefix, numberStr];
        
        NSRange prefixRange = [totalStr rangeOfString:prefix];
        NSRange numberRange = [totalStr rangeOfString:numberStr];
        
        str = [[NSMutableAttributedString alloc]initWithString:totalStr];
        [str setFont:[UIFont fontWithName:LATO_REGULAR size:12] range:numberRange];
        
        [str setFont:[UIFont fontWithName:LATO_BOLD size:8] range:prefixRange];
        
    }else if (_maxNumView == numberView){
        NSString *prefix = @"Max";
        NSString *totalStr = [NSString stringWithFormat:@"%@ %@", prefix, numberStr];
        
        NSRange prefixRange = [totalStr rangeOfString:prefix];
        NSRange numberRange = [totalStr rangeOfString:numberStr];
        
        str = [[NSMutableAttributedString alloc]initWithString:totalStr];
        [str setFont:[UIFont fontWithName:LATO_REGULAR size:12] range:numberRange];
        
        [str setFont:[UIFont fontWithName:LATO_BOLD size:8] range:prefixRange];
        
        
    }
    
    return [str copy];
}

-(CGFloat)scaleConst{
    return self.width/207.f;
}
@end
