//
//  GYHSToolsQueryVC.m
//
//  Created by User on 16/8/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *   工具申购查询
 *   对企业进行pos机、积分刷卡器、消费刷卡器、消费者系统资源、个性卡定制服务申购、系统缴纳年费单查询。可以查看出货情况和购买工具详细信息；对未付款订单可进行付款操作；对未确认订单进行取消订单操作；查看申购单详情。
 */
#import "GYHSToolsQueryVC.h"
#import "GYHSQueryToolListCell.h"
#import "GYHSQueryToolHeadCell.h"
#import "GYHSQueryToolMidCell.h"
#import "GYHSStoreHttpTool.h"
#import "GYHSStoreQueryListModel.h"
#import "GYHSStoreQueryDetailModel.h"
#import "GYHSStoreKVUtils.h"
#import <YYKit/NSString+YYAdd.h>
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import <YYKit/NSArray+YYAdd.h>
#import "GYPayViewController.h"
#import "GYHSToolPayModel.h"
#import "GYHSMyPayYearFeeModel.h"
#import "GYHSPublicMethod.h"
#define kPayBottomHeight 50
#define kTableMargin 16
#define kRemoveNoMessage 1233
#define kRemoveNoMessage2 1234
@interface GYHSToolsQueryVC () <UITableViewDataSource, UITableViewDelegate,GYNetworkReloadDelete>

@property (nonatomic, strong) UITableView* leftTableView;
@property (nonatomic, strong) UITableView* rightTableView;
@property (nonatomic, strong) NSMutableArray<GYHSStoreQueryListModel*>* leftModelArray;
@property (nonatomic, strong) NSArray* rightTitleArray;
@property (nonatomic, strong) NSArray* rightValueArray;
@property (nonatomic, strong) GYHSStoreQueryListModel* selectedModel;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *amountStr;
@property (nonatomic, strong) GYHSStoreOrderInfoModel *orderModel;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UIButton* cancelButton;
@property (nonatomic, strong) GYHSMyPayYearFeeModel* yearFeemodel;
@property (nonatomic, strong) UILabel* leftHeader;
@end

static NSString* qrToolListCellId = @"GYHSQueryToolListCell";
static NSString* qrToolHeadCellId = @"GYHSQueryToolHeadCell";
static NSString* qrToolMidCellId = @"GYHSQueryToolMidCell";

@implementation GYHSToolsQueryVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
    [self requestListData];
    [self requestDetailData];
    [self requestYearFee];
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate

// #pragma mark - CustomDelegate
// #pragma mark - event response
//#pragma mark - request

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_HSStore_Query_QueryToolPurchase");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createBottomView];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [self.leftTableView registerNib:[UINib nibWithNibName:NSStringFromClass(GYHSQueryToolListCell.class) bundle:nil] forCellReuseIdentifier:qrToolListCellId];
    
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass(GYHSQueryToolHeadCell.class) bundle:nil] forCellReuseIdentifier:qrToolHeadCellId];
    
    [self.rightTableView registerNib:[UINib nibWithNibName:NSStringFromClass(GYHSQueryToolMidCell.class) bundle:nil] forCellReuseIdentifier:qrToolMidCellId];
    
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    
    @weakify(self);
    
    UILabel* leftHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.leftTableView.width, 45)];
    
    leftHeader.text = kLocalized(@"GYHS_HSStore_Query_PurchaseOrder");
    leftHeader.textColor = [UIColor whiteColor];
    leftHeader.textAlignment = NSTextAlignmentCenter;
    leftHeader.font = [UIFont systemFontOfSize:21];
    leftHeader.backgroundColor = [UIColor colorWithHexString:@"#70adff"];
    
    [self.view addSubview:leftHeader];
    [leftHeader mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@45);
        make.top.mas_equalTo(kTableMargin+kNavigationHeight);
        make.left.mas_equalTo(kTableMargin);
        make.width.mas_equalTo(kDeviceProportion(360));
    }];
    self.leftHeader = leftHeader;
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.top.equalTo(leftHeader.mas_bottom);
        make.left.mas_equalTo(kTableMargin);
        make.bottom.mas_equalTo(self.footerView.mas_top);
        make.width.mas_equalTo(kDeviceProportion(360));
        
    }];
    self.page = 1;
    self.pageSize = 5;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = YES;
        self.page = 1;
        [self requestListData];
    }];
    self.leftTableView.mj_header = header;
    [self.leftTableView.mj_header beginRefreshing];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = NO;
        self.page++;
        [self.leftTableView.mj_footer resetNoMoreData];
        [self requestListData];
        
    }];
    self.leftTableView.mj_footer = footer;
    
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.left.equalTo(self.leftTableView.mas_right).offset(kTableMargin);
        make.right.mas_equalTo(-kTableMargin);
        make.bottom.equalTo(self.leftTableView);
        make.top.mas_equalTo(kTableMargin+kNavigationHeight);
        
    }];
   
}
/**
 *  创建底部按钮视图
 */
