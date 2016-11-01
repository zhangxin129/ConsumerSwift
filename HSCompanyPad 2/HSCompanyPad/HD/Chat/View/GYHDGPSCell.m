//
//  GYHDGPSCell.m
//  HSConsumer
//
//  Created by shiang on 16/7/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDGPSCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDGPSCell ()
/**标题*/
@property(nonatomic, strong)UILabel *GPSTitileLabel;
/**地址*/
@property(nonatomic, strong)UILabel *GPSAddressLabel;
/**是否选择*/
@property(nonatomic, strong)UIImageView *selectImageView;
@end

@implementation GYHDGPSCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.GPSTitileLabel = [[UILabel alloc] init];
    self.GPSTitileLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.GPSTitileLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [self.contentView addSubview:self.GPSTitileLabel];
    
    self.GPSAddressLabel = [[UILabel alloc] init];
    self.GPSAddressLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    self.GPSAddressLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.contentView addSubview:self.GPSAddressLabel];
    
    self.selectImageView = [[UIImageView alloc] init];
    self.selectImageView.image = [UIImage imageNamed:@"hd_GPS_select"];
    [self.contentView addSubview:self.selectImageView];
    WS(weakSelf);
    [self.GPSTitileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.bottom.equalTo(weakSelf.GPSAddressLabel.mas_top);
        make.height.equalTo(weakSelf.GPSAddressLabel);
    }];
    [self.GPSAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.equalTo(weakSelf.GPSTitileLabel.mas_bottom);
        make.height.equalTo(weakSelf.GPSTitileLabel);
    }];
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.right.mas_equalTo(-12);
    }];
    
}
- (void)setModel:(GYHDGPSModel *)model {
    _model = model;
    self.GPSTitileLabel.text = model.title;
    self.GPSAddressLabel.text = model.address;
    if(model.selectState) {
        self.selectImageView.hidden = NO;
    } else {
        self.selectImageView.hidden = YES;
    }
}
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//    self.model.selectState = selected;
//    if(selected) {
//        self.selectImageView.hidden = NO;
//    } else {
//        self.selectImageView.hidden = YES;
//    }
//}
@end
