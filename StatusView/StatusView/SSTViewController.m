//
//  SSTViewController.m
//  StatusView
//
//  Created by Brennan Stehling on 5/17/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTViewController.h"

#import "SSTStatusView.h"

@interface SSTViewController ()

@property (weak, nonatomic) SSTStatusView *statusView;

@end

@implementation SSTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addBluebox];
    [self addRedBox];
    
    self.statusView = [SSTStatusView loadFromNibIntoSuperview:self.view];
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self displayStatusMessages];
    });
}

#pragma mark - Rotation
#pragma mark -

// Note: The status view goes out of view during rotation and does not come back into view (the attempts below did not fix it)

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    [self.statusView setNeedsLayout];
    [self.statusView layoutIfNeeded];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

    [self.statusView setNeedsLayout];
    [self.statusView layoutIfNeeded];
}

- (void)addBluebox {
    // Add a blue box which is just positioned with a frame.
    
    // The blue box is centered and a little larger than the red box. It stays centered on rotation.
    
    UIView *blueBox = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) / 2) - 60.0, (CGRectGetHeight(self.view.frame) / 2) - 60.0, 120.0, 120.0)];
    blueBox.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
    blueBox.translatesAutoresizingMaskIntoConstraints = YES; // default
    blueBox.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:blueBox];
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
    
    [redBox.superview addConstraints:@[centerXConstraint, centerYConstraint]];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:redBox attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:redBox attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100.0];
    
    [redBox addConstraints:@[widthConstraint, heightConstraint]];
}

- (void)displayStatusMessages {
    
    [self.statusView displayStatus:@"Hello!" withCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.statusView displayStatus:@"Goodbye!" withCompletionBlock:^{
                // start again
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self displayStatusMessages];
                });
            }];
        });
    }];
    
}

@end
