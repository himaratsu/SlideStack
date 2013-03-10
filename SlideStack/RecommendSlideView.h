//
//  RecommendSlideView.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
#import "SlideShowObject.h"

@protocol RecommendSlideViewDelegate <NSObject>

- (void)didTapRecommendSlideWithUrl:(NSString*)url title:(NSString*)title;

@end

@interface RecommendSlideView : UIButton {
    UILabel *_titleLabel;
    UIView  *_highlightedView;
}

@property (nonatomic, strong) CustomImageView *thumbnailImage;
@property (nonatomic, strong) SlideShowObject *slide;
@property (nonatomic, assign) id<RecommendSlideViewDelegate> delegate;

@end
