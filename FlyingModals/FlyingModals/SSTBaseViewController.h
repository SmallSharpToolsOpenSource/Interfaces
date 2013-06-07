//
//  SSTBaseViewController.h
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTBaseViewController : UIViewController

- (void)embedViewController:(UIViewController *)vc intoView:(UIView *)superview;

- (void)removeEmbeddedViewController:(UIViewController *)vc;

- (void)showFlyingModal1;

- (void)showFlyingModal2;

@end
