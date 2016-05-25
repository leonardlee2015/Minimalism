//
//  TemperatureView.h
//  WheatherAppTest
//
//  Created by 李南 on 15/9/26.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "BaseWheatherView.h"
#import "NumberView.h"


@interface TemperatureView : BaseWheatherView<NumberViewDelegate>
@property(nonatomic,assign) NSNumber *temperature;

@end
