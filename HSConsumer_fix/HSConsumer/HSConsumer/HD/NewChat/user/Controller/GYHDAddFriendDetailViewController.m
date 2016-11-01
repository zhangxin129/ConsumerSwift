//
//  GYHDAddFriendDetailViewController.m
//  HSConsumer
//
//  Created by shiang on 16/4/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddFriendDetailViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDAddFriendDetailModel.h"
#import "GYHDAddFriendDetailCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface GYHDAddFriendDetailViewController () <UITableViewDataSource, UITableViewDelegate>
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
@end

@implementation GYHDAddFriendDetailViewController

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
    [sendButton setTitle:[GYUtils localizedStringWithKey:@"GYHD_Friend_add_Friend"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send-btn_normal"] forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"gyhd_send_btn_Highlighted"] forState:UIControlStateHighlighted];
    sendButton.frame = CGRectMake(12, 12, kScreenWidth - 24, 66 - 24);
    [footerView addSubview:sendButton];

    UITableView* friendDetalTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    friendDetalTableView.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    friendDetalTableView.delegate = self;
    friendDetalTableView.dataSource = self;
    [friendDetalTableView registerClass:[GYHDAddFriendDetailCell class] forCellReuseIdentifier:@"GYHDAddFriendDetailCellID"];
    friendDetalTableView.tableHeaderView = headerView;
    if (!self.hidenSendButton) {
        friendDetalTableView.tableFooterView = footerView;
    }else {
        friendDetalTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }

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

    if (![_bodyDict[@"userType"] integerValue]) {
        self.friendHushengLabel.hidden = YES;
    }
}

- (void)sendButtonClick
{
    if (self.block) {
        self.block(self);
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendDetailArrayM.count;
    ;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDAddFriendDetailModel* model = self.friendDetailArrayM[indexPath.row];
    GYHDAddFriendDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDAddFriendDetailCellID"];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDAddFriendDetailModel* model = self.friendDetailArrayM[indexPath.row];
    return [tableView fd_heightForCellWithIdentifier:@"GYHDAddFriendDetailCellID" configuration:^(GYHDAddFriendDetailCell* cell) {

       cell.model = model;
    }];
}

- (void)setBodyDict:(NSDictionary*)bodyDict
{
    _bodyDict = bodyDict;
    NSMutableArray* array = [NSMutableArray array];
    GYHDAddFriendDetailModel* addressModel = [[GYHDAddFriendDetailModel alloc] init];
    addressModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_Friend_address"];
    addressModel.infoDetail = bodyDict[@"area"];
    [array addObject:addressModel];
    GYHDAddFriendDetailModel* hobbyModel = [[GYHDAddFriendDetailModel alloc] init];
    hobbyModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_hobby"];
    hobbyModel.infoDetail = bodyDict[@"hobby"];
    [array addObject:hobbyModel];
    GYHDAddFriendDetailModel* signModel = [[GYHDAddFriendDetailModel alloc] init];
    signModel.infoName = [GYUtils localizedStringWithKey:@"GYHD_sign"];
    signModel.infoDetail = bodyDict[@"sign"];
    [array addObject:signModel];
    self.friendDetailArrayM = array;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.bodyDict[@"headImage"] hasPrefix:@"http"]) {
        [self.friendIconImageView setImageWithURL:[NSURL URLWithString:self.bodyDict[@"headImage"]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }
    else {
        NSString* imageURl = [NSString stringWithFormat:@"%@%@", globalData.loginModel.picUrl, self.bodyDict[@"headImage"]];
        [self.friendIconImageView setImageWithURL:[NSURL URLWithString:imageURl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }

    self.friendNameLabel.text = self.bodyDict[@"nickName"];
    ;
    self.friendHushengLabel.text = [NSString stringWithFormat:@"%@:%@",[GYUtils localizedStringWithKey:@"GYHD_hushengCard"], [[GYHDMessageCenter sharedInstance] segmentationHuShengCardWithCard:self.bodyDict[@"resNo"]]];
    UIImage* sexImgae = nil;
    if ([self.bodyDict[@"sex"] isEqualToString:@"1"]) {
        sexImgae = [UIImage imageNamed:@"gyhd_man_icon"];
    }
    else {
        sexImgae = [UIImage imageNamed:@"gyhd_girl_icon"];
    }
    self.sexImageView.image = sexImgae;

    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
    attDict[NSForegroundColorAttributeName] = kNavigationBarColor;
    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
- (void)ignoreClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];

//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}

@end
