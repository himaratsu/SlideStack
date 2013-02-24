//
//  CommonAPIParser.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpRequestDelegate <NSObject>
@required
- (void)didStartHttpResuest:(id)result type:(NSString*)type;
- (void)didEndHttpResuest:(id)result type:(NSString*)type;
- (void)didErrorHttpRequest:(id)result type:(NSString*)type;
@end


// APIパーサーの基礎クラス
@interface CommonAPIParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, assign) id<HttpRequestDelegate> delegate;

@property (nonatomic, strong) NSMutableString *currentCharacters;
@property (nonatomic, strong) NSMutableDictionary  *results;

- (id)initWithDelegate:(id)delegate;
- (void)parse:(NSData*)data;

@end
