//
//  CustomImageView.h
//  dollerme
//
//  Created by 平松 亮介 on 2013/02/13.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomImageView : UIImageView

- (id)initWithFrame:(CGRect)frame withUrl:(NSURL *)url;
- (void)startLoadImage;
- (void)reloadImage;
- (void)cancelLoading;

@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, assign) BOOL  isLoaded;

@end
