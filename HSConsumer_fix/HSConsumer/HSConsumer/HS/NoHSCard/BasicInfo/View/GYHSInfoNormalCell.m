//
//  GYHSInfoNormalCell.m
//  HSConsumer
//
//  Created by zhangqy on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSInfoNormalCell.h"

@implementation GYHSInfoNormalCell

- (void)awakeFromNib
{
    _titleLabel.textColor = kCellItemTitleColor;
    [self.textField addTarget:self action:@selector(changeTextFieldAction:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)changeTextFieldAction:(UITextField*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(inputTextField:indexPath:)]) {
        [self.cellDelegate inputTextField:sender.text indexPath:self.indexPath];
    }
}

@end
