//
//  LeftCityInfoView.m
//  MyWheaher
//
//  Created by  Leonard on 16/8/2.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "LeftCityInfoView.h"
#import "WheatherViewAnimationState.h"
#import <FLKAutoLayout.h>
#import <pop/POP.h>

@interface LeftCityInfoView ()
@property(nonnull,strong,nonatomic)UIView *leftContainerView;
@property(nonatomic,nonnull,strong)UIButton *ItemCallButton;
@property(nonatomic,nonnull,readonly)NSMutableArray<UIButton*>* itemButtons;
@property(nonnull,nonatomic,strong)WheatherViewAnimationState *leftContainerViewState;
@property(nullable,nonatomic,strong)NSTimer *hideLeftViewTimer;
@end

@implementation LeftCityInfoView

-(void)buildView{
    self.backgroundColor = [UIColor clearColor];


    _ItemCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ItemCallButton.backgroundColor = [UIColor clearColor];
    _ItemCallButton.frame = self.bounds;

    [_ItemCallButton addTarget:self action:@selector(callButtonItemsOut:) forControlEvents:UIControlEventTouchUpInside];

    [self insertSubview:_ItemCallButton atIndex:0];

    // 初始化_leftContainerView
    _leftContainerView = [[UIView alloc]initWithFrame:self.bounds];
    _leftContainerView.backgroundColor = [UIColor blackColor];
    _leftContainerView.x = - (self.width - 5);

    [self addSubview:_leftContainerView];

    _leftContainerViewState = [WheatherViewAnimationState new];

    [self MoveWithMidRect:_leftContainerView.frame startOffsetP:CGPointMake(0, -5) endOffsetP:CGPointMake(0, 0) WithAnimationState:_leftContainerViewState];

    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragLeftView:)];
    [self addGestureRecognizer:gesture];


}

-(IBAction)dragLeftView:(nonnull UIPanGestureRecognizer*)sender{
    static BOOL enabled = NO;

    CGFloat showPosition = 0;
    CGFloat hidePosition = -self.width + 5;
    CGFloat maxAllowMoveSpace = self.width - 5;


    CGPoint  translation = [sender translationInView:self];

    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{

            for (UIView *view in self.leftContainerView.subviews) {
                view.hidden = NO;
            }

            if (
                !((_leftContainerView.x>=showPosition && translation.x > 0)||
                (_leftContainerView.x<=hidePosition && translation.x<0))
                ) {

                enabled = YES;

            }else{
                enabled = NO;
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (enabled) {

                _leftContainerView.x += translation.x;

                if (_leftContainerView.x > showPosition) {
                    _leftContainerView.x  = 0;
                }else if (_leftContainerView.x < hidePosition){
                    _leftContainerView.x = hidePosition;
                }
            }
            break;
        }
        default:{
            CGFloat leftPercent = (0 - self.leftContainerView.x) / maxAllowMoveSpace;
            if (leftPercent >= 0.5) {
                [self hidenLeftView];
            }else{
                [self showLeftView];
            }
            break;
        }

    }

}

