//
//  SlideTableViewCell.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/24.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SlideTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SlideTableViewCell

- (void)awakeFromNib {
    // スライドサムネイル
    _customImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _customImageView.layer.borderWidth = 1.0f;
    _customImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    _customImageView.layer.shadowOffset = CGSizeMake(0, 2);
    _customImageView.layer.shadowRadius = 1;
    _customImageView.layer.shadowOpacity = 0.3;
    _customImageView.layer.cornerRadius = 2.0;
    _customImageView.clipsToBounds = YES;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNumViews:(NSInteger)numViews {
    _numViews = numViews;
    _numViewsLabel.text = [NSString stringWithFormat:@"%d", _numViews];
    [_numViewsLabel sizeToFit];
}

- (void)setNumFavorites:(NSInteger)numFavorites {
    _numFavorites = numFavorites;
    _numFavoritesLabel.text = [NSString stringWithFormat:@"%d", _numFavorites];
    [_numFavoritesLabel sizeToFit];
}

- (void)setNumDownloads:(NSInteger)numDownloads {
    _numDownloads = numDownloads;
    _numDownloadsLabel.text = [NSString stringWithFormat:@"%d", _numDownloads];
    [_numDownloadsLabel sizeToFit];
}


@end
