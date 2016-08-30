//
//  AppDelegate.m
//  MyWheaher
//
//  Created by  Leonard on 16/4/17.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityLogger.h"
#import "CityDBData.h"
#import <UMMobClick/MobClick.h>
/*
 #import <UMSocial.h>
#import <UMSocialWechatHandler.h>
#import <UMSocialQQHandler.h>
#import <UMSocialSinaSSOHandler.h>
*/
#import "MWHeWeatherClient.h"


#define UMAPPKey @"57a604ef67e58e8820002f9b"

// 微信
#define kWechatAppID @"wx583a9239406dfa5f"
#define kWechatAppSecret @"d4624c36b6795d1d99dcf0547af5443d"
// QQ
#define kQQAppID @"1105476106"
#define kQQAppKey @"FtXkR3atEHANB4tG"
// 新浪微博
#define kSinaAppKey @"1576468831"
#define kSinaAppSecret @"22316f7a15b1733d8761c33f8876ba2b"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // 设置AFNetworking 网络活动监视器。
#ifdef M_DEBUG
    [[AFNetworkActivityLogger sharedLogger]startLogging];
    
    [AFNetworkActivityLogger sharedLogger].level = AFLoggerLevelDebug;

#endif

    // 初始化数据库。
    [CityDbData shareCityDbData];

    // 注册友盟统计
    [self registerUMAnalystics];
#ifdef UM_OPEN
    // 注册友盟分享
    [UMSocialData setAppKey:UMAPPKey];
    [UMSocialData openLog:YES];

    // 注册微信
    [UMSocialWechatHandler setWXAppId:@"wxdc1e388c3822c80b" appSecret:@"a393c1527aaccb95f3a4c88d6d1455f6" url:@"http://www.umeng.com/social"];

    //[UMSocialWechatHandler setWXAppId:kWechatAppID  appSecret:kWechatAppSecret url:@"http://www.umeng.com/social"];
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeImage;

    // 注册QQ
    [UMSocialQQHandler setQQWithAppId:kQQAppID  appKey:kQQAppKey   url:@"http://www.umeng.com/social"];
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;

    // 注册微博
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSinaAppKey secret:kSinaAppSecret RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];



#endif


    return YES;
}

/**
 *   注册友盟统计。
 */
-(void)registerUMAnalystics{
    UMConfigInstance.appKey = UMAPPKey;
    UMConfigInstance.channelId = @"App Store";

    [MobClick startWithConfigure:UMConfigInstance];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
