//
//  SSTStackedItemView.m
//  Stacks
//
//  Created by Brennan Stehling on 7/12/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTStackedItemView.h"

#define kMaxLabelWidth      280

@implementation SSTStackedItemViewOwner
@end

#pragma mark - Class Extension
#pragma mark -

@interface SSTStackedItemView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stackedItemLabelHeightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *stackedItemLabel;

@property (strong, nonatomic) SSTStackedItem *stackedItem;

@end

@implementation SSTStackedItemView

#pragma mark - View Lifecycle
#pragma mark -

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    [self logFonts];
}

+ (instancetype)loadViewFromNib {
    SSTStackedItemViewOwner *owner = [[SSTStackedItemViewOwner alloc] init];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([SSTStackedItemView class]) bundle:nil];
    [nib instantiateWithOwner:owner options:nil];
    SSTStackedItemView *stackedView = owner.stackedView;
    owner.stackedView = nil;
    owner = nil;
    
    return stackedView;
}

- (void)configureForStackedItem:(SSTStackedItem *)stackedItem {
    self.stackedItem = stackedItem;
    
    NSAttributedString *attributedString = [SSTStackedItemView attributedStringForStackedItem:stackedItem];
    CGFloat height = [SSTStackedItemView heightForAttributedString:attributedString withMaxWidth:kMaxLabelWidth];
    self.stackedItemLabel.attributedText = attributedString;
    self.stackedItemLabelHeightConstraint.constant = height;
}

+ (CGFloat)stackItems:(NSArray *)stackedItems inView:(UIView *)view {
//    DebugLog(@"%@", NSStringFromSelector(_cmd));
    
    CGFloat yPos = 0;
    for (SSTStackedItem *stackedItem in stackedItems) {
//        DebugLog(@"stackedItem: %@", stackedItem.text);
        SSTStackedItemView *stackedItemView = [SSTStackedItemView loadViewFromNib];
        
        stackedItemView.translatesAutoresizingMaskIntoConstraints = YES;
        
        MAAssert(stackedItemView, @"View must be defined");
        [stackedItemView configureForStackedItem:stackedItem];
        CGFloat height = [SSTStackedItemView heightForViewWithStackedItem:stackedItem];
        CGRect frame = CGRectMake(0, yPos, 320, height);
        stackedItemView.frame = frame;
        yPos += height;
        [view addSubview:stackedItemView];
    }
    
    return yPos;
}

- (void)logFonts {
    for (id familyName in [UIFont familyNames]) {
        DebugLog(@"Family Name: %@", familyName);
        for (id fontName in [UIFont fontNamesForFamilyName:familyName]) {
            DebugLog(@"Font Name: %@", fontName);
        }
    }
}


#pragma mark - Private
#pragma mark -

+ (NSAttributedString *)attributedStringForStackedItem:(SSTStackedItem *)stackedItem {
    NSString *text = stackedItem.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSDictionary *prefixTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Noteworthy-Bold" size:16],
                                            NSForegroundColorAttributeName : [UIColor darkGrayColor]};

    NSAttributedString *prefixAttributedString = [[NSAttributedString alloc] initWithString:@"NOTE: "
                                                                               attributes:prefixTextAttributes];
    
    [attributedString appendAttributedString:prefixAttributedString];
    
    NSDictionary *regularTextAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"Noteworthy-Light" size:16],
                                     NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    
    NSAttributedString *textAttributedString = [[NSAttributedString alloc] initWithString:text
                                                                               attributes:regularTextAttributes];
    
    [attributedString appendAttributedString:textAttributedString];
    
    return attributedString;
}

+ (CGFloat)heightForViewWithStackedItem:(SSTStackedItem *)stackedItem {
    NSAttributedString *str = [SSTStackedItemView attributedStringForStackedItem:stackedItem];
    CGFloat labelHeight = [SSTStackedItemView heightForAttributedString:str withMaxWidth:kMaxLabelWidth];
    
    return labelHeight + 40;
}

+ (CGFloat)heightForAttributedString:(NSAttributedString *)attribuedString withMaxWidth:(CGFloat)maxWidth {
    CGRect rect = [attribuedString boundingRectWithSize:CGSizeMake(maxWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    
    return CGRectGetHeight(rect);
}

@end
