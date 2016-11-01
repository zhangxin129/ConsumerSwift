//
//  GYHDEmojiCell.m
//  HSConsumer
//
//  Created by shiang on 16/2/24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDEmojiCell.h"
#import "GYHDMessageCenter.h"

@interface GYHDEmojiCell ()
/**测试*/
//@property(nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak) UIImageView* emojiImageView;
@end

@implementation GYHDEmojiCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView* emojiImageView = [[UIImageView alloc] init];
    emojiImageView.backgroundColor = [UIColor whiteColor];
    //    emojiImageView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:emojiImageView];
    _emojiImageView = emojiImageView;
    WS(weakSelf);
    [emojiImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.contentView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
}

- (void)setimageName:(NSString*)imageName
{
    UIImage* image = [UIImage imageNamed:imageName];
    self.emojiImageView.image = image;
}

@end
