//
//  GYHESCConfirmOrderViewController.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/26.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kConfirmOrderCell @"confirmOrderCell"
#define kOrderSectionHeaderCell @"orderSectionHeaderCell"
#define kOrderSectionFooterCell @"orderSectionFooterCell"

#import "GYHESCConfirmOrderViewController.h"
#import "GYHESCConfirmOrderTableViewCell.h"
#import "GYHESCOrderTableHeaderView.h"
#import "GYHESCOrderTableFooterView.h"
#import "GYHESCOrderSectionFooterView.h"
#import "GYHESCOrderSectionHeaderView.h"
#import "GYHESCOrderSectionFooterView.h"
#import "GYHESCCartListModel.h"
#import "GYHESCOrderModel.h"
#import "GYHESCDistributionWayViewController.h"
#import "GYHESCPaymentMethodsViewController.h"
#import "GYHESCPaymentModel.h"
//#import "GYHEPurchaseOrderController.h"
#import "GYHESCDefaultAddressModel.h"
#import "GYHESCDiscountInfoModel.h"
#import "GYHESCChooseAreaViewController.h"
#import "GYHESCChooseAreaModel.h"
#import "UPPayPlugin.h"
#import "GYHEOrderQuickPayVC.h"
#import "GYAddressData.h"
#import "GYHSGetGoodViewController.h"
#import "GYEPMyAllOrdersViewController.h"
#import "GYPaymentConfirmViewController.h"
#import "libPayecoPayPlugin.h"
#import "GYAlertView.h"
#import "UIButton+GYTimeOut.h"
#import "GYUtilsMacro.h"

@interface GYHESCConfirmOrderViewController () <UITableViewDataSource, UITableViewDelegate, GYHESCOrderSectionFooterViewDelegate, GYHESCOrderTableFooterViewDelegate, GYNetRequestDelegate, UPPayPluginDelegate, GYHESCOrderTableHeaderViewDelegate, GYGetAddressDelegate,PayEcoPpiDelegate>
@property (weak, nonatomic) IBOutlet UITableView* tabView;
@property (weak, nonatomic) IBOutlet UILabel* realNumberTagLabel; //实付金额标签
@property (weak, nonatomic) IBOutlet UILabel* realNumerLabel;
@property (weak, nonatomic) IBOutlet UILabel* consumePVTagLabel; //消费积分标签
@property (weak, nonatomic) IBOutlet UILabel* consumePVLabel;
@property (weak, nonatomic) IBOutlet UIButton* submitOrder; //提交订单按钮
@property (nonatomic, copy) NSString *realMoney;

@property (nonatomic, strong) GYHESCOrderTableHeaderView* headerView;
@property (nonatomic, strong) GYHESCOrderTableFooterView* footerView;

@property (nonatomic, copy) NSString* payType; //支付方式
@property (nonatomic, strong) GYHESCDefaultAddressModel* addressModel; //默认收货地址model
@property (nonatomic, strong) GYHESCDiscountInfoModel* discountModel; //消费券信息model

// 易联支付类
@property (nonatomic, strong) PayEcoPpi* payEcoPpi;

@end

@implementation GYHESCConfirmOrderViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    kCheckLogined
    [self basicSettings]; //基本设置
    [self defaultAddressRequestFromNetWork]; //获取默认地址
    [self setDataSourceAccordingDict:self.isRightAway]; //根据是否立即支付判断需不需要设置数据源
    [self couponInfoRequestFromNetWork]; //获取消费券信息

    self.tabView.tableHeaderView = self.headerView;
    self.tabView.tableFooterView = self.footerView;

    [self.tabView registerNib:[UINib nibWithNibName:@"GYHESCConfirmOrderTableViewCell" bundle:nil] forCellReuseIdentifier:kConfirmOrderCell];
    [self.tabView registerNib:[UINib nibWithNibName:@"GYHESCOrderSectionFooterView" bundle:nil] forHeaderFooterViewReuseIdentifier:kOrderSectionFooterCell];
    [self.tabView registerNib:[UINib nibWithNibName:@"GYHESCOrderSectionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kOrderSectionHeaderCell];
    
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
}
- (void)pushBack{
    if([[[UIDevice currentDevice] systemVersion] floatValue]<8.0) {
        for (NSLayoutConstraint *containt in self.view.constraints) {
            
            [self.view removeConstraint:containt];
            
        }
        
        self.tabView.delegate = nil;
        [self.headerView removeFromSuperview];
        [self.footerView removeFromSuperview];
        [self.headerView removeConstraints:self.headerView.constraints];
        
        for (UIView *view in self.view.subviews) {
            
            [view removeConstraints:view.constraints];
        }
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHESCOrderModel* orderModel = self.dataSourceArray[section];
    return orderModel.modelArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHESCConfirmOrderTableViewCell* orderCell = [tableView dequeueReusableCellWithIdentifier:kConfirmOrderCell forIndexPath:indexPath];
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    GYHESCOrderModel* orderModel = nil;
    if (self.dataSourceArray.count > indexPath.section) {
        orderModel = self.dataSourceArray[indexPath.section];
    }
    GYHESCCartListModel* listModel = nil;
    if (orderModel.modelArray.count > indexPath.row) {
        listModel = orderModel.modelArray[indexPath.row];
    }
    
    [orderCell refreshDataWithModel:listModel]; //刷新数据
    return orderCell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    GYHESCOrderModel* orderModel = self.dataSourceArray[section];
    if (orderModel.enableApplyCard) {
        if (orderModel.isInvoice) {
            return 415.0f;
        }
        else {
            return 415.0f - 50.0f;
        }
    }
    else {
        if (orderModel.isInvoice) {
            return 365.0f;
        }
        else {
            return 365.0f - 50.0f;
        }
    }
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    GYHESCOrderSectionHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kOrderSectionHeaderCell];
    GYHESCOrderModel* orderModel = self.dataSourceArray[section];
    headerView.vShopNameLabel.text = orderModel.vShopName;
    return headerView;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    GYHESCOrderSectionFooterView* footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kOrderSectionFooterCell];
    GYHESCOrderModel* orderModel = self.dataSourceArray[section];
    footerView.orderModel = orderModel;
    footerView.section = section;
    footerView.isRightAway = self.isRightAway;
    footerView.delegate = self;
    [footerView refreshDataWithModel:orderModel discountInfoModel:self.discountModel];
    WS(weakSelf);
    footerView.invoiceBlock = ^() {
//        [weakSelf.tabView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tabView reloadData];
    };
    return footerView;
}

