//
//  GYHDFriendsViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFriendsViewController.h"
#import "GYHDFriendCell.h"
#import "GYHDFriendModel.h"
#import "GYHDMessageCenter.h"
#import "GYHDFriendDetailViewController.h"
#import "GYPinYinConvertTool.h"
#import "GYHDFriendGroupModel.h"
#import "GYHDPopAddTeamView.h"
#import "GYHDPopView.h"
#import "GYHDPopMessageTopView.h"
#import "GYHDPopDeleteTeamView.h"
#import "GYHDFriendTeamModel.h"
#import "GYHDPopMoveTeamView.h"
#import "GYHDMoveFriendViewController.h"
#import "GYHDApplicantDetailViewController.h"
#import "GYHDFriendApplicationViewController.h"

@interface GYHDFriendsViewController () <UITableViewDelegate, UITableViewDataSource>
/**
 * 朋友展示数组
 */
@property (nonatomic, strong) NSMutableArray* FriendGourpArrayM;
/**
 * 朋友展示控制器
 */
@property (nonatomic, weak) UITableView* friendTableView;
/**
 * 好友分组ScrollView
 */
@property (nonatomic, weak) UIScrollView* friendTypeScroll;
/**好友分组View*/
@property (nonatomic, weak) UIView* FriendTypeView;
/**选择好友按钮*/
@property (nonatomic, weak) UIButton* selectTypeButton;
/**下拉按钮*/
@property (nonatomic, weak) UIButton* changeButton;
/**好友分组数组*/
@property (nonatomic, strong) NSMutableArray* friendTeamArray;
@property (nonatomic, weak) UILabel* zeroMessageLabel;
@end

@implementation GYHDFriendsViewController

- (NSMutableArray*)friendTeamArray
{
    if (!_friendTeamArray) {
        _friendTeamArray = [NSMutableArray array];
    }
    return _friendTeamArray;
}

- (NSMutableArray*)FriendGourpArrayM
{
    if (!_FriendGourpArrayM) {
        _FriendGourpArrayM = [NSMutableArray array];
    }
    return _FriendGourpArrayM;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Friend_Info"];
    //1. 好友类型
    UIScrollView* friendTypeScroll = [[UIScrollView alloc] init];
    friendTypeScroll.backgroundColor = [UIColor whiteColor];
    friendTypeScroll.showsHorizontalScrollIndicator = NO;
    friendTypeScroll.showsVerticalScrollIndicator = NO;
    friendTypeScroll.delegate = self;
    [self.view addSubview:friendTypeScroll];
    _friendTypeScroll = friendTypeScroll;

    //1. 获取好友列表
    UITableView* friendTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    friendTableView.delegate = self;
    friendTableView.dataSource = self;
    friendTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    friendTableView.sectionHeaderHeight = 18.0f;
    friendTableView.sectionIndexColor = [UIColor blackColor];
    friendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(longPressGestureRecognized:)];
    [friendTableView addGestureRecognizer:longPress];
    [friendTableView registerClass:[GYHDFriendCell class] forCellReuseIdentifier:@"GYHDFriendCellID"];
    [self.view addSubview:friendTableView];
    _friendTableView = friendTableView;
    friendTableView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
  
    UIView* FriendTypeView = [[UIView alloc] init];
    FriendTypeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:FriendTypeView];
    _FriendTypeView = FriendTypeView;

    UIButton* changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"gyhd_friend_change_normal"] forState:UIControlStateNormal];
    [changeButton setBackgroundImage:[UIImage imageNamed:@"gyhd_friend_change_select"] forState:UIControlStateSelected];
    [changeButton addTarget:self action:@selector(changeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeButton];
    _changeButton = changeButton;
    //    _selectTypeButton = changeButton;
    [friendTypeScroll mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    [friendTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(friendTypeScroll.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];

    [FriendTypeView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(-170);
        make.height.mas_equalTo(170);
    }];

    [changeButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];

    UILabel* zeroMessageLabel = [[UILabel alloc] init];
    zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_friend"];
    zeroMessageLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    zeroMessageLabel.textColor = [UIColor grayColor];
    [self.view addSubview:zeroMessageLabel];
    _zeroMessageLabel = zeroMessageLabel;
    WS(weakSelf);
    [zeroMessageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];
    [self setupRefresh];
     [weakSelf getFriendListTeam];
    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(friendChange:)];
}
- (void)dealloc
{
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
}

- (void)reloadTableView {
    if (globalData.isLogined) {
        [self getFriendList];
        [self getFriendListTeam];
    }
    [self.friendTableView.mj_header endRefreshing];
}

