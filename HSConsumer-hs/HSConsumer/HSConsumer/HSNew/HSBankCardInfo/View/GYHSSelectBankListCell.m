//
//  GYHSSelectBankListCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSelectBankListCell.h"
#import "GYHSTools.h"

@implementation GYHSSelectBankListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 13, kScreenWidth - 40, 14)];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = kSelectBankListCell;
    [self addSubview:self.titleLabel];
    
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.backgroundColor = UIColorFromRGB(0xffffff);
}

@end
