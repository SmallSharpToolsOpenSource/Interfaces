//
//  SSTStackedItemView.h
//  Stacks
//
//  Created by Brennan Stehling on 7/12/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SSTStackedItem.h"
#import "SSTStackedItemView.h"

@class SSTStackedItemView;

@interface SSTStackedItemViewOwner : NSObject

@property (strong, nonatomic) IBOutlet SSTStackedItemView *stackedView;

@end

@interface SSTStackedItemView : UIView

+ (instancetype)loadViewFromNib;

- (void)configureForStackedItem:(SSTStackedItem *)stackedItem;

+ (CGFloat)stackItems:(NSArray *)stackedItems inView:(UIView *)view;

@end
