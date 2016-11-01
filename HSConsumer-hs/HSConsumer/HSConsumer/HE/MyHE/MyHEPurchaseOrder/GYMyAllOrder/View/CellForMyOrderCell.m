//
//  CellForMyOrderCell.m
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellForMyOrderCell.h"
#import "ViewHeaderForMyOrder.h"
#import "ViewFooterForMyOrder.h"
#import "CellForMyOrderSubCell.h"

#import "GYEPSaleAfterApplyForViewController.h" //售后申请
#import "GYEPOrderDetailViewController.h" //订单详情
#import "UIButton+GYExtension.h"
#import "EasyPurchaseData.h"
#import "GYEasyBuyModel.h"
#import "GYOrderRefundDetailsViewController.h" //退款详情
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYPaymentConfirmViewController.h"

//#import "GYStoreDetailViewController.h"
#import "GYShopDescribeController.h"
#import "GYDeliverGoodsViewController.h" //发货
#import "GYGIFHUD.h"
#import "NSObject+HXAddtions.h"
#import "GYAlertView.h"

@interface CellForMyOrderCell () <UITableViewDataSource, UITableViewDelegate> {
    ViewHeaderForMyOrder* vHeader;
    ViewFooterForMyOrder* vFooter;
    NSInteger orderState;
    BOOL isShowTrash;
    NSArray* arrDataSource;
    NSString* orderNo;
    //    NSString *orderID;//暂时去掉
}
@end

@implementation CellForMyOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kDefaultVCBackgroundColor;
        vHeader = [[ViewHeaderForMyOrder alloc] init];
        [vHeader.lbState setTextColor:kValueRedCorlor];
        [vHeader.lbOrderNo setTextColor:kCorlorFromHexcode(0x8C8C8C)];
        vHeader.lbOrderNo.font = [UIFont systemFontOfSize:14];
        [GYUtils setFontSizeToFitWidthWithLabel:vHeader.lbOrderNo labelLines:1];
        [vHeader.btnTrash addTarget:self action:@selector(btnTrashClick:) forControlEvents:UIControlEventTouchUpInside];
        //        vHeader.btnTrash.hidden=YES;
        [GYUtils setFontSizeToFitWidthWithLabel:vHeader.lbState labelLines:1];
        vHeader.lbOrderNo.hidden = YES; //UI更改，不显示
        [vHeader addTopBorder];

        [vHeader.btnShopName setTitleColor:kCorlorFromHexcode(0x5A5A5A) forState:UIControlStateNormal];
        [vHeader.btnShopName addTarget:self action:@selector(btnShopNameClick:) forControlEvents:UIControlEventTouchUpInside];
        [vHeader.btnShopName2 addTarget:self action:@selector(btnShopNameClick:) forControlEvents:UIControlEventTouchUpInside];

        vFooter = [[ViewFooterForMyOrder alloc] init];
        [vFooter.lbLabelMoney setTextColor:kCorlorFromHexcode(0x8C8C8C)];

        [vFooter.footClickBtn addTarget:self action:@selector(pushToDetailAfterSales) forControlEvents:UIControlEventTouchUpInside];

        [GYUtils setFontSizeToFitWidthWithLabel:vFooter.lbMoneyAmount labelLines:2];
        [GYUtils setFontSizeToFitWidthWithLabel:vFooter.lbPointAmount labelLines:1];
        [GYUtils setFontSizeToFitWidthWithLabel:vFooter.btn0.titleLabel labelLines:1];
        [GYUtils setFontSizeToFitWidthWithLabel:vFooter.btn1.titleLabel labelLines:1];

        [vFooter.lbPointAmount setTextColor:kCorlorFromHexcode(0x008CD2)];
        vFooter.lbPointAmount.font = [UIFont systemFontOfSize:15];
        vFooter.lbMoneyAmount.font = [UIFont systemFontOfSize:15];
        vFooter.lbMoneyAmount.textColor = kCorlorFromHexcode(0x464646);
        [vFooter addBottomBorder];
        [vFooter setBottomBorderInset:YES];

        CGRect tbvFrame = CGRectMake(0, 0, kScreenWidth, CGRectGetHeight(vHeader.frame) + CGRectGetHeight(vFooter.frame) + 10);
        self.tableView = [[UITableView alloc] initWithFrame:tbvFrame style:UITableViewStylePlain];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView setScrollEnabled:NO];
        self.tableView.tableHeaderView = vHeader;
        self.tableView.tableFooterView = vFooter;
        [self addSubview:self.tableView];

        //        self.arrDataSource = [NSMutableArray array];
        [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForMyOrderSubCell class]) bundle:kDefaultBundle] forCellReuseIdentifier:kCellForMyOrderSubCellIdentifier];

        isShowTrash = YES; //Trash显示的初始状态
    }
    return self;
}

