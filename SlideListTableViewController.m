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
//        _searchWord = @"Objective-C";
        _searchWord = @"subversionn";
        _sortType = @"";
        self.title = @"Slide Socket";
        _isLoading = NO;
        _isMoreSlide = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    self.view.backgroundColor = [UIColor grayColor];
//    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ControlSortView *headView = [[ControlSortView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    headView.delegate = self;
    self.tableView.tableHeaderView = headView;
    self.tableView.scrollsToTop = YES;
    
    [self reload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"設定" style:UIBarButtonItemStylePlain target:self action:@selector(openSettingView)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reset)];
}

- (void)reset {
    // コンテンツを一旦削除
    [_slideArray removeAllObjects];
//    self.slideArray = [[NSMutableArray alloc] init];
    _isMoreSlide = YES;
    _page = 1;
    
    [self reload];
}

- (void)reload {
    self.title = _searchWord;
    
    SlideSearchAPI *api = [[SlideSearchAPI alloc] initWithDelegate:self];
    [api send:[self createApiParameter]];
    [SVProgressHUD showWithStatus:@"読込中..." maskType:SVProgressHUDMaskTypeClear];
}

// パラメータを作成
- (NSMutableDictionary*)createApiParameter {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:_searchWord forKey:@"q"];
    [dict setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"page"];
    [dict setObject:_sortType forKey:@"sort"];
    [dict setObject:@"1" forKey:@"detailed"];
    return dict;
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
    if (section == 0) {
        return [_slideArray count];
    }
    else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    }
    else {
        return 90;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    CellIdentifier = [NSString stringWithFormat:@"Cell_%d_%d", indexPath.section, indexPath.row];
    
    // 最下部に表示するインジケータセル
    if (indexPath.section == 1) {
        UITableViewCell *cell = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            
            if (_isMoreSlide) {
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                CGRect frame = indicator.frame;
                indicator.frame = CGRectMake((320-frame.size.width)/2, (44-frame.size.height)/2,
                                             frame.size.width, frame.size.height);
                [cell.contentView addSubview:indicator];
                
                // はじめはインジケータを表示しない
                if ([_slideArray count] != 0) {
                    [indicator startAnimating];
                }
            }
            else {
                // 0件の時のメッセージ
                if ([_slideArray count] == 0) {
                    cell.textLabel.text = @"条件にマッチしたスライドはありません。";
                } else {
                    cell.textLabel.text = @"検索結果は以上です。";
                }
                cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
        }
        
        // インジケータビューが表示されたタイミングでページング
        if (_isLoading == NO && _isMoreSlide) {
            _isLoading = YES;
            SlideSearchAPI *api = [[SlideSearchAPI alloc] initWithDelegate:self];
            _page++;
            NSMutableDictionary* param = [self createApiParameter];
            [api send:param];
        }
        
        return cell;
    }
    
    // スライドセル
    SlideTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SlideTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.section == 0) {
        SlideShowObject *slide = [_slideArray objectAtIndex:indexPath.row];
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
    }
    
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
    
    [self.slideArray addObjectsFromArray:[resultDict objectForKey:@"SlideShows"]];
    
    //    [self.tableView reloadData];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    // トップへ
//    if (_isScrollTopAfterLoad) {
//        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
//        _isScrollTopAfterLoad = NO;
//    }

    // まだ読み込む結果があるかチェック
    NSInteger numResults = [[resultDict objectForKey:@"NumResults"] integerValue];
    NSInteger totalResults = [[resultDict objectForKey:@"TotalResults"] integerValue];

    // 取得件数が12件でない->最後まで読み込んだ
    if (numResults != PER_PAGE) {
        _isMoreSlide = NO;
    }
    else if (_page*12 == totalResults) {
        _isMoreSlide = NO;
    }
    
    _isLoading = NO;
    [SVProgressHUD dismiss];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didErrorHttpRequest:(id)result type:(NSString *)type {
//    isLoading = NO;
//    _isScrollTopAfterLoad = NO;
    
    _isLoading = NO;
    _isMoreSlide = NO;
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
