//
//  LNS_Tabbar.h
//  DynamicTabBar
//
//  Created by  Leonard on 16/5/18.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LNS_Tabbar;
@protocol LNS_TabbarDelegate <NSObject>
-(void)tabbar:(nonnull LNS_Tabbar*)tabbar pageValueDidChange:(NSInteger)changeValue;

@optional
-(void)tabbarRightBarItemDidClick:(nonnull LNS_Tabbar *)tabbar;
-(void)tabbarLeftBarItemDidClick:(nonnull LNS_Tabbar*)  tabbar;
@end


@interface LNS_Tabbar : UIView
@property(nullable,nonatomic,weak) id<LNS_TabbarDelegate> delegate;
@property(nonnull,nonatomic,strong)UIImage *leftButtonNormalImage;
@property(nonatomic,nonnull,strong)UIImage *leftBUttonHighLightImage;

@property(nonnull,nonatomic,strong)UIImage *rightButtonNormalImage;
@property(nonnull,nonatomic,strong)UIImage *rightButtonHighLightImage;

@property(nonatomic,assign) NSUInteger numOfPages;
@property(nonatomic,assign) NSUInteger currentPage;

@end
