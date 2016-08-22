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
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self) {
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.ZHCityName = [aDecoder decodeObjectForKey:@"ZHCityName"];
        self.country = [aDecoder decodeObjectForKey:@"country"];
        self.coordinate = [aDecoder decodeObjectForKey:@"coordinate"];
        self.temperature = [aDecoder decodeObjectForKey:@"temperature"];
        self.upateTime = [aDecoder decodeObjectForKey:@"upateTime"];
    }

    return self;

}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.ZHCityName forKey:@"ZHCityName"];
    [aCoder encodeObject:self.country forKey:@"country"];
    [aCoder encodeObject:self.coordinate forKey:@"coordinate"];
    [aCoder encodeObject:self.temperature forKey:@"temperature"];
    [aCoder encodeObject:self.upateTime forKey:@"upateTime"];
}
-(id)copyWithZone:(NSZone *)zone{
    City *city = [[City alloc]init];

    city.cityId = _cityId;
    city.cityName = _cityName;
    city.ZHCityName  = _ZHCityName;
    city.coordinate.lat = _coordinate.lat;
    city.coordinate.lon = _coordinate.lon;
    city.country = _country;

    return city;
}
@end
