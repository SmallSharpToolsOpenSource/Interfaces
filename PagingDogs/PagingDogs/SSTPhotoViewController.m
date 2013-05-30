//
//  SSTPhotoViewController.m
//  PagingDogs
//
//  Created by Brennan Stehling on 5/29/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTPhotoViewController.h"

@interface SSTPhotoViewController ()

@property (assign, readwrite, nonatomic) NSUInteger index;

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *captionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomShadowImageView;

@end

@implementation SSTPhotoViewController

- (NSString *)description {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    return [NSString stringWithFormat:@"%@ (%i)", NSStringFromClass([self class]), self.index];
}

- (void)viewDidLoad {
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    [super viewDidLoad];
    
    MAAssert(self.photoImageView, @"IBOutlet must be defined");
    self.photoImageView.image = [UIImage imageNamed:@"dog1.jpg"];
    
    self.bottomShadowImageView.image = [self bottomShadowImage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *imageName = [NSString stringWithFormat:@"dog%i.jpg", self.index + 1];
    DebugLog(@"imageName: %@", imageName);
    UIImage *image = [UIImage imageNamed:imageName];
    self.photoImageView.image = image;
    
    
    switch (self.index) {
        case 0:
            self.captionLabel.text = @"Are you ready...";
            break;
        case 1:
            self.captionLabel.text = @"to relax by the lake...";
            break;
        case 2:
            self.captionLabel.text = @"play ball...";
            break;
        case 3:
            self.captionLabel.text = @"take in some sun..";
            break;
        case 4:
            self.captionLabel.text = @"get face time...";
            break;
        case 5:
            self.captionLabel.text = @"and take a joy ride?";
            break;
            
        default:
            break;
    }
    
}

#pragma mark - Public
#pragma mark -

- (void)prepareForIndex:(NSUInteger)index {
    self.index = index;
}

#pragma mark - Private
#pragma mark -

- (UIImage *)bottomShadowImage {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(320.0, 200.0), NO, 0.0f);
        
        //// General Declarations
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //// Color Declarations
        UIColor* clear = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0];
        UIColor* shadow = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 0.707];
        
        //// Gradient Declarations
        NSArray* shadowGradientColors = [NSArray arrayWithObjects:
                                         (id)shadow.CGColor,
                                         (id)clear.CGColor, nil];
        CGFloat shadowGradientLocations[] = {0, 1};
        CGGradientRef shadowGradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)shadowGradientColors, shadowGradientLocations);
        
        //// Rectangle Drawing
        UIBezierPath* rectanglePath = [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 320, 200)];
        CGContextSaveGState(context);
        [rectanglePath addClip];
        CGContextDrawLinearGradient(context, shadowGradient, CGPointMake(160, 200), CGPointMake(160, -0), 0);
        CGContextRestoreGState(context);
        
        
        //// Cleanup
        CGGradientRelease(shadowGradient);
        CGColorSpaceRelease(colorSpace);
        
        
        
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    });
    return image;
}

@end
