//
//  DatePickerViewController.m
//  Rotation
//
//  Created by Brennan Stehling on 9/2/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "DatePickerViewController.h"

CGFloat const DatePickerViewControllerAnimationDuration = 0.25;

@interface DatePickerViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pickerWrapperView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation DatePickerViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.animationDuration = DatePickerViewControllerAnimationDuration;
}

- (IBAction)doneButtonTapped:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [self dismiss];
}

- (IBAction)tapGestureRecognized:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [self dismiss];
}

#pragma mark - Private
#pragma mark -

- (void)dismiss {
    [self hidePicker:TRUE withCompletionBlock:^{
        if ([self.delegate respondsToSelector:@selector(datePickerWasDismissed:)]) {
            [self.delegate datePickerWasDismissed:self];
        }
    }];
}

- (void)showPicker:(BOOL)animated withCompletionBlock:(void (^)())completionBlock {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    CGFloat duration = animated ? self.animationDuration : 0.0;
    
    self.pickerWrapperView.hidden = FALSE;
    
    CGRect frame = self.pickerWrapperView.frame;
    frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.pickerWrapperView.frame);
    
    LOG_FRAME(@"show", frame);
    
    UIViewAnimationOptions options = kNilOptions;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.pickerWrapperView.frame = frame;
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)hidePicker:(BOOL)animated withCompletionBlock:(void (^)())completionBlock {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    CGFloat duration = animated ? self.animationDuration : 0.0;
    
    if (!animated) {
        self.pickerWrapperView.hidden = TRUE;
    }
    
    CGRect frame = self.pickerWrapperView.frame;
    frame.origin.y = CGRectGetHeight(self.view.frame);
    
    LOG_FRAME(@"hide", frame);

    UIViewAnimationOptions options = kNilOptions;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.pickerWrapperView.frame = frame;
    } completion:^(BOOL finished) {
        self.pickerWrapperView.hidden = TRUE;
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark - UIGestureRecognizerDelegate
#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // only respond tapping the main view, not any subview which may use the touch events
    if (self.tapGestureRecognizer == gestureRecognizer) {
        return touch.view == self.view;
    }
    else {
        return TRUE;
    }
}

@end
