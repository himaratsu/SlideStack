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
    // タグ表示ボタン
    UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    tagButton.showsTouchWhenHighlighted = YES;
    [tagButton setBackgroundImage:[UIImage imageNamed:@"list.png"] forState:UIControlStateNormal];
    [tagButton addTarget:self action:@selector(slide) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* tagButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tagButton];
    tagButtonItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = tagButtonItem;
    
    [self reload];
}

- (void)reload {
    RecommendAPI *api = [[RecommendAPI alloc] initWithDelegate:self];
    [api send];
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
        _tagListView = [[RecommendTagListView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
        _tagListView.delegate = self;
    }
    _tagListView.tagList = _recommendTags;
    return _tagListView;
}

- (RecommendSlideListView *)slideListView {
    if (_slideListView == nil) {
        _slideListView = [[RecommendSlideListView alloc] initWithFrame:CGRectMake(0, 10, 320, 250) delegate:self];
    }
    return _slideListView;
}

- (SlideHistoryView *)histView {
    if (_histView == nil) {
        _histView = [[SlideHistoryView alloc] initWithFrame:CGRectMake(0, 10, 320, 80)];
        _histView.delegate = self;
    }
    return _histView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isLoaded) {
        return 3;
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
        case 1:
            return NSLocalizedString(@"Featured Slide", @"おすすめのスライド");
        case 2:
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
        case 1:
            return 230;
        case 2:
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
        else if (indexPath.section == 1) {
            [cell.contentView addSubview:self.slideListView];
        }
        else if (indexPath.section == 2) {
            [cell.contentView addSubview:self.histView];
        }
    }
    
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            [_slideListView startLoadingImages];
            break;
        case 2:
//            [_histView reload];
            break;
        default:
            break;
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
    GA_TRACK_METHOD
    SlideListTableViewController *slideListVC = [[SlideListTableViewController alloc]
                                               initWithNibName:@"SlideListTableViewController"
                                               bundle:nil];
    slideListVC.searchWord = tagName;
    [self.navigationController pushViewController:slideListVC animated:YES];
}

- (void)didTapRecommendSlideWithUrl:(NSString *)url title:(NSString *)title {
    GA_TRACK_METHOD
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVC.title = title;
    webVC.loadUrl = url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didTapSlideHistory:(SlideShowObject *)slide {
    GA_TRACK_METHOD
    WebViewController *webVC = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    webVC.title = slide.title;
    webVC.loadUrl = slide.url;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)slide {
    [self.viewDeckController toggleRightViewAnimated:YES];
}

#pragma mark - HttpRequestDelegate method

- (void)didStartHttpResuest:(id)result type:(NSString *)type {
    [SVProgressHUD show];
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
