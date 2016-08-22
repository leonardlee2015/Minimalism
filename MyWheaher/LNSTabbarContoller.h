//
//  LNSTabbarContoller.h
//  DynamicTabBar
//
//  Created by  Leonard on 16/5/16.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>



@class LNS_Tabbar;
@class LNSTabbarContoller;

@protocol LNSTabbarContollerDelegate <UITabBarControllerDelegate>
@optional
-(void)tabBarControllerDidClickLeftBarItem:(nonnull LNSTabbarContoller *)tabBarController;
-(void)tabbarControllerDidClickRightBarItem:(nonnull LNSTabbarContoller *)tabBarController;

@end
@interface LNSTabbarContoller : UITabBarController
@property(nullable,weak,nonatomic) id<LNSTabbarContollerDelegate> delegate;
@property(nonatomic,strong,nonnull,readonly)LNS_Tabbar *constomTabbar;


@end
