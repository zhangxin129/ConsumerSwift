//
//  GYHDFriendApplicationViewController.m
//  HSConsumer
//
//  Created by shiang on 16/5/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFriendApplicationViewController.h"
#import "GYHDFriendApplicationCell.h"
#import "GYHDFriendApplicationModel.h"
#import "GYHDMessageCenter.h"
//#import "GYFMDBCityManager.h"
#import "GYAddressData.h"

@interface GYHDFriendApplicationViewController () <UITableViewDataSource, UITableViewDelegate>
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
@property (nonatomic, weak) UIView* footView;
@property (nonatomic, weak) UIImageView* sexImageView;
@property (nonatomic, weak) UIButton* sendButton;
/**个人资料dict*/
@property (nonatomic, strong) NSMutableDictionary* infoDict;
@end

@implementation GYHDFriendApplicationViewController

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

    UIView* footerView = [[UIView alloc] init];
    footerView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    footerView.frame = CGRectMake(0, 0, kScreenWidth, 66);
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_To_Apply_For"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send-btn_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_Highlighted"] forState:UIControlStateHighlighted];

    [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"] forState:UIControlStateSelected];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"btn-ignore_h"] forState:UIControlStateSelected];
    sendButton.frame = CGRectMake(12, 12, kScreenWidth - 24, 66 - 24);
    [footerView addSubview:sendButton];
    _sendButton = sendButton;

    UITableView* friendDetalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    friendDetalTableView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    friendDetalTableView.delegate = self;
    friendDetalTableView.dataSource = self;
    friendDetalTableView.tableHeaderView = headerView;
    friendDetalTableView.tableFooterView = footerView;

    [friendDetalTableView registerClass:[GYHDFriendApplicationCell class] forCellReuseIdentifier:@"GYHDFriendApplicationCellID"];
    [self.view addSubview:friendDetalTableView];
    _friendDetalTableView = friendDetalTableView;
    [friendDetalTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.left.bottom.right.mas_equalTo(0);
    }];

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray* array = [NSMutableArray array];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[GYHDDataBaseCenterFriendCustID] = self.FriendCustID;
    NSArray* infoArray = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:dict TableName:GYHDDataBaseCenterFriendTableName];
    self.infoDict = [NSMutableDictionary dictionaryWithDictionary:infoArray.lastObject];
    NSDictionary* boydDict = [GYUtils stringToDictionary:self.infoDict[@"Friend_Basic"]];
    GYHDFriendApplicationModel* teamModel = [[GYHDFriendApplicationModel alloc] init];
    teamModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_classification"];
    teamModel.infoDetail = [GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"];
    [array addObject:teamModel];
    GYHDFriendApplicationModel* addressModel = [[GYHDFriendApplicationModel alloc] init];

    if ([boydDict[@"city"] integerValue] > 0) {
        //        GYCityAddressModel *model = [[GYFMDBCityManager shareInstance] selectCity:boydDict[@"city"]];
        GYCityAddressModel* model = [[GYAddressData shareInstance] queryCityNo:boydDict[@"city"]];
        addressModel.infoDetail = model.cityFullName;
    }
    else {
        addressModel.infoDetail = @"";
    }
    addressModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_Friend_address"];
    [array addObject:addressModel];
    GYHDFriendApplicationModel* hobbyModel = [[GYHDFriendApplicationModel alloc] init];
    hobbyModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_hobby"];
    hobbyModel.infoDetail = [boydDict[@"hobby"] isEqualToString:@"null"] ? @"" : boydDict[@"hobby"];
    [array addObject:hobbyModel];
    GYHDFriendApplicationModel* signModel = [[GYHDFriendApplicationModel alloc] init];
    signModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_sign"];
    signModel.infoDetail = [boydDict[@"sign"] isEqualToString:@"null"] ? @"" : boydDict[@"sign"];
    [array addObject:signModel];
    self.friendDetailArrayM = array;
    NSURL* url = [NSURL URLWithString:self.infoDict[@"Friend_Icon"]];
    [self.friendIconImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    self.friendNameLabel.text = self.infoDict[@"Friend_Name"];

    if ([self.infoDict[@"Friend_ID"] hasPrefix:@"nc_"]) {
        self.friendHushengLabel.hidden = YES;
    }
    self.friendHushengLabel.text = [NSString stringWithFormat:@"%@: %@",[GYUtils localizedStringWithKey:@"GYHD_hushengCard"],
                                    [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:self.infoDict[@"Friend_ResourceID"]]];

    NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
    selectDict[@"User_Name"] = self.FriendCustID;
    NSArray* setArray = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:selectDict TableName:GYHDDataBaseCenterUserSetingTableName];
    NSDictionary* setDict = setArray.lastObject;
    if (setDict[GYHDDataBaseCenterUserSetingSelectCount]) {

        NSInteger countI = [setDict[GYHDDataBaseCenterUserSetingSelectCount] integerValue];
        if (countI > 4) {
            self.sendButton.selected = YES;
            self.sendButton.userInteractionEnabled = NO;
        }
    }
}

