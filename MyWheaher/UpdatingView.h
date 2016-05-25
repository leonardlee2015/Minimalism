//
//  UpdatingView.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SnowView.h"
#import "UIView+GlowView.h"
#import "UIView+SetRect.h"
#import "CALayer+MaskLayer.h"

@interface UpdatingView : UIView

- (void)insertIntoView:(UIView *)view;

- (void)show;
- (void)hide;
- (void)showFailed;

@end
