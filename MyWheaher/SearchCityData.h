//
//  SearchCityData.h
//  MyWheaher
//
//  Created by  Leonard on 16/7/24.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SearchCityData;
@class City;

@protocol SearchCityDataDelegate <NSObject>
-(void)searchCityData:(nonnull SearchCityData*) searchCityData didUpdateSucessWithData:(nonnull NSArray<City*>*)cities;
-(void)searchCityData:(nonnull SearchCityData*) searchCityData didUpdateFailWithError:(nullable NSError*)error;

@end

@interface SearchCityData : NSObject
@property(nullable,weak,nonatomic) id<SearchCityDataDelegate> delegate;

-(void)searchCityByName:(nonnull NSString*)cityName;
@end
