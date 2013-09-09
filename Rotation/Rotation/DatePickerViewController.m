//
//  DatePickerViewController.m
//  Rotation
//
//  Created by Brennan Stehling on 9/2/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "DatePickerViewController.h"

#import "RotationConstants.h"

CGFloat const DatePickerViewControllerAnimationDuration = 0.25;

@interface DatePickerViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *pickerWrapperView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation DatePickerViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.animationDuration = DatePickerViewControllerAnimationDuration;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (kUseWindow) {
        [self changeToOrientation:toInterfaceOrientation];
    }
}

#pragma mark - Public
#pragma mark -

- (void)changeToOrientation:(UIInterfaceOrientation)orientation {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    UIView *rootView = window.rootViewController.view;
    
    self.view.transform = [self transformForOrientation:orientation];
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(rootView.frame), CGRectGetHeight(rootView.frame));
    self.view.frame = frame;
}

- (void)showPicker:(BOOL)animated withCompletionBlock:(void (^)())completionBlock {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    CGFloat duration = animated ? self.animationDuration : 0.0;
    
    self.pickerWrapperView.hidden = FALSE;
    
    CGRect frame = self.pickerWrapperView.frame;
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (!UIInterfaceOrientationIsLandscape(orientation)) {
        frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.pickerWrapperView.frame);
    }
    else {
        frame.origin.y = CGRectGetWidth(self.view.frame) - CGRectGetHeight(self.pickerWrapperView.frame);
    }
    
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

#pragma mark - User Actions
#pragma mark -

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

- (CGAffineTransform)transformForOrientation:(UIInterfaceOrientation)orientation {
//	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	if (orientation == UIInterfaceOrientationLandscapeLeft) {
		return CGAffineTransformMakeRotation(M_PI*1.5);
	} else if (orientation == UIInterfaceOrientationLandscapeRight) {
		return CGAffineTransformMakeRotation(M_PI/2);
	} else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
		return CGAffineTransformMakeRotation(-M_PI);
	} else {
		return CGAffineTransformIdentity;
	}
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
