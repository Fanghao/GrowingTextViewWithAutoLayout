//
//  GTVViewController.m
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/10/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import "GTVViewController.h"
#import "GTVTextView.h"
#import "PureLayout.h"

#define kViewInsets         20.0f
#define kTextViewHeight     33.0f // estimated

@interface GTVViewController ()

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) GTVTextView *textView;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@implementation GTVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Single Growing Text View";
    
    [self setupViews];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.textView becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(screenOrientationDidChange)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:nil];
}

- (void)setupViews {
    self.backgroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundView];
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.containerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.containerView];
    
    self.textView = [[GTVTextView alloc] initWithFrame:CGRectMake(0,
                                                                  0,
                                                                  [UIScreen mainScreen].bounds.size.width - kViewInsets * 4,
                                                                  kTextViewHeight)];
    self.textView.delegate = self;
    [self.textView setMaxNumberOfLinesToDisplay:3];
    [self.containerView addSubview:self.textView];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (!self.didSetupConstraints) {
        
        [self.backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
        
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kViewInsets * 4];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kViewInsets];
        [self.containerView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kViewInsets];
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            [self.textView autoSetContentCompressionResistancePriorityForAxis:ALAxisVertical];
        }];
        
        [UIView autoSetPriority:UILayoutPriorityRequired forConstraints:^{
            self.heightConstraint = [self.textView autoSetDimension:ALDimensionHeight toSize:kTextViewHeight];
        }];
        
        [self.textView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(kViewInsets,
                                                                               kViewInsets,
                                                                               kViewInsets,
                                                                               kViewInsets)];
        
        self.didSetupConstraints = YES;
    }
    
    self.heightConstraint.constant = [self.textView getHeightConstraint];
}

- (void)screenOrientationDidChange {
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
}

#pragma mark - UITextView delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView setContentOffset:CGPointZero animated:YES];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.view setNeedsUpdateConstraints];
    [self.view updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


@end
