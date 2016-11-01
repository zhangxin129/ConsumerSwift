//
//  GYHDDingDanListViewController.m
//  HSConsumer
//
//  Created by shiang on 16/1/15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMessageListViewController.h"
#import "GYHDMessageListCell.h"
#import "GYHDMessageListModel.h"
#import "GYHDMessageCenter.h"
#import "GYOrderDetailsViewController.h"
#import "GYEPOrderDetailViewController.h"
#import "GYHDHSPlatformViewController.h"
#import "GYHDBindHSViewController.h"
#import "GYHDHuShengMessageDetailViewController.h"

#import "GYHDApplicantListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface GYHDMessageListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray* messageListArrayM;
@property (nonatomic, weak) UITableView* DingDanListView;
@end

@implementation GYHDMessageListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView* DingDanListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.automaticallyAdjustsScrollViewInsets = NO;
    DingDanListView.delegate = self;
    DingDanListView.dataSource = self;
    [DingDanListView registerClass:[GYHDMessageListCell class] forCellReuseIdentifier:@"GYHDMessageListCellID"];
    [DingDanListView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:DingDanListView];
    _DingDanListView = DingDanListView;
    WS(weakSelf);
    [DingDanListView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.bottom.top.right.equalTo(weakSelf.view);

    }];
    [self messageCenterDataBaseChagne:nil];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[GYHDMessageCenter sharedInstance] addDataBaseChangeNotificationObserver:self selector:@selector(messageCenterDataBaseChagne:)];
}
//- (void)ignoreClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[GYHDMessageCenter sharedInstance] ClearUnreadMessageWithCard:self.messageCard];
    [[GYHDMessageCenter sharedInstance] removeDataBaseChangeNotificationWithObserver:self];
}

- (void)messageCenterDataBaseChagne:(NSNotification*)noti
{
    //    NSLog(@"bbb == %@",noti.object);
}

/**上拉刷新*/
- (void)setupRefresh
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf loadData];
        [weakSelf.DingDanListView.mj_footer endRefreshing];
    }];

    self.DingDanListView.mj_footer = footer;
    [self.DingDanListView.mj_footer beginRefreshing];
}

- (void)loadData
{
    NSMutableArray* messageListArrayM = [NSMutableArray array];
    //    NSArray *array = [[GYHDMessageCenter sharedInstance] selectAllMessageListWithMessageCard:self.messageCard];
    NSArray* array = [[GYHDMessageCenter sharedInstance] selectPushWithMessageCode:self.messageCard from:self.messageListArrayM.count to:20];
    for (NSDictionary* dingdanDict in array) {
        GYHDMessageListModel* dingdanModel = [GYHDMessageListModel dingDanModelWithDictionary:dingdanDict];
        [messageListArrayM addObject:dingdanModel];
    }
    NSMutableArray* fristArray = [NSMutableArray arrayWithArray:self.messageListArrayM];
    [fristArray addObjectsFromArray:messageListArrayM];
    self.messageListArrayM = fristArray;
    [self.DingDanListView reloadData];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageListArrayM.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDMessageListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDMessageListCellID"];
    cell.dingDanModel = self.messageListArrayM[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    WS(weakSelf)
    return [tableView fd_heightForCellWithIdentifier:@"GYHDMessageListCellID" configuration:^(GYHDMessageListCell* cell) {
        GYHDMessageListModel *dingdanModel = weakSelf.messageListArrayM[indexPath.row];
        cell.dingDanModel = dingdanModel;
    }];
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self pushNextViewControllerWithIndexPath:indexPath];
}

/**
 * 跳转到下个一控制器
 */
