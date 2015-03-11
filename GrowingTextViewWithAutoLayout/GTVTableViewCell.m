//
//  GTVTableViewCell.m
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/9/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import "GTVTableViewCell.h"
#import "PureLayout.h"

#define kTextViewHorizontalInsets      15.0f
#define kTextViewVerticalInsets        10.0f
#define kTextViewHeight                33.0f // estimated

@interface GTVTableViewCell()

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation GTVTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.didSetupConstraints = NO;

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    self.textView = [[GTVTextView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  [UIScreen mainScreen].bounds.size.width - kTextViewHorizontalInsets * 2,
                                                                  kTextViewHeight)];
    self.textView.delegate = self;
    
    // Uncomment following line to set the number of lines desired to display
    //[self.textView setMaxNumberOfLinesToDisplay:3];
    
    [self.contentView addSubview:self.textView];
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (!self.didSetupConstraints) {
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.textView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [UIView autoSetPriority:UILayoutPriorityDefaultHigh forConstraints:^{
            self.heightConstraint = [self.textView autoSetDimension:ALDimensionHeight toSize:kTextViewHeight];
        }];
        
        [self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kTextViewVerticalInsets,
                                                                               kTextViewHorizontalInsets,
                                                                               kTextViewVerticalInsets,
                                                                               kTextViewHorizontalInsets)];
        
        self.didSetupConstraints = YES;
    }
    
    // Calculate height constraint every time
    self.heightConstraint.constant = [self.textView getHeightConstraint];
}

#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.userInteractionEnabled = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    textView.userInteractionEnabled = NO;
    [textView setContentOffset:CGPointZero animated:YES];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
    [self.delegate updateCell:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
