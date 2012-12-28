//
//  IFHomeViewController.m
//  Sidebar
//
//  Created by Brennan Stehling on 12/26/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//

#import "IFHomeViewController.h"

#define kMinSideBarWidth        0.0
#define kMaxSideBarWidth        200.0

#define kAnimationDuration      0.25

@interface IFHomeViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *siderBarView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *panGestureRecognizer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLeftConstraint;

@end

@implementation IFHomeViewController {
    CGFloat leftConstraintConstantOrigin;
    CGPoint gesturePointOrigin;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    leftConstraintConstantOrigin = self.contentLeftConstraint.constant;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DebugLog(@"segue.identifier: %@", segue.identifier);
    
    if ([@"HomeHeader" isEqualToString:segue.identifier]) {
        NSAssert([segue.destinationViewController isKindOfClass:[IFHeaderViewController class]], @"Destination VC must be the Header VC");
        IFHeaderViewController *headerVC = (IFHeaderViewController *)segue.destinationViewController;
        headerVC.delegate = self;
    }
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)handlePanGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint currentGesturePoint = [self.panGestureRecognizer locationInView:self.view];
    CGPoint velocity = [self.panGestureRecognizer velocityInView:self.view];
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        gesturePointOrigin = currentGesturePoint;
        leftConstraintConstantOrigin = self.contentLeftConstraint.constant;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan ||
        panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // get the delta
        CGFloat xDelta = currentGesturePoint.x - gesturePointOrigin.x;
        CGFloat yDelta = currentGesturePoint.y - gesturePointOrigin.y;
        CGPoint deltaPoint = CGPointMake(xDelta, yDelta);
        [self moveSideBarWithDelta:deltaPoint];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self moveSideBarWithVelocity:velocity];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateCancelled ||
             panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
        [self moveSideBarWithVelocity:velocity];
    }
}

#pragma mark - Private
#pragma mark -

- (void)hideSideBar:(BOOL)animated withDuration:(CGFloat)duration {
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.contentLeftConstraint.constant = kMinSideBarWidth;
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)hideSideBar:(BOOL)animated {
    [self hideSideBar:animated withDuration:kAnimationDuration];
}

- (void)showSideBar:(BOOL)animated withDuration:(CGFloat)duration {
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.contentLeftConstraint.constant = kMaxSideBarWidth;
        [self.contentView setNeedsLayout];
        [self.contentView layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

- (void)showSideBar:(BOOL)animated {
    [self showSideBar:animated withDuration:kAnimationDuration];
}

- (void)toggleSideBar {
    if (self.contentLeftConstraint.constant > kMinSideBarWidth) {
        [self hideSideBar:TRUE];
    }
    else {
        [self showSideBar:TRUE];
    }
}

- (void)moveSideBarWithDelta:(CGPoint)deltaPoint {
    // ensure the delta is in the min/max bounds
    CGFloat newConstant = leftConstraintConstantOrigin + deltaPoint.x;
    
    newConstant = MIN(newConstant, kMaxSideBarWidth);
    newConstant = MAX(newConstant, kMinSideBarWidth);
    
    self.contentLeftConstraint.constant = newConstant;
}

- (void)moveSideBarWithVelocity:(CGPoint)velocity {
    // The velocity of the pan gesture is expressed in points per second. The velocity is broken into horizontal and vertical components.

    // The remaining distance to move and the velocity can be used to determine the animation duration to keep a consisten motion
    // The remaining distance depends if it is moving left or right (negative or positive)
    // The total distance moved could be calculated with the leftConstraintConstantOrigin and gesturePointOrigin and the last point
    
    // How long does it take to go the distance given the velocity?
    // 100 points per second (velocity) would go 10 points (distance) in 0.1 seconds (duration)
    
    // 10 / 100 = 0.1
    // distance / velocity = duration

    if (velocity.x == 0.0) {
        // avoid divide by zero
        [self hideSideBar:TRUE];
        return;
    }
    
    if (velocity.x < 0.0) {
        // moving to min
        CGFloat distance = self.contentLeftConstraint.constant - kMinSideBarWidth;
        CGFloat duration = MIN(kAnimationDuration, distance / ABS(velocity.x));
        [self hideSideBar:TRUE withDuration:duration];
    }
    else {
        // moving to max
        CGFloat distance = kMaxSideBarWidth - self.contentLeftConstraint.constant;
        CGFloat duration = MIN(kAnimationDuration, distance / ABS(velocity.x));
        [self showSideBar:TRUE withDuration:duration];
    }
}

#pragma mark - IFHeaderDelegate
#pragma mark -

- (void)headerViewDidToggleSideBar:(IFHeaderViewController *)sender {
    [self toggleSideBar];
}

#pragma mark - UIGestureRecognizerDelegate
#pragma mark -

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([self.panGestureRecognizer isEqual:gestureRecognizer]) {
        return TRUE;
    }
    
    return FALSE;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
        shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
	return NO;
}

@end
