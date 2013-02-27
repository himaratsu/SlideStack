//
//  SelectTagViewCell.m
//  SlideStack
//
//  Created by 平松 亮介 on 2013/02/28.
//  Copyright (c) 2013年 mashroom. All rights reserved.
//

#import "SelectTagViewCell.h"

@implementation SelectTagViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)willTransitionToState:(UITableViewCellStateMask)state
{
    // セルの状態を取得
    [super willTransitionToState:state];
    _deleteState = NO;
    
    if (UITableViewCellStateShowingDeleteConfirmationMask == (state & UITableViewCellStateShowingDeleteConfirmationMask)) {
        _deleteState = YES;
    }
    if (UITableViewCellStateShowingEditControlMask == (state & UITableViewCellStateShowingEditControlMask)) {
        _deleteState = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (_deleteState) {
        for (UIView *subview in self.subviews) {
            if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationControl"]) {
                
                // 削除ボタンの位置を直接動かすとアニメーションが不自然
//                UIView *deleteButtonView = (UIView *)[subview.subviews objectAtIndex:0];
//                CGRect f = deleteButtonView.frame;
//                f.origin.x -= 50;
//                deleteButtonView.frame = f;
                
//                subviewごと動かして対応
                CGRect sf = subview.frame;
                sf.origin.x -= 50;
                subview.frame = sf;
            }
        }
    }
}



@end
