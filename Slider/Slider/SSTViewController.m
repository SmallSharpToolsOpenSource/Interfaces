//
//  SSTViewController.m
//  Slider
//
//  Created by Brennan Stehling on 3/4/14.
//  Copyright (c) 2014 SmallSharptools. All rights reserved.
//

#import "SSTViewController.h"

#define kSideBarWidth 276

#define kRenderModeImage            @"image"
#define kRenderModeAccelerated      @"accelerated"
#define kRenderModeToolbar          @"toolbar"

#define RenderMode                  @"image"

@interface SSTViewController ()

@property (weak, nonatomic) IBOutlet UIView *screenView;

@property (weak, nonatomic) IBOutlet UIView *sideBarBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *sideBarBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *sideBarMenuView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sideBarBackgroundWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sideBarMenuTrailingConstraint;

@end

@implementation SSTViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // assert necessary outlets are defined
    NSCAssert(self.sideBarBackgroundView, @"Outlet is required");
    NSCAssert(self.sideBarBackgroundImageView, @"Outlet is required");
    NSCAssert(self.sideBarMenuView, @"Outlet is required");
    
    self.sideBarBackgroundView.backgroundColor = [UIColor clearColor];
    self.sideBarMenuView.backgroundColor = [UIColor clearColor];
    
    if ([RenderMode isEqualToString:kRenderModeImage]) {
        self.sideBarBackgroundImageView.image = [self backgroundImageView];
        self.sideBarBackgroundImageView.hidden = FALSE;
    }
    else if ([RenderMode isEqualToString:kRenderModeAccelerated]) {
    }
    else if ([RenderMode isEqualToString:kRenderModeToolbar]) {
        UIColor *tintColor = [UIColor colorWithRed:0.94 green:0.69 blue:0.49 alpha:0.85];
        self.sideBarBackgroundView.opaque = NO;
        self.sideBarBackgroundView.backgroundColor = [UIColor clearColor];
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.sideBarBackgroundView.bounds];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.translucent = TRUE;
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        toolbar.barTintColor = tintColor;
        [self.sideBarBackgroundView insertSubview:toolbar atIndex:0];
    }
    
    [self showHideSideBar:TRUE];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // hide sidebar if not hidden already
    if (![self isSideBarHidden]) {
        [self showHideSideBar:FALSE];
    }
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)showHideButtonTapped:(id)sender {
    [self showHideSideBar:TRUE];
}

- (IBAction)screenViewTapped:(id)sender {
    BOOL isHidden = [self isSideBarHidden];
    if (!isHidden) {
        [self showHideSideBar:TRUE];
    }
}

#pragma mark - Private Methods
#pragma mark -

- (BOOL)isSideBarHidden {
    return CGRectGetWidth(self.sideBarBackgroundView.frame) == 0;
}

- (void)showHideSideBar:(BOOL)animated {
    BOOL isHidden = [self isSideBarHidden];
    DebugLog(@"isHidden: %@", isHidden ? @"YES" : @"NO");
    
    CGFloat duration = animated ? 0.25 : 0.0;
    
    if (isHidden) {
        // Shown: background width is kSideBarWidth and trailing constraint is 0
        self.screenView.hidden = FALSE;
        self.screenView.alpha = 0.0;
        [UIView animateWithDuration:duration animations:^{
            self.sideBarBackgroundWidthConstraint.constant = kSideBarWidth;
            self.sideBarMenuTrailingConstraint.constant = 0;
            self.screenView.alpha = 1.0;
            
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            DebugLog(@"Shown");
            self.screenView.hidden = FALSE;
        }];
    }
    else {
        // Hidden: background width is 0 and trailing constraint is -kSideBarWidth
        [UIView animateWithDuration:duration animations:^{
            self.sideBarBackgroundWidthConstraint.constant = 0;
            self.sideBarMenuTrailingConstraint.constant = -1 * kSideBarWidth;
            self.screenView.alpha = 1.0;
            
            [self.view setNeedsLayout];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            DebugLog(@"Hidden");
            self.screenView.hidden = TRUE;
        }];
    }
}

- (UIImage *)backgroundImageView {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(276, 568), NO, 0.0f);
        
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* myColor1 = [UIColor colorWithRed: 0.945 green: 0.631 blue: 0.506 alpha: 1];
        UIColor* myColor2 = [UIColor colorWithRed: 0.993 green: 0.896 blue: 0.758 alpha: 1];
        
        //// Gradient Declarations
        NSArray* myGradientColors = [NSArray arrayWithObjects:
                                     (id)myColor1.CGColor,
                                     (id)[UIColor colorWithRed: 0.969 green: 0.763 blue: 0.632 alpha: 1].CGColor,
                                     (id)myColor2.CGColor, nil];
        CGFloat myGradientLocations[] = {0, 0.61, 1};
        CGGradientRef myGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)myGradientColors, myGradientLocations);
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 276, 568)];
        CGContextSaveGState(context);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, myGradient, CGPointMake(0, 284), CGPointMake(276, 284), 0);
        CGContextRestoreGState(context);
        
        
        //// Cleanup
        CGGradientRelease(myGradient);
        CGColorSpaceRelease(colorSpace);
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}

@end
