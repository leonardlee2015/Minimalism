//
//  ForcastViewController.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/26.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const DismissForcastViewCNotification;

typedef NS_ENUM(NSUInteger, ForcastRequestType) {
    ForcastRequestTypeCityID,
    ForcastRequestTypeCityName,
    ForcastRequestTypeCoordinate
};

@interface ForcastViewController : UIViewController
@property(nonatomic) ForcastRequestType requestType;
@property(nonatomic,strong) id requstParam;
@end
