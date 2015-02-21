//
//  TagManageTableViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "TagManageTableViewController.h"
#import "TagManager.h"
#import "TagWithCheckMarkObject.h"

@interface TagManageTableViewController ()

@end

@implementation TagManageTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tags = [NSMutableArray arrayWithArray:[[TagManager sharedInstance] allTags]];
        self.filteredTags = [NSMutableArray arrayWithCapacity:[self totalTagCount]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Add Tags", @"タグを追加");
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:NSLocalizedString(@"Done", @"完了")
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(close)];
    
    _mySearchBar.tintColor = [UIColor lightGrayColor];
    _mySearchBar.delegate = self;
    _mySearchBar.placeholder = NSLocalizedString(@"Narrow Tags", @"タグを絞り込み");
    _mySearchBar.showsCancelButton = NO;
    [_mySearchBar sizeToFit];
    self.tableView.tableHeaderView = _mySearchBar;
    
    for (UIView *searchBarSubview in [_mySearchBar subviews]) {
        //protocolがUITextInputTraits=キー入力関係のオブジェクトを判定
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            @try {
                //UITextInputTraitsのオブジェクト、ここでは「検索」ボタンになるので
                //UIReturnKeyDone=完了に変更
                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
            }
            @catch (NSException * e) {
                //例外処理
            }
        }
    }
    
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    _mySearchDisplayController.searchResultsTitle = NSLocalizedString(@"Narrow Tags", @"タグを絞り込み");
    
    // ナビゲーションバーの設定
    // 背景画像
    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload {
    self.tags = [NSMutableArray arrayWithArray:[[TagManager sharedInstance] allTags]];
//    self.filteredTags = [NSMutableArray arrayWithCapacity:[self totalTagCount]];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return 1 + [_tags count]; // タグを作成 + 各カテゴリのタグ
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredTags count];
    }
    else {
        switch (section) {
            case 0:
                return 1;
            default:
                return [[_tags objectAtIndex:(section-1)] count];
        }
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return NSLocalizedString(@"Search Result", @"検索結果");
    } else {
//        if ([[_tags objectAtIndex:section] count] == 0) {
//                return @"";
//        }
        
        switch (section) {
            case 0:
                return @"";
            case 1:
                if ([[_tags objectAtIndex:0] count] == 0) {
                    return @"";
                }
                else {
                    return NSLocalizedString(@"Tag You Created", @"あなたが作ったタグ");
                }
            case 2:
                return NSLocalizedString(@"Programing", @"プログラミング");
            case 3:
                return NSLocalizedString(@"Library", @"ライブラリ");
            case 4:
                return NSLocalizedString(@"Development", @"開発");
            case 5:
                return NSLocalizedString(@"Server/Infrastructure", @"サーバ/インフラ");
            case 6:
                return NSLocalizedString(@"Other", @"その他");
        }
    }
    return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // 「タグを作成」セクション
    if (tableView != self.searchDisplayController.searchResultsTableView
        && indexPath.section == 0)
    {
        cell.textLabel.text = NSLocalizedString(@"+ Create Tag", @"+タグを作成");
        return cell;
    }
    
    
    TagWithCheckMarkObject *tag;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tag = [_filteredTags objectAtIndex:indexPath.row];
    }
    else {
        tag = [[_tags objectAtIndex:(indexPath.section-1)] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = tag.tagName;
    if (tag.isChecked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        // 「あなたが作成したタグ」のみ編集可能
        return YES;
    }
    else {
        return NO;
    }
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        TagWithCheckMarkObject *deleteTag = [[_tags objectAtIndex:(indexPath.section-1)] objectAtIndex:indexPath.row];
        [[TagManager sharedInstance] removeOriginalTag:deleteTag.tagName];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TagWithCheckMarkObject *tag;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tag = [_filteredTags objectAtIndex:indexPath.row];
    }
    else {
        if (indexPath.section == 0) {
            // タグを新規作成
            [self createNewTag];
            return ;
        }
        
        tag = [[_tags objectAtIndex:(indexPath.section-1)] objectAtIndex:indexPath.row];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (tag.isChecked == NO) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[TagManager sharedInstance] updateCheckMarkState:tag.tagName isCheck:YES];
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [[TagManager sharedInstance] updateCheckMarkState:tag.tagName isCheck:NO];
    }
    
    [self reload];
}

#pragma mark - Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    [_filteredTags removeAllObjects];
    for (TagWithCheckMarkObject *tag in [self plainTags]) {
        NSComparisonResult result = [tag.tagName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch)
                                           range:NSMakeRange(0, [searchText length])];
        if (result == NSOrderedSame) {
            [_filteredTags addObject:tag];
        }
    }
}

#pragma mark - UISearchDisplayController Delegate Methods


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    controller.searchBar.showsCancelButton = NO;
    
    return YES;
}

#pragma mark - UISearchBar Delegate Methods

- (void) searchBarSearchButtonClicked: (UISearchBar *) searchBar {
    [searchBar resignFirstResponder];
    [self.searchDisplayController setActive:NO animated:YES];
}

// section-rowを無視したタグリストを返す
- (NSArray*)plainTags {
    NSMutableArray* plainTags = [NSMutableArray array];
    NSArray *itemArray;
    for (int i=0; i<[_tags count]; i++) {
        itemArray = [_tags objectAtIndex:i];
        for (int j=0; j<[itemArray count]; j++) {
            [plainTags addObject:[itemArray objectAtIndex:j]];
        }
    }
    return [NSArray arrayWithArray:plainTags];
}

- (NSInteger)totalTagCount {
    NSInteger totalCount = 0;
    
    NSArray *itemArray;
    for (int i=0; i<[_tags count]; i++) {
        itemArray = [_tags objectAtIndex:i];
        totalCount += [itemArray count];
    }
    
    return totalCount;
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createNewTag {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Tag Name", @"作成するタグ名")
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"キャンセル")
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = ALERT_VIEW_TAG_CREATE_NEW_TAG;
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    NSString *inputText = [[alertView textFieldAtIndex:0] text];
    if ([inputText length] >= 1) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == ALERT_VIEW_TAG_CREATE_NEW_TAG
        && buttonIndex == 1) {
        
        NSString *inputTitle = [[alertView textFieldAtIndex:0] text];

        // タグを新規作成
        BOOL success = [[TagManager sharedInstance] addOriginalTag:inputTitle];
        if (success){
            if (success == NO) {
                // タグの追加に失敗
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"エラー")
                                                                message:NSLocalizedString(@"Tag is Alerady Exist", @"既に同名のタグが存在します")
                                                               delegate:self
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            } else {
                // タグの追加に成功
                [self reload];
            }
        }
    }
}

@end
