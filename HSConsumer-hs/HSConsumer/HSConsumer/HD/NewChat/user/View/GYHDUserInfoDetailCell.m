//
//  GYHDUserInfoDetailCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUserInfoDetailCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDUserInfoDetailCell ()

@property(nonatomic, strong)UIImageView *sexImageView;

@end

@implementation GYHDUserInfoDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        self.leftBottomLabel.font = [UIFont systemFontOfSize:16];
        self.leftBottomLabel.textColor = [UIColor colorWithRed:250 / 255.0f green:60 / 255.0f blue:40 / 255.0f alpha:1];
        WS(weakSelf)
        self.sexImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.sexImageView];
                
        [self.sexImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.leftTopLabel.mas_right);
            make.centerY.equalTo(weakSelf.leftTopLabel);
        }];
    }
    return self;
}

- (void)setModel:(GYHDUserInfoDetailModel *)model {
    _model = model;
    if ([model.iconString hasPrefix:@"http"]) {
        [self.leftImageView setImageWithURL:[NSURL URLWithString:model.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }else {
        self.leftImageView.image = [UIImage imageWithContentsOfFile:model.iconString];
    }

    self.leftTopLabel.text = model.nikeNameString;
    self.leftBottomLabel.text = model.huShengString;
    if ([model.sexString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Man"]]) {
        [self.sexImageView setImage:[UIImage imageNamed:@"gyhd_man_icon"]];
    }
    else if ([model.sexString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Woman"]]) {
        [self.sexImageView setImage:[UIImage imageNamed:@"gyhd_girl_icon"]];
    }
    else {
        [self.sexImageView setImage:[UIImage imageNamed:@""]];
    }
    if (!globalData.loginModel.cardHolder) {
        self.leftBottomLabel.hidden = YES;
    }
}
@end
