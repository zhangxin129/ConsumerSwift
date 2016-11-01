//
//  GYHDSearchUserDetailViewController.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchUserDetailViewController.h"
#import "GYHDSearchUserDetailCell.h"
#import "GYHDSearchUserInfoCell.h"
#import "GYHDSearchUserDetailModel.h"
#import "GYHDSearchUserModel.h"
#import "GYHDMessageCenter.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GYHDSDK.h"
#import "GYHDSendAddFriendViewController.h"

@interface GYHDSearchUserDetailViewController ()<UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong)UITableView *infoTableView;
@property(nonatomic, strong)NSArray     *dataArray;

@end

@implementation GYHDSearchUserDetailViewController
- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return  _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";

    self.view.backgroundColor = [UIColor orangeColor];
    self.infoTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.infoTableView.dataSource = self;
    self.infoTableView.delegate = self;

    //    self.infoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.infoTableView registerClass:[GYHDSearchUserDetailCell class] forCellReuseIdentifier:NSStringFromClass([GYHDSearchUserDetailCell class])];
    [self.infoTableView registerClass:[GYHDSearchUserInfoCell class] forCellReuseIdentifier:NSStringFromClass([GYHDSearchUserInfoCell class])];
    [self.view addSubview:self.infoTableView];
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    [self loadData];
}
- (void)loadData {
    
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *iconArray = [NSMutableArray array];
    GYHDSearchUserDetailModel *iconModel = [[GYHDSearchUserDetailModel alloc] init];
    iconModel.iconString = self.userModel.iconString;
    iconModel.nikeNameString = self.userModel.nameString;
    iconModel.huShengString = self.userModel.hushengString;
    [iconArray addObject:iconModel];
    
    NSMutableArray *infoArray = [NSMutableArray array];
    GYHDSearchUserDetailModel *addressModel = [[GYHDSearchUserDetailModel alloc] init];
    addressModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_Friend_address"];
    addressModel.userInfo = self.userModel.address;
    
    [infoArray addObject:addressModel];
    if ([self.userModel.userType isEqualToString:@"c"]) {
        GYHDSearchUserDetailModel *hobbyModel = [[GYHDSearchUserDetailModel alloc] init];
        hobbyModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_hobby"];
        hobbyModel.userInfo = self.userModel.hobby;
        
        GYHDSearchUserDetailModel *signModel = [[GYHDSearchUserDetailModel alloc] init];
        signModel.userInfoName = [GYUtils localizedStringWithKey:@"GYHD_sign"];
        signModel.userInfo = self.userModel.sign;
        
        
        [infoArray addObject:hobbyModel];
        [infoArray addObject:signModel];
    }

    
    [array addObject:iconArray];
    [array addObject:infoArray];
    self.dataArray = array;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (!indexPath.section) {
        GYHDSearchUserDetailCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDSearchUserDetailCell class])];
        baseCell.model = self.dataArray[indexPath.section][indexPath.row];
        cell = baseCell;
    }else {
        GYHDSearchUserInfoCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDSearchUserInfoCell class])];
        baseCell.model = self.dataArray[indexPath.section][indexPath.row];
        cell = baseCell;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!indexPath.section) {
       return  68.0f;
    }else {
        return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([GYHDSearchUserInfoCell class]) configuration:^(GYHDSearchUserInfoCell *cell) {
            cell.model = self.dataArray[indexPath.section][indexPath.row];
        }];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
        return 66;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section) {
        UIView* footerView = [[UIView alloc] init];
        footerView.backgroundColor =[UIColor clearColor];
        footerView.frame = CGRectMake(0, 0, kScreenWidth, 66);
        UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([self.userModel.userType isEqualToString:@"c"]) {
            if ([self.userModel.friendStatus isEqualToString:@"-1"]) {
                [sendButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_Friend_agree"] forState:UIControlStateNormal];
            }else if([self.userModel.friendStatus isEqualToString:@"1"]){
                sendButton.userInteractionEnabled = NO;
                [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"] forState:UIControlStateNormal];
            }else {
                [sendButton setTitle: [GYUtils localizedStringWithKey:@"GYHD_Friend_add_Friend" ]forState:UIControlStateNormal];
            }

        }else {
            [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_user_attentionCompany" ]forState:UIControlStateNormal];
        }

        sendButton.layer.cornerRadius=21;
        sendButton.layer.masksToBounds=YES;

//        sendButton.backgroundColor=[UIColor colorWithRed:239 / 255.0f green:66 / 255.0f blue:55 / 255.0f alpha:1];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send-btn_normal"] forState:UIControlStateNormal];
        [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_Highlighted"] forState:UIControlStateHighlighted];
        sendButton.frame = CGRectMake(12, 12, kScreenWidth - 24, 66 - 24);
        [footerView addSubview:sendButton];
        return footerView;
    }
    return nil;
}
- (void)footButtonClick:(UIButton *)button {
            WS(weakSelf);
    if ([self.userModel.userType isEqualToString:@"c"])
    {
        if ([self.userModel.friendStatus isEqualToString:@"-1"]) {
            
            NSDictionary *dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
            NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
            insideDict[@"msg_icon"] = dict[@"Friend_Icon"];
            insideDict[@"msg_note"] = dict[@"Friend_Name"];
            insideDict[@"sex"] = globalData.loginModel.sex;
            insideDict[@"reqInfo"] = @"同意添加你为好友";
            insideDict[@"msg_subject"] = [NSString stringWithFormat:@"%@ 同意添加你为好友", self.userModel.nameString];
            insideDict[@"msgContent"] = @"同意添加你为好友";

            
            
            [[GYHDSDK sharedInstance] verifyFriendWithFriendID:[NSString stringWithFormat:@"m_%@",self.userModel.custID] agree:0 content:[GYUtils dictionaryToString:insideDict]];
    
            [GYHDSDK sharedInstance].receiveMsgBlock = ^(PBGeneratedMessage *message){
                if ([message isKindOfClass:[VerifyFriendRsp class]]) {
                    VerifyFriendRsp *rsp = (VerifyFriendRsp *)message;
                    if (rsp.resultCode == ResultCodeNoError){
                        [button setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_already_agree"] forState:UIControlStateNormal];

                        button.userInteractionEnabled = NO;
                        weakSelf.userModel.friendStatus = @"2";
                        
                        NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
                        selectDict[GYHDDataBaseCenterPushMessageCode] = @"4101";
                        selectDict[GYHDDataBaseCenterPushMessagePlantFromID] =[NSString stringWithFormat:@"m_%@",weakSelf.userModel.custID];
                        NSDictionary *pushDict = [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName].lastObject;
                        
                        
                        NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:pushDict[GYHDDataBaseCenterPushMessageBody]]];
                        bodyDict[@"status"] = @"1";

                        NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                        updateDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
                        NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                        condDict[GYHDDataBaseCenterPushMessageID] = [NSString stringWithFormat:@"m_c_%@",weakSelf.userModel.custID];
                        
                        [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName];
                        [[GYHDMessageCenter sharedInstance] getFriendListRequetResult:^(NSArray *resultArry) {
                        }];
                    }
                }
            };
        }else {
            GYHDSendAddFriendViewController* sendViewController = [[GYHDSendAddFriendViewController alloc] init];
            [self.navigationController pushViewController:sendViewController animated:YES];
            sendViewController.block = ^(NSString* string) {
                NSDictionary *dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
                NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
                insideDict[@"msg_icon"] = dict[@"Friend_Icon"];
                insideDict[@"msg_note"] = dict[@"Friend_Name"];
                insideDict[@"reqInfo"] = string;
                [[GYHDSDK sharedInstance] addFriendWithFriendID:[NSString stringWithFormat:@"m_c_%@",weakSelf.userModel.custID] content:[GYUtils dictionaryToString:insideDict] verify:string];
                [GYHDSDK sharedInstance].receiveMsgBlock = ^(PBGeneratedMessage *message) {
                    if ([message isKindOfClass:[AddFriendRsp class]]) {
                        AddFriendRsp *rsp = (AddFriendRsp *)message;
                        NSString *tips = nil;
                        switch (rsp.resultCode) {
                            case ResultCodeNoError:
                            {
                               tips = [GYUtils localizedStringWithKey:@"GYHD_Friend_To_Apply_For_success"];
                                break;
                            }
                                case ResultCodeErrorFriendAlreadyExist:
                            {
                                tips = @"好友已经存在";
                                break;
                            }
                            case ResultCodeErrorFriendCannotAddYourself:
                            {
                                tips = @"不可以自己加自己为好友";
                                break;
                            }
                            case ResultCodeErrorFriendRquToomuch:
                            {
                                tips = @"超过请求添加好友次数";
                                break;
                            }
                            case ResultCodeErrorFriendStranger:
                            {
                                tips = @"陌生人,非好友关系";
                                break;
                            }
                            case ResultCodeErrorFriendIToomuchFriends:
                            {
                                tips = @"您的好友数量已达上限";
                                break;
                            }
                            case ResultCodeErrorFriendUToomuchFriends:
                            {
                                tips = @"对方好友数量已达上限";
                                [button setTitle: @"等待验证" forState:UIControlStateNormal];
                                break;
                            }
                            case ResultCodeErrorFriendTeamToomuch:
                            {
                                tips = @"好友分组已达上限";
                                break;
                            }
                            case ResultCodeErrorFriendTeamAlreadyExsit:
                            {
                                tips = @"好友分组已存在";
                                break;
                            }

                            default:
                                break;
                        }
                        [GYUtils showToast:tips duration:1.0 position:CSToastPositionCenter];
                    }
                };
 
            };
        }
//         = 301,
//         = 302,
//         = 303,
//         = 304,
//         = 305,
//         = 306,
//         = 307,
//         = 308,

//     GYHDSearchUserDetailViewController

    }
    else { // 关注企业

        NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
        sendDict[@"vShopId"] = self.userModel.vshopID;
        sendDict[@"key"] =  globalData.loginModel.token ;
        sendDict[@"shopId"] = self.userModel.vshopID;
        sendDict[@"shopName"] = self.userModel.nameString ;
        
        [[GYHDMessageCenter sharedInstance] ConcernShopUrlWithDict:sendDict RequetResult:^(NSDictionary *resultDict) {
            NSLog(@"%@",resultDict);
            if ([resultDict[@"retCode"] integerValue] == 200) {
                button.userInteractionEnabled = NO;
                [button setTitle: [GYUtils localizedStringWithKey:@"GYHD_user_already_attentionCompany" ]forState:UIControlStateNormal];
            }
        }];
        
    }
}

@end

//    {// 添加好友
//        NSString *string = [NSString stringWithFormat:@"m_%@",self.userModel.custID];
//
//
//        NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
//        insideDict[@"accountId"] = globalData.loginModel.custId;
//        insideDict[@"accountNickname"] = globalData.loginModel.nickName;
//        insideDict[@"accountHeadPic"] = globalData.loginModel.headPic;
//        insideDict[@"req_info"] =@"xxxx";
//        insideDict[@"friendId"] =self.userModel.custID;
//        insideDict[@"friendNickname"] =self.userModel.nameString;
//        insideDict[@"friendStatus"] = @"1";
//        insideDict[@"friendHeadPic"] = self.userModel.iconString;
//
//        [[GYHDMessageCenter sharedInstance] addFriendWithFriendID:string verify:[GYUtils dictionaryToString:insideDict]];
//    }
//            data.put("msg_icon", userInfo.getHeadPic());
//            data.put("msg_note", userInfo.getNickName());
//            data.put("sex", userInfo.getSex());
//            data.put("reqInfo", mAddTip.getText().toString());
//            data.put("msg_subject", userInfo.getNickName() + "请求添加你为好友");
//            data.put("msgContent", mAddTip.getText().toString());

//            [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary *resultDict) {
//                UIWindow *wind =  [UIApplication sharedApplication].windows.lastObject;
//                if ([resultDict[@"retCode"] isEqualToString:@"200"]) {
////                    model.addUserStatus = 1;
////                    [weakSelf.searchFriendTableView reloadData];
//                    [wind makeToast:[GYUtils localizedStringWithKey:@"GYHD_Friend_Application_is_successful"] duration:1.0 position:CSToastPositionCenter];
//                }else {
//
//                    [wind makeToast:resultDict[@"message"] duration:1.0 position:CSToastPositionCenter];
//                }
//
//            }];
//    NSMutableDictionary* sendDict  = [[NSMutableDictionary alloc] init];
//
//    if(![GYUtils checkStringInvalid:shopInfo.strVshopId]) {
//        [sendDict setValue:[NSString stringWithFormat:@"%@", shopInfo.strVshopId] forKey:@"vShopId"];
//        [dict setValue:globalData.loginModel.token forKey:@"key"];
//        [dict setValue:shopInfo.strShopId forKey:@"shopId"];
//        [dict setValue:shopInfo.strVshopId forKey:@"vShopId"];
//        //add by zhangqy 店名最长显示30字
//        [dict setValue:shopInfo.strShopName forKey:@"shopName"];
//    }