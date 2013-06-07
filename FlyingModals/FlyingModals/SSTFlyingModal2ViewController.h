//
//  SSTFlyingModal2ViewController.h
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSTFlyingModal2ViewControllerDelegate;

@interface SSTFlyingModal2ViewController : UIViewController

@property (weak, nonatomic) id<SSTFlyingModal2ViewControllerDelegate> delegate;

@end

@protocol SSTFlyingModal2ViewControllerDelegate <NSObject>

- (void)flyingModal2ViewControllerDismissed:(SSTFlyingModal2ViewController *)vc;

@end
