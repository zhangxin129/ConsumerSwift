//
//  GYualificationTableViewCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYualificationTableViewCell.h"

@implementation GYualificationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)lbcontenttext:(NSString *)lbcontenttext lbcontentColor:(UIColor *)lbcontentColor lbTimetext:(NSString *)lbTimetext lbTimeColor:(UIColor *)lbTimeColor SecurityQualificationlbtext:(NSString *)SecurityQualificationlbtext SecurityQualificationlbColor:(UIColor *)SecurityQualificationlbColor
{
    self.SecurityQualificationlb.text = SecurityQualificationlbtext;
    self.SecurityQualificationlb.textColor = SecurityQualificationlbColor;
    self.lbcontent.text =  lbcontenttext;
    self.lbcontent.textColor = lbcontentColor;
    self.lbTime.textColor = lbTimeColor;
    self.lbTime.text = lbTimetext;
}
@end