#pragma mark - GYHESCOrderSectionFooterViewDelegate
//选择配送方式
- (void)pushToDistributionWayWithSection:(NSInteger)section
{
    GYHESCDistributionWayViewController* vc = [[GYHESCDistributionWayViewController alloc] init];
    GYHESCOrderModel* orderModel = self.dataSourceArray[section];
    vc.orderModel = orderModel;
    WS(weakSelf);
    vc.distributionBlock = ^(GYHESCDistributionTypeModel* typeModel) {
        orderModel.sendWay = typeModel.desc;
        orderModel.coinIconWidth = typeModel.coinIconWidth;
        orderModel.sendMoney = typeModel.moneyString;
        orderModel.deliveryType = typeModel.type;

        GYHESCOrderSectionFooterView *footerView = (GYHESCOrderSectionFooterView *)[self.tabView footerViewForSection:section];
        footerView.sendWayLabel.textColor = [UIColor blackColor];
        footerView.sendWayLabel.text = orderModel.sendWay;
        footerView.coinIconWidth.constant = orderModel.coinIconWidth;
        if ([orderModel.deliveryType isEqualToString:@"1"]) {//是快递支付
            footerView.expressageLabel.text = orderModel.sendMoney;
        } else {
            footerView.expressageLabel.text = @"";
        }
        
        self.footerView.paymentMethodLabel.text = kLocalized(@"HE_SC_OrderPaymentMethod");
        self.footerView.paymentMethodLabel.textColor = [UIColor lightGrayColor];
        self.payType = nil;
        
        [weakSelf setValueForBottomView];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//选择营业点
- (void)pushToChooseAreaWithIndexPath:(NSInteger)section
{
    GYHESCChooseAreaViewController* vc = [[GYHESCChooseAreaViewController alloc] init];
    vc.chooseBlock = ^(GYHESCChooseAreaModel* areaModel) {
        
        GYHESCOrderModel *orderModel = self.dataSourceArray[section];
        orderModel.shopName = areaModel.shopName;
        orderModel.shopId = areaModel.shopId;
        GYHESCOrderSectionFooterView *footerView = (GYHESCOrderSectionFooterView *)[self.tabView footerViewForSection:section];
        footerView.operatingPointLabel.text = orderModel.shopName;
        
        //将配送方式置空
        orderModel.sendWay = kLocalized(@"HE_SC_OrderDistributionWay");
        orderModel.coinIconWidth = 0;
        orderModel.sendMoney = @"";
        orderModel.deliveryType = nil;
        footerView.expressageLabel.text = orderModel.sendMoney;
        footerView.coinIconWidth.constant = orderModel.coinIconWidth;
        footerView.sendWayLabel.text = orderModel.sendWay;
        footerView.sendWayLabel.textColor = [UIColor lightGrayColor];
        
        //将支付方式置空
        self.footerView.paymentMethodLabel.text = kLocalized(@"HE_SC_OrderPaymentMethod");
        self.footerView.paymentMethodLabel.textColor = [UIColor lightGrayColor];
        self.payType = nil;
    }; //返回营业点名称
    
    GYHESCOrderModel* orderModel = self.dataSourceArray[section];
    GYHESCCartListModel* listModel = [orderModel.modelArray firstObject];
    vc.vShopId = orderModel.vShopId;
    vc.itemId = listModel.id;
    
    [self.navigationController pushViewController:vc animated:YES];
}

//重新计算实付金额与消费积分
- (void)calculateWhenConsumeSwitchDidChange
{
    [self setValueForBottomView];
}


#pragma mark - GYHESCOrderTableFooterViewDelegate
//选择支付方式
- (void)pushToChoosePaymentMethod
{
    BOOL isSendWayExist = NO;
    for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
        if (orderModel.deliveryType) {
            isSendWayExist = YES;
        }
    }
    if (isSendWayExist) {
        GYHESCPaymentMethodsViewController* vc = [[GYHESCPaymentMethodsViewController alloc] init];
        vc.paymentBlock = ^(GYHESCPaymentMethodModel* model) {
            self.footerView.paymentMethodLabel.textColor = [UIColor blackColor];
            self.footerView.paymentMethodLabel.text = model.typeString;
            self.payType = model.payType;
        };
        vc.isDelivery = @"0";
        NSMutableArray* mArray = [[NSMutableArray alloc] init];
        for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
            [mArray addObject:orderModel.shopId];
            if ([orderModel.deliveryType isEqualToString:@"1"]) {
                vc.isDelivery = @"1";
            }
        }
        NSString* shopIdList = [mArray componentsJoinedByString:@","]; //将数组元素按逗号合并成字符串
        vc.shopIds = shopIdList;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [GYUtils showToast:kLocalized(@"HE_SC_OrderDistributionWay")];
    }
}

