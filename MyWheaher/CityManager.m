//
//  CityManager.m
//  MyWheaher
//
//  Created by  Leonard on 16/7/17.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "CityManager.h"
#import "City.h"

NSString *const citiesKey = @"cities key";
@interface CityManager ()
@property(nonnull,nonatomic,readonly) NSMutableDictionary *didSelectCityHandlers;

@property(nonnull,nonatomic,readonly) NSMutableDictionary *didChangedCityHandlers;

@property(nonnull,nonatomic,readonly) NSMutableDictionary *didremoveCityHandlers;

@property(nonnull,nonatomic,readonly) NSMutableDictionary *didUpdateAllCitysHandlers;

@property(nonatomic,readonly) CityType currentCityType;
@property(nonatomic,readonly) NSInteger currentCityIndex;


@end
@implementation CityManager
+(CityManager *)shareManager{
    static CityManager *cityManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cityManager = [[CityManager alloc]init];
    });

    return cityManager;
}

-(instancetype)init{
    self = [super init];
    if (self) {

        _citys = [self citiesFromUserDefaults];

        if (!_citys) {
            _citys = [NSArray array];

            [[NSUserDefaults standardUserDefaults] setObject:_citys forKey:citiesKey];

        }
    }


    return self;
}

-(void)addCity:(City *)city{
    NSMutableArray *cities  = [NSMutableArray arrayWithArray:_citys];
    [cities addObject:city];
    _citys = [cities copy];

    [self refleshArrayInUserDefault:cities];

    for (DidChangedCityHandler handler in [self.didChangedCityHandlers allValues]) {
        handler(city, CityTypeNormal, [cities indexOfObject:city]);
    }

}

-(void)addCities:(NSArray<City *> *)cities{
    NSMutableArray *inCities  = [NSMutableArray arrayWithArray:_citys];
    [inCities addObjectsFromArray:cities];

    _citys = [inCities copy];

    [self refleshArrayInUserDefault:inCities];


    for (DidUpdateAllCitysHandler handler in [self.didUpdateAllCitysHandlers allValues]) {
        handler(cities);
    }
}

-(void)removeCity:(City *)city{
    NSMutableArray *cities  = [NSMutableArray arrayWithArray:_citys];
    NSInteger index = [cities indexOfObject:city];

    [cities removeObject:city];

    _citys = [cities copy];

    [self refleshArrayInUserDefault:cities];


    for (DidremoveCityHandler handler in [self.didremoveCityHandlers allValues]) {
        handler(city,CityTypeNormal, index);
    }
}

-(void)removeCities:(NSArray<City *> *)cities{
    NSMutableArray *inCities  = [NSMutableArray arrayWithArray:_citys];
    [inCities removeObjectsInArray:cities];

    _citys = [cities copy];


    [self refleshArrayInUserDefault:cities];

}

-(void)setCurrentCityType:(CityType)type index:(NSInteger)index{
    _currentCityType = type;
    _currentCityIndex = index;

    for (DidSelectCityHandler handler in [self.didSelectCityHandlers allValues]) {
        if (type == CityTypelocation) {
            handler(_locatedCity, type, 0);
        }else{
            handler(_citys[index], type, index);
        }
    }
}

-(void)refleshArrayInUserDefault:(NSArray<City*>*)cities{
    NSMutableArray *tempCities = [NSMutableArray arrayWithCapacity:cities.count];
    for (City *city in cities) {
        NSData *cityData = [NSKeyedArchiver archivedDataWithRootObject:city];

        [tempCities addObject:cityData];
    }

    [[NSUserDefaults standardUserDefaults] setObject:[tempCities copy] forKey:citiesKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(NSArray<City*>*)citiesFromUserDefaults{
    NSMutableArray *tempCities = [NSMutableArray array];

    NSArray *citiesData = [[NSUserDefaults standardUserDefaults] objectForKey:citiesKey];

    for (NSData *cityData in citiesData) {
        City *city = [NSKeyedUnarchiver unarchiveObjectWithData:cityData];
        [tempCities addObject:city];
    }

    return [tempCities copy];

}
#pragma mark - Properties
@synthesize locatedCity = _locatedCity;
-(City *)locatedCity{
    if(!_locatedCity){
        _locatedCity = [City new];
    }

    return _locatedCity;
}
-(void)setLocatedCity:(City *)locatedCity{

    _locatedCity = locatedCity;

    for (DidChangedCityHandler handler in [self.didChangedCityHandlers allValues]) {

        handler(locatedCity, CityTypelocation, 0);
    }
}

-(void)addDidSelectCityHandler:(DidSelectCityHandler)hander withIdentifier:(NSString *)identifier{
    [self.didSelectCityHandlers setObject:[hander copy] forKey:identifier];

}

-(void)addDidChangedCityHandler:(DidChangedCityHandler)hander withIdentifier:(NSString *)identifier{
    [self.didChangedCityHandlers setObject:[hander copy] forKey:identifier];
}

-(void)addDidremoveCityHandler:(DidremoveCityHandler)hander withIdentifier:(NSString *)identifier{
    [self.didremoveCityHandlers setObject:[hander copy] forKey:identifier];
}

-(void)addDidUpdateAllCitysHandler:(DidUpdateAllCitysHandler)hander withIdentifier:(NSString *)identifier{
    [self.didUpdateAllCitysHandlers setObject:[hander copy] forKey:identifier];
}

-(void)removeDidSelectCityHandlerByIdentifier:(NSString *)identifier{
    [self.didSelectCityHandlers removeObjectForKey:identifier];
}

-(void)removeDidChangedCityHandlerByIdentifier:(NSString *)identifier{
    [self.didChangedCityHandlers removeObjectForKey:identifier];
}

-(void)removeDidremoveCityHandlerByIdentifier:(NSString *)identifier{
    [self.didremoveCityHandlers removeObjectForKey:identifier];
}

-(void)removeDidUpdateAllCitysHandlerByIdentifier:(NSString *)identifier{
    [self.didUpdateAllCitysHandlers removeObjectForKey:identifier];
}

@synthesize didSelectCityHandlers = _didSelectCityHandlers;
-(NSMutableDictionary *)didSelectCityHandlers{
    if (!_didSelectCityHandlers) {
        _didSelectCityHandlers = [NSMutableDictionary dictionaryWithCapacity:10];

    }
    return _didSelectCityHandlers;
}

@synthesize didChangedCityHandlers = _didChangedCityHandlers;
-(NSMutableDictionary *)didChangedCityHandlers{
    if (!_didChangedCityHandlers) {
        _didChangedCityHandlers = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return _didChangedCityHandlers;
}

@synthesize didremoveCityHandlers = _didremoveCityHandlers;
-(NSMutableDictionary *)didremoveCityHandlers{
    if (!_didremoveCityHandlers) {
        _didremoveCityHandlers = [NSMutableDictionary dictionaryWithCapacity:10
                                  ];

    }

    return _didremoveCityHandlers;
}

@synthesize didUpdateAllCitysHandlers = _didUpdateAllCitysHandlers;
-(NSMutableDictionary *)didUpdateAllCitysHandlers{
    if (!_didUpdateAllCitysHandlers) {
        _didUpdateAllCitysHandlers = [NSMutableDictionary dictionaryWithCapacity:10];

    }
    return _didUpdateAllCitysHandlers;
}
@end

