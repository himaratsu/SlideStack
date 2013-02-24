//
//  CommonAPIParser.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "CommonAPIParser.h"


@implementation CommonAPIParser

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)parse:(NSData*)data {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
}

// XMLのパース開始
- (void)parserDidStartDocument:(NSXMLParser *)parser {
	// 初期化処理
    [self _didStartHttpRequest];
    
    self.results = [NSMutableDictionary dictionary];
}

// XMLのパース終了
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [self _didEndHttpRequest:[NSDictionary dictionaryWithDictionary:_results]];
}

// XMLのパースに失敗
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [self _didErrorHttpRequest:parseError];
}

// 要素の開始タグを読み込み
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    // 実装は子に任せる
}

// 要素の閉じタグを読み込み
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    // 実装は子に任せる
}

// テキストデータ読み込み
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [_currentCharacters appendString:string];
}




#pragma mark -
#pragma mark HttpRequestDelegate Method

- (void)_didStartHttpRequest {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [_delegate didStartHttpResuest:nil type:[[self class] description]];
}

- (void)_didEndHttpRequest:(id)result {    
    [_delegate didEndHttpResuest:result type:[[self class] description]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)_didErrorHttpRequest:(NSError*)error {    
    [_delegate didErrorHttpRequest:error type:[[self class] description]];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end




