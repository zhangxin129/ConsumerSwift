//
//  GYHDFriendDetailViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFriendDetailViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDFriendDetailCell.h"
#import "GYHDFriendDetailModel.h"
#import "GYHDChatViewController.h"
#import "GYHDPopMoreView.h"
#import "GYHDPopMoveTeamView.h"
#import "GYHDPopView.h"
#import "GYHDPopAddTeamView.h"
#import "GYHDPopDeleteTeamView.h"

//#import "GYFMDBCityManager.h"
#import "GYAddressData.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface GYHDFriendDetailViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView* friendDetalTableView;
@property (nonatomic, strong) NSMutableArray* friendDetailArrayM;
/**好友头像View*/
@property (nonatomic, weak) UIImageView* friendIconImageView;
/**友好名字Label*/
@property (nonatomic, weak) UILabel* friendNameLabel;
/**好友互生卡*/
@property (nonatomic, weak) UILabel* friendHushengLabel;
/**好友昵称*/
@property (nonatomic, weak) UILabel* friendNikeNameLabel;
/**好友model*/
@property (nonatomic, strong) GYHDFriendDetailModel* friendDetailModel;

@property (nonatomic, copy) NSString* nameStr;
@property (nonatomic, weak) UIImageView* sexImageView;
@property (nonatomic, strong)UIView *footView;
@end

@implementation GYHDFriendDetailViewController
- (NSMutableArray*)friendDetailArrayM
{
    if (!_friendDetailArrayM) {
        _friendDetailArrayM = [NSMutableArray array];
    }
    return _friendDetailArrayM;
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [backButton setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
//    backButton.frame = CGRectMake(0, 0, 80, 40);
//    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
//    [backButton addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];

//}
//- (void)ignoreClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Friend_Info"];
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 106);

    UIView* chilidView = [[UIView alloc] init];

    [headerView addSubview:chilidView];
    chilidView.frame = CGRectMake(0, 20, kScreenWidth, 66);
    chilidView.backgroundColor = [UIColor whiteColor];
    //1. 头像
    UIImageView* friendIconImageView = [[UIImageView alloc] init];
    friendIconImageView.layer.masksToBounds = YES;
    friendIconImageView.layer.cornerRadius = 3.0f;
    friendIconImageView.image = [UIImage imageNamed:@"gyhd_defaultheadimg"];
    [chilidView addSubview:friendIconImageView];
    _friendIconImageView = friendIconImageView;
    //2. 名字
    UILabel* friendNameLabel = [[UILabel alloc] init];
    friendNameLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    [chilidView addSubview:friendNameLabel];
    _friendNameLabel = friendNameLabel;
    //3. 互生卡
    UILabel* friendHushengLabel = [[UILabel alloc] init];
    friendHushengLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    friendHushengLabel.textColor = [UIColor colorWithRed:250 / 255.0f green:60 / 255.0f blue:40 / 255.0f alpha:1];
    [chilidView addSubview:friendHushengLabel];
    _friendHushengLabel = friendHushengLabel;

    UIImageView* sexImageView = [[UIImageView alloc] init];
    [chilidView addSubview:sexImageView];
    _sexImageView = sexImageView;
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton addTarget:self action:@selector(moreSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nav_rightView_more"] forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 33, 33);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];

    [friendIconImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(chilidView);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    [friendNameLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(friendIconImageView);
        make.left.equalTo(friendIconImageView.mas_right).offset(12);
        make.height.equalTo(friendIconImageView).multipliedBy(0.5);
    }];

    [sexImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(friendNameLabel.mas_right).offset(2);
        make.centerY.equalTo(friendNameLabel);
    }];

    [friendHushengLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.equalTo(friendIconImageView);
        make.left.equalTo(friendNameLabel);
        make.height.equalTo(friendIconImageView).multipliedBy(0.5);
    }];

    UIView* footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 66);
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_send_message"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send-btn_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_Highlighted"] forState:UIControlStateHighlighted];
    [footerView addSubview:sendButton];
    _footView = footerView;
    [sendButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(46);
        make.centerY.equalTo(footerView);
    }];

    UITableView* friendDetalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    friendDetalTableView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    [friendDetalTableView setSeparatorColor:[UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1]];
    friendDetalTableView.delegate = self;
    friendDetalTableView.dataSource = self;

    [friendDetalTableView registerClass:[GYHDFriendDetailCell class] forCellReuseIdentifier:@"GYHDFriendDetailCellID"];
