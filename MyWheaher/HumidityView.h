//
//  HumidityView.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/16.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <POP/POP.h>
#import "BaseWheatherView.h"


@interface HumidityView :BaseWheatherView
/**
 *  @author ctd.leonard, 15-09-16 11:09:02
 *
 *  @abstract  the humidity for this view to display.
 *  @discussion Humidity must in range of [0 , 100];
 */
@property (nonatomic) CGFloat Humidity;

@end
