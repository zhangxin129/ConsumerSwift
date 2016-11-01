//
//  GYHDMoveFriendCollectionCell.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMoveFriendCollectionCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDMoveFriendGroupModel.h"

@interface GYHDMoveFriendCollectionCell ()
@property(nonatomic, strong)UIImageView *iconImageView;
@end

@implementation GYHDMoveFriendCollectionCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.iconImageView];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(3);
        make.bottom.right.mas_equalTo(-3);
    }];
//    UIImageView* emojiImageView = [[UIImageView alloc] init];
//    emojiImageView.backgroundColor = [UIColor whiteColor];
//    //    emojiImageView.contentMode = UIViewContentModeCenter;
//    [self.contentView addSubview:emojiImageView];
//    _emojiImageView = emojiImageView;
//    WS(weakSelf);
//    [emojiImageView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.center.equalTo(weakSelf.contentView);
//        make.size.mas_equalTo(CGSizeMake(30, 30));
//    }];
}
- (void)setModel:(GYHDMoveFriendModel *)model {
    _model = model;
    [self.iconImageView setImageWithURL:[NSURL URLWithString:model.moveFriendIconUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
}
@end
