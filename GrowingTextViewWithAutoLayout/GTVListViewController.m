//
//  GTVListViewController.m
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/10/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import "GTVListViewController.h"
#import "GTVTableViewController.h"
#import "GTVViewController.h"
#import "PureLayout.h"

#define kButtonInsets         20.0f
#define kButtonHeight         44.0f

@interface GTVListViewController ()

@property (nonatomic) BOOL didSetupConstraints;
@property (nonatomic, strong) UIButton *tableViewButton;
@property (nonatomic, strong) UIButton *singleViewButton;

@end

@implementation GTVListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Growing Text View Demo";
    
    [self setupViews];
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableViewButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.tableViewButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.tableViewButton setTitle:@"Growing text views in table view" forState:UIControlStateNormal];
    [self.tableViewButton addTarget:self action:@selector(tableViewButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableViewButton];
    
    self.singleViewButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.singleViewButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.singleViewButton setTitle:@"A single growing text view" forState:UIControlStateNormal];
    [self.singleViewButton addTarget:self action:@selector(singleViewButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.singleViewButton];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    if (!self.didSetupConstraints) {
        
        [self.tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kButtonInsets * 4];
        [self.tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kButtonInsets];
        [self.tableViewButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kButtonInsets];
        [self.tableViewButton autoSetDimension:ALDimensionHeight toSize:kButtonHeight];
        
        [self.singleViewButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.tableViewButton withOffset:kButtonInsets];
        [self.singleViewButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kButtonInsets];
        [self.singleViewButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kButtonInsets];
        [self.singleViewButton autoSetDimension:ALDimensionHeight toSize:kButtonHeight];
        
        self.didSetupConstraints = YES;
    }
}

- (void)tableViewButtonPressed {
    [self.navigationController pushViewController:[[GTVTableViewController alloc] init] animated:YES];
}

- (void)singleViewButtonPressed {
    [self.navigationController pushViewController:[[GTVViewController alloc] init] animated:YES];
}

@end
