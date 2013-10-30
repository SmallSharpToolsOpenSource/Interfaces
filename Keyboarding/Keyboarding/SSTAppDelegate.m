//
//  SSTAppDelegate.m
//  Keyboarding
//
//  Created by Brennan Stehling on 8/19/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTAppDelegate.h"

@implementation SSTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (isiOS7OrLater) {
        UIColor *foregroundColor = [UIColor whiteColor];
        UIColor *backgroundColor = [UIColor colorWithRed:0.04 green:0.70 blue:0.99 alpha:0.75];
        [[UINavigationBar appearance] setBarTintColor:backgroundColor];
        
        NSDictionary *textAttributes = @{ NSForegroundColorAttributeName : foregroundColor };
        [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
        
        self.window.tintColor = [UIColor darkGrayColor];
    }

    return YES;
}

@end
