//
//  SSTListView.m
//  ListView
//
//  Created by Brennan Stehling on 7/24/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTListView.h"

#import "SSTListViewCell.h"

#import <tgmath.h>

#pragma mark - Class Extension
#pragma mark -

@interface SSTListView () <UIScrollViewDelegate>

@property (strong, nonatomic, readwrite) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) NSMutableArray *reusableCells;

@end

#pragma mark -

@implementation SSTListView {
    NSUInteger visibleCount;
    NSUInteger numberOfCellsInListView;
}

#pragma mark - Initialization
#pragma mark -

- (id)initWithCoder:(NSCoder *)aDecoder {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    if (self = [super initWithCoder:aDecoder]) {
        self.reusableCells = [@[] mutableCopy];
    }
    return self;
}

- (void)layoutSubviews {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [super layoutSubviews];
    
    if (!self.scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
//        scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        
        // TODO add constraints to make scroll view fill container
        
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.tag = 1001;
        scrollView.delegate = self;
        self.scrollView = scrollView;
        
//        UIView *containerView = [[UIView alloc] initWithFrame:scrollView.frame];
//        containerView.translatesAutoresizingMaskIntoConstraints = NO;
//        [self.scrollView addSubview:containerView];
//        self.containerView = containerView;
        
        [self addSubview:self.scrollView];
        [self bringSubviewToFront:self.scrollView];
        
        [self fillSubview:self.scrollView inSuperView:self];
//        [self setConstraintsForContainerView];
        
        NSAssert(self.scrollView.superview != nil, @"Invalid State");
    }
}

#pragma mark - Implementation
#pragma mark -

- (void)reloadData {
    NSAssert(self.delegate != nil, @"Invalid State");
    
    numberOfCellsInListView = [self.delegate numberOfCellsInListView:self];
    DebugLog(@"numberOfCellsInListView: %i", numberOfCellsInListView);
    
    // remove all subviews in the scroll view and add items back again
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    [self populateCells];
}

- (SSTListCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier {
    NSUInteger initialCount = self.reusableCells.count;
    NSInteger foundIndex = NSIntegerMax;
    SSTListCell *foundCell = nil;
    
    if (self.reusableCells.count > 0) {
        for (NSUInteger index = 0; index < self.reusableCells.count; index++) {
            SSTListCell *cell = [self.reusableCells objectAtIndex:index];
            if ([cell.reuseIdentifier isEqualToString:identifier]) {
                foundIndex = index;
                break;
            }
        }
    }
    
    if (foundIndex != NSIntegerMax) {
        foundCell = [self.reusableCells objectAtIndex:foundIndex];
        [self.reusableCells removeObjectAtIndex:foundIndex];
        NSAssert(self.reusableCells.count == initialCount - 1, @"Invalid State");
        [foundCell prepareForReuse];
    }
    
    return foundCell;
}

- (void)displayAtIndex:(NSUInteger)index {
    NSAssert(self.delegate != nil, @"Invalid State");
    
    CGRect frame = [self positionForItemAtIndex:index];
    self.scrollView.contentOffset = frame.origin;
}

#pragma mark - Private Methods
#pragma mark -

- (void)fillSubview:(UIView *)subview inSuperView:(UIView *)superview {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [superview addConstraints:@[
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                     toItem:superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
     ]];
    [subview setNeedsLayout];
    [subview layoutIfNeeded];
}

- (void)setConstraintsForContainerView {
    // set fixed width (initially to the width of the superview
    // set leading, top and bottom to superview
    
    CGFloat width = CGRectGetWidth(self.scrollView.frame);
    
    [self.containerView addConstraint:[NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual
                                                                      toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:width]];
    
    [self.containerView.superview addConstraints:@[
     [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual
                                     toItem:self.containerView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0],
     [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual
                                     toItem:self.containerView.superview attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0],
     [NSLayoutConstraint constraintWithItem:self.containerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual
                                     toItem:self.containerView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]
     ]];
    [self.containerView setNeedsLayout];
    [self.containerView layoutIfNeeded];
}

- (void)reclaimReusableCellsFromScrollView:(UIScrollView *)scrollView {
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[SSTListCell class]]) {
            SSTListCell *cell = (SSTListCell *)view;
            if (![self isFrame:cell.frame visibleInScrollView:self.scrollView]) {
                NSAssert(self.reusableCells != nil, @"Invalid State");
                [self.reusableCells addObject:cell];
                NSAssert(self.reusableCells.count > 0, @"Invalid State");
                [cell deactivate];
                [cell removeFromSuperview];
                [cell verifyIntegrity];
            }
        }
    }
}