- (void)pushNextViewControllerWithIndexPath:(NSIndexPath*)indexPath
{
    GYHDMessageListModel* messageModel = self.messageListArrayM[indexPath.row];

    NSDictionary* contentDict = [GYUtils stringToDictionary:messageModel.messageBody];
    UIViewController* pushNextViewController = nil;
    if (messageModel.messageCode == GYHDProtobufMessage02001 || messageModel.messageCode == GYHDProtobufMessage02002 || messageModel.messageCode == GYHDProtobufMessage02003 || messageModel.messageCode == GYHDProtobufMessage02004 || messageModel.messageCode == GYHDProtobufMessage02005 || messageModel.messageCode == GYHDProtobufMessage02006 || messageModel.messageCode == GYHDProtobufMessage02007 || messageModel.messageCode == GYHDProtobufMessage02008) {
        GYEPOrderDetailViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
        vc.orderID = contentDict[@"orderId"];
        vc.dicDataSource = nil;
        vc.navigationItem.title = kLocalized(@"GYHD_order_detail");
        pushNextViewController = vc;
    }
    else if (messageModel.messageCode == GYHDProtobufMessage02021 || messageModel.messageCode == GYHDProtobufMessage02022 || messageModel.messageCode == GYHDProtobufMessage02023 || messageModel.messageCode == GYHDProtobufMessage02024 || messageModel.messageCode == GYHDProtobufMessage02025 || messageModel.messageCode == GYHDProtobufMessage02026 || messageModel.messageCode == GYHDProtobufMessage02027 || messageModel.messageCode == GYHDProtobufMessage02028 || messageModel.messageCode == GYHDProtobufMessage02029) {
        GYOrderDetailsViewController* orderDetail = kLoadVcFromClassStringName(NSStringFromClass([GYOrderDetailsViewController class]));
        orderDetail.orderId = contentDict[@"orderId"];
        orderDetail.moderType = contentDict[@"msg_repast_type"];
        pushNextViewController = orderDetail;
    }
    else if (messageModel.messageCode == GYHDProtobufMessage01001 || messageModel.messageCode == GYHDProtobufMessage01002) {
        NSDictionary* subContDict = [GYUtils stringToDictionary:contentDict[@"msg_content"]];
        GYHDHSPlatformViewController* hsplatFormViewController = [[GYHDHSPlatformViewController alloc] init];
        hsplatFormViewController.urlString = subContDict[@"pageUrl"];
        pushNextViewController = hsplatFormViewController;
    }
    else if (messageModel.messageCode == GYHDProtobufMessage01009) {
        GYHDBindHSViewController* bindHSViewController = [[GYHDBindHSViewController alloc] init];
        bindHSViewController.messageBody = messageModel.messageBody;
        bindHSViewController.messageID = messageModel.messageID;
        pushNextViewController = bindHSViewController;
    }
    [self.navigationController pushViewController:pushNextViewController animated:YES];
}

@end

//    switch (messageModel.submessgeCode.integerValue) {
//        case GYHDDataBaseCenterPush1010201:
//        {
//            GYHDBindHSViewController *bindHSViewController = [[GYHDBindHSViewController alloc] init];
//            bindHSViewController.messageBody = messageModel.messageListMessageBody;
//            pushNextViewController = bindHSViewController;
//
//            break;
//        }
//        case GYHDDataBaseCenterPush10101:
//        {
//            GYHDHSPlatformViewController *hsplatFormViewController = [[ GYHDHSPlatformViewController alloc] init];
//            hsplatFormViewController.urlString = messageModel.pageUrl;
//            pushNextViewController = hsplatFormViewController;
//            break;
//        }
//        case GYHDDataBaseCenterPush1010208:
//        case GYHDDataBaseCenterPush1010209:
//        case GYHDDataBaseCenterPush1010210:
//        case GYHDDataBaseCenterPush1010211:
//        {
//            GYHDHuShengMessageDetailViewController *hsmessageDetailViewController = [[GYHDHuShengMessageDetailViewController alloc] init];
//            hsmessageDetailViewController.messageBody = messageModel.messageListMessageBody;
//            pushNextViewController = hsmessageDetailViewController;
//            break;
//        }
//        case GYHDProtobufMessage02001:
//        case GYHDDataBaseCenterPush1010215:
//        case GYHDDataBaseCenterPush1010216:
//        case GYHDDataBaseCenterPush1010217:
//        case GYHDDataBaseCenterPush1010218:
//        case GYHDDataBaseCenterPush1010219:
//        case GYHDDataBaseCenterPush1010220:
//        case GYHDDataBaseCenterPush1010221:
//        case GYHDDataBaseCenterPush1010222:
//        {
//            GYOrderDetailsViewController *orderDetail = kLoadVcFromClassStringName(NSStringFromClass([GYOrderDetailsViewController class]));
//            orderDetail.orderId = messageModel.orderId;
//            orderDetail.moderType= messageModel.moderType;
//            pushNextViewController = orderDetail;
//            break;
//        }
//        case GYHDDataBaseCenterPush1010202:
//        case GYHDDataBaseCenterPush1010203:
//        case GYHDDataBaseCenterPush1010204:
//        case GYHDDataBaseCenterPush1010205:
//        case GYHDDataBaseCenterPush1010206:
//        case GYHDDataBaseCenterPush1010207:
//        case GYHDDataBaseCenterPush1010212:
//        case GYHDDataBaseCenterPush1010213:
//        {

//            break;
//        }
//        default:
//            break;
//    }
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

//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];