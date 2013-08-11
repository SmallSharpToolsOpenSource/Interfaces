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

@implementation SSTDrawingView {
    BOOL drawingStarted;
    CGFloat start;
    CGFloat finish;
    CGFloat drawingProgress;
}

- (id)initWithFrame:(CGRect)frame {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // this is where the animation will be started
    
    [self startDrawing];
}

- (void)startDrawing {
    if (!drawingStarted) {
        drawingStarted = TRUE;
        drawingProgress = 0.0f;
        start = randomFloat(0.5, 0.7);
        finish = randomFloat(0.3, 0.5);
        
        [NSTimer scheduledTimerWithTimeInterval:kIntervalDuration target:self selector:@selector(updateDrawing:) userInfo:nil repeats:YES];
    }
}

- (void)updateDrawing:(NSTimer*)timer {
    drawingProgress += kIntervalDuration * 4;
    [self setNeedsDisplay];
    
    if (drawingProgress >= 1.0f) {
        [timer invalidate];
        drawingStarted = FALSE;
        [self performSelector:@selector(startDrawing) withObject:nil afterDelay:0.75];
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
    
    CGFloat currentFinishHeight = startHeight - (difference * drawingProgress);
  
    //// Color Declarations
    UIColor* strokeColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    //// Bezier Drawing
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(0, startHeight)];
    [bezierPath addLineToPoint: CGPointMake(width * drawingProgress, currentFinishHeight)];
    [strokeColor setStroke];
    bezierPath.lineWidth = 6;
    [bezierPath stroke];
}

@end
