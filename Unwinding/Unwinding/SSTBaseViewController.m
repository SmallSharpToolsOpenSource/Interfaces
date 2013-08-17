//
//  SSTBaseViewController.m
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTBaseViewController.h"

@interface SSTBaseViewController ()

@end

@implementation SSTBaseViewController

- (BOOL)canPerformUnwindSegueAction:(SEL)action fromViewController:(UIViewController *)fromViewController withSender:(id)sender {
    DebugLog(@"%@ (%@)", NSStringFromSelector(_cmd), self.title);
    return [super canPerformUnwindSegueAction:action fromViewController:fromViewController withSender:sender];
}

- (UIViewController *)parentOrPresentingViewController {
    return self.parentViewController ? self.parentViewController : self.presentingViewController;
}

- (void)performSegueWithIdentifier:(NSString *)identifier action:(SEL)action {
    
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
        DebugLog(@"destinationVC: %@", NSStringFromClass([destinationVC class]));
        UIStoryboardSegue *segue = [UIStoryboardSegue segueWithIdentifier:identifier source:self destination:destinationVC performHandler:^{
            DebugLog(@"Performing!");
//            if ([self isModal:self]) {
                DebugLog(@"dismissing");
                [destinationVC dismissViewControllerAnimated:TRUE completion:nil];
//            }
//            else {
//                DebugLog(@"popping");
//                [destinationVC.navigationController popToViewController:destinationVC animated:TRUE];
//            }
        }];
        [segue perform];
    }

}

- (BOOL)isModal:(UIViewController *)vc {
    BOOL isModal = ((vc.presentingViewController && vc.presentingViewController.presentedViewController == vc) ||
                    //or if I have a navigation controller, check if its parent modal view controller is self navigation controller
                    (vc.navigationController && vc.navigationController.presentingViewController && vc.navigationController.presentingViewController.presentedViewController == vc.navigationController) ||
                    //or if the parent of my UITabBarController is also a UITabBarController class, then there is no way to do that, except by using a modal presentation
                    [[[vc tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]]);
    
    return isModal;
}

@end