- (void)populateCells {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    NSAssert(self.scrollView != nil, @"Invalid State");
    NSAssert(self.scrollView.superview != nil, @"Invalid State");
    
    if (numberOfCellsInListView > 0) {
        CGFloat width = [self totalWidth];
        CGFloat height = [self.delegate listViewCellSize:self atIndex:0].height;
        
        DebugLog(@"width: %f", CGRectGetWidth(self.scrollView.frame));
        
        [self.scrollView setContentSize:CGSizeMake(width, height)];
        for (NSUInteger index=0; index < numberOfCellsInListView; index++) {
            CGRect frame = [self positionForItemAtIndex:index];
            if ([self isFrame:frame visibleInScrollView:self.scrollView]) {
                SSTListCell *cell = [self.delegate listView:self cellForIndex:index];
                [self.delegate listView:self configureCell:cell forIndex:index];
                NSAssert(cell != nil, @"Invalid State");
                cell.frame = [self positionForItemAtIndex:index];
                if (cell.superview == nil) {
                    DebugLog(@"adding cell");
                    [self.scrollView addSubview:cell];
                }
            }
        }
    }
}

- (CGFloat)totalWidth {
    NSAssert(self.delegate != nil, @"Invalid State");
    
    CGFloat tally = 0;
    
    for (NSUInteger index=0; index < numberOfCellsInListView; index++) {
        CGSize size = [self.delegate listViewCellSize:self atIndex:index];
        tally += size.width;
    }
    
    return tally;
}

- (CGRect)positionForItemAtIndex:(NSUInteger)index {
    CGFloat totalWidth = 0.0;
    for (NSUInteger i=0; i<=index; i++) {
        CGSize size = [self.delegate listViewCellSize:self atIndex:i];
        totalWidth += size.width;
    }
    
    NSAssert(totalWidth != 0, @"Invalid State");
    
    CGSize size = [self.delegate listViewCellSize:self atIndex:index];
    CGFloat x = totalWidth - size.width;
    CGFloat y = 0.0;
    
    return CGRectMake(x, y, size.width, size.height);
}

- (CGPoint)nearestMarginToPoint:(CGPoint)point withVelocity:(CGPoint)velocity {
    CGFloat maxX = MAX(0.0, self.scrollView.contentSize.width - self.scrollView.bounds.size.width);
    
    if (numberOfCellsInListView > 0) {
        CGFloat currentX = 0.0;
        for (NSUInteger index=0; index < numberOfCellsInListView; index++) {
            CGSize size = [self.delegate listViewCellSize:self atIndex:index];
            
            // if velocity.x < 0 it is moving left otherwise it is moving right
            
            if (velocity.x > 0) {
                // moving right, so lean right
                
                // first cell and point.x is less than currentX + 0.25 of size.width
                // first cell and point.x is more than currentX but less than size.width
                
                if (point.x < currentX + (size.width * 0.25)) {
                    // x position is closer to left edge of current cell
                    return CGPointMake(currentX, point.y);
                }
                else if (point.x > currentX + (size.width * 0.25) && point.x < currentX + size.width) {
                    // x position is closer to right edge of current cell
                    return CGPointMake(currentX + size.width, point.y);
                }
                else if (currentX > maxX) {
                    // x position is over max
                    return CGPointMake(maxX, point.y);
                }
                
            }
            else {
                // moving left, so lean left
                
                // first cell and point.x is less than currentX
                
                if (point.x < currentX + (size.width * 0.75)) {
                    // x position is closer to left edge of current cell
                    return CGPointMake(currentX, point.y);
                }
                else if (point.x > currentX + (size.width * 0.75) && point.x < currentX + size.width) {
                    // x position is closer to right edge of current cell
                    return CGPointMake(currentX + size.width, point.y);
                }
                else if (currentX > maxX) {
                    // x position is over max
                    return CGPointMake(maxX, point.y);
                }
                
            }
            
            currentX += size.width;
        }
    }
    
    // default to the given point
    return point;
}

- (BOOL)isFrame:(CGRect)frame visibleInScrollView:(UIScrollView *)scrollView {
    CGRect visibleRect;
    visibleRect.origin = scrollView.contentOffset;
    visibleRect.size = scrollView.bounds.size;
    
    return CGRectIntersectsRect(frame, visibleRect);
}

#pragma mark - UIScrollViewDelegate
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // determine which cells should be visible and remove/add as appropriate
    
    [self reclaimReusableCellsFromScrollView:scrollView];
    
    // now add cells which are now visible
    for (NSUInteger index=0; index < numberOfCellsInListView; index++) {
        CGRect frame = [self positionForItemAtIndex:index];
        if ([self isFrame:frame visibleInScrollView:self.scrollView]) {
            BOOL found = FALSE;
            for (UIView *view in self.scrollView.subviews) {
                if ([view isKindOfClass:[SSTListCell class]] && CGPointEqualToPoint(frame.origin, view.frame.origin)) {
                    found = TRUE;
                    break;
                }
            }
            if (!found) {
                SSTListCell *cell = [self.delegate listView:self cellForIndex:index];
                cell.frame = frame;
                if (cell.superview == nil) {
                    [self.scrollView addSubview:cell];
                }
            }
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.delegate listViewShouldSettleAtMargin:self] && fabsf(velocity.x) > 0.1) {
        // set the x value to the nearest margin
        CGPoint nearestMargin = [self nearestMarginToPoint:(*targetContentOffset) withVelocity:velocity];
        targetContentOffset->x = nearestMargin.x;
    }
}

@end