/**下拉刷新*/
- (void)setupRefresh
{

    WS(weakSelf);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        if (globalData.isLogined) {
            [weakSelf getFriendList];
        }
        [weakSelf.friendTableView.mj_header endRefreshing];
    }];

    self.friendTableView.mj_header = header;
    [self.friendTableView.mj_header beginRefreshing];

}

- (void)friendChange:(NSNotification*)noti
{
    NSDictionary* dict = noti.object;
    if (dict[@"friendChange"]) {
        [self getFriendList];
    }
}
- (void)changeButtonClick:(UIButton*)button
{

    button.selected = !button.selected;
    WS(weakSelf);
    [UIView animateWithDuration:0.25f animations:^{
        if (!button.selected) {
            [weakSelf.FriendTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-170);
            }];
        } else {
            [weakSelf.FriendTypeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
            }];
        }
        [weakSelf.view layoutIfNeeded];
    }];
}

/**好友分组名字*/
- (void)getFriendListTeam
{

    WS(weakSelf);
    NSArray* DBfriendTeamArray = [[GYHDMessageCenter sharedInstance] getFriendTeamRequetResult:^(NSArray* resultArry) {
        NSMutableArray *friendTeamArray = [NSMutableArray array];
        if (resultArry.count > 0) {
            GYHDFriendTeamModel *teamModel = [[GYHDFriendTeamModel alloc] init];
            teamModel.teamID = @"unteamed";
            teamModel.teamName = [GYUtils localizedStringWithKey:@"GYHD_complete"];
            [friendTeamArray addObject:teamModel];
            
            GYHDFriendTeamModel *comModel = [[GYHDFriendTeamModel alloc] init];
            comModel.teamID  = @"application";
            comModel.teamName = [GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"];
            [friendTeamArray addObject:comModel];
        }
        for (NSDictionary *dict in resultArry) {
            GYHDFriendTeamModel *teamModel = [[GYHDFriendTeamModel alloc] initWithDict:dict];
            [friendTeamArray addObject:teamModel];
        }
        GYHDFriendTeamModel *addteamModel = [[GYHDFriendTeamModel alloc] init];
        addteamModel.teamID = @"0";
        addteamModel.teamName = @"+ 增加"; [GYUtils localizedStringWithKey:@"GYHD_add"];
        [friendTeamArray addObject:addteamModel];
        weakSelf.friendTeamArray = friendTeamArray;
        [weakSelf createTeam];
    }];
    NSMutableArray* friendTeamArray = [NSMutableArray array];
    if (DBfriendTeamArray.count > 0) {
        GYHDFriendTeamModel* teamModel = [[GYHDFriendTeamModel alloc] init];
        teamModel.teamID = @"unteamed";
        teamModel.teamName = [GYUtils localizedStringWithKey:@"GYHD_complete"];
        [friendTeamArray addObject:teamModel];

        GYHDFriendTeamModel* comModel = [[GYHDFriendTeamModel alloc] init];
        comModel.teamID = @"application";
        comModel.teamName = [GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"];
        [friendTeamArray addObject:comModel];
    }

    for (NSDictionary* dict in DBfriendTeamArray) {
        NSDictionary* teamDict = [GYUtils stringToDictionary:dict[GYHDDataBaseCenterFriendTeamDetail]];
        GYHDFriendTeamModel* teamModel = [[GYHDFriendTeamModel alloc] initWithDict:teamDict];
        [friendTeamArray addObject:teamModel];
    }

    GYHDFriendTeamModel* addteamModel = [[GYHDFriendTeamModel alloc] init];
    addteamModel.teamID = @"0";
    addteamModel.teamName = @"+ 增加";
    [GYUtils localizedStringWithKey:@"GYHD_add"];
    [friendTeamArray addObject:addteamModel];
    self.friendTeamArray = friendTeamArray;
    [self createTeam];
}

/**创建好友分组按钮*/
- (void)createTeam
{

    for (UIView* view in self.FriendTypeView.subviews) {
        [view removeFromSuperview];
    }
    for (UIView* view in self.friendTypeScroll.subviews) {
        [view removeFromSuperview];
    }
    CGFloat buttonW = 70;
    CGFloat buttonH = 23;
    // scrollview 添加button
    //    UIButton *lastButton1 = nil;
    NSInteger count = self.friendTeamArray.count;
    for (int i = 0; i < count - 1; i++) {
        GYHDFriendTeamModel* model = self.friendTeamArray[i];
        NSString* teamName = model.teamName;
        if (teamName == nil)
            return;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];

        NSMutableDictionary* normalDict = [NSMutableDictionary dictionary];
        normalDict[NSFontAttributeName] = [UIFont systemFontOfSize:KFontSizePX(24)];
        normalDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:51 / 255.0f green:51 / 255.0f blue:51 / 255.0f alpha:1];

        NSAttributedString* normalAttString = [[NSMutableAttributedString alloc] initWithString:teamName attributes:normalDict];
        [button setAttributedTitle:normalAttString forState:UIControlStateNormal];
        [button setTitle:teamName forState:UIControlStateNormal];
        NSMutableDictionary* selectlDict = [NSMutableDictionary dictionary];
        selectlDict[NSFontAttributeName] = [UIFont systemFontOfSize:KFontSizePX(32)];
        selectlDict[NSForegroundColorAttributeName] = [UIColor colorWithRed:250 / 255.0f green:60 / 255.0f blue:40 / 255.0f alpha:1];
        NSAttributedString* selectlAttString = [[NSMutableAttributedString alloc] initWithString:teamName attributes:selectlDict];
        [button setAttributedTitle:selectlAttString forState:UIControlStateSelected];
        //        CGSize bsize = [GYUtils sizeForString:teamName font:[UIFont systemFontOfSize:KFontSizePX(36)] width:MAXFLOAT];

        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.friendTypeScroll addSubview:button];

        button.frame = CGRectMake(i * buttonW, 0, buttonW, 35);
        if (i == 0) {
            self.selectTypeButton = button;
            self.selectTypeButton.selected = YES;
        }
    }
    self.friendTypeScroll.contentSize = CGSizeMake((count + 1) * buttonW, 0);

    UIButton* lastButton2 = nil;
    UILabel* changeLabel = [[UILabel alloc] init];
    changeLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    changeLabel.textColor = [UIColor colorWithRed:51 / 255.0f green:51 / 255.0f blue:51 / 255.0f alpha:1];
    changeLabel.text = [GYUtils localizedStringWithKey:@"GYHD_change_team"];

    [self.FriendTypeView addSubview:changeLabel];

    [changeLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.top.mas_equalTo(12);
    }];

    for (int i = 0; i < count; i++) {
        GYHDFriendTeamModel* model = self.friendTeamArray[i];
        NSString* teamName = model.teamName;
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
        [button setTitle:teamName forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:51 / 255.0f green:51 / 255.0f blue:51 / 255.0f alpha:1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:250 / 255.0f green:60 / 255.0f blue:40 / 255.0f alpha:1] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageNamed:@"gyhd_friend_team_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gyhd_friend_team_highlighted"] forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        UILongPressGestureRecognizer* longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(teamButtonLongtap:)];
        if (i + 2 < count && i > 1) {
            [button addGestureRecognizer:longtap];
        }

        [self.FriendTypeView addSubview:button];

        [button mas_makeConstraints:^(MASConstraintMaker* make) {
            if (i /4 == 0) {
                make.top.mas_equalTo(33.0f);
                make.left.mas_equalTo((buttonW+8)*i+8);
            } else {
                make.top.equalTo(lastButton2.mas_bottom).offset(12);
                CGFloat buttonLeft = (i % 4)*(buttonW+8) + 8;
                make.left.mas_equalTo(buttonLeft);
            }
            make.size.mas_equalTo(CGSizeMake(buttonW, buttonH));

        }];
        if ((i + 1) % 4 == 0) {
            lastButton2 = button;
        }
        if (i == count - 1) {
            //            [button setImage:[UIImage imageNamed:@"gyhd_nav_add_icon"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"gyhd_friend_team_add_normal"] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:@"gyhd_friend_team_add_highlighted"] forState:UIControlStateHighlighted];
            [button removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
            [button addTarget:self action:@selector(addFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)addFriendButtonClick:(UIButton*)button
{

    GYHDPopAddTeamView* popAddteamView = [[GYHDPopAddTeamView alloc] init];
    [popAddteamView setTitle: [GYUtils localizedStringWithKey:@"GYHD_add_friend_team"]];
    [popAddteamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 147.0f));
    }];
    popAddteamView.maxCharCount = 4;
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:popAddteamView];
    [popView showToView:self.navigationController.view];
    popAddteamView.block = ^(NSString* message) {
        [popView disMiss];
        if (message) {

            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"teamName"] = message;
            WS(weakSelf);
            [[GYHDMessageCenter sharedInstance] createFriendTeamWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                [weakSelf getFriendListTeam];
                [weakSelf getFriendList];
            }];
        }
    };
}

