//
//  SSTViewController.m
//  BusyTextField
//
//  Created by Brennan Stehling on 3/10/14.
//  Copyright (c) 2014 SmallSharpTools. All rights reserved.
//

#import "SSTBusyTextViewController.h"

@interface SSTBusyTextViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;


@end

@implementation SSTBusyTextViewController

#pragma mark - Private
#pragma mark -

- (void)setBusy:(BOOL)busy {
    if (busy) {
        self.textField.rightView = nil;
        self.textField.rightViewMode = UITextFieldViewModeNever;
    }
    else {
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.textField.rightView = activityIndicator;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
        [activityIndicator startAnimating];
    }
    
    busy = !busy;
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)toggleButtonTapped:(id)sender {
    [self setBusy:self.textField.rightView != nil];
}

@end
