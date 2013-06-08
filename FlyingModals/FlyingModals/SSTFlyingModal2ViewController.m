//
//  SSTFlyingModal2ViewController.m
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTFlyingModal2ViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface SSTFlyingModal2ViewController ()

@property (weak, nonatomic) IBOutlet UIView *modalView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SSTFlyingModal2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // it is easy to delete a constraint in a storyboard, so always assert they are defined
    MAAssert(self.topConstraint, @"Constraint is required");
    MAAssert(self.heightConstraint, @"Constraint is required");
    
    self.modalView.hidden = TRUE;
    
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0.75];
    self.textView.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.alpha = 0;
    
    [self hideModal:FALSE withCompletionBlock:^{
        self.modalView.hidden = FALSE;
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // due to contraints with autolayout bounds are not set until viewDidAppear (there has to be a better way)
    [self styleModal];
    
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
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.topConstraint.constant = (self.heightConstraint.constant + 20) * -1;
        [self.view endEditing:TRUE];
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
        [self.textView becomeFirstResponder];
        self.topConstraint.constant = 20;
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completionBlock) {
            completionBlock();
        }
    }];
}

#pragma mark - Style
#pragma mark -

- (void)styleModal {
    // first set the height of the modal view to adapt for 3.5" and 4" displays
    
    // 216 for keyboard + (20 * 2) for additional space on top and bottom
    self.heightConstraint.constant = CGRectGetHeight(self.view.frame) - 216.0 - 40.0;
    [self.modalView setNeedsLayout];
    [self.modalView layoutIfNeeded];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    UIBezierPath *roundedPath = [UIBezierPath bezierPathWithRoundedRect:self.modalView.bounds
                                                      byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomRight
                                                            cornerRadii:CGSizeMake(13.f, 13.f)];
    [roundedPath closePath];
    maskLayer.path = [roundedPath CGPath];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.backgroundColor = [[UIColor greenColor] CGColor];
    self.modalView.layer.mask = maskLayer;
    [self.modalView setNeedsDisplay];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)dismissButtonTapped:(id)sender {
    [self hideModal:TRUE withCompletionBlock:^{
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.delegate flyingModal2ViewControllerDismissed:self];
        }];
    }];
}

@end
