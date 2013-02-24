//
//  TagManager.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "TagManager.h"
#import "TagWithCheckMarkObject.h"

@implementation TagManager

static TagManager *sharedInstance = nil;

+ (TagManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[TagManager alloc] init];
    }
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.allTags = [self loadTags];
    }
    return self;
}

// 独自のタグを追加
- (void)addOriginalTag:(NSString *)originalTagName {
    TagWithCheckMarkObject *tag = [[TagWithCheckMarkObject alloc] initWithTagName:originalTagName isChecked:YES];
    [_myOriginalTags addObject:tag];
    [self saveTags];
}

// チェック状態の更新
- (void)updateCheckMarkState:(NSString *)tagName isCheck:(BOOL)isCheck {
    NSArray *itemArray = [NSArray array];
    TagWithCheckMarkObject *tag;
    
    for (int i=0; i<[_allTags count]; i++) {
        itemArray = [_allTags objectAtIndex:i];
        for (int j=0; j<[itemArray count]; j++) {
            tag = [itemArray objectAtIndex:j];
            if ([tag.tagName isEqualToString:tagName]) {
                tag.isChecked = isCheck;
                break ;
            }
        }
    }
    [self saveTags];
}

// データの保存
- (void)saveTags {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:_allTags];
    [defaults setObject:saveData forKey:@"AllTags"];
    [defaults synchronize];
}

// 保存データの読み込み
- (NSMutableArray*)loadTags {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *loadData = [defaults objectForKey:@"AllTags"];
    NSMutableArray *loadArray = [NSKeyedUnarchiver unarchiveObjectWithData:loadData];
    if (loadArray) {
        self.myOriginalTags = [loadArray objectAtIndex:0];
        return loadArray;
    }
    else {
        return [NSMutableArray arrayWithArray:[self defaultArray]];
    }
}

- (NSArray *)defaultArray {
    NSArray *defaultArray = [NSArray array];
    self.myOriginalTags = [NSMutableArray array];
    NSArray* program = [self stringArrayToTagArray:
                        @[@"HTML", @"CSS", @"JavaScript", @"Perl", @"PHP",
                        @"Ruby", @"Python", @"Java", @"Objectice-C",
                        @"ActionScript", @"SQL"]
                        ];
    NSArray* library = [self stringArrayToTagArray:
                        @[@"jQuery", @"WordPress", @"MovableType", @"CakePHP",
                        @"Symfony", @"Rails", @"RSpec", @"Catalyst",
                        @"Django", @"Titanium", @"Node.js"]
                        ];
    NSArray *develop = [self stringArrayToTagArray:
                        @[@"Git", @"Subversion", @"Redmine", @"Trac", @"DDD",
                        @"TDD", @"Hudson", @"Security", @"DataMining",
                        @"Vim", @"Emacs"]
                        ];
    NSArray *server = [self stringArrayToTagArray:
                       @[@"Server", @"Infrastructure", @"Apache", @"MySQL",
                       @"PostgreSQL", @"MongoDB", @"memchached",
                       @"Virtualization", @"Linux", @"AWS", @"Cloud"]
                       ];
    NSArray *other = [self stringArrayToTagArray:
                      @[@"Twitter", @"Facebook", @"Marketing", @"SEO",
                      @"WebDesign", @"Photoshop", @"Flash"
                      @"Mobile", @"iPhone", @"iPad", @"Android"]];
    defaultArray = [NSArray arrayWithObjects:_myOriginalTags, program, library, develop, server, other, nil];
    
    return defaultArray;
}

// チェックのついているタグのリストを作成して返す
- (NSArray *)checkedTagArray {
    NSMutableArray *checkedTagArray = [NSMutableArray array];
    
    NSArray *itemArray = [NSArray array];
    TagWithCheckMarkObject *tag;
    
    for (int i=0; i<[_allTags count]; i++) {
        itemArray = [_allTags objectAtIndex:i];
        for (int j=0; j<[itemArray count]; j++) {
            tag = [itemArray objectAtIndex:j];
            if (tag.isChecked) {
                // チェックのついてるタグを取得
                [checkedTagArray addObject:tag];
            }
        }
    }
    
    return [NSArray arrayWithArray:checkedTagArray];
}

// 文字列のarray -> TagWithCheckMarkのarray
- (NSArray*)stringArrayToTagArray:(NSArray*)stringArray {
    NSMutableArray *tagArray = [NSMutableArray array];
    
    for (NSString* tagName in stringArray) {
        [tagArray addObject: [[TagWithCheckMarkObject alloc] initWithTagName:tagName]];
    }
    
    return tagArray;
}


@end
