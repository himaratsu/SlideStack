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

@property (nonatomic, strong) NSString *language;   // 対象言語
@property (nonatomic, strong) NSString *target;     // 検索モード（0:テキスト/1;タグ）
@property (nonatomic, strong) NSString *targetDisplay;   // 検索モードの表示文

@end
