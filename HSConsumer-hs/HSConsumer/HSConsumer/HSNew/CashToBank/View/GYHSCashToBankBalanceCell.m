//
//  GYHSCashToBankBalanceCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCashToBankBalanceCell.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSCashToBankBalanceCell()

@property (nonatomic,strong) UILabel *titleLabel;//标题


@end

@implementation GYHSCashToBankBalanceCell

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
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = font;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLabel];
    
    self.detailTextField = [[UITextField alloc] init];
    self.detailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.detailTextField.textColor = UIColorFromRGB(0xef4136);
    self.detailTextField.textAlignment = NSTextAlignmentLeft;
    self.detailTextField.font = font;
    [self addSubview:self.detailTextField];
    
    self.selectBankImageView = [[UIImageView alloc] init];
    self.selectBankImageView.image = [UIImage imageNamed:@"hs_cell_btn_bank"];
    [self addSubview:self.selectBankImageView];
    
    
    CGFloat leftX = 13;
    CGFloat leftY = 0;//13
    CGFloat rightX = 151;
    CGFloat rightY = 0;//13
    CGFloat height = 40;//14
    
    self.titleLabel.frame = CGRectMake(leftX, leftY, rightX -leftX, height);
    self.detailTextField.frame = CGRectMake(rightX, rightY, kScreenWidth -rightX, height            );
    self.selectBankImageView.frame = CGRectMake(kScreenWidth - 18 -30, 10, 30, 20);
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.layer.borderWidth = 0.5;
    
}

-(void)refreshTitle:(NSString *)title placehold:(NSString *)placehold detail:(NSString *)detail  {

    self.titleLabel.text = title;
    self.detailTextField.placeholder = placehold;
    self.detailTextField.text = detail;
}

@end
