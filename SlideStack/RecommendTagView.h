//
//  RecommendTagView.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/03.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_FONT_SIZE 20.0
#define TAG_DEFAULT_FONT [UIFont systemFontOfSize:TAG_FONT_SIZE]

#define TAG_DEFAULT_FONTCOLOR [UIColor colorWithRed:70/255.0 green:142/255.0 blue:244/255.0 alpha:1.0]
#define TAG_DEFAULT_BGCOLOR [UIColor colorWithRed:231/255.0 green:242/255.0 blue:253/255.0 alpha:1.0]
#define TAG_DEFAULT_BORDERCOLOR [UIColor colorWithRed:190/255.0 green:219/255.0 blue:251/255.0 alpha:1.0].CGColor



@interface RecommendTagView : UIButton {
    UILabel *_tagNameLabel;
    UIView  *_highlightedView;
}

@property (nonatomic, strong) NSString *tagName;
@property (nonatomic, strong) NSString *displayTagName;

- (id)initWithTagName:(NSString*)tagName;

@end
