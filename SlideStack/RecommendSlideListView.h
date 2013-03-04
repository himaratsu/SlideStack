//
//  RecommendSlideListView.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendSlideView.h"

@interface RecommendSlideListView : UIView <RecommendSlideViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id<RecommendSlideViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<RecommendSlideViewDelegate>)delegate;
- (void)startLoadingImages;

@end
