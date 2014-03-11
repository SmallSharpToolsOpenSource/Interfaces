//
//  SSTBlurryView.m
//  Slider
//
//  Created by Brennan Stehling on 3/4/14.
//  Copyright (c) 2014 SmallSharptools. All rights reserved.
//

#import "SSTBlurryView.h"

@implementation SSTBlurryView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    if ((self = [super initWithCoder:coder])) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UIColor *tintColor = self.backgroundColor;
    
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = TRUE;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toolbar.barTintColor = [tintColor colorWithAlphaComponent:0.75];
    [self insertSubview:toolbar atIndex:0];
}

@end
