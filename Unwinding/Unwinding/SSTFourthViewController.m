//
//  SSTFourthViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTFourthViewController.h"

@interface SSTFourthViewController ()

@end

@implementation SSTFourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Fourth";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DebugLog(@"isModal: %@", [self isModal:self] ? @"YES" : @"NO");
}

- (IBAction)dismissButtonTapped:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [self performSegueWithIdentifier:@"popToHome" action:@selector(popToHome:)];
}

@end
