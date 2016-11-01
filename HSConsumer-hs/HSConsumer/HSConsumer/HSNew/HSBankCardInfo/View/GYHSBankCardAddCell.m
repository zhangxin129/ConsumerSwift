//
//  GYHSBankCardAddCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBankCardAddCell.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSBankCardAddCell()




@end

@implementation GYHSBankCardAddCell

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
    
    UIFont *font = kBankCardAddCell;

    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = font;
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.detailTextField = [[UITextField alloc]init];
    self.detailTextField.textColor  = UIColorFromRGB(0x333333);
    self.detailTextField.textAlignment = NSTextAlignmentLeft;
    self.detailTextField.font = font;
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self addSubview:self.detailTextField];
    
    self.selectImageView = [[UIImageView alloc] init];
    [self addSubview:self.selectImageView];
    self.areaBtn = [[UIButton alloc]init];
    [self addSubview:self.areaBtn];
    
    self.defaultSwitch = [[UISwitch alloc] init];
    self.defaultSwitch.transform  = CGAffineTransformMakeScale(0.75, 0.75);
    self.defaultSwitch.frame = CGRectMake(kScreenWidth - 13 -40, 8, 40, 24);
    [self addSubview:self.defaultSwitch];
    
    self.layer.borderColor  = UIColorFromRGB(0xebebeb).CGColor;
    self.layer.borderWidth = 0.5;
    
    CGFloat leftX = 13;
    CGFloat leftY = 13;
    CGFloat leftWidth = 98;
    CGFloat height = 14;
    
    self.titleLabel.frame = CGRectMake(leftX, leftY, leftWidth, height);
    self.detailTextField.frame = CGRectMake(self.titleLabel.right, leftY, kScreenWidth -2*leftX -leftWidth, height);

}

-(void)refreshTitle:(NSString *)title placeholder:(NSString *)placeholder detail:(NSString *)detail {
    
    self.titleLabel.text = title;
    self.detailTextField.placeholder = placeholder;
    self.detailTextField.text = detail;
}

@end
