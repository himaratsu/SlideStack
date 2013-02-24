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
    }
    return self;
}


@end
