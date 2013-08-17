//
//  SSTFirstViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTFirstViewController.h"

@interface SSTFirstViewController ()

@end

@implementation SSTFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"First";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DebugLog(@"isModal: %@", [self isModal:self] ? @"YES" : @"NO");
}

- (IBAction)forwardButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"FirstToSecond" sender:self];
}

@end
