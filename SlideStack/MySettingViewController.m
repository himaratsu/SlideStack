//
//  MySettingViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "MySettingViewController.h"

@implementation MySettingViewController

static MySettingViewController *sharedInstance = nil;

+ (MySettingViewController *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[MySettingViewController alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.language = @"ja";
        self.target   = nil;
        self.targetDisplay = @"タグ";
        self.defaultSort = nil;
        self.defaultSortDisplay = @"Latest";
    }
    return self;
}

- (void)setTargetDisplay:(NSString *)targetDisplay {
    _targetDisplay = targetDisplay;
    if ([targetDisplay isEqualToString:@"タイトル+本文"]) {
        _target = nil;
    }
    else if ([targetDisplay isEqualToString:@"タグ"]) {
        _target = @"tag";
    }
}

- (void)setDefaultSortDisplay:(NSString *)defaultSortDisplay {
    _defaultSortDisplay = defaultSortDisplay;
    if ([_defaultSortDisplay isEqualToString:@"Latest"]) {
        _defaultSort = @"latest";
    }
    else if ([_defaultSortDisplay isEqualToString:@"MostView"]) {
        _defaultSort = @"mostviewed";
    }
    else if ([_defaultSortDisplay isEqualToString:@"MostDownload"]) {
        _defaultSort = @"mostdownloaded";
    }
}

@end
