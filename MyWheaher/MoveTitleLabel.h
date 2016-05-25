//
//  MoveTitleLabel.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/23.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"


@interface MoveTitleLabel : BaseWheatherView

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSAttributedString *attributedTitle;
@property (nonatomic,strong) UIFont *font;

@property (nonatomic) CGPoint startOffset;
@property (nonatomic) CGPoint endOffset;
@end