- (void)createBottomView{
    
    UIView* bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 42 - 62 - 70, kScreenWidth, 70)];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    self.footerView = bottomBackView;
    [self.view addSubview:self.footerView];
    UIButton* cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.layer.cornerRadius = 5;
    cancelButton.layer.masksToBounds = YES;
    [cancelButton setTitle:kLocalized(@"GYHS_HSStore_Query_CancelOrder") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:kGray878694];
    [cancelButton addTarget:self action:@selector(didTapCancelPay) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.footerView.mas_top).offset((70 - 33) / 2);
        make.left.equalTo(self.footerView.mas_left).offset((kScreenWidth - 290) / 2);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(33)));
    }];
    self.cancelButton = cancelButton;
    
    UIButton* payButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payButton.layer.cornerRadius = 5;
    payButton.layer.masksToBounds = YES;
    [payButton setTitle:kLocalized(@"GYHS_HSStore_Query_ToPay") forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payButton setBackgroundColor:kRedE50012];
    [payButton addTarget:self action:@selector(didTapPay) forControlEvents:UIControlEventTouchUpInside];
    [self.footerView addSubview:payButton];
    [payButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.footerView.mas_top).offset((70 - 33) / 2);
        make.left.equalTo(cancelButton.mas_left).offset(120 + 50);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(33)));
    }];
}

#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return  _dataArray;
}
- (NSMutableArray*)leftModelArray
{

    if (!_leftModelArray) {
        _leftModelArray = [NSMutableArray new];
    }
    return _leftModelArray;
}
- (UITableView*)leftTableView
{

    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 20, 360, 200) style:UITableViewStylePlain];
        
        _leftTableView.layer.borderWidth = 1;
        _leftTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _leftTableView;
}

- (UITableView*)rightTableView
{

    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(240, 20, 200, 200) style:UITableViewStyleGrouped];
        
        _rightTableView.layer.borderWidth = 1;
        _rightTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _rightTableView;
}

