//
//  WebViewController.h
//  dollerme
//
//  Created by 平松 亮介 on 2013/02/13.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ORIENTATION [[UIDevice currentDevice] orientation]

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
    BOOL isLoading;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *slideId;
@property (nonatomic, strong) NSString  *loadUrl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil loadUrl:(NSString*)loadUrl;

@end
