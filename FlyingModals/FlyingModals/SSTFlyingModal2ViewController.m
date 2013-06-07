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
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation SSTFlyingModal2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    LOG_FRAME(@"bounds", self.modalView.bounds);
    
    self.view.backgroundColor = [self.view.backgroundColor colorWithAlphaComponent:0.75];
    self.textView.text = @"";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    LOG_FRAME(@"bounds", self.modalView.bounds);
    
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [self hideModal:FALSE withCompletionBlock:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    LOG_FRAME(@"bounds", self.modalView.bounds);
    
    [self styleModal];
    
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [self showModal:TRUE withCompletionBlock:nil];
}

#pragma mark - Hide and Show
#pragma mark -

- (void)hideModal:(BOOL)animated withCompletionBlock:(void (^)())completionBlock {
    CGFloat duration = animated ? 0.25 : 0.0;
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    [UIView animateWithDuration:duration delay:0.0 options:options animations:^{
        self.topConstraint.constant = CGRectGetHeight(self.view.frame) / 2 * -1;
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
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    [self hideModal:TRUE withCompletionBlock:^{
        [UIView animateWithDuration:0.1 animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.delegate flyingModal2ViewControllerDismissed:self];
        }];
    }];
}

@end
