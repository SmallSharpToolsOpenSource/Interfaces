//
//  SSTSecondViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTSecondViewController.h"

@interface SSTSecondViewController ()

@end

@implementation SSTSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Second";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DebugLog(@"isModal: %@", [self isModal:self] ? @"YES" : @"NO");
}

- (IBAction)forwardButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"SecondToThird" sender:self];
}

@end
