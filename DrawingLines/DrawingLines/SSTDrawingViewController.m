//
//  SSTDrawingViewController.m
//  DrawingLines
//
//  Created by Brennan Stehling on 8/11/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTDrawingViewController.h"

#import "SSTDrawingView.h"

@interface SSTDrawingViewController () <SSTDrawingViewDelegate>

@property (weak, nonatomic) IBOutlet SSTDrawingView *drawingView;

@end

@implementation SSTDrawingViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.drawingView drawLine];
}

#pragma mark - SSTDrawingViewDelegate
#pragma mark -

- (void)drawingViewDidFinishDrawing:(SSTDrawingView *)drawingView {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.drawingView drawLine];
    });
}

@end
