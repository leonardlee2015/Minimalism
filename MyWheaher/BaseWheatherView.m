//
//  WheatherView.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/16.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"
#import "UIView+SetRect.h"
#import "WheatherViewAnimationState.h"
@implementation BaseWheatherView
@dynamic scaleConst;
-(CGFloat)scaleConst{
        //return self.width/187.5;
    return self.width/207;
}
-(void)buildView{
    NSString *msg = @"this is a virtual class ,you should not use this class immediately! ";
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:msg userInfo:nil];
    
    
    
}
-(void)show{

    [self showByDuration:SHOW_DURATION delay:0.f];
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(additionShowAnimationToView:byDuration:delay:)]) {
        [self.delegate additionShowAnimationToView:self byDuration:duration delay:delay];
        
        
    }
}
-(void)hide{
    [self hideByDuration:HIDE_DURATION delay:0];
}
-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    if (self.delegate && [self.delegate respondsToSelector:@selector(additionHideAnimationToView:byDuration:delay:)]) {
        [self.delegate additionHideAnimationToView:self byDuration:duration delay:delay];
    }
}
-(void)checkSizeWithFrame:(CGRect)frame{
    if (CGRectGetHeight(frame) != CGRectGetWidth(frame)) {
        NSString *msg = [NSString stringWithFormat:@"%@'s width must equal its height", NSStringFromClass([self class])];
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:msg userInfo:nil];
    }
}
-(void)setUITestOn:(BOOL)UITestOn{
    _UITestOn = UITestOn;
    
    if (_UITestOn) {
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 2.f;
    }else{
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.layer.borderWidth = 0;
    }
}

-(void)ToAnimationEndState{
    
}
-(void)ToAnimationMidState{
    
}
-(void)ToAnimationStartState{
    
}


-(void)MoveWithMidRect:(CGRect)rect startOffsetP:(CGPoint)startOffset endOffsetP:(CGPoint)endOffset WithAnimationState:(nonnull WheatherViewAnimationState*)state{
    state.midState = [NSValue valueWithCGRect:rect];
    
    CGRect startRect = rect;
    startRect.origin.x += startOffset.x;
    startRect.origin.y += startOffset.y;
    state.startState = [NSValue valueWithCGRect:startRect];
    
    rect.origin.x += endOffset.x;
    rect.origin.y += endOffset.y;
    
    state.endState = [NSValue valueWithCGRect:rect];
    
}
@end
