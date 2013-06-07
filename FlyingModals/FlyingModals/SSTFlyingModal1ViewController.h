//
//  SSTFlyingModal1ViewController.h
//  FlyingModals
//
//  Created by Brennan Stehling on 6/6/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSTFlyingModal1ViewControllerDelegate;

@interface SSTFlyingModal1ViewController : UIViewController

@property (weak, nonatomic) id<SSTFlyingModal1ViewControllerDelegate> delegate;

@end

@protocol SSTFlyingModal1ViewControllerDelegate <NSObject>

- (void)flyingModal1ViewControllerDismissed:(SSTFlyingModal1ViewController *)vc;

@end
