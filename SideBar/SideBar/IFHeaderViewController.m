//
//  IFHeaderViewController.m
//  Sidebar
//
//  Created by Brennan Stehling on 12/26/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//

#import "IFHeaderViewController.h"

@interface IFHeaderViewController ()

@end

@implementation IFHeaderViewController

#pragma mark - User Actions
#pragma mark -

- (IBAction)siderBarButtonTapped:(id)sender {
    NSAssert(self.delegate != nil, @"Delegate must be defined!");
    
    if (self.delegate != nil) {
        [self.delegate headerViewDidToggleSideBar:self];
    }
}

@end