-(void)addButtonItemWithImage:(UIImage *)image HeightLightImage:(UIImage *)heightLightImage backgroundColor:(UIColor*)color target:(id)target action:(SEL)selector{

    UIButton *itemButton;

    // 如果有heightLightImage初始化button为自定义类型，否则为系统类型。
    if (heightLightImage) {
        itemButton  = [UIButton buttonWithType:UIButtonTypeCustom];

        [itemButton setImage:heightLightImage forState:UIControlStateHighlighted];
    }else{
        itemButton = [UIButton buttonWithType:UIButtonTypeSystem];
    }

    [itemButton setImage:image forState:UIControlStateNormal];
    if (color) {
        itemButton.backgroundColor = color;

    }
    itemButton.hidden = YES;
    [itemButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    [self.itemButtons addObject:itemButton];

    [self layoutButtonItems];

}
-(void)layoutButtonItems{
    NSUInteger count = self.itemButtons.count;
    if (count > 0 ) {
        [self.leftContainerView removeConstraints:self.leftContainerView. constraints];
        for (UIButton *button in self.itemButtons) {
            [button removeConstraints:button.constraints];
        }
        for (UIButton *button in self.itemButtons) {
            [self.leftContainerView addSubview:button];

            [button alignTop:@"0" bottom:@"0" toView:self.leftContainerView];
        }

        [self.itemButtons.firstObject alignLeadingEdgeWithView:self.leftContainerView predicate:@"0"];
        [self.itemButtons.firstObject constrainWidth:[NSString stringWithFormat:@"%f",self.leftContainerView.width/count]];

        [self.itemButtons.lastObject alignTrailingEdgeWithView:self.leftContainerView predicate:@"0"];

        if (count >1) {

            [UIView spaceOutViewsHorizontally:self.itemButtons predicate:@"0"];
            [UIView equalWidthForViews:self.itemButtons];
        }


        [self.leftContainerView layoutIfNeeded];
    

    }
}
-(void)showLeftView{
    for (UIView *view in self.leftContainerView.subviews) {
        view.hidden = NO;
    }


    // 按钮弹出动画效果。
    CGFloat unfinishedPercent = (0 - self.leftContainerView.x) / (self.width - 5);

    

    [UIView animateWithDuration:0.75f* unfinishedPercent
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.leftContainerView.x = 0;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.ItemCallButton.hidden = YES;

                             [self startHideLeftViewTimer];


                         }else{
                             self.leftContainerView.x = -self.width +5;
                             self.ItemCallButton.hidden = NO;
                             for (UIView *view in self.leftContainerView.subviews) {
                                 view.hidden = YES;
                             }
                         }
                     }];

}
-(void)hideLeftViewimmediately{
    self.leftContainerView.x = -self.width +5;

    self.ItemCallButton.hidden = NO;
    for (UIView *view in self.leftContainerView.subviews) {
        view.hidden = YES;
    }

    [self.hideLeftViewTimer invalidate];

}
-(void)hidenLeftView{


    CGFloat unfinishedPercent = (self.leftContainerView.x - (- self.width+5)) / (self.width - 5);


    [UIView animateWithDuration:0.75f* unfinishedPercent
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.leftContainerView.x = -self.width +5;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             self.ItemCallButton.hidden = NO;
                             for (UIView *view in self.leftContainerView.subviews) {
                                 view.hidden = YES;
                             }

                             [self.hideLeftViewTimer invalidate];

                         }else{
                             self.leftContainerView.x = 0;
                             self.ItemCallButton.hidden = YES;
                             for (UIView *view in self.leftContainerView.subviews) {
                                 view.hidden = NO;
                             }
                         }


                     }];

}
-(void)startHideLeftViewTimer{

    [self.hideLeftViewTimer invalidate];
    self.hideLeftViewTimer =  nil;
    self.hideLeftViewTimer = [NSTimer
                              scheduledTimerWithTimeInterval:5.f
                              target:self
                              selector:@selector(hidenLeftView) userInfo:nil
                              repeats:NO];


}
-(IBAction)callButtonItemsOut:(id)sender{
    [self showLeftView];
}


-(void)hideButtunItems:(BOOL)animated{
    if (animated) {
        [self hidenLeftView];
    }else{
        [self hideLeftViewimmediately];
    }
}

-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay{

    self.leftContainerView.frame = [_leftContainerViewState.startState CGRectValue];
    self.alpha = 0;
    [UIView animateWithDuration:duration
                          delay:delay \
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.leftContainerView.frame = [_leftContainerViewState.midState CGRectValue];
                         self.alpha = 1;
                     } completion:nil];
}
-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay{
    self.leftContainerView.x = -self.width + 5;
    self.alpha = 1;
    [UIView animateWithDuration:duration
                          delay:delay
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         self.leftContainerView.frame = [_leftContainerViewState.endState CGRectValue];
                         self.alpha = 0;
                     } completion:nil];

}
@synthesize itemButtons = _itemButtons;

-(NSMutableArray<UIButton *> *)itemButtons{
    if (!_itemButtons) {
        _itemButtons = [NSMutableArray arrayWithCapacity:2];
    }

    return _itemButtons;
}

@end
