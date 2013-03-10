//
//  MySettingViewController.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MySettingViewController : NSObject

+ (MySettingViewController*)sharedInstance;

@property (nonatomic, strong) NSString *language;           // 対象言語
@property (nonatomic, strong) NSString *languageDisplay;    // 対象言語の表示文
@property (nonatomic, strong) NSString *target;             // 検索モード（nil:テキスト/tag:タグ）
@property (nonatomic, strong) NSString *targetDisplay;      // 検索モードの表示文
@property (nonatomic, strong) NSString *defaultSort;        // 標準の並び順
@property (nonatomic, strong) NSString *defaultSortDisplay; // 標準の並び順の表示文

- (void)saveMySettingLanguage;
- (void)saveMySettingTarget;
- (void)saveMySettingDefaultSort;

- (void)loadMySetting;

@end
