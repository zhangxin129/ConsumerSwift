//
//  GYAccidentPromptTableViewCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAccidentPromptTableViewCell.h"

@interface GYAccidentPromptTableViewCell()



@end

@implementation GYAccidentPromptTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.warmLable setTextColor:kNumRednColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)btnAccidentInfoShow:(id)sender {
    if ([_btnAccidentInfoShowDelegate respondsToSelector:@selector(btnAccidentInfoShow)]) {
        [self.btnAccidentInfoShowDelegate btnAccidentInfoShow];
    }
}

@end
