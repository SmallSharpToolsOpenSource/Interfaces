//
//  SSTSixthViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTSixthViewController.h"

@interface SSTSixthViewController ()

@end

@implementation SSTSixthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Sixth";
}

- (IBAction)dismissButtonTapped:(id)sender {
    [self performUnwindSegueWithIdentifier:@"popToHome" action:@selector(popToHome:)];
}

@end
