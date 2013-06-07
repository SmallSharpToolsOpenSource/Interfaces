//
//  SSTHomeViewController.m
//  PagingDogs
//
//  Created by Brennan Stehling on 5/29/13.
//  Copyright (c) 2013 SmallSharpTools. All rights reserved.
//

#import "SSTHomeViewController.h"

#import "SSTPageViewController.h"
#import "SSTPhotoViewController.h"

#define kMaxIndex       5

@interface SSTHomeViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goButtonBottomConstraint;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@end

@implementation SSTHomeViewController {
    NSUInteger currentIndex;
}

#pragma mark - View Lifecycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.pageViewController) {
        self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
        self.pageViewController.delegate = self;
        self.pageViewController.dataSource = self;
        [self addChildViewController:self.pageViewController];
        [self.view addSubview:self.pageViewController.view];
        self.pageViewController.view.frame = CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        [self.view sendSubviewToBack:self.pageViewController.view];
        [self.pageViewController didMoveToParentViewController:self];
        
        [self.pageViewController transitionStyle];
    }
    
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:currentIndex]]
                     direction:UIPageViewControllerNavigationDirectionForward
                      animated:NO
                    completion:NULL];
    
    self.goButton.hidden = TRUE;
    self.goButton.alpha = 0.0;
    self.goButtonBottomConstraint.constant = -100.0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateForPosition];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self scheduleMove];
}

#pragma mark - User Actions
#pragma mark -

- (IBAction)goButtonTapped:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.flickr.com/search/?q=dogs&l=cc&ss=0&ct=0&mt=photos&w=all&adv=1"]];
}

#pragma mark - UIPageViewControllerDelegate
#pragma mark -

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    MAAssert(pageViewController.viewControllers.count, @"There must be VCs");
    SSTPhotoViewController *vc = (SSTPhotoViewController *)pageViewController.viewControllers[0];
    currentIndex = vc.index;
    [self updateForPosition];
}

#pragma mark - UIPageViewControllerDataSource
#pragma mark -

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    [self cancelScheduledMove];
    [self scheduleMove];
    
    SSTPhotoViewController *vc = (SSTPhotoViewController *)viewController;
    if (vc.index > 0) {
        return [self photoViewControllerForIndex:vc.index - 1];
    }
    else {
        return [self photoViewControllerForIndex:kMaxIndex];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    [self cancelScheduledMove];
    [self scheduleMove];
    
    SSTPhotoViewController *vc = (SSTPhotoViewController *)viewController;
    if (vc.index < kMaxIndex) {
        return [self photoViewControllerForIndex:vc.index + 1];
    }
    else {
        return [self photoViewControllerForIndex:0];
    }
}

#pragma mark - Private
#pragma mark -

- (void)updateForPosition {
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState;
    NSUInteger index = currentIndex;
    self.pageControl.currentPage = currentIndex;
    
    if (currentIndex != kMaxIndex) {
        if (!self.goButton.hidden) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:1.0 delay:0.0 options:options animations:^{
                    self.goButton.alpha = 0.0;
                    self.goButtonBottomConstraint.constant = -100.0;
                    [self.view setNeedsLayout];
                    [self.view layoutIfNeeded];
                } completion:^(BOOL finished) {
                    self.goButton.hidden = TRUE;
                    if (currentIndex != index) {
                        [self updateForPosition];
                    }
                }];
            });
        }
    }
    else {
        self.goButton.hidden = FALSE;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 delay:0.0 options:options animations:^{
                self.goButton.alpha = 1.0;
                self.goButtonBottomConstraint.constant = 20.0;
                [self.view setNeedsLayout];
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                if (currentIndex != index) {
                    [self updateForPosition];
                }
            }];
        });
    }
}

- (void)scheduleMove {
    [self performSelector:@selector(moveToNextPosition) withObject:nil afterDelay:3.0];
}

- (void)cancelScheduledMove {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveToNextPosition) object:nil];
}

- (void)moveToNextPosition {
    [self cancelScheduledMove];
    __weak SSTHomeViewController *weakSelf = self;
    
    if (currentIndex < kMaxIndex) {
        currentIndex++;
    }
    else {
        currentIndex = 0;
    }
    
    [self updateForPosition];
    [self.pageViewController setViewControllers:@[[self photoViewControllerForIndex:currentIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         [weakSelf scheduleMove];
                                     }];
}

- (SSTPhotoViewController *)photoViewControllerForIndex:(NSUInteger)index {
    SSTPhotoViewController *vc = (SSTPhotoViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    MAAssert(vc, @"VC must be defined");
    [vc prepareForIndex:index];
    return vc;
}

@end
