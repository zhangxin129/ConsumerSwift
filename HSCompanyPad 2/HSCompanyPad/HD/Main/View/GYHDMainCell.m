//
//  GYHDMainCell.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDMainCell.h"

@interface GYHDMainCell()

@property(nonatomic, strong)UIImageView *topImageView;
@property(nonatomic, strong)UILabel *bottomlabel;
@property(nonatomic, strong)UIImageView *readImageView;


@end

@implementation GYHDMainCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.topImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.topImageView];
        
        self.bottomlabel = [[UILabel alloc] init];
        self.bottomlabel.font = [UIFont systemFontOfSize:18.0f];
        [self.contentView addSubview:self.bottomlabel];
        
        self.readImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_unread_tips_icon"]];
        self.readImageView.hidden=YES;
        [self.contentView addSubview:self.readImageView];
        @weakify(self);
        [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(13);
            make.centerX.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(32,32));
        }];
        
        [self.bottomlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.contentView);
            make.bottom.mas_equalTo(-23);
        }];
        
        [self.readImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerX.equalTo(self.topImageView.mas_right);
            make.centerY.equalTo(self.topImageView.mas_top);
        }];
    }
    return self;
}
- (void)setup {
}

- (void)setModel:(GYHDMainModel *)model {
    _model = model;

    self.bottomlabel.text = model.bottomTitleString;
    if ([model.bottomTitleString isEqualToString:kLocalized(@"GYHD_Message")] && model.msgTip) {
        
        self.readImageView.hidden=NO;
    }else{
    
        self.readImageView.hidden=YES;
    }
    if (!model.select) {
        self.bottomlabel.textColor = [UIColor colorWithHex:0x999999];
        self.topImageView.image = [UIImage imageNamed:model.topImageString];
    }else {
        self.bottomlabel.textColor = [UIColor colorWithHex:0x3e8ffa];
        self.topImageView.image = [UIImage imageNamed:model.topSelectImageString];
    }
}
@end
