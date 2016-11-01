//
//  GYHEHeadViewSecondCell.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEHeadViewSecondCell.h"

@implementation GYHEHeadViewSecondCell

//开关控件方法
- (IBAction)switchOnOrOff:(UISwitch *)sender {
    NSLog(@"sender.value == %d",sender.on);
    //还需要刷新表视图
    if (sender.on == NO) {
        [self.delegate reloadData:4];
    }
    else
    {
    [self.delegate reloadData:5];
    }
}




- (void)awakeFromNib {
    [super awakeFromNib];
    _titleLabelFirst.text = @"是否属于上门服务业务";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
