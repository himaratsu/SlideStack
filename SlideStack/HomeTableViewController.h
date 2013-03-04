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

@interface HomeTableViewController : UITableViewController
<HttpRequestDelegate, RecommendTagListViewDelegate>
{
    RecommendTagListView *tagListView;
}

@end
