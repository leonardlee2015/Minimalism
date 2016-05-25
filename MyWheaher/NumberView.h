//
//  numberView.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/21.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"
#import "NumberAnimation.h"
#import <UIKit/UIKit.h>

@class NumberView;
@protocol NumberViewDelegate <BaseWheatherViewDelegate>
@required
/**
 *  @brief  实现 数字的显示效果。
 *
 *  @param number 数字
 *
 *  @return 数字属性符串
 */
-(NSAttributedString*)NumberView:(NumberView*)numberView accessNumber:(CGFloat)number;

@end
@interface NumberView : BaseWheatherView

@property(nonatomic) CGFloat number;
@property(nonatomic,weak) id<NumberViewDelegate> delegate;
@property(nonatomic) BOOL AdjustNumberSize;
-(instancetype)initWithNumber:( CGFloat) number;
@end
