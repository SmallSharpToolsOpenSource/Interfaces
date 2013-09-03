//
//  ViewController.m
//  Rotation
//
//  Created by Brennan Stehling on 8/31/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "RotationViewController.h"

#import "DatePickerViewController.h"

@interface RotationViewController () <DatePickerViewControllerDelegate>

@property (strong, nonatomic) UIViewController *shownViewController;

@end

@implementation RotationViewController

#pragma mark - View Lifecycle
#pragma mark -

- (IBAction)showDatePickerButtonTapped:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    DatePickerViewController *vc = (DatePickerViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"DatePickerVC"];
    vc.delegate = self;
    [self showViewController:vc];
    [vc hidePicker:FALSE withCompletionBlock:^{
        [vc showPicker:TRUE withCompletionBlock:nil];
    }];
}

- (IBAction)showManualViewButtonTapped:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.25];
    
    UIViewController *containerViewController = [self containerViewController];
    UIView *parentView = containerViewController.view;
    
    CGFloat height = 200;
    CGFloat yPos = CGRectGetHeight(parentView.frame) - height;
    CGRect frame = CGRectMake(0, yPos, CGRectGetWidth(parentView.frame), height);
    UIView *bottomView = [[UIView alloc] initWithFrame:frame];
    bottomView.backgroundColor = [UIColor redColor];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [vc.view addSubview:bottomView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(manualTapGestureRecognized:)];
    vc.view.gestureRecognizers = @[tapGestureRecognizer];
    
    [self showViewController:vc];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)manualTapGestureRecognized:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    [self hideViewController:self.shownViewController];
}

#pragma mark - Private
#pragma mark -

- (UIViewController *)containerViewController {
//    return self; // will not be suitable inside of a TabBar or Navigation Controller
    
    return self.parentViewController.parentViewController;
    
    // Use key window to show above every other view (in TabBar and NavBar)
//    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
//    return window.rootViewController;
}

- (void)showViewController:(UIViewController *)vc {
    self.shownViewController = vc;
    
    UIViewController *containerViewController = [self containerViewController];
    UIView *parentView = containerViewController.view;
    
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    vc.view.frame = parentView.frame;
    
    if (!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
		vc.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetWidth(parentView.frame), CGRectGetHeight(parentView.frame));
    }
    else {
		vc.view.frame = CGRectMake(0.0f, 0.0f, CGRectGetHeight(parentView.frame), CGRectGetWidth(parentView.frame));
    }
    
    // BUG adding the view to the rootViewController of the window prevents messages from being sent to the child vc. Why?
    
    [containerViewController addChildViewController:vc];
    [containerViewController.view addSubview:vc.view];
    [vc didMoveToParentViewController:self];
}

- (void)hideViewController:(UIViewController *)vc {
    [vc willMoveToParentViewController:nil];
    [vc.view removeFromSuperview];
    [vc removeFromParentViewController];
    self.shownViewController = nil;
}

#pragma mark - DatePickerViewControllerDelegate
#pragma mark -

- (void)datePickerWasDismissed:(DatePickerViewController *)vc {
    DebugLog(@"%@", NSStringFromSelector(_cmd));

    [self hideViewController:vc];
}

@end
