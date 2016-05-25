//
//  MyLocationManeger.m
//  MyWheaher
//
//  Created by  Leonard on 16/5/1.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "MyLocationManeger.h"
#import <CoreLocation/CoreLocation.h>


@interface MyLocationManeger ()<CLLocationManagerDelegate>
@property(nonnull,strong,nonatomic) CLLocationManager *locationManager;
@end
@implementation MyLocationManeger
-(instancetype)init{
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }

    return self;
}
-(void)startLocation{
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }

    [_locationManager startUpdatingLocation];
}
@end
