//
//  GTVTableViewCell.h
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/9/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTVTextView.h"

@protocol GTVTableViewCellDelegate <NSObject>

- (void)updateCell:(UITableViewCell *)cell;

@end

@interface GTVTableViewCell : UITableViewCell <UITextViewDelegate>

@property (nonatomic, strong) GTVTextView *textView;
@property (nonatomic, weak) id<GTVTableViewCellDelegate> delegate;

@end
