//
//  SlideListTableViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideListTableViewController.h"
#import "SVProgressHUD.h"
#import "SlideShowObject.h"
#import "WebViewController.h"
#import "SettingTableViewController.h"
#import "SlideTableViewCell.h"

@interface SlideListTableViewController ()

@end

@implementation SlideListTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.slideArray = [[NSMutableArray alloc] init];
        _searchWord = @"Objective-C";
        _sortType = @"";
        self.title = @"Slide Socket";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    ControlSortView *headView = [[ControlSortView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStylePlain target:self action:@selector(openSettingView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reset)];
}

- (void)reset {
    // コンテンツを一旦削除
//    [_slideArray removeAllObjects];
//    self.slideArray = [[NSMutableArray alloc] init];
        
    _page = 1;
    
    [self reload];
}

- (void)reload {
    self.title = _searchWord;
    
    SlideSearchAPI *api = [[SlideSearchAPI alloc] initWithDelegate:self];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_searchWord forKey:@"q"];
    [dict setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page"];
    [dict setObject:_sortType forKey:@"sort"];
    [dict setObject:@"1" forKey:@"detailed"];
    [api send:dict];
    [SVProgressHUD showWithStatus:@"読込中..." maskType:SVProgressHUDMaskTypeClear];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_slideArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell_%d", indexPath.row];
    SlideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SlideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    SlideShowObject *slide = [_slideArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = slide.title;
    cell.titleLabel.text = slide.title;
    
    if (cell.customImageView.isLoaded == NO
        || ![[cell.customImageView.imageUrl absoluteString] isEqualToString:slide.thumbnailUrl]) {
        cell.customImageView.imageUrl = [NSURL URLWithString:slide.thumbnailUrl];
        cell.customImageView.image = nil;
        [cell.customImageView startLoadImage];
    }
    
    cell.numViews = slide.numViews;
    cell.numFavorites = slide.numFavorites;
    cell.numDownloads = slide.numDownloads;
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    SlideShowObject *d = [_slideArray objectAtIndex:indexPath.row];
    webVC.title = d.title;
    webVC.loadUrl = d.url;
    [self.navigationController pushViewController:webVC animated:YES];
}


#pragma mark - HttpRequestDelegate

- (void)didStartHttpResuest:(id)result type:(NSString *)type {
//    isLoading = YES;
}

- (void)didEndHttpResuest:(id)result type:(NSString *)type {
    NSMutableDictionary *resultDict = (NSMutableDictionary*)result;
    
    self.slideArray = [resultDict objectForKey:@"SlideShows"];
    
    //    [self.tableView reloadData];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    // トップへ
//    if (_isScrollTopAfterLoad) {
//        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
//        _isScrollTopAfterLoad = NO;
//    }

    [SVProgressHUD dismiss];
}

- (void)didErrorHttpRequest:(id)result type:(NSString *)type {
//    isLoading = NO;
//    _isScrollTopAfterLoad = NO;
    
    [SVProgressHUD dismiss];
}

- (void)setSearchWord:(NSString *)searchWord {
    _searchWord = searchWord;
    [self reset];
}

- (void)openSettingView {
    SettingTableViewController *settingTableVC = [[SettingTableViewController alloc]
                                                  initWithNibName:@"SettingTableViewController"
                                                  bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingTableVC];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)sortChange:(NSString *)sortType {
    _sortType = sortType;
    [self reset];
}

@end
