//
//  RecommendTagView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "RecommendTagView.h"
#import <QuartzCore/QuartzCore.h>

@implementation RecommendTagView

- (id)initWithTagName:(NSString *)tagName {
    self = [super init];
    
    if (self) {
        self.tagName = tagName;
        self.displayTagName = [NSString stringWithFormat:@"#%@", tagName];
        
        // サイズを計算
        CGSize size = [_displayTagName sizeWithFont:TAG_DEFAULT_FONT
                          constrainedToSize:CGSizeMake(320, CGFLOAT_MAX)];
        self.frame = CGRectMake(0, 0, size.width+10, size.height+6);
        
        // タグの背景色
        self.backgroundColor = TAG_DEFAULT_BGCOLOR;
        
        // タグの線
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = TAG_DEFAULT_BORDERCOLOR;
        self.layer.cornerRadius = 3.0;
        
        // ラベルの設定
        _tagNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 3, size.width, size.height)];
        _tagNameLabel.text = _displayTagName;
        _tagNameLabel.font = TAG_DEFAULT_FONT;
        _tagNameLabel.textColor = TAG_DEFAULT_FONTCOLOR;
        _tagNameLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_tagNameLabel];
        
        // ハイライト時のビュー
        _highlightedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _highlightedView.backgroundColor = [UIColor grayColor];
        _highlightedView.alpha = 0.6;
        _highlightedView.layer.cornerRadius = self.layer.cornerRadius;
        _highlightedView.hidden = YES;
        [self addSubview:_highlightedView];
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:YES];
    _highlightedView.hidden = !highlighted;
}

@end
