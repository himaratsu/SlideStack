//
//  SlideShowObject.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/23.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SlideShowObject : NSObject <NSCoding>

@property (nonatomic, strong) NSString *slideId;        // id
@property (nonatomic, strong) NSString *title;          // タイトル
@property (nonatomic, strong) NSString *description;    // 説明
@property (nonatomic, strong) NSString *userName;       // ユーザ名
@property (nonatomic, strong) NSString *url;            // url
@property (nonatomic, strong) NSString *thumbnailUrl;   // 画像url
@property (nonatomic, strong) NSString *thumbnailSmallUrl;  // 小画像urk
@property (nonatomic, strong) NSString   *created;
@property (nonatomic, strong) NSString   *Updated;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, assign) NSInteger numDownloads;
@property (nonatomic, assign) NSInteger numViews;
@property (nonatomic, assign) NSInteger numComments;
@property (nonatomic, assign) NSInteger numFavorites;
@property (nonatomic, assign) NSInteger numSlides;


@end