- (void)buttonClick:(UIButton*)button
{
    self.selectTypeButton.selected = NO;
    button.selected = YES;
    self.selectTypeButton = button;

    for (GYHDFriendTeamModel* model in self.friendTeamArray) {
        if ([model.teamName isEqualToString:button.currentTitle]) {
            NSArray* DBfriendArray = nil;
            if ([model.teamName isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"]]) {

//                NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//                DBfriendArray = [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:dict TableName:GYHDDataBaseCenterFriendTableName];
                DBfriendArray = [[GYHDMessageCenter sharedInstance] selectApplicationFriend];
            }
            else if ([model.teamName isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_all"]]) {
                DBfriendArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:nil];
            }
            else {
                DBfriendArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:model.teamID];
            }

            self.FriendGourpArrayM = [self friendPinYinGroupWithArray:DBfriendArray];
            [self.friendTableView reloadData];
            break;
        }
    }
}

- (void)teamButtonLongtap:(UITapGestureRecognizer*)longTap
{
    WS(weakSelf);
    if (longTap.state == UIGestureRecognizerStateBegan) {
        UIButton* button = (UIButton*)longTap.view;

        NSArray* messageArray = @[ button.currentTitle, [GYUtils localizedStringWithKey:@"GYHD_edit_team"], [GYUtils localizedStringWithKey:@"GYHD_delete_team"], [GYUtils localizedStringWithKey:@"GYHD_friend_move_in"], [GYUtils localizedStringWithKey:@"GYHD_friend_move_cout"] ];
        GYHDPopMessageTopView* messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
        [messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(230, 230.0f));
        }];
        GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
        messageTopView.block = ^(NSString* messageString) {
            if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_delete_team"]]) {
                [weakSelf deleteTeamWithName:button.currentTitle];
            }
            if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_edit_team"]]) {
                [weakSelf editTeamWithName:button.currentTitle];
            }
            if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_friend_move_in"]]) {
                GYHDMoveFriendViewController *moveFriendViewController = [[GYHDMoveFriendViewController alloc] init];
                NSString *teamID = nil;
                for (GYHDFriendTeamModel *model in self.friendTeamArray) {
                    if ([model.teamName isEqualToString:button.currentTitle]) {
                        teamID = model.teamID;
                        moveFriendViewController.teamID = model.teamID;
                        break;
                    }
                }
                moveFriendViewController.moveString = [GYUtils localizedStringWithKey:@"GYHD_move_in" ];
                [self presentViewController:moveFriendViewController animated:YES completion:nil];
                moveFriendViewController.block = ^(NSString *message) {
                    NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"teamId"] = teamID;
                    dict[@"userId"] = myDict[@"Friend_ID"];
                    dict[@"friendId"] = message;
                    [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                        [weakSelf getFriendList];
                    }];
                };

            }

            if ([messageString isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_friend_move_cout"]]) {
                GYHDMoveFriendViewController *moveFriendViewController = [[GYHDMoveFriendViewController alloc] init];
                NSString *teamID = nil;
                for (GYHDFriendTeamModel *model in self.friendTeamArray) {
                    if ([model.teamName isEqualToString:button.currentTitle]) {
                        teamID = model.teamID;
                        moveFriendViewController.teamID = model.teamID;
                        break;
                    }
                }

                moveFriendViewController.moveString = [GYUtils localizedStringWithKey:@"GYHD_move_out"];
                [self presentViewController:moveFriendViewController animated:YES completion:nil];
                moveFriendViewController.block = ^(NSString *message) {
                    NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"teamId"] = @"unteamed";
                    dict[@"userId"] = myDict[@"Friend_ID"];
                    dict[@"friendId"] = message;
                    [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                        [weakSelf getFriendList];
                    }];

                };


            }
            [topView disMiss];
        };
        [topView showToView:self.navigationController.view];
    }
}

