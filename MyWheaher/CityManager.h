//
//  CityManager.h
//  MyWheaher
//
//  Created by  Leonard on 16/7/17.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class City;

typedef NS_ENUM(NSUInteger,  CityType) {
    CityTypelocation,
    CityTypeNormal,
};


typedef void(^DidSelectCityHandler)( City * __nullable city, CityType type, NSUInteger index);
typedef void(^DidChangedCityHandler)(City * __nullable city, CityType type, NSUInteger index);
typedef void(^DidremoveCityHandler)(City * __nullable city, CityType type, NSUInteger index);
typedef void(^DidUpdateAllCitysHandler)(NSArray<City*>* _Nonnull cities);

@interface CityManager : NSObject
@property(nonnull,nonatomic,strong) City *locatedCity;
@property(nonatomic,nonnull,copy)NSArray<City*> *citys;

-(void)setCurrentCityType:(CityType)type index:(NSInteger)index;

+(nonnull CityManager*)shareManager;
-(void)addCity:(nonnull City * ) city;
-(void)addCities:(nonnull NSArray<City*> *)cities;
-(void)removeCity:(nonnull City *)city;
-(void)removeCities:(nonnull NSArray<City*>*)cities;

-(void)addDidSelectCityHandler:(DidSelectCityHandler _Nonnull)hander withIdentifier:(nonnull NSString*)identifier;
-(void)addDidChangedCityHandler:(DidChangedCityHandler _Nonnull)hander withIdentifier:(nonnull NSString*)identifier;
-(void)addDidremoveCityHandler:(DidremoveCityHandler _Nonnull)hander withIdentifier:(nonnull NSString*)identifier;
-(void)addDidUpdateAllCitysHandler:(DidUpdateAllCitysHandler _Nonnull)hander withIdentifier:(nonnull NSString*)identifier;

-(void)removeDidSelectCityHandlerByIdentifier:(nonnull NSString*)identifier;
-(void)removeDidChangedCityHandlerByIdentifier:(nonnull NSString*)identifier;
-(void)removeDidremoveCityHandlerByIdentifier:(nonnull NSString*)identifier;
-(void)removeDidUpdateAllCitysHandlerByIdentifier:(nonnull NSString*)identifier;

@end
