//
//  GYHDAdvisoryListCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDAdvisoryListCell.h"

@interface GYHDAdvisoryListCell ()
@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *timeLabel;

@end

@implementation GYHDAdvisoryListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.nameLabel.textColor = [UIColor colorWithHex:0x3e8ffa];
    [self.contentView addSubview:self.nameLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:12.0f];
    self.timeLabel.textColor = [UIColor colorWithHex:0xa9a9a9];
    [self.contentView addSubview:self.timeLabel];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(7);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-9);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-7);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(9);
    }];
    
    
    
}

-(void)setModel:(GYHDAdvisoryListModel *)model{

    _model=model;
    
    self.nameLabel.text =model.nameString;
    self.timeLabel.text =model.timeString;

}
@end
