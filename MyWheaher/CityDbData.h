//
//  CityDBData.h
//  MyWheaher
//
//  Created by  Leonard on 16/5/7.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityDbData : NSObject
/**
 *  生成数据库单例
 *
 *  @return 返回数据库单例
 */
+(nullable CityDbData*)shareCityDbData;
/**
 *  初始化数据库，查询数据前需运行一次。当且仅当程序第一次运行执行数据库初始化.
 */
-(void)initializationDB;
/**
 *  根据英文城市名查询中文城市名称。
 *
 *  @param cityName 英文城市名。
 *
 *  @return 查询成功返回中文城市名称，失败返回nil.
 */
-(nullable NSString *)requestZhCityNameByCityName:(nonnull NSString*)cityName;

/**
 *  根据中文城市名称返回英文城市拼音名称（仅支持中国城市）
 *
 *  @param zhCityName 中文城市名称
 *
 *  @return 英文城市拼音名称。
 */

-(nullable NSString *)requestCityNameByZHCityName:(nonnull NSString*)zhCityName;
@end
