//
//  GYEPOrderDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEPOrderDetailViewController.h"
#import "ViewHeaderForOrderDetail.h"
#import "ViewFooterForOrderDetail.h"
#import "CellForOrderDetailCell.h"
#import "UIActionSheet+Blocks.h"
#import "UIButton+GYExtension.h"
#import "GYEPSaleAfterApplyForViewController.h"

#import "ViewUseVouchesInfo.h"
#import "ViewGoodsAmount.h"
#import "ViewShopInfo.h"
#import "ViewOrderStateInfo.h"
#import "EasyPurchaseData.h"
#import "GYEPOrderQRCoderViewController.h"
#import "GYShowWebInfoViewController.h"
#import "GYEasybuyGoodsInfoViewController.h" //商品详情
#import "GYGIFHUD.h"
#import "GYHDChatViewController.h"
#import "AutoAdjustFrame.h"
#import "GYPaymentConfirmViewController.h"
#import "GYShopDescribeController.h"
#import "GYEasyBuyModel.h"
#import "GYAlertView.h"

@interface GYEPOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, CellForOrderDetailCellDelegate, ViewHeaderForOrderDetailDelegate, UIActionSheetDelegate> {
    ViewHeaderForOrderDetail* vHeader;
    ViewFooterForOrderDetail* vFooter;

    ViewOrderStateInfo* vOrderStateInfo;
    ViewShopInfo* vShopInfo;
    ViewGoodsAmount* vAmount;
    ViewUseVouchesInfo* vVouches;
    NSDictionary* dicResult;

    EMOrderState orderState;
    BOOL isHasCouponInfo;
}
@property (strong, nonatomic) NSMutableArray* arrDataSource;
@property (strong, nonatomic) IBOutlet UITableView* tableView;

@property (weak, nonatomic) IBOutlet UIButton* payNowBtn;
@property (weak, nonatomic) IBOutlet UIButton* cancelOrderBtn;

@property (strong, nonatomic) IBOutlet UIButton* btn0;
@property (strong, nonatomic) IBOutlet UIButton* btn1;
@property (strong, nonatomic) IBOutlet UIView* btnsBkg;
//add by zhangqy
@property (copy, nonatomic) NSString* day; //倒计时，天数
@property (copy, nonatomic) NSString* hour; //倒计时，小时
@property (assign, nonatomic) BOOL checkApply; //是否可申请延时收货
@property (copy, nonatomic) NSString* takeCode; //自提码，如果是在线支付且自提方式下才有
@property (copy, nonatomic) NSString* status;
@property (copy, nonatomic) NSString* strMessage;
@property (assign, nonatomic) BOOL logistics; //是否有物流信息
@property (assign, nonatomic) CGRect btn0Frame;
@property (assign, nonatomic) CGRect btn1Frame;
@property (nonatomic, copy) NSString* deliveryType; //为2时是门店自提

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* btn0CenterConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint* btn1CenterConstraint;

@property (nonatomic, copy) NSString* indexRefund; //为判断从订单详情，申请售后刷新底部按钮

@end

@implementation GYEPOrderDetailViewController

- (NSMutableArray*)arrDataSource
{
    if (_arrDataSource == nil) {
        _arrDataSource = [[NSMutableArray alloc] init];
    }
    return _arrDataSource;
}

- (NSMutableDictionary*)dicDataSource
{
    if (!_dicDataSource) {
        _dicDataSource = [NSMutableDictionary dictionary];
    }
    return _dicDataSource;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //边框
    vOrderStateInfo = [[ViewOrderStateInfo alloc] init];
    vShopInfo = [[ViewShopInfo alloc] init];
    vAmount = [[ViewGoodsAmount alloc] init];
    vVouches = [[ViewUseVouchesInfo alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBasicSetting];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 40, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backButton addTarget:self action:@selector(popToSomeViewControllerAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backButton];
}

- (void)popToSomeViewControllerAction {
    if (self.isComeOrder) {
        UIViewController *vc = self.navigationController.viewControllers[self.navigationController.viewControllers.count - 4];
        [self.navigationController popToViewController:vc animated:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)createBasicSetting
{
    self.title = kLocalized(@"GYHE_MyHE_OrderDetail");
    _btn0Frame = self.btn0.frame;
    _btn1Frame = self.btn1.frame;
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    isHasCouponInfo = NO;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderInfo) name:@"refreshAfterSaleListNotification" object:nil];
    
    self.btnsBkg.hidden = YES;
    self.tableView.hidden = YES;
    self.payNowBtn.hidden = YES;
    self.cancelOrderBtn.hidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.payNowBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.payNowBtn.backgroundColor = kCorlorFromHexcode(0xF09614);
    self.cancelOrderBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    self.cancelOrderBtn.backgroundColor = kCorlorFromHexcode(0xFA3C28);
    
    vHeader = [[ViewHeaderForOrderDetail alloc] init];
    vHeader.delegate = self;
    [vHeader.btnVshopName addTarget:self action:@selector(btnShopNameClick:) forControlEvents:UIControlEventTouchUpInside];
    vHeader.mvArrowRight.hidden = NO; // add by songjk 隐藏取商铺的尖头
    self.tableView.tableHeaderView = vHeader;
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(vHeader.viewBkg3.frame));
    vFooter = [[ViewFooterForOrderDetail alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForOrderDetailCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellForOrderDetailCellIdentifier];
    [self.btn0 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
    [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_ImmediatePayment") forState:UIControlStateNormal];
    // add by songjk 改变联系客服按钮位置 隐藏掉之前的
    //self.btnContact.hidden = YES;
    [self getOrderInfo];

}

#pragma mark ViewHeaderForOrderDetailDelegate
- (void)ViewHeaderForOrderDetailContactDidClickedWithView:(ViewHeaderForOrderDetail*)view
{
    [self btnContactClick:nil];
}

//zhangqiyun
- (void)confirmGetGoodsBtnClicked:(UIButton*)btn
{
    [self btnConfirmClick:btn];
}

- (void)delayGetGoodsBtnClicked:(UIButton*)btn
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_WhetherDelayReceipt") confirm:^{
        [self delayOrder];
    } cancleBlock:^{
        
    }];
}

