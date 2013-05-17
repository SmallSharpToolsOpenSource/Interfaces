//
//  SSTStatusView.h
//  StatusView
//
//  Created by Brennan Stehling on 5/17/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTStatusView : UIView

+ (SSTStatusView *)loadFromNibIntoSuperview:(UIView *)superview;

- (void)displayStatus:(NSString *)status withCompletionBlock:(void (^)())completionBlock;

@end
