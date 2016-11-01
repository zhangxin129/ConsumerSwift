//
//  GYHDSearchUserCell.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchUserCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDSearchUserModel.h"

@interface GYHDSearchUserCell ()

@property(nonatomic, strong)UIImageView *iconImageView;
@property(nonatomic, strong)UILabel     *nameLabel;
@property(nonatomic, strong)UILabel     *hushengLabel;

@end
@implementation GYHDSearchUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];
    
    self.nameLabel = [[ UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    [self.contentView addSubview:self.nameLabel];
    
    self.hushengLabel = [[ UILabel alloc] init];
    self.hushengLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
    self.hushengLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    [self.contentView addSubview:self.hushengLabel];
    WS(weakSelf);
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(12);
        make.bottom.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(5);
        make.top.equalTo(weakSelf.iconImageView);
        make.height.equalTo(weakSelf.iconImageView).multipliedBy(0.5);
        make.right.mas_equalTo(-24);
    }];
    
    [self.hushengLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.iconImageView.mas_right).offset(5);
        make.bottom.equalTo(weakSelf.iconImageView);
        make.height.equalTo(weakSelf.iconImageView).multipliedBy(0.5);
        make.right.mas_equalTo(-24);
    }];
//    self.iconImageView.backgroundColor = [UIColor randomColor];
//    self.nameLabel.backgroundColor = [UIColor randomColor];
//    self.hushengLabel.backgroundColor = [UIColor randomColor];
}
- (void)setModel:(GYHDSearchUserModel *)model
{
    _model = model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"]];
    self.nameLabel.text = model.nameString;
    self.hushengLabel.text = model.hushengString;
}
@end
