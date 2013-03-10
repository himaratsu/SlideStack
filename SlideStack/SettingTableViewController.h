//
//  SettingTableViewController.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define SUPPORT_MAIL_ADDRESS @"slidepocket.team@gmail.com"

@interface SettingTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

@end
