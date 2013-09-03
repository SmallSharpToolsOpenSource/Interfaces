//
//  SSTGrowingImageView.h
//  GrowingImageView
//
//  Created by Brennan Stehling on 8/15/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTGrowingImageView : UIImageView

- (void)growFullImageView:(BOOL)animated;
- (void)shrinkFullImageView:(BOOL)animated;

@end
