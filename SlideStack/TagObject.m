//
//  TagObject.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "TagObject.h"

@implementation TagObject

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.tagCount = [aDecoder decodeIntegerForKey:@"TagCount"];
        self.tagName = [aDecoder decodeObjectForKey:@"TagName"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_tagCount forKey:@"TagCount"];
    [aCoder encodeObject:_tagName forKey:@"TagName"];
}

@end
