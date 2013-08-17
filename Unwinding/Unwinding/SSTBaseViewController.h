//
//  SSTBaseViewController.h
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTBaseViewController : UIViewController

- (void)performSegueWithIdentifier:(NSString *)identifier action:(SEL)action;

- (BOOL)isModal:(UIViewController *)vc;

@end
