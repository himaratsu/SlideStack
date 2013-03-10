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
        [self loadMySetting];
    }
    return self;
}

- (void)setLanguage:(NSString *)language {
    _language = language;
    if ([_language isEqualToString:@"**"]) {
        _languageDisplay = NSLocalizedString(@"All", nil);
    }
    else if ([_language isEqualToString:@"ja"]) {
        _languageDisplay = NSLocalizedString(@"Japanese", nil);
    }
    else if ([_language isEqualToString:@"en"]) {
        _languageDisplay = NSLocalizedString(@"English", nil);
    }
    [self saveMySettingLanguage];
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
    [self saveMySettingLanguage];
}

- (void)setTarget:(NSString *)target {
    _target = target;
    if (_target == nil) {
        _targetDisplay = NSLocalizedString(@"Title+Contents", nil);
    }
    else if ([_target isEqualToString:@"tag"]) {
        _targetDisplay = NSLocalizedString(@"Tag", nil);
    }
    [self saveMySettingTarget];
}

- (void)setTargetDisplay:(NSString *)targetDisplay {
    _targetDisplay = targetDisplay;
    if ([targetDisplay isEqualToString:NSLocalizedString(@"Title+Contents", nil)]) {
        _target = nil;
    }
    else if ([targetDisplay isEqualToString:NSLocalizedString(@"Tag", nil)]) {
        _target = @"tag";
    }
    [self saveMySettingTarget];
}

- (void)setDefaultSort:(NSString *)defaultSort {
    _defaultSort = defaultSort;
    if ([_defaultSort isEqualToString:@"latest"]) {
        _defaultSortDisplay = NSLocalizedString(@"Latest", nil);
    }
    else if ([_defaultSort isEqualToString:@"mostviewed"]) {
        _defaultSortDisplay = NSLocalizedString(@"MostView", nil);
    }
    else if ([_defaultSort isEqualToString:@"mostdownloaded"]) {
        _defaultSortDisplay = NSLocalizedString(@"MostDownLoad", nil);
    }
    [self saveMySettingDefaultSort];
}

- (void)setDefaultSortDisplay:(NSString *)defaultSortDisplay {
    _defaultSortDisplay = defaultSortDisplay;
    if ([_defaultSortDisplay isEqualToString:NSLocalizedString(@"Latest", nil)]) {
        _defaultSort = @"latest";
    }
    else if ([_defaultSortDisplay isEqualToString:NSLocalizedString(@"MostView", nil)]) {
        _defaultSort = @"mostviewed";
    }
    else if ([_defaultSortDisplay isEqualToString:NSLocalizedString(@"MostDownLoad", nil)]) {
        _defaultSort = @"mostdownloaded";
    }
    [self saveMySettingDefaultSort];
}


// 初回起動、スライドの検索対象をどうするか
- (void)defaultLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    NSLog(@"currentLanguage: %@", currentLanguage);
    
    if ([currentLanguage isEqualToString:@"ja"]) {
        // デフォルト日本語（スライドの対象も日本のスライド）
        self.language        = @"ja";
        self.languageDisplay = NSLocalizedString(@"Japanese", nil);
    } else {
        self.language        = @"**";
        self.languageDisplay = NSLocalizedString(@"All", nil);
    }
}

// データ保存

- (void)saveMySettingLanguage {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.language forKey:@"Language"];
    [defaults synchronize];
}

- (void)saveMySettingTarget {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.target forKey:@"Target"];
    [defaults synchronize];
}

- (void)saveMySettingDefaultSort {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.defaultSort forKey:@"DefaultSort"];
    [defaults synchronize];
}

// データ読込
- (void)loadMySetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL notFirstSetting = [defaults boolForKey:@"NotFirstSetting"];   // 初回起動かどうか（NOなら初回起動）
    
    if (notFirstSetting == NO) {
        [self setDefaultSetting];
    }
    else {
        self.language = [defaults objectForKey:@"Language"];
        self.target = [defaults objectForKey:@"Target"];
        self.defaultSort = [defaults objectForKey:@"DefaultSort"];
    }
}

// デフォルト設定を反映
- (void)setDefaultSetting {
    self.targetDisplay = NSLocalizedString(@"Tag", nil);
    self.defaultSortDisplay = NSLocalizedString(@"Latest", nil);
    
    // 端末の言語設定によってデフォルト値を変更する
    [self defaultLanguage];
    
    [self saveMySettingLanguage];
    [self saveMySettingTarget];
    [self saveMySettingDefaultSort];
    
    // 初回起動フラグを折っておく
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"NotFirstSetting"];
    [defaults synchronize];
}

@end
