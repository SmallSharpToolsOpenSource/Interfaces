//
//  SSTPhotoViewController.h
//  PagingDogs
//
//  Created by Brennan Stehling on 5/29/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTPhotoViewController : UIViewController

@property (readonly, nonatomic) NSUInteger index;

- (void)prepareForIndex:(NSUInteger)index;

@end
