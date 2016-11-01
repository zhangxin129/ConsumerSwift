//
//  GYHDContactsGroupCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/5.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDContactsGroupCell.h"
#import <YYKit/UIImageView+YYWebImage.h>
@interface GYHDContactsGroupCell ()
@property(nonatomic, strong)UIImageView *iconImageView;//头像
@property(nonatomic, strong)UIImageView *sexImageView;//性别
@property(nonatomic, strong)UILabel     *NameLabel;//姓名
@property(nonatomic, strong)UILabel     *operatingLabel;//操作号
@property(nonatomic, strong)UILabel     *intergrowthLabel;//互生号
@property(nonatomic, strong)UIView      *selectShowView;//选择蓝条显示
@end

@implementation GYHDContactsGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.selectShowView=[[UIView alloc]init];
    self.selectShowView.backgroundColor=[UIColor colorWithRed:48/255.0 green:152/255.0 blue:229/255.0 alpha:1.0];
    self.selectShowView.hidden=YES;
    [self.contentView addSubview:self.selectShowView];
    
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:self.iconImageView];
    
    self.sexImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.sexImageView];
    
    self.NameLabel = [[UILabel alloc] init];
    self.NameLabel.font = [UIFont systemFontOfSize:16.0f];
    self.NameLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.NameLabel];
    
    self.operatingLabel = [[UILabel alloc] init];
    self.operatingLabel.font = [UIFont systemFontOfSize:14.0f];
    self.operatingLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.contentView addSubview:self.operatingLabel];
    
    self.intergrowthLabel = [[UILabel alloc] init];
    self.intergrowthLabel.font = [UIFont systemFontOfSize:14.0f];
    self.intergrowthLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.contentView addSubview:self.intergrowthLabel];
    
    @weakify(self);
    
    [self.selectShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(3);
        
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];

    [self.NameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.operatingLabel.mas_top).offset(-6);
        make.top.mas_equalTo(18);
        make.right.mas_lessThanOrEqualTo(-30);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    [self.operatingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.contentView);
        make.right.mas_lessThanOrEqualTo(-30);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    [self.intergrowthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.operatingLabel.mas_bottom).offset(6);
        make.right.mas_lessThanOrEqualTo(-30);
        make.bottom.mas_equalTo(-18);
    }];
    [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.NameLabel);
        make.left.equalTo(self.NameLabel.mas_right).offset(5);
    }];
    
}
-(void)setModel:(GYHDOpereotrListModel *)model{

    NSDictionary*dic=model.searchUserInfo;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,dic[@"headImage"]]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    
    self.NameLabel.text=dic[@"operName"];
    
    self.operatingLabel.text=[NSString stringWithFormat:@"%@:%@",kLocalized(@"GYHD_Employee_Number"),dic[@"username"]];
    
    NSString*resNoStr=kSaftToNSString(dic[@"resNo"]);
    
//    if (resNoStr.length>0 ) {
    
        self.intergrowthLabel.text=[NSString stringWithFormat:@"%@:%@",kLocalized(@"GYHD_Alternate_Number"),resNoStr];
//    }
    NSString*sexStr=kSaftToNSString(dic[@"sex"]);
    
    if ([sexStr isEqualToString:@"1"]) {
        
        self.sexImageView.image=[UIImage imageNamed:@"gyhd_man_icon"];

    }else if ([sexStr isEqualToString:@"0"]){
    
    self.sexImageView.image=[UIImage imageNamed:@"gyhd_woman_icon"];
        
    }
    
    if (model.isSelect) {
        
        self.selectShowView.hidden=NO;
        
        self.contentView.backgroundColor=kDefaultVCBackgroundColor;
        
    }else{
    
        self.selectShowView.hidden=YES;
        
        self.contentView.backgroundColor=[UIColor whiteColor];
    }
    
    
   
}

@end
