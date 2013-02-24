//
//  NSString+MyString.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "NSString+MyString.h"

@implementation NSString (MyString)

+ (NSString *)trim:(NSMutableString*)str {
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