/**编辑分类*/
- (void)editTeamWithName:(NSString*)name
{

    GYHDPopAddTeamView* popAddteamView = [[GYHDPopAddTeamView alloc] init];
    [popAddteamView setTitle: [GYUtils localizedStringWithKey:@"GYHD_edit_team"]];
    [popAddteamView setDefaulText:name];
    [popAddteamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 147.0f));
    }];
    popAddteamView.maxCharCount = 4;
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:popAddteamView];
    [popView showToView:self.navigationController.view];
    WS(weakSelf);
    popAddteamView.block = ^(NSString* message) {
        [popView disMiss];
        if (message) {
            for (GYHDFriendTeamModel *model in self.friendTeamArray) {
                if ([model.teamName isEqualToString:name]) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"teamName"] = message;
                    dict[@"teamRemark"] = message;
                    dict[@"teamId"] = model.teamID;
                    [[GYHDMessageCenter sharedInstance] updateFriendTeamWithDict:dict RequetResult:^(NSDictionary *resultDict) {

                        [weakSelf getFriendListTeam];
                        [weakSelf getFriendList];
                    }];
                    break;
                }
            }
        }
    };
}

/**删除分类*/
- (void)deleteTeamWithName:(NSString*)name
{
    GYHDPopDeleteTeamView* deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
    //    deleteTeamView.deleteTeamName = name;
    [deleteTeamView setTitle:@"删除分类" Content:name];
    [deleteTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    WS(weakSelf)
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
    deleteTeamView.block = ^(NSString* message) {

        for (GYHDFriendTeamModel *model in self.friendTeamArray) {
            if ([model.teamName isEqualToString:message]) {

                [[GYHDMessageCenter sharedInstance] deleteFriendTeamID:model.teamID RequetResult:^(NSDictionary *resultDict) {

                    [weakSelf getFriendListTeam];
                    [weakSelf getFriendList];
                }];
                break;
            }
        }
        [topView disMiss];
    };
    [topView  showToView:self.navigationController.view];
}

/**好友列表*/
- (void)getFriendList
{       WS(weakSelf);
    if (self.selectTypeButton.currentTitle) {
        

        NSArray* DBfriendArray = [[GYHDMessageCenter sharedInstance] getFriendListRequetResult:^(NSArray* resultArry) {
            [weakSelf buttonClick:weakSelf.selectTypeButton];
           
        }];

    } else {

        NSArray* DBfriendArray = [[GYHDMessageCenter sharedInstance] getFriendListRequetResult:^(NSArray* resultArry) {
            //        if (!resultArry.count) return ;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                weakSelf.FriendGourpArrayM =  [weakSelf friendPinYinGroupWithArray:resultArry];
                [weakSelf.friendTableView  reloadData];
                
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                dict[@"Friend_MessageType"] = @"Friend";
//                NSDictionary *reDict =  [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:dict TableName:GYHDDataBaseCenterFriendTableName].lastObject;

            });
        }];
        //1.首先加载数据数据
        
        self.FriendGourpArrayM = [self friendPinYinGroupWithArray:DBfriendArray];
        [weakSelf.friendTableView reloadData];

    }


}

