//
//  Coordinates.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/19.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.lat = [aDecoder decodeObjectForKey:@"lat"];
        self.lon = [aDecoder decodeObjectForKey:@"lon"];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.lat forKey:@"lat"];
    [aCoder encodeObject:self.lon forKey:@"lon"];
}

@end
