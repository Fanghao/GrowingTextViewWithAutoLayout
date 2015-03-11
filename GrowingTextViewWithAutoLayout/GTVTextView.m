//
//  GTVTextView.m
//  GrowingTextViewWithAutoLayout
//
//  Created by Fanghao Chen on 3/9/15.
//  Copyright (c) 2015 Fanghao Chen. All rights reserved.
//

#import "GTVTextView.h"

@interface GTVTextView()

@property (nonatomic) CGFloat initialHeight;
@property (nonatomic) NSInteger maxNumberOfLinesToDisplay;

@end

@implementation GTVTextView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.font = [UIFont systemFontOfSize:18.f];
        self.returnKeyType = UIReturnKeyDone;
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        
        self.initialHeight = [self calculateInitialHeight];
        self.maxNumberOfLinesToDisplay = 2;
    }
    
    return self;
}

- (void)setMaxNumberOfLinesToDisplay:(NSInteger)maxNumberOfLinesToDisplay {
    _maxNumberOfLinesToDisplay = maxNumberOfLinesToDisplay;
    _initialHeight = [self calculateInitialHeight];
}

- (CGFloat)calculateInitialHeight {
    NSString *text = self.text;
    self.text = @"a";
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, 9999.f)];
    self.text = text;
    return size.height;
}

- (CGFloat)getMaxHeight {
    CGFloat buffer = self.font.lineHeight / 4.0f;
    return self.initialHeight + self.font.lineHeight * (self.maxNumberOfLinesToDisplay - 1) + buffer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.contentSize.height < [self getMaxHeight]) {
        self.contentOffset = CGPointZero;
    }
}

- (CGFloat)getHeightConstraint {
    CGSize size = [self sizeThatFits:CGSizeMake(self.bounds.size.width, 9999.f)];
    
    if (size.height > [self getMaxHeight]) {
        return [self getMaxHeight];
    } else {
        return size.height;
    }
}

@end
