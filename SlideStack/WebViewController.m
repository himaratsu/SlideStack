//
//  WebViewController.m
//  dollerme
//
//  Created by 平松 亮介 on 2013/02/13.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "WebViewController.h"
#import "SVProgressHUD.h"
#import "Util.h"
#import "PocketAPI.h"
#import "IIViewDeckController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil loadUrl:(NSString*)loadUrl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loadUrl = loadUrl;
    }
    return self;
}

- (void)viewDidLoad
{
    GA_TRACK_CLASS
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    NSString *title = self.title;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.minimumScaleFactor = 0.6f;
    titleLabel.numberOfLines = 0;
    self.navigationItem.titleView = titleLabel;
    
    // ナビゲーションバーの設定
    // 背景画像
    UIImage *image = [UIImage imageNamed:@"nav_bg.png"];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    // Pocketに送るボタン
    UIBarButtonItem *pocket = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                            target:self
                                                                            action:@selector(openSavePocket)];
    self.navigationItem.rightBarButtonItem = pocket;
    
    // 戻るボタン
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];



    if ([Util isAvailableNetwork]) {
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_loadUrl]]];
    }
    else {
        [SVProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"NetworkError", @"通信エラー")
                                                        message:NSLocalizedString(@"NetworkErrorNotice", @"ネットワーク環境を確認して下さい")
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading", @"読込中...")];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}


- (void)openSavePocket {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"Cancel", @"キャンセル")
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:NSLocalizedString(@"Copy URL", @"URLをコピー"),
                                                                      NSLocalizedString(@"Open in Safari", @"Safariで開く"),
                                                                      NSLocalizedString(@"Save to Pocket", @"Pocketに送る"),
                                  NSLocalizedString(@"Open in SlideShare App", @"SlideShareアプリで開く"),
                                                                      nil
                                  ];
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            // URLをコピー
            [self copyUrl];
            break;
        case 1:
            // Safariで開く
            [self openInSafari];
            break;
        case 2:
            // Pocketに送る
            [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeClear];
            [self sendUrlToPocket];
            break;
        case 3:
        {
            // Slideshareアプリで開く
            NSString *url = [NSString stringWithFormat:@"slideshare-app://ss/%@", self.slideId];
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Slideshareアプリがインストールされていません"
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
        case 4:
            // キャンセル
            break;
        default:
            break;
    }
}

// URLをコピー
- (void)copyUrl {
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    [board setValue:_loadUrl forPasteboardType:@"public.utf8-plain-text"];
    [SVProgressHUD showSuccessWithStatus:@"Success Copy"];
}

// Safariで開く
- (void)openInSafari {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_loadUrl]];
}

// ポケットに送る
- (void)sendUrlToPocket {
    NSURL *url = [NSURL URLWithString:_loadUrl];
    [[PocketAPI sharedAPI] saveURL:url handler: ^(PocketAPI *API, NSURL *URL,
                                                  NSError *error){
        
        if(error){
            // 失敗
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:@"Failed Save"];
        }else{
            // 成功
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:@"Success Saved"];
        }
    }];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Slideshareアプリを開こうとするのをキャンセル
    if ([request.URL.scheme isEqualToString:@"slideshare-app"]) {
        return NO;
    }
    
    return YES;
}

// 回転対応
- (NSUInteger)supportedInterfaceOrientations
{
    // WebViewでは回転を許可
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate
{    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    if (toInterfaceOrientation == UIDeviceOrientationPortrait
        || toInterfaceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        LOG (@"タテ回転〜！");
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _webView.scrollView.scrollEnabled = YES;
        [self.viewDeckController setEnabled:YES];
    }
    else {
        LOG (@"ヨコ回転〜！");
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _webView.scrollView.scrollEnabled = NO;
        [self.viewDeckController closeRightView];
        [self.viewDeckController setEnabled:NO];
    }
}
@end
