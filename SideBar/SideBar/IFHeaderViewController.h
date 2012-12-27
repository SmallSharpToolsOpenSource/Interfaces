//
//  IFHeaderViewController.h
//  Sidebar
//
//  Created by Brennan Stehling on 12/26/12.
//  Copyright (c) 2012 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IFHeaderDelegate;

@interface IFHeaderViewController : UIViewController

@property (nonatomic, assign) IBOutlet id<IFHeaderDelegate> delegate;

@end

@protocol IFHeaderDelegate <NSObject>

- (void)headerViewDidToggleSideBar:(IFHeaderViewController *)sender;

@end