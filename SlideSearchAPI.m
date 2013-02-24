//
//  SlideSearchAPI.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideSearchAPI.h"
#import "NSString+MyString.h"
#import "MySettingViewController.h"

@implementation SlideSearchAPI

- (id)initWithDelegate:(id)delegate {
    self = [super init];
    if (self) {
        module_ = @"search_slideshows";
        delegate_ = delegate;
    }
    return self;
}

- (void)send:(NSDictionary*)param {
    NSMutableDictionary *mutParam = [NSMutableDictionary dictionaryWithDictionary:param];
    [mutParam setObject:[MySettingViewController sharedInstance].language forKey:@"lang"];
    [super send:[NSDictionary dictionaryWithDictionary:mutParam]];
}

- (void)parse:(NSData*)data {
    SlideSearchAPIParser* parser = [[SlideSearchAPIParser alloc] init];
    parser.delegate = delegate_;
    [parser parse:data];
}


@end

@implementation SlideSearchAPIParser

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
    
    if ([elementName isEqualToString:@"Slideshows"]) {
        _isInSlideShows = YES;
        self.slideShows = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"Meta"]) {
        _isInMeta = YES;
    }
    else if ([elementName isEqualToString:@"Slideshow"]) {
        _isInSlideShow = YES;
        self.slideShow = [[SlideShowObject alloc] init];
    }
    else if ([elementName isEqualToString:@"Tags"]) {
        _isInTags = YES;
        _slideShow.tags = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"Tag"]) {
        _isInTag = YES;
        self.tag = [[TagObject alloc] init];
        // カウントを取得
        _tag.tagCount = [[attributeDict objectForKey:@"Count"] integerValue];
        self.currentCharacters = [NSMutableString string];
    }
    else if ([elementName isEqualToString:@"Query"]
             || [elementName isEqualToString:@"ResultOffset"]
             || [elementName isEqualToString:@"NumResults"]
             || [elementName isEqualToString:@"TotalResults"]
             || [elementName isEqualToString:@"ID"]
             || [elementName isEqualToString:@"Title"]
             || [elementName isEqualToString:@"Description"]
             || [elementName isEqualToString:@"Username"]
             || [elementName isEqualToString:@"URL"]
             || [elementName isEqualToString:@"ThumbnailURL"]
             || [elementName isEqualToString:@"ThumbnailSmallURL"]
             || [elementName isEqualToString:@"Embed"]
             || [elementName isEqualToString:@"Created"]
             || [elementName isEqualToString:@"Updated"]
             || [elementName isEqualToString:@"UserID"]
             || [elementName isEqualToString:@"NumDownloads"]
             || [elementName isEqualToString:@"NumViews"]
             || [elementName isEqualToString:@"NumComments"]
             || [elementName isEqualToString:@"NumFavorites"]
             || [elementName isEqualToString:@"NumSlides"]) {
        self.currentCharacters = [NSMutableString string];
    }
}

// 要素の閉じタグを読み込み
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
//    LOG(@"start[%@]", elementName);
    
    if (_isInSlideShows && [elementName isEqualToString:@"Slideshows"]) {
        _isInSlideShows = NO;
        [self.results setObject:_slideShows forKey:@"SlideShows"];
    }
    else if (_isInMeta && [elementName isEqualToString:@"Meta"]) {
        _isInMeta = NO;
    }
    else if (_isInMeta) {
        if ([elementName isEqualToString:@"Query"]) {
            [self.results setObject:[NSString trim:self.currentCharacters] forKey:@"Query"];
        }
        else if ([elementName isEqualToString:@"ResultOffset"]) {
            [self.results setObject:[NSString trim:self.currentCharacters] forKey:@"ResultOffset"];
        }
        else if ([elementName isEqualToString:@"NumResults"]) {
            [self.results setObject:[NSString trim:self.currentCharacters] forKey:@"NumResults"];
        }
        else if ([elementName isEqualToString:@"TotalResults"]) {
            [self.results setObject:[NSString trim:self.currentCharacters] forKey:@"TotalResults"];
        }
    }
    else if (_isInSlideShow && [elementName isEqualToString:@"Slideshow"]) {
        _isInSlideShow = NO;
        [_slideShows addObject:_slideShow];
    }
    else if (_isInSlideShow) {
        if (_isInTags) {
            if ([elementName isEqualToString:@"Tags"]) {
                _isInTags = NO;
            }
            if (_isInTag && [elementName isEqualToString:@"Tag"]) {
                _isInTag = NO;
                _tag.tagName = [NSString trim:self.currentCharacters];
                [_slideShow.tags addObject:_tag];
            }
        }
        else if ([elementName isEqualToString:@"ID"]) {
            _slideShow.slideId = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"Title"]) {
            _slideShow.title   = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"Description"]) {
            _slideShow.description = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"Username"]) {
            _slideShow.userName = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"URL"]) {
            _slideShow.url = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"ThumbnailURL"]) {
            _slideShow.thumbnailUrl = [self appendProtocol:[NSString trim:self.currentCharacters]];
        }
        else if ([elementName isEqualToString:@"ThumbnailSmallURL"]) {
            _slideShow.thumbnailSmallUrl = [self appendProtocol:[NSString trim:self.currentCharacters]];
        }
        else if ([elementName isEqualToString:@"Embed"]) {
            _slideShow.embed = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"Created"]) {
            _slideShow.created = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"Updated"]) {
            _slideShow.Updated = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"UserID"]) {
            _slideShow.userId = [NSString trim:self.currentCharacters];
        }
        else if ([elementName isEqualToString:@"NumDownloads"]) {
            _slideShow.numDownloads = [[NSString trim:self.currentCharacters] integerValue];
        }
        else if ([elementName isEqualToString:@"NumViews"]) {
            _slideShow.numViews = [[NSString trim:self.currentCharacters] integerValue];
        }
        else if ([elementName isEqualToString:@"NumComments"]) {
            _slideShow.numComments = [[NSString trim:self.currentCharacters] integerValue];
        }
        else if ([elementName isEqualToString:@"NumFavorites"]) {
            _slideShow.numFavorites = [[NSString trim:self.currentCharacters] integerValue];
        }
    }
}

- (NSString*)appendProtocol:(NSString*)url {
    return [NSString stringWithFormat:@"http:%@", url];
}



@end