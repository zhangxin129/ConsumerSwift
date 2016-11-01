//
//  GYHDAddFriendViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddFriendViewController.h"
#import "GYHDAddFriendCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDAddFriendModel.h"

#import "GYHDSendAddFriendViewController.h"
#import "GYHDAddFriendDetailViewController.h"
#import "GYHDApplicantDetailViewController.h"
#import "GYHDApplicantListModel.h"
//#import "GYHDSelectAddFriendCell.h"
//#import "GYHDChooseAddressViewController.h"

@interface GYHDAddFriendViewController () <UITableViewDataSource, UITableViewDelegate, GYHDAddFriendCellDelegate>
/**搜索好友tableview*/
@property (nonatomic, weak) UITableView* searchFriendTableView;
/**搜索好友数组*/
@property (nonatomic, strong) NSMutableArray* searchFriendArray;
/**搜索统计*/
@property (nonatomic, assign) NSInteger searchCount;

@property(nonatomic ,strong)UIView *zeroView;
@end

@implementation GYHDAddFriendViewController

- (NSMutableArray*)searchFriendArray
{
    if (!_searchFriendArray) {
        _searchFriendArray = [NSMutableArray array];
    }
    return _searchFriendArray;
}
-(void)createZeroView {
    self.zeroView = [[UIView alloc] init];
    self.zeroView.backgroundColor = [UIColor colorWithRed:244 / 255.0f green:245 / 255.0f blue:246 / 255.0f alpha:1];
    [self.view addSubview: self.zeroView];
    
    UIImageView *zeroImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_zero_search"]];
    [self.zeroView addSubview:zeroImageView];
    
    UILabel *zeroLabel = [[UILabel alloc] init];
    zeroLabel.font = [UIFont systemFontOfSize:16.0f];
    zeroLabel.text = [GYUtils localizedStringWithKey:@"GYHD_Friend_zero_search"];
    zeroLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.zeroView addSubview:zeroLabel];
    
    WS(weakSelf);
    [self.zeroView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    [zeroImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(85);
        make.centerX.mas_equalTo(weakSelf.zeroView);
    }];
    
    [zeroLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zeroImageView.mas_bottom).offset(20);
        make.centerX.mas_equalTo(weakSelf.zeroView);
    }];
//    self.zeroView.hidden = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    [self createZeroView];

    //1.
    //    UIButton *backtrackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [backtrackButton addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [backtrackButton setTitleColor:[UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1] forState:UIControlStateNormal];
    //    backtrackButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    backtrackButton.frame = CGRectMake(0, 0, 80, 44);
    //    [backtrackButton setImage:kLoadPng(@"gyhd_nav_leftView_back") forState:UIControlStateNormal];
    ////    [backtrackButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_user_addfriedn_friend"] forState:UIControlStateNormal];
    //    backtrackButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backtrackButton];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Friend_SearchResult"];
    UITableView* searchFriendTableView = [[UITableView alloc] init];
    searchFriendTableView.dataSource = self;
    searchFriendTableView.delegate = self;
    [searchFriendTableView registerClass:[GYHDAddFriendCell class] forCellReuseIdentifier:@"GYHDSelectAddFriendCellID"];
    searchFriendTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:searchFriendTableView];
    _searchFriendTableView = searchFriendTableView;
    [searchFriendTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    self.searchFriendArray = [NSMutableArray array];
    self.searchCount = 0 ;
    [self setupRefresh];
}

- (void)backClick:(UIButton*)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**下拉刷新*/
- (void)setupRefresh
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadAddFriendFromNetWork];

    }];

    self.searchFriendTableView.mj_footer = footer;
    [self.searchFriendTableView.mj_footer beginRefreshing];
}

