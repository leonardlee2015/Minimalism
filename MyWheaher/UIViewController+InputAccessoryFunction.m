//
//  UIViewController+InputAccessoryFunction.m
//  CLContentsTest
//
//  Created by 李南 on 15/8/26.
//  Copyright (c) 2015年 ctd.leonard. All rights reserved.
//

#import "UIViewController+InputAccessoryFunction.h"
#import <objc/runtime.h>

@implementation UIViewController (InputAccessoryFunction)
static const   char textFieldAssociateKey;
static const char enbededTextViewAssociateKey;

-(void)addAccessViewToTextField:(UITextField *)textField 
{
    
    objc_setAssociatedObject(self, &textFieldAssociateKey, textField, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    textField.inputAccessoryView = [self createInputAccessoryView];
    
    
    // set observer of keyboardNotication to change FirsstResponder.
    [self setNotification];
    

    
}
-(UIView*)createInputAccessoryView{
    
    // initialize a accessory view contain a canccel ,a done button and a text view .
    UIView *accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 200, CGRectGetWidth(self.view.bounds), 150)];
    accessoryView.backgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    
    // initialize canncel and done button;
    
    UIButton *canccelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [canccelButton setTitle:@"取消 " forState:UIControlStateNormal];
    [canccelButton addTarget:self action:@selector(canncel:) forControlEvents:UIControlEventTouchUpInside];
    canccelButton.frame =  CGRectMake(5, 5, 70, 30);
    canccelButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [canccelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //canccelButton.backgroundColor  = [UIColor whiteColor];
    //canccelButton.layer.borderWidth = 3;
    //canccelButton.layer.borderColor = [UIColor blueColor].CGColor;
    [accessoryView addSubview:canccelButton];
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame =  CGRectMake(CGRectGetWidth(accessoryView.bounds)-5-70, 5, 70, 30);
    doneButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //doneButton.backgroundColor = [UIColor whiteColor];
    //doneButton.layer.borderWidth = 3;
    //doneButton.layer.borderColor = [UIColor blueColor].CGColor;
    [accessoryView addSubview:doneButton];
    
    // initialize a title label .
    // initialize wo textView .
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(20,35 ,CGRectGetWidth(accessoryView.bounds)-40,150-40-10) ];
    textView.delegate = self;
    [accessoryView addSubview:textView];
    /**
     *  make textView associate with this view controller.
     */

    objc_setAssociatedObject(self, &enbededTextViewAssociateKey, textView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return accessoryView;

}
#pragma mark - Properties
-(UITextField *)textField{
    return objc_getAssociatedObject(self, &textFieldAssociateKey);
}

-(UITextView *)enbededTextView{
    return objc_getAssociatedObject(self, &enbededTextViewAssociateKey);
}
#pragma mark - Event Handling
-(void)setNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFirstResponder:) name:UIKeyboardWillShowNotification object:nil];
}

-(void)changeFirstResponder:(NSNotification*)notification{
    NSLog(@"textField %@ ", self.textField.placeholder);
    if (![self.textField.text isEqualToString:@""]) {
        self.textField.text = @"";
    }
    self.enbededTextView.text =  self.textField.text;
    [self.enbededTextView becomeFirstResponder];
    [self.textField resignFirstResponder];
}
-(IBAction)canncel:(id)sender{
    [self.enbededTextView resignFirstResponder];
    [self.textField resignFirstResponder];
    
}
-(void)complete:(id)sender{
    [self.enbededTextView resignFirstResponder];
    [self.textField resignFirstResponder];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length != 0) {
        self.textField.text = textView.text;
    }
    
}
#pragma mark - UITextFieldDelegate
/*
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
 */
@end
