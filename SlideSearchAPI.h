//
//  SlideSearchAPI.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "CommonAPI.h"
#import "CommonAPIParser.h"
#import "SlideShowObject.h"
#import "TagObject.h"

@interface SlideSearchAPI : CommonAPI

@end


@interface SlideSearchAPIParser : CommonAPIParser {
    BOOL _isInSlideShows;
    BOOL _isInMeta;
    BOOL _isInSlideShow;
    BOOL _isInTags;
    BOOL _isInTag;
}

@property (nonatomic, strong) NSMutableArray *slideShows;
@property (nonatomic, strong) SlideShowObject *slideShow;
@property (nonatomic, strong) TagObject *tag;

@end