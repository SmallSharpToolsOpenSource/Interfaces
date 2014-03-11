//
//  SSTTapSlider.m
//  TapSlider
//
//  Created by Brennan Stehling on 3/8/14.
//  Copyright (c) 2014 SmallSharpTools. All rights reserved.
//

#import "SSTTapSlider.h"

@implementation SSTTapSlider

#pragma mark - Initialization
#pragma mark -

-  (id)initWithFrame:(CGRect)aRect {
    self = [super initWithFrame:aRect];
    
    if (self) {
        [self initializeTapSlider];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initializeTapSlider];
    }
    
    return self;
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)sliderGestureRecognized:(id)sender {
    [self handleSliderGestureRecognizer:(UIGestureRecognizer *)sender];
}

#pragma mark - Private
#pragma mark -

- (void)initializeTapSlider {
    [self modifySlider:self];
}

- (void)modifySlider:(UISlider *)slider {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGestureRecognized:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(sliderGestureRecognized:)];
    slider.gestureRecognizers = @[tapGestureRecognizer, panGestureRecognizer];
}

- (void)handleSliderGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if ([recognizer.view isKindOfClass:[UISlider class]]) {
        UISlider *slider = (UISlider *)recognizer.view;
        CGPoint point = [recognizer locationInView:recognizer.view];
        CGFloat width = CGRectGetWidth(slider.frame);
        CGFloat percentage = point.x / width;
        
        // new value is based on the slider's min and max values which
        // could be different with each slider
        float newValue = ((slider.maximumValue - slider.minimumValue) * percentage) + slider.minimumValue;
        [slider setValue:newValue animated:TRUE];
        DebugLog(@"newValue: %f", newValue);
    }
}

@end
