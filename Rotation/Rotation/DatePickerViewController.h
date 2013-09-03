//
//  DatePickerViewController.h
//  Rotation
//
//  Created by Brennan Stehling on 9/2/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const DatePickerViewControllerAnimationDuration;

@protocol DatePickerViewControllerDelegate;

@interface DatePickerViewController : UIViewController

@property (weak, nonatomic) id<DatePickerViewControllerDelegate> delegate;

@property (assign, nonatomic) CGFloat animationDuration;

- (void)showPicker:(BOOL)animated withCompletionBlock:(void (^)())completionBlock;

- (void)hidePicker:(BOOL)animated withCompletionBlock:(void (^)())completionBlock;

@end

@protocol DatePickerViewControllerDelegate <NSObject>

- (void)datePickerWasDismissed:(DatePickerViewController *)vc;

@end