/**好友按字母分组*/
- (NSMutableArray*)friendPinYinGroupWithArray:(NSArray*)array
{
    NSArray* ABCArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    NSMutableArray* friendGroupArray = [NSMutableArray array];
    for (NSString* key in ABCArray) {
        GYHDFriendGroupModel* friendGroupModel = [[GYHDFriendGroupModel alloc] init];

        for (NSDictionary* dict in array) {

            //1. 转字母
            NSString* tempStr = dict[@"Friend_Name"];
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if ([GYUtils isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
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

                friendGroupModel.friendGroupTitle = key;
                GYHDFriendModel* friendModel = [[GYHDFriendModel alloc] initWithDictionary:dict];
                [friendGroupModel.friendGroupArray addObject:friendModel];
            }
        }
        if (friendGroupModel.friendGroupTitle && friendGroupModel.friendGroupArray.count > 0) {
            [friendGroupArray addObject:friendGroupModel];
        }
    }
    WS(weakSelf);
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"Friend_MessageType"] = @"Friend";
    NSDictionary* reDict = [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:dict TableName:GYHDDataBaseCenterFriendTableName].lastObject;
    if (reDict.allKeys.count) {
        weakSelf.changeButton.hidden = NO;
        [weakSelf.friendTableView mas_remakeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(weakSelf.friendTypeScroll.mas_bottom);
            make.left.bottom.right.mas_equalTo(0);
        }];
    }
    else {
        weakSelf.changeButton.hidden = YES;
        [weakSelf.friendTableView mas_remakeConstraints:^(MASConstraintMaker* make) {
            make.top.mas_equalTo(0);
            make.left.bottom.right.mas_equalTo(0);
        }];
    }
    
    if (friendGroupArray.count) {
        self.zeroMessageLabel.text = @"";
    }
    else {
        if (!self.selectTypeButton.currentTitle ||[self.selectTypeButton.currentTitle isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_all"]]) {
            self.zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_friend"];
        }else {
            self.zeroMessageLabel.text = @"当前分类下没有好友。";
        }
//        self.zeroMessageLabel.hidden = NO;
    }
    return friendGroupArray;
}

