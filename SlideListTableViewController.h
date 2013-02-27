//
//  SlideListTableViewController.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SlideSearchAPI.h"
#import "ControlSortView.h"

@interface SlideListTableViewController : UITableViewController
<HttpRequestDelegate, ControlSortViewDelegate>
{
    BOOL _isLoading;                // いまAPIと通信中かどうか
    BOOL _isScrollTopAfterLoad;     // アイテム更新後、トップにスクロールするかどうか
    BOOL _isMoreSlide;              // もっと読込するアイテムが残っているかどうか
    UIRefreshControl *_refreshControl;  // 「引っ張って更新」
    ControlSortView *_sortControlView;  // ソート操作ビュー
}

@property (nonatomic, strong) NSMutableArray *slideArray;

@property (nonatomic, assign) NSString *searchWord; // 検索キーワード
@property (nonatomic, assign) NSInteger page;       // ページング用
@property (nonatomic, assign )NSString *sortType;   // 並び順の指定

@end
