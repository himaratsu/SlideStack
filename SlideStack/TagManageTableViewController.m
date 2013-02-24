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
        self.tags = [[TagManager sharedInstance] allTags];
        self.filteredTags = [NSMutableArray arrayWithCapacity:[self totalTagCount]];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"タグを追加";
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"閉じる" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    
    _mySearchBar.tintColor = [UIColor lightGrayColor];
    _mySearchBar.delegate = self;
    _mySearchBar.placeholder = @"タグを検索";
    _mySearchBar.showsCancelButton = NO;
    [_mySearchBar sizeToFit];
    self.tableView.tableHeaderView = _mySearchBar;
    
    _mySearchDisplayController.delegate = self;
    _mySearchDisplayController.searchResultsDelegate = self;
    _mySearchDisplayController.searchResultsDataSource = self;
    
    [self.tableView reloadData];
    self.tableView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reload {
    self.tags = [[TagManager sharedInstance] allTags];
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
        return [_tags count];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [_filteredTags count];
    }
    else {
        return [[_tags objectAtIndex:section] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return @"検索結果";
    } else {
        if ([[_tags objectAtIndex:section] count] == 0) {
                return @"";
        }
        
        switch (section) {
            case 0:
                return @"あなたが追加したタグ";
            case 1:
                return @"プログラミング";
            case 2:
                return @"ライブラリ";
            case 3:
                return @"開発";
            case 4:
                return @"サーバ/インフラ";
            case 5:
                return @"その他";
                break;
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
    
    // Configure the cell...
    TagWithCheckMarkObject *tag;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tag = [_filteredTags objectAtIndex:indexPath.row];
    }
    else {
        tag = [[_tags objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = tag.tagName;
    if (tag.isChecked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"%d %d", indexPath.section, indexPath.row);
    
    TagWithCheckMarkObject *tag;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        tag = [_filteredTags objectAtIndex:indexPath.row];
    }
    else {
        tag = [[_tags objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
    return YES;
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

@end