- (void)delayOrder
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : _orderID };

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:DelayDeliverUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    //add by zhangqy  刷新倒计时
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_DelayReceivingApplicationSuccessful")];
                    [self.delegate performSelector:@selector(headerRereshing)];
                    
                    [self refreshTimerNetworking];

                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_DelayOperationFailed")];
                    self.btn0.hidden = YES;
                    self.btn1CenterConstraint.constant = 0;
                }
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
            }
            
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }
    }];
    [request start];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount = [self.arrDataSource count];
    if (isHasCouponInfo) {
        dataCount += 5; //加一个订单状态，实体店信息,金额，互生券 【20150506因为后台接口没返回互生券的信息，暂时隐藏】
    }
    else {
        dataCount += 4; //加一个订单状态，实体店信息,金额，互生券 【20150506因为后台接口没返回互生券的信息，暂时隐藏】
    }
    return dataCount;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    static NSString* cellid = kCellForOrderDetailCellIdentifier;
    UITableViewCell* cll = nil;
    switch (section) {
    case 0: {
        if (row < self.arrDataSource.count) {
            CellForOrderDetailCell* cell = nil;
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[CellForOrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.delegate = self;
            cell.index = row;
            NSDictionary* dic = self.arrDataSource[row];
            cell.lbGoodsName.text = kSaftToNSString(dic[@"title"]);
            cell.lbGoodsProperty.text = kSaftToNSString(dic[@"desc"]);
            cell.lbGoodsCnt.text = [NSString stringWithFormat:@"x %@", dic[@"count"]];

            NSString* imgUrl = kSaftToNSString(dic[@"url"]);
            [cell.ivGoodsPicture setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];

            cll = cell;
        }
        else if (row == self.arrDataSource.count) { //订单状态
            cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            cll.backgroundView.backgroundColor = kNavigationBarColor;

            [vOrderStateInfo.lbState setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_OrderStatus"), [EasyPurchaseData getOrderStateString:orderState]]];
            [vOrderStateInfo.lbOrderNo setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_Order_Number"), kSaftToNSString(dicResult[@"orderId"])]];
            [vOrderStateInfo.lbOrderDatetime setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_ClosingTime"), dicResult[@"createTime"]]];

            if (self.takeCode && self.takeCode.length > 0) {
                vOrderStateInfo.lbOrderTakeCode.hidden = NO;
                [vOrderStateInfo.lbOrderTakeCode setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_SinceCode"), self.takeCode]];
            }
            else {
                CGRect vframe = vOrderStateInfo.frame;
                vframe.size.height = 94;
                vOrderStateInfo.frame = vframe;
            }

            [cll.contentView addSubview:vOrderStateInfo];
        }
        else if (row == self.arrDataSource.count + 1) { //实体店
            cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            [vShopInfo.btnShopTel addTarget:self action:@selector(callShop:) forControlEvents:UIControlEventTouchUpInside];
            NSString* tmpStr = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_MyHE_Address"), dicResult[@"shopAddress"]];
            [vShopInfo.lbShopAddress setText:tmpStr];
            tmpStr = [NSString stringWithFormat:@"%@", dicResult[@"contactWay"]];
            [vShopInfo.btnShopTel setTitle:tmpStr forState:UIControlStateNormal];

            [cll.contentView addSubview:vShopInfo];
        }
        else if (row == self.arrDataSource.count + 2) { /////发票数据
            cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            UILabel* toplabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 20)];
            toplabel.text = kLocalized(@"GYHE_MyHE_InvoiceInformation");
            toplabel.font = [UIFont boldSystemFontOfSize:14];
            toplabel.textColor = kCorlorFromHexcode(0xA0A0A0);
            [cll.contentView addSubview:toplabel];
            
            UILabel* notetitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 100, 20)];
            notetitle.font = [UIFont systemFontOfSize:14];
            notetitle.textColor = kCellItemTextColor;
            notetitle.text = kLocalized(@"GYHE_MyHE_WhetherInvoice");
            [cll.contentView addSubview:notetitle];
            
            UILabel* note = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 20, 20)];
            note.font = [UIFont systemFontOfSize:14];
            note.textColor = kCellItemTextColor;
            note.text = [kSaftToNSString(dicResult[@"isDrawed"]) isEqualToString:@"0"] ? kLocalized(@"GYHE_MyHE_NO") : kLocalized(@"GYHE_MyHE_YES");
            [cll.contentView addSubview:note];
            ////发票抬头信息
            CGFloat fontSizeInvoice = 14.0;
            CGFloat widthInvoice = self.view.bounds.size.width - 36;
            NSString* strInvoice = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_InvoiceTitle"), kSaftToNSString(dicResult[@"invoiceTitle"])];
            CGFloat heightInvoice = [AutoAdjustFrame heightForString:strInvoice width:widthInvoice font:fontSizeInvoice];
            
            UILabel* invoiceTitlelab = [[UILabel alloc] initWithFrame:CGRectMake(15, note.frame.size.height + note.frame.origin.y + 2, widthInvoice, heightInvoice)];
            invoiceTitlelab.text = strInvoice;
            invoiceTitlelab.textColor = kCellItemTextColor;
            invoiceTitlelab.font = [UIFont systemFontOfSize:fontSizeInvoice];
            invoiceTitlelab.numberOfLines = 0;
            [cll.contentView addSubview:invoiceTitlelab];
            
            ////中线
            UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(15, invoiceTitlelab.frame.origin.y + invoiceTitlelab.bounds.size.height + 10, kScreenWidth - 30, 1)];
            line.backgroundColor = [UIColor lightGrayColor];
            line.alpha = 0.5;
            [cll.contentView addSubview:line];
            
            UILabel* messagetitle = [[UILabel alloc] initWithFrame:CGRectMake(15, line.frame.origin.y + line.frame.size.height + 12, 100, 16)];
            messagetitle.text = kLocalized(@"GYHE_MyHE_BuyerLeaveMessge");
            messagetitle.font = [UIFont systemFontOfSize:14];
            messagetitle.textColor = kCorlorFromHexcode(0xA0A0A0);
            [cll.contentView addSubview:messagetitle];
            
            if (kSaftToNSInteger(dicResult[@"isDrawed"]) == 0) {
                invoiceTitlelab.hidden = YES;
                line.frame = CGRectMake(15, notetitle.frame.origin.y + notetitle.bounds.size.height + 4, kScreenWidth - 30, 0.2);
                messagetitle.frame = CGRectMake(15, notetitle.frame.origin.y + notetitle.frame.size.height + 12, 100, 16);
            }
            
            ////买家留言内容
            CGFloat fontSize = 14.0;
            CGFloat widthMsg = self.view.bounds.size.width - 36;
            CGFloat height = [AutoAdjustFrame heightForString:kSaftToNSString(dicResult[@"userNote"]) width:widthMsg font:fontSize];
            UILabel* message = [[UILabel alloc] initWithFrame:CGRectMake(15, messagetitle.frame.origin.y + messagetitle.bounds.size.height + 5, widthMsg, height)];
            message.textColor = kCorlorFromHexcode(0xA0A0A0);
            message.text = kSaftToNSString(dicResult[@"userNote"]);
            message.font = [UIFont systemFontOfSize:fontSize];
            message.numberOfLines = 0;
            [cll.contentView addSubview:message];
            self.strMessage = message.text;
        }
        else if (row == self.arrDataSource.count + 3) { //金额
            vAmount.lbAmount.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"orderTotal"] doubleValue]];
            vAmount.lbCourierFees.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"postAge"] doubleValue]];
            vAmount.lbPoint.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"totalPoints"] doubleValue]];
            cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];
            vAmount.lbAmount.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"orderTotal"] doubleValue]];
            vAmount.lbCourierFees.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"postAge"] doubleValue]];
            vAmount.lbPoint.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"totalPoints"] doubleValue]];
            [cll addSubview:vAmount];
        }
        else if (row == self.arrDataSource.count + 4) { //互生券
            cll = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell0"];

            NSDictionary* couponInfo = dicResult[@"couponInfo"];
            if (couponInfo && [couponInfo isKindOfClass:[NSDictionary class]]) {
                vVouches.lbLabelHSConsumptionVouchers.text = kSaftToNSString(couponInfo[@"name"]);
                vVouches.lbVouchersInfo0.text = [NSString stringWithFormat:@"%@元/张 x%@", couponInfo[@"faceValue"], couponInfo[@"num"]];
                double val = kSaftToDouble(couponInfo[@"faceValue"]);
                NSInteger num = kSaftToNSInteger(couponInfo[@"num"]);
                vVouches.lbHSConsumptionVouchers.text = [GYUtils formatCurrencyStyle:val * num];
                vVouches.lbTotalVouchers.text = [GYUtils formatCurrencyStyle:val * num];
                isHasCouponInfo = YES;
            }

            [cll addSubview:vVouches];
        }

    } break;

    default:
        break;
    }
    [cll setSelectionStyle:UITableViewCellSelectionStyleNone];

    //    [cell.contentView addBottomBorder];
    return cll;
}

