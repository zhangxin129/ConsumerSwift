//
//  GYHDReplyChooseCell.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDReplyChooseCell.h"

@interface GYHDReplyChooseCell ()
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UILabel *detailLabel;
@end

@implementation GYHDReplyChooseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    self.titleLabel.textColor = [UIColor colorWithHex:0x3e8ffa];
    [self.contentView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.font = [UIFont systemFontOfSize:16.0f];
    self.detailLabel.textColor = [UIColor colorWithHex:0x232c2e];
    [self.contentView addSubview:self.detailLabel];
    
    @weakify(self);
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(13);
        make.bottom.mas_equalTo(-13);
        make.right.equalTo(self.detailLabel.mas_left).offset(-25);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(13);
        make.bottom.mas_equalTo(-13);
        make.left.mas_equalTo(140);
        make.right.mas_equalTo(-13);
    }];
    
    [self.titleLabel setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置label1的content compression 为1000
    [self.titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired
                                             forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置右边的label2的content hugging 为1000
    [self.detailLabel setContentHuggingPriority:UILayoutPriorityRequired
                               forAxis:UILayoutConstraintAxisHorizontal];
    
    //设置右边的label2的content compression 为250
    [self.detailLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                             forAxis:UILayoutConstraintAxisHorizontal];
    self.titleLabel.text = @" ";
    self.detailLabel.text = @" ";
}
- (void)setModel:(GYHDReplyModel *)model {
    self.titleLabel.text = model.titleString;
    self.detailLabel.text = model.contentString;
}
@end
