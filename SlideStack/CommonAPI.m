//
//  CommonAPI.m
//  UIPatterns
//
//  Created by 平松 亮介 on 2012/11/09.
//  Copyright (c) 2012年 mashroom. All rights reserved.
//

#import "CommonAPI.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CommonAPI

#pragma mark -
#pragma mark Network Method

// SHA1で暗号化する
// 参考:http://stackoverflow.com/questions/7570377/creating-sha1-hash-from-nsstring
- (NSString *)sha1:(NSString *)inputString 
{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}


// UNIXTIMEを取得
- (NSString*)unixTime {
    long long int unixTime =  (long long int)[[NSDate date] timeIntervalSince1970];
    return [NSString stringWithFormat:@"%lld", unixTime];
}

- (NSDictionary*)addRequiredParameter:(NSDictionary*)param {
    NSMutableDictionary *mutableParam;
    if (param) {
        mutableParam = [NSMutableDictionary dictionaryWithDictionary:param];
    } else {
        mutableParam = [NSMutableDictionary dictionary];
    }
    
    // APIキーを追加
    [mutableParam setObject:API_KEY forKey:@"api_key"];
    
    // UNIXタイムを追加
    NSString *unixTimeStr = [self unixTime];
    [mutableParam setObject:unixTimeStr forKey:@"ts"];
    
    // SECRETキー+UNIXタイム
    NSString *secAndTs = [NSString stringWithFormat:@"%@%@", SECRET_KEY, unixTimeStr];
    [mutableParam setObject:[self sha1:secAndTs] forKey:@"hash"];
    
    return [NSDictionary dictionaryWithDictionary:mutableParam];
}

// paramに格納されたkey->valueを
// key=value と変換して&で連結する
- (NSString*)composeKeyAndValueParams:(NSDictionary*)param {
    NSMutableString* path = [[NSMutableString alloc] init];
    NSArray* allKeys = [param allKeys];
    for (NSString* key in allKeys) {
        NSString* keyEqualValueStr = [NSString stringWithFormat:@"%@=%@", key, [param objectForKey:key]];
        [path appendString:keyEqualValueStr];
        [path appendString:@"&"];
    }
    // 最後の&は削除する
    [path deleteCharactersInRange:NSMakeRange([path length]-1, 1)];
    
    return path;
}

// リクエストURLを作成する
- (NSString*)makeUrl:(NSDictionary *)param {
    NSMutableString* url = [[NSMutableString alloc] initWithString:BASE_URL];
    [url appendString:module_];
    
    // APIキーなど必須パラメータを追加
    param = [self addRequiredParameter:param];

    if (param != nil) {
        [url appendString:@"?"];
        [url appendString:[self composeKeyAndValueParams:param]];
    }
    return url;
}

// リクエストを送信（プライベートメソッド）
- (void)_send: (NSDictionary *)param {
    @autoreleasepool {
        NSString* urlStr = [self makeUrl:param];
        NSURLRequest *req = nil;
        
        LOG(@"url = %@", urlStr);
        
        // リクエストの作成
        if (urlStr) {
            NSURL *url = [NSURL URLWithString:urlStr];
            if (url) {
                req = [NSURLRequest requestWithURL:url];
            }
        }
        
        if (!req) {
            return;
        }
        
        // ネットワークアクセス開始
        NSData *data;
        NSURLResponse *res;
        NSError *err = nil;
        
        data = [NSURLConnection sendSynchronousRequest:req
                                             returningResponse:&res
                                                         error:&err];
        [self parse:data];
    }
}

// リクエストを送信（プライベートメソッド）
- (void)_sendWithURL: (NSString *)urlStr {
    @autoreleasepool {
        NSURLRequest *req = nil;
    
        // リクエストの作成
        if (urlStr) {
            NSURL *url = [NSURL URLWithString:urlStr];
            if (url) {
                req = [NSURLRequest requestWithURL:url];
            }
        }
        
        if (!req) {
            return;
        }
        
        // ネットワークアクセス開始
        NSData *data;
        NSURLResponse *res;
        NSError *err = nil;
        
        data = [NSURLConnection sendSynchronousRequest:req
                                     returningResponse:&res
                                                 error:&err];
        [self parse:data];
    }
}



// リクエストを送信（パラメータあり）
- (void)send:(NSDictionary *)param {
    // サブスレッドを作成する
    [NSThread detachNewThreadSelector:@selector(_send:) toTarget:self withObject:param];
}

// リクエストを送信（パラメータなし）
- (void)send {
    [self send:nil];
}

- (void)sendWithUrl:(NSString *)url {
    // サブスレッドを作成する
    [NSThread detachNewThreadSelector:@selector(_sendWithURL:) toTarget:self withObject:url];
}

@end
