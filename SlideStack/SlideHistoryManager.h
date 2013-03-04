//
//  SlideHistoryManager.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/04.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideShowObject.h"

@interface SlideHistoryManager : NSObject

@property (nonatomic, strong) NSMutableArray *historyList;

+ (SlideHistoryManager*)sharedInstance;

- (void)appendHistoryList:(SlideShowObject*)slide;
- (void)saveSlideHisotry;
- (NSMutableArray*)loadSlideHistory;

@end