#pragma mark-- UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return self.FriendGourpArrayM.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHDFriendGroupModel* groupModel = self.FriendGourpArrayM[section];
    return groupModel.friendGroupArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
//    GYHDFriendCell* cell = [GYHDFriendCell cellWithTableView:tableView];
    GYHDFriendCell *cell =[tableView dequeueReusableCellWithIdentifier:@"GYHDFriendCellID"];
    GYHDFriendGroupModel* groupModel = self.FriendGourpArrayM[indexPath.section];
    cell.friendModel = groupModel.friendGroupArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 68.0f;
}

//- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
//{
//    GYHDFriendGroupModel* groupModel = self.FriendGourpArrayM[section];
//    return groupModel.friendGroupTitle;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   return  18.0f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18)];
    GYHDFriendGroupModel* groupModel = self.FriendGourpArrayM[section];
//    groupModel.friendGroupTitle;
    label.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    label.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    label.text =  [NSString stringWithFormat:@"  %@",groupModel.friendGroupTitle];
    return label;
}
- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (GYHDFriendGroupModel* model in self.FriendGourpArrayM) {
        [titleArray addObject:model.friendGroupTitle];
    }
    return titleArray;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYHDFriendGroupModel* groupModel = self.FriendGourpArrayM[indexPath.section];
    GYHDFriendModel* friendModel = groupModel.friendGroupArray[indexPath.row];
    if ([friendModel.friendApplicationStatus isEqualToString:@"1"]) {
        GYHDFriendApplicationViewController* friendApplicationViewController = [[GYHDFriendApplicationViewController alloc] init];
        friendApplicationViewController.FriendCustID = friendModel.FriendCustID;
        friendApplicationViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendApplicationViewController animated:YES];
    } else if ([friendModel.friendApplicationStatus isEqualToString:@"-1"]) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        GYHDApplicantListModel *listModel = [[GYHDApplicantListModel alloc] init];
        dict[@"msg_icon"] = friendModel.FriendIconUrl;
        dict[@"msg_note"] = friendModel.FriendNickName;
        dict[@"fromId"] = friendModel.FriendAccountID;
        dict[@"req_info"] = friendModel.reqInfoString;
        listModel.applicantBody = [GYUtils dictionaryToString:dict];
        listModel.applicantID = friendModel.FriendCustID;
        
        GYHDApplicantDetailViewController *detailViewController = [[GYHDApplicantDetailViewController alloc] init];
        detailViewController.model = listModel;
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else {
        GYHDFriendDetailViewController* friendDetailViewController = [[GYHDFriendDetailViewController alloc] init];
        friendDetailViewController.FriendCustID = friendModel.FriendCustID;
        if ([friendModel.friendTeamID isEqualToString:@"blacklisted"]) {
            friendDetailViewController.hidenSendButton = YES;
        }
        friendDetailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:friendDetailViewController animated:YES];
    }
}

- (void)longPressGestureRecognized:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint location = [longPress locationInView:self.friendTableView];
    NSIndexPath* indexPath = [self.friendTableView indexPathForRowAtPoint:location];
    if (!indexPath)
        return;
    GYHDFriendGroupModel* groupModel = self.FriendGourpArrayM[indexPath.section];
    GYHDFriendModel* friendModel = groupModel.friendGroupArray[indexPath.row];
    if ([friendModel.friendApplicationStatus isEqualToString:@"1"])
        return;
    NSMutableArray* messageArray = [NSMutableArray arrayWithArray:@[ friendModel.FriendNickName, @"修改备注", @"移动分类", @"删除好友" ]];
    if (![friendModel.friendTeamID isEqualToString:@"blacklisted"]) {
        [messageArray addObject:@"加入黑名单"];
    }else {
        [messageArray addObject:@"移出黑名单"];
    }
    GYHDPopMessageTopView* messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
    [messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270.0f, 230.0f));
    }];
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
    [popView  showToView:self.navigationController.view];
    WS(weakSelf)
    messageTopView.block = ^(NSString* string) {
        if ([string isEqualToString:@"修改备注"]) {
            [weakSelf editNoteWithFriendModel:friendModel];
        } else if ([string isEqualToString:@"移动分类"]) {
            [weakSelf moveteamWithFriendModel:friendModel];
        } else if ([string isEqualToString:@"删除好友"]) {
            [weakSelf deleteFriendFriendModel:friendModel];
        } else if ([string isEqualToString:@"加入黑名单"]) {
            [weakSelf addBlackTeamWithFriendModel:friendModel];
        }else if ([string isEqualToString:@"移出黑名单"]) {
            [weakSelf moveBlackTeamWithFriendModel:friendModel];
        }
        [popView disMiss];
    };
}

