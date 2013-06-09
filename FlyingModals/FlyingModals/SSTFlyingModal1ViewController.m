//
//  SSTFlyingModal1ViewController.m
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTFlyingModal1ViewController.h"

@interface SSTFlyingModal1ViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blueBoxLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redBoxTrailingConstraint;

@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UIView *redView;

@end

@implementation SSTFlyingModal1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // it is easy to delete a constraint in a storyboard, so always assert they are defined
    MAAssert(self.blueBoxLeadingConstraint, @"Constraint is required");
    MAAssert(self.redBoxTrailingConstraint, @"Constraint is required");
    
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0.75];
    
    // hide the views  in advance of hiding them in viewDidLoad to avoid showing prematurely
    self.blueView.hidden = TRUE;
    self.redView.hidden = TRUE;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.alpha = 0;
    
    [self hideModal:FALSE withCompletionBlock:^{
        self.blueView.hidden = FALSE;
        self.redView.hidden = FALSE;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        [self showModal:TRUE withCompletionBlock:nil];
    }];
}

#pragma mark - Hide and Show
#pragma mark -

- (void)hideModal:(BOOL)animated withCompletionBlock:(void (^)())completionBlock {
    CGFloat duration = animated ? 0.25 : 0.0;
    CGFloat width = CGRectGetWidth(self.view.frame);
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.blueBoxLeadingConstraint.constant = width * -1;
        self.redBoxTrailingConstraint.constant = width;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

- (void)showModal:(BOOL)animated withCompletionBlock:(void (^)())completionBlock {
    CGFloat duration = animated ? 0.25 : 0.0;
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.blueBoxLeadingConstraint.constant = 0;
        self.redBoxTrailingConstraint.constant = 0;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)dismissButtonTapped:(id)sender {
    [self hideModal:TRUE withCompletionBlock:^{
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.delegate flyingModal1ViewControllerDismissed:self];
        }];
    }];
}

@end
