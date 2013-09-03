//
//  SSTBaseViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTBaseViewController.h"

#warning This code is not entirely reliable yet

@interface SSTBaseViewController ()

@end

@implementation SSTBaseViewController

- (UIViewController *)parentOrPresentingViewController {
    return self.parentViewController ? self.parentViewController : self.presentingViewController;
}

- (void)performUnwindSegueWithIdentifier:(NSString *)identifier action:(SEL)action {
    UIViewController *destinationVC = nil;
    UIViewController *parentVC = [self parentOrPresentingViewController];
    while (parentVC) {
        UIViewController *vc = [parentVC viewControllerForUnwindSegueAction:action fromViewController:self withSender:self];
        if (vc) {
            destinationVC = vc;
            break;
        }
        else {
            parentVC = [self parentOrPresentingViewController];
        }
    }
    
    if (destinationVC) {
        UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:identifier source:self destination:destinationVC performHandler:^{
            // pop if there is a navigation controller and it has view controllers besides the root
            if (destinationVC.navigationController && destinationVC.navigationController.viewControllers.count > 1) {
                // dismiss modal before popping if necessary
                if (destinationVC.presentedViewController) {
                    [destinationVC dismissViewControllerAnimated:FALSE completion:nil];
                }
                [destinationVC.navigationController popToViewController:destinationVC animated:TRUE];
            }
            else if (destinationVC.presentedViewController) {
                [destinationVC dismissViewControllerAnimated:TRUE completion:nil];
            }
        }];
        [segue perform];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [destinationVC performSelector:action withObject:segue];
#pragma clang diagnostic pop
    }
}

@end