- (void)editNoteWithFriendModel:(GYHDFriendModel*)friendModel
{
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    GYHDPopAddTeamView* popAddteamView = [[GYHDPopAddTeamView alloc] init];
    [popAddteamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_Edit_sb_Note"], friendModel.FriendNickName]];
    //    [popAddteamView setTitle:@"修改备注"];
    popAddteamView.maxCharCount = 11;
    [popAddteamView setDefaulText:friendModel.FriendNickName];
    [popAddteamView setPlaceholder:[NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_inptu"],[GYUtils localizedStringWithKey:@"GYHD_remarks"]]];
    [popAddteamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 147.0f));
    }];

    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:popAddteamView];
    [popView  showToView:self.navigationController.view];
    WS(weakSelf);
    popAddteamView.block = ^(NSString* message) {
        [popView disMiss];
        if (message) {

            if (message || message.length > 1) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setValue:myDict[@"Friend_ID"] forKey:@"accountId"];
                [dict setValue: friendModel.FriendAccountID  forKey:@"friendId"];
                [dict setValue:message forKey:@"friendNickname"];
                [[GYHDMessageCenter sharedInstance] updateFriendNickNameWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                    [weakSelf getFriendList];
                }];
            }


        }
    };
}

- (void)moveteamWithFriendModel:(GYHDFriendModel*)friendModel
{

    GYHDPopMoveTeamView* moveTeamView = [[GYHDPopMoveTeamView alloc] init];
    [moveTeamView settitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_to"], friendModel.FriendNickName]];
    NSMutableArray* movieArray = [NSMutableArray array];
    for (GYHDFriendTeamModel* model in self.friendTeamArray) {
        if (![model.teamName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_add"]]) {
            [movieArray addObject:model.teamName];
        }
    }
    [movieArray removeObjectAtIndex:1];
    [movieArray removeLastObject];
    [moveTeamView setDataSource:movieArray];
    [moveTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 276.0f));
    }];
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:moveTeamView];
    [popView  showToView:self.navigationController.view];
    WS(weakSelf);
    moveTeamView.block = ^(NSString* messageString) {
        for (GYHDFriendTeamModel *model in self.friendTeamArray) {
            if ([model.teamName isEqualToString:messageString]) {
                NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"teamId"] = model.teamID;
                dict[@"userId"] =  myDict[@"Friend_ID"];
                dict[@"friendId"] = friendModel.FriendAccountID;
                if ([friendModel.friendTeamID isEqualToString:@"blacklisted"] && ![dict[@"teamId"] isEqualToString:@"blacklisted"]) {
                    dict[@"ifCancelBlacklisted"] = @"Y";
                }
                [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                    [weakSelf getFriendList];
                }];
                [popView disMiss];
                self.selectTypeButton.selected = NO;
                [self getFriendList];
            }

        }
    };
}

- (void)deleteFriendFriendModel:(GYHDFriendModel*)friendModel
{
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    GYHDPopDeleteTeamView* deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
    [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_will_be_delete"], friendModel.FriendNickName] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_delete_tips"]];
    [deleteTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    WS(weakSelf);
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
    deleteTeamView.block = ^(NSString* message) {
        if (message) {
            NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
            [insideDict setValue: myDict[@"Friend_ID"] forKey:@"accountId"];
            [insideDict setValue:myDict[@"Friend_Name"] forKey:@"accountNickname"];
            [insideDict setValue:myDict[@"Friend_Icon"] forKey:@"accountHeadPic"];
            [insideDict setValue:friendModel.FriendAccountID forKey:@"friendId"];
            [insideDict setValue:friendModel.FriendNickName forKey:@"friendNickname"];
            [insideDict setValue:@"4" forKey:@"friendStatus"];
            [insideDict setValue:friendModel.FriendIconUrl forKey:@"friendHeadPic"];

            [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary *resultDict) {
                if (resultDict && [resultDict[@"retCode"] integerValue] == 200) {
                    NSMutableDictionary *deleteFriendDict = [NSMutableDictionary dictionary];
                    deleteFriendDict[GYHDDataBaseCenterFriendCustID] = friendModel.FriendCustID;
                    [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteFriendDict TableName:GYHDDataBaseCenterFriendTableName];

                    NSMutableDictionary *deleteMessageDict = [NSMutableDictionary dictionary];
                    deleteMessageDict[GYHDDataBaseCenterMessageCard] = friendModel.FriendCustID;
                    [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteMessageDict TableName:GYHDDataBaseCenterMessageTableName];
                    
                    NSMutableDictionary *delectDict = [NSMutableDictionary dictionary];
                    delectDict[GYHDDataBaseCenterPushMessageFromID] = friendModel.FriendCustID;
                    [[GYHDMessageCenter sharedInstance]deleteInfoWithDict:delectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                    [weakSelf getFriendList];
                }

            }];
        }
        [topView disMiss];
    };
    [topView  showToView:self.navigationController.view];
}

