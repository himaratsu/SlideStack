//
//  TagManageTableViewController.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ALERT_VIEW_TAG_CREATE_NEW_TAG   500

@interface TagManageTableViewController : UITableViewController
<UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) NSMutableArray *filteredTags;
@property (nonatomic, strong) UITextField *textFieldNewTagName;

@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *mySearchDisplayController;

@end
