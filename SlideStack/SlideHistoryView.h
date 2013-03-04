//
//  SlideHistoryView.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/04.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideHistoryViewParts.h"

@interface SlideHistoryView : UIView <SlideHistoryViewPartsDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *zeroMatchLabel;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id<SlideHistoryViewPartsDelegate> delegate;

- (void)reload;

@end