#pragma mark CellForOrderDetailCellDelegate
- (void)CellForOrderDetailCellDidCliciPictureWithCell:(CellForOrderDetailCell*)cell
{
    // songjk 互动进入判断
    if (!self.vShopId) {
        self.vShopId = [self.dicDataSource objectForKey:@"vShopNameId"];
    }
    if (!self.itemId || !self.vShopId || self.itemId.length == 0 || self.vShopId.length == 0) {
        return;
    }
    
    NSMutableArray *arrDataSource = [NSMutableArray array];
    arrDataSource = self.dicDataSource[@"items"];
    GYEasybuyGoodsInfoViewController* vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYEasybuyGoodsInfoViewController class]));
    vcGoodDetail.itemId = arrDataSource[cell.index][@"id"];
//    vcGoodDetail.itemId = self.itemId;
    vcGoodDetail.vShopId = self.vShopId;
    [self.navigationController pushViewController:vcGoodDetail animated:YES];
}

////算高度
- (CGFloat)labelheight:(NSString*)string
{
    //modify by zhangqy
    if (![string isKindOfClass:[NSNull class]]) {

        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary* attributes = @{
            NSFontAttributeName : [UIFont systemFontOfSize:12],
            NSParagraphStyleAttributeName : paragraphStyle
        };

        CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
        return size.height;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat h = 80.0f;
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    DDLogDebug(@"%ld", self.arrDataSource.count);
    switch (section) {
    case 0:
        if (row < self.arrDataSource.count) {
            h = 120.0f;
        }
        else if (row == self.arrDataSource.count) { //订单状态
            if (self.takeCode.length > 0) {
                h = [ViewOrderStateInfo getHeight];
            }
            else {

                h = [ViewOrderStateInfo getHeight] - 25;
            }
        }
        else if (row == self.arrDataSource.count + 1) { //实体店
            h = [ViewShopInfo getHeight];
        }
        else if (row == self.arrDataSource.count + 2) { /////发票数据  需要根据发票信息和买家留言 两个label 来计算高度
            if ([GYUtils isBlankString:self.strMessage]) {
                //开具发票，无发票抬头
                if([GYUtils checkStringInvalid:dicResult[@"invoiceTitle"]]) {
                    
                    if (![dicResult[@"userNote"] isEqualToString:@""]) {
                        CGFloat   strHeigt1 = 0.0 ;
                        strHeigt1 = [dicResult[@"userNote"] boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 36, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size.height;
                        
                        h = 90 + strHeigt1;
                    }else{
                        
                        return 90;
                    }
                    
                }else {
                    CGRect rect = [dicResult[@"invoiceTitle"] boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 36, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
                    CGFloat   strHeigt = 0.0 ;
                    if (dicResult[@"userNote"] && ![dicResult[@"userNote"] isEqualToString:@""]) {
                        
                    strHeigt = [dicResult[@"userNote"] boundingRectWithSize:CGSizeMake(self.view.bounds.size.width - 36, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil].size.height;
                    }
                    
                    if([[UIDevice currentDevice].systemVersion doubleValue] < 8.0){
                        
                        h = 90 + rect.size.height + 20;//20是底部留言高度
                        
                        if (strHeigt > 0) {
                            h = 110 + rect.size.height +strHeigt;
                        }
                        
                    }else
                    {
                        h = 110 + rect.size.height;
                    }
                    
                }
            }else { //HEInvoiceTitle

                if ([kSaftToNSString(dicResult[@"isDrawed"]) isEqualToString:@"0"]) {

                    NSString* str = [NSString stringWithFormat:@"%@\n%@", kLocalized(@"GYHE_MyHE_BuyerLeaveMessge"), kSaftToNSString(self.strMessage)];
                    CGFloat fontSize = 14.0;
                    CGFloat widthMsg = self.view.bounds.size.width - 30;
                    h = [AutoAdjustFrame heightForString:str width:widthMsg font:fontSize] + 90;
                }
                else {

                    NSString* str = [NSString stringWithFormat:@"%@\n%@", kLocalized(@"GYHE_MyHE_BuyerLeaveMessge"), kSaftToNSString(self.strMessage)];
                    CGFloat fontSize = 14.0;
                    CGFloat widthMsg = self.view.bounds.size.width - 30;
                    h = [AutoAdjustFrame heightForString:str width:widthMsg font:fontSize] + 90 + 35;
                }
            }
        }
        else if (row == self.arrDataSource.count + 3) { //金额
            h = [ViewGoodsAmount getHeight];
        }
        else if (row == self.arrDataSource.count + 4) { //互生券
            h = [ViewUseVouchesInfo getHeight];
        }

        break;
    default:
        break;
    }
    return h;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return [ViewFooterForOrderDetail getHeight];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    NSInteger isRefund = kSaftToNSInteger([self.dicDataSource objectForKey:@"orderClickRefund"]);

    if (isRefund == 1 || [_indexRefund isEqualToString:@"1"]) { //判断售后状态，为1时候隐藏按钮
        self.btn0.hidden = YES;
        self.btn1CenterConstraint.constant = 0;
    }

    return vFooter;
}

#pragma mark -   拨打电话
- (void)callShop:(UIButton*)button
{

    [GYUtils callPhoneWithPhoneNumber:button.currentTitle showInView:self.view];
}

#pragma mark - 查看物流详情
- (void)btnCheckLogisticDetailClick:(id)sender
{
    GYShowWebInfoViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYShowWebInfoViewController class]));
    vc.strUrl = vHeader.strCheckLogisticDetailUrl;
    vc.navigationItem.title = kLocalized(@"GYHE_MyHE_LogisticsDetails");
    [self pushVC:vc animated:YES];
}

#pragma mark - 联系商家
- (void)btnContactClick:(id)sender
{
    GlobalData* data = globalData;
    NSString* resourceNo = kSaftToNSString(dicResult[@"companyResourceNo"]);
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"resourceNo" : resourceNo };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:GetVShopShortlyInfoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    dic = dic[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        GYHDChatViewController *chatViewController = [[GYHDChatViewController alloc] init];
                        
                        
                        NSMutableDictionary *comDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                        
                        NSString *type = kLocalized(@"GYHE_MyHE_PurchaseOrders");
                        //订单类型
                        NSString *orderStat = [EasyPurchaseData getOrderStateString:[dicResult[@"status"] integerValue]];
                        
                        NSString *price = [NSString stringWithFormat:@"%.2f",[dicResult[@"orderTotal"] doubleValue]];
                        NSString *pv = [NSString stringWithFormat:@"%.2f",[dicResult[@"totalPoints"] doubleValue]];
                        
                        [comDict setValue:@{
                                            @"order_type":type,
                                            @"order_no":kSaftToNSString(dicResult[@"orderId"]),
                                            @"order_time":kSaftToNSString(dicResult[@"createTime"]),
                                            @"order_state":kSaftToNSString(orderStat),
                                            @"order_price":kSaftToNSString(price),
                                            @"order_pv":kSaftToNSString(pv)
                                            } forKey:@"orders"];
                        [comDict setValue:@"" forKey:@"goods"];
                        chatViewController.companyInformationDict = comDict;
                        [self.navigationController pushViewController:chatViewController animated:YES];
                    });
                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_AccessBusinessInformationFailed")];
                }
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_AccessBusinessInformationFailed")];
            }
            
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }
    }];
    [request start];
}

