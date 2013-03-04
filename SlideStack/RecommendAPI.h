//
//  RecommendAPI.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "CommonAPI.h"
#import "CommonAPIParser.h"
#import "SlideShowObject.h"

#define RECOMMEND_XML_URL @"http://samura1.net/collection/slidestack/recommend_tag.xml"

@interface RecommendAPI : CommonAPI

@end


@interface RecommendAPIParser : CommonAPIParser {
    BOOL _isInRecommendTags;
    BOOL _isInRecommendSlides;
    BOOL _isInRecommendSlide;
}

@property (nonatomic, strong) NSMutableArray *recommendTags;
@property (nonatomic, strong) NSMutableArray *recommendSlides;
@property (nonatomic, strong) SlideShowObject *slide;


@end