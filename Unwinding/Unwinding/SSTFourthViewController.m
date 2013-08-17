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

- (IBAction)dismissButtonTapped:(id)sender {
    [self performUnwindSegueWithIdentifier:@"popToHome" action:@selector(popToHome:)];
}

@end
