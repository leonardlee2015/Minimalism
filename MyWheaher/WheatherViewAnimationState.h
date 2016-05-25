//
//  WheatherViewState.h
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WheatherViewAnimationState : NSObject
@property(nonatomic,strong) id startState;
@property(nonatomic,strong) id midState;
@property(nonatomic,strong) id endState;

-(CGFloat)CGFloatStartState;
-(CGFloat)CGFloatMidState;
-(CGFloat)CGFloatEndState;

-(CGRect)CGRectStartState;
-(CGRect)CGRectMidState;
-(CGRect)CGRectEndState;
@end
