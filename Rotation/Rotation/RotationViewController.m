//
//  ViewController.m
//  Rotation
//
//  Created by Brennan Stehling on 8/31/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "RotationViewController.h"

#import "RotationConstants.h"
#import "DatePickerViewController.h"

@interface RotationViewController () <DatePickerViewControllerDelegate>

@property (strong, nonatomic) UIViewController *shownViewController;

@property (strong, nonatomic) UIActionSheet *shownActionSheet;

@end

@implementation RotationViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
//    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.shownViewController) {
        [self.shownViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }
    else {
        DebugLog(@"There is no shown view controller");
    }
}

#pragma mark - User Actions
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
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                       delegate:nil
                              cancelButtonTitle:nil
                         destructiveButtonTitle:nil
                              otherButtonTitles:nil];
    
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    CGRect pickerRect = pickerView.frame;
    pickerRect.origin.y = 266 - CGRectGetHeight(pickerRect);
    pickerView.frame = pickerRect;
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 90, 5, 80, 40);
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(dismissManualModal:) forControlEvents:UIControlEventTouchUpInside];

    [actionSheet addSubview:pickerView];
    [actionSheet addSubview:doneButton];
    [actionSheet showInView:self.view];
    [actionSheet setFrame:CGRectMake(0,CGRectGetHeight(self.view.frame) - 266,CGRectGetWidth(self.view.frame), 266)];
    
    actionSheet.superview.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.25];
    
    self.shownActionSheet = actionSheet;
}

- (IBAction)dismissManualModal:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self.shownActionSheet) {
        [self.shownActionSheet dismissWithClickedButtonIndex:0 animated:TRUE];
        self.shownActionSheet = nil;
    }
}

#pragma mark - Private
#pragma mark -

- (UIViewController *)containerViewController {
    // return self; // will not be suitable inside of a TabBar or Navigation Controller

    // Use parent of the parent if the current view is contained in a navbar in a tabbar
    // return self.parentViewController.parentViewController;
    
    // Use key window to show above every other view (in TabBar and NavBar)
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController;
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
    
    id genericVC = (id)vc;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && [genericVC respondsToSelector:@selector(changeToOrientation:)]) {
        [genericVC changeToOrientation:self.interfaceOrientation];
    }
    
    // BUG adding the view to the rootViewController of the window prevents messages from being sent to the child vc. Why?
    
    if (kUseWindow) {
        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        [window addSubview:vc.view];
    }
    else {
        [containerViewController addChildViewController:vc];
        [containerViewController.view addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
}

- (void)hideViewController:(UIViewController *)vc {
    if (kUseWindow) {
        [vc.view removeFromSuperview];
        self.shownViewController = nil;
    }
    else {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        self.shownViewController = nil;
    }
}

#pragma mark - DatePickerViewControllerDelegate
#pragma mark -

- (void)datePickerWasDismissed:(DatePickerViewController *)vc {
    DebugLog(@"%@", NSStringFromSelector(_cmd));

    [self hideViewController:vc];
}

@end
