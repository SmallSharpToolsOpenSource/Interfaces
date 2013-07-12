//
//  SSTViewController.m
//  Stacks
//
//  Created by Brennan Stehling on 7/12/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTStackedViewController.h"

#import "SSTStackedItem.h"
#import "SSTStackedItemView.h"

#pragma mark - Class Extension
#pragma mark -

@interface SSTStackedViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewHeightConstraint;

@end

@implementation SSTStackedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    NSArray *strings = @[
                         @"Vinyl labore squid Tonx. Banjo literally bicycle rights actually wolf sint. Kogi tattooed deserunt, Echo Park aliquip Wes Anderson enim cray stumptown id et.",
                         @"Pug Tonx keytar plaid elit Etsy, Williamsburg Echo Park iPhone raw denim direct trade typewriter.",
                         @"Wolf helvetica Bushwick, nihil ethical raw denim four loko actually minim consectetur bitters kogi you probably haven't heard of them fashion axe.",
                         @"Meggings tousled assumenda, beard pork belly placeat irony church-key voluptate pop-up lomo. Tote bag ea fap whatever roof party.",
                         @"Placeat minim artisan stumptown, cray culpa occaecat disrupt gastropub blog laboris elit. Nulla meggings aliquip elit craft beer.",
                         @"Before they sold out leggings sapiente, meggings laborum try-hard brunch occupy Schlitz eu.",
                         @"Laborum tousled twee, wolf fashion axe yr intelligentsia kogi anim trust fund shoreditch vinyl nisi consequat swag."
                         ];

    NSMutableArray *stackedItems = [@[] mutableCopy];
    for (NSString *string in strings) {
        SSTStackedItem *stackedItem = [[SSTStackedItem alloc] init];
        stackedItem.text = string;
        [stackedItems addObject:stackedItem];
    }
    
    CGFloat totalHeight = [SSTStackedItemView stackItems:stackedItems inView:self.containerView];
    DebugLog(@"totalHeight: %f", totalHeight);
    
    self.containerViewHeightConstraint.constant = totalHeight;
    [self.containerView setNeedsLayout];
    [self.containerView layoutIfNeeded];
}

@end
