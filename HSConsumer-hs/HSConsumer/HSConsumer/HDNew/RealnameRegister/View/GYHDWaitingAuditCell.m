//
//  GYHDWaitingAuditCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDWaitingAuditCell.h"
#import "GYHSTools.h"

@interface GYHDWaitingAuditCell ()

@end
@implementation GYHDWaitingAuditCell

- (void)awakeFromNib {
    // Initialization code
   
    self.auditLb.textColor = kSuccessLbCorlor;
    self.warmPromptLb.textColor = kSuccessLbCorlor;
    self.auditLb.font = kButtonCellFont;
    self.warmPromptLb.font = kWarmCellFont;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
