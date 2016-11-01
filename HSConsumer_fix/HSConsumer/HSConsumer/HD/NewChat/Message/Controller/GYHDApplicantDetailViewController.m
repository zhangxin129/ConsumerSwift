//
//  GYHDApplicantDetailViewController.m
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDApplicantDetailViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDPopMoveTeamView.h"
#import "GYHDPopView.h"



@interface GYHDApplicantDetailViewController ()
/**好友头像View*/
@property (nonatomic, weak) UIImageView* friendIconImageView;
/**友好名字Label*/
@property (nonatomic, weak) UILabel* friendNameLabel;
/**好友互生卡*/
@property (nonatomic, weak) UILabel* friendHushengLabel;
/**好友model*/
@property (nonatomic, weak) UIImageView* sexImageView;
@property (nonatomic, weak) UILabel* selectTeamLabel;
@property (nonatomic, weak) UIButton* agreeButton;

@property(nonatomic, copy)NSString *iconString;
@property(nonatomic, copy)NSString *nameString;
@property(nonatomic, copy)NSString *hushengString;
@property(nonatomic, copy)NSString *sexString;
@end

@implementation GYHDApplicantDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Friend_application_friend"];
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    UIView* chilidView = [[UIView alloc] init];
    chilidView.frame = CGRectMake(0, 20, kScreenWidth, 66);
    chilidView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:chilidView];
    //1. 头像
    UIImageView* friendIconImageView = [[UIImageView alloc] init];
    friendIconImageView.layer.masksToBounds = YES;
    friendIconImageView.layer.cornerRadius = 3.0f;
    //    friendIconImageView.image = [UIImage imageNamed:@"gyhd_defaultheadimg"];
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

    UILabel* extraInformationLabel = [[UILabel alloc] init];
    extraInformationLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_extra_information"];
    [self.view addSubview:extraInformationLabel];

    UIView* contView = [[UIView alloc] init];
    contView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contView];
    UILabel* extraInformationContLabel = [[UILabel alloc] init];
    extraInformationContLabel.text = @"xx";
    extraInformationContLabel.numberOfLines = 0;
    [contView addSubview:extraInformationContLabel];

    UILabel* teamLabel = [[UILabel alloc] init];

    teamLabel.text = [GYUtils localizedStringWithKey:@"GYHD_classification"];
    [self.view addSubview:teamLabel];

    UIView* teamView = [[UIView alloc] init];
    teamView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(teamClcik)];
    [teamView addGestureRecognizer:tap];
    [self.view addSubview:teamView];

    UILabel* selectTeamLabel = [[UILabel alloc] init];
    selectTeamLabel.text = [GYUtils localizedStringWithKey:@"GYHD_all"];
    [teamView addSubview:selectTeamLabel];
    _selectTeamLabel = selectTeamLabel;

    UIImageView* moreImageView = [[UIImageView alloc] init];
    moreImageView.image = [UIImage imageNamed:@"gyhd_more_gd"];
    [self.view addSubview:moreImageView];

    UIButton* agreeButton = [[UIButton alloc] init];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn-gyhd_argee_btn_normal"] forState:UIControlStateNormal];
    [agreeButton setBackgroundImage:[UIImage imageNamed:@"btn-gyhd_argee_btn_Highlighte"] forState:UIControlStateHighlighted];
    [agreeButton addTarget:self action:@selector(agreeClick) forControlEvents:UIControlEventTouchUpInside];
    [agreeButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_agree"] forState:UIControlStateNormal];
    [agreeButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_already_agree"] forState:UIControlStateSelected];
    [self.view addSubview:agreeButton];
    _agreeButton = agreeButton;
    UIButton* ignoreButton = [[UIButton alloc] init];
    [ignoreButton setBackgroundImage:[UIImage imageNamed:@"gyhd_ignore_btn_normal"] forState:UIControlStateNormal];
    [ignoreButton setBackgroundImage:[UIImage imageNamed:@"gyhd_ignore_btn_Highlighte"] forState:UIControlStateHighlighted];
    [ignoreButton addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
    [ignoreButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_GYHD_Frined_Ignored"] forState:UIControlStateNormal];
    [self.view addSubview:ignoreButton];

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
    [extraInformationLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(chilidView.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(35);
    }];

    [extraInformationContLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.centerY.equalTo(contView);
        make.top.equalTo(extraInformationLabel.mas_bottom).offset(12);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-50);

    }];

    [contView mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.top.equalTo(extraInformationLabel.mas_bottom);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(44);
//        make.top.left.bottom.right.equalTo(extraInformationContLabel);
        make.top.equalTo(extraInformationLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.equalTo(extraInformationContLabel).offset(24);
    }];

    [teamLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(contView.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(35);
    }];

    [teamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(teamLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];

    [moreImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(teamView);
        make.right.mas_equalTo(-12);
    }];

    [selectTeamLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.centerY.equalTo(teamView);
        make.left.mas_equalTo(12);
    }];

    [agreeButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(teamView.mas_bottom).offset(20);
        make.left.mas_equalTo(12);
        make.height.mas_equalTo(40);
        make.right.equalTo(ignoreButton.mas_left).offset(-20);
        make.width.equalTo(ignoreButton);
    }];

    [ignoreButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(teamView.mas_bottom).offset(20);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(40);
        make.left.equalTo(agreeButton.mas_right).offset(20);
        make.width.equalTo(agreeButton);
    }];

    NSDictionary* infoDict = [GYUtils stringToDictionary:self.model.applicantBody];
    [friendIconImageView setImageWithURL:[NSURL URLWithString:infoDict[@"msg_icon"]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];

    friendNameLabel.text = infoDict[@"msg_note"];
    NSString* hushengCard = infoDict[@"fromId"];
    if (hushengCard.length>11) {
        
            friendHushengLabel.text = [NSString stringWithFormat:@"%@: %@",[GYUtils localizedStringWithKey:@"GYHD_hushengCard"],[[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:[hushengCard substringWithRange:NSMakeRange(2, 11)]]];
    }else {
           friendHushengLabel.text = [NSString stringWithFormat:@"%@: %@",[GYUtils localizedStringWithKey:@"GYHD_hushengCard"],[[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:hushengCard]];
    }
    if ([hushengCard hasPrefix:@"nc_"]) {
        friendHushengLabel.hidden = YES;
    }else {
        friendHushengLabel.hidden = NO;
    }
    extraInformationContLabel.text = infoDict[@"req_info"];
    switch (self.model.applicantUserStatus) {
    case 0:
        agreeButton.selected = NO;
        agreeButton.userInteractionEnabled = YES;
        break;
    case 1:
        agreeButton.selected = YES;
        agreeButton.userInteractionEnabled = NO;
        break;

    default:
        break;
    }
    // Do any additional setup after loading the view.
}
- (void)setInfoDict:(NSDictionary *)infoDict {
    _infoDict = infoDict;
//    self.iconString =;
//    self.nameString = ;
//    self.hushengString = ;
//    self.sexString = ;
}

- (void)teamClcik
{

    GYHDPopMoveTeamView* moveTeamView = [[GYHDPopMoveTeamView alloc] init];

    NSArray* teamArray = [[GYHDMessageCenter sharedInstance] getFriendTeamRequetResult:nil];

    NSMutableArray* movieArray = [NSMutableArray array];
    [movieArray addObject:[GYUtils localizedStringWithKey:@"GYHD_all"]];
    for (NSDictionary* dict in teamArray) {
        if ([dict[@"Tream_Name"] isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Friend_blacklist"]]) {
        }
        else {
            [movieArray addObject:dict[@"Tream_Name"]];
        }
    }
    [moveTeamView settitle:[NSString stringWithFormat:[GYUtils localizedStringWithKey:@"GYHD_Friend_move_to"], self.friendNameLabel.text]];

    [moveTeamView setDataSource:movieArray];
    [moveTeamView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270, 276.0f));
    }];
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:moveTeamView];
    [popView showToView:self.navigationController.view];
    WS(weakSelf);
    moveTeamView.block = ^(NSString* messageString) {
        weakSelf.selectTeamLabel.text = messageString;
        [popView disMiss];
    };
}