- (void)loadAddFriendFromNetWork
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];

    dict[@"keyword"] = self.searchDict[@"husheng"];
    if ([self.searchDict[@"age"] isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_any"]]) {
        dict[@"ageScope"] = @"";
    }
    else {
        NSString* ageString = self.searchDict[@"age"];
        NSMutableString* newAgeString = [NSMutableString string];
        NSString* pattern = @"\\d+";
        NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        // 2.测试字符串
        NSArray* results = [regex matchesInString:ageString options:0 range:NSMakeRange(0, ageString.length)];
        // 3.遍历结果
        for (NSTextCheckingResult* result in results) {
            [newAgeString appendFormat:@"%@,", [ageString substringWithRange:result.range]];
        }
        if (newAgeString.length > 1) {
            [newAgeString deleteCharactersInRange:NSMakeRange(newAgeString.length - 1, 1)];
            if (newAgeString.length < 3) {
                if (newAgeString.integerValue <= 18) {
                    newAgeString = [NSMutableString stringWithFormat:@"*,%ld", newAgeString.integerValue - 1];
                }
                else if (newAgeString.integerValue >= 46) {
                    newAgeString = [NSMutableString stringWithFormat:@"%ld,*", newAgeString.integerValue + 1];
                }
            }
        }
        dict[@"ageScope"] = newAgeString;
    }
    if ([self.searchDict[@"address"] isEqualToString: [GYUtils localizedStringWithKey:@"GYHD_any"]]) {
        dict[@"province"] = @"";
        dict[@"city"] = @"";
    }
    else {
        dict[@"province"] = self.searchDict[@"province"];
        dict[@"city"] = self.searchDict[@"city"];
    }
    if ([self.searchDict[@"sex"] isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Man"]]) {
        dict[@"sex"] = @"1";
    }
    else if ([self.searchDict[@"sex"] isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Woman"]]) {
        dict[@"sex"] = @"0";
    }

    NSString* page = [NSString stringWithFormat:@"%ld", ++_searchCount];
    WS(weakSelf)
        [[GYHDMessageCenter sharedInstance] searchFriendWithDict:dict Page:page RequetResult:^(NSDictionary* resultDict) {
        if ([resultDict[@"retCode"] integerValue] == 200) {
            NSMutableArray *searchArray = [NSMutableArray array];
            NSMutableArray *resuArray = resultDict[@"rows"];
            for (NSDictionary *childDict in resuArray) {
                GYHDAddFriendModel *model = [[GYHDAddFriendModel alloc] initWithDict:childDict];
                [searchArray addObject:model];
            }
            [weakSelf.searchFriendArray addObjectsFromArray:searchArray];
            [weakSelf.searchFriendTableView reloadData];
            if (!weakSelf.searchFriendArray.count) {
                [self.view bringSubviewToFront:self.zeroView];
//                NSString *title = nil;
//                if (weakSelf.searchFriendArray.count) {
//                    title = @"已经全部加载完毕！";
//                }else {
//                    title = @"对不起 , 查不到该好友";
//                }
//                weakSelf.searchFriendTableView.mj_footer.hidden = YES;
//                [GYUtils showToast:title duration:1 position:CSToastPositionBottom];
//                UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
//                [GYUtils showToast:title duration:1.0f position:CSToastPositionBottom];
            }
        }
        [weakSelf.searchFriendTableView.mj_footer endRefreshing];
        }];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchFriendArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDAddFriendModel* model = self.searchFriendArray[indexPath.row];

    GYHDAddFriendCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDSelectAddFriendCellID"];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 68.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHDAddFriendModel* model = self.searchFriendArray[indexPath.row];
    if (model.addUserStatus == -1) {
        
        NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
        NSString *fromdID = nil;
        if ([model.addfriendID  hasPrefix:@"nc_"]) {
            fromdID = [model.addfriendID  substringFromIndex:3];
        }else if ([model.addfriendID  hasPrefix:@"c_"]){
            fromdID = [model.addfriendID substringFromIndex:2];
        }else {
            fromdID = model.addfriendID ;
        }
        selectDict[@"PUSH_MSG_FromID"] = fromdID;
        selectDict[@"PUSH_MSG_Code"] = @"4101";
        NSDictionary *reDict =  [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName].lastObject;
 
        GYHDApplicantListModel *listModel = nil;
        if (reDict) {
             listModel = [[GYHDApplicantListModel alloc] initWithDict:reDict];
        
        }else {
            listModel = [[GYHDApplicantListModel alloc] init];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            
            dict[@"msg_icon"] = model.addHeadImageUrlString;
            dict[@"msg_note"] = model.addNikeNameString;
            dict[@"fromId"] = model.addfriendID;
            dict[@"req_info"] = model.addExtraMessage;
            listModel.applicantBody = [GYUtils dictionaryToString:dict];
        }
        GYHDApplicantDetailViewController *detailViewController = [[GYHDApplicantDetailViewController alloc] init];
        detailViewController.model = listModel;
        
        [self.navigationController pushViewController:detailViewController animated:YES];
    }else {
        GYHDAddFriendDetailViewController* friendDetailViewController = [[GYHDAddFriendDetailViewController alloc] init];
        friendDetailViewController.bodyDict = model.addDobyDict;
        if (!model.addUserStatus) {
            friendDetailViewController.hidenSendButton = NO;
        }
        else {
            friendDetailViewController.hidenSendButton = YES;
        }
        WS(weakSelf);
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:friendDetailViewController];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
        friendDetailViewController.block = ^(UIViewController* viewController) {
            [viewController dismissViewControllerAnimated:YES completion:^{
                [weakSelf GYHDAddFriendCell:nil model:model];
            }];
            
        };
    }
}

- (void)GYHDAddFriendCell:(GYHDAddFriendCell*)cell model:(GYHDAddFriendModel*)model
{
    WS(weakSelf);
    if (model.addUserStatus) {
        
        
        NSDictionary* dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
        NSMutableDictionary* insideDict = [NSMutableDictionary dictionary];
        insideDict[@"accountId"] = dict[@"Friend_ID"];
        insideDict[@"accountNickname"] = dict[@"Friend_Name"];
        insideDict[@"accountHeadPic"] = dict[@"Friend_Icon"];
        insideDict[@"req_info"] = @"11";
        insideDict[@"friendId"] = model.addfriendID;
        insideDict[@"friendNickname"] =  model.addNikeNameString;
        insideDict[@"friendStatus"] = @"2";
        insideDict[@"friendHeadPic"] = model.addHeadImageUrlString;
        [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary* resultDict) {
//            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if ([resultDict[@"retCode"] isEqualToString:@"200"]  ||
                [resultDict[@"retCode"] isEqualToString:@"501"]  ||
                [resultDict[@"retCode"] isEqualToString:@"810"]  ||
                [resultDict[@"retCode"] isEqualToString:@"811"]  ) {
                if ([resultDict[@"retCode"] isEqualToString:@"200"]  ||
                    [resultDict[@"retCode"] isEqualToString:@"501"]) {
//                    [GYUtils showToast:[resultDict[@"retCode"] isEqualToString:@"501"] ? [GYUtils localizedStringWithKey:@"GYHD_Friend_add_already"] :[GYUtils localizedStringWithKey:@"GYHD_Friend_add_success"] duration:1.0f position:CSToastPositionCenter];
                                   [GYUtils showToast:[resultDict[@"retCode"] isEqualToString:@"501"] ? [GYUtils localizedStringWithKey:@"GYHD_Friend_add_already"] :[GYUtils localizedStringWithKey:@"GYHD_Friend_add_success"] duration:1.0f position:CSToastPositionCenter];
                }else {
                    [GYUtils showToast:resultDict[@"message"] duration:1.0f position:CSToastPositionCenter];
                    
                }
      
                model.addUserStatus = 2;
                [weakSelf.searchFriendTableView reloadData];
                NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
                
                NSString *fromdID = nil;
                if ([model.addfriendID  hasPrefix:@"nc_"]) {
                    fromdID = [model.addfriendID  substringFromIndex:3];
                }else if ([model.addfriendID  hasPrefix:@"c_"]){
                    fromdID = [model.addfriendID substringFromIndex:2];
                }else {
                    fromdID = model.addfriendID ;
                }
                selectDict[@"PUSH_MSG_FromID"] = fromdID;
   
                selectDict[@"PUSH_MSG_Code"] = @"4101";
               NSDictionary *reDict =  [[GYHDMessageCenter sharedInstance] selectInfoEqualDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName].lastObject;
                
                NSMutableDictionary *bodyDict = [NSMutableDictionary dictionaryWithDictionary:[GYUtils stringToDictionary:reDict[@"PUSH_MSG_Body"]]];
                bodyDict[@"status"] = resultDict[@"retCode"];
                NSMutableDictionary *updateDict = [NSMutableDictionary dictionary];
                updateDict[GYHDDataBaseCenterPushMessageBody] = [GYUtils dictionaryToString:bodyDict];
                NSMutableDictionary *condDict = [NSMutableDictionary dictionary];
                condDict[GYHDDataBaseCenterPushMessageID] = reDict[@"PUSH_MSG_ID"];
                

                [[GYHDMessageCenter sharedInstance] updateInfoWithDict:updateDict conditionDict:condDict TableName:GYHDDataBaseCenterPushMessageTableName];
                NSMutableDictionary *frienddeletedict = [NSMutableDictionary dictionary];
                frienddeletedict[@"friendChange"] = @(100);
                frienddeletedict[@"toID"] =  updateDict[@"friendId"];
                [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotificationWithDict:frienddeletedict];
            }else {
                
//                if ([resultDict[@"retCode"] isEqualToString:@"810"] ||
//                    [resultDict[@"retCode"] isEqualToString:@"811"]) {
//                    NSMutableDictionary *selectDict = [NSMutableDictionary dictionary];
//                    if (globalData.loginModel.cardHolder) {
//                        selectDict[@"PUSH_MSG_FromID"] = [model.addfriendID substringFromIndex:2];
//                    }else {
//                        selectDict[@"PUSH_MSG_FromID"] = [model.addfriendID substringFromIndex:3];
//                    }
                
//                    selectDict[@"PUSH_MSG_Code"] = @"4101";
//                    [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName];
//                }
                [GYUtils showToast:resultDict[@"message"] duration:1.0f position:CSToastPositionCenter];
            }
        }];
        
    }else {
        GYHDSendAddFriendViewController* sendViewController = [[GYHDSendAddFriendViewController alloc] init];
        
 
        
        [self.navigationController pushViewController:sendViewController animated:YES];
        sendViewController.block = ^(NSString* string) {
            NSDictionary *dict = [[GYHDMessageCenter sharedInstance] selectMyInfo];
            NSMutableDictionary *insideDict = [NSMutableDictionary dictionary];
            insideDict[@"accountId"] =  dict[@"Friend_ID"];
            insideDict[@"accountNickname"] = dict[@"Friend_Name"];
            insideDict[@"accountHeadPic"] = dict[@"Friend_Icon"];
            insideDict[@"req_info"] = string;
            insideDict[@"friendId"] = model.addfriendID;
            insideDict[@"friendNickname"] = model.addNikeNameString;
            insideDict[@"friendStatus"] = @"1";
            insideDict[@"friendHeadPic"] = model.addHeadImageUrlString;
            [[GYHDMessageCenter sharedInstance] deleteFriendWithDict:insideDict RequetResult:^(NSDictionary *resultDict) {
                UIWindow *wind =  [UIApplication sharedApplication].windows.lastObject;
                if ([resultDict[@"retCode"] isEqualToString:@"200"]) {
                    model.addUserStatus = 1;
                    [weakSelf.searchFriendTableView reloadData];
                    [wind makeToast:[GYUtils localizedStringWithKey:@"GYHD_Friend_Application_is_successful"] duration:1.0 position:CSToastPositionCenter];
                }else {
                    
                    [wind makeToast:resultDict[@"message"] duration:1.0 position:CSToastPositionCenter];
                }
                
            }];
            
        };
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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
}
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

//- (void)GYHDSendAddFriendViewController:(GYHDSendAddFriendViewController *)ViewController SendText:(NSString *)sendText {
//    [ViewController dismissViewControllerAnimated:YES completion:^{
//        NSLog(@"数据%@",sendText);
//
//
//    NSLog(@"%@",model.);
//
//    }];
//}

@end

