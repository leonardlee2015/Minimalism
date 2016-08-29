//
//  Analysitcs.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/29.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#ifndef Analysitcs_h
#define Analysitcs_h

#import <UMMobClick/MobClick.h>

// 自定义事件ID
#define RequestingEnterCityMangerID @"RequestingEnterCityManger"
#define RequestFailedEnterCityManagerID @"RequestFailedEnterCityManager"
#define NormalEnterCityMangerID @"NormalEnterCityManger"
#define LongPressRequestWeatherDataID @"LongPressRequestWeatherData"
#define DragDownRequestWeatherDataID @"DragDownRequestWeatherData"
#define SwipeChangeShowCityID @"SwipeChangeShowCity"
#define CityManagerChangeShowCityID @"CityManagerChangeShowCity"
#define AddCityID @"AddCity"
#define RemoveCityID @"RemoveCity"
#define LocationDidNotOpenID @"LocationDidNotOpen"
#define LocationFailedID @"LocationFailed"
#define DecoderLocationFailedID @"DecoderLocationFailed"
#define RequestWeatherDataFailedID @"RequestWeatherDataFailed"

// 自定义事件属性key
#define UMErrMsg @"ErrMsg"
#endif /* Analysitcs_h */
