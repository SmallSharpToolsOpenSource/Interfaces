//
//  SSTStackedItemView.m
//  Stacks
//
//  Created by Brennan Stehling on 7/12/13.
//  Copyright (c) 2013 SmallSharpTools LLC. All rights reserved.
//

#import "SSTStackedItemView.h"

#define kMaxLabelWidth      280

#define kUseConstraints     1

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
    
    CGFloat yPos = 0;
    if (kUseConstraints) {
        SSTStackedItemView *previousView = nil;
        for (SSTStackedItem *stackedItem in stackedItems) {
            SSTStackedItemView *stackedItemView = [SSTStackedItemView loadViewFromNib];
            [stackedItemView configureForStackedItem:stackedItem];
            CGFloat height = [SSTStackedItemView heightForViewWithStackedItem:stackedItem];
            yPos += height;
            stackedItemView.translatesAutoresizingMaskIntoConstraints = NO;
            [view addSubview:stackedItemView];
            
            if (!previousView) {
                // constrain view to top
                [SSTStackedItemView constrainViewToTopOfSuperview:stackedItemView withHeight:height];
            }
            else {
                // constrant current view to the previous view
                [SSTStackedItemView constraintView:stackedItemView toPreviousView:previousView withHeight:height];
            }

            previousView = stackedItemView;
        }
    }
    else {
        for (SSTStackedItem *stackedItem in stackedItems) {
            SSTStackedItemView *stackedItemView = [SSTStackedItemView loadViewFromNib];
            [stackedItemView configureForStackedItem:stackedItem];
            CGFloat height = [SSTStackedItemView heightForViewWithStackedItem:stackedItem];
            CGRect frame = CGRectMake(0, yPos, 320, height);
            stackedItemView.frame = frame;
            yPos += height;
            [view addSubview:stackedItemView];
        }
    }
    
    return yPos;
}

+ (void)constrainViewToTopOfSuperview:(UIView *)view withHeight:(CGFloat)height {
    // attach top to top, leading, trailing and then height

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [view.superview addConstraint:topConstraint];
    [view.superview addConstraint:leadingConstraint];
    [view.superview addConstraint:trailingConstraint];
    [view addConstraint:heightConstraint];
}

+ (void)constraintView:(UIView *)view toPreviousView:(UIView *)previousView withHeight:(CGFloat)height {
    // attach top to bottom, leading, trailing and then height
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:previousView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    
    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:view.superview attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [view.superview addConstraint:topConstraint];
    [view.superview addConstraint:leadingConstraint];
    [view.superview addConstraint:trailingConstraint];
    [view addConstraint:heightConstraint];
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
