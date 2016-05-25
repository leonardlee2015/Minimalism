//
//  VSeparatorLine.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "VSeparatorLine.h"

@interface VSeparatorLine (){
    CGFloat _interHeight;
}

@end

@implementation VSeparatorLine
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.f;
        _interHeight = self.height;
        self.height = 0.f;
        self.backgroundColor  = [UIColor blackColor];
    }
    return self;
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    self.alpha = 0.f;
    self.height = 0.f;

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.1f;
        self.height = _interHeight;

    } completion:^(BOOL finished) {
        if (!finished) {
            self.alpha = 0.f;
            self.height = 0.f;
        }
    }];

}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{

    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.f;
        self.height = 0.f;

    } completion:^(BOOL finished) {
        if (!finished) {
            self.alpha = 0.1f;
            self.height = _interHeight;
        }
    }];
}
@end
