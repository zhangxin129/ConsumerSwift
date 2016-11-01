//
//  GYHEHeadViewFirstCell.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEHeadViewFirstCell.h"

@implementation GYHEHeadViewFirstCell

//点击时间按钮
- (IBAction)clickTimeView:(id)sender {
    NSLog(@"时间按钮被点击了");
}





- (void)awakeFromNib {
    [super awakeFromNib];
    _textLabelFirst.text = @"预约/预订时间";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