#pragma mark - GYHESCOrderTableHeaderViewDelegate
//跳转到选择收获地址页面
- (void)pushToChooseReceiveAddress
{
    GYHSGetGoodViewController* vc = [[GYHSGetGoodViewController alloc] init];
    vc.deletage = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYGetAddressDelegate
- (void)getAddressModle:(GYAddressModel*)model
{
    if (!self.addressModel) {
        self.addressModel = [[GYHESCDefaultAddressModel alloc] init];
    }
    self.addressModel.postCode = model.postCode;
    self.addressModel.receiver = model.receiver;
    self.addressModel.addrId = model.addrId;
    self.addressModel.mobile = model.mobile;
    self.addressModel.provinceNo = model.provinceNo;
    self.addressModel.isDefault = model.isDefault;
    self.addressModel.area = model.area;
    self.addressModel.cityNo = model.cityNo;
    self.addressModel.address = model.address;
    self.addressModel.custId = model.custId;
    self.addressModel.telphone = model.telphone;
    self.addressModel.countryNo = model.countryNo;

    self.headerView.chooseAddressLabel.hidden = YES;
    [self setValueForTableHeaderView];
}

#pragma mark - custom methods
- (NSMutableArray*)buildPaymentJson
{
    NSMutableArray* finalArray = [[NSMutableArray alloc] init];
    for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
        GYHESCPaymentModel* payModel = [[GYHESCPaymentModel alloc] init];
        for (GYHESCCartListModel* listModel in orderModel.modelArray) {
            GYHESCOrderDetailListModel* detailModel = [[GYHESCOrderDetailListModel alloc] init];
            detailModel.quantity = listModel.count;
            detailModel.categoryId = listModel.categoryId;
            detailModel.ruleId = kSaftToNSString(listModel.ruleId);
            detailModel.vShopId = listModel.vShopId;
            detailModel.isApplyCard = orderModel.enableApplyCard ? @"1" : @"0";
            detailModel.itemName = listModel.title;
            detailModel.skuId = listModel.skuId;
            detailModel.price = listModel.price;
            detailModel.subTotal = [NSString stringWithFormat:@"%.2lf", [listModel.price doubleValue] * [listModel.count integerValue]];
            detailModel.point = listModel.pv;
            detailModel.skus = listModel.sku;
            detailModel.shopId = listModel.shopId;
            detailModel.subPoints = [NSString stringWithFormat:@"%.2lf", [listModel.pv doubleValue] * [listModel.count integerValue]];
            detailModel.itemId = listModel.id;

            payModel.companyResourceNo = listModel.companyResourceNo;
            payModel.serviceResourceNo = listModel.serviceResourceNo;

            [payModel.orderDetailList addObject:detailModel];
        }
        if (orderModel.isApplyCard) {
            if (kSaftToNSString(orderModel.leaveMessage).length > 0) {
                payModel.userNote = [NSString stringWithFormat:@"%@%@",kSaftToNSString(orderModel.leaveMessage),kLocalized(@"GYHE_SC_BuyerApplyHSCardWithOther")];
            } else {
                payModel.userNote = kLocalized(@"GYHE_SC_BuyerApplyHSCard");
            }
        } else {
            payModel.userNote = kSaftToNSString(orderModel.leaveMessage);
        }
        payModel.payType = self.payType;
        payModel.sendWay = [NSString stringWithFormat:@"%@ ¥%@", orderModel.sendWay, orderModel.sendMoney];
        payModel.shopId = orderModel.shopId;
        payModel.shopName = orderModel.shopName;
        payModel.totalPoints = [NSNumber numberWithDouble:[orderModel.totalPv doubleValue]];
        payModel.channelType = @"2";
        payModel.coinCode = globalData.custGlobalDataModel.currencyCode;
        payModel.deliveryType = orderModel.deliveryType;
        payModel.vShopName = orderModel.vShopName;

        payModel.isDrawed = orderModel.isInvoice ? @"1" : @"0";
        payModel.Express = orderModel.sendWay;
        payModel.receiverAddress = [self obtainAddress];
        payModel.receiverContact = self.addressModel.mobile;
        payModel.receiver = self.addressModel.receiver;
        payModel.receiverPostCode = self.addressModel.postCode;
        payModel.postAge = orderModel.sendMoney;
        payModel.totalAmount = [NSNumber numberWithDouble:[orderModel.totalMoney doubleValue]];
        payModel.invoiceTitle = kSaftToNSString(orderModel.invoiceHead);
        payModel.vShopId = orderModel.vShopId;
        double coupomAmount = 0;
        if (orderModel.isUseConsume) {
            NSMutableDictionary* mDict = [[NSMutableDictionary alloc] init];

            [mDict setValue:[NSNumber numberWithInteger:[orderModel.couponId longLongValue]] forKey:@"id"];
            [mDict setValue:[NSNumber numberWithInteger:[orderModel.num integerValue]] forKey:@"num"];
            [mDict setValue:[NSNumber numberWithInteger:[orderModel.amount integerValue]] forKey:@"faceValue"];
            [mDict setValue:orderModel.couponName forKey:@"name"];

            NSData* counponData = [NSJSONSerialization dataWithJSONObject:mDict options:NSJSONWritingPrettyPrinted error:nil];
            NSString* counponString = [[NSString alloc] initWithData:counponData encoding:NSUTF8StringEncoding];
            payModel.couponInfo = counponString;
            payModel.isSelectDiscount = @"1";
            NSString* couponMoney = [NSString stringWithFormat:@"%.2lf", [orderModel.num integerValue] * [orderModel.amount doubleValue]];
            payModel.discount = [NSString stringWithFormat:kLocalized(@"GYHE_SC_DiscountInfomation"), orderModel.couponName, orderModel.num, couponMoney];
            payModel.couponAmount = [NSString stringWithFormat:@"%.2lf", [orderModel.amount doubleValue] * [orderModel.num integerValue]];
            coupomAmount = [orderModel.amount doubleValue] * [orderModel.num integerValue];
        }
        else {
            payModel.couponAmount = @"0";
            payModel.couponInfo = @"";
            coupomAmount = 0;
        }
        payModel.actuallyAmount = [NSString stringWithFormat:@"%.2lf", [orderModel.totalMoney doubleValue] + [orderModel.sendMoney doubleValue] - coupomAmount]; //实付金额(totalAmount  - couponAmount )
        if ([orderModel.num integerValue] > 0) {
            NSString* couponMoney = [NSString stringWithFormat:@"%.2lf", [orderModel.num integerValue] * [orderModel.amount doubleValue]];
            payModel.DiscountDetail = [NSString stringWithFormat:kLocalized(@"GYHE_SC_DiscountInfomationDiff"), orderModel.couponName, orderModel.num, couponMoney];
        }

        //        payModel.buyerAccountNo = globalData.loginModel.resNo;
        NSDictionary* payDict = [payModel toDictionary];
        [finalArray addObject:payDict];
    }
    return finalArray;
}

