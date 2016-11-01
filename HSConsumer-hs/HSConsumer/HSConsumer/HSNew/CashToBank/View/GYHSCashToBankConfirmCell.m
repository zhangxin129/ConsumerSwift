//
//  GYHSCashToBankConfirmCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCashToBankConfirmCell.h"
#import "GYHSTools.h"

@interface GYHSCashToBankConfirmCell()

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;

@end

@implementation GYHSCashToBankConfirmCell

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
    
    UIFont *font = kCashToBankBalanceCellFont;
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = font;
    [self addSubview:self.titleLabel];
    
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = font ;
    self.detailLabel.textAlignment = NSTextAlignmentRight;
    self.detailLabel.textColor = UIColorFromRGB(0xef4136);
    [self addSubview:self.detailLabel];
    
    CGFloat marginLeft = 13;
    CGFloat top = 13;
    CGFloat marginRight = 13;
    CGFloat height = 14;
    self.titleLabel.frame = CGRectMake(marginLeft, top, 150, height);
    self.detailLabel.frame = CGRectMake(150, top, kScreenWidth - 150 -marginRight, height);
    
}

-(void)refreshTitle:(NSString *)title detail:(NSString *)detail {

    self.titleLabel.text = title;
    self.detailLabel.text = detail;
}

@end
