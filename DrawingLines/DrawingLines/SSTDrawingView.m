//
//  SSTDrawingView.m
//  DrawingLines
//
//  Created by Brennan Stehling on 8/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTDrawingView.h"

float randomFloat(float min, float max){
    return ((arc4random()%RAND_MAX)/(RAND_MAX*1.0))*(max-min)+min;
}

#define kIntervalDuration   1.0f / 30.0f
#define kDidFinishSelector @selector(drawingViewDidFinishDrawing:)

@implementation SSTDrawingView {
    BOOL isDrawing;
    CGFloat start;
    CGFloat finish;
    CGFloat currentPosition;
}

- (void)drawLine {
    if (!isDrawing) {
        isDrawing = TRUE;
        currentPosition = 0.0f;
        start = randomFloat(0.5, 0.7);
        finish = randomFloat(0.3, 0.5);
        
        [NSTimer scheduledTimerWithTimeInterval:kIntervalDuration target:self selector:@selector(updateDrawing:) userInfo:nil repeats:YES];
    }
}

- (void)updateDrawing:(NSTimer*)timer {
    currentPosition += kIntervalDuration * 4;
    [self setNeedsDisplay];
    
    if (currentPosition >= 1.0f) {
        [timer invalidate];
        isDrawing = FALSE;
        if ([self.delegate respondsToSelector:kDidFinishSelector]) {
            [self.delegate performSelector:kDidFinishSelector withObject:self];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat height = CGRectGetHeight(rect);
    CGFloat width = CGRectGetWidth(rect);
    
    CGFloat startHeight = start * height;
    CGFloat finishHeight = finish * height;
    
    CGFloat difference = startHeight - finishHeight;
    
    CGFloat currentFinishHeight = startHeight - (difference * currentPosition);
  
    //// Color Declarations
    UIColor* strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0, startHeight)];
    [bezierPath addLineToPoint: CGPointMake(width * currentPosition, currentFinishHeight)];
    [strokeColor setStroke];
    bezierPath.lineWidth = 6;
    [bezierPath stroke];
}

@end