- (void)sendButtonClick
{

    NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
    NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
    insideDict[@"accountId"] = dict[@"Friend_ID"];
    insideDict[@"accountNickname"] = dict[@"Friend_Name"];
    insideDict[@"accountHeadPic"] = dict[@"Friend_Icon"];
    insideDict[@"req_info"] = [NSString stringWithFormat:@"我是%@", dict[@"Friend_Name"]];
    insideDict[@"friendId"] = self.infoDict[@"Friend_ID"];
    insideDict[@"friendNickname"] = self.infoDict[@"Friend_Name"];
    insideDict[@"friendStatus"] = @"1";
    insideDict[@"friendHeadPic"] = self.infoDict[@"Friend_Icon"];
    [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary* resultDict) {
        if ([resultDict[@"retCode"] isEqualToString:@"200"]) {
            
//            UIWindow *windows = [UIApplication sharedApplication].windows.lastObject;
//            [windows makeToast:@"重新申请！"];
            [GYUtils showToast:[GYUtils localizedStringWithKey:@"GYHD_Friend_To_Apply_For_success"]];
            NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
            selectDict[@"User_Name"] = self.FriendCustID;
            NSArray *setArray =  [[GYHDMessageCenter sharedInstance] selectInfoWithDict:selectDict TableName:GYHDDataBaseCenterUserSetingTableName];
            NSDictionary *setDict = setArray.lastObject;
            NSString  *count = nil;
            if (setDict[GYHDDataBaseCenterUserSetingSelectCount]) {

                NSInteger countI = [setDict[GYHDDataBaseCenterUserSetingSelectCount] integerValue];
                if (countI == 4) {
                    self.sendButton.selected = YES;
                    self.sendButton.userInteractionEnabled = NO;
                }
                count = [NSString stringWithFormat:@"%ld",(long)++countI];
            }else {
                count = @"1";
            }
            [[GYHDMessageCenter sharedInstance] updataFriendSelectCount:count custID: self.FriendCustID];
//            if ([self.infoDict[@"Friend_SelectCount"] isEqualToString:@"-1"]) {
//                self.infoDict[@"Friend_SelectCount"] = @"1";
//            }else {
//                NSInteger selectCount = [self.infoDict[@"Friend_SelectCount"] integerValue];
//                self.infoDict[@"Friend_SelectCount"] = [NSString stringWithFormat:@"%ld",++selectCount];
//            }
//            
//            NSMutableDictionary *conditionDict = [NSMutableDictionary dictionary];
//            conditionDict[GYHDDataBaseCenterFriendCustID] = self.FriendCustID;
//            
//            NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
//            updateDict[@"Friend_SelectCount"] = self.infoDict[@"Friend_SelectCount"];
//            [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:conditionDict TableName:GYHDDataBaseCenterFriendTableName];
        }
    }];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendDetailArrayM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDFriendApplicationModel* model = self.friendDetailArrayM[indexPath.row];
    GYHDFriendApplicationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDFriendApplicationCellID"];
    cell.model = model;
    return cell;
}
@end
