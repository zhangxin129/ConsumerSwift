//
//  GYHDAdvisoryCustormerCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDAdvisoryCustormerCell.h"

@interface GYHDAdvisoryCustormerCell ()
@property(nonatomic, strong)UIButton    *selectButton;
@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel     *titleLabel;
@property(nonatomic, strong)UILabel     *operNumLabel;
@property(nonatomic, strong)UILabel     *detailLabel;
@end

@implementation GYHDAdvisoryCustormerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"gyhd_choose_btn_normal"] forState:UIControlStateNormal];
    [self.selectButton setBackgroundImage:[UIImage imageNamed:@"gyhd_choose_btn_select"] forState:UIControlStateSelected];
    [self.contentView addSubview:self.selectButton];
    
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 3.0f;
    [self.contentView addSubview:self.iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.titleLabel];
    
    self.operNumLabel = [[UILabel alloc] init];
    self.operNumLabel.font = [UIFont systemFontOfSize:14.0f];
    self.operNumLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.contentView addSubview:self.operNumLabel];

    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:14.0f];
    self.detailLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.contentView addSubview:self.detailLabel];
    
    
    @weakify(self);
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.equalTo(self.iconImageView);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.selectButton.mas_right).offset(8);
        make.top.mas_equalTo(22);
        make.bottom.mas_equalTo(-22);
        make.size.mas_equalTo(CGSizeMake(46, 46));
        
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(15);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
    
    [self.operNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(20);
        make.top.equalTo(self.titleLabel.mas_bottom);
    }];

    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
        make.right.mas_equalTo(-10);
        make.top.equalTo(self.operNumLabel.mas_bottom);
    }];
   
}

-(void)setModel:(GYHDCustomerServiceOnLineModel *)model{

    _model=model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.iconUrl]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    self.titleLabel.text =model.name;
    self.operNumLabel.text=model.operNum;
    self.detailLabel.text = model.roleStr;
    
    if (model.isSelect) {
        
        self.selectButton.selected=YES;
        
    }else{
    
        self.selectButton.selected=NO;
    }
    
}
@end
