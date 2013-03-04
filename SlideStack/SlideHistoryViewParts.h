//
//  SlideHistoryViewParts.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/03/04.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
#import "SlideShowObject.h"

@protocol SlideHistoryViewPartsDelegate <NSObject>

- (void)didTapSlideHistory:(SlideShowObject*)slide;

@end



@interface SlideHistoryViewParts : UIButton

@property (nonatomic, strong) SlideShowObject *slide;
@property (nonatomic, strong) CustomImageView *thumbView;

@property (nonatomic, assign) id<SlideHistoryViewPartsDelegate> delegate;

@end
