//
//  SSTUnwindingViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTUnwindingViewController.h"

@interface SSTUnwindingViewController ()

@end

@implementation SSTUnwindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DebugLog(@"segue: %@", segue.identifier);
}

- (IBAction)forwardButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"HomeToFirst" sender:self];
}

- (IBAction)modalButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"HomeToFourth" sender:self];
}

- (IBAction)goToFifthButtonTapped:(id)sender {
    [self performSegueWithIdentifier:@"HomeToFifth" sender:self];
}

- (IBAction)popToHome:(UIStoryboardSegue *)segue {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
}

@end
