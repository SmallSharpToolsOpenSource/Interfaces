//
//  IFMainViewController.m
//  MultipleStoryboards
//
//  Created by Brennan Stehling on 4/7/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "IFMainViewController.h"

#pragma mark - Class Extension
#pragma mark -

@interface IFMainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableDictionary *storyboards;

@end

@implementation IFMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.storyboards = [[NSMutableDictionary alloc] init];
}

#pragma mark - Private
#pragma mark -

- (void)loadAndPushStoryboardWithName:(NSString *)name {
    UIStoryboard *storyboard = self.storyboards[name];
    
    if (!storyboard) {
        DebugLog(@"Loading %@", name);
        storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
        NSAssert(storyboard != nil, @"Storyboard must be defined. Invalid name?");
        if (storyboard) {
            // store the storyboard to use again
            self.storyboards[name] = storyboard;
        }
    }
    else {
        DebugLog(@"Reusing %@", name);
    }
    
    UIViewController *initialVC = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:initialVC animated:TRUE];
}

#pragma mark - UITableViewDataSource
#pragma mark -

// table is static with 3 rows

#pragma mark - UITableViewDelegate
#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DebugLog(@"row: %i", indexPath.row);
    
    NSString *storyboardName = [NSString stringWithFormat:@"Section%iStoryboard", indexPath.row + 1];
    
    [self loadAndPushStoryboardWithName:storyboardName];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    });
}

@end
