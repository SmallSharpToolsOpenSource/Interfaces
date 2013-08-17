//
//  SSTBaseViewController.h
//  Unwinding
//
//  Created by Brennan Stehling on 8/16/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTBaseViewController : UIViewController

- (void)performUnwindSegueWithIdentifier:(NSString *)identifier action:(SEL)action;

@end
