//
//  LineBackgroundView.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LineBackgroundView : UIView

@property (nonatomic) CGFloat            lineWidth;
@property (nonatomic) CGFloat            lineGap;
@property (nonatomic, strong) UIColor   *lineColor;

- (void)buildView;
+ (instancetype)createViewWithFrame:(CGRect)frame
                          LineWidth:(CGFloat)width
                            lineGap:(CGFloat)lineGap
                          lineColor:(UIColor *)color;

@end