- (void)agreeClick
{
    NSArray* teamArray = [[GYHDMessageCenter sharedInstance] getFriendTeamRequetResult:nil];
    NSString* teamID = nil;
    for (NSDictionary* dict in teamArray) {
        if ([dict[@"Tream_Name"] isEqualToString:self.selectTeamLabel.text]) {
            teamID = dict[@"Tream_ID"];
            break;
        }
    }

    NSDictionary* infoDict = [GYUtils stringToDictionary:self.model.applicantBody];
    NSDictionary* myDict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"accountId"] = myDict[@"Friend_ID"];
    insideDict[@"accountNickname"] = myDict[@"Friend_Name"];
    insideDict[@"accountHeadPic"] = myDict[@"Friend_Icon"];
    insideDict[@"req_info"] = @"11";
    insideDict[@"friendId"] = infoDict[@"fromId"];
    insideDict[@"friendNickname"] = infoDict[@"msg_note"];
    insideDict[@"friendStatus"] = @"2";
    insideDict[@"friendHeadPic"] = infoDict[@"msg_icon"];
    [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary* resultDict) {
        if ([resultDict[@"retCode"] isEqualToString:@"200"]  ||
            [resultDict[@"retCode"] isEqualToString:@"501"]  ||
            [resultDict[@"retCode"] isEqualToString:@"810"]  ||
            [resultDict[@"retCode"] isEqualToString:@"811"]  ) {
            if ([resultDict[@"retCode"] isEqualToString:@"200"]  ||
                [resultDict[@"retCode"] isEqualToString:@"501"]) {
                [GYUtils showToast:[resultDict[@"retCode"] isEqualToString:@"501"] ? [GYUtils localizedStringWithKey:@"GYHD_Friend_add_already"] :[GYUtils localizedStringWithKey:@"GYHD_Friend_add_success"] duration:1.0f position:CSToastPositionCenter];
            }else {
                [self.agreeButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_Reached_the_limit"] forState:UIControlStateSelected];
                [GYUtils showToast:resultDict[@"message"] duration:1.0f position:CSToastPositionCenter];
            }
            
            self.model.applicantUserStatus = 0;
            self.agreeButton.selected = YES;
            self.agreeButton.userInteractionEnabled = NO;
            if (teamID) {
                NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
                sendDict[@"teamId"] = teamID;
                sendDict[@"userId"] =  myDict[@"Friend_ID"];
                sendDict[@"friendId"] = infoDict[@"fromId"];
                [[GYHDMessageCenter sharedInstance] MovieFriendWithDict:sendDict RequetResult:^(NSDictionary *resultDict) {
                    UIWindow *windows = [UIApplication sharedApplication].keyWindow;
                    [windows makeToast:[GYUtils localizedStringWithKey:@"GYHD_success"] duration:1.0f position:CSToastPositionCenter];
                }];
            }
            
            NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
            selectDict[GYHDDataBaseCenterPushMessageCode] = @"4101";
            NSString *fromdID = nil;
            if ([self.model.applicantID hasPrefix:@"nc_"]) {
                fromdID = [self.model.applicantID substringFromIndex:3];
            }else if ([self.model.applicantID hasPrefix:@"c_"]){
                fromdID = [self.model.applicantID substringFromIndex:2];
            }else {
                fromdID = self.model.applicantID;
            }
            selectDict[GYHDDataBaseCenterPushMessageFromID] =fromdID;
//            NSDictionary *pushDict = [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName].lastObject;
            
            
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:self.model.applicantBody]];
            bodyDict[@"status"] = resultDict[@"retCode"];
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
            NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
            condDict[GYHDDataBaseCenterPushMessageID] = self.model.applicantMessageID;

            [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName];
            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
            frienddeletedict[@"friendChange"] = @(100);
            frienddeletedict[@"toID"] =  updateDict[@"friendId"];
            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
        }else {
            if ([resultDict[@"retCode"] isEqualToString:@"810"] ||
                [resultDict[@"retCode"] isEqualToString:@"811"]) {
                self.agreeButton.selected = YES;
                self.agreeButton.userInteractionEnabled = NO;
                [self.agreeButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_Reached_the_limit"] forState:UIControlStateSelected];
//                NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
//                selectDict[GYHDDataBaseCenterPushMessageCode] = @"4101";
//                selectDict[GYHDDataBaseCenterPushMessageFromID] = self.model.applicantID;
//                [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName];
            }
            [GYUtils showToast:resultDict[@"message"] duration:1.0f position:CSToastPositionCenter];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)ignoreClick
{
    WS(weakSelf);
    NSDictionary* infoDict = [GYUtils stringToDictionary:self.model.applicantBody];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSDictionary *myDict =  [[GYHDMessageCenter sharedInstance] selectMyInfo];
    dict[@"accountId"] = myDict[@"Friend_ID"];
    dict[@"friendId"] = infoDict[@"fromId"];
    [[GYHDMessageCenter sharedInstance] deleteRedundantFriendVerifyDataWithDict:dict RequetResult:^(NSDictionary *resultDict) {
        if ([resultDict[@"retCode"] isEqualToString:@"200"]){
            NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:self.model.applicantBody]];
            bodyDict[@"status"] = @"2";
            self.model.applicantUserStatus = 2;
            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
            updateDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
            NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
            condDict[GYHDDataBaseCenterPushMessageID] = self.model.applicantMessageID;
            [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
            NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
            frienddeletedict[@"friendChange"] = @(100);
            frienddeletedict[@"toID"] =  updateDict[@"friendId"];
            [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
            [weakSelf.navigationController popViewControllerAnimated:YES];
         }
    }];

}
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
@end
