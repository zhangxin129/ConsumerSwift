//
//  GYHSCancelDetermineCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCancelDetermineCell.h"
#import "GYHSTools.h"

@implementation GYHSCancelDetermineCell

- (void)awakeFromNib {
    // Initialization code
    self.cancelBtn.titleLabel.font = kButtonCellFont;
    self.determineBtn.titleLabel.font = kButtonCellFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark -- 取消
- (IBAction)cancel:(id)sender {
    if ([_cancelDetermineDelegate respondsToSelector:@selector(cancelLimitation)]) {
        [self.cancelDetermineDelegate cancelLimitation];
    }
}
#pragma mark -- 确定
- (IBAction)determine:(id)sender {
    if ([_cancelDetermineDelegate respondsToSelector:@selector(determineLimitation)]) {
        [self.cancelDetermineDelegate determineLimitation];
    }

}

@end
