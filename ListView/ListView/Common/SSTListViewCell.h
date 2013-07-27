//
//  SSTListViewCell.h
//  ListView
//
//  Created by Brennan Stehling on 7/24/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTListCell : UIView

@property (assign, nonatomic) IBOutlet UIView *content;
@property (readonly, copy, nonatomic) NSString *reuseIdentifier;

- (id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)aReuseIdentifier;

- (NSString *)nibName;

- (void)prepareForReuse;
- (void)deactivate;
- (void)verifyIntegrity;

@end
