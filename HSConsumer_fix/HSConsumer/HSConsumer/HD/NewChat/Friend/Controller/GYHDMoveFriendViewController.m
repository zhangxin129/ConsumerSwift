//
//  GYHDMoveFriendViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMoveFriendViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDMoveFriendGroupModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDMoveFriendCell.h"

@interface GYHDMoveFriendViewController () <UITableViewDataSource, UITableViewDelegate>
/**移动button*/
@property (nonatomic, weak) UIButton* movieButton;
/**标题*/
@property (nonatomic, weak) UILabel* titleLabel;
/**选择tableView*/
@property (nonatomic, weak) UITableView* selectTableView;
/**移动好友数组*/
@property (nonatomic, strong) NSMutableArray* moveFriendArray;
/**选择的用户名称*/
@property (nonatomic, copy) NSString* selectAccountIDString;
@end

@implementation GYHDMoveFriendViewController
- (NSMutableArray*)moveFriendArray
{
    if (!_moveFriendArray) {
        _moveFriendArray = [NSMutableArray array];
    }
    return _moveFriendArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton* cancelButton = [[UIButton alloc] init];
    [cancelButton setTitleColor:[UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1] forState:UIControlStateNormal];

    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_cancel"] forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];

    UILabel* titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = [UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1];
    titleLabel.text = [GYUtils localizedStringWithKey:@"GYHD_select_contacts"];
    [self.view addSubview:titleLabel];
    _titleLabel = titleLabel;

    UIButton* movieButton = [[UIButton alloc] init];
    //    [movieButton setTitle:@"移入" forState:UIControlStateNormal];
    [movieButton setTitleColor:[UIColor colorWithRed:153 / 255.0f green:153 / 255.0f blue:153 / 255.0f alpha:1] forState:UIControlStateNormal];
    [movieButton addTarget:self action:@selector(movieButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:movieButton];
    _movieButton = movieButton;

    UITableView* selectTableView = [[UITableView alloc] init];
    selectTableView.dataSource = self;
    selectTableView.delegate = self;
    [selectTableView registerClass:[GYHDMoveFriendCell class] forCellReuseIdentifier:@"GYHDMoveFriendCellID"];
    [self.view addSubview:selectTableView];
    _selectTableView = selectTableView;
    WS(weakSelf);
    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(12);

    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(cancelButton);
        make.centerX.equalTo(weakSelf.view);
    }];
    [movieButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(cancelButton);
        make.right.mas_equalTo(-12);
    }];
    [selectTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(cancelButton.mas_bottom).offset(20);
        make.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)setMoveString:(NSString*)moveString
{
    _moveString = moveString;
    [self.movieButton setTitle:moveString forState:UIControlStateNormal];
}

- (void)setTeamID:(NSString*)teamID
{
    _teamID = teamID;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadTeamFriend];
}

/**好友列表*/
- (void)loadTeamFriend
{
    WS(weakSelf);
    NSArray  *DBfriendArray = nil;
    if ([self.moveString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_move_in"]]) {
     
        DBfriendArray =  [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:nil];
  
    } else {
    
        DBfriendArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:self.teamID];

    }

    //    //1.首先加载数据数据
    self.moveFriendArray = [self friendPinYinGroupWithArray:DBfriendArray];
    [weakSelf.selectTableView reloadData];
}

/**好友按字母分组*/
- (NSMutableArray*)friendPinYinGroupWithArray:(NSArray*)array
{
    NSArray* ABCArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    NSMutableArray* friendGroupArray = [NSMutableArray array];
    for (NSString* key in ABCArray) {
        GYHDMoveFriendGroupModel* friendGroupModel = [[GYHDMoveFriendGroupModel alloc] init];
        for (NSDictionary* dict in array) {

            //1. 转字母
            NSString* tempStr = dict[GYHDDataBaseCenterFriendName];
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if ([GYUtils isIncludeChineseInString:dict[GYHDDataBaseCenterFriendName]]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:dict[GYHDDataBaseCenterFriendName]];
            }
            //2. 获取首字母
            NSString* firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }

            //3. 加入数组
            if ([firstLetter isEqualToString:key]) {

                friendGroupModel.moveFriendTitle = key;
                GYHDMoveFriendModel* friendModel = [[GYHDMoveFriendModel alloc] initWithDictionary:dict];

                if ([self.teamID isEqualToString:friendModel.moveFriendTeamID] && [self.moveString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_move_in"]]) {
                    friendModel.TeamSelf = YES;
                }
                else {
                    friendModel.TeamSelf = NO;
                }
                [friendModel addObserver:self forKeyPath:@"moveFriendSelectState" options:NSKeyValueObservingOptionNew context:nil];
                [friendGroupModel.moveFriendArray addObject:friendModel];
            }
        }
        if (friendGroupModel.moveFriendTitle && friendGroupModel.moveFriendArray.count > 0) {
            [friendGroupArray addObject:friendGroupModel];
        }
    }

    return friendGroupArray;
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"moveFriendSelectState"]) {
        int selectCount = 0;
        NSMutableString* selectCountString = [[NSMutableString alloc] init];
        for (GYHDMoveFriendGroupModel* froupModel in self.moveFriendArray) {
            for (GYHDMoveFriendModel* friendModel in froupModel.moveFriendArray) {
                if (friendModel.moveFriendSelectState) {
                    selectCount++;
                    [selectCountString appendFormat:@"%@,", friendModel.moveFriendAccountID];
                }
            }
        }
        NSString* title = nil;
        if (selectCount) {
            title = [NSString stringWithFormat:@"%@(%d)", self.moveString, selectCount];
        }
        else {
            title = self.moveString;
        }
        if (selectCountString.length) {
            [selectCountString deleteCharactersInRange:NSMakeRange(selectCountString.length - 1, 1)];
        }
        self.selectAccountIDString = selectCountString;
        [self.movieButton setTitle:title forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    for (GYHDMoveFriendGroupModel* froupModel in self.moveFriendArray) {
        for (GYHDMoveFriendModel* friendModel in froupModel.moveFriendArray) {
            [friendModel removeObserver:self forKeyPath:@"moveFriendSelectState"];
        }
    }
}

- (void)movieTitle:(NSString*)title
{
    self.titleLabel.text = title;
}

- (void)movieButtonClick
{

    if (self.block) {
        self.block(self.selectAccountIDString);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelButtonClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.moveFriendArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHDMoveFriendGroupModel* model = self.moveFriendArray[section];
    return model.moveFriendArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDMoveFriendGroupModel* model = self.moveFriendArray[indexPath.section];
    GYHDMoveFriendModel* friendModel = model.moveFriendArray[indexPath.row];
    GYHDMoveFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDMoveFriendCellID"];
    cell.model = friendModel;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 66.0f;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    GYHDMoveFriendGroupModel* model = self.moveFriendArray[section];
    return model.moveFriendTitle;
}

- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (GYHDMoveFriendGroupModel* model in self.moveFriendArray) {
        [titleArray addObject:model.moveFriendTitle];
    }
    return titleArray;
}

@end
