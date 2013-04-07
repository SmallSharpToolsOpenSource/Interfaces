//
//  SSTViewController.m
//  TextAllTheThings
//
//  Created by Brennan Stehling on 3/8/13.
//  Copyright (c) 2013 SmallSharptools LLC. All rights reserved.
//

#import "SSTViewController.h"

@interface SSTViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation SSTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.textView.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor grayColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSDictionary *blackAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
    NSDictionary *redAttributes = @{NSForegroundColorAttributeName : [UIColor redColor]};
    NSDictionary *blueAttributes = @{NSForegroundColorAttributeName : [UIColor blueColor]};
    
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Black. " attributes:blackAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Blue. " attributes:blueAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Red. " attributes:redAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Black. " attributes:blackAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Blue. " attributes:blueAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Red. " attributes:redAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Black. " attributes:blackAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Blue. " attributes:blueAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Red. " attributes:redAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Black. " attributes:blackAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Blue. " attributes:blueAttributes]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"This is Red. " attributes:redAttributes]];
    
    self.textView.attributedText = attributedString;
    
    CGFloat maxWidth = CGRectGetWidth(self.textView.frame);
    DebugLog(@"maxWidth: %f", maxWidth);
    maxWidth = 280.0;
//    CGFloat height = [self heightForFont:self.textView.font withWidth:maxWidth andAttributedString:attributedString];
    CGFloat height = [self heightForFont:self.textView.font withWidth:maxWidth andString:[attributedString string]];
    self.textViewHeightConstraint.constant = height;
}

- (CGFloat)heightForFont:(UIFont *)font withWidth:(CGFloat)width andAttributedString:(NSAttributedString *)attributedString {
    CGSize maximumSize = CGSizeMake(width,9999);

//    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGRect frame = [attributedString boundingRectWithSize:maximumSize options:NSStringDrawingUsesDeviceMetrics context:nil];
    
    DebugLog(@"height: %f", frame.size.height);
    
    return frame.size.height;
}

- (CGFloat)heightForFont:(UIFont *)font withWidth:(CGFloat)width andString:(NSString *)string {
    CGSize maximumSize = CGSizeMake(width,9999);
    CGSize size = [string sizeWithFont:font
                   constrainedToSize:maximumSize
                       lineBreakMode:NSLineBreakByTruncatingTail];
    
    return size.height;
}

@end
