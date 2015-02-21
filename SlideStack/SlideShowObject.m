//
//  SlideShowObject.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideShowObject.h"

@implementation SlideShowObject

@synthesize description = _description;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.slideId = [aDecoder decodeObjectForKey:@"SlideId"];
        self.title   = [aDecoder decodeObjectForKey:@"Title"];
        self.description = [aDecoder decodeObjectForKey:@"Description"];
        self.userName = [aDecoder decodeObjectForKey:@"UserName"];
        self.url = [aDecoder decodeObjectForKey:@"Url"];
        self.thumbnailUrl = [aDecoder decodeObjectForKey:@"ThumbnailUrl"];
        self.thumbnailSmallUrl = [aDecoder decodeObjectForKey:@"ThumbnailSmallUrl"];
        self.created = [aDecoder decodeObjectForKey:@"Created"];
        self.Updated = [aDecoder decodeObjectForKey:@"Updated"];
        self.tags = [aDecoder decodeObjectForKey:@"Tags"];
        self.numDownloads = [aDecoder decodeIntegerForKey:@"NumDownloads"];
        self.numViews = [aDecoder decodeIntegerForKey:@"NumViews"];
        self.numComments = [aDecoder decodeIntegerForKey:@"NumComments"];
        self.numFavorites = [aDecoder decodeIntegerForKey:@"NumFavorites"];
        self.numSlides = [aDecoder decodeIntegerForKey:@"NumSlides"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_slideId forKey:@"SlideId"];
    [aCoder encodeObject:_title forKey:@"Title"];
    [aCoder encodeObject:_description forKey:@"Description"];
    [aCoder encodeObject:_userName forKey:@"UserName"];
    [aCoder encodeObject:_url forKey:@"Url"];
    [aCoder encodeObject:_thumbnailUrl forKey:@"ThumbnailUrl"];
    [aCoder encodeObject:_thumbnailSmallUrl forKey:@"ThumbnailSmallUrl"];
    [aCoder encodeObject:_created forKey:@"Created"];
    [aCoder encodeObject:_Updated forKey:@"Updated"];
    [aCoder encodeObject:_tags forKey:@"Tags"];
    [aCoder encodeInteger:_numDownloads forKey:@"NumDownloads"];
    [aCoder encodeInteger:_numViews forKey:@"NumViews"];
    [aCoder encodeInteger:_numComments forKey:@"NumComments"];
    [aCoder encodeInteger:_numFavorites forKey:@"NumFavorites"];
    [aCoder encodeInteger:_numSlides forKey:@"NumSlides"];
}


@end
