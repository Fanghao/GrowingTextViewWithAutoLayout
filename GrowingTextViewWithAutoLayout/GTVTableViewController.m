//
//  GTVTableViewController.m
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/9/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import "GTVTableViewController.h"
#import "GTVObject.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface GTVTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation GTVTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Growing Text Views in table view";
    
    [self setupDataModel];
    
    [self.tableView registerClass:[GTVTableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Self sizing table view cell
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 53.0f;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                           target:self
                                                                                           action:@selector(add)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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

- (void)setupDataModel {
    self.dataArray = [NSMutableArray array];
    
    GTVObject *firstObject = [GTVObject new];
    firstObject.title = @"Use the top right button to add more text views into the table view";
    
    GTVObject *secondObject = [GTVObject new];
    secondObject.title = @"Select a cell to start editing its text view";
    
    [self.dataArray addObjectsFromArray:@[firstObject, secondObject]];
}

- (void)add {
    [self.dataArray insertObject:[GTVObject new] atIndex:0];
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[firstIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:firstIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    GTVTableViewCell *cell = (GTVTableViewCell *)[self.tableView cellForRowAtIndexPath:firstIndexPath];
    [cell.textView becomeFirstResponder];
}

- (void)screenOrientationDidChange {
    // Relayout the cells
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GTVTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    GTVObject *object = self.dataArray[indexPath.row];
    cell.textView.text = object.title;
    
    cell.delegate = self;
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GTVTableViewCell *cell = (GTVTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    [cell.textView becomeFirstResponder];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Table view cell delegate

- (void)updateCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSString *title = ((GTVTableViewCell *)cell).textView.text;
    GTVObject *object = self.dataArray[indexPath.row];
    object.title = title;
    
    // Update the height of table view cell if necessary
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
