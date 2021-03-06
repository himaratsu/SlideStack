//
//  SlideHistoryView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/04.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideHistoryView.h"
#import "SlideHistoryManager.h"
#import "SlideShowObject.h"


@implementation SlideHistoryView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 85)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        self.zeroMatchLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, self.frame.size.width, 20)];
        _zeroMatchLabel.text = NSLocalizedString(@"No History", @"閲覧履歴はまだありません");
        _zeroMatchLabel.backgroundColor = [UIColor clearColor];
        _zeroMatchLabel.textColor = [UIColor grayColor];
        _zeroMatchLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_zeroMatchLabel];
        _zeroMatchLabel.hidden = YES;
        
        self.dataArray = [NSMutableArray array];
        
        [self reload];
    }
    return self;
}

- (void)reload {
    _zeroMatchLabel.hidden = YES;
    self.dataArray = [[SlideHistoryManager sharedInstance] historyList];
    
    if ([_dataArray count] == 0) {
        _zeroMatchLabel.hidden = NO;
        return;
    }
    
    for (UIView *v in [_scrollView subviews]) {
        if ([v isKindOfClass:[SlideHistoryViewParts class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i=0; i<[_dataArray count]; i++) {
        SlideShowObject *d = [_dataArray objectAtIndex:i];
        SlideHistoryViewParts *parts = [[SlideHistoryViewParts alloc] initWithFrame:CGRectMake(10+110*i, 0, 100, 70)];
        parts.delegate = self;
        parts.slide = d;
        parts.thumbView.imageUrl = [NSURL URLWithString:d.thumbnailUrl];
        [parts.thumbView startLoadImage];
        
        [_scrollView addSubview:parts];
    }
    _scrollView.contentSize = CGSizeMake(10+110*[_dataArray count], 85);
}


- (void)didTapSlideHistory:(SlideShowObject *)slide {
    if ([_delegate respondsToSelector:@selector(didTapSlideHistory:)]) {
        [_delegate didTapSlideHistory:slide];
    }
}

@end
