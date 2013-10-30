//
//  SSTBaseViewController.m
//  Keyboarding
//
//  Created by Brennan Stehling on 8/19/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTBaseViewController.h"

@interface SSTBaseViewController ()

@end

@implementation SSTBaseViewController

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShowNotification:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHideNotification:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

#pragma mark - Notifications
#pragma mark -

- (void)keyboardWillShowNotification:(NSNotification *)notification {
	CGFloat height = [self getKeyboardHeight:notification forBeginning:TRUE];
	NSTimeInterval duration = [self getDuration:notification];
    UIViewAnimationOptions curve = [self getAnimationCurve:notification];
    
    [self keyboardWillShowWithHeight:height duration:duration curve:curve];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification {
	CGFloat height = [self getKeyboardHeight:notification forBeginning:FALSE];
	NSTimeInterval duration = [self getDuration:notification];
    UIViewAnimationOptions curve = [self getAnimationCurve:notification];
    
    [self keyboardWillHideWithHeight:height duration:duration curve:curve];
}

- (void)keyboardDidShowNotification:(NSNotification *)notification {
    [self keyboardDidShow];
}

- (void)keyboardDidHideNotification:(NSNotification *)notification {
    [self keyboardDidHide];
}

#pragma mark - Keyboard Methods to Override
#pragma mark -

- (void)keyboardWillShowWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    // override
}

- (void)keyboardWillHideWithHeight:(CGFloat)height duration:(CGFloat)duration curve:(UIViewAnimationOptions)curve {
    // override
}

- (void)keyboardDidShow {
    // override
}

- (void)keyboardDidHide {
    // override
}

#pragma mark - Private
#pragma mark -

- (NSTimeInterval)getDuration:(NSNotification *)notification {
	NSDictionary *info = [notification userInfo];
	
	NSTimeInterval duration;
	
	NSValue *durationValue = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	[durationValue getValue:&duration];
	
	return duration;
}

- (CGFloat)getKeyboardHeight:(NSNotification *)notification forBeginning:(BOOL)forBeginning {
	NSDictionary *info = [notification userInfo];
	
	CGFloat keyboardHeight;
    
    NSValue *boundsValue = nil;
    if (forBeginning) {
        boundsValue = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    }
    else {
        boundsValue = [info valueForKey:UIKeyboardFrameEndUserInfoKey];
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(orientation)) {
        keyboardHeight = [boundsValue CGRectValue].size.width;
    }
    else {
        keyboardHeight = [boundsValue CGRectValue].size.height;
    }
    
	return keyboardHeight;
}

- (UIViewAnimationOptions)getAnimationCurve:(NSNotification *)notification {
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            break;
    }
    
    return kNilOptions;
}

@end
