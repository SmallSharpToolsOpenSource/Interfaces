//
//  SSTStatusView.m
//  StatusView
//
//  Created by Brennan Stehling on 5/17/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTStatusView.h"

#pragma mark - Class Extension
#pragma mark -

@interface SSTStatusView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) NSLayoutConstraint *statusViewTopConstraint;

@end

@implementation SSTStatusView {
    BOOL isStatusHidden;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChangeNotification:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
    return self;
}

+ (SSTStatusView *)loadFromNibIntoSuperview:(UIView *)superview {
    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth(superview.frame), 20.0);
    SSTStatusView *statusView = [[SSTStatusView alloc] initWithFrame:frame];
    statusView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UINib *nib = [UINib nibWithNibName:@"SSTStatusView" bundle:nil];
    NSArray *items = [nib instantiateWithOwner:statusView options:nil];
    
    MAAssert(items.count, @"There must be items loaded from the NIB");
    MAAssert(statusView.contentView, @"Content View outlet must be attached");
    MAAssert(statusView.statusLabel, @"Status Label outlet must be attached");
    
    for (id item in items) {
        if ([item isKindOfClass:[UIView class]]) {
            [statusView addSubview:(UIView *)item];
        }
    }
    
    [superview addSubview:statusView];
    [superview bringSubviewToFront:statusView];
    
    MAAssert(statusView.subviews.count, @"Status View should have subviews");
    
    //// Add Constraints
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:statusView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                                                        toItem:statusView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0];
    // save top constraint
    statusView.statusViewTopConstraint = topConstraint;
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:statusView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                                                            toItem:statusView.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:statusView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                                                             toItem:statusView.superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    [statusView.superview addConstraints:@[topConstraint, leadingConstraint, trailingConstraint]];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:statusView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:20.0];
    [statusView addConstraint:heightConstraint];
    statusView.hidden = TRUE;
    
    return statusView;
}

- (void)displayStatus:(NSString *)status withCompletionBlock:(void (^)())completionBlock {
//    DebugLog(@"%@, %@", NSStringFromSelector(_cmd), status);
    
    self.statusLabel.text = status;
    self.statusViewTopConstraint.constant = -20.0;
    [self.superview bringSubviewToFront:self];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.hidden = FALSE;
    isStatusHidden = TRUE;
    
    // during rotation the constant value on the key constraint is set to ensure the position is
    // correct, which causes a side effect on the animation if an animation block uses a delay value,
    // so instead GCD is used for the delay and the show/hide sequence is broken into 2 parts.
    // it now works reliably.
    
    [self showStatusWithCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self hideStatusWithCompletionBlock:^{
                if (completionBlock) {
                    completionBlock();
                }
            }];
        });
    }];
    
    // animating with a delay causes trouble related orientation changes so this code has been commented out
//    [UIView animateWithDuration:0.5 delay:1.0 options:options animations:^{
//        self.statusViewTopConstraint.constant = 0.0;
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
//    } completion:^(BOOL finished) {
//        isStatusHidden = FALSE;
//        DebugLog(@"setting currentTopConstant to -20.0");
//        [UIView animateWithDuration:0.5 delay:3.0 options:options animations:^{
//            self.statusViewTopConstraint.constant = -20.0;
//            [self setNeedsLayout];
//            [self layoutIfNeeded];
//        } completion:^(BOOL finished) {
//            isStatusHidden = TRUE;
//            if (completionBlock) {
//                completionBlock();
//            }
//        }];
//    }];
}

- (void)showStatusWithCompletionBlock:(void (^)())completionBlock {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.5 delay:0.0 options:options animations:^{
        self.statusViewTopConstraint.constant = 0.0;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        isStatusHidden = FALSE;
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)hideStatusWithCompletionBlock:(void (^)())completionBlock {
    UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:0.5 delay:0.0 options:options animations:^{
        self.statusViewTopConstraint.constant = -20.0;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        isStatusHidden = TRUE;
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark - Logging
#pragma mark -

- (void)logConstraint {
    DebugLog(@"top constant: %f", self.statusViewTopConstraint.constant);
}

#pragma mark - Notifications
#pragma mark -

- (void)deviceOrientationDidChangeNotification:(NSNotification *)notification {
    self.statusViewTopConstraint.constant = isStatusHidden ? -20.0 : 0.0;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
