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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.frame = CGRectMake(10, 10, 300, 110);
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 180, 70)];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        self.customImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(210, 10, 90, 70)];
        _customImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _customImageView.layer.borderWidth = 1.0f;
        [self addSubview:_customImageView];
        
        self.numViewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 85, 80, 15)];
        _numViewsLabel.font = [UIFont boldSystemFontOfSize:13];
        _numViewsLabel.backgroundColor = [UIColor clearColor];
        _numViewsLabel.numberOfLines = 0;
        [self addSubview:_numViewsLabel];
        
        self.numFavoritesLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 85, 80, 15)];
        _numFavoritesLabel.font = [UIFont boldSystemFontOfSize:13];
        _numFavoritesLabel.backgroundColor = [UIColor clearColor];
        _numFavoritesLabel.numberOfLines = 0;
        [self addSubview:_numFavoritesLabel];
        
        self.numDownloadsLabel = [[UILabel alloc] initWithFrame:CGRectMake(210, 85, 80, 15)];
        _numDownloadsLabel.font = [UIFont boldSystemFontOfSize:13];
        _numDownloadsLabel.backgroundColor = [UIColor clearColor];
        _numDownloadsLabel.numberOfLines = 0;
        [self addSubview:_numDownloadsLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setNumViews:(NSInteger)numViews {
    _numViews = numViews;
    _numViewsLabel.text = [NSString stringWithFormat:@"View %d", _numViews];
}

- (void)setNumFavorites:(NSInteger)numFavorites {
    _numFavorites = numFavorites;
    _numFavoritesLabel.text = [NSString stringWithFormat:@"Fav %d", _numFavorites];
}

- (void)setNumDownloads:(NSInteger)numDownloads {
    _numDownloads = numDownloads;
    _numDownloadsLabel.text = [NSString stringWithFormat:@"DL %d", _numDownloads];
}


@end
