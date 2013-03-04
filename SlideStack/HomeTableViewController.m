//
//  HomeTableViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "HomeTableViewController.h"
#import "RecommendTagView.h"
#import "SlideListTableViewController.h"
#import "IIViewDeckController.h"
#import "SettingTableViewController.h"
#import "RecommendAPI.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"おすすめ";
    self.tableView.backgroundColor = DEFAULT_BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
    // ナビゲーションバーの設定
    // 設定ボタン
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    settingButton.showsTouchWhenHighlighted = YES;
    [settingButton setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(openSettingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* settingbuttonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    settingbuttonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = settingbuttonItem;
    
    // タグ表示ボタン
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    tagButton.showsTouchWhenHighlighted = YES;
    [tagButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(slide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* tagButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
    tagButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = tagButtonItem;
    
    tagListView = [[RecommendTagListView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    tagListView.delegate = self;
    
    [self reload];
}

- (void)reload {
    RecommendAPI *api = [[RecommendAPI alloc] initWithDelegate:self];
    [api send];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"おすすめのタグ";
        case 1:
            return @"閲覧履歴";
        default:
            break;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [tagListView heightForTagList] + 10;
        case 1:
            return 400;
        default:
            break;
    }
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (indexPath.section == 0) {
            [cell.contentView addSubview:tagListView];
        }
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)didTapRecomeendTag:(NSString*)tagName {
    SlideListTableViewController *slideListVC = [[SlideListTableViewController alloc]
                                               initWithNibName:@"SlideListTableViewController"
                                               bundle:nil];
    slideListVC.searchWord = tagName;
    [self.navigationController pushViewController:slideListVC animated:YES];
}

- (void)slide {
    [self.viewDeckController toggleRightViewAnimated:YES];
}

- (void)openSettingView {
    SettingTableViewController *settingTableVC = [[SettingTableViewController alloc]
                                                  initWithNibName:@"SettingTableViewController"
                                                  bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingTableVC];
    [self presentViewController:navController animated:YES completion:nil];
}


#pragma mark - HttpRequestDelegate method

- (void)didStartHttpResuest:(id)result type:(NSString *)type {

}

- (void)didEndHttpResuest:(id)result type:(NSString *)type {
    NSMutableDictionary *results = (NSMutableDictionary*)result;
    
    tagListView.tagList = [results objectForKey:@"RecommendTags"];
    
    [self.tableView reloadData];
//    [SVProgressHUD dismiss];
}

- (void)didErrorHttpRequest:(id)result type:(NSString *)type {

    [SVProgressHUD dismiss];
}


@end
