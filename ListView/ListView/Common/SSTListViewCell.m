//
//  SSTListViewCell.m
//  ListView
//
//  Created by Brennan Stehling on 7/24/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTListViewCell.h"

#pragma mark - Class Extension
#pragma mark -

@interface SSTListCell ()

@property(nonatomic, readwrite, copy) NSString *reuseIdentifier;

@end


#pragma mark -

@implementation SSTListCell

#pragma mark - Initialization
#pragma mark -

- (id)initWithFrame:(CGRect)frame andReuseIdentifier:(NSString *)aReuseIdentifier {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.reuseIdentifier = aReuseIdentifier;
        
        UINib *cellNib = [UINib nibWithNibName:[self nibName] bundle:nil];
        [cellNib instantiateWithOwner:self options:nil];
        
        self.frame = self.content.frame;
        [self addSubview:self.content];
    }
    return self;
}

#pragma mark - Implementation
#pragma mark -

- (NSString *)nibName {
    return NSStringFromClass([self class]);
}

- (void)prepareForReuse {
    // method to inherit and override
}

- (void)deactivate {
    // method to inherit and override
}

- (void)verifyIntegrity {
    // method to inherit and override
}

@end
