//
//  SSTListViewController.m
//  ListView
//
//  Created by Brennan Stehling on 7/24/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTListViewController.h"

@interface SSTListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *firstCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *secondCollectionView;

@property (strong, nonatomic) NSArray *items;

@end

@implementation SSTListViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.items = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    self.firstCollectionView.allowsMultipleSelection = YES;
    self.secondCollectionView.allowsMultipleSelection = YES;
    
    self.firstCollectionView.contentInset = UIEdgeInsetsMake(0, 1, 0, 1);
    
    // don't let the empty cells show
    self.secondCollectionView.contentInset = UIEdgeInsetsMake(0, -230, 0, -230);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
//    if (self.secondCollectionView.contentOffset.x == 0) {
//        self.secondCollectionView.contentOffset = CGPointMake(150, 0);
//    }

}

#pragma mark - Private
#pragma mark -

- (BOOL)isSimpleCell:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath {
    if (self.secondCollectionView == collectionView) {
        // the first and last cell in the second collection view will use the empty cell
        if (indexPath.row == 0 || indexPath.row == self.items.count + 1) {
            return FALSE;
        }
    }
    
    return TRUE;
}

#pragma mark - UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.firstCollectionView == collectionView) {
        return self.items.count;
    }
    else {
        return self.items.count + 2;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isSimpleCell:collectionView atIndexPath:indexPath]) {
        NSUInteger index = indexPath.row - (self.secondCollectionView == collectionView ? 1 : 0);
        MAAssert(self.items.count > index, @"Count must be greater than row");
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimpleCell" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:1];
        NSNumber *number = self.items[index];
        label.text = [NSString stringWithFormat:@"%@", number];
        label.textColor = cell.selected ? [UIColor lightGrayColor] : [UIColor whiteColor];
        
        return cell;
    }
    else {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"EmptyCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate
#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.textColor = [UIColor lightGrayColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.textColor = [UIColor whiteColor];
}

@end
