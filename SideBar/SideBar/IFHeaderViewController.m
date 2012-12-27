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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.delegate == nil && [self.parentViewController conformsToProtocol:@protocol(IFHeaderDelegate)]) {
        self.delegate = (id<IFHeaderDelegate>) self.parentViewController;
    }
    
    NSAssert(self.delegate != nil, @"Delegate must be defined!");
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)siderBarButtonTapped:(id)sender {
    NSAssert(self.delegate != nil, @"Delegate must be defined!");
    
    if (self.delegate != nil) {
        [self.delegate headerViewDidToggleSideBar:self];
    }
}

@end
