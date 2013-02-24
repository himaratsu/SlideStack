//
//  TagWithCheckMarkObject.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "TagWithCheckMarkObject.h"

@implementation TagWithCheckMarkObject

- (id)initWithTagName:(NSString*)tagName {
    self = [super init];
    if (self) {
        self.tagName = tagName;
        _isChecked = NO;
    }
    return self;
}

- (id)initWithTagName:(NSString *)tagName isChecked:(BOOL)isChecked {
    self = [self initWithTagName:tagName];
    if (self) {
        _isChecked = isChecked;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.tagName = [aDecoder decodeObjectForKey:@"TagName"];
        self.isChecked = [aDecoder decodeBoolForKey:@"IsChecked"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_tagName forKey:@"TagName"];
    [aCoder encodeBool:_isChecked forKey:@"IsChecked"];
}

@end