- (void)showTrash:(BOOL)isShow
{
    if (isShowTrash != isShow) { //tableview的复用
        CGRect lbStateFrame = vHeader.lbState.frame;
        CGFloat _x = CGRectGetMaxX(vHeader.btnTrash.frame) - CGRectGetMinX(vHeader.viewLine.frame) + 14;
        if (isShow)
            lbStateFrame.size.width -= _x;
        else
            lbStateFrame.size.width += _x;
        vHeader.lbState.frame = lbStateFrame;
    }
    isShowTrash = isShow;
    vHeader.viewLine.hidden = !isShow;
    vHeader.btnTrash.hidden = !isShow;

    if (vHeader.viewLine.hidden == YES && vHeader.btnTrash.hidden == YES) {
        vHeader.lbStateConstraint.constant = 15;
    }
    else {
        vHeader.lbStateConstraint.constant = 65;
    }

    //调整商城名称宽度
    CGFloat _shopName_X = 5; //商城名称与箭头之间的间隔
    CGRect btnShopNameFrame = vHeader.btnShopName.frame;
    CGRect btnShopNameFrame2 = vHeader.btnShopName2.frame;
    CGFloat maxWidth = CGRectGetMinX(vHeader.lbState.frame) - CGRectGetMinX(vHeader.btnShopName.frame) - 3;
    CGFloat maxShopNameWidth = maxWidth - btnShopNameFrame2.size.width - _shopName_X;

    NSString* str = [vHeader.btnShopName titleForState:UIControlStateNormal];

    CGSize strSize = [str boundingRectWithSize:CGSizeMake(MAXFLOAT, vHeader.btnShopName.titleLabel.frame.size.width) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{ NSFontAttributeName : vHeader.btnShopName.titleLabel.font } context:nil].size;
    if (strSize.width > maxShopNameWidth) {
        strSize.width = maxShopNameWidth;
    }

    btnShopNameFrame.size.width = strSize.width;
    btnShopNameFrame2.origin.x = CGRectGetMaxX(btnShopNameFrame) + _shopName_X;
    vHeader.btnShopName.frame = btnShopNameFrame;
    vHeader.btnShopName2.frame = btnShopNameFrame2;
}

