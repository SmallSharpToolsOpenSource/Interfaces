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

- (IBAction)forwardButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"FirstToSecond" sender:self];
}

@end
