//
//  ForecastCell.h
//  MyWheaher
//
//  Created by  Leonard on 16/4/26.
//  Copyright © 2016年  Leonard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForecastCell : UITableViewCell

/**
 *  处理常规数据
 *
 *  @param data 处理的数据
 */
- (void)acccessData:(id)data indexPath:(NSIndexPath *)indexPath;

/**
 *  显示
 */
- (void)show;

/**
 *  隐藏
 */
- (void)hide;

@end