- (void)reloadData
{
    //先移除之前的方法；
    [vFooter.btn0 removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [vFooter.btn1 removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [vFooter.btn0 setHidden:YES];
    [vFooter.btn1 setHidden:YES];

    //    再次购买是加入购物车
    UIColor* cGray = kCorlorFromRGBA(150, 150, 150, 1);
    UIColor* cRed = kCorlorFromRGBA(250, 60, 40, 1);
    /*
    kOrderStateCancelBySystem = -1,//系统取消订单
    kOrderStateWaittingPay = 0, //待买家付款
    kOrderStateHasPay = 1,      //买家已付款
    kOrderStateWaittingDelivery = 2,        //待发货
    kOrderStateWaittingConfirmReceiving = 3,//待确认收货
    kOrderStateFinished = 4,//交易成功
    kOrderStateClosed = 5,  //交易关闭
    kOrderStateWaittingPickUpCargo = 6, //待自提
    kOrderStateWaittingSellerSendGoods = 7, //待商家送货
    kOrderStateCancelPaidOrderByBuyer = 97,//买家退款退货//取消已经支付的订单
    kOrderStateCancelBySeller = 98,//商家取消订单
    kOrderStateCancelByBuyer = 99,//买家已取消
    kOrderStateAll = 1000       //全部订单
 */
    arrDataSource = self.dicDataSource[@"items"];
    orderState = kSaftToNSInteger(self.dicDataSource[@"status"]);

    vHeader.btnShopName.titleLabel.numberOfLines = 1;
    [vHeader.btnShopName setTitle:
                             [NSString stringWithFormat:@"%@", kSaftToNSString(self.dicDataSource[@"virtualShopName"])]
                         forState:UIControlStateNormal];

    if (self.isSaleAfter == YES) { //判断 售后申请 和退换货记录vFooter显示的情况

        vHeader.orderNumberConstraint.constant = 200;
        [vHeader.btnShopName.titleLabel setTextColor:kCorlorFromHexcode(0x8C8C8C)];
        vHeader.btnShopName.titleLabel.font = [UIFont systemFontOfSize:14];
        if (self.isQueryRefundRecord == YES) {
            vFooter.lbLabelMoney.text = kLocalized(@"GYHE_MyHE_RefundMoney");
            vFooter.backPVLabel.hidden = NO;
            vFooter.lbLabelMoney.hidden = NO;
            vFooter.scoreLabelDistanceLeft.constant = 80;
            //            vFooter.pvLabelDistanceLeft.constant = 80;
            vHeader.lbstateDistanceTop.constant = 28;
            vHeader.stateDistanceTop.constant = 6;
        }
        else {
            vFooter.lbLabelMoney.text = kLocalized(@"GYHE_MyHE_RealPays");
            vFooter.backPVLabel.hidden = YES;
            vFooter.lbLabelMoney.hidden = NO;
            vFooter.scoreLabelDistanceLeft.constant = 68;
            //            vFooter.pvLabelDistanceLeft.constant = 68;
        }
    }
    if (self.isQueryRefundRecord) {
        orderNo = kSaftToNSString(self.dicDataSource[@"id"]);
        [vHeader.btnShopName setTitle:
                                 [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_MyHE_Order_Number"), kSaftToNSString(self.dicDataSource[@"number"])]
                             forState:UIControlStateNormal];
        vHeader.btnShopName.titleLabel.font = [UIFont systemFontOfSize:14];
        vHeader.refundTypeLabel.font = [UIFont systemFontOfSize:16];
        vHeader.orderNumberDistaceTopConstraint.constant = 7;

        if (orderState == kOrderRefundStateWaittingBuyersDelivery) {

            vFooter.deliverBtn.hidden = NO;

            [vFooter.deliverBtn addTarget:self action:@selector(deliverClick) forControlEvents:UIControlEventTouchUpInside];
        }
        else {

            vFooter.deliverBtn.hidden = YES;
        }

        switch (kSaftToNSInteger(self.dicDataSource[@"refundType"])) {
        case 1: {
            vHeader.refundTypeLabel.text = [NSString stringWithFormat:@"【%@】", kLocalized(@"GYHE_MyHE_RetunGoods")];
        } break;
        case 2: {

            vHeader.refundTypeLabel.text = [NSString stringWithFormat:@"【%@】", kLocalized(@"GYHE_MyHE_OnlyRefuseReturnMoney")];
        } break;
        case 3: {

            vHeader.refundTypeLabel.text = [NSString stringWithFormat:@"【%@】", kLocalized(@"GYHE_MyHE_ChangeGoods")];
        } break;
        default:
            break;
        }
    }
    else {
        orderNo = kSaftToNSString(self.dicDataSource[@"number"]);
        [self showTrash:YES];
    }

    //    add by zhangx  判断是否进入售后显示

    if (self.isSaleAfter) {

        //修改订单编号--zcx
        [vHeader.btnShopName setTitle:
                                 //         [NSString stringWithFormat:@"%@:%@",kLocalized(@"order_num"), kSaftToNSString(arrDataSource[0][@"orderDetailId"])] forState:UIControlStateNormal];

                                 [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_MyHE_Order_Number"), kSaftToNSString(self.dicDataSource[@"number"])]
                             forState:UIControlStateNormal];

        [vHeader.buttonArrow setHidden:YES]; //我的售后时成功，隐藏删除按钮
    }
    else {

        [vHeader.buttonArrow setHidden:NO]; //购物订单时成功，显示删除按钮
    }

    //    kOrderStateCancelBySystem = -1,//取消订单
    //    kOrderStateWaittingPay = 0, //待买家付款
    //    kOrderStateHasPay = 1,      //买家已付款
    //    kOrderStateWaittingDelivery = 2,        //商家备货中
    //    kOrderStateWaittingConfirmReceiving = 3,//待确认收货
    //    kOrderStateFinished = 4,//交易成功
    //    kOrderStateClosed = 5,  //交易关闭
    //    kOrderStateWaittingPickUpCargo = 6, //待自提、已备货待提
    //    kOrderStateWaittingSellerSendGoods = 7, //待商家送货、商家备货中
    //    kOrderStateSellerWaittingPayConfirm = 8, //企业待支付确认、待收货
    //    kOrderStateSellerPreparingGoods = 9, //待备货
    //    kOrderStateSellerCancelOrder = 10, //已申请取消订单
    //    kOrderStateCancelPaidOrderByBuyer = 97,//买家退款退货//取消已经支付的订单
    //    kOrderStateCancelBySeller = 98,//商家取消订单
    //    kOrderStateCancelByBuyer = 99,//买家已取消
    //    kOrderStateAll = 1000       //全部订单

    switch (orderState) {
    case kOrderStateWaittingPay: //待买家付款
        [vFooter.btn0 setHidden:NO];
        [vFooter.btn1 setHidden:NO];

        [vFooter.btn0 setBackgroundColor:kClearColor];
        [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
        [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [vFooter.btn0 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        [vFooter.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

        [vFooter.btn1 setBackgroundColor:kClearColor];
        [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_ImmediatePayment") forState:UIControlStateNormal];
        [vFooter.btn1 addTarget:self action:@selector(btnPayClick:) forControlEvents:UIControlEventTouchUpInside];

        vFooter.btn0DistanceTopConstraint.constant = 49;
        vFooter.btn1DistanceTopConstraint.constant = 14;

        [self showTrash:NO];

        break;
    case kOrderStateHasPay: //买家已付款
    case kOrderStateWaittingDelivery: //待发货
    case kOrderStateWaittingSellerSendGoods: //待商家送货
        [vFooter.btn1 setHidden:NO];
        [vFooter.btn0 setHidden:NO];
        [vFooter.btn1 setBackgroundColor:kClearColor];
        [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_RemindDelivery") forState:UIControlStateNormal];
        [vFooter.btn1 addTarget:self action:@selector(alertToSendGoods) forControlEvents:UIControlEventTouchUpInside];

        [vFooter.btn0 setBackgroundColor:kClearColor];
        [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
        [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [vFooter.btn0 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
        [vFooter.btn0 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

        vFooter.btn0DistanceTopConstraint.constant = 49;
        vFooter.btn1DistanceTopConstraint.constant = 14;

        [self showTrash:NO];

        break;

    case kOrderStateWaittingPickUpCargo: //待自提
    {
        BOOL isPostPay = [kSaftToNSString(self.dicDataSource[@"isPostPay"]) boolValue]; //是否货到付款
        if (isPostPay) { //货到付款kOrderStateWaittingPickUpCargo
            [vFooter.btn1 setHidden:NO];

            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            //                [vFooter.btn0 setHidden:NO];
            [vFooter.btn1 setHidden:NO];

            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];

            //                [vFooter.btn1 setBackgroundColor:kClearColor];
            //                [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            //                [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            //                [vFooter.btn1 setTitle:kLocalized(@"确认收货") forState:UIControlStateNormal];
            //                [vFooter.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];
        }

        [self showTrash:NO];
    } break;

    case kOrderStateWaittingConfirmReceiving: //待确认收货
        [vFooter.btn1 setHidden:NO];
        [vFooter.btn1 setBackgroundColor:kClearColor];
        [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_ConfirmReachGoods") forState:UIControlStateNormal];
        [vFooter.btn1 addTarget:self action:@selector(btnConfirmClick:) forControlEvents:UIControlEventTouchUpInside];

        [self showTrash:NO];
        //add by zhangqy 延时收货按钮
        [vFooter.btn0 setHidden:NO];
        [vFooter.btn0 setBackgroundColor:kClearColor];
        [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
        [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
        [vFooter.btn0 setTitle:kLocalized(@"GYHE_MyHE_DelayDelivery") forState:UIControlStateNormal];
        [vFooter.btn0 addTarget:self action:@selector(btnDelayClick:) forControlEvents:UIControlEventTouchUpInside];
        BOOL checkApplay = [self.dicDataSource[@"checkApply"] boolValue];
        if (!checkApplay) {
            vFooter.btn0.hidden = YES;
        }
        vFooter.btn0DistanceTopConstraint.constant = 49;
        vFooter.btn1DistanceTopConstraint.constant = 14;

        break;
    case kOrderStateFinished: //交易成功
    {

        if (!self.isQueryRefundRecord) {
            [vFooter.btn0 setHidden:NO];
            [vFooter.btn1 setHidden:NO];

            [vFooter.btn0 setBackgroundColor:kClearColor];
            [vFooter.btn0 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn0 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
            [vFooter.btn0 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_ApplyAfterSales") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnSaleAfterClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        if (self.isSaleAfter) {

            [self showTrash:NO];
        }
        else {

            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_ApplyAfterSales") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnSaleAfterClick:) forControlEvents:UIControlEventTouchUpInside];
            [vFooter.btn0 setBackgroundColor:kClearColor];
            [vFooter.btn0 setTitleColor:cRed forState:UIControlStateNormal];
            [vFooter.btn0 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [vFooter.btn0 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
            [vFooter.btn0 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];

            vFooter.btn0DistanceTopConstraint.constant = 14;
            vFooter.btn1DistanceTopConstraint.constant = 49;

            [self showTrash:YES];
        }

    } break;
    case kOrderStateSellerPreparingGoods: //待备货
    {
        if (!self.isQueryRefundRecord) {

            [vFooter.btn0 setHidden:YES];
            [vFooter.btn1 setHidden:NO];

            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cGray forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cGray];
            [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_Cancel") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
        }

        [self showTrash:NO];
    } break;

    case kOrderStateClosed: //交易关闭
        [vFooter.btn1 setHidden:NO];
        [vFooter.btn1 setBackgroundColor:kClearColor];
        [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
        [vFooter.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];

        [self showTrash:YES];

        break;

    case kOrderStateCancelBySeller: //商家取消订单
    case kOrderStateCancelByBuyer: //买家已取消
    case kOrderStateCancelBySystem: //系统取消订单kOrderStateSellerCancelOrder
        [vFooter.btn1 setHidden:NO];
        [vFooter.btn1 setBackgroundColor:kClearColor];
        [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
        [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
        [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_BuyAgain") forState:UIControlStateNormal];
        [vFooter.btn1 addTarget:self action:@selector(btnBuyAgainClick:) forControlEvents:UIControlEventTouchUpInside];

        [self showTrash:YES];

        break;

    default:
        [self showTrash:NO];

        break;
    }

    if (self.isQueryRefundRecord) {
        [vFooter.btn0 setHidden:YES]; //隐藏
        [vFooter.btn1 setHidden:YES]; //隐藏
        [vHeader.lbState setText:[EasyPurchaseData getOrderRefundStateString:orderState]];
        if (orderState == kOrderRefundStateSellerDisAgree || orderState == kOrderRefundStateCancelAppling) {
            [self showTrash:NO];
            vHeader.refundTypeLabel.hidden = NO;
        }
        else {
            [self showTrash:NO];
            //   在这里进行退换货状态判断
            vHeader.lbStateConstraint.constant = 15;

            vHeader.refundTypeLabel.hidden = NO;
        }

        if (orderState == kOrderRefundStateWaittingbuyerConfirmReceiving) {

            vFooter.btn1.hidden = NO;

            [vFooter.btn1 setHidden:NO];
            [vFooter.btn1 setBackgroundColor:kClearColor];
            [vFooter.btn1 setTitleColor:cRed forState:UIControlStateNormal];
            [vFooter.btn1 setBorderWithWidth:1.0 andRadius:2.0 andColor:cRed];
            [vFooter.btn1 setTitle:kLocalized(@"GYHE_MyHE_ConfirmReachGoods") forState:UIControlStateNormal];
            [vFooter.btn1 addTarget:self action:@selector(btnRefConfirmReceipt) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else{
        
        [vHeader.lbState setText:[EasyPurchaseData getOrderStateString:orderState]];
        if (orderState == kOrderStateWaittingConfirmReceiving) {
            vHeader.refundTypeLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_MyHE_%@Day%@HoursConfirmByItself"),kSaftToNSString(self.dicDataSource[@"day"]) ,kSaftToNSString(self.dicDataSource[@"hour"])];
            vHeader.refundTypeLabel.font = [UIFont systemFontOfSize:13];
            vHeader.refundTypeLabel.hidden = NO;
            vHeader.stateDistanceTop.constant = 28;
            vHeader.lbstateDistanceTop.constant = 6;
        }else{
            vHeader.lbstateDistanceTop.constant = 15;
            vHeader.stateDistanceTop.constant = 6;
            vHeader.refundTypeLabel.hidden = YES;
        }
    }
    
    [vHeader.lbOrderNo setText:[NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_MyHE_Order_Number"), orderNo]];
    if (self.isSaleAfter == YES && self.isQueryRefundRecord == YES) {
        vFooter.lbMoneyAmount.text = [GYUtils formatCurrencyStyle:[self.dicDataSource[@"refundPrice"] doubleValue]];

    }else{
        vFooter.lbMoneyAmount.text = [GYUtils formatCurrencyStyle:[self.dicDataSource[@"total"] doubleValue]];

    }
       vFooter.lbPointAmount.text = [GYUtils formatCurrencyStyle:[self.dicDataSource[@"totalPv"] doubleValue]];
    [self.tableView reloadData];
}

#pragma mark - 延时收货
- (void)btnDelayClick:(UIButton*)btn
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_WhetherDelayReceipt") confirm:^{
        [self delayOrder];
    } cancleBlock:^{

    }];
}

- (void)delayOrder
{
    
    NSDictionary* allParas = @{ @"key" : globalData.loginModel.token,
                                @"orderId" : self.dicDataSource[@"id"]
                                };
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:DelayDeliverUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
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
                    [self.delegate performSelector:@selector(headerRereshing)];
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_DelayReceivingApplicationSuccessful")];
                    
                } else {//返回失败数据
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_DelayOperationFailed")];
                    vFooter.btn0.hidden = YES;
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

#pragma mark - 取消订单
- (void)btnCancelClick:(id)sender
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_WetherCancelOrder") confirm:^{
        
        [self cancelOrder];
    } cancleBlock:^{
    }];
}

#pragma mark 提醒发货
- (void)alertToSendGoods
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : orderNo,
        @"resNo" : self.dicDataSource[@"companyResourceNo"] };

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

- (void)cancelOrder
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : orderNo };

    [GYGIFHUD showFullScreen];
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyCancelOrderUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            [GYGIFHUD dismiss];
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    
                    NSString *string = kSaftToNSString(self.dicDataSource[@"status"]);
                    if ([string isEqualToString:@"0"] || [string isEqualToString:@"9"]) {//商家备货中提示
                        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_CancelOrderSuccess")];
                    } else {
                        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OrderHaveCommitPleaseWait")];
                        
                    }
                    
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
    DDLogDebug(@"立即付款");

    GYPaymentConfirmViewController* vc = [[GYPaymentConfirmViewController alloc] init];
    vc.paymentMode = GYPaymentModeWithGoods;
    vc.orderNO = kSaftToNSString(self.dicDataSource[@"number"]);
    vc.realMoney = kSaftToNSString(self.dicDataSource[@"total"]);
    vc.navigationItem.title = kLocalized(@"GYHE_MyHE_PayCinfirm");
    vc.isFromOrderList = YES;
    vc.discount = kSaftToNSString(self.dicDataSource[@"activityAmount"]);
    vc.orderMoney = [NSString stringWithFormat:@"%.2lf", [vc.realMoney doubleValue] + [vc.discount doubleValue]];
    [self pushVC:vc animated:YES];
}

#pragma mark - 确认收货
- (void)btnConfirmClick:(id)sender
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_PleassConfirmReceiptGoods") confirm:^{
        
        [self confirmReceipt];

    } cancleBlock:^{

    }];
}

#warning 孙秋明注释 接口的请求方式有问题
- (void)confirmReceipt
{
    GlobalData* data = globalData;
    NSArray* orderNos = @[ orderNo ];
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderIds" : [orderNos componentsJoinedByString:@","] //多个订单使用,分隔
    };

    [GYGIFHUD showFullScreen];
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyConfirmReceiptUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
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
                    //去刷新吧
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

#pragma mark - 售后申请
- (void)btnSaleAfterClick:(id)sender
{
    GYEPSaleAfterApplyForViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPSaleAfterApplyForViewController class]));
    vc.dicDataSource = self.dicDataSource;
    vc.navigationItem.title = kLocalized(@"GYHE_MyHE_AfterSales");
    [self pushVC:vc animated:YES];
}

#pragma mark - 售后确认收货
- (void)btnRefConfirmReceipt
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_PleassConfirmReceiptGoods") confirm:^{
        [self confirmReceiptGoods];
    } cancleBlock:^{

    }];
}

- (void)confirmReceiptGoods
{

    NSDictionary* allParas = @{ @"key" : kSaftToNSString(globalData.loginModel.token),
        @"orderId" : kSaftToNSString(self.dicDataSource[@"number"]),
        @"refId" : kSaftToNSString(orderNo) };

    [GYGIFHUD showFullScreen];
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:EasyBuyrefConfirmReceiptUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        
        if (!error) {
            
            if ([responseObject[@"retCode"] integerValue] == 200) {
                
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_ConfirmReceiptSuccess") confirm:^{
                    
                }];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState)stringValue]] object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll)stringValue]] object:nil userInfo:nil];
                
                
            } else {
                
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail") confirm:^{
                    
                }];
            }
        } else {
            
            [GYUtils showMessage:kLocalized(@"GYHE_MyHE_OpearateFail") confirm:^{
                
            }];
        }

        
    }];
    [request start];

}

