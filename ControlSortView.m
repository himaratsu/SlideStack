//
//  ControlSortView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "ControlSortView.h"
#import "IIViewDeckController.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControlSortView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_SORT_CONTROL_BGCOLOR_ALPHA;
        
        CGFloat x = 10;
        CGFloat y = 6;
        
        latestBtn = [UIButton buttonWithType:100];
        latestBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
        latestBtn.frame = CGRectMake(x, y, 0, 20);
        [latestBtn setTitle:@"Latest" forState:UIControlStateNormal];
        [latestBtn addTarget:self action:@selector(tapLatest)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:latestBtn];
        
        mostViewBtn = [UIButton buttonWithType:100];
        mostViewBtn.frame = CGRectMake(x+60, y
                                       , 90, 20);
        mostViewBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
        [mostViewBtn setTitle:@"Most View" forState:UIControlStateNormal];
        [mostViewBtn addTarget:self action:@selector(tapMostView)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostViewBtn];
        
        mostDLBtn = [UIButton buttonWithType:100];
        mostDLBtn.frame = CGRectMake(x+145, y, 80, 20);
        mostDLBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
        [mostDLBtn setTitle:@"Most DL" forState:UIControlStateNormal];
        [mostDLBtn addTarget:self action:@selector(tapMostDL)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostDLBtn];
        
        addTagButton = [UIButton buttonWithType:100];
        addTagButton.frame = CGRectMake(260, y, 20, 20);
        [addTagButton setTitle:@"+Tag" forState:UIControlStateNormal];
        [addTagButton addTarget:self action:@selector(tapAddTag)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addTagButton];
        
        
//        relateBtn = [UIButton buttonWithType:100];
//        relateBtn.frame = CGRectMake(245, 6, 70, 20);
//        relateBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
//        [relateBtn setTitle:@"Relative" forState:UIControlStateNormal];
//        [relateBtn addTarget:self action:@selector(tapRelative)
//            forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:relateBtn];
//        
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOffset = CGSizeMake(1.0, 2.0);
        
    }
    return self;
}

// ソートボタンが押された
- (void)sortChange:(NSString*)sortType {
    if (_delegate && [_delegate respondsToSelector:@selector(sortChange:)]) {
        [_delegate sortChange:sortType];
    }
}

// タグボタンが押された
- (void)tapAddTag {
    if (_delegate && [_delegate respondsToSelector:@selector(tapAddTagButton)]) {
        [_delegate tapAddTagButton];
    }
}


//- (void)tapRelative {
//    [self allResetButtonSelected];
//    relateBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
//    [self sortChange:@"relevance"];
//}

- (void)tapMostView {
    [self allResetButtonSelected];
    mostViewBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    [self sortChange:@"mostviewed"];
}

- (void)tapMostDL {
    [self allResetButtonSelected];
    mostDLBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    [self sortChange:@"mostdownloaded"];
}

- (void)tapLatest {
    [self allResetButtonSelected];
    latestBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    [self sortChange:@"latest"];
}

- (void)allResetButtonSelected {
    relateBtn.tintColor
    = mostViewBtn.tintColor
    = mostDLBtn.tintColor
    = latestBtn.tintColor
    = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
}

- (void)selectSort:(NSString *)sortType {
    // 全選択解除
    [self allResetButtonSelected];
    
    if ([sortType isEqualToString:@"latest"]) {
        latestBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    }
    else if ([sortType isEqualToString:@"mostviewed"]) {
        mostViewBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    }
    else if ([sortType isEqualToString:@"mostdownloaded"]) {
        mostDLBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    }
}

// タグボタンの状態を切り替える
- (void)highlightTagButton:(BOOL)isHighlight {
    if (isHighlight) {
        // 既に追加済み
        addTagButton.frame = CGRectMake(250, 6, 20, 20);
        addTagButton.tintColor = [UIColor grayColor];
        [addTagButton setTitle:@"Added" forState:UIControlStateNormal];
    }
    else {
        // まだ追加されてない
        addTagButton.frame = CGRectMake(260, 6, 20, 20);
        addTagButton.tintColor = [UIColor colorWithRed:108/255.0 green:226/255.0 blue:108/255.0 alpha:1.0];
        [addTagButton setTitle:@"+Tag" forState:UIControlStateNormal];
    }
}

@end
