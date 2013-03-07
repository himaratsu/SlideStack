//
//  HomeTableViewController.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendAPI.h"
#import "RecommendTagListView.h"
#import "RecommendSlideListView.h"
#import "SlideHistoryView.h"

@interface HomeTableViewController : UITableViewController
<HttpRequestDelegate, RecommendTagListViewDelegate, RecommendSlideViewDelegate, SlideHistoryViewPartsDelegate>
{
    BOOL isLoaded;  // ロード済みかどうか
}

@property (nonatomic, strong) RecommendTagListView *tagListView;    // タグリスト
@property (nonatomic, strong) RecommendSlideListView *slideListView;// スライドリスト
@property (nonatomic, strong) SlideHistoryView *histView;           // 履歴リスト
@property (nonatomic, strong) NSMutableArray *recommendTags;

@end
