//
//  SlideHistoryManager.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/04.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideHistoryManager.h"

@implementation SlideHistoryManager

static SlideHistoryManager *sharedInstance = nil;

+ (SlideHistoryManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[SlideHistoryManager alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.historyList = [self loadSlideHistory];
    }
    return self;
}

// スライドを追加
- (void)appendHistoryList:(SlideShowObject*)slide {
    NSInteger index = [self isExistSlide:slide];
    
    if (index == -1) {
        // まだ存在しないスライド
        // なにもしない
    }
    else {
        // 既に存在する場合、古いものを消して新しいスライドを追加
        [_historyList removeObjectAtIndex:index];
    }
    
    // 最大数を超えないよう調整
    if ([_historyList count] >= 20) {
        [_historyList removeObjectAtIndex:[_historyList count]-1];
    }
    
    [_historyList insertObject:slide atIndex:0];
    [self saveSlideHisotry];
}

// スライドが既に存在するかチェック
- (NSInteger)isExistSlide:(SlideShowObject*)newSlide {
    for (int i=0; i<[_historyList count]; i++) {
        SlideShowObject *slide = [_historyList objectAtIndex:i];
        if ([slide.slideId isEqualToString:newSlide.slideId]) {
            return i;
        }
    }
    return -1;
}

// スライド履歴の保存
- (void)saveSlideHisotry {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:_historyList];
    [defaults setObject:savedData forKey:@"SlideHisotryList"];
    [defaults synchronize];
}

// スライド履歴の読込
- (NSMutableArray *)loadSlideHistory {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *loadData = [defaults objectForKey:@"SlideHisotryList"];
    NSMutableArray *loadArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadData];
    if (loadArray) {
        return loadArray;
    } else {
        return [NSMutableArray array];
    }
}


@end
