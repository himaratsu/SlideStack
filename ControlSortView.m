//
//  ControlSortView.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "ControlSortView.h"

@implementation ControlSortView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
        
        UIButton *relateBtn = [UIButton buttonWithType:100];
        relateBtn.frame = CGRectMake(10, 5, 70, 20);
        [relateBtn setTitle:@"Relative" forState:UIControlStateNormal];
        [relateBtn addTarget:self action:@selector(tapRelative)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:relateBtn];
        
        UIButton *mostViewBtn = [UIButton buttonWithType:100];
        mostViewBtn.frame = CGRectMake(85, 5, 80, 20);
        [mostViewBtn setTitle:@"Most View" forState:UIControlStateNormal];
        [mostViewBtn addTarget:self action:@selector(tapMostView)
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostViewBtn];
        
        UIButton *mostDLBtn = [UIButton buttonWithType:100];
        mostDLBtn.frame = CGRectMake(175, 5, 80, 20);
        [mostDLBtn setTitle:@"Most DL" forState:UIControlStateNormal];
        [mostDLBtn addTarget:self action:@selector(tapMostDL)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mostDLBtn];
        
        UIButton *latestBtn = [UIButton buttonWithType:100];
        latestBtn.frame = CGRectMake(255, 5, 50, 20);
        [latestBtn setTitle:@"Latest" forState:UIControlStateNormal];
        [latestBtn addTarget:self action:@selector(tapLatest)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:latestBtn];
    }
    return self;
}

- (void)sortChange:(NSString*)sortType {
    if (_delegate && [_delegate respondsToSelector:@selector(sortChange:)]) {
        [_delegate sortChange:sortType];
    }
}

- (void)tapRelative {
    [self sortChange:@"relevance"];
}

- (void)tapMostView {
    [self sortChange:@"mostviewed"];
}

- (void)tapMostDL {
    [self sortChange:@"mostdownloaded"];
}

- (void)tapLatest {
    [self sortChange:@"latest"];
}


@end
