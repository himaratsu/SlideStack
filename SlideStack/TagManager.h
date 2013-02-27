//
//  TagManager.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagManager : NSObject

// 2次元Array allTags[i][j]
// i -> 種類（あなたが追加したタグ, プログラミング, ...）
@property (nonatomic, strong) NSArray *allTags;
@property (nonatomic, strong) NSMutableArray *myOriginalTags;

+ (TagManager*)sharedInstance;

- (BOOL)addOriginalTag:(NSString*)originalTagName;   // タグを新規に追加
- (void)removeOriginalTag:(NSString*)originalTagName;  // タグを削除
- (void)updateCheckMarkState:(NSString*)tagName isCheck:(BOOL)isCheck;    // 指定したタグの選択状態を変更
- (NSArray*)checkedTagArray;    // 選択状態にあるタグリストを返す

@end
