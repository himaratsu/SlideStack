//
//  AppDelegate.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "AppDelegate.h"

#import "SlideListTableViewController.h"
#import "SelectTagViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    SlideListTableViewController *slideListVC = [[SlideListTableViewController alloc] initWithNibName:@"SlideListTableViewController" bundle:nil];
    self.navController = [[UINavigationController alloc] initWithRootViewController:slideListVC];
    self.navController.navigationBar.tintColor = [UIColor blackColor];
    
    SelectTagViewController *selectTagVC = [[SelectTagViewController alloc] initWithNibName:@"SelectTagViewController" bundle:nil];
    
    self.deckController = [[IIViewDeckController alloc] initWithCenterViewController:self.navController rightViewController:selectTagVC];
    _deckController.rightSize = 150;
    _deckController.centerhiddenInteractivity =IIViewDeckCenterHiddenNotUserInteractive;
    
    self.window.rootViewController = self.deckController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
