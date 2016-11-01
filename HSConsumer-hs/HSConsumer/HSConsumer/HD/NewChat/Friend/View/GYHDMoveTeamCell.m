//
//  GYHDMoveTeamCell.m
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMoveTeamCell.h"
#import "GYHDMoveTeamModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDMoveTeamCell ()
/**选中状态按钮*/
@property (nonatomic, weak) UIButton* selectButton;
/**选择标题*/
@property (nonatomic, weak) UILabel* selectTitleLabel;
@end

@implementation GYHDMoveTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    //按钮
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    UIButton* selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.userInteractionEnabled = NO;
    [selectButton setBackgroundImage:[UIImage imageNamed:@"gyhd_select_original_btn_Highlighte"] forState:UIControlStateNormal];
    [selectButton setBackgroundImage:[UIImage imageNamed:@"gyhd_select_original_btn_normal"] forState:UIControlStateSelected];
    [self.contentView addSubview:selectButton];
    _selectButton = selectButton;
    //标题
    UILabel* selectTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:selectTitleLabel];
    _selectTitleLabel = selectTitleLabel;

    WS(weakSelf);
    [selectButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(weakSelf.contentView);
        make.left.mas_equalTo(20);
    }];

    [selectTitleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(weakSelf.selectButton.mas_right).offset(12);
        make.centerY.equalTo(weakSelf.selectButton);
    }];
}

- (void)setTeamModel:(GYHDMoveTeamModel*)teamModel
{
    _teamModel = teamModel;
    self.selectTitleLabel.text = teamModel.selectTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.teamModel.selectState = selected;
    self.selectButton.selected = !selected;
}

@end
