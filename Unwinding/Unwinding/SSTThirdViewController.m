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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DebugLog(@"isModal: %@", [self isModal:self] ? @"YES" : @"NO");
}

- (IBAction)homeButtonTapped:(id)sender {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    [self performSegueWithIdentifier:@"popToHome" action:@selector(popToHome:)];
}

@end
