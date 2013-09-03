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

#pragma mark - Rotation
#pragma mark -

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationMaskAllButUpsideDown);
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotate {
    return TRUE;
}

#pragma mark - Additions
#pragma mark -

- (void)fillSubview:(UIView *)subview inSuperView:(UIView *)superview {
    [superview addConstraints:@[
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
     ]];
    [subview setNeedsLayout];
    [subview layoutIfNeeded];
}

- (void)embedViewController:(UIViewController *)vc intoView:(UIView *)superview {
    MAAssert(vc, @"VC must be define");
    MAAssert(superview, @"Superview must be defined");
    
    if ([vc respondsToSelector:@selector(setDelegate:)]) {
        [vc performSelector:@selector(setDelegate:) withObject:self];
    }
    
    vc.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addChildViewController:vc];
    [superview addSubview:vc.view];
    [self fillSubview:vc.view inSuperView:superview];
    
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
