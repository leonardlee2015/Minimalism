//
//  numberView.m
//  WheatherAppTest
//
//  Created by 李南 on 15/9/21.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "NumberView.h"
#import "NumberAnimation.h"

#import <pop/POP.h>
#import <FLKAutoLayout/FLKAutoLayout.h>

@interface NumberView ()<NumberAnimationDelegate>
@property (nonatomic,strong) UILabel *numberLabel;
@property (nonatomic,strong) NumberAnimation *animation;
@end
@implementation NumberView

@dynamic delegate;

-(instancetype)initWithNumber:( CGFloat)number{
    self = [super init];
    if (self) {
        self.number = number;
       
        self.AdjustNumberSize = NO;
        
        
    }
    return self;
}




-(void)buildView{
    // preset view to transparent
    //self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    self.alpha = 0.0f;
    // size
    _numberLabel = [[UILabel alloc]init];
    
    //_numberLabel.backgroundColor = [UIColor greenColor];
    //self.numberLabel.textAlignment = NSTextAlignmentCenter;

    [self setNumberLabelNumber:self.number];

    //self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.numberLabel.textColor = [UIColor blackColor];
    
    [self addSubview:self.numberLabel];
#if 0
    self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *numberLabelDic = @{@"numberLabel":self.numberLabel};

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[numberLabel]|" options:0 metrics:nil views:numberLabelDic]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[numberLabel]|" options:0 metrics:nil views:numberLabelDic]];
    //
#endif

    [_numberLabel alignToView:self];
    //[self.numberLabel sizeToFit];
      //[self layoutIfNeeded];
    NSLog(@"%f,%f,%f,%f",_numberLabel.x,self.y,_numberLabel.width,_numberLabel.height);
 
    self.animation = [[NumberAnimation alloc]init];
    self.animation.delegate = self;
    
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _numberLabel.frame = self.bounds;
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{
    self.animation.fromValue = @(0);
    self.animation.toValue = @(self.number);
    self.animation.duration = duration;
    [self.animation startAnimation];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.alpha = 1.0f;
                        
                     }];
    [super showByDuration:duration delay:delay];
    
}
-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
   
    self.animation.fromValue = @(self.number);
    self.animation.toValue = @(0);
    self.animation.duration = duration;
    [self.animation startAnimation];
    [UIView animateWithDuration:duration
                     animations:^{
                         self.alpha = 0.0f;
                       
                     }];
    [super hideByDuration:duration delay:delay];
    
}

#pragma mark - NumberAnimationDelegate
-(void)animation:(NumberAnimation *)animation ByCurrentNumber:(CGFloat)number{
    [self setNumberLabelNumber:number];
}

-(void)setNumberLabelNumber:(CGFloat)number{
    if (self.delegate && [self.delegate respondsToSelector:@selector(NumberView:accessNumber:)]) {
        self.numberLabel.attributedText = [self.delegate NumberView:self accessNumber:number];

        [self setNeedsLayout];
        
        if (self.AdjustNumberSize) {
            self.size = [self.numberLabel sizeThatFits:self.numberLabel.size];
        }
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
