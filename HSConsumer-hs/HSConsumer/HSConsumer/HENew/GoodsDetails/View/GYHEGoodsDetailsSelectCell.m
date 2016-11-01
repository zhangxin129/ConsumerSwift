//
//  GYHEGoodsDetailsSelectCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsSelectCell.h"

@implementation GYHEGoodsDetailsSelectCell

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

    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth -2*12, 32)];
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.textColor = UIColorFromRGB(0x403000);
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.contentLabel];
}

@end
