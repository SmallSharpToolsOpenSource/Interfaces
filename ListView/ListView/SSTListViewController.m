//
//  SSTListViewController.m
//  ListView
//
//  Created by Brennan Stehling on 7/24/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTListViewController.h"

@interface SSTListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) NSArray *items;

@end

@implementation SSTListViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [super viewDidLoad];
    
    self.items = @[@1, @2, @3, @4, @5, @6, @7, @8, @9, @10];
    self.collectionView.allowsMultipleSelection = YES;
}

#pragma mark - UICollectionViewDataSource
#pragma mark -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SimpleCell" forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    NSNumber *number = self.items[indexPath.row];
    label.text = [NSString stringWithFormat:@"%@", number];
    label.textColor = cell.selected ? [UIColor lightGrayColor] : [UIColor whiteColor];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
#pragma mark -

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"selected %i", indexPath.row);
    
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.textColor = [UIColor lightGrayColor];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    label.textColor = [UIColor whiteColor];
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark -

@end