//根据是否立即支付判断需不需要设置数据源
- (void)setDataSourceAccordingDict:(NSString*)isRightAway
{
    if ([isRightAway isEqualToString:@"1"]) {
        GYHESCCartListModel* listModel = [[GYHESCCartListModel alloc] init];
        listModel.count = self.goodsNumber;
        listModel.cartId = @"";
        listModel.categoryId = self.goodsDict[@"categoryId"];
        listModel.companyResourceNo = self.goodsDict[@"companyResourceNo"];
        listModel.couponDesc = self.goodsDict[@"couponDesc"];
        listModel.id = self.goodsDict[@"id"];
        listModel.isApplyCard = kSaftToNSString(self.goodsDict[@"isApplyCard"]);
        listModel.ruleId = self.goodsDict[@"ruleId"];
        listModel.serviceResourceNo = self.goodsDict[@"serviceResourceNo"];
        listModel.shopId = self.goodsDict[@"shopId"];
        listModel.shopName = self.goodsDict[@"shopName"];
        if ([[self.goodsDict allKeys] containsObject:@"title"]) {
            listModel.title = self.goodsDict[@"title"];
        }
        else {
            listModel.title = self.goodsDict[@"itemName"];
        }
        listModel.vShopId = self.goodsDict[@"vShopId"];
        listModel.vShopName = self.goodsDict[@"vShopName"];

        listModel.sku = self.skuDict[@"sku"];
        listModel.skuId = self.skuDict[@"skuId"];
        listModel.url = self.skuDict[@"picList"][0][@"url"];
        listModel.price = [self.skuDict[@"price"] stringValue];
        listModel.pv = [self.skuDict[@"pv"] stringValue];
        listModel.isSelect = YES;

        NSMutableArray* mArray = [[NSMutableArray alloc] init];
        [mArray addObject:listModel];
        GYHESCOrderModel* orderModel = [[GYHESCOrderModel alloc] init];
        [orderModel.modelArray addObject:listModel];
        orderModel.vShopName = listModel.vShopName;
        orderModel.vShopId = listModel.vShopId;
        orderModel.modelArray = [[NSMutableArray alloc] initWithObjects:listModel, nil];
        orderModel.totalNumber = [NSString stringWithFormat:@"%ld", mArray.count];
        orderModel.totalMoney = [NSString stringWithFormat:@"%.2lf", [listModel.price doubleValue] * [listModel.count integerValue]];
        orderModel.totalPv = [NSString stringWithFormat:@"%.2lf", [listModel.pv doubleValue] * [listModel.count integerValue]];
        orderModel.shopName = listModel.shopName;
        orderModel.shopId = listModel.shopId;
        orderModel.sendWay = kLocalized(@"HE_SC_OrderDistributionWay");
        orderModel.payOffWay = kLocalized(@"HE_SC_OrderPaymentMethod");
        if ([listModel.isApplyCard isEqualToString:@"1"]) {
            orderModel.enableApplyCard = YES;
        }

        orderModel.totalNumber = [NSString stringWithFormat:@"%ld", mArray.count];
        orderModel.totalMoney = [NSString stringWithFormat:@"%.2lf", [listModel.price doubleValue] * [listModel.count integerValue]];
        orderModel.totalPv = [NSString stringWithFormat:@"%.2lf", [listModel.pv doubleValue] * [listModel.count integerValue]];

        [self.dataSourceArray addObject:orderModel];
    }
}