- (void)addBlackTeamWithFriendModel:(GYHDFriendModel*)friendModel
{
    GYHDPopDeleteTeamView* deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
    [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_in_blacklist"], friendModel.FriendNickName] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_in_blacklist_tips"]];
    [deleteTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    WS(weakSelf)
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
    deleteTeamView.block = ^(NSString* message) {

        if (message) {
            NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"teamId"] = [NSString stringWithFormat:@"%@", @"blacklisted" ];
            dict[@"userId"] =  myDict[@"Friend_ID"];
            dict[@"friendId"] = friendModel.FriendAccountID;

            [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                [weakSelf getFriendList];
            }];
            [topView disMiss];
            self.selectTypeButton.selected = NO;

        }
        [topView disMiss];
    };
    [topView  showToView:self.navigationController.view];
}

- (void)moveBlackTeamWithFriendModel:(GYHDFriendModel*)friendModel {
    
    GYHDPopDeleteTeamView* deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
    [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_out_blacklist"], friendModel.FriendNickName] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_out_blacklist_tips"]];
    [deleteTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(230, 137.0f));
    }];
    WS(weakSelf)
    GYHDPopView* topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
    deleteTeamView.block = ^(NSString* message) {
        
        if (message) {
            NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"teamId"] = @"unteamed";
            dict[@"userId"] =  myDict[@"Friend_ID"];
            dict[@"friendId"] = friendModel.FriendAccountID;
            dict[@"ifCancelBlacklisted"] = @"Y";
            [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                [weakSelf getFriendList];
            }];
            [topView disMiss];
            self.selectTypeButton.selected = NO;
            
        }
        [topView disMiss];
    };
    [topView  showToView:self.navigationController.view];
}

//{
//    if (longPress.state != UIGestureRecognizerStateBegan) return;
//    CGPoint location = [longPress locationInView:self.friendTableView];
//    NSIndexPath  *indexPath= [self.friendTableView indexPathForRowAtPoint:location];
//    if (!indexPath) return ;
//    GYHDFriendGroupModel *groupModel = self.FriendGourpArrayM[indexPath.section];
//    GYHDFriendModel *friendModel = groupModel.friendGroupArray[indexPath.row];
//
//    GYHDPopMoveTeamView *moveTeamView = [[GYHDPopMoveTeamView alloc] init];
//    [moveTeamView settitle:friendModel.FriendNickName];
//
//    NSMutableArray *movieArray = [NSMutableArray array];
//    for (GYHDFriendTeamModel *model in self.friendTeamArray) {
//        if (![model.teamName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_complete"]] && ![model.teamName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_add"]]) {
//            [movieArray addObject:model.teamName];
//        }
//
//    }
//    [moveTeamView setDataSource:movieArray];
//    [moveTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(270, 276.0f));
//    }];
//    GYHDPopView *popView = [[GYHDPopView alloc] initWithChlidView:moveTeamView];
//    [popView show];
//    moveTeamView.block = ^(NSString *messageString) {
//        for (GYHDFriendTeamModel *model in self.friendTeamArray) {
//            if ([model.teamName isEqualToString:messageString]) {
//                NSDictionary *myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
//                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//                dict[@"teamId"] = model.teamID;
//                dict[@"userId"] =  [NSString stringWithFormat:@"c_%@",myDict[@"Friend_CustID"]];
//                dict[@"friendId"] = friendModel.FriendAccountID;
//                [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
//
//                }];
//                [popView disMiss];
//                self.selectTypeButton.selected = NO;
//                [self getFriendList];
//            }
//
//        }
//    };
//}

@end
