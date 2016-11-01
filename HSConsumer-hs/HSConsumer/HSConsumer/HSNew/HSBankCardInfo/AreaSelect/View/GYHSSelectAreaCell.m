//
//  GYHSSelectAreaCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSelectAreaCell.h"
#import "GYHSTools.h"

@implementation GYHSSelectAreaCell

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

    UIFont *font = KSelectAreaCellFont;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = font;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textColor = UIColorFromRGB(0x666666);
    self.detailLabel.font = font;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.detailLabel];
    
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.layer.borderWidth = 0.5;
    
    self.titleLabel.frame  = CGRectMake(13, 13, 160, 14);
    self.detailLabel.frame = CGRectMake(kScreenWidth -200-20-20, 13, 200, 14);
}

@end
