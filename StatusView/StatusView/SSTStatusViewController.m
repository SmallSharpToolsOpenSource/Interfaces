//
//  SSTViewController.m
//  StatusView
//
//  Created by Brennan Stehling on 5/17/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTStatusViewController.H"

#import "SSTStatusView.h"

@interface SSTStatusViewController ()

@property (weak, nonatomic) SSTStatusView *statusView;

@property (weak, nonatomic) UIView *redBox;
@property (weak, nonatomic) UIView *blueBox;

@property (weak, nonatomic) NSLayoutConstraint *centerYConstraint;

@end

@implementation SSTStatusViewController {
    BOOL isBlueDown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addBluebox]; // frame only
    [self addRedBox]; // constraints
    self.statusView = [SSTStatusView loadFromNibIntoSuperview:self.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isBlueDown) {
        self.blueBox.frame = [self blueBoxDownFrame];
    }
    else {
        self.blueBox.frame = [self blueBoxUpFrame];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self displayStatusMessages];
        [self moveBoxes];
    });
}

#pragma mark - Rotation
#pragma mark -

// Note: The status view goes out of view during rotation and does not come back into view

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (isBlueDown) {
        self.blueBox.frame = [self blueBoxDownFrame];
    }
    else {
        self.blueBox.frame = [self blueBoxUpFrame];
    }
}

- (void)addBluebox {
    // Add a blue box which is just positioned with a frame.
    
    // The blue box is centered and a little larger than the red box. It stays centered on rotation.
    
    isBlueDown = FALSE;
    CGRect frame = [self blueBoxUpFrame];
    UIView *blueBox = [[UIView alloc] initWithFrame:frame];
    blueBox.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    blueBox.translatesAutoresizingMaskIntoConstraints = YES; // default
    blueBox.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:blueBox];
    
    MAAssert(blueBox.constraints.count == 0, @"There should be no constraints");
    
    self.blueBox = blueBox;
}

- (void)addRedBox {
    // Add a red box which is positioned with constraints.
    
    // The red box is centered and a little smaller than the blue box which is below. It stays centered on rotation using constraints.
    
    UIView *redBox = [[UIView alloc] initWithFrame:CGRectMake(20.0, 100.0, 100.0, 100.0)];
    redBox.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    redBox.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:redBox];
    
    // Add constraints to center view
    
    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:redBox attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual
                                                                            toItem:redBox.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:redBox attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual
                                                                            toItem:redBox.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
    self.centerYConstraint = centerYConstraint;
    
    [redBox.superview addConstraints:@[centerXConstraint, centerYConstraint]];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:redBox attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:redBox attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0];
    
    [redBox addConstraints:@[widthConstraint, heightConstraint]];
    
    self.redBox = redBox;
}

- (void)moveBoxes {
    isBlueDown = TRUE;
    [UIView animateWithDuration:0.5 animations:^{
        self.centerYConstraint.constant = -50;
        [self.redBox setNeedsLayout];
        [self.redBox layoutIfNeeded];
        self.blueBox.frame = [self blueBoxDownFrame];
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            isBlueDown = FALSE;
            [UIView animateWithDuration:0.5 animations:^{
                self.centerYConstraint.constant = 0;
                [self.redBox setNeedsLayout];
                [self.redBox layoutIfNeeded];
                self.blueBox.frame = [self blueBoxUpFrame];
            } completion:^(BOOL finished) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self moveBoxes];
                });
            }];
        });
    }];
}

- (CGRect)blueBoxDownFrame {
    CGRect frame = CGRectMake(0, 0, 120, 120);
    if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        frame.origin.x = (CGRectGetWidth(self.view.frame) / 2) - (CGRectGetWidth(self.blueBox.frame) / 2);
        frame.origin.y = (CGRectGetHeight(self.view.frame) / 2) - (CGRectGetHeight(self.blueBox.frame) / 2) + 60.0;
    }
    else {
        frame.origin.x = (CGRectGetHeight(self.view.frame) / 2) - (CGRectGetHeight(self.blueBox.frame) / 2);
        frame.origin.y = (CGRectGetWidth(self.view.frame) / 2) - (CGRectGetWidth(self.blueBox.frame) / 2) + 60.0;
    }
    
    return frame;
}

- (CGRect)blueBoxUpFrame {
    CGRect frame = CGRectMake(0.0, 0.0, 120, 120);
    if (!UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        frame.origin.x = (CGRectGetWidth(self.view.frame) / 2) - (CGRectGetWidth(self.blueBox.frame) / 2);
        frame.origin.y = (CGRectGetHeight(self.view.frame) / 2) - (CGRectGetHeight(self.blueBox.frame) / 2);
    }
    else {
        frame.origin.x = (CGRectGetHeight(self.view.frame) / 2) - (CGRectGetHeight(self.blueBox.frame) / 2);
        frame.origin.y = (CGRectGetWidth(self.view.frame) / 2) - (CGRectGetWidth(self.blueBox.frame) / 2);
    }
    
    return frame;
}

- (void)displayStatusMessages {
    [self.statusView displayStatus:@"Hello!" withCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.statusView displayStatus:@"Goodbye!" withCompletionBlock:^{
                // start again
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self displayStatusMessages];
                });
            }];
        });
    }];
    
}

- (void)logDeviceOrientation {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    DebugLog(@"Is Portrait (Interface): %@", UIInterfaceOrientationIsPortrait(orientation) ? @"YES" : @"NO");
    DebugLog(@"Is Landscape (Interface): %@", UIInterfaceOrientationIsLandscape(orientation) ? @"YES" : @"NO");
    DebugLog(@"Is Portrait (Device): %@", UIDeviceOrientationIsPortrait(orientation) ? @"YES" : @"NO");
    DebugLog(@"Is Landscape (Device): %@", UIDeviceOrientationIsLandscape(orientation) ? @"YES" : @"NO");
    
    if (orientation == UIDeviceOrientationUnknown) {
        DebugLog(@"Orientation is Unknown");
    }
    else if (orientation == UIDeviceOrientationPortrait) {
        DebugLog(@"Orientation is Portrait");
    }
    else if (orientation == UIDeviceOrientationPortraitUpsideDown) {
        DebugLog(@"Orientation is PortraitUpsideDown");
    }
    else if (orientation == UIDeviceOrientationLandscapeLeft) {
        DebugLog(@"Orientation is LandscapeLeft");
    }
    else if (orientation == UIDeviceOrientationLandscapeRight) {
        DebugLog(@"Orientation is LandscapeRight");
    }
    else if (orientation == UIDeviceOrientationFaceUp) {
        DebugLog(@"Orientation is FaceUp");
    }
    else if (orientation == UIDeviceOrientationFaceDown) {
        DebugLog(@"Orientation is FaceDown");
    }
}

@end
