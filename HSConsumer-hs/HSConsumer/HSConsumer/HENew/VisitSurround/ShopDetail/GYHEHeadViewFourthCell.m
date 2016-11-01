//
//  GYHEHeadViewFourthCell.m
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEHeadViewFourthCell.h"

@implementation GYHEHeadViewFourthCell
//点击跳转新地址
- (IBAction)clickGoToChangeAdress:(UIButton *)sender {
    NSLog(@"点击跳转新地址");
}





- (void)awakeFromNib {
    [super awakeFromNib];
    _contactPersonLabel.text = @"联系人:";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
