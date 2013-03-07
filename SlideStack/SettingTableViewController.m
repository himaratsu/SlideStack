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

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController


- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"設定・その他");
    // ナビゲーションバーの設定
    // タグ表示ボタン
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    tagButton.showsTouchWhenHighlighted = YES;
    [tagButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(slide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* tagButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
    tagButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = tagButtonItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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
            default:
                break;
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
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
        // TODO: 処理を追記
        
    }
}

- (void)slide {
    [self.viewDeckController toggleRightViewAnimated:YES];
}

@end
