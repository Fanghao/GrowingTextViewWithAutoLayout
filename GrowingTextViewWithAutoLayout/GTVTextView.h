//
//  GTVTextView.h
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/9/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GTVTextView : UITextView

- (void)setMaxNumberOfLinesToDisplay:(NSInteger)maxNumberOfLinesToDisplay;
- (CGFloat)getHeightConstraint;

@end
