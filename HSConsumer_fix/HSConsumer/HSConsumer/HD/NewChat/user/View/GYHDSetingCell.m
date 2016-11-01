//
//  GYHDSetingCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSetingCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDSetingCell()

@property(nonatomic, strong)UILabel *tipsLabel;
@property(nonatomic, strong)UISwitch *setingSwitch;

@end

@implementation GYHDSetingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tipsLabel = [[UILabel alloc] init];
    self.setingSwitch = [[UISwitch alloc] init];
    [self.setingSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.setingSwitch];
    self.setingSwitch.onTintColor = [UIColor colorWithRed:250/255.0f green:71/255.0f blue:53/255.0f alpha:1];
    WS(weakSelf);
    [self.setingSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.lessThanOrEqualTo(weakSelf.setingSwitch.mas_right).offset(10);
        make.centerY.equalTo(weakSelf.contentView);
    }];

}
- (void)setModel:(GYHDSetingModel *)model {
    _model = model;
    self.tipsLabel.text = model.title;
    self.setingSwitch.on = model.setting;
}

- (void)switchClick:(UISwitch *)sw {
    self.model.setting = sw.on;
    if ([self.delegate respondsToSelector:@selector(swithClickWithCell:)]) {
        [self.delegate swithClickWithCell:self];
    }
}

@end
