//
//  SSTThirdViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTThirdViewController.h"

@interface SSTThirdViewController ()

@end

@implementation SSTThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Third";
}

- (IBAction)homeButtonTapped:(id)sender {
    [self performUnwindSegueWithIdentifier:@"popToHome" action:@selector(popToHome:)];
}

@end
