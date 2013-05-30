//
//  SSTFlatButton.m
//  PagingDogs
//
//  Created by Brennan Stehling on 5/29/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTFlatButton.h"

#pragma mark - Class Extension
#pragma mark -

@interface SSTFlatButton ()

@property (strong, nonatomic) UIColor *originalBackgroundColor;

@end

@implementation SSTFlatButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        self.originalBackgroundColor = self.backgroundColor;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self setBackgroundImage:[self drawnBackgroundImageWithSize:self.frame.size] forState:UIControlStateNormal];
}

- (UIImage *)drawnBackgroundImageWithSize:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, size.width, size.height)];
    [self.originalBackgroundColor setFill];
    [rectanglePath fill];

    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        
    return image;
}

@end
