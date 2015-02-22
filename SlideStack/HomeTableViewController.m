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
#import "RecommendAPI.h"
#import "SVProgressHUD.h"
#import "WebViewController.h"
#import "SlideHistoryManager.h"
#import "Util.h"

@interface HomeTableViewController ()

@end

@implementation HomeTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isLoaded = NO;
        self.recommendTags = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];

    self.title = NSLocalizedString(@"Featured", @"おすすめ");
    self.tableView.backgroundColor = DEFAULT_BGCOLOR;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection = NO;
    
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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reload];
}

- (void)reload {
    
    isLoaded = YES;
    self.recommendTags = @[@"Swift", @"Arduino", @"Docker", @"AWS", @"Design"].mutableCopy;
    [self reloadData];
    
//    if ([Util isAvailableNetwork]) {
//        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", nil)];
//        RecommendAPI *api = [[RecommendAPI alloc] initWithDelegate:self];
//        [api send];
//    }
//    else {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NetworkError", @"通信エラー")
//                                                        message:NSLocalizedString(@"NetworkErrorNotice", @"ネットワーク環境を確認して下さい")
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"OK", nil];
//        [alert show];
//    }
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (RecommendTagListView *)tagListView {
    if (_tagListView == nil) {
        _tagListView = [[RecommendTagListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 90)];
        _tagListView.delegate = self;
    }
    _tagListView.tagList = _recommendTags;
    return _tagListView;
}

- (RecommendSlideListView *)slideListView {
    if (_slideListView == nil) {
        _slideListView = [[RecommendSlideListView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 250) delegate:self];
    }
    return _slideListView;
}

- (SlideHistoryView *)histView {
    if (_histView == nil) {
        _histView = [[SlideHistoryView alloc] initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 80)];
        _histView.delegate = self;
    }
    return _histView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoaded) {
        return 2;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return NSLocalizedString(@"Featured Tag", @"おすすめのタグ");
//        case 1:
//            return NSLocalizedString(@"Featured Slide", @"おすすめのスライド");
        case 1:
            return NSLocalizedString(@"History", @"閲覧履歴");
        default:
            break;
    }
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [self.tagListView heightForTagList] + 10;
//        case 1:
//            return 230;
        case 1:
            return 100;
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
            [cell.contentView addSubview:self.tagListView];
        }
//        else if (indexPath.section == 1) {
//            [cell.contentView addSubview:self.slideListView];
//        }
        else if (indexPath.section == 1) {
            [cell.contentView addSubview:self.histView];
        }
    }
    
    switch (indexPath.section) {
        case 0:
            break;
//        case 1:
//            [_slideListView startLoadingImages];
//            break;
        case 2:
//            [_histView reload];
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    view.backgroundColor = [UIColor clearColor];
    view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home_header.png"]];
    
    UIImage *iconImage;
    if (section == 0) {
        iconImage = [UIImage imageNamed:@"tag_black.png"];
//    } else if (section == 1) {
//        iconImage = [UIImage imageNamed:@"slide.png"];
    } else {
        iconImage = [UIImage imageNamed:@"view_black.png"];
    }
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:iconImage];
    iconImageView.frame = CGRectMake(10, 3, 20, 20);
    [view addSubview:iconImageView];
    
    NSString *title = [self tableView:tableView titleForHeaderInSection:section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(32, 3, 260, 20)];
    label.text = title;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:13.0f];
    label.textColor = [UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0];
    [view addSubview:label];
    
    return view;
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
    GA_TRACK_METHOD_WITH_LABEL(tagName);
    SlideListTableViewController *slideListVC = [[SlideListTableViewController alloc]
                                               initWithNibName:@"SlideListTableViewController"
                                               bundle:nil];
    slideListVC.searchWord = tagName;
    [self.navigationController pushViewController:slideListVC animated:YES];
}

- (void)didTapRecommendSlide:(SlideShowObject *)slide {
    GA_TRACK_METHOD_WITH_LABEL(slide.title);
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVC.slideId = slide.slideId;
    webVC.title = slide.title;
    webVC.loadUrl = slide.url;
    [self.navigationController pushViewController:webVC animated:YES];
    
    // スライド閲覧履歴に追加
    [[SlideHistoryManager sharedInstance] appendHistoryList:slide];
}


- (void)didTapSlideHistory:(SlideShowObject *)slide {
    GA_TRACK_METHOD_WITH_LABEL(slide.title);
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVC.slideId = slide.slideId;
    webVC.title = slide.title;
    webVC.loadUrl = slide.url;
    [self.navigationController pushViewController:webVC animated:YES];
    
    // スライド閲覧履歴に追加
    [[SlideHistoryManager sharedInstance] appendHistoryList:slide];
}

- (void)slide {
    [self.viewDeckController toggleRightViewAnimated:YES];
}

#pragma mark - HttpRequestDelegate method

- (void)didStartHttpResuest:(id)result type:(NSString *)type {

}

- (void)didEndHttpResuest:(id)result type:(NSString *)type {
    [SVProgressHUD dismiss];
    
    NSMutableDictionary *results = (NSMutableDictionary*)result;
    
    self.recommendTags = [results objectForKey:@"RecommendTags"];
    self.slideListView.dataArray = [results objectForKey:@"RecommendSlides"];
    
    isLoaded = YES;

    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)didErrorHttpRequest:(id)result type:(NSString *)type {
    [SVProgressHUD dismiss];
}


@end
