//
//  SSTFlyingModalsViewController.m
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTFlyingModalsViewController.h"

#import "SSTFlyingModal1ViewController.h"
#import "SSTFlyingModal2ViewController.h"

@interface SSTFlyingModalsViewController () <SSTFlyingModal1ViewControllerDelegate, SSTFlyingModal2ViewControllerDelegate>

@end

@implementation SSTFlyingModalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)showModal1ButtonTapped:(id)sender {
    [self showFlyingModal1];
}

- (IBAction)showModal2ButtonTapped:(id)sender {
    [self showFlyingModal2];
}

#pragma mark - SSTFlyingModal1ViewControllerDelegate
#pragma mark -

- (void)flyingModal1ViewControllerDismissed:(SSTFlyingModal1ViewController *)vc {
    [self removeEmbeddedViewController:vc];
}

#pragma mark - SSTFlyingModal2ViewControllerDelegate
#pragma mark -

- (void)flyingModal2ViewControllerDismissed:(SSTFlyingModal2ViewController *)vc {
    [self removeEmbeddedViewController:vc];
}

@end