#pragma mark - TableView Delegate
#pragma mark - TableView DataSource

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    if ([tableView isEqual:self.leftTableView]) {
        return nil;
    }
    else {
        if (section == 0) {
            return nil;
        }
        //合计
        
        UIView* footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rightTableView.width, 40)];
        
        UILabel* totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(footView.width - 150, 0, 150, 40)];
        totalLabel.text = [GYUtils formatCurrencyStyle:[self.amountStr doubleValue]];
        totalLabel.textColor = kRedE50012;
        totalLabel.font = kFont48;
        [footView addSubview:totalLabel];
    
        UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(footView.width - 176, 10, 21, 21)];
        [coinImageView setImage:[UIImage imageNamed:@"gyhs_HSBCoin"]];
        [footView addSubview:coinImageView];
        
        UILabel* tintLabel = [[UILabel alloc] initWithFrame:CGRectMake(footView.width - 236, 0, 50, 40)];
        tintLabel.text = kLocalized(@"GYHS_HSStore_Query_Total");
        tintLabel.font = [UIFont systemFontOfSize:24];
        tintLabel.textColor = kGray999999;
        tintLabel.textAlignment = NSTextAlignmentRight;
        [footView addSubview:tintLabel];
        return footView;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView isEqual:self.rightTableView] && section == 1) {
        return 40;
    }
    return 0.01f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    return 0.01f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if ([tableView isEqual:self.leftTableView]) {
        return 180;
    }
    else {
        if (indexPath.section == 0) {
            NSString* value = self.rightValueArray[indexPath.row];
            float height = [value heightForFont:[UIFont systemFontOfSize:16] width:self.rightTableView.width * 0.75];
            
            return ceil(height) + 10;
        }
        return 100;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    if ([tableView isEqual:self.leftTableView]) {
        return 1;
    }
    else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if ([tableView isEqual:self.leftTableView]) {
        UIView* view = [self.view viewWithTag:kRemoveNoMessage];
        if (view) {
            [view removeFromSuperview];
        }
        if (self.leftModelArray.count == 0) {
            
            UIView* viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.view];
            viewC.tag = kRemoveNoMessage;
            viewC.frame = _leftTableView.frame;
            [viewC mas_makeConstraints:^(MASConstraintMaker* make) {
                make.top.equalTo(_leftHeader.mas_bottom);
                make.left.mas_equalTo(kTableMargin);
                make.bottom.mas_equalTo(_footerView.mas_top);
                make.width.mas_equalTo(kDeviceProportion(360));
                
            }];
            
        }
        return self.leftModelArray.count;
    }
    else {
        UIView* view = [self.view viewWithTag:kRemoveNoMessage2];
        if (view) {
            [view removeFromSuperview];
        }
        if (self.rightValueArray.count == 0 && self.dataArray.count == 0) {
            
            UIView* viewC = [GYHSPublicMethod addNoDataTipViewWithSuperView:self.view];
            viewC.tag = kRemoveNoMessage2;
            viewC.frame = _rightTableView.frame;
            [viewC mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(_leftTableView.mas_right).offset(kTableMargin);
                make.right.mas_equalTo(-kTableMargin);
                make.bottom.equalTo(_leftTableView);
                make.top.mas_equalTo(kTableMargin+kNavigationHeight);
                
            }];
            
        }
        if (section == 0) {
            return self.rightValueArray.count;
        }else{
            return  _dataArray.count;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if ([tableView isEqual:self.leftTableView]) {
    
        GYHSQueryToolListCell* cell = [tableView dequeueReusableCellWithIdentifier:qrToolListCellId];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GYHSQueryToolListCell.class) owner:self options:nil][0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        GYHSStoreQueryListModel* model = self.leftModelArray[indexPath.row];
        cell.model = model;
        
        return cell;
    }
    else {
    
        if (indexPath.section == 0) {
            static NSString* ID = @"cectionA";
            UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
            }
            cell.textLabel.text = self.rightTitleArray[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.textLabel.textColor = kGray999999;

            cell.detailTextLabel.text = self.rightValueArray[indexPath.row];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            cell.detailTextLabel.numberOfLines = 0;
            if ([cell.textLabel.text isEqualToString:kLocalized(@"GYHS_HSStore_Query_OrderType")]) {
                cell.detailTextLabel.textColor = kBlue0A59C2;
            }else if ([cell.textLabel.text isEqualToString:kLocalized(@"GYHS_HSStore_Query_OrderStatus")]){
                cell.detailTextLabel.textColor = kRedE50012;
            }else{
                cell.detailTextLabel.textColor = kGray333333;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            GYHSQueryToolMidCell* cell = [tableView dequeueReusableCellWithIdentifier:qrToolMidCellId];
            if (cell == nil) {
                cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GYHSQueryToolMidCell.class) owner:self options:nil][0];
            }
            cell.model = _dataArray[indexPath.row];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    if ([tableView isEqual:self.rightTableView]) {
    
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (tableView == self.leftTableView) {
        GYHSQueryToolListCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        self.selectedModel = cell.model;
        [self requestDetailData];
        if ([cell.model.orderStatus isEqualToString:@"1"]) {
            self.footerView.hidden = NO;
        }
        else {
            self.footerView.hidden = YES;
        }
    }
}

- (void)didTapCancelPay
{
    [GYAlertView alertWithTitle:kLocalized(@"GYHS_Point_Tip")
                        Message:kLocalized(@"GYHS_HSStore_Query_SureToCancelOrder")
                       topColor:TopColorBlue
                   comfirmBlock:^{
                       //进行撤单
                       [self requestCancelOrder];
                   }];
}

- (void)requestCancelOrder{
    [GYHSStoreHttpTool cancelOrderByOrderNo:self.selectedModel.orderNo success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_Query_OrderCanceledSuccessfully")];
        self.isDown = YES;
        [self requestListData];
        [self requestDetailData];
        
    } failure:^{
        
    }];
}

