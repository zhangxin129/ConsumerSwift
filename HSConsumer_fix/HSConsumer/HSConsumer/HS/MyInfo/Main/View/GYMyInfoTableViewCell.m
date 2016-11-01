//
//  GYMyInfoTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-10-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMyInfoTableViewCell.h"

@implementation GYMyInfoTableViewCell {
    //图片
    __weak IBOutlet UIImageView* CellImg;
    //文字
    __weak IBOutlet UILabel* CellString;
}
- (void)awakeFromNib
{
    // Initialization code
    CellString.textColor = UIColorFromRGB(0x464646);
    self.vAccessoryView.textColor = UIColorFromRGB(0xA0A0A0);
    CellString.font = [UIFont systemFontOfSize:18];
    self.vAccessoryView.font = [UIFont systemFontOfSize:16];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithImg:(NSString*)imgName WithTitle:(NSString*)title
{

    CellImg.image = [UIImage imageNamed:imgName];
    CellString.text = title;


}

@end
