//
//  TagWithCheckMarkObject.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagWithCheckMarkObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *tagName;    // タグ名
@property (nonatomic, assign) BOOL      isChecked;  // チェックされているかどうか（デフォルトNO）

- (id)initWithTagName:(NSString*)tagName;
- (id)initWithTagName:(NSString *)tagName isChecked:(BOOL)isChecked;

@end
