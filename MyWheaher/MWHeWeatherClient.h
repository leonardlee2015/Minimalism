//
//  MWHeWeatherClient.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/15.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, MWHeDataType){
    MWHeDataTypeCities,
    MWHeDataTypeWeatherData,
    MWHeDataTypeCouds

};

// no used, for weather respond handler.
typedef void(^MWHeGETCompletedBlock)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject);
typedef void(^MWHeGETFailBlock)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error);

// weather key .
extern NSString* const _Nonnull weatherHeaderKey;

// error cumstom domain.

@class MWHeWeatherClient;
@protocol MWHeWeatherClientDelegate <NSObject>

-(void)MWWeatherClient:(nonnull MWHeWeatherClient*)client didUpdateSucessWithWeatherData:(nullable id)weather type:(MWHeDataType) type;

-(void)MWWeatherClient:(nonnull MWHeWeatherClient *)client didUpdateSucessFailWithError:(nullable NSError*)error;
@end

@interface MWHeWeatherClient : AFHTTPSessionManager
@property(nullable,weak,nonatomic) id<MWHeWeatherClientDelegate>delegate;
@property(nonatomic,nonnull,readonly) NSArray *currentTasks;

+(nullable MWHeWeatherClient*)shareClient;
+(nullable MWHeWeatherClient*)client;

-(nullable NSURLSessionDataTask*)getAllChinaCityList;
-(nullable NSURLSessionDataTask*)getHotCityList;
-(nullable NSURLSessionDataTask*)getAllWorldCityList;
-(nullable NSURLSessionDataTask*)getAllCondList;
-(nullable NSURLSessionDataTask*)requestCityWeatherdataByID:(nonnull NSString*)cityID;
-(nullable NSURLSessionDataTask*)requestCityWeatherdataByName:(nonnull NSString*)name;
@end
