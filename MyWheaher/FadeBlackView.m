//
//  FadeBlackView.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "FadeBlackView.h"
#import "Categories.h"

@implementation FadeBlackView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha           = 0.f;
    }
    
    return self;
}

- (void)show {
    
    [UIView animateWithDuration:1.f animations:^{
        
        self.alpha = 0.75f;
    }];
}

- (void)hide {
    
    [UIView animateWithDuration:0.75f animations:^{
        
        self.alpha = 0.f;
    }];
}

@end
