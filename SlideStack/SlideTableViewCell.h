//
//  SlideTableViewCell.h
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"

@interface SlideTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) CustomImageView *customImageView;

@property (nonatomic, strong) UILabel *numViewsLabel;
@property (nonatomic, strong) UILabel *numFavoritesLabel;
@property (nonatomic, strong) UILabel *numDownloadsLabel;

@property (nonatomic, assign) NSInteger numViews;
@property (nonatomic, assign) NSInteger numFavorites;
@property (nonatomic, assign) NSInteger numDownloads;

@end
