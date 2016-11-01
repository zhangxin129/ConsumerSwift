//
//  GYHDPhoneFriendCell.m
//  HSConsumer
//
//  Created by wangbiao on 16/10/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPhoneFriendCell.h" 
#import "GYHDSearchUserModel.h"
#import "GYHDMessageCenter.h"


@interface GYHDPhoneFriendCell ()

@property(nonatomic, strong)UIButton *searchStatusButton;

@end

@implementation GYHDPhoneFriendCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.searchStatusButton = [[UIButton alloc] init];
        self.searchStatusButton.backgroundColor=[UIColor colorWithHexString:@"#ef4136"];
        self.searchStatusButton.titleLabel.font=[UIFont systemFontOfSize:14.0];
        self.searchStatusButton.layer.cornerRadius=6;
        self.searchStatusButton.layer.masksToBounds=YES;
//        [self.searchStatusButton setContentEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
        [self.contentView addSubview:self.searchStatusButton];
        WS(weakSelf);
        [self.searchStatusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.right.mas_equalTo(-12);
            make.height.mas_equalTo(26);
            make.width.mas_lessThanOrEqualTo(44);
//            make.size.mas_equalTo(CGSizeMake(44, 26));
        }];
    }
    return self;
}

- (void)setModel:(GYHDSearchUserModel *)model {
    _model = model;
    [self.leftImageView setImageWithURL:[NSURL URLWithString:model.iconString] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    
    self.leftTopLabel.text = model.bookName;
    self.leftBottomLabel.text = model.nameString;
    
    switch (model.friendStatus.integerValue) {
        case 0:
            [self.searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_add"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_ADD_success"] forState:UIControlStateNormal];
            [self.searchStatusButton setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            self.searchStatusButton.backgroundColor=[UIColor clearColor];
            break;
        case -1:
            [self.searchStatusButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_agree"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }

}
@end