- (void)didTapPay
{
    GYPayViewController *payVC =  [[GYPayViewController alloc]initWithNibName:NSStringFromClass([GYPayViewController class]) bundle:nil];
    
    if ([self.orderModel.orderType isEqualToString:@"103"]) {
        payVC.type = GYPaymentServiceTypeToolPurchase;
    }else if ([self.orderModel.orderType isEqualToString:@"107"]) {
        payVC.type = GYPaymentServiceTypePersonalCard;
    }else if ([self.orderModel.orderType isEqualToString:@"110"]) {
        payVC.type = GYPaymentServiceTypeResourcePurchase;
    }else if ([self.orderModel.orderType isEqualToString:@"100"]){
        payVC.type = GYPaymentServiceTypePayAnnualFee;
    }
    
    GYHSToolPayModel *model = [[GYHSToolPayModel alloc] init];
    model.orderNo = kSaftToNSString(self.orderModel.orderNo);
    model.hsbAmount = kSaftToNSString(self.orderModel.orderAmount);
    payVC.model = model;
    payVC.isQueryDetailVC = YES;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)requestListData
{
[GYNetwork sharedInstance].delegate = self;
    [GYHSStoreHttpTool queryAllOrderListOrderType:@"103,100,107,109,104,110" dateFlag:@"" curPage:[@(self.page) stringValue] pageSize:[@(self.pageSize) stringValue] success:^(id responsObject) {
    
        if ([self.leftTableView.mj_footer isRefreshing]) {
            [self.leftTableView.mj_footer endRefreshing];
        }
        if ([self.leftTableView.mj_header isRefreshing]) {
            [self.leftTableView.mj_header endRefreshing];
        }
        
        
        if (self.isDown) {
            [self.leftModelArray removeAllObjects];
            self.leftModelArray = responsObject;
        }else {
            [self.leftModelArray addObjectsFromArray:responsObject];
        }
    [self.leftTableView reloadData];
    [self tableView:self.leftTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    } failure:^{
    
    }];
}
/**
 *  没有网络的加盖视图上点击重新加载
 */
- (void)gyNetworkDidTapReloadBtn
{
    [self requestListData];
}
- (void)requestDetailData
{
    if (!self.selectedModel.orderNo) {
        return;
    }
    
    [GYHSStoreHttpTool getToolBuyOrderInfoOrderNo:self.selectedModel.orderNo success:^(id responsObject) {
    
    GYHSStoreQueryDetailModel *infoModel = (GYHSStoreQueryDetailModel *)responsObject;

    self.rightTitleArray = [GYHSStoreKVUtils getTitleListWithModel:infoModel];
    
    self.rightValueArray = [GYHSStoreKVUtils getValueListWithModel:infoModel listModel:self.selectedModel yearFeeModel:self.yearFeemodel];
        
        GYHSStoreOrderInfoModel *orderModel = (GYHSStoreOrderInfoModel *)infoModel.orderInfo;
        self.orderModel = orderModel;
        if ([self.orderModel.orderType isEqualToString:@"100"]) {
            self.cancelButton.hidden = YES;
        }else{
            self.cancelButton.hidden = NO;
        }

        self.amountStr = orderModel.orderAmount;
        if ([orderModel.orderType isEqualToString:@"109"]) {//申报申购的金额与总金额要设置为0
            NSMutableArray *dataArrM = @[].mutableCopy;
            for (GYHSStoreConfsModel *tempModel in infoModel.confsInfo) {
                tempModel.price = @"0";
                tempModel.totalAmount = @"0";
                [dataArrM addObject:tempModel];
                
            }
            self.dataArray = dataArrM;
        }else {
            self.dataArray = (NSMutableArray *)infoModel.confsInfo;
        }

        
    [self.rightTableView reloadData];
    
    } failure:^{
    
    }];
}

/**
 *  请求年费信息
 */
- (void)requestYearFee{
    NSDictionary* dicParamas = @{
                                 @"entCustId" : globalData.loginModel.entCustId
                                 };
    @weakify(self);
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSGetAnnualFeeInfo)
         parameter:dicParamas
           success:^(id returnValue) {
               @strongify(self);
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   self.yearFeemodel = [[GYHSMyPayYearFeeModel alloc] initWithDictionary:returnValue[GYNetWorkDataKey] error:nil];
               } else {
                   [GYUtils showToast:returnValue[@"msg"]];
               }
               
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];


}
- (NSArray*)rightTitleArray
{
    if (!_rightTitleArray) {
        _rightTitleArray = @[];
    }
    return _rightTitleArray;
}

- (NSArray*)rightValueArray
{
    if (!_rightValueArray) {
    
        _rightValueArray = @[];
    }
    
    return _rightValueArray;
    
}

@end
