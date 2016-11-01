//
//  GYHDPopMoveTeamView.m
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPopMoveTeamView.h"
#import "GYHDMessageCenter.h"
#import "GYHDMoveTeamCell.h"
#import "GYHDMoveTeamModel.h"

@interface GYHDPopMoveTeamView () <UITableViewDataSource, UITableViewDelegate>
/**移动选择View*/
@property (nonatomic, weak) UITableView* movieTableView;
/**移动用户*/
@property (nonatomic, weak) UILabel* titleLabel;
/**确定按钮*/
@property (nonatomic, weak) UIButton* defineButton;
/**移动数据源*/
@property (nonatomic, strong) NSMutableArray* moveArray;
@end

@implementation GYHDPopMoveTeamView

- (NSMutableArray*)moveArray
{
    if (!_moveArray) {
        _moveArray = [NSMutableArray array];
    }
    return _moveArray;
}

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
    //标题
    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    titleLabel.textColor = [UIColor colorWithRed:251 / 255.0f green:99 / 255.0f blue:83 / 255.0f alpha:1];
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
    UIView* lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithRed:203 / 255.0f green:204 / 255.0f blue:205 / 255.0f alpha:1];
    [self addSubview:lineView];
    // 选择表
    UITableView* movieTableView = [[UITableView alloc] init];
    movieTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    movieTableView.delegate = self;
    movieTableView.dataSource = self;
    [movieTableView registerClass:[GYHDMoveTeamCell class] forCellReuseIdentifier:@"moveCellID"];
    [self addSubview:movieTableView];
    _movieTableView = movieTableView;
    // definebutton
    UIButton* defineButton = [[UIButton alloc] init];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_define_btn_normal"] forState:UIControlStateNormal];
    [defineButton setBackgroundImage:[UIImage imageNamed:@"gyhd_pop_define_btn_Highlighted"] forState:UIControlStateHighlighted];
    [defineButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_confirm"] forState:UIControlStateNormal];
    [defineButton addTarget:self action:@selector(defineButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:defineButton];
    _defineButton = defineButton;

    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(46);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(titleLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    [defineButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
    }];
    [movieTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(20);
        make.bottom.equalTo(defineButton.mas_top).offset(-20);
        make.left.right.mas_equalTo(0);
    }];
}

- (void)settitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)setDataSource:(NSArray*)array
{
    for (NSString* string in array) {
        GYHDMoveTeamModel* teamModel = [[GYHDMoveTeamModel alloc] init];
        teamModel.selectState = NO;
        teamModel.selectTitle = string;
        [self.moveArray addObject:teamModel];
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.moveArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDMoveTeamCell* cell = [tableView dequeueReusableCellWithIdentifier:@"moveCellID"];
    GYHDMoveTeamModel* teamModel = self.moveArray[indexPath.row];
    cell.teamModel = teamModel;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 60.0f;
}

- (void)defineButtonClick
{
    for (GYHDMoveTeamModel* model in self.moveArray) {
        if (model.selectState) {
            if (self.block) {
                self.block(model.selectTitle);
            }
        }
    }
}

@end
