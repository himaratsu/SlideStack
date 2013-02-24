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

@end



@interface ControlSortView : UIView

@property (nonatomic, assign) id<ControlSortViewDelegate> delegate;

@end
