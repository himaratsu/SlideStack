//
//  SlideListTableViewController.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideListTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"
#import "SlideShowObject.h"
#import "WebViewController.h"
#import "SlideTableViewCell.h"
#import "IIViewDeckController.h"
#import "SlideHistoryManager.h"
#import "MySettingViewController.h"
#import "TagManager.h"
#import "Util.h"

@interface SlideListTableViewController ()

@end

@implementation SlideListTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.slideArray = [[NSMutableArray alloc] init];
        _searchWord = @"Objective-C";
        _sortType = [MySettingViewController sharedInstance].defaultSort;
        _isLoading = NO;
        _isScrollTopAfterLoad = NO;
        _isMoreSlide = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];
    
    self.view.backgroundColor = DEFAULT_BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // ソートコントローラを追加
    _sortControlView = [[ControlSortView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    _sortControlView.delegate = self;
    [_sortControlView highlightTagButton: [[TagManager sharedInstance] isAlreadyChecked:_searchWord]];
    [self.view addSubview:_sortControlView];
    [_sortControlView selectSort:_sortType];
    
    // 同じサイズだけ上部に空間を空ける
    UIView *brankView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 42)];
    brankView.backgroundColor = [UIColor clearColor];
    // ズルイ線（黒背景用）
    UIView *borderUpper = [[UIView alloc] initWithFrame:CGRectMake(0, brankView.frame.size.height-2, 320, 1)];
    borderUpper.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    borderUpper.layer.shadowOpacity = 0.1;
    borderUpper.layer.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
    borderUpper.layer.shadowOffset = CGSizeMake(320, 1);
    [brankView addSubview:borderUpper];
    
    UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, brankView.frame.size.height-1, 320, 1)];
    borderBottom.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    [brankView addSubview:borderBottom];
    self.tableView.tableHeaderView = brankView;
    
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
    
    // 更新ボタン
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refreshStarted) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
    
    self.tableView.scrollsToTop = YES;
    
    [self reset];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}

- (void)reset {
    _isMoreSlide = YES;
    _page = 1;

    // 更新後にトップへ
    _isScrollTopAfterLoad = YES;
    
    [self reload];
}

- (void)reload {
    self.title = _searchWord;
    
    if ([Util isAvailableNetwork]) {
        
        SlideSearchAPI *api = [[SlideSearchAPI alloc] initWithDelegate:self];
        [api send:[self createApiParameter]];
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", @"読込中") maskType:SVProgressHUDMaskTypeClear];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NetworkError", @"通信エラー")
                                                        message:NSLocalizedString(@"NetworkErrorNotice", @"ネットワーク環境を確認して下さい")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
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
    if ([Util isAvailableNetwork]) {
        return 2;
    }
    else {
        return 0;
    }
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
            cell.contentView.backgroundColor = DEFAULT_BGCOLOR;
            
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
                    cell.textLabel.text = NSLocalizedString(@"NoHit", @"条件にマッチしたスライドはありません。");
                } else {
                    cell.textLabel.text = NSLocalizedString(@"No More Slide.", @"検索結果は以上です。");
                }
                cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.textColor = [UIColor grayColor];
                cell.textLabel.backgroundColor = [UIColor clearColor];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
            }
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
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    // 下から4つ目のアイテムが読み込まれたタイミングでページング
    if (indexPath.section == 0 && indexPath.row == [_slideArray count] - 4) {
        if (_isLoading == NO && _isMoreSlide) {
            _isLoading = YES;
            SlideSearchAPI *api = [[SlideSearchAPI alloc] initWithDelegate:self];
            _page++;
            NSMutableDictionary* param = [self createApiParameter];
            [api send:param];
        }
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
    
    // スライド閲覧履歴に追加
    [[SlideHistoryManager sharedInstance] appendHistoryList:d];
}


#pragma mark - HttpRequestDelegate

- (void)didStartHttpResuest:(id)result type:(NSString *)type {
//    isLoading = YES;
}

- (void)didEndHttpResuest:(id)result type:(NSString *)type {
    NSMutableDictionary *resultDict = (NSMutableDictionary*)result;
    
    if (_isScrollTopAfterLoad) {
        // コンテンツを一旦削除
        [_slideArray removeAllObjects];
        self.slideArray = [NSMutableArray array];
    }
    
    [self.slideArray addObjectsFromArray:[resultDict objectForKey:@"SlideShows"]];
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    // トップへ
    if (_isScrollTopAfterLoad) {
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:NO];
        _isScrollTopAfterLoad = NO;
        _sortControlView.frame = CGRectMake(0, 0, 320, 40);
    }

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
}

- (void)didErrorHttpRequest:(id)result type:(NSString *)type {
    _isScrollTopAfterLoad = NO;
    
    _isLoading = NO;
    _isMoreSlide = NO;
    [SVProgressHUD dismiss];
}

- (void)setSearchWord:(NSString *)searchWord {
    _searchWord = searchWord;
//    [self reset];
}

- (void)sortChange:(NSString *)sortType {
    _sortType = sortType;
    [self reset];
}

- (void)tapAddTagButton {
    // 既に追加している場合
    if ([[TagManager sharedInstance] isAlreadyChecked:_searchWord]) {
        [_sortControlView highlightTagButton:NO];
        [[TagManager sharedInstance] updateCheckMarkState:_searchWord isCheck:NO];
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Remove Tag", nil)];
    }
    else {
        [_sortControlView highlightTagButton:YES];
        [[TagManager sharedInstance] checkTagOrAddNewTag:_searchWord];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Follow Tag", nil)];
    }
}

- (void)headerViewScrollToTop:(BOOL)animated {
    CGFloat y = self.tableView.contentOffset.y;
    
    if (y <= 0) {
        y = 0;
    }
    
    CGRect targetRect = CGRectMake(_sortControlView.frame.origin.x,
                                   y,
                                   _sortControlView.frame.size.width,
                                   _sortControlView.frame.size.height);
    if (animated) {
        // TODO: まだ使えない
//        CGFloat y = self.tableView.contentOffset.y - 40;
//        if (y < 0) {
//            y = 0;
//        }
//        
//        _sortControlView.frame = CGRectMake(0, y, 320, 40);
//        
//        [UIView animateWithDuration:0.5f delay:0.0f
//                            options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^{
//                             // UITableViewのスクロールに合わせて表示位置を調整
//                             [_sortControlView setFrame:targetRect];
//                         }completion:nil
//         ];
    }
    else {
        // アニメなし
        [_sortControlView setFrame:targetRect];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self headerViewScrollToTop:NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self headerViewScrollToTop:NO];
}

- (void)slide {
    [self.viewDeckController toggleRightViewAnimated:YES];
}

// 引っ張って更新スタート！
- (void)refreshStarted {
    [self reset];
    [_refreshControl endRefreshing];
}

@end
