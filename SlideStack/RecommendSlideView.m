//
//  RecommendSlideView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "RecommendSlideView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RecommendSlideView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.thumbnailImage = [[CustomImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 160)];
        _thumbnailImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _thumbnailImage.layer.borderWidth = 1.0f;
        _thumbnailImage.layer.shadowColor = [UIColor grayColor].CGColor;
        _thumbnailImage.layer.shadowOffset = CGSizeMake(0, 2);
        _thumbnailImage.layer.shadowRadius = 1;
        _thumbnailImage.layer.shadowOpacity = 0.3;
        _thumbnailImage.layer.cornerRadius = 2.0;
        _thumbnailImage.layer.masksToBounds = YES;
        [self addSubview:_thumbnailImage];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, 220, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];

        [self addTarget:self action:@selector(didTapRecommendSlide) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setSlide:(SlideShowObject *)slide {
    _slide = slide;
    
    // 画像
    _thumbnailImage.imageUrl = [NSURL URLWithString:_slide.thumbnailUrl];
    [_thumbnailImage startLoadImage];
    [self addSubview:_thumbnailImage];
    
    // タイトル
    CGSize size = [_slide.title sizeWithFont:[UIFont systemFontOfSize:16.0f]
                           constrainedToSize:CGSizeMake(220, CGFLOAT_MAX)];
    CGRect frame = _titleLabel.frame;
    frame.size.height = size.height;
    _titleLabel.frame = frame;
    _titleLabel.text = _slide.title;
}

- (void)didTapRecommendSlide {
    if ([_delegate respondsToSelector:@selector(didTapRecommendSlideWithUrl:title:)]) {
        [_delegate didTapRecommendSlideWithUrl:_slide.url title:_slide.title];
    }
}

@end
