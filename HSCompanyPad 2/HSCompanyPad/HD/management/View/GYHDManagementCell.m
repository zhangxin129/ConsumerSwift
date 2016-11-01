//
//  GYHDManagementCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDManagementCell.h"

@interface GYHDManagementCell ()

@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UIView      *selectShowView;//选择蓝条显示

@end

@implementation GYHDManagementCell

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
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.contentView addSubview:self.titleLabel];
    
    
    [self.selectShowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(3);
        
    }];
    
    @weakify(self);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(21);
        make.bottom.mas_equalTo(-21);
        make.size.mas_equalTo(CGSizeMake(46, 46));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.iconImageView.mas_right).offset(13);
        make.centerY.equalTo(self.iconImageView);
        make.right.mas_equalTo(-10);
    }];
}
- (void)setModel:(GYHDManagementModel *)model {
    _model = model;
    self.iconImageView.image = [UIImage imageNamed:model.imageString];
    self.titleLabel.text = model.titleString;

    if (model.isSelect) {
        self.selectShowView.hidden=NO;
        self.backgroundColor = kDefaultVCBackgroundColor;
    }else{
        self.selectShowView.hidden=YES;
        self.backgroundColor=[UIColor clearColor];
        
    }
}
@end