#pragma mark - 取消订单
- (void)btnCancelClick:(id)sender
{
    [GYAlertView showMessage:kLocalized(@"GYHE_MyHE_WetherCancelOrder") cancleBlock:^{
        
    } confirmBlock:^{
        
        [self cancelOrder];
    }];
}

- (void)cancelOrder
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : _orderID };
    [GYGIFHUD showFullScreen];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyCancelOrderUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    
                    [self.cancelOrderBtn setHidden:YES];
                    [self.payNowBtn setHidden:YES];
                    
                    NSString *string = kSaftToNSString(self.dicDataSource[@"status"]);
                    if ([string isEqualToString:@"0"] || [string isEqualToString:@"9"]) {//商家备货中提示
                        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CancelOrderSuccess")];
                    } else {
                        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OrderHaveCommitPleaseWait")];
                        
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState)stringValue]] object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll)stringValue]] object:nil userInfo:nil];
                    
                    [self createBasicSetting];
                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
                }
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
            }
            
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }
    }];
    [request start];
}

#pragma mark - 进入商铺
- (void)btnShopNameClick:(id)sender
{
    GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
    ShopModel* model = [[ShopModel alloc] init];
    model.strShopId = kSaftToNSString(self.dicDataSource[@"shopId"]);
    model.strVshopId = [_dicDataSource objectForKey:@"virtualShopId"];
    if (!model.strVshopId || model.strVshopId.length == 0) {
        return;
    }
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVC:vc animated:YES];

}

#pragma mark - 售后申请
- (void)btnSaleAfterClick:(id)sender
{
    GYEPSaleAfterApplyForViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPSaleAfterApplyForViewController class]));
    vc.dicDataSource = self.dicDataSource;
    vc.navigationItem.title = kLocalized(@"GYHE_MyHE_ApplyAfterSales");
    [self pushVC:vc animated:YES];
}

#pragma mark - 再次购买
- (void)btnBuyAgainClick:(id)sender
{
    [self buyAgain];
}

