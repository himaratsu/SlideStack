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
        self.target   = nil;
        self.targetDisplay = NSLocalizedString(@"Tag", nil);
        self.defaultSort = nil;
        self.defaultSortDisplay = NSLocalizedString(@"Latest", nil);
        
        // 端末の言語設定によってデフォルト値を変更する
        [self changeLanguage];
    }
    return self;
}

- (void)setLanguageDisplay:(NSString *)languageDisplay {
    _languageDisplay = languageDisplay;
    if ([_languageDisplay isEqualToString:NSLocalizedString(@"All", nil)]) {
        _language = @"**";
    }
    else if ([_languageDisplay isEqualToString:NSLocalizedString(@"Japanese", nil)]) {
        _language = @"ja";
    }
    else if ([_languageDisplay isEqualToString:NSLocalizedString(@"English", nil)]) {
        _language = @"en";
    }
}

- (void)setTargetDisplay:(NSString *)targetDisplay {
    _targetDisplay = targetDisplay;
    if ([targetDisplay isEqualToString:NSLocalizedString(@"Title+Contents", nil)]) {
        _target = nil;
    }
    else if ([targetDisplay isEqualToString:NSLocalizedString(@"Tag", nil)]) {
        _target = @"tag";
    }
}

- (void)setDefaultSortDisplay:(NSString *)defaultSortDisplay {
    _defaultSortDisplay = defaultSortDisplay;
    if ([_defaultSortDisplay isEqualToString:NSLocalizedString(@"Latest", nil)]) {
        _defaultSort = @"latest";
    }
    else if ([_defaultSortDisplay isEqualToString:NSLocalizedString(@"MostView", nil)]) {
        _defaultSort = @"mostviewed";
    }
    else if ([_defaultSortDisplay isEqualToString:NSLocalizedString(@"MostDownload", nil)]) {
        _defaultSort = @"mostdownloaded";
    }
}

- (void)changeLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog(@"currentLanguage: %@", currentLanguage);
    
    if ([currentLanguage isEqualToString:@"ja"]) {
        // デフォルト日本語（スライドの対象も日本のスライド）
        self.languageDisplay = NSLocalizedString(@"Japanese", nil);
    } else {
        self.languageDisplay = NSLocalizedString(@"All", nil);
    }
}

@end
