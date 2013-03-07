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
        self.contentView.frame = CGRectMake(0, 0, 320, 110);
        self.contentView.backgroundColor = DEFAULT_BGCOLOR;
        
        // タイトル
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 15, 180, 60)];
        _titleLabel.font = [UIFont systemFontOfSize:SLIDE_CELL_TITLE_FONT_SIZE];
        _titleLabel.textColor = DEFAULT_FONTCOLOR;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        [self addSubview:_titleLabel];
        
        // スライドサムネイル
        self.customImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(10, 15, 105, 80)];
        _customImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _customImageView.layer.borderWidth = 1.0f;
        _customImageView.layer.shadowColor = [UIColor grayColor].CGColor;
        _customImageView.layer.shadowOffset = CGSizeMake(0, 2);
        _customImageView.layer.shadowRadius = 1;
        _customImageView.layer.shadowOpacity = 0.3;
        _customImageView.layer.cornerRadius = 2.0;
        _customImageView.clipsToBounds = YES;
        [self addSubview:_customImageView];
        
        
        CGFloat x = 125;
        CGFloat y = 70;
        
        // fav数
        UIImage *favImage  = [UIImage imageNamed:@"fav_black.png"];
        UIImageView *favImageView = [[UIImageView alloc] initWithImage:favImage];
        favImageView.frame = CGRectMake(x, y, 30, 30);
        [self addSubview:favImageView];
        
        x += 27;
        self.numFavoritesLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y+8, 50, 15)];
        _numFavoritesLabel.font = [UIFont boldSystemFontOfSize:SLIDE_CELL_COUNT_FONT_SIZE];
        _numFavoritesLabel.textColor = DEFAULT_FONTCOLOR;
        _numFavoritesLabel.backgroundColor = [UIColor clearColor];
        _numFavoritesLabel.numberOfLines = 0;
        [self addSubview:_numFavoritesLabel];
        
        // DL数
        x += 25;
        UIImage *downloadImage = [UIImage imageNamed:@"download_black.png"];
        UIImageView *downloadImageView = [[UIImageView alloc] initWithImage:downloadImage];
        downloadImageView.frame = CGRectMake(x, y, 30, 30);
        [self addSubview:downloadImageView];
        
        x += 27;
        self.numDownloadsLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y+8, 50, 15)];
        _numDownloadsLabel.font = [UIFont boldSystemFontOfSize:SLIDE_CELL_COUNT_FONT_SIZE];
        _numDownloadsLabel.textColor = DEFAULT_FONTCOLOR;
        _numDownloadsLabel.backgroundColor = [UIColor clearColor];
        _numDownloadsLabel.numberOfLines = 0;
        [self addSubview:_numDownloadsLabel];
        
        // 視聴数
        x += 25;
        UIImage *viewImage = [UIImage imageNamed:@"view_black.png"];
        UIImageView *viewImageView = [[UIImageView alloc] initWithImage:viewImage];
        viewImageView.frame = CGRectMake(x, y, 30, 30);
        [self addSubview:viewImageView];
        
        x += 27;
        self.numViewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y+8, 50, 15)];
        _numViewsLabel.font = [UIFont boldSystemFontOfSize:SLIDE_CELL_COUNT_FONT_SIZE];
        _numViewsLabel.textColor = DEFAULT_FONTCOLOR;
        _numViewsLabel.backgroundColor = [UIColor clearColor];
        _numViewsLabel.numberOfLines = 0;
        [self addSubview:_numViewsLabel];
        
        // ズルイ線（黒背景用）
//        UIView *borderUpper = [[UIView alloc] initWithFrame:CGRectMake(0, 106, 320, 2)];
//        borderUpper.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
//        borderUpper.layer.shadowOpacity = 0.1;
//        borderUpper.layer.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
//        borderUpper.layer.shadowOffset = CGSizeMake(320, 1);
//        [self addSubview:borderUpper];
//        
//        UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 108, 320, 1)];
//        borderBottom.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
//        [self addSubview:borderBottom];
        
        // ズルイ線（黒背景用）
        UIView *borderUpper = [[UIView alloc] initWithFrame:CGRectMake(0, 108, 320, 1)];
        borderUpper.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        borderUpper.layer.shadowOpacity = 0.1;
        borderUpper.layer.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1].CGColor;
        borderUpper.layer.shadowOffset = CGSizeMake(320, 1);
        [self addSubview:borderUpper];

        UIView *borderBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 109, 320, 1)];
        borderBottom.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        [self addSubview:borderBottom];
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
    _numViewsLabel.text = [NSString stringWithFormat:@"%d", _numViews];
}

- (void)setNumFavorites:(NSInteger)numFavorites {
    _numFavorites = numFavorites;
    _numFavoritesLabel.text = [NSString stringWithFormat:@"%d", _numFavorites];
}

- (void)setNumDownloads:(NSInteger)numDownloads {
    _numDownloads = numDownloads;
    _numDownloadsLabel.text = [NSString stringWithFormat:@"%d", _numDownloads];
}


@end
