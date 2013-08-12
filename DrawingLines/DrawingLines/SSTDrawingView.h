//
//  SSTDrawingView.h
//  DrawingLines
//
//  Created by Brennan Stehling on 8/10/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSTDrawingViewDelegate;

@interface SSTDrawingView : UIView

@property (weak, nonatomic) IBOutlet id<SSTDrawingViewDelegate> delegate;

- (void)drawLine;

@end

@protocol SSTDrawingViewDelegate <NSObject>

@optional

- (void)drawingViewDidFinishDrawing:(SSTDrawingView *)drawingView;

@end