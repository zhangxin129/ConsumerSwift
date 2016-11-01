//
//  GYHDPopDeleteTeamView.m
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPopDeleteTeamView.h"
#import "GYHDMessageCenter.h"

@interface GYHDPopDeleteTeamView ()
@property (nonatomic, weak) UILabel* contentLabel;
@property (nonatomic, weak) UILabel* titleLabel;
@end

@implementation GYHDPopDeleteTeamView

/*
   // Only override drawRect: if you perform custom drawing.
   // An empty implementation adversely affects performance during animation.
   - (void)drawRect:(CGRect)rect {
    // Drawing code
   }
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.backgroundColor = [UIColor whiteColor];
    //1. 标题
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    titleLabel.textColor = [UIColor colorWithRed:251 / 255.0f green:99 / 255.0f blue:83 / 255.0f alpha:1];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    //2. 类容
    UILabel* contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.font = [UIFont systemFontOfSize:KFontSizePX(24.0f)];
    [self addSubview:contentLabel];
    _contentLabel = contentLabel;

    UIButton* defineButton = [[UIButton alloc] init];
    [defineButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] forState:UIControlStateNormal];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_left_btn_normal"] forState:UIControlStateNormal];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_left_btn_Highlighted"] forState:UIControlStateHighlighted];
    [defineButton addTarget:self action:@selector(defineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defineButton];

    UIButton* cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_right_btn_normal"] forState:UIControlStateNormal];
    [cancleButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_right_btn_highlighted"] forState:UIControlStateHighlighted];
    [cancleButton addTarget:self action:@selector(cancleButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancleButton];

    //    WS(weakSelf);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(35);
    }];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(32);
    }];
    [defineButton mas_makeConstraints:^(MASConstraintMaker* make) {

        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(42);
        make.right.equalTo(cancleButton.mas_left).offset(-1);
        make.width.equalTo(cancleButton);
    }];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(42);
        make.left.equalTo(defineButton.mas_right).offset(1);
        make.width.equalTo(defineButton);

    }];
}

- (void)setDeleteTeamName:(NSString*)deleteTeamName
{
    _deleteTeamName = deleteTeamName;
    self.contentLabel.text = deleteTeamName;
}

- (void)setTitle:(NSString*)title Content:(NSString*)content
{
    self.contentLabel.text = content;
    self.titleLabel.text = title;
}

- (void)cancleButtonClick
{
    if (self.block) {
        self.block(nil);
    }
}

- (void)defineButtonClick
{
    if (self.block) {
        self.block(self.contentLabel.text);
    }
}

@end
