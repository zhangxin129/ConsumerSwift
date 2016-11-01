//
//  GYPOSVolumeCell.m
//  company
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPointVolumeCell.h"
#import "GYHSPublicMethod.h"
@implementation GYHSPointVolumeCell

- (void)awakeFromNib
{
    self.textNumber.textColor = kGray333333;
    self.textNumber.font = kFont32;
    self.faceLabel.textColor = kGray666666;
    self.faceLabel.font = kFont24;
    self.lineView.backgroundColor = kGrayc8c8d8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:@"gyhs_point_select"]];
        self.textNumber.textColor = kRedE40011;
        self.faceLabel.textColor = kRedE40011;
    } else {
        self.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:@"gyhs_point_noselect"]];
        self.textNumber.textColor = kGray333333;
        self.faceLabel.textColor = kGray666666;
    }
    
}


@end
