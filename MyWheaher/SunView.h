//
//  sunView.h
//  WheatherAppTest
//
//  Created by 李南 on 16/3/28.
//  Copyright © 2016年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"

typedef NS_ENUM(NSInteger,SunStype){
    SunStypeSunSet,
    SunStypeSunRize
};

@interface SunView : BaseWheatherView{
@protected
    UIView *_upView;
    UIView *_downView;
    UIView *_separatorLine;
    
    UILabel *_timeLabel;
    UIImageView *_sunImageView;
    UIImageView *_moonImageView;
    
    CGFloat _width;
    
}
@property(nonatomic,copy)NSDate *sunrizeSunsetTime;
+(SunView*)sunViewWithFrame:(CGRect)frame Stype:(SunStype)sunstype;


@end
