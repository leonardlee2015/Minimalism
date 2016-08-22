//
//  SearchCityResultController.h
//  MyWheaher
//
//  Created by  Leonard on 16/8/6.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ResultDidselectedHandler)( City * _Nonnull city);
typedef void(^DidRollViewHandler)();

@interface SearchCityResultController : UIViewController
@property(nonnull,strong,nonatomic)NSArray<City*>* cities;
@property(nonatomic,nonnull,copy)ResultDidselectedHandler resultDidselectedHandler;

@property(nonnull,nonatomic,copy)DidRollViewHandler didRollViewHandler;
@end
