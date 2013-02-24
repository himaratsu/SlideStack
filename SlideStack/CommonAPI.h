//
//  CommonAPI.h
//  UIPatterns
//
//  Created by 平松 亮介 on 2012/11/09.
//  Copyright (c) 2012年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonAPIParser.h"

#define BASE_URL            @"https://www.slideshare.net/api/2/"
#define API_KEY             @"u25khrDY"
#define SECRET_KEY          @"kJFifre0"

// APIの基礎クラス
@interface CommonAPI : NSObject {
    NSString* module_;
    id<HttpRequestDelegate> delegate_;
}

@property (nonatomic, strong) CommonAPIParser *parser;
@property (nonatomic, strong) id<HttpRequestDelegate> delegate;

- (id)initWithDelegate:(id)delegate;
- (void)send:(NSDictionary*)param;
- (void)send;
- (void)parse:(NSData*)dic;

@end


