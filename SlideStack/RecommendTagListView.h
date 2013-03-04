//
//  RecommendTagListView.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MARGIN_UP_BOTTOM    10
#define MARGIN_LEFT_RIGHT   10

@protocol RecommendTagListViewDelegate <NSObject>

- (void)didTapRecomeendTag:(NSString*)tagName;

@end


@interface RecommendTagListView : UIView

@property (nonatomic, strong) NSMutableArray *tagList;
@property (nonatomic, assign) id<RecommendTagListViewDelegate> delegate;

- (CGFloat)heightForTagList;

@end