- (void)buyAgain
{
    GlobalData* data = globalData;

    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"sourceType" : @"2",
        @"orderId" : _orderID };

    [GYGIFHUD show];
    
    
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyAgainBuyUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_GoodsUnderFrame")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }else if ([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]){
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_shopClocePleaseTryLater")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }else{
                
                [GYUtils parseNetWork:error resultBlock:nil];
                return ;
            }
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    //去刷新吧
                    
                    [GYAlertView showMessage:kLocalized(@"GYHE_MyHE_CartTips") cancleButtonTitle:kLocalized(@"GYHE_MyHE_NO") confirmButtonTitle:kLocalized(@"GYHE_MyHE_YES") cancleBlock:^{
                        
                    } confirmBlock:^{
                        
                        UIViewController *vc = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }];
                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
                }
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
            }
            
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }
    }];
    [request start];
}

#pragma mark - 确认收货
- (void)btnConfirmClick:(id)sender
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_PleassConfirmReceiptGoods") confirm:^{
        [self confirmReceipt];
    } cancleBlock:^{
        
    }];
}

- (void)confirmReceipt
{
    GlobalData* data = globalData;
    NSArray* orderNos = @[ _orderID ];
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderIds" : [orderNos componentsJoinedByString:@","] //多个订单使用,分隔
    };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyConfirmReceiptUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (!error) {
            
            if (error) {
                DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                [GYUtils parseNetWork:error resultBlock:nil];
                return ;
            }
            
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    //去刷新吧
                    DDLogDebug(@"确认收货成功.");
                    //确认收货成功把btn0，btn1还原位置
                    self.btn0.frame = _btn0Frame;
                    self.btn1.frame = _btn1Frame;
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_ConfirmReceiptSuccess")];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState)stringValue]] object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll)stringValue]] object:nil userInfo:nil];
                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
                }
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
            }
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }
    }];
    [request start];
}

#pragma mark - 立即付款
- (void)btnPayClick:(id)sender
{
    GYPaymentConfirmViewController *vc = [[GYPaymentConfirmViewController alloc] init];
    vc.paymentMode = GYPaymentModeWithGoods;
    vc.orderNO = kSaftToNSString(self.dicDataSource[@"number"]);
    vc.realMoney = kSaftToNSString(self.dicDataSource[@"total"]);
    vc.navigationItem.title = kLocalized(@"GYHE_MyHE_PayCinfirm");
    
    vc.discount = kSaftToNSString(self.dicDataSource[@"activityAmount"]);
    vc.orderMoney = [NSString stringWithFormat:@"%.2lf",[vc.realMoney doubleValue] + [vc.discount doubleValue]];
    [self pushVC:vc animated:YES];
}

