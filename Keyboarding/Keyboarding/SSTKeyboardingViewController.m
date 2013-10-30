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
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UITextField *topTextField;

@end

@implementation SSTKeyboardingViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set to black to make the status bar white, which makes no sense at all
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (isiOS7OrLater) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self resizeForHiddenKeyboardWithHeight:0.0 duration:0.0 curve:kNilOptions];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    MAAssert(self.scrollView, @"Outlet is required");
//    MAAssert(self.tapGesture, @"Outlet is required");
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIDeviceOrientationIsLandscape(toInterfaceOrientation)) {
        DebugLog(@"Landscape");
    }
    else {
        DebugLog(@"Portrait");
    }
    
    // set the width of the top text field which equals the width of the rest of the text fields
    NSLayoutConstraint *widthConstraint = [self getWidthConstraint:self.topTextField];
    CGFloat width = CGRectGetWidth(self.view.frame) - 40;
    widthConstraint.constant = width;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    return UIStatusBarStyleLightContent;
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
    
    CGFloat bottom = 0;
    if (isiOS7OrLater) {
        bottom = self.bottomLayoutGuide.length;
    }
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = bottom;
    self.scrollView.contentInset = contentInset;
    
    UIEdgeInsets scrollIndicatorInsets = self.scrollView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = contentInset.bottom;
    self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
}

- (void)resizeForShownKeyboardWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    self.tapGesture.enabled = TRUE;
    
    CGFloat bottom = 0;
    if (isiOS7OrLater) {
        bottom = self.bottomLayoutGuide.length;
    }
    
    UIEdgeInsets contentInset = self.scrollView.contentInset;
    contentInset.bottom = bottom + height;
    self.scrollView.contentInset = contentInset;
    
    UIEdgeInsets scrollIndicatorInsets = self.scrollView.scrollIndicatorInsets;
    scrollIndicatorInsets.bottom = contentInset.bottom;
    self.scrollView.scrollIndicatorInsets = scrollIndicatorInsets;
}

#pragma mark - Layout Constraints
#pragma mark -

- (NSLayoutConstraint *)getTopConstraint:(UIView *)view {
    return [self getConstraintInView:view forLayoutAttribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint *)getWidthConstraint:(UIView *)view {
    return [self getConstraintInView:view forLayoutAttribute:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint *)getHeightConstraint:(UIView *)view {
    return [self getConstraintInView:view forLayoutAttribute:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint *)getConstraintInView:(UIView *)view forLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    NSLayoutConstraint *foundConstraint = nil;
    
    if (layoutAttribute == NSLayoutAttributeTop || layoutAttribute == NSLayoutAttributeBottom ||
        layoutAttribute == NSLayoutAttributeLeading || layoutAttribute == NSLayoutAttributeTrailing) {
        
        for (NSLayoutConstraint *constraint in view.superview.constraints) {
            if (constraint.firstAttribute == layoutAttribute &&
                [view isEqual:constraint.firstItem]) {
                foundConstraint = constraint;
                break;
            }
        }
    }
    else {
        for (NSLayoutConstraint *constraint in view.constraints) {
            if (constraint.firstAttribute == layoutAttribute &&
                constraint.secondAttribute == NSLayoutAttributeNotAnAttribute) {
                foundConstraint = constraint;
                break;
            }
        }
    }
    
    return foundConstraint;
}

#pragma mark - UITextFieldDelegate
#pragma mark -

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:TRUE];
    return TRUE;
}

@end
