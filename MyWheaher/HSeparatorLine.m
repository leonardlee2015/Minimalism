//
//  HSeparatorLine.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "HSeparatorLine.h"
#import "Categories.h"

@interface HSeparatorLine (){
    CGFloat _inetWidth;
}
@end
@implementation HSeparatorLine

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.alpha = 0.f;
        _inetWidth = self.width;
        self.backgroundColor = [UIColor blackColor];
    }
    return  self;
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    self.width = 0.f;
    self.alpha = 0.f;
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.1f;
        self.width = _inetWidth;
    } completion:^(BOOL finished) {
        if (!finished) {
            self.width = 0.f;
            self.alpha = 0.f;

        }
    }];

}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
        self.alpha = 0.f;
        self.width = 0.f;

    } completion:^(BOOL finished) {
        if (!finished) {
            self.alpha = 0.1f;
            self.width = _inetWidth;
        }
    }];
    
}

-(CGFloat)scaleConst{
    return 1;
}
@end
