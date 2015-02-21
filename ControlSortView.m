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
//        self.backgroundColor = DEFAULT_SORT_CONTROL_BGCOLOR_ALPHA;
        self.backgroundColor = [UIColor blackColor];

        UIImage *latestImage = [UIImage imageNamed:@"sort_button_latest.png"];
        UIImage *latestImageHigh = [UIImage imageNamed:@"sort_button_latest_highlight.png"];
        latestBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 74, 40)];
        [latestBtn setImage:latestImage forState:UIControlStateNormal];
        [latestBtn setImage:latestImageHigh forState:UIControlStateSelected];
        [latestBtn addTarget:self action:@selector(tapLatest) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:latestBtn];
        
        UIImage *mostViewImage = [UIImage imageNamed:@"sort_button_mview.png"];
        UIImage *mostViewImageHigh = [UIImage imageNamed:@"sort_button_mview_highlight.png"];
        mostViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(74, 0, 74, 40)];
        [mostViewBtn setImage:mostViewImage forState:UIControlStateNormal];
        [mostViewBtn setImage:mostViewImageHigh forState:UIControlStateSelected];
        [mostViewBtn addTarget:self action:@selector(tapMostView)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostViewBtn];
    
        UIImage *mostDownloadImage = [UIImage imageNamed:@"sort_button_mdl.png"];
        UIImage *mostDownloadImageHigh = [UIImage imageNamed:@"sort_button_mdl_highlight.png"];
        mostDLBtn = [[UIButton alloc] initWithFrame:CGRectMake(148, 0, 74, 40)];
        [mostDLBtn setImage:mostDownloadImage forState:UIControlStateNormal];
        [mostDLBtn setImage:mostDownloadImageHigh forState:UIControlStateSelected];
        [mostDLBtn addTarget:self action:@selector(tapMostDL)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostDLBtn];

        UIImageView *brankBG = [[UIImageView alloc] initWithFrame:CGRectMake(222, 0, 104, 40)];
        brankBG.image = [UIImage imageNamed:@"sort_button_none.png"];
        [self addSubview:brankBG];
        
        UIImage *tagAddOffImage = [UIImage imageNamed:@"tag_add_off.png"];
        UIImage *tagRemoveOffImage = [UIImage imageNamed:@"tag_remove_off.png"];
        addTagButton = [[UIButton alloc] initWithFrame:CGRectMake(235, 6, 76, 28)];
        [addTagButton setImage:tagAddOffImage forState:UIControlStateNormal];
        [addTagButton setImage:tagRemoveOffImage forState:UIControlStateSelected];
        [addTagButton addTarget:self action:@selector(tapAddTag)
               forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:addTagButton];
        
        selectBorder = [[UIView alloc] initWithFrame:CGRectMake(3, 37, 69, 3)];
        selectBorder.backgroundColor = [UIColor colorWithRed:255/255.0 green:159/255.0 blue:58/255.0 alpha:1.0];
        [self addSubview:selectBorder];
        
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


- (void)moveSelectBorderAtIndex:(NSInteger)index {
    [UIView animateWithDuration:0.3f animations:^(void){
        selectBorder.frame = CGRectMake(3 + 74*index, 37, 69, 3);
    }];
}

- (void)tapLatest {
    [self allResetButtonSelected];
    latestBtn.selected = YES;
    [self moveSelectBorderAtIndex:0];
    [self sortChange:@"latest"];
}

- (void)tapMostView {
    [self allResetButtonSelected];
    mostViewBtn.selected = YES;
    [self moveSelectBorderAtIndex:1];
    [self sortChange:@"mostviewed"];
}

- (void)tapMostDL {
    [self allResetButtonSelected];
    mostDLBtn.selected = YES;
    [self moveSelectBorderAtIndex:2];
    [self sortChange:@"mostdownloaded"];
}


- (void)allResetButtonSelected {
    latestBtn.selected = mostViewBtn.selected = mostDLBtn.selected = NO;
}

- (void)selectSort:(NSString *)sortType {
    // 全選択解除
    [self allResetButtonSelected];
    
    if ([sortType isEqualToString:@"latest"]) {
        latestBtn.selected = YES;
        [self moveSelectBorderAtIndex:0];
    }
    else if ([sortType isEqualToString:@"mostviewed"]) {
        mostViewBtn.selected = YES;
        [self moveSelectBorderAtIndex:1];
    }
    else if ([sortType isEqualToString:@"mostdownloaded"]) {
        mostDLBtn.selected = YES;
        [self moveSelectBorderAtIndex:2];
    }
}

// タグボタンの状態を切り替える
- (void)highlightTagButton:(BOOL)isHighlight {
    if (isHighlight) {
        // 既に追加済み
        addTagButton.selected = YES;
    }
    else {
        // まだ追加されてない
        addTagButton.selected = NO;
    }
}

@end