//    friendDetalTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    friendDetalTableView.tableHeaderView = headerView;
    if (!self.hidenSendButton) {
        friendDetalTableView.tableFooterView = footerView;
    }
    else {
        friendDetalTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

    //    [friendDetalTableView registerClass:[GYHDFriendDetailCell class] forCellReuseIdentifier:@"GYHDFriendDetailCellID"];

    [self.view addSubview:friendDetalTableView];
    _friendDetalTableView = friendDetalTableView;
    [friendDetalTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.left.bottom.right.mas_equalTo(0);
    }];
    [self getFriendDetail];
}

- (void)moreSelect:(UIButton*)button
{
    WS(weakSelf);
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:self.FriendCustID];
    NSDictionary* friendDict = [GYUtils stringToDictionary:dict[@"Friend_Basic"]];
    GYHDFriendDetailModel* friendDetailModel = self.friendDetailArrayM[1];
    NSLog(@"%@",friendDetailModel.userInfo);
    __block GYHDPopMoreView* popMoreView = [[GYHDPopMoreView alloc] init];
    //    GlobalData *data = [GlobalData shareInstance];
    NSMutableArray *moreArray = [NSMutableArray array];
    [moreArray addObject: [GYUtils localizedStringWithKey:@"GYHD_clear_message"]];
    [moreArray addObject: [GYUtils localizedStringWithKey:@"GYHD_delete_friend"]];
    if (![friendDetailModel.userInfo isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Friend_blacklist"]]) {
        [moreArray addObject: [GYUtils localizedStringWithKey:@"GYHD_add_black"]];
    }
    popMoreView.moreSelectArray = moreArray;
    
    [popMoreView show];
    popMoreView.block = ^(NSString* message) {
        //        [popMoreView disMiss];
        if ([message isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_clear_message"]]) {
            
            //      add zhangx 清空对话  删除好友 提示弹框
            GYHDPopDeleteTeamView *deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
            [deleteTeamView setTitle:[GYUtils localizedStringWithKey:@"GYHD_clear_message"] Content:[GYUtils localizedStringWithKey:@"GYHD_clear_message_tips"]];
            [deleteTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(230, 137.0f));
            }];
            WS(weakSelf)
            GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
            deleteTeamView.block = ^(NSString *message) {
                
                if (message) {
                    
                    [[GYHDMessageCenter sharedInstance] deleteWithMessage:weakSelf.FriendCustID fieldName:GYHDDataBaseCenterMessageCard TableName:GYHDDataBaseCenterMessageTableName];
                }
                [topView disMiss];
            };
            [topView show];
            
            
            //                [self.navigationController popToRootViewControllerAnimated:YES];
        } else if ([message isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_delete_friend"]]) {
            
            GYHDPopDeleteTeamView *deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
            [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_will_be_delete"],weakSelf.friendNameLabel.text] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_delete_tips"]];
            [deleteTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(230, 137.0f));
            }];
            WS(weakSelf)
            GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
            deleteTeamView.block = ^(NSString *message) {
                
                if (message) {
                    
                    NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
                    [insideDict setValue:myDict[@"Friend_ID"] forKey:@"accountId"];
                    [insideDict setValue:myDict[@"Friend_Name"] forKey:@"accountNickname"];
                    [insideDict setValue:myDict[@"Friend_Icon"] forKey:@"accountHeadPic"];
                    [insideDict setValue:friendDict[@"accountId"] forKey:@"friendId"];
                    [insideDict setValue:friendDict[@"nickname"] forKey:@"friendNickname"];
                    [insideDict setValue:@"4" forKey:@"friendStatus"];
                    [insideDict setValue:friendDict[@"headPic"]  forKey:@"friendHeadPic"];
                    
                    [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary *resultDict) {
                        if (resultDict && [resultDict[@"retCode"] integerValue] == 200) {
                            NSMutableDictionary *deleteFriendDict = [NSMutableDictionary dictionary];
                            deleteFriendDict[GYHDDataBaseCenterFriendCustID] = weakSelf.FriendCustID;
                            [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteFriendDict TableName:GYHDDataBaseCenterFriendTableName];
                            
                            NSMutableDictionary *deleteMessageDict = [NSMutableDictionary dictionary];
                            deleteMessageDict[GYHDDataBaseCenterMessageCard] = weakSelf.FriendCustID;
                            [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteMessageDict TableName:GYHDDataBaseCenterMessageTableName];
                            
                            NSMutableDictionary *delectDict = [NSMutableDictionary dictionary];
                            delectDict[GYHDDataBaseCenterPushMessageFromID] = weakSelf.FriendCustID;
                            [[GYHDMessageCenter sharedInstance]deleteInfoWithDict:delectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                            
                            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                            frienddeletedict[@"friendChange"] = @(11);
                            frienddeletedict[@"toID"] = friendDict[@"accountId"];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                        }
                        
                    }];
                }
                [topView disMiss];
            };
            [topView show];
            
            
        } else if ([message isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_add_black"]]) {
            
            GYHDPopDeleteTeamView *deleteTeamView = [[GYHDPopDeleteTeamView alloc] init];
            [deleteTeamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_in_blacklist"],weakSelf.friendNameLabel.text] Content:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_in_blacklist_tips"]];
            [deleteTeamView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(230, 137.0f));
            }];
            WS(weakSelf)
            GYHDPopView *topView = [[GYHDPopView alloc] initWithChlidView:deleteTeamView];
            deleteTeamView.block = ^(NSString *message) {
                
                if (message) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    dict[@"teamId"] = @"blacklisted";
                    dict[@"userId"] = myDict[@"Friend_ID"];
                    dict[@"friendId"] = friendDict[@"accountId"];
                    [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                        
                        NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                        frienddeletedict[@"friendChange"] = @(11);
                        frienddeletedict[@"toID"] = friendDict[@"accountId"];
                        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                        GYHDFriendDetailModel* friendDetailModel = weakSelf.friendDetailArrayM[1];
                        friendDetailModel.userInfo = [GYUtils localizedStringWithKey:@"GYHD_Friend_blacklist"];
                        self.hidenSendButton = YES;
                        [weakSelf.friendDetalTableView reloadData];
//                        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                    }];
                    
                }
                [topView disMiss];
            };
            [topView show];
        }
        
    };
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendDetailArrayM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDFriendDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDFriendDetailCellID"];
    cell.friendDetailModel = self.friendDetailArrayM[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHDFriendDetailModel* friendDetailModel = self.friendDetailArrayM[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"GYHDFriendDetailCellID" configuration:^(GYHDFriendDetailCell* cell) {
        cell.friendDetailModel = friendDetailModel;
    }];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = nil;
    if (!self.hidenSendButton) {
       footView = _footView;
    }
    else {
        footView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return footView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.footView.frame.size.height;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHDFriendDetailModel* friendDetailModel = self.friendDetailArrayM[indexPath.row];
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSDictionary* userdict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:self.FriendCustID];
    if ([friendDetailModel.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_classification"]]) {

        GYHDPopMoveTeamView* moveTeamView = [[GYHDPopMoveTeamView alloc] init];
        //        [moveTeamView settitle: [GYUtils localizedStringWithKey:@"GYHD_classification"]];
        NSString* title = [NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_to"], self.friendNameLabel.text];
        [moveTeamView settitle:title];

        NSArray* dbArray = [[GYHDMessageCenter sharedInstance] getFriendTeamRequetResult:nil];
        NSMutableArray* movieArray = [NSMutableArray array];
        [movieArray addObject:[GYUtils localizedStringWithKey:@"GYHD_all"]];
        for (NSDictionary* teamDict in dbArray) {
            if (![teamDict[@"Tream_ID"] isEqualToString:@"blacklisted"]) {
                NSDictionary* teamDetailDict = [GYUtils stringToDictionary:teamDict[@"Tream_detal"]];
                [movieArray addObject:teamDetailDict[@"teamName"]];
            }
        }
        [moveTeamView setDataSource:movieArray];
        [moveTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(270, 276.0f));
        }];
        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:moveTeamView];
        [popView showToView:self.navigationController.view];
        WS(weakSelf);
        moveTeamView.block = ^(NSString* messageString) {

            if ([messageString isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_all"]]) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"teamId"] = @"unteamed";
                dict[@"userId"] = myDict[@"Friend_ID"];
                dict[@"friendId"] = userdict[@"Friend_ID"];
                if ([friendDetailModel.userInfo isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Friend_blacklist"]]) {
                    dict[@"ifCancelBlacklisted"] = @"Y";
                }
                [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                    if ([resultDict[@"retCode"] integerValue] == 200) {
                        self.hidenSendButton = NO;
                        friendDetailModel.userInfo = messageString;
                        [weakSelf.friendDetalTableView reloadData];
                        NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                        frienddeletedict[@"friendChange"] = @(11);
                        frienddeletedict[@"toID"] =  userdict[@"Friend_ID"];
                        [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];

                    }
                }];
            }else {
                for (NSDictionary *teamDict in dbArray) {
                    NSDictionary *teamDetailDict = [GYUtils stringToDictionary:teamDict[@"Tream_detal"]];
                    if ([teamDetailDict[@"teamName"] isEqualToString:messageString]) {
                        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                        dict[@"teamId"] = teamDetailDict[@"teamId"];
                        dict[@"userId"] = myDict[@"Friend_ID"];
                        dict[@"friendId"] = userdict[@"Friend_ID"];
                        if ([friendDetailModel.userInfo isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Friend_blacklist"]]) {
                            dict[@"ifCancelBlacklisted"] = @"Y";
                        }
                        [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                            if ([resultDict[@"retCode"] integerValue] == 200) {
                                self.hidenSendButton = NO;
                                friendDetailModel.userInfo = messageString;
                                [weakSelf.friendDetalTableView reloadData];
                                NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                                frienddeletedict[@"friendChange"] = @(11);
                                frienddeletedict[@"toID"] =  userdict[@"Friend_ID"];
                                [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                            }
                        }];
    
                        
                        
                        break;
                    }
                }
            }
            [popView disMiss];

        };
    }
    else if ([friendDetailModel.userInfoName isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_remarks"]]) {
        GYHDPopAddTeamView* popAddteamView = [[GYHDPopAddTeamView alloc] init];
        //        [popAddteamView setTitle:@"修改备注"];
        [popAddteamView setTitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_Edit_sb_Note"], self.nameStr]];
        popAddteamView.maxCharCount = 11;
        [popAddteamView setDefaulText:friendDetailModel.userInfo];
        [popAddteamView setPlaceholder:[NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_inptu"],[GYUtils localizedStringWithKey:@"GYHD_remarks"]]];
        [popAddteamView mas_makeConstraints:^(MASConstraintMaker* make) {
            make.size.mas_equalTo(CGSizeMake(270, 147.0f));
        }];

        GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:popAddteamView];
        [popView showToView:self.navigationController.view];
        WS(weakSelf);
        popAddteamView.block = ^(NSString* message) {
            [popView disMiss];
            if (message) {

                if (message || message.length > 1) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setValue:myDict[@"Friend_ID"] forKey:@"accountId"];
                    [dict setValue:userdict[@"Friend_ID"]  forKey:@"friendId"];
                    [dict setValue:message forKey:@"friendNickname"];
                    [[GYHDMessageCenter sharedInstance] updateFriendNickNameWithDict:dict RequetResult:^(NSDictionary *resultDict) {
                        if ([resultDict[@"retCode"] integerValue] == 200) {
                            friendDetailModel.userInfo = message;
                            [weakSelf.friendDetalTableView reloadData];
                            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                            frienddeletedict[@"friendChange"] = @(11);
                            frienddeletedict[@"toID"] =  userdict[@"Friend_ID"];
                            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
                            self.friendNameLabel.text = message;
                        }

                    }];
                }


            }
        };
    }
}


- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath

{
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
}


- (void)setFriendCustID:(NSString*)FriendCustID
{
    _FriendCustID = FriendCustID;
    [self getFriendDetail];
}

- (void)getFriendDetail
{
    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectFriendBaseWithCardString:self.FriendCustID];
    NSDictionary* friendDict = [GYUtils stringToDictionary:dict[@"Friend_Basic"]];
    [self.friendIconImageView setImageWithURL:[NSURL URLWithString:dict[GYHDDataBaseCenterFriendIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    NSString* hushengCard = friendDict[@"accountId"];

    NSMutableArray* friendDetailArrayM = [NSMutableArray array];
    hushengCard = [NSString stringWithFormat:@"%@%@", [GYUtils localizedStringWithKey:@"GYHD_hushengCard"], [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:dict[@"Friend_ResourceID"]] ];
    self.friendHushengLabel.text = hushengCard;
    self.friendNameLabel.text = friendDict[@"nickname"];
    self.friendNikeNameLabel.text = friendDict[@"nickname"];
    self.nameStr = friendDict[@"nickname"];
    //1. 备注
    GYHDFriendDetailModel* remarkModel = [[GYHDFriendDetailModel alloc] init];
    remarkModel.userInfo = friendDict[@"remark"];
    remarkModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_remarks"];
    [friendDetailArrayM addObject:remarkModel];
    //2. 分类
    GYHDFriendDetailModel* teamNameModel = [[GYHDFriendDetailModel alloc] init];
    
    if ([friendDict[@"teamName"] isEqualToString:@""]) {
        teamNameModel.userInfo = [GYUtils localizedStringWithKey:@"GYHD_all"];
    }else {
        teamNameModel.userInfo = friendDict[@"teamName"];
    }
//    teamNameModel.userInfo = friendDict[@""];
    teamNameModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_classification"];
    [friendDetailArrayM addObject:teamNameModel];
    //3. 地区
    GYHDFriendDetailModel* addressModel = [[GYHDFriendDetailModel alloc] init];
    if ([friendDict[@"city"] integerValue] > 0) {
        //       GYCityAddressModel *model = [[GYFMDBCityManager shareInstance] selectCity:friendDict[@"city"] ];
        GYCityAddressModel* model = [[GYAddressData shareInstance] queryCityNo:friendDict[@"city"]];
        addressModel.userInfo = model.cityFullName;
    }
    else {
        addressModel.userInfo = @"";
    }
    addressModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_area"];
    [friendDetailArrayM addObject:addressModel];
    //4. 爱好
    GYHDFriendDetailModel* hobbyModel = [[GYHDFriendDetailModel alloc] init];
    hobbyModel.userInfo = friendDict[@"hobby"];
    hobbyModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_hobby"];
    [friendDetailArrayM addObject:hobbyModel];
    //5.
    GYHDFriendDetailModel* signModel = [[GYHDFriendDetailModel alloc] init];
    if ([friendDict[@"sign"] isEqualToString:@"null"]) {

        signModel.userInfo = @"";
    }
    else {

        signModel.userInfo = kSaftToNSString(friendDict[@"sign"]);
    }

    signModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_sign"];
    [friendDetailArrayM addObject:signModel];
    self.friendDetailArrayM = friendDetailArrayM;

    if ([friendDict[@"accountId"] hasPrefix:@"nc_"]) {
        self.friendHushengLabel.hidden = YES;
    }
    UIImage* sexImgae = nil;
    if ([friendDict[@"sex"] isEqualToString:@"1"]) {
        sexImgae = [UIImage imageNamed:@"gyhd_man_icon"];
    }
    else if ([friendDict[@"sex"] isEqualToString:@"0"]) {
        sexImgae = [UIImage imageNamed:@"gyhd_girl_icon"];
    }
    self.sexImageView.image = sexImgae;
}

- (void)sendButtonClick
{
    GYHDChatViewController* chatViewController = [[GYHDChatViewController alloc] init];
    // 传19位
    chatViewController.messageCard = self.FriendCustID;
    chatViewController.title = self.friendNameLabel.text;
    [self.navigationController pushViewController:chatViewController animated:YES];
}

@end
