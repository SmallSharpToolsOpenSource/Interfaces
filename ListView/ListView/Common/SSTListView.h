//
//  SSTListView.h
//  ListView
//
//  Created by Brennan Stehling on 7/24/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSTListViewDelegate;

@class SSTListCell;

@interface SSTListView : UIView

@property(weak, nonatomic) IBOutlet id<SSTListViewDelegate> delegate;

//@property(strong, nonatomic, readonly) UIScrollView *scrollView;

// Clears cells and resets the view
- (void)reloadData;

// Dequeues an cell that is free to be reused
- (SSTListCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

- (void)displayAtIndex:(NSUInteger)index;

@end

@protocol SSTListViewDelegate <NSObject>

@required

// Provides dimensions for each cell (uniform in size for this implementation)
- (CGSize)listViewCellSize:(SSTListView *)listView atIndex:(NSUInteger)index;

// Total number of cells available in the slider
- (NSInteger)numberOfCellsInListView:(SSTListView *)listView;

// Creates and returns item for the given index, reusing items whenever possible like UITableView.
- (SSTListCell *)listView:(SSTListView *)listView cellForIndex:(NSUInteger)index;

// Allows for cell to be configured
- (void)listView:(SSTListView *)listView configureCell:(SSTListCell *)cell forIndex:(NSUInteger)index;

// Determines if the slider bar will set the offset to a margin after user interaction has finished scrolling
- (BOOL)listViewShouldSettleAtMargin:(SSTListView *)listView;

@end
