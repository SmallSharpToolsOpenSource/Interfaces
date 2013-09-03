//
//  SSTGrowingImageView.m
//  GrowingImageView
//
//  Created by Brennan Stehling on 8/15/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTGrowingImageView.h"

#pragma mark - Class Extension
#pragma mark -

@interface SSTGrowingImageView ()

@property (weak, nonatomic) UIImageView *fullImageView;

@end

@implementation SSTGrowingImageView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        // attach tap gesture
        UITapGestureRecognizer *growingTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(originalImageViewTapped:)];
        self.gestureRecognizers = @[growingTapGestureRecognizer];
        self.userInteractionEnabled = TRUE;
    }
    return self;
}

- (IBAction)originalImageViewTapped:(id)sender {
    [self growFullImageView:TRUE];
}

- (IBAction)fullImageViewTapped:(id)sender {
    [self shrinkFullImageView:TRUE];
}

- (CGRect)originalFrame {
    CGPoint point = [self.window.rootViewController.view convertPoint:self.bounds.origin fromView:self];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    return CGRectMake(point.x, point.y, width, height);
}

- (CGRect)fullFrame {
    CGFloat width = CGRectGetWidth(self.window.rootViewController.view.bounds);
    CGFloat height = CGRectGetHeight(self.window.rootViewController.view.bounds);
    
    if ([[UIApplication sharedApplication] isStatusBarHidden]) {
        return CGRectMake(0, 0, width, height);
    }
    else {
        height -= 20;
        return CGRectMake(0, 20, width, height);
    }
}

- (void)growFullImageView:(BOOL)animated {
    CGRect originalFrame = [self originalFrame];
    
    UIImageView *fullImageView = [[UIImageView alloc] initWithFrame:originalFrame];
    fullImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    fullImageView.contentMode = UIViewContentModeScaleAspectFit;
    fullImageView.backgroundColor = [UIColor clearColor];
    fullImageView.image = self.image;
    fullImageView.userInteractionEnabled = TRUE;
    
    UITapGestureRecognizer *fullImageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fullImageViewTapped:)];
    fullImageView.gestureRecognizers = @[fullImageViewTapGestureRecognizer];
    
    self.fullImageView = fullImageView;
    
    [self addFullView];
    
    CGFloat duration = animated ? 0.25 : 0.0;
    CGRect fullFrame = [self fullFrame];
    
    [UIView animateWithDuration:duration animations:^{
        fullImageView.frame = fullFrame;
        fullImageView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
    } completion:^(BOOL finished) {
        // do nothing
    }];
}

- (void)shrinkFullImageView:(BOOL)animated {
    if (!self.fullImageView) {
        return;
    }
    
    if (!animated) {
        [self removeFullView];
    }
    
    CGRect originalFrame = [self originalFrame];
    
    self.fullImageView.backgroundColor = [UIColor clearColor];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.fullImageView.frame = originalFrame;
    } completion:^(BOOL finished) {
        [self removeFullView];
    }];
}

- (void)addFullView {
    [self.window.rootViewController.view addSubview:self.fullImageView];
}

- (void)removeFullView {
    [self.fullImageView removeFromSuperview];
    self.fullImageView = nil; // just a redundant step to free this property
}

@end
