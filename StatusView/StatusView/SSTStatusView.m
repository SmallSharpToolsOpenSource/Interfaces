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

@implementation SSTStatusView

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
    self.statusLabel.text = status;
    self.statusViewTopConstraint.constant = -20.0;
    [self.superview bringSubviewToFront:self];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    self.hidden = FALSE;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.statusViewTopConstraint.constant = 0.0;
        [self setNeedsLayout];
    } completion:^(BOOL finished) {
        UIViewAnimationOptions options = UIViewAnimationOptionAllowUserInteraction;
        [UIView animateWithDuration:0.5 delay:3.0 options:options animations:^{
            self.statusViewTopConstraint.constant = -20.0;
            [self setNeedsLayout];
        } completion:^(BOOL finished) {
            if (completionBlock) {
                completionBlock();
            }
        }];
    }];
}

@end
