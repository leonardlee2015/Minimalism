//
//  GetCurrentData.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/21.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CurrentWeatherData;
@class GetCurrentData;
@class Coordinate;
@protocol GetCurrentDataDelegate <NSObject>
-(void)GetCurrentData:(nonnull GetCurrentData*)getData  getDataSuccessWithWeatherData:(nonnull CurrentWeatherData*)weatherData;
-(void)GetCurrentData:(nonnull GetCurrentData*)getData getDataFailWithError:(nonnull NSError*)error;

@end
@interface GetCurrentData : NSObject

@property(nonatomic,weak,nullable)  id<GetCurrentDataDelegate> delegate;


-(nullable instancetype)initWithDelegate:(nullable id<GetCurrentDataDelegate>)delegate;

@property(nonatomic,strong,nonnull) Coordinate *location;
@property(nonatomic,copy,nonnull) NSString *cityId;
@property(nonatomic,copy,nonnull) NSString *cityName;
@property(nonatomic,copy,nullable) NSString *ZNCithName;

-(void)requestWithLocation;
-(void)requestWithCityId;
-(void)requestWithCityName;

-(void)requestWithCoordinate:(nonnull Coordinate*)corrdinate;
-(void)requestWithCityId:(nonnull NSString*)cityId;
-(void)requestWithCityName:(nonnull NSString*)cityName;

@end
