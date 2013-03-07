//
//  ControlSortView.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ControlSortViewDelegate <NSObject>

- (void)sortChange:(NSString*)sortType;
- (void)tapAddTagButton;

@end



@interface ControlSortView : UIView {
    UIButton *relateBtn;
    UIButton *mostViewBtn;
    UIButton *mostDLBtn;
    UIButton *latestBtn;
    UIButton *addTagButton;
}

@property (nonatomic, assign) id<ControlSortViewDelegate> delegate;

- (void)selectSort:(NSString*)sortType;
- (void)highlightTagButton:(BOOL)isHighlight;

@end
