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

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet CustomImageView *customImageView;

@property (nonatomic, strong) IBOutlet UILabel *numViewsLabel;
@property (nonatomic, strong) IBOutlet UILabel *numFavoritesLabel;
@property (nonatomic, strong) IBOutlet UILabel *numDownloadsLabel;

@property (nonatomic, assign) NSInteger numViews;
@property (nonatomic, assign) NSInteger numFavorites;
@property (nonatomic, assign) NSInteger numDownloads;

@end
