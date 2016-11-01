//
//  GYHSBankCardListCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSBankCardListCell.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSBankCardListCell()

@property (nonatomic,strong) UILabel *nameLabel;//姓名
@property (nonatomic,strong) UILabel *cardNoLabel;//卡号
@property (nonatomic,strong) UILabel *bankNameLabel;//银行名称
@property (nonatomic,strong) UILabel *defaultLabel;//默认
@property (nonatomic,strong) UIImageView *defaultImageView;//默认图片
@property (nonatomic,strong) UILabel *validLabel;//是否 验证
@property (nonatomic,strong) UIView *lineView;//分割线


@end

@implementation GYHSBankCardListCell

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
    
    //分割线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor  = UIColorFromRGB(0xebebeb);
    [self addSubview:self.lineView];
    
    //默认
    self.defaultLabel = [[UILabel alloc] init];
    self.defaultLabel.textColor = UIColorFromRGB(0x00a500);
    self.defaultLabel.textAlignment = NSTextAlignmentLeft;
    self.defaultLabel.font = kBankCardListCellFont;
    [self addSubview:self.defaultLabel];
    
    //默认图片
    self.defaultImageView = [[UIImageView alloc] init];
    self.defaultImageView.image = [UIImage imageNamed:@"gyhs_bank_default"];
    [self addSubview:self.defaultImageView];
    
    //设置默认开关
    self.defaultSwitch = [[UISwitch alloc] init];
    self.defaultSwitch.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [self addSubview:self.defaultSwitch];
    
    //删除银行卡
    self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteBtn.titleLabel.font = kBankCardListCellFont;
    [self.deleteBtn setTitle:kLocalized(@"GYHS_Address_DeleteBankCard") forState:UIControlStateNormal];
    self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.deleteBtn setTitleColor:UIColorFromRGB(0xef4136) forState:UIControlStateNormal];
    [self addSubview:self.deleteBtn];
    
    //是否验证
    self.validLabel = [[UILabel alloc] init];
    self.validLabel.font = kBankCardListCellFont;
    self.validLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.validLabel];
    
    //姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = kBankCardListCellFont;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor  = UIColorFromRGB(0x333333);
    [self addSubview:self.nameLabel];
    
    //卡号
    self.cardNoLabel = [[UILabel alloc] init];
    self.cardNoLabel.font = kBankCardListCellFont;
    self.cardNoLabel.textColor = UIColorFromRGB(0x333333);
    self.cardNoLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.cardNoLabel];
    
    //银行名称
    self.bankNameLabel = [[UILabel alloc]init];
    self.bankNameLabel.font =kBankCardListCellNameFont;
    self.bankNameLabel.textColor = UIColorFromRGB(0x666666);
    self.bankNameLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.bankNameLabel];

}

#pragma mark - get or set 
-(void)setModel:(GYHSCardBandModel *)model {
    
    self.nameLabel.text = model.realName;
    self.bankNameLabel.text = model.bankName;
    
    if(model.bankAccNo.length > 8) {
        self.cardNoLabel.text = [NSString stringWithFormat:@"%@ **** **** %@",[model.bankAccNo substringToIndex:4],[model.bankAccNo substringFromIndex:model.bankAccNo.length -4]];
    }else {
        self.cardNoLabel.text = model.bankAccNo;
    }

    CGFloat rightWidth = 123;
    CGFloat rightX = 15;
    CGFloat rightY = 13;
    
    CGFloat leftX = 13;
    CGFloat leftY = 13;
    
    self.lineView.frame = CGRectMake(kScreenWidth - rightWidth , rightY, 0.5, 60);
    self.nameLabel.frame = CGRectMake(leftX, leftY, kScreenWidth - rightWidth -leftX, 12);
    self.cardNoLabel.frame = CGRectMake(leftX, self.nameLabel.bottom + leftY, kScreenWidth - rightWidth -leftX, 12);
    self.bankNameLabel.frame = CGRectMake(leftX, self.cardNoLabel.bottom +leftY, kScreenWidth - rightWidth -leftX, 11);
    self.defaultLabel.frame = CGRectMake(kScreenWidth - rightWidth + rightX, rightY, 30, 12);
    self.defaultImageView.frame = CGRectMake(self.defaultLabel.right + 3, rightY, 12, 12);
    self.defaultSwitch.frame = CGRectMake(self.defaultLabel.right + 3, 5, 12, 12);
    
    self.deleteBtn.frame = CGRectMake(kScreenWidth - rightWidth + rightX, self.defaultLabel.bottom + rightY, rightWidth - leftX, 12);
    self.validLabel.frame = CGRectMake(kScreenWidth - rightWidth + rightX, self.deleteBtn.bottom + rightY, rightWidth - leftX, 11);
    
    self.defaultLabel.text = kLocalized(@"GYHS_Address_Default");
    if([model.isDefault isEqualToString:@"1"]) {
        self.defaultLabel.textColor = UIColorFromRGB(0x00a500);
        self.defaultImageView.hidden = NO;
        self.defaultSwitch.on = YES;
        self.defaultSwitch.hidden = YES;
    }else {
        self.defaultLabel.textColor = UIColorFromRGB(0x333333);
        self.defaultSwitch.hidden = NO;
        self.defaultSwitch.on = NO;
        self.defaultImageView.hidden = YES;
    }
    
    //是否验证
    if([model.isValidAccount isEqualToString:@"1"]) {
        self.validLabel.textColor = UIColorFromRGB(0x00a500);
        self.validLabel.text = kLocalized(@"GYHS_Banding_Authenticated");
    }else {
        
        self.validLabel.textColor = UIColorFromRGB(0x1d7dd6);
        self.validLabel.text = kLocalized(@"GYHS_Banding_No_Validation");
    }

}




@end
