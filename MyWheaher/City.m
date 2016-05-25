//
//  City.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "City.h"
#import "Coordinate.h"

@implementation City
-(instancetype)init{
    self = [super init];
    if (self) {
        _coordinate = [Coordinate new];
    }
    return self;
}
@end
