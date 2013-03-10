//
//  RecommendSlideListView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "RecommendSlideListView.h"

@implementation RecommendSlideListView

- (id)initWithFrame:(CGRect)frame delegate:(id<RecommendSlideViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 250, 200)];
        _scrollView.clipsToBounds = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        self.delegate = delegate;
        
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    
    for (UIView *v in [_scrollView subviews]) {
        if ([v isKindOfClass:[RecommendSlideView class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i=0; i<[_dataArray count]; i++) {
        SlideShowObject *slide = [_dataArray objectAtIndex:i];
        
        RecommendSlideView *slideView = [[RecommendSlideView alloc] initWithFrame:CGRectMake(50+250*i, 0, 220, 200)];
        slideView.slide = slide;
        slideView.delegate = self;
        [_scrollView addSubview:slideView];
    }
    
    _scrollView.contentSize = CGSizeMake(250*[_dataArray count], 200);
}

- (void)startLoadingImages {
    for (UIView *v in [_scrollView subviews]) {
        if ([v isKindOfClass:[RecommendSlideView class]]) {
            [((RecommendSlideView*)v).thumbnailImage startLoadImage];
        }
    }
}

- (void)didTapRecommendSlide:(SlideShowObject *)slide {
    if ([_delegate respondsToSelector:@selector(didTapRecommendSlide:)]) {
        [_delegate didTapRecommendSlide:slide];
    }
}

@end
