//
//  RecommendAPI.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "RecommendAPI.h"
#import "NSString+MyString.h"

@implementation RecommendAPI

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        delegate_ = delegate;
    }
    return self;
}

- (void)send {
    [super sendWithUrl:RECOMMEND_XML_URL];
}

- (void)parse:(NSData*)data {
    RecommendAPIParser* parser = [[RecommendAPIParser alloc] init];
    parser.delegate = delegate_;
    [parser parse:data];
}

@end



@implementation RecommendAPIParser

- (void)parse:(NSData*)data {
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	[parser setDelegate:self];
	[parser parse];
}

// XMLのパース開始
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    [super parserDidStartDocument:parser];
    
	// 初期化処理
	self.results = [NSMutableDictionary dictionary];
}


// 要素の開始タグを読み込み
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"RecommendTags"]) {
        _isInRecommendTags = YES;
        self.recommendTags = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"RecommendSlides"]) {
        _isInRecommendSlides = YES;
        self.recommendSlides = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"RecommendSlide"]) {
        _isInRecommendSlide = YES;
        self.slide = [[SlideShowObject alloc] init];
    }
    else if ([elementName isEqualToString:@"RecommendTagName"]
             || [elementName isEqualToString:@"ID"]
             || [elementName isEqualToString:@"Title"]
             || [elementName isEqualToString:@"URL"]
             || [elementName isEqualToString:@"ThumbnailURL"])
    {
        self.currentCharacters = [NSMutableString string];
    }
}

// 要素の閉じタグを読み込み
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    LOG(@"start[%@]", elementName);
    
    if (_isInRecommendTags) {
        if ([elementName isEqualToString:@"RecommendTags"]) {
            _isInRecommendTags = NO;
            [self.results setObject:_recommendTags forKey:@"RecommendTags"];
        }
        else if ([elementName isEqualToString:@"RecommendTagName"]) {
            [_recommendTags addObject:[NSString trim:self.currentCharacters]];
        }
    }
    else if (_isInRecommendSlide) {
        if ([elementName isEqualToString:@"RecommendSlide"]) {
            _isInRecommendSlide = NO;
            [self.recommendSlides addObject:self.slide];
        }
        else if ([elementName isEqualToString:@"ID"]) {
            _slide.slideId = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"Title"]) {
            _slide.title = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"URL"]) {
            _slide.url = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"ThumbnailURL"]) {
            _slide.thumbnailUrl = [NSString trim:self.currentCharacters];
        }
    }
    else if (_isInRecommendSlides) {
        if ([elementName isEqualToString:@"RecommendSlides"]) {
            _isInRecommendSlides = NO;
            [self.results setObject:_recommendSlides forKey:@"RecommendSlides"];
        }
    }
}


@end