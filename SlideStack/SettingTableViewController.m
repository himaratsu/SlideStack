//
//  SettingTableViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SettingTableViewController.h"
#import "SettingLanguageViewController.h"
#import "MySettingViewController.h"
#import "SettingTargetViewController.h"
#import "SettingDefaultSortViewController.h"
#import "IIViewDeckController.h"

#import <sys/sysctl.h>

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController


- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"設定・その他");
    // ナビゲーションバーの設定
    // 背景画像
    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // タグ表示ボタン
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    tagButton.showsTouchWhenHighlighted = YES;
    [tagButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(slide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* tagButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
    tagButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = tagButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = DEFAULT_SETTING_BGCOLOR;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
        default:
            break;
    }
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Search Terms", @"検索条件");
        case 1:
            return NSLocalizedString(@"Contact", @"ご意見・ご要望");
        default:
            break;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
        }
        else if (indexPath.section == 1) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    }
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"Language", @"検索言語");
                cell.detailTextLabel.text = [MySettingViewController sharedInstance].languageDisplay;
                break;
            case 1:
                cell.textLabel.text = NSLocalizedString(@"Target", @"検索対象");
                cell.detailTextLabel.text = [MySettingViewController sharedInstance].targetDisplay;
                break;
            case 2:
                cell.textLabel.text = NSLocalizedString(@"Sorting", @"標準ソート");
                cell.detailTextLabel.text = [MySettingViewController sharedInstance].defaultSortDisplay;
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = NSLocalizedString(@"Email to Support", @"お問い合わせ");
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                SettingLanguageViewController *settingLanguageVC = [[SettingLanguageViewController alloc]
                                                                    initWithNibName:@"SettingLanguageViewController" bundle:nil];
                [self.navigationController pushViewController:settingLanguageVC animated:YES];
                break;
            }
            case 1:
            {
                SettingTargetViewController *settingTargetVC = [[SettingTargetViewController alloc]
                                                                initWithNibName:@"SettingTargetViewController" bundle:nil];
                [self.navigationController pushViewController:settingTargetVC animated:YES];
                break;
            }
            case 2:
            {
                SettingDefaultSortViewController *settingSortVC = [[SettingDefaultSortViewController alloc]
                                                                initWithNibName:@"SettingDefaultSortViewController" bundle:nil];
                [self.navigationController pushViewController:settingSortVC animated:YES];
                break;
            }
            default:
                break;
        }

    }
    else if (indexPath.section == 1){
        [self launchMail];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)slide {
    [self.viewDeckController toggleRightViewAnimated:YES];
}



/*
 * アプリ内でメールを立ち上げる
 */
-(void)launchMail
{
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:SUPPORT_MAIL_ADDRESS]];
        mailViewController.title = @"";
        [mailViewController setSubject:@"Slide Pocket"];
        
        // マーケットに出ている場合
        NSString *body = NSLocalizedString(@"SupportMailBody", @"【お問い合わせ内容】\n\n\n\n※以下は変更しないで下さい。\n-----\nDEVICE: %@\niOS: %@\nVERSION: %@\n");
        [mailViewController setMessageBody:[NSString stringWithFormat:body,[UIDevice currentDevice].systemVersion, [self _platformString],[self _appVersion]] isHTML:NO];
    
        [self.navigationController presentViewController:mailViewController animated:YES completion:nil];
    }
    
    else {
        UIAlertView *mailBoxAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"MailSettingError", @"メール設定エラー")
                                                               message:NSLocalizedString(@"MailSettingNotice",@"端末にメールアカウント設定を行ってください。")
                                                              delegate:self
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles: nil];
        [mailBoxAlert show];
    }
}

/*
 * メール画面の「閉じる」ボタンを押したらメール画面を消す
 */
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (NSString*)_appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

- (NSString *) _platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = 6;
    mib[1] = 1;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (NSString *) _platformString
{
    NSString *platform = [self _platform];
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPod1,1"])  return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])  return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])  return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])  return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])  return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])  return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])  return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])  return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])  return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,5"])  return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])  return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])  return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])  return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])  return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])  return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])  return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])  return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])  return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])  return @"iPhone Simulator";
    return platform;
}
@end
