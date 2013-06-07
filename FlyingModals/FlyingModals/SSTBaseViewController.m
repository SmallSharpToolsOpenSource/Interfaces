//
//  SSTBaseViewController.m
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTBaseViewController.h"

#import "SSTFlyingModal1ViewController.h"
#import "SSTFlyingModal2ViewController.h"

@interface SSTBaseViewController ()

@end

@implementation SSTBaseViewController

#pragma mark - View Lifecycle
#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return FALSE;
}

#pragma mark - Additions
#pragma mark -

- (void)embedViewController:(UIViewController *)vc intoView:(UIView *)superview {
    MAAssert(vc, @"VC must be define");
    MAAssert(superview, @"Superview must be defined");
    
    if ([vc respondsToSelector:@selector(setDelegate:)]) {
        [vc performSelector:@selector(setDelegate:) withObject:self];
    }
    
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:vc];
    [superview addSubview:vc.view];
    [superview addConstraints:@[
     [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
     [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:vc.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
     ]];
    [vc.view setNeedsLayout];
    [vc.view layoutIfNeeded];
    
    [vc didMoveToParentViewController:self];
}

- (void)removeEmbeddedViewController:(UIViewController *)vc {
    if (vc) {
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
}

- (void)showFlyingModal1 {
    SSTFlyingModal1ViewController *vc = (SSTFlyingModal1ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SSTFlyingModal1VC"];
    [self embedViewController:vc intoView:self.view];
}

- (void)showFlyingModal2 {
    SSTFlyingModal1ViewController *vc = (SSTFlyingModal1ViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"SSTFlyingModal2VC"];
    [self embedViewController:vc intoView:self.view];
}

@end
