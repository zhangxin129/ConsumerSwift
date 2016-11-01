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
#import "GYHDChatViewController.h"
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

@property (nonatomic,strong)UILabel* markLabel;//标签

@property (nonatomic,strong)UILabel* remarkLabel;//备注

/**好友model*/
@property (nonatomic, weak) UIView* footView;
@property (nonatomic, weak) UIImageView* sexImageView;
@property (nonatomic, weak) UIButton* sendButton;
/**个人资料dict*/
@property (nonatomic, strong) NSMutableDictionary* infoDict;
@end

@implementation GYHDFriendApplicationViewController

-(NSMutableArray *)friendDetailArrayM{

    if (!_friendDetailArrayM) {
        
        _friendDetailArrayM=[NSMutableArray array];
    }
    return _friendDetailArrayM;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Friend_Info"];
    UIView* headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    headerView.frame = CGRectMake(0, 0, kScreenWidth, 106+20+88);

    UIView* chilidView = [[UIView alloc] init];

    [headerView addSubview:chilidView];
    chilidView.frame = CGRectMake(0, 20, kScreenWidth, 66);
    chilidView.backgroundColor = [UIColor whiteColor];

    //1. 头像
    UIImageView* friendIconImageView = [[UIImageView alloc] init];
    friendIconImageView.layer.masksToBounds = YES;
    friendIconImageView.layer.cornerRadius = 3.0f;
    
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
    
    UIView*markView= [[UIView alloc] init];
    [headerView addSubview:markView];
    markView.frame = CGRectMake(0, 106, kScreenWidth, 88);
    markView.backgroundColor = [UIColor whiteColor];
    
   //标签
    self.markLabel=[[UILabel alloc]init];
    self.markLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    self.markLabel.text= [GYUtils localizedStringWithKey:@"GYHD_Mark"];
    [markView addSubview:self.markLabel];
    
    UIView*lineView=[[UIView alloc]init];
    
    lineView.backgroundColor=[UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    
    [markView addSubview:lineView];
    
   //备注
    self.remarkLabel=[[UILabel alloc]init];
    self.remarkLabel.font = [UIFont systemFontOfSize:KFontSizePX(32.0f)];
    self.remarkLabel.text= [GYUtils localizedStringWithKey:@"GYHD_remarks"];
    [markView addSubview:self.remarkLabel];
    
    UIImageView*arrowImageView=[[UIImageView alloc]init];
    arrowImageView.image=[UIImage imageNamed:@"gyhd_cell_arrow_right_icon"];
    [markView addSubview:arrowImageView];
    
    UIImageView* sexImageView = [[UIImageView alloc] init];
    [chilidView addSubview:sexImageView];
    _sexImageView = sexImageView;

 

    UITableView* friendDetalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    friendDetalTableView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    friendDetalTableView.delegate = self;
    friendDetalTableView.dataSource = self;
    friendDetalTableView.tableHeaderView = headerView;
//    friendDetalTableView.tableFooterView = footerView;
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
    
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(12);
        make.right.equalTo(arrowImageView.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.markLabel.mas_bottom).offset(0);
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(lineView.mas_bottom).offset(0);
        make.left.mas_equalTo(12);
        make.right.equalTo(arrowImageView.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    
    [self  loadFriendInfoData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
}

#pragma mark- 加载好友数据
-(void)loadFriendInfoData{

    
    NSMutableArray *oneArray = [NSMutableArray array];
    GYHDFriendApplicationModel* markModel = [[GYHDFriendApplicationModel alloc] init];
    markModel.infoName = @"标签";
    markModel.infoDetail = @" ";
    [oneArray addObject:markModel];
    
    GYHDFriendApplicationModel *remarksModel = [[GYHDFriendApplicationModel alloc] init];
    remarksModel.infoName = @"备注";
    remarksModel.infoDetail = @" ";
    [oneArray addObject: remarksModel];
    
    
    NSMutableArray* twoArray = [NSMutableArray array];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[GYHDDataBaseCenterFriendCustID] = self.FriendCustID;
    NSArray* infoArray = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:dict TableName:GYHDDataBaseCenterFriendTableName];
    self.infoDict = [NSMutableDictionary dictionaryWithDictionary:infoArray.lastObject];
    NSDictionary* boydDict = [GYUtils stringToDictionary:self.infoDict[@"Friend_Basic"]];
#warning 改版屏蔽分类
//    GYHDFriendApplicationModel* teamModel = [[GYHDFriendApplicationModel alloc] init];
//    teamModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_classification"];
//    teamModel.infoDetail = [GYUtils localizedStringWithKey:@"GYHD_Awaiting_verification"];
//    [array addObject:teamModel];
    GYHDFriendApplicationModel* addressModel = [[GYHDFriendApplicationModel alloc] init];
    
    if ([boydDict[@"city"] integerValue] > 0) {
        
        GYCityAddressModel* model = [[GYAddressData shareInstance] queryCityNo:boydDict[@"city"]];
        addressModel.infoDetail = model.cityFullName;
    }
    else {
        addressModel.infoDetail = @"";
    }
    addressModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_Friend_address"];
    [twoArray addObject:addressModel];
    GYHDFriendApplicationModel* hobbyModel = [[GYHDFriendApplicationModel alloc] init];
    hobbyModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_hobby"];
    hobbyModel.infoDetail = [boydDict[@"hobby"] isEqualToString:@"null"] ? @"" : boydDict[@"hobby"];
    [twoArray addObject:hobbyModel];
    GYHDFriendApplicationModel* signModel = [[GYHDFriendApplicationModel alloc] init];
    signModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_sign"];
    signModel.infoDetail = [boydDict[@"sign"] isEqualToString:@"null"] ? @"" : boydDict[@"sign"];
    [twoArray addObject:signModel];
    [self.friendDetailArrayM addObject:oneArray];
    [self.friendDetailArrayM addObject:twoArray];
//    self.friendDetailArrayM = twoArray;
    NSURL* url = [NSURL URLWithString:self.infoDict[@"Friend_Icon"]];
    [self.friendIconImageView setImageWithURL:url placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    self.friendNameLabel.text = self.infoDict[@"Friend_Name"];
    
    if ([self.infoDict[@"Friend_ID"] hasPrefix:@"nc_"]) {
        self.friendHushengLabel.hidden = YES;
    }
    self.friendHushengLabel.text = [NSString stringWithFormat:@"%@: %@",[GYUtils localizedStringWithKey:@"GYHD_hushengCard"],
                                    [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:self.infoDict[@"Friend_ResourceID"]]];
    
    NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
    selectDict[@"User_Name"] = [self.FriendCustID substringToIndex:11];
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
    
    GYHDChatViewController*vc=[[GYHDChatViewController alloc]init];
    vc.messageCard=@"060131100000000";
    [self.navigationController pushViewController:vc animated:YES];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.friendDetailArrayM.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.friendDetailArrayM[section];
    return array.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray *array = self.friendDetailArrayM[indexPath.section];
    GYHDFriendApplicationModel* model = array[indexPath.row];
    GYHDFriendApplicationCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDFriendApplicationCellID"];
    cell.model = model;
    return cell;
}



- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = nil;
    if (section) {
        UIView* footerView = [[UIView alloc] init];
        footerView.backgroundColor =[UIColor clearColor];
        footerView.frame = CGRectMake(0, 0, kScreenWidth, 66);
        UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_send_message"]forState:UIControlStateNormal];
        sendButton.layer.cornerRadius=21;
        sendButton.layer.masksToBounds=YES;
        sendButton.backgroundColor=[UIColor colorWithRed:239 / 255.0f green:66 / 255.0f blue:55 / 255.0f alpha:1];
        sendButton.frame = CGRectMake(12, 12, kScreenWidth - 24, 66 - 24);
        [footerView addSubview:sendButton];
        _sendButton = sendButton;
        view = footerView;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section) {
        return 66;
    }
    return 10;
}
@end