#pragma mark - 再次购买
- (void)btnBuyAgainClick:(id)sender
{
    [self buyAgain];
    DDLogDebug(@"再次购买");
}

- (void)buyAgain
{
    GlobalData* data = globalData;

    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"sourceType" : @"2",
        @"orderId" : orderNo };

    [GYGIFHUD show];
    
    GYNetRequest *requst = [[GYNetRequest alloc]initWithBlock:EasyBuyAgainBuyUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        
        if (error) {
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_GoodsUnderFrame")];
                return;
            }else if ([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]){
                [GYUtils showMessage:kLocalized(@"GYHE_MyHE_shopClocePleaseTryLater")];
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
                        
                        UIViewController *vcCart = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
                        [self pushVC:vcCart animated:YES];
                        
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
    [requst start];
}

#pragma mark - 删除订单
- (void)btnTrashClick:(id)sender
{
    [GYUtils showMessge:kLocalized(@"GYHE_MyHE_WhetherDeleteOrder") confirm:^{
        
        [self deleteOrder];

    } cancleBlock:^{

    }];
}

- (void)deleteOrder
{
    GlobalData* data = globalData;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"orderId" : orderNo };
    NSString* appendUrl = EasyBuyDeleteOrderUrl;

    if (_isQueryRefundRecord) { //删除售后记录
        allParas = @{ @"key" : globalData.loginModel.token,
            @"refId" : orderNo };
        appendUrl = EasyBuyDeleteRefundUrl;
    }

    [GYGIFHUD showFullScreen];
    
    GYNetRequest *request = [[GYNetRequest alloc]initWithBlock:appendUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        
        if (!error) {
            NSDictionary *dic = responseObject;
            if (!error) {
                if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) {//返回成功数据
                    //去刷新吧
                    [GYUtils showMessage:kLocalized(@"GYHE_MyHE_DeleteSuccess")];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(orderState)stringValue]] object:nil userInfo:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:[kNotificationNameRefreshOrderList stringByAppendingString:[@(kOrderStateAll)stringValue]] object:nil userInfo:nil];
                    
                    [GYGIFHUD dismiss];
                    
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

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav) {

        [self.nav pushViewController:vc animated:ani];
    }
}

