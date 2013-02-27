//
//  ControlSortView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "ControlSortView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ControlSortView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = DEFAULT_SORT_CONTROL_BGCOLOR;
        
        CGFloat y = 6;
        latestBtn = [UIButton buttonWithType:100];
        latestBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
        latestBtn.frame = CGRectMake(10, 6, 50, 20);
        [latestBtn setTitle:@"Latest" forState:UIControlStateNormal];
        [latestBtn addTarget:self action:@selector(tapLatest)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:latestBtn];
        
        mostViewBtn = [UIButton buttonWithType:100];
        mostViewBtn.frame = CGRectMake(75, 6, 80, 20);
        mostViewBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
        [mostViewBtn setTitle:@"Most View" forState:UIControlStateNormal];
        [mostViewBtn addTarget:self action:@selector(tapMostView)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostViewBtn];
        
        mostDLBtn = [UIButton buttonWithType:100];
        mostDLBtn.frame = CGRectMake(165, 6, 80, 20);
        mostDLBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
        [mostDLBtn setTitle:@"Most DL" forState:UIControlStateNormal];
        [mostDLBtn addTarget:self action:@selector(tapMostDL)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostDLBtn];
        
        
        relateBtn = [UIButton buttonWithType:100];
        relateBtn.frame = CGRectMake(245, 6, 70, 20);
        relateBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR;
        [relateBtn setTitle:@"Relative" forState:UIControlStateNormal];
        [relateBtn addTarget:self action:@selector(tapRelative)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:relateBtn];
        
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(1.0, 2.0);
        
    }
    return self;
}

- (void)sortChange:(NSString*)sortType {
    if (_delegate && [_delegate respondsToSelector:@selector(sortChange:)]) {
        [_delegate sortChange:sortType];
    }
}

- (void)tapRelative {
    [self allResetButtonSelected];
    relateBtn.tintColor = DEFAULT_SORT_CONTROL_BUTTON_COLOR_SELECTED;
    [self sortChange:@"relevance"];
}

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

@end
