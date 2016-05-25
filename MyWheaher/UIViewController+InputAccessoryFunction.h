//
//  UIViewController+InputAccessoryFunction.h
//  CLContentsTest
//
//  Created by 李南 on 15/8/26.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol editMathodsDelegate <NSObject>


@end
@interface UIViewController(InputAccessoryFunction)<UITextViewDelegate,UITextFieldDelegate>

-(void)addAccessViewToTextField:(UITextField*)textField;
@property (nonatomic,readonly) UITextField *textField;
@property (nonatomic,readonly) UITextView *enbededTextView;
@end