//基本设置
- (void)basicSettings
{
    self.title = kLocalized(@"HE_SC_OrderConfirmOrderTitle");
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tabView setTableFooterView:[[UIView alloc] init]];
    self.tabView.rowHeight = 110.0f;

    self.realNumberTagLabel.text = [NSString stringWithFormat:@"%@:",kLocalized(@"HE_SC_OrderRealMoney")];
    self.consumePVTagLabel.text = [NSString stringWithFormat:@"%@:",kLocalized(@"HE_SC_OrderConsumePoints")];
    [self.submitOrder setTitle:kLocalized(@"HE_SC_OrderSubmitOrderTitle") forState:UIControlStateNormal];
    [self setValueForBottomView];
}

//为底部view赋值
- (void)setValueForBottomView
{
    double totalMoney = 0;
    double totalPv = 0;
    double discountPrice = 0;
    for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
        if (orderModel.isUseConsume) {
            discountPrice = [orderModel.amount doubleValue] * [orderModel.num integerValue];
        }
        else {
            discountPrice = 0;
        }
        totalMoney += [orderModel.totalMoney doubleValue] + [orderModel.sendMoney doubleValue] - discountPrice;
        totalPv += [orderModel.totalPv doubleValue];
    } //计算实付金额与消费积分
    self.realMoney = [NSString stringWithFormat:@"%.2lf", totalMoney];
    self.realNumerLabel.text = self.realMoney;
    self.consumePVLabel.text = [NSString stringWithFormat:@"%.2lf", totalPv];
}

