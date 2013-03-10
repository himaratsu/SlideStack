//
//  Util.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/10.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "Util.h"
#import "Reachability.h"

@implementation Util

// Y!にアクセスできるか（ネット環境下にいるか）
+ (BOOL)isAccessYahooJapan {
    Reachability *reachablity = [Reachability reachabilityWithHostName:@"yahoo.co.jp"];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)isAvailableNetwork {
    Reachability *reachablity = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachablity currentReachabilityStatus];
    switch (status) {
        case NotReachable:
            LOG(@"インターネット接続出来ません");
            return NO;
        case ReachableViaWWAN:
            LOG(@"3G接続中");
            break;
        case ReachableViaWiFi:
            LOG(@"WiFi接続中");
            break;
        default:
            LOG(@"？？[%d]", status);
            break;
    }
    
    return [self isAccessYahooJapan];
}




@end
