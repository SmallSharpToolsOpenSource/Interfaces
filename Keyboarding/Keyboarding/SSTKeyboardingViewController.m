//
//  SSTViewController.m
//  Keyboarding
//
//  Created by Brennan Stehling on 8/19/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTKeyboardingViewController.h"

@interface SSTKeyboardingViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;

@end

@implementation SSTKeyboardingViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resizeForHiddenKeyboardWithHeight:0.0 duration:0.0 curve:kNilOptions];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MAAssert(self.scrollView, @"Outlet is required");
    MAAssert(self.scrollViewHeightConstraint, @"Outlet is required");
//    MAAssert(self.tapGesture, @"Outlet is required");
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)tapGestureRecognized:(id)sender {
    [self.view endEditing:TRUE];
}

#pragma mark - Base Overrides
#pragma mark -

- (void)keyboardWillShowWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    [super keyboardWillShowWithHeight:height duration:duration curve:curve];
    [self resizeForShownKeyboardWithHeight:height duration:duration curve:curve];
}

- (void)keyboardWillHideWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    [super keyboardWillHideWithHeight:height duration:duration curve:curve];
    [self resizeForHiddenKeyboardWithHeight:height duration:duration curve:curve];
}

- (void)resizeForHiddenKeyboardWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    self.tapGesture.enabled = FALSE;
    CGFloat constant = CGRectGetHeight(self.view.frame);
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        self.scrollViewHeightConstraint.constant = constant;
        [self.scrollView setNeedsLayout];
        [self.scrollView layoutIfNeeded];
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:TRUE];
    } completion:^(BOOL finished) {
    }];
}

- (void)resizeForShownKeyboardWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    self.tapGesture.enabled = TRUE;
    CGFloat constant = CGRectGetHeight(self.view.frame) - height;
    
    CGFloat totalHeight = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    self.scrollViewHeightConstraint.constant = totalHeight;
    [self.scrollView setNeedsLayout];
    [self.scrollView layoutIfNeeded];
    
    [UIView animateWithDuration:duration delay:0.0 options:curve animations:^{
        self.scrollViewHeightConstraint.constant = constant;
        [self.scrollView setNeedsLayout];
        [self.scrollView layoutIfNeeded];
        CGRect frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 10, 320, 10);
        [self.scrollView scrollRectToVisible:frame animated:TRUE];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - UITextFieldDelegate
#pragma mark -

// currently the code below does not work properly
//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    DebugLog(@"%@", NSStringFromSelector(_cmd));
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
////        CGRect frame = [self.scrollView convertRect:textField.frame fromView:textField];
//        
//        CGPoint point = [self.view convertPoint:textField.center fromView:textField];
//        CGRect frame = CGRectMake(point.x, point.y, 10, 10);
//        LOG_FRAME(@"frame", frame);
//        [self.scrollView scrollRectToVisible:frame animated:TRUE];
//    });
//    
//}

@end
