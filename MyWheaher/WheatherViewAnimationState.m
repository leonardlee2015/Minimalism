//
//  WheatherViewState.m
//  WheatherAppTest
//
//  Created by  Leonard on 16/4/14.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "WheatherViewAnimationState.h"

@implementation WheatherViewAnimationState
-(CGFloat)CGFloatStartState{
    if ([_startState isKindOfClass:[NSValue class]]) {
        return [_startState floatValue];
    }else{
        return -1.f;
    }
    
}
-(CGFloat)CGFloatEndState{
    if ([_endState isKindOfClass:[NSValue class]]) {
        return [_endState floatValue];
    }else{
        return -1.f;
    }
}
-(CGFloat)CGFloatMidState{
    if ([_midState isKindOfClass:[NSValue class]]) {
        return [_midState floatValue];
    }else{
        return -1.f;
    }
}

-(CGRect)CGRectStartState{
    if ([_startState isKindOfClass:[NSValue class]]) {
        return [(NSValue*)_startState CGRectValue];
    }else{
        return CGRectNull;
    }
}

-(CGRect)CGRectMidState{
    if ([_midState isKindOfClass:[NSValue class]]) {
        return [(NSValue*)_midState CGRectValue];
    }else{
        return CGRectNull;
    }
}

-(CGRect)CGRectEndState{
    if ([_endState isKindOfClass:[NSValue class]]) {
        return [(NSValue*)_endState CGRectValue];
    }else{
        return CGRectNull;
    }
}
@end
