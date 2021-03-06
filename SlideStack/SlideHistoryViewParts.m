//
//  SlideHistoryViewParts.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/04.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideHistoryViewParts.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideHistoryViewParts

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbView = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 4, self.frame.size.width, self.frame.size.height)];
        _thumbView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _thumbView.layer.borderWidth = 1.0f;
        _thumbView.layer.shadowColor = [UIColor grayColor].CGColor;
        _thumbView.layer.shadowOffset = CGSizeMake(0, 2);
        _thumbView.layer.shadowRadius = 1;
        _thumbView.layer.shadowOpacity = 0.3;
        _thumbView.layer.cornerRadius = 2.0;
        _thumbView.layer.masksToBounds = YES;
        [self addSubview:_thumbView];
        
        // ハイライト時のビュー
        _highlightedView = [[UIView alloc] initWithFrame:CGRectMake(-4, 0, self.frame.size.width+8, self.frame.size.height+8)];
        _highlightedView.backgroundColor = [UIColor grayColor];
        _highlightedView.alpha = 0.6;
        _highlightedView.layer.cornerRadius = self.layer.cornerRadius;
        _highlightedView.hidden = YES;
        [self addSubview:_highlightedView];
        
        [self addTarget:self action:@selector(didTapSlideHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)didTapSlideHistory {
    if ([_delegate respondsToSelector:@selector(didTapSlideHistory:)]) {
        [_delegate didTapSlideHistory:self.slide];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:YES];
    _highlightedView.hidden = !highlighted;
}

@end