#pragma - 刷新数据
- (void)setupTimerAndDelay
{
    UIColor* cGray = kCorlorFromRGBA(150, 150, 150, 1);
    UIColor* cRed = kCorlorFromRGBA(250, 60, 40, 1);
    if ([self.status isEqualToString:@"0"] || [self.status isEqualToString:@"3"] || [self.status isEqualToString:@"10"]) {

        if (_logistics) {
            CGRect tmpRect = vHeader.frame;
            tmpRect.size.height = [ViewHeaderForOrderDetail getHeight] - 173;
            [vHeader setFrame:tmpRect];
            CGRect vb3Frame = vHeader.viewBkg3.frame;
            vb3Frame.origin.y = kDefaultMarginToBounds;
            vHeader.viewBkg3.frame = vb3Frame;
        }
        else {
            
            if ([self.deliveryType isEqualToString:@"2"]) {  //待自提
                
                [vHeader.viewBkg2 setHidden:YES];
                CGRect tmpRect = vHeader.frame;
                tmpRect.size.height = [ViewHeaderForOrderDetail getHeight] - vHeader.viewBkg2.frame.size.height - kDefaultMarginToBounds - 173 - 64;
                [vHeader setFrame:tmpRect];
                vHeader.distanceTopConstraint.constant = -120;
                vHeader.viewbBGHeightConstraint.constant = 68;
                CGRect vb3Frame = vHeader.viewBkg3.frame;
                vb3Frame.origin.y = kDefaultMarginToBounds;
                vHeader.viewBkg3.frame = vb3Frame;
            }else{
                
                [vHeader.viewBkg2 setHidden:YES];
                CGRect tmpRect = vHeader.frame;
                tmpRect.size.height = [ViewHeaderForOrderDetail getHeight] - vHeader.viewBkg2.frame.size.height - kDefaultMarginToBounds - 173;
                [vHeader setFrame:tmpRect];
                vHeader.distanceTopConstraint.constant = -120;
                CGRect vb3Frame = vHeader.viewBkg3.frame;
                vb3Frame.origin.y = kDefaultMarginToBounds;
                vHeader.viewBkg3.frame = vb3Frame;
            }
            
        }

        //待买家付款
        if ([self.status isEqualToString:@"0"]) {
            vHeader.lbTimeLeft.text = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Day%@HourCancelOrder") , _day, _hour];
        }
        //待确认收货/待确认收货
        if ([self.status isEqualToString:@"3"]) {
            vHeader.lbTimeLeft.text = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Day_HourOrderWillConfirmReceiveGoosByItself"), _day, _hour];
            [self.btn1 setHidden:NO];
            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_ConfirmReachGoods") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];

            //  CGRect rect0 = self.btnContact.frame;
            self.btn1.frame = _btn0Frame;
            self.btn0.frame = _btn1Frame;
            CGRect rectBtn = self.btn1.frame;
            rectBtn.origin.x = kScreenWidth * 0.5 - 90;
            self.btn1.frame = rectBtn;
            
            CGRect rectBtn1 = self.btn0.frame;
            rectBtn1.origin.x = kScreenWidth * 0.5 + 10;
            self.btn0.frame = rectBtn1;

            [self.btn0 setTitle:kLocalized(@"GYHE_MyHE_DelayDelivery") forState:UIControlStateNormal];
            [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 addTarget:self action:@selector(delayGetGoodsBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.btn0 setBackgroundColor:[UIColor clearColor]];
            [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];

            if (!self.checkApply) {
                self.btn0.hidden = YES;
                self.btn1CenterConstraint.constant = 0;
            }
            else {
                self.btn0.hidden = NO;
                self.btn1CenterConstraint.constant = -self.btn0CenterConstraint.constant;
            }

        }
        //已申请取消/买家取消待确认
        if ([self.status isEqualToString:@"10"]) {
            vHeader.lbTimeLeft.text = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Day%@HourCancelOrder"), _day, _hour];
        }
    }
    else {
        vHeader.viewBkg3.hidden = YES;
        vHeader.addressDistanceTopConstraint.constant = -95;

        if (_logistics) {
            vHeader.addressDistanceTopConstraint.constant = -65;
            CGRect tmpRect = vHeader.frame;
            tmpRect.size.height = [ViewHeaderForOrderDetail getHeight] - vHeader.viewBkg3.frame.size.height - kDefaultMarginToBounds - 170;
            [vHeader setFrame:tmpRect];
            [vHeader.viewBkg3 setHidden:YES];
            CGRect vb2Frame = vHeader.viewBkg2.frame;
            vb2Frame.origin.y = 0;
            vHeader.viewBkg2.frame = vb2Frame;

            CGRect vb0Frame = vHeader.viewBkg0.frame;
            vb0Frame.origin.y = kDefaultMarginToBounds * 2 + vb2Frame.size.height;
            vHeader.viewBkg0.frame = vb0Frame;

            CGRect vb1Frame = vHeader.viewBkg1.frame;
            vb1Frame.origin.y = kDefaultMarginToBounds + vb0Frame.origin.y + vb0Frame.size.height;
            vHeader.viewBkg1.frame = vb1Frame;
        }
        else {
            if ([self.deliveryType isEqualToString:@"2"]) { //待自提
                
                [vHeader.viewBkg2 setHidden:YES];
                CGRect tmpRect = vHeader.frame;
                tmpRect.size.height = [ViewHeaderForOrderDetail getHeight] - vHeader.viewBkg3.frame.size.height - vHeader.viewBkg2.frame.size.height - kDefaultMarginToBounds * 2 - 172 - 64;
                [vHeader setFrame:tmpRect];
                
                CGRect vb0Frame = vHeader.viewBkg0.frame;
                vb0Frame.origin.y = kDefaultMarginToBounds;
                vHeader.viewBkg0.frame = vb0Frame;
                vHeader.viewbBGHeightConstraint.constant = 68;
                vHeader.distanceTopConstraint.constant = -90;
                CGRect vb1Frame = vHeader.viewBkg1.frame;
                vb1Frame.origin.y = kDefaultMarginToBounds + vb0Frame.origin.y + vb0Frame.size.height;
                vHeader.viewBkg1.frame = vb1Frame;
                
            }else {
                
                [vHeader.viewBkg2 setHidden:YES];
                CGRect tmpRect = vHeader.frame;
                tmpRect.size.height = [ViewHeaderForOrderDetail getHeight] - vHeader.viewBkg3.frame.size.height - vHeader.viewBkg2.frame.size.height - kDefaultMarginToBounds * 2 - 172;
                [vHeader setFrame:tmpRect];
                
                CGRect vb0Frame = vHeader.viewBkg0.frame;
                vb0Frame.origin.y = kDefaultMarginToBounds;
                vHeader.viewBkg0.frame = vb0Frame;
                vHeader.distanceTopConstraint.constant = -90;
                CGRect vb1Frame = vHeader.viewBkg1.frame;
                vb1Frame.origin.y = kDefaultMarginToBounds + vb0Frame.origin.y + vb0Frame.size.height;
                vHeader.viewBkg1.frame = vb1Frame;
            }
        }
    }
}

- (void)reloadData
{
    [self.btn0 setHidden:YES];
    [self.btn1 setHidden:YES];

    //

    //
    //    vHeader.lbTimeLeft.text = [NSString stringWithFormat:@"还剩%@天%@小时订单自动确认收货",_day,_hour];
    //    if (!_checkApply) {
    //        self.delayGetGoodsBtn.hidden = YES;
    //    }
    //    订单状态                   操作
    //    待付款                    取消订单、立即付款
    //    待收货                    确认收货
    //    交易成功                  售后申请、再次购买 、删除
    //    交易关闭                  再次购买、删除
    //    待发货、买家已付款         取消订单
    //    商家取消订单、买家已取消  再次购买、删除
    //
    //    再次购买是加入购物车
    UIColor* cGray = kCorlorFromRGBA(150, 150, 150, 1);
    UIColor* cRed = kCorlorFromRGBA(250, 60, 40, 1);

    _arrDataSource = dicResult[@"items"];
    orderState = kSaftToNSInteger(dicResult[@"status"]);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderInfo) name:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil];

    NSString* strLogisticName = kSaftToNSString(dicResult[@"logisticName"]);
    NSString* strLogisticOrderNo = kSaftToNSString(dicResult[@"logisticCode"]);
    if (strLogisticName.length > 0 && strLogisticOrderNo.length > 0) {
        [vHeader.lbLogisticName setText:[kLocalized(@"GYHE_MyHE_ExpressCompany") stringByAppendingString:strLogisticName]];
        [vHeader.lbLogisticOrderNo setText:[kLocalized(@"GYHE_MyHE_HECourierNumber") stringByAppendingString:strLogisticOrderNo]];
        vHeader.strCheckLogisticDetailUrl = [NSString stringWithFormat:@"http://m.kuaidi100.com/index_all.html?type=%@&postid=%@",
                                                      kSaftToNSString(dicResult[@"logisticId"]),
                                                      strLogisticOrderNo];

        [vHeader.btnCheckLogisticDetail addTarget:self action:@selector(btnCheckLogisticDetailClick:) forControlEvents:UIControlEventTouchUpInside];
        _logistics = YES;
    }
    else { //没有物流信息 隐藏

        _logistics = NO;
    }
    [vHeader.lbConsignee setText:[NSString stringWithFormat:@"%@", dicResult[@"receiver"]]];
    [vHeader.lbTel setText:kSaftToNSString(dicResult[@"receiverContact"])];

    NSString* str = kSaftToNSString(dicResult[@"receiverAddress"]);
    // add by songjk 地址后面加上邮编 没有返回邮编无法添加 只能到确认订单界面添加
    //    NSString * strZipCode = kSaftToNSString(dicResult[@"logisticId"]);
    //    if (strZipCode && ![strZipCode isKindOfClass:[NSNull class]] && strZipCode.length>0 && [strZipCode rangeOfString:@"null"].location == NSNotFound)
    //    {
    //        str = [str stringByAppendingString:[NSString stringWithFormat:@"(%@)",strZipCode]];
    //    }
    if ([str hasPrefix:kLocalized(@"GYHE_MyHE_ReceiveGoodsAdress")]) {
        str = [str substringFromIndex:5];
    }
    str = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_ReceiveGoodsAdress: %@"), str];
    
    if (![self.deliveryType isEqualToString:@"2"]) {
        [vHeader.lbConsigneeAddress setText:str];
    }
    //    [vHeader.btnVshopName setTitle:kSaftToNSString(dicResult[@"vShopName"]) forState:UIControlStateNormal] ;
    vHeader.labVshopName.text = [NSString stringWithFormat:@"%@", kSaftToNSString(dicResult[@"vShopName"])];

    self.tableView.tableHeaderView = vHeader;

    [vOrderStateInfo.lbState setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_OrderStatus"), [EasyPurchaseData getOrderStateString:orderState]]];
    [vOrderStateInfo.lbOrderNo setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_Order_Number"), kSaftToNSString(dicResult[@"orderId"])]];
    [vOrderStateInfo.lbOrderDatetime setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_ClosingTime"), dicResult[@"createTime"]]];
    if (self.takeCode && self.takeCode.length > 0) {
        vOrderStateInfo.lbOrderTakeCode.hidden = NO;
        [vOrderStateInfo.lbOrderTakeCode setText:[NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_SinceCode"), self.takeCode]];
    }
    else {
        CGRect vframe = vOrderStateInfo.frame;
        vframe.size.height -= 11;
        vOrderStateInfo.frame = vframe;
    }

    //    [vShopInfo.lbShopName setText:kSaftToNSString(dicResult[@"shopName"])];
    //    NSString *tmpStr = [NSString stringWithFormat:@"%@%@%@%@", kLocalized(@"地址："), dicResult[@"city"], dicResult[@"area"], dicResult[@"shopAddress"]];
    NSString* tmpStr = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_MyHE_Address"), dicResult[@"shopAddress"]];
    [vShopInfo.lbShopAddress setText:tmpStr];
    tmpStr = [NSString stringWithFormat:@"%@", dicResult[@"contactWay"]];
    [vShopInfo.btnShopTel setTitle:tmpStr forState:UIControlStateNormal];

    [vAmount.lbAmount setText:[GYUtils formatCurrencyStyle:kSaftToDouble(dicResult[@"orderTotal"])]];
    [vAmount.lbCourierFees setText:[GYUtils formatCurrencyStyle:kSaftToDouble(dicResult[@"postAge"])]];
    [vAmount.lbPoint setText:[GYUtils formatCurrencyStyle:kSaftToDouble(dicResult[@"totalPoints"])]];

    vFooter.lbRealisticAmount.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"actuallyAmount"] doubleValue]];
    vFooter.lbPoint.text = [NSString stringWithFormat:@"%.02f", [dicResult[@"totalPoints"] doubleValue]];

    NSDictionary* couponInfo = dicResult[@"couponInfo"];
    if (couponInfo && [couponInfo isKindOfClass:[NSDictionary class]]) {
        vVouches.lbLabelHSConsumptionVouchers.text = kSaftToNSString(couponInfo[@"name"]);
        vVouches.lbVouchersInfo0.text = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@RmbOnePiecex%@"), couponInfo[@"faceValue"], couponInfo[@"num"]];
        double val = kSaftToDouble(couponInfo[@"faceValue"]);
        NSInteger num = kSaftToNSInteger(couponInfo[@"num"]);
        vVouches.lbHSConsumptionVouchers.text = [GYUtils formatCurrencyStyle:val * num];
        vVouches.lbTotalVouchers.text = [GYUtils formatCurrencyStyle:val * num];
        isHasCouponInfo = YES;
    }

    switch (orderState) {
    case kOrderStateWaittingPay: //待买家付款
        [self.btn0 setHidden:NO];
        [self.btn1 setHidden:NO];
        [self.btn0 setHidden:YES];
        [self.btn1 setHidden:YES];
        [self.cancelOrderBtn setHidden:NO];
        [self.payNowBtn setHidden:NO];

        [self.btn0 setBackgroundColor:kClearColor];
        [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
        [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [self.btn0 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrderBtn removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrderBtn addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrderBtn addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_ImmediatePayment") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.payNowBtn addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];

        break;
    case kOrderStateHasPay: //买家已付款
    case kOrderStateWaittingDelivery: //待发货
    case kOrderStateWaittingSellerSendGoods: //待商家送货

        [self.btn1 setHidden:NO];
        [self.btn0 setHidden:NO];
        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_RemindDelivery") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(alertToSendGoods) forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 setBorderWithWidth:1 andRadius:3 andColor:kNavigationBarColor];
        [self.btn0 setBackgroundColor:kClearColor];
        [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
        [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [self.btn0 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

        break;

    case kOrderStateWaittingPickUpCargo: //待自提
    {
        BOOL isPostPay = [kSaftToNSString(dicResult[@"isPostPay"]) boolValue]; //是否货到付款
        if (isPostPay) { //货到付款
            [self.btn1 setHidden:NO];
            
            self.btn1CenterConstraint.constant = 0;

            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            //                [self.btn0 setHidden:NO];
            [self.btn1 setHidden:NO];
            self.btn1CenterConstraint.constant = 0;

            [self.btn1 setBackgroundColor:kClearColor];
            [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
            [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            [self.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

            //                [self.btn1 setBackgroundColor:kClearColor];
            //                [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            //                [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            //                [self.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
            //                [self.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    } break;

    case kOrderStateWaittingConfirmReceiving: //待确认收货
        [self.btn1 setHidden:NO];
        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_ConfirmReachGoods") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        break;
    case kOrderStateFinished: //交易成功
    {
        [self.btn0 setHidden:NO];
        [self.btn1 setHidden:NO];
        self.btn1CenterConstraint.constant = -self.btn0CenterConstraint.constant;

        [self.btn0 setBackgroundColor:kClearColor];
        [self.btn0 setTitleColor:cGray forState:UIControlStateNormal];
        [self.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [self.btn0 setTitle:kLocalized(@"GYHE_MyHE_ApplyAfterSales") forState:UIControlStateNormal];
        [self.btn0 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn0 addTarget:self action:@selector(btnSaleAfterClick:) forControlEvents:UIControlEventTouchUpInside];
        if (!self.dicDataSource) { //未传订单列表信息过来，不可以进行售后申请
            [self.btn0 setHidden:YES];
            self.btn1CenterConstraint.constant = 0;
        }

        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
    } break;
    case kOrderStateClosed: //交易关闭
        [self.btn1 setHidden:NO];
        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];

        break;
    case kOrderStateSellerPreparingGoods: //交易关闭
        [self.btn1 setHidden:NO];
        self.btn1CenterConstraint.constant = 0;
        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:cGray forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

        break;
    case kOrderStateCancelBySeller: //商家取消订单
    case kOrderStateCancelByBuyer: //买家已取消
    case kOrderStateCancelBySystem: //系统取消订单
        [self.btn1 setHidden:NO];
        self.btn1CenterConstraint.constant = 0;
        [self.btn1 setBackgroundColor:kClearColor];
        [self.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [self.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [self.btn1 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
        [self.btn1 removeTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];

        break;

    default:
        break;
    }
    //add by zhangqy

    [self setupTimerAndDelay];
    self.tableView.tableHeaderView = vHeader;

    if ([self.arrDataSource isKindOfClass:[NSNull class]]) {
        self.arrDataSource = nil;
    }
    self.tableView.hidden = (self.arrDataSource && self.arrDataSource.count > 0 ? NO : YES);
    self.btnsBkg.hidden = self.tableView.hidden;
    [self.tableView reloadData];
}

#pragma mark 卖家提醒
- (void)alertToSendGoods
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : _orderID,
        @"resNo" : self.dicDataSource[@"companyResourceNo"],
    };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyRemindDeliverUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_RemindSellerShippedSuccess")];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState) stringValue]] object:nil userInfo:nil];
                    //                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll) stringValue]] object:nil userInfo:nil];
                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
                }
            } else {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail")];
            }
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }
    }];

    [request start];
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (vc) {
        [self.navigationController pushViewController:vc animated:ani];
    }
}

#pragma mark - 获取订单详情
- (void)getOrderInfo
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : self.orderID };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyGetOrderInfoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    dicResult = dic[@"data"];
                    _day = kSaftToNSString([dicResult[@"day"] stringValue]);
                    _hour = kSaftToNSString([dicResult[@"hour"] stringValue]);
                    _status = kSaftToNSString([dicResult[@"status"] stringValue]);
                    _checkApply = [dicResult[@"checkApply"] boolValue];
                    _takeCode = kSaftToNSString(dicResult[@"takeCode"]);
                    _deliveryType = kSaftToNSString([dicResult[@"deliveryType"] stringValue]);
                    _indexRefund = kSaftToNSString(dicResult[@"orderClickRefund"]);
                    // songjk 互动进入处理
                    if (self.dicDataSource.count == 0) {
                        self.dicDataSource = [NSMutableDictionary dictionaryWithDictionary:dicResult];
                        [self.dicDataSource setValue:kSaftToNSString(dicResult[@"orderId"]) forKey:@"id"];
                        [self.dicDataSource setValue:kSaftToNSString(dicResult[@"totalPoints"]) forKey:@"totalPv"];
                        [self.dicDataSource setValue:kSaftToNSString(dicResult[@"actuallyAmount"]) forKey:@"total"];
                    }
                    NSString *resOldNo = kSaftToNSString([self.dicDataSource objectForKey:@"companyResourceNo"]);
                    if (resOldNo.length < 11) {
                        [self.dicDataSource setValue:kSaftToNSString(dicResult[@"companyResourceNo"]) forKey:@"companyResourceNo"];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self reloadData];
                        //显示二维码
                        UIImage *image = kLoadPng(@"gyhe_myhe_qrcoder");
                        CGRect backframe = CGRectMake(0, 0, image.size.width, image.size.height);
                        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
                        backButton.frame = backframe;
                        [backButton setBackgroundImage:image forState:UIControlStateNormal];
                        [backButton setTitle:@"" forState:UIControlStateNormal];
                        [backButton addTarget:self action:@selector(pushQRcoder:) forControlEvents:UIControlEventTouchUpInside];
                        UIBarButtonItem *btnSetting = [[UIBarButtonItem alloc] initWithCustomView:backButton];
                        self.navigationItem.rightBarButtonItem = btnSetting;
                    });
                } else {//返回失败数据
                    WS(weakSelf)
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CheckOrderDetailsFailure") confirm:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }
            } else {
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CheckOrderDetailsFailure") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        } else {
            WS(weakSelf)
            [GYUtils showMessage:[error localizedDescription] confirm:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    [request start];
}

//add by zhangqy  延时收货后，重新请求倒计时时间
- (void)refreshTimerNetworking
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : self.orderID };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyGetOrderInfoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    dicResult = dic[@"data"];
                    _day = kSaftToNSString([dicResult[@"day"] stringValue]);
                    _hour = kSaftToNSString([dicResult[@"hour"] stringValue]);
                    _status = kSaftToNSString([dicResult[@"status"] stringValue]);
                    _checkApply = [dicResult[@"checkApply"] boolValue];
                    _takeCode = kSaftToNSString(dicResult[@"√"]);
                    _deliveryType = kSaftToNSString([dicResult[@"deliveryType"] stringValue]);
                    [self setupTimerAndDelay];
                }
            }
        }
    }];
    [request start];
}

//订单二维码
- (void)pushQRcoder:(id)sender {
    GYEPOrderQRCoderViewController *qrCoder = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderQRCoderViewController class]));
    qrCoder.navigationItem.title = kLocalized(@"GYHE_MyHE_OrderTwo-dimensionalCode");
    qrCoder.orderID = self.orderID;
    [self pushVC:qrCoder animated:YES];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshAfterSaleListNotification" object:nil];
}

@end
