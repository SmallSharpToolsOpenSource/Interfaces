//
//  SSTFifthViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTFifthViewController.h"

@interface SSTFifthViewController ()

@end

@implementation SSTFifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Fifth";
}

- (IBAction)modalButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"FifthToSixth" sender:self];
}

@end
