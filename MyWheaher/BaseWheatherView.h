//
//  WheatherView.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/16.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SetRect.h"

#define SHOW_DURATION 1.75f
#define HIDE_DURATION 0.75f
#define MOD(element) ((element) * self.scaleConst)
#define ScaleRectMake(x,y,width,height) CGRectMake(MOD(x), MOD(y), MOD(width), MOD(height))
#define ScaleSizeMake(width,height) CGSizeMake(MOD(width), MOD(height))
#define ScalePointMake(x,y) CGPointMake(MOD(x), MOD(y))
#define radian(angle) (M_PI * (angle) /180.f)



@class WheatherViewAnimationState;
@protocol BaseWheatherViewDelegate <NSObject>
@optional

/**
 *  @brief additon animation will play while perform [WheatherView show].
 *
 *  @param view     iew that the animation is added to.
 *  @param duration animation duration.
 *  @param delay    animation delay.
 */
-(void)additionShowAnimationToView:(UIView*)view byDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

/**
 *  @brief additon animation will play while perform [WheatherView hide].
 * 
 *  @param view     view view that the animation is added to;
 *  @param duration animation duration.
 *  @param delay    animation delay.
 */
-(void)additionHideAnimationToView:(UIView*)view byDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay;

@end
@interface BaseWheatherView : UIView
/**
 *  @brief  delegate
 */
@property (nonatomic,weak) id<BaseWheatherViewDelegate> delegate;
/**
 *  @author ctd.leonard, 15-09-16 11:09:32
 *
 *  @abstract  initialize view's appearance. 
 *  @discussion after you create the view , you should run this methods before use it.If this view use autoLayout,run config constraints and run [layoutIfNeed] before this methods.
 *
 */

-(void)buildView;
/**
 *  @author ctd.leonard, 15-09-16 11:09:18
 *  @warning subclass must override this mothods.
 *  @abstract show the view with  animation effects.
 */
-(void)show;
/**
 *  @brief show the view with  animation effects.
 *  @warning subclass must override this mothods.
 *  @param duration animation duration.
 *  @param delay    animation delay .
 */
-(void)showByDuration:(CGFloat)duration delay:(CGFloat)delay;
/**s
 *  @author ctd.leonard, 15-09-16 11:09:39
 *
 *  @abstract hide the view with  aniamtion effects.
 */
-(void)hide;
/**
 *  @brief hide the view with  aniamtion effects.
 *  @warning subclass must override this mothods.
 *  @param duration animation duration.
 *  @param delay    animation delay.
 */
-(void)hideByDuration:(CGFloat)duration delay:(CGFloat)delay;
/**
 *  @brief an scale  constant let view's contents fit the views size.
 *      if you want to use MOD() Macro，you must override its getter mathods first.
 */
@property(nonatomic,readonly)CGFloat scaleConst;
/**
 *  @brief check wheater view frame satisified the view need.
 *  @Warning the predefine requisition is width must equal height. if you want to change 
    the rule of frame in subclass override this mathods. 
 *  @param frame frame.
 */
-(void)checkSizeWithFrame:(CGRect) frame;

-(void)ToAnimationStartState;
-(void)ToAnimationMidState;
-(void)ToAnimationEndState;
-(void)MoveWithMidRect:(CGRect)rect startOffsetP:(CGPoint)startOffset endOffsetP:(CGPoint)endOffset WithAnimationState:(nonnull WheatherViewAnimationState*)state;
@property(nonatomic, getter=isUITestOn) BOOL UITestOn;
@end