#pragma mark - Table view data source and delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    NSInteger isRefund = kSaftToNSInteger([self.dicDataSource objectForKey:@"orderClickRefund"]);
    if (isRefund == 1) { //判断售后状态，为1时候隐藏按钮
        vFooter.btn1.hidden = YES;
    }

    return arrDataSource.count; //[self.dicDataSource[@"items"] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    NSInteger row = indexPath.row;
    CellForMyOrderSubCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellForMyOrderSubCellIdentifier];

    if (!cell) {
        cell = [[CellForMyOrderSubCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellForMyOrderSubCellIdentifier];
    }

    [cell.viewContentBkg setBottomBorderInset:row == arrDataSource.count - 1 ? YES : NO];

    NSString* imgUrl = kSaftToNSString(arrDataSource[row][@"url"]);
    [cell.ivGoodsPicture setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kLoadPng(@"gycommon_image_placeholder") options:kNilOptions completion:nil];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToGoodsDetail:)];
    cell.ivGoodsPicture.tag = row;
    [cell.ivGoodsPicture addGestureRecognizer:tap];

    cell.lbGoodsName.text = kSaftToNSString(arrDataSource[row][@"title"]);
    cell.lbGoodsPrice.text = [NSString stringWithFormat:@"%.02f", [(arrDataSource[row][@"price"])doubleValue]];
    cell.lbGoodsCnt.text = [NSString stringWithFormat:@"x %@", arrDataSource[row][@"count"]];
    cell.lbGoodsProperty.text = kSaftToNSString(arrDataSource[row][@"desc"]);

    if (self.isQueryRefundRecord) {

        cell.pvImgView.hidden = YES;

        cell.pvLabel.hidden = YES;

        //        cell.pvLabel.text=kSaftToNSString(self.dicDataSource[@"totalPv"]);
        cell.pvLabel.text = [GYUtils formatCurrencyStyle:kSaftToDouble((arrDataSource[row][@"subPoints"]))];
        
    
    }

    //    cell.accessoryType = UITableViewCellAccessoryNone;
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat minHeight = 60;

    return self.cellSubCellRowHeight > minHeight ? self.cellSubCellRowHeight : minHeight;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    UIViewController* vcs = nil;
    if (self.isQueryRefundRecord) {
        GYOrderRefundDetailsViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYOrderRefundDetailsViewController class]));
        switch (kSaftToNSInteger(self.dicDataSource[@"refundType"])) {
        case 1: //换货详情
        {
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_RefundShopDetails");
        } break;
        case 2: { //退款详情
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_RefundDetails");
        } break;
        case 3: { //退货详情
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_RefundChangeShopDetails");
        } break;
        default:
            break;
        }

        vc.orderID = orderNo;
        vc.myOrderId = self.dicDataSource[@"number"];
        //        vc.refId = orderNo  ;
        vcs = vc;
    }
    else {
        GYEPOrderDetailViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
        vc.orderID = orderNo;
        vc.dicDataSource = [NSMutableDictionary dictionaryWithDictionary:self.dicDataSource];
        vc.delegate = self.delegate;
        vc.navigationItem.title = kLocalized(@"GYHE_MyHE_OrderDetail");
        // add by songjk
        if (arrDataSource.count > indexPath.row) {
            vc.vShopId = arrDataSource[indexPath.row][@"vShopId"];
            vc.itemId = arrDataSource[indexPath.row][@"id"];
        }
        if (!vc.vShopId || vc.vShopId.length == 0) {
            vc.vShopId = [self.dicDataSource objectForKey:@"virtualShopId"];
        }
        vcs = vc;
    }

    if (vcs) {
        [self pushVC:vcs animated:YES];
    }
}