//消费券信息网络请求
- (void)couponInfoRequestFromNetWork
{
    NSMutableArray* mDiscountInfoArray = [self buildDiscountInfoArray];
    NSData* discountInfoData = [NSJSONSerialization dataWithJSONObject:mDiscountInfoArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString* parameterString = [[NSString alloc] initWithData:discountInfoData encoding:NSUTF8StringEncoding]; //转为json字符串
    NSMutableDictionary* mParameterDic = [[NSMutableDictionary alloc] init];
    [mParameterDic setValue:globalData.loginModel.token forKey:@"key"];
    [mParameterDic setValue:parameterString forKey:@"params"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyGetConfirmOrderInfoUrl parameters:mParameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 102;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//默认地址网络请求
- (void)defaultAddressRequestFromNetWork
{
    NSDictionary* parameterDic = @{ @"token" : globalData.loginModel.token,
        @"custId" : globalData.loginModel.custId };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:kGetDefaultReceiveGoodsAddressUrlString parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 103;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//创建消费券请求体
- (NSMutableArray*)buildDiscountInfoArray
{
    NSMutableArray* mParameterArray = [[NSMutableArray alloc] init];
    for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
        NSMutableArray* listArray = [[NSMutableArray alloc] init];
        for (GYHESCCartListModel* listModel in orderModel.modelArray) {
            NSMutableDictionary* mListDic = [[NSMutableDictionary alloc] init];
            [mListDic setValue:listModel.id forKey:@"itemId"];
            [mListDic setValue:listModel.ruleId forKey:@"ruleId"];
            [mListDic setValue:listModel.vShopId forKey:@"vShopId"];
            NSString* itemPrice = [NSString stringWithFormat:@"%.2lf", [listModel.price doubleValue] * [listModel.count integerValue]];
            [mListDic setValue:itemPrice forKey:@"itemPrice"];
            [listArray addObject:mListDic];
        }
        NSMutableDictionary* mParamsDic = [[NSMutableDictionary alloc] init];
        [mParamsDic setValue:listArray forKey:@"list"];
        [mParamsDic setValue:orderModel.shopId forKey:@"orderKey"];
        [mParameterArray addObject:mParamsDic];
    }
    return mParameterArray;
}

//为数据源新增默认配送方式（快递支付）
- (void)addDataForDataSourceWithDiscountModel
{
    for (NSInteger i = 0; i < self.dataSourceArray.count; i++) {
        GYHESCOrderModel* orderModel = self.dataSourceArray[i];
        orderModel.sendWay = kLocalized(@"HE_SC_OrderExpress");
        orderModel.coinIconWidth = 21.0f;
        GYHESCExpressFeeModel* expressModel = self.discountModel.expressFeeList[i];
        orderModel.sendMoney = kSaftToNSString(expressModel.expressFee);
        orderModel.deliveryType = @"1";
        for (GYHESCOrderCouponModel* couponModel in self.discountModel.orderCouponList) {
            if ([couponModel.orderKey isEqualToString:orderModel.shopId]) {
                GYHESCDiscountDetailModel* detailModel = [couponModel.list firstObject];
                orderModel.couponId = detailModel.couponId;
                orderModel.amount = detailModel.amount;
                orderModel.num = detailModel.num;
                orderModel.couponName = detailModel.couponName;
                break;
            }
        }
    }
    [self.tabView reloadData];
}

//为顶部地址view设值
- (void)setValueForTableHeaderView
{
    self.headerView.nameLabel.text = [NSString stringWithFormat:@"%@", self.addressModel.receiver];
    self.headerView.telephoneNumberLabel.text = self.addressModel.mobile;
    self.headerView.addressLabel.text = [NSString stringWithFormat:@"%@%@", kLocalized(@"HE_SC_OrderReceiveAddress"), [self obtainAddress]];
}

//拼接收获地址
- (NSString*)obtainAddress
{
    GYCityAddressModel* cityModel = [[GYAddressData shareInstance] queryCityNo:self.addressModel.cityNo];
    GYProvinceModel* provinceModel = [[GYAddressData shareInstance] queryProvinceNo:self.addressModel.provinceNo];
    NSString* attribString = [NSString stringWithFormat:@"%@%@%@%@", kSaftToNSString(provinceModel.provinceName), kSaftToNSString(cityModel.cityName), kSaftToNSString(self.addressModel.area), kSaftToNSString(self.addressModel.address)];

    return attribString;
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    if (netRequest.tag == 103) {
        self.headerView.chooseAddressLabel.text = kLocalized(@"HE_SC_OrderPleaseSelectAddress");
        self.headerView.chooseAddressLabel.hidden = NO;
    }
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    DDLogDebug(@"------success----");
    if (netRequest.tag == 101) {
        if ([self.payType isEqualToString:@"3"]) {
            NSString* orderIdString = kSaftToNSString(responseObject[@"data"]);
            
            GYPaymentConfirmViewController *vc = [[GYPaymentConfirmViewController alloc] init];
            vc.paymentMode = GYPaymentModeWithGoods;
            vc.orderNO = orderIdString;
            vc.realMoney = self.realMoney;
            vc.navigationItem.title = kLocalized(@"GYHE_SC_PaymentConfirmation");
            double allMoney = 0;
            double couponMoney = 0;
            double discountPrice = 0;
            for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
                if (orderModel.isUseConsume) {
                    discountPrice = [orderModel.amount doubleValue] * [orderModel.num integerValue];
                }
                else {
                    discountPrice = 0;
                }
                allMoney += [orderModel.totalMoney doubleValue] + [orderModel.sendMoney doubleValue];
                couponMoney += discountPrice;
            }
            vc.orderMoney = [NSString stringWithFormat:@"%.2lf",allMoney];
            vc.discount = [NSString stringWithFormat:@"%.2lf",couponMoney];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([self.payType isEqualToString:@"5"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *tnCode = responseObject[@"data"];
                [self queryEcoPpiOrder:tnCode];//认证卡支付
                
//                if (tnCode.length > 0) {
//                    [UPPayPlugin startPay:tnCode mode:kUPPayPluginMode viewController:self delegate:self];//调用银联支付
//                } else {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:kLocalized(@"HE_SC_IconPayConfirmOrderFaild") delegate:self cancelButtonTitle:kLocalized(@"HE_SC_CartConfirm") otherButtonTitles:nil];
//                    [alertView show];
//                }
            });
        }
        else if ([self.payType isEqualToString:@"1"]) {
            [GYAlertView showMessage:kLocalized(@"HE_SC_IconPayCDSuccess") confirmBlock:^{
                //跳转到购物订单界面
//                GYHEPurchaseOrderController *vc = [[GYHEPurchaseOrderController alloc] init];
//                [self.navigationController pushViewController:vc animated:YES];
                
                GYEPMyAllOrdersViewController *vcMyOrder = [[GYEPMyAllOrdersViewController alloc] init];
                vcMyOrder.title = kLocalized(@"GYHE_SC_ShoppingList");
                [self.navigationController pushViewController:vcMyOrder animated:YES];
            }];
        }
        else {
            NSString* tnCode = responseObject[@"data"];
            if ([GYUtils checkStringInvalid:tnCode]) {
                [GYUtils showToast:kLocalized(@"GYHE_SC_SubmitOrderFaild")];
                return;
            }

            GYHEOrderQuickPayVC* vc = [[GYHEOrderQuickPayVC alloc] init];
            vc.orderNO = tnCode;
            vc.amount = self.realMoney;
            vc.orderType = GYHEOrderQuickPayVCOrderTypeGoods;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (netRequest.tag == 102) {
        self.discountModel = [[GYHESCDiscountInfoModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
        [self addDataForDataSourceWithDiscountModel];
        [self setValueForBottomView];
    }
    else {

        NSDictionary* addressDict = responseObject[@"data"];
        if (addressDict && ![addressDict isKindOfClass:[NSNull class]]) {
            self.addressModel = [[GYHESCDefaultAddressModel alloc] initWithDictionary:addressDict error:nil];
            if (!self.addressModel.area) {
                self.addressModel.area = @"";
            }
            [self setValueForTableHeaderView];
            self.headerView.chooseAddressLabel.hidden = YES;
        }
        else {
            self.headerView.chooseAddressLabel.text = kLocalized(@"HE_SC_OrderPleaseSelectAddress");
            self.headerView.chooseAddressLabel.hidden = NO;
        }
    }
}

#pragma mark - 懒加载
- (NSMutableArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

- (GYHESCOrderTableHeaderView*)headerView
{
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"GYHESCOrderTableHeaderView" owner:self options:nil] firstObject];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (GYHESCOrderTableFooterView*)footerView
{
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"GYHESCOrderTableFooterView" owner:self options:nil] firstObject];
        _footerView.paymentMethodLabel.text = kLocalized(@"HE_SC_OrderACPayment");
        _footerView.paymentMethodLabel.textColor = [UIColor blackColor];
        self.payType = @"3";
        _footerView.delegate = self;
    }
    return _footerView;
}

#pragma mark - xib event response
//提交订单点击事件
- (IBAction)submitOrderButtonClick:(UIButton*)sender
{    
    [sender controlTimeOut];
    
    if (!(self.addressModel && self.headerView.chooseAddressLabel.hidden)) {
        [GYUtils showToast:kLocalized(@"HE_SC_OrderPleaseSelectAddress")];
        return;
    }

    BOOL isSendWayExist = NO;
    for (GYHESCOrderModel* orderModel in self.dataSourceArray) {
        if (orderModel.deliveryType) {
            isSendWayExist = YES;
        }
        if (orderModel.isInvoice && !(orderModel.invoiceHead.length > 0)) {
            [GYUtils showToast:kLocalized(@"HE_SC_OrderInvoiceHeadPlaceHolder")];
            return;
        }
    }

    if (self.addressModel && self.headerView.chooseAddressLabel.hidden) {

        if (isSendWayExist) {
            if (self.payType && self.payType.length > 0) {
                NSMutableArray* mArray = [self buildPaymentJson];
                NSData* data = [NSJSONSerialization dataWithJSONObject:mArray options:NSJSONWritingPrettyPrinted error:nil];
                NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; //转为json字符串
                NSMutableDictionary* mParameterDic = [[NSMutableDictionary alloc] init];
                [mParameterDic setValue:globalData.loginModel.token forKey:@"key"];
                [mParameterDic setValue:self.isRightAway forKey:@"isRightAway"];
                [mParameterDic setValue:jsonString forKey:@"orderJson"];
                if ([self.payType isEqualToString:@"3"]) { //互生币支付
                    [mParameterDic setValue:@"000" forKey:@"coinCode"];
                }
                else {
                    [mParameterDic setValue:globalData.custGlobalDataModel.currencyCode forKey:@"coinCode"];
                }
                NSDictionary* parameterDic = [mParameterDic copy];
                GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyConfirmationOrderUrl parameters:parameterDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerHTTP];
//                [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
                request.tag = 101;
                [request commonParams:[GYUtils netWorkCommonParams]];
                [request start];
            }
            else {
                [GYUtils showToast:kLocalized(@"HE_SC_OrderPaymentMethod")];
            }
        }
        else {
            [GYUtils showToast:kLocalized(@"HE_SC_OrderDistributionWay")];
        }
    }
    else {
        [GYUtils showToast:kLocalized(@"HE_SC_OrderPleaseSelectAddress")];
    }
}

#pragma mark - UPPayPluginDelegate
- (void)UPPayPluginResult:(NSString*)result
{
    if ([result isEqualToString:@"success"]) {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:kLocalized(@"HE_SC_IconPaySuccess") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:kLocalized(@"HE_SC_CartConfirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
#warning 合并后需跳转到购物订单界面
//            GYHEPurchaseOrderController *vc = [[GYHEPurchaseOrderController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            GYEPMyAllOrdersViewController *vcMyOrder = [[GYEPMyAllOrdersViewController alloc] init];
            vcMyOrder.title = kLocalized(@"GYHE_SC_ShoppingList");
            [self.navigationController pushViewController:vcMyOrder animated:YES];

        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:nil message:kLocalized(@"HE_SC_IconPayFaild") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:kLocalized(@"HE_SC_CartConfirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action) {
#warning 合并后需跳转到购物订单界面
//            GYHEPurchaseOrderController *vc = [[GYHEPurchaseOrderController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            GYEPMyAllOrdersViewController *vcMyOrder = [[GYEPMyAllOrdersViewController alloc] init];
            vcMyOrder.title = kLocalized(@"GYHE_SC_ShoppingList");// modify by songjk 改成全部订单
            [self.navigationController pushViewController:vcMyOrder animated:YES];

        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }

}

- (void)queryEcoPpiOrder:(NSString *)orderNO
{
    NSDictionary* paramDic = @{
                               @"operateCode" : kGY_HSEC_TMS_001,
                               @"orderNo" : kSaftToNSString(orderNO),
                               @"transAmount" : self.realMoney,
                               @"key" : kSaftToNSString(globalData.loginModel.token)
                               };
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kUrlPayOperateOrderInfo parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYAlertView showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability")
                            confirmBlock:^{
                                GYEPMyAllOrdersViewController *epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
                                epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
                                [self.navigationController pushViewController:epMyOrderVc animated:YES];
                            }];
                return;
            }
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        
        NSDictionary *serverDic = responseObject[@"data"];
        
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
            [GYUtils showToast:kLocalized(@"GYHE_SC_GetTradeDataFailed")];
            return;
        }
        
        //初始化易联支付类对象
        self.payEcoPpi = [[PayEcoPpi alloc] init];
        NSString *reqJson = [GYUtils dictionaryToString:serverDic];
        
        // delegate: 用于接收支付结果回调
        // env:环境参数 00: 测试环境  01: 生产环境
        // orientation: 支付界面显示的方向 00：横屏  01: 竖屏
        [self.payEcoPpi startPay:reqJson delegate:self env:kPayEcoPpiPluginMode orientation:@"01"];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark - PayEcoPpiDelegate
// 易联支付完成后执行回调，返回数据，通知商户
- (void)payResponse:(NSString*)respJsonStr
{
    DDLogDebug(@"\nPayEco PpiDelegate payResponse:%@", respJsonStr);
    
    NSData* respData = [respJsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* respDic = [NSJSONSerialization JSONObjectWithData:respData
                                                            options:kNilOptions
                                                              error:nil];
    NSString* respCode = [respDic objectForKey:@"respCode"];
    NSString* respDesc = [respDic objectForKey:@"respDesc"];
    
    if ([respCode isEqualToString:@"0000"]) {
        [GYUtils showToast:kLocalized(@"GYHE_SC_OrderPaySuccess")];
        GYEPMyAllOrdersViewController* epMyOrderVc = [[GYEPMyAllOrdersViewController alloc] init];
        epMyOrderVc.title = kLocalized(@"GYHE_SC_ShoppingList");
        [self.navigationController pushViewController:epMyOrderVc animated:YES];
    }
    else {
        if (!respDesc || [respDesc isKindOfClass:[NSNull class]]) {
            respDesc = kLocalized(@"GYHE_SC_OrderPayFailed");
        }
        if ([respCode isEqualToString:@"W101"]) {
            respDesc = kLocalized(@"GYHE_SC_OrderNotPayment");
        }
        [GYUtils showToast:respDesc];
    }
}

@end
