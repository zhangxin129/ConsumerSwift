//
//  GYHESCChooseAreaTableViewCell.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/24.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESCChooseAreaTableViewCell.h"

@implementation GYHESCChooseAreaTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)refreshDataWithModel:(GYHESCChooseAreaModel*)model
{
    self.addressLabel.text = model.addr;
    self.telphoneLabel.text = model.tel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
