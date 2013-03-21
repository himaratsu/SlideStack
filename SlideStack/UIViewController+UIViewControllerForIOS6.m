//
//  UIViewController+UIViewControllerForIOS6.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/21.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "UIViewController+UIViewControllerForIOS6.h"

@implementation UIViewController (UIViewControllerForIOS6)

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // iPhone がサポートする向き
        return UIInterfaceOrientationMaskPortrait;
    }
    
    // iPad がサポートする向き
    return UIInterfaceOrientationMaskAll;
}
- (BOOL)shouldAutorotate
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        // iPhone
        return NO;
    }
    
    return YES;
}

@end
