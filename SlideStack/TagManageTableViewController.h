//
//  TagManageTableViewController.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagManageTableViewController : UITableViewController
<UISearchBarDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSMutableArray *filteredTags;

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *mySearchDisplayController;

@end
