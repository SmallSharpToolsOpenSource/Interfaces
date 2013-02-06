//
//  IFContentViewController.m
//  Sidebar
//
//  Created by Brennan Stehling on 12/26/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//

#import "IFContentViewController.h"

@interface IFContentViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *blueView;
@property (weak, nonatomic) IBOutlet UILabel *blueLabel;

@end

@implementation IFContentViewController {
    CGPoint gesturePointOrigin;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    for (NSLayoutConstraint *constraint in self.blueView.constraints) {
        if (constraint.constant == 100 || constraint.constant == 240) {
            constraint.constant = 400.0;
        }
    }
    self.scrollView.contentSize = CGSizeMake(410.0, 410.0);
}

@end
