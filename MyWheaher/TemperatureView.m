//
//  TemperatureView.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/26.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "TemperatureView.h"
#import "UIColor+CustomColor.h"
#import "MoveTitleLabel.h"
#import "AddedFont.h"


@interface TemperatureView () 
@property(nonatomic,strong) NumberView *numberView;
@property(nonatomic,strong) MoveTitleLabel *titleLabel;
@end
@implementation TemperatureView
@dynamic delegate;
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)buildView{
    // create titleLabel
    self.titleLabel = [[MoveTitleLabel alloc]initWithFrame:ScaleRectMake(20, 10, 0, 0)];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]
                                      initWithString:NSLocalizedString(@"TemperatureViewTitle", @"Temperature")
                                      attributes:@{
                                                   NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:MOD(19)],
                                                   NSForegroundColorAttributeName: [UIColor colorWithWhite:0.3 alpha:1.0f]
                                                   }];
    self.titleLabel.attributedTitle = str;
    self.titleLabel.startOffset = ScalePointMake(-30,0);
    self.titleLabel.endOffset = ScalePointMake(30, 0);
    [self addSubview:self.titleLabel];
    [self.titleLabel buildView];

    // create numberView;
    [self createNumberView];

    
    
}

-(void)createNumberView{
    self.numberView = [[NumberView alloc]initWithNumber:[self.temperature floatValue]];
    //self.numberView.translatesAutoresizingMaskIntoConstraints = NO;
    //self.numberView.AdjustNumberSize = YES;
    self.numberView.frame = ScaleRectMake(23.5, 43.5, 160, 140);

    self.numberView.delegate  = self;

    [self addSubview:self.numberView];

    
    [self.numberView buildView];
    
}
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [self.numberView showByDuration:duration delay:delay];
    [self.titleLabel showByDuration:duration delay:delay];
    
    self.alpha = 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 1.0f;
    }];
    [super showByDuration:duration delay:delay];
}

-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    [self.numberView hideByDuration:duration delay:delay];
    [self.titleLabel hideByDuration:duration delay:delay];
    
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    }];
    [super hideByDuration:duration delay:delay];
}
#pragma mark - NumberViewDelegate
-(NSAttributedString *)NumberView:(NumberView *)numberView accessNumber:(CGFloat)number{
    NSString *str = [NSString stringWithFormat:@"%2lu˚",(unsigned long)number];

    NSRange range = [str rangeOfString:str];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    [string addAttributes:@{
                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:MOD(100)],
                            NSForegroundColorAttributeName:[UIColor CustomBlueColor]
                            }
                    range:range];
    
     
    return string;
}

-(void)setTemperature:(NSNumber *)temperature{
    _temperature = temperature;
    if (_temperature) {
        _numberView.number  = [_temperature floatValue];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