#pragma mark--点击footer进入售后详情
- (void)pushToDetailAfterSales
{

    UIViewController* vcs = nil;
    if (self.isQueryRefundRecord) {
        GYOrderRefundDetailsViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYOrderRefundDetailsViewController class]));
        switch (kSaftToNSInteger(self.dicDataSource[@"refundType"])) {
        case 1: //换货详情
        {
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_RefundShopDetails");
        } break;
        case 2: { //退款详情
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_RefundDetails");
        } break;
        case 3: { //退货详情
            vc.navigationItem.title = kLocalized(@"GYHE_MyHE_RefundChangeShopDetails");
        } break;
        default:
            break;
        }
        vc.orderID = orderNo;
        vc.myOrderId = self.dicDataSource[@"number"];
//        vc.refId = orderNo  ;
        vcs = vc;
        if (vcs) {
            [self pushVC:vcs animated:YES];
        }
    }
}

- (void)pushToGoodsDetail:(UITapGestureRecognizer *)tap {
    UIImageView *imgv = (UIImageView *)tap.view;

    GYEasyBuyModel *mod = [[GYEasyBuyModel alloc] init];

    mod.strGoodId = arrDataSource[imgv.tag][@"id"];
    ShopModel *shopInfo = [[ShopModel alloc] init];
    shopInfo.strShopId = arrDataSource[imgv.tag][@"vShopId"];
    if (!shopInfo.strShopId || shopInfo.strShopId.length == 0) {
        shopInfo.strShopId = [self.dicDataSource objectForKey:@"virtualShopId"];
    }
    mod.shopInfo = shopInfo;

    GYEasybuyGoodsInfoViewController* vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYEasybuyGoodsInfoViewController class]));
    GYEasyBuyModel *model = mod;
    vcGoodDetail.itemId = model.strGoodId;
    vcGoodDetail.vShopId = model.shopInfo.strShopId;
    [self pushVC:vcGoodDetail animated:YES];
    
}

#pragma mark - 发货
- (void)deliverClick {

    GYDeliverGoodsViewController *vc = [[GYDeliverGoodsViewController alloc] init];
    if (self.isQueryRefundRecord) {
        orderNo = kSaftToNSString(self.dicDataSource[@"id"]);
        vc.applyId = orderNo;
    }
    [self pushVC:vc animated:YES];
}

@end
