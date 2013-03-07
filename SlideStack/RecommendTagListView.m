//
//  RecommendTagListView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "RecommendTagListView.h"
#import "RecommendTagView.h"

@implementation RecommendTagListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setTagList:(NSMutableArray *)tagList {
    int x = MARGIN_LEFT_RIGHT;
    int y = MARGIN_UP_BOTTOM;
    _tagList = tagList;
    
    for (UIView *v in [self subviews]) {
        if ([v isKindOfClass:[RecommendTagView class]]) {
            [v removeFromSuperview];
        }
    }
    
    for (int i=0; i<[tagList count]; i++) {
        NSString *tag = [tagList objectAtIndex:i];
        RecommendTagView *tagView = [[RecommendTagView alloc] initWithTagName:tag];
        [tagView addTarget:self action:@selector(tapRecommendTag:)
          forControlEvents:UIControlEventTouchUpInside];
        
        CGRect frame = tagView.frame;
        frame.origin.x += x;
        
        // 画面内に収まらない場合は改行
        if (frame.origin.x + frame.size.width > 320-MARGIN_LEFT_RIGHT) {
            frame.origin.x = x = MARGIN_LEFT_RIGHT;
            y += 40;
        }
        frame.origin.y += y;
        tagView.frame = frame;
        [self addSubview:tagView];

        x += frame.size.width+10;
    }
    CGRect frame = self.frame;
    frame.size.height = [self heightForTagList];
}

- (CGFloat)heightForTagList {
    CGFloat h = MARGIN_UP_BOTTOM;
    int x=MARGIN_LEFT_RIGHT;
    
    for (int i=0; i<[_tagList count]; i++) {
        NSString *tag = [_tagList objectAtIndex:i];
        RecommendTagView *tagView = [[RecommendTagView alloc] initWithTagName:tag];
    
        CGRect frame = tagView.frame;
        
        // 最初の一回目
        if (h == MARGIN_UP_BOTTOM) {
            h += frame.size.height;
        }
    
        // 画面内に収まらない場合は改行
        if (x + frame.size.width > 320) {
            h += 40;
            x = MARGIN_LEFT_RIGHT;
        }
        
        x += frame.size.width+10;
    }
    h += MARGIN_UP_BOTTOM;
    
    return h;
}

- (void)tapRecommendTag:(RecommendTagView*)sender {
    if ([_delegate respondsToSelector:@selector(didTapRecomeendTag:)]) {
        [_delegate didTapRecomeendTag:sender.tagName];
    }
}

@end
