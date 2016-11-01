//
//  GYDetailNextViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellSubCellHeight 24.f

#import "GYDetailsNextViewController.h"
#import "CellDetailRow.h"

#import "CellDetailTwoRow.h"
#import "GYAlertView.h"

@interface GYDetailsNextViewController () <UITableViewDataSource,
    UITableViewDelegate> {
    GlobalData* data; //全局单例
    NSArray* arrItmes_k_v; //row属性数组
    //    NSString *detailsUrlType;// 1为支付/撤单/退货明细数据 url ,其它为账户的明细URL
    //    NSInteger revokeReturnType;//撤单/退货类型
}
@property (strong, nonatomic) NSMutableArray* arrDataSource;
@property (strong, nonatomic) UITableView* tableView;
@end

@implementation GYDetailsNextViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        _rowAmountIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //实例化单例
    data = globalData;

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    CGFloat _y = 10; //距离父上下相距的视图y 10

    CGFloat statusH = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navBarH = self.navigationController.navigationBar.frame.size.height;
    CGFloat maxHeight = kScreenHeight - statusH - navBarH - 2 * 16; //ios6 限制当前详情界面的最大高度, 上下相距16

    BOOL scrEnable = NO;

    arrItmes_k_v = self.dicDetailsProperty[@"item_k_v"];

    if (arrItmes_k_v.count < 1) {
        [GYAlertView showMessage:kLocalized(@"GYHS_Common_No_Details") confirmBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }
    //    detailsUrlType = kSaftToNSString(self.dicDetailsProperty[@"details_url_type"]);
    //    revokeReturnType = kSaftToNSInteger(self.dicDetailsProperty[@"revoke_return_type"]);

    NSMutableArray* arrTwoRow = [NSMutableArray array];
    for (NSArray* arr in arrItmes_k_v) {
        for (NSString* a in arr) {
            if ([a isEqualToString:kLocalized(@"GYHS_Common_Business_Operation_SerialNumber")]) {
                [arrTwoRow addObject:a];
            }
        }
    }

    CGFloat backgroudViewHeight = arrItmes_k_v.count * kCellSubCellHeight + arrTwoRow.count * 30 + _y * 2;
    if (backgroudViewHeight > maxHeight) {
        backgroudViewHeight = maxHeight;
        scrEnable = YES;
    }

    CGRect tbvFrame = CGRectMake(self.view.frame.origin.x,
        _y,
        self.view.frame.size.width,
        backgroudViewHeight - _y * 2);
    //用于加载tableview的父视图
    UIView* backgroudView = [[UIView alloc] initWithFrame:CGRectMake(tbvFrame.origin.x,
                                                              16,
                                                              tbvFrame.size.width,
                                                              backgroudViewHeight)];
    [backgroudView setBackgroundColor:[UIColor whiteColor]];
    [backgroudView addTopBorderAndBottomBorder];
    [self.view addSubview:backgroudView];

    self.tableView = [[UITableView alloc] initWithFrame:tbvFrame style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.tableView setUserInteractionEnabled:scrEnable]; //控制子tableview是否可以滚动
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailRow" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailRowIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailTwoRow" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailTwoRowIdentifier];
    [backgroudView addSubview:self.tableView];

    DDLogInfo(@"dicDetailsProperty;%@", self.dicDetailsProperty);
    self.tableView.hidden = YES;

    //    if ([detailsUrlType isEqualToString:@"2"])// 货币转银行的查询流水号使用订单号
    //    {
    //        self.strTradeSn = kSaftToNSString(self.dicItem[@"srcOrderNo"]);
    //    }else if ([detailsUrlType isEqualToString:@"3"])// 货币转银行失败
    //    {
    //        self.strTradeSn = kSaftToNSString(self.dicItem[@"refOEvidence"]);
    //    }
    //系统平账转入 转出
    if ([self.dicItem[@"transType"] isEqualToString:@"X14000"] || [self.dicItem[@"transType"] isEqualToString:@"X11000"]) {
        self.arrDataSource = [NSMutableArray array];
        for (NSArray* keys in arrItmes_k_v) {

            NSString* flag = kSaftToNSString(keys[2]);
            NSString* title = kSaftToNSString(keys[1]);

            NSString* value = kSaftToNSString(keys[0]);
            if ([flag isEqualToString:@"0"]) {

                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : self.dicItem[@"sourceTransNo"] }];
            }
            else if ([flag isEqualToString:@"1"]) {
                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : self.dicItem[@"transDate"] }];
            }
            else if ([flag isEqualToString:@"2"]) {
                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : self.strTransString }];
            }
            else if ([flag isEqualToString:@"3"]) {
                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : value }];
            }
            else if ([flag isEqualToString:@"4"]) {
                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : value }];
            }
            else if ([flag isEqualToString:@"5"]) {
                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : self.dicItem[@"amount"] }];
            }
            else if ([flag isEqualToString:@"6"]) {
                [self.arrDataSource addObject:@{ @"title" : title,
                    @"value" : self.dicItem[@"remark"] }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.arrDataSource && self.arrDataSource.count > 0)
                    self.tableView.hidden = NO;

                [self.tableView reloadData];

            });
        }
    }
    else {
        [self get_details_info_new];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.arrDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell* nomalCell;
    CellDetailRow* cell = [tableView dequeueReusableCellWithIdentifier:kCellDetailRowIdentifier];
    CellDetailTwoRow* TwoRowCell = [tableView dequeueReusableCellWithIdentifier:kCellDetailTwoRowIdentifier];

    if (self.arrDataSource.count > indexPath.row && [self.arrDataSource[indexPath.row][@"title"] isEqualToString:kLocalized(@"GYHS_Common_Business_Operation_SerialNumber")]) {

        if (TwoRowCell == nil) {
            TwoRowCell = [[CellDetailTwoRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailTwoRowIdentifier];
        }
        TwoRowCell.lbTitle.text = self.arrDataSource[row][@"title"];
        TwoRowCell.lbValue.text = self.arrDataSource[row][@"value"];
        [TwoRowCell.lbTitle setTextColor:kCellItemTitleColor];
        [TwoRowCell.lbValue setTextColor:kCellItemTextColor];
        nomalCell = TwoRowCell;
    }
    else {
        if (!cell) {
            cell = [[CellDetailRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailRowIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //         if ([self.arrDataSource[indexPath.row][@"title"] isEqualToString:@"撤单转入金额"])
        //         {
        //             NSString * fee = self.arrDataSource[8][@"value"];
        //             NSString * inputAmount = self.arrDataSource[3][@"value"];
        //             cell.lbTitle.text = self.arrDataSource[row][@"title"];
        //             cell.lbValue.text = [NSString stringWithFormat:@"%ld",(fee.integerValue+inputAmount.integerValue)];
        //         }else
        //         {
        cell.lbTitle.text = self.arrDataSource[row][@"title"];
        cell.lbValue.text = self.arrDataSource[row][@"value"];
        //         }

        [cell setBackgroundColor:[UIColor clearColor]];

        [cell.lbTitle setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.lbValue setFont:[UIFont systemFontOfSize:14.0f]];
        [cell.lbTitle setTextColor:kCellItemTitleColor];
        [cell.lbValue setTextColor:kCellItemTextColor];
        nomalCell = cell;
    }

    NSArray* rowTitleHighlightedProperty = self.dicDetailsProperty[@"title_highlighted_property"];
    //设置title高亮的颜色
    if (rowTitleHighlightedProperty) {
        [rowTitleHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            if ([(NSArray *) obj count] > 1) {
                if ([cell.lbTitle.text isEqualToString:obj[0]]) {//Title的颜色
                    [cell.lbTitle setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];
                }
            }
        }];
    }
    else
        [cell.lbTitle setTextColor:kCellItemTitleColor];

    NSArray* rowValueHighlightedProperty = self.dicDetailsProperty[@"vaule_highlighted_property"];
    //设置value高亮的颜色
    if (rowValueHighlightedProperty) {
        [rowValueHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            if ([(NSArray *) obj count] > 1) {
                if ([cell.lbTitle.text isEqualToString:obj[0]]) {//value的颜色
                    [cell.lbValue setFont:[UIFont systemFontOfSize:16.0f]];
                    [cell.lbValue setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];

                    if ([(NSArray *) obj count] > 2 && [obj[2] boolValue]) {//为真是格式化货币值

                        NSString *value = [GYUtils formatCurrencyStyle:[cell.lbValue.text doubleValue]];
                        if ([cell.lbValue.text hasPrefix:@"+"]) {

                            value = [NSString stringWithFormat:@"+%@", value];

                        }


                        cell.lbValue.text = value;
                    }
                }
            }
        }];
    }
    else
        [cell.lbValue setTextColor:kCellItemTextColor];

    return nomalCell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat height = 0;

    if (self.arrDataSource.count > indexPath.row && [self.arrDataSource[indexPath.row][@"title"] isEqualToString:kLocalized(@"GYHS_Common_Business_Operation_SerialNumber")]) {

        height = 50;
    }
    else {
        height = kCellSubCellHeight;
    }

    return height;
}

#pragma mark - wangbb 获取详情的Url
- (NSString*)getDetailUrl
{
    NSString* strUrl;
    switch (self.detailsCode) {
    case kDetailsCode_Point:
        strUrl = kUrlQueryPointAccountDetail;
        break;

    case kDetailsCode_Cash:
        strUrl = kUrlQueryHbAccountDetail;
        break;

    case kDetailsCode_HSDToCash:
        strUrl = kUrlQueryHsbAccountDetailForLtb;
        break;

    case kDetailsCode_HSDToCon:
        strUrl = kUrlQueryHsbAccountDetailForXfb;
        break;

    case kDetailsCode_InvestPoint:
        strUrl = kUrlInvestBalanceDetail;
        break;

    case kDetailsCode_InvestDividends:
        strUrl = kUrlCViewInvestDividendInfo;
        break;

    case kDetailsCode_BusinessPro:
        strUrl = @"";
        break;

    case kDetailsCode_foods:
        strUrl = @"";
        break;

    default:
        break;
    }
    return strUrl;
}

- (NSDictionary*)getParamslDic
{
    NSDictionary* dic;
    switch (self.detailsCode) {
    case kDetailsCode_Point:
    case kDetailsCode_Cash:
    case kDetailsCode_HSDToCash:
    case kDetailsCode_HSDToCon: {
        dic = @{
            @"transNo" : kSaftToNSString(self.dicItem[@"transNo"]),
            @"transType" : self.dicItem[@"transType"],
            @"transSys" : self.dicItem[@"transSys"]
        };
    } break;
    case kDetailsCode_InvestPoint: {

        dic = @{ @"hsResNo" : @"",
            @"dividendYear" : @"",
            @"curPage" : @"" };
    } break;

    case kDetailsCode_InvestDividends: {

        dic = @{ @"hsResNo" : self.dicItem[@""],
            @"dateFlag" : @"",
            @"curPage" : @"" };
    }

    break;

    case kDetailsCode_BusinessPro:
        dic = @{

        };
        break;

    case kDetailsCode_foods:

        break;

    default:
        break;
    }
    return dic;
}

#if 0
//根据账户类型返回查询接口的参数
- (NSArray *)get_cmd_para_and_details_key {
    NSArray *p_k = @[@"", @""];
    switch (self.detailsCode) {
    case kDetailsCode_Point:
        if ([detailsUrlType isEqualToString:@"1"]) {  // 1为支付/撤单/退货明细数据 url
            p_k = @[@"get_pay_revoke_return_detail", [self revoke_return_type_string]];
        } else
            p_k = @[@"get_integral_act_trade_detail", @"integralTradeDetail"];

        break;

    case kDetailsCode_Cash:
        if ([detailsUrlType isEqualToString:@"2"]) {  // 货币转银行
            p_k = @[@"get_transfer_cash_to_bank_detail", @"result"];
        } else if ([detailsUrlType isEqualToString:@"3"]) { // 货币转银行失败
            p_k = @[@"get_transfer_cash_to_bank_fail_detail", @"result"];
        } else
            p_k = @[@"get_cash_act_trade_detail", @"cashTradeDetail"];

        break;

    case kDetailsCode_HSDToCash:

        if ([detailsUrlType isEqualToString:@"1"]) {  // 1为支付/撤单/退货明细数据 url
            p_k = @[@"get_pay_revoke_return_detail", [self revoke_return_type_string]];
        } else if ([detailsUrlType isEqualToString:@"4"]) {
            p_k = @[@"get_hsb_transfer_consume_trade_detail", [self revoke_return_type_string]];
        } else if ([detailsUrlType isEqualToString:@"5"]) {
            p_k = @[@"get_hsb_transfer_consume_trade_detail", [self revoke_return_type_string]];
        } else {
            p_k = @[@"get_hsb_transfer_cash_trade_detail", @"hsbTransferCashTradeDetail"];
        }
        break;

    case kDetailsCode_HSDToCon:
        if ([detailsUrlType isEqualToString:@"1"]) {  // 1为支付/撤单/退货明细数据 url
            p_k = @[@"get_pay_revoke_return_detail", [self revoke_return_type_string]];
        } else if ([detailsUrlType isEqualToString:@"5"]) {
            p_k = @[@"get_hsb_transfer_consume_trade_detail", [self revoke_return_type_string]];
        } else if ([detailsUrlType isEqualToString:@"4"]) {
            p_k = @[@"get_hsb_transfer_consume_trade_detail", [self revoke_return_type_string]];
        } else
            p_k = @[@"get_hsb_transfer_consume_trade_detail", @"hsbTransferConsumeTradeDetail"];
        break;

//        case kDetailsCode_InvestPoint:
//            p_k = @[@"get_invest_act_trade_list", @"investTradeList"];
//            break;

    case kDetailsCode_InvestDividends:
        p_k = @[@"get_invest_dividends_detail", @"data"];
        break;

    default:
        break;
    }
    return p_k;
}

- (NSArray *)revoke_return_type_string {
    NSArray *arrType = @[@[@"", @""],//占位
                         @[@"webOrderPayRefund", @"webOrderPay", @"comsumePointReFund", @"comsumePoint", @"others"],//1 网上订单支付退货, 网上订单支付退货原单，消费积分撤单，消费积分原单
                         @[@"hsbDealReFund", @"hsbDeal", @"comsumePointReFund", @"comsumePoint"],//2 互生币支付退货, 互生币支付退货原单，消费积分撤单，消费积分原单
                         @[@"webOrderDealRefund", @"webOrderPay"],//3 网上订单支付撤单, 网上订单支付撤单原单
                         @[@"hsbPayRefund", @"hsbDeal", @"comsumePointReFund", @"comsumePoint"],//4 互生币支付撤单, 互生币支付撤单原单，消费积分撤单，消费积分原单
                         @[@"comsumePointReFund", @"comsumePoint"],//5 消费积分撤单，消费积分原单
                         @[@"hsbDeal", @"comsumePoint"],//6 互生币支付，消费积分原单
                         @[@"webOrderPay", @"comsumePoint"],//7 网上订单支付，消费积分原单
                         @[@"comsumePoint", @"others"],//餐饮订单支付
                         @[@"comsumePoint", @"hsbTransferConsumeTradeDetail"],//餐厅定向币 退款
    ];
    if (revokeReturnType > arrType.count - 1) {
        return @[@"", @""];
    }
    return arrType[revokeReturnType];
}

#endif

#pragma mark - 接口重构  by zxm 20151230
- (void)get_details_info_new //获取详情
{
    NSDictionary* dict = [self getParamslDic];
    NSString* url = [self getDetailUrl];
    [Network GET:url parameters:dict completion:^(NSDictionary* responseObject, NSError* error) {
        if (!error) {
            NSDictionary *dic = responseObject;

            if ([dic [@"retCode"] isEqualToNumber:@200]) {  //返回成功数据
                dic = dic[@"data"];
                if ([dic isKindOfClass:[NSNull class]] || dic == nil || dic.count == 0) {
                    //无字段，返回
                    return;
                }


                self.arrDataSource = [NSMutableArray array];
                for (NSArray *keys in arrItmes_k_v) {

                    NSString *flag = kSaftToNSString(keys[2]);
                    NSString *title = kSaftToNSString(keys[1]);
                    NSString *value = kSaftToNSString(dic[keys[0]]);

                    //add by zxm 20160115
                    //格式化数字的小数点
                    if ([keys[0] isEqualToString:@"toCashAmt"]) {

                        value = [self formatString:value decimalPointNum:2];
                    } else if ([keys[0] isEqualToString:@"currencyRate"]) {

                        value = [self formatString:value decimalPointNum:4];

                    } else if ([keys[0] isEqualToString:@"exRate"]) {

                        value = [self formatString:value decimalPointNum:4];
                    } else if ([keys[0] isEqualToString:@"feeHsbAmt"]) {

                        value = [self formatString:value decimalPointNum:2];
                    } else if ([keys[0] isEqualToString:@"amount"]) {

                        value = [self formatString:value decimalPointNum:2];
                    } else if ([keys[0] isEqualToString:@"sourceTransAmount"]) {
                        //互生币支付退货金额--保留到小数点后两位
                        value = [self formatString:value decimalPointNum:2];
                    }
                    if ([keys[0] isEqualToString:@"sourcePoint"]) {
                        //互生币支付分配积分数--保留到小数点后两位
                        value = [self formatString:value decimalPointNum:2];
                    } else if ([keys[0] isEqualToString:@"transAmount"]) {
                        //消费金额
                        value = [self formatString:value decimalPointNum:2];
                    } else if ([keys[0] isEqualToString:@"perPoint"]) {
                        //撤单积分数
                        value = [self formatString:value decimalPointNum:2];
                    }


                    if ([flag isEqualToString:@"0"]) {  //直接取返回的key
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];
                    } else if ([flag isEqualToString:@"1"]) {//业务类别,收入或支出

                        if ([self.dicItem[@"businessType"] isEqualToNumber:@2]) {
                            //支出
                            value = [NSString stringWithFormat:@"-%@", value];
                        } else {
                            //收入
                            value = [NSString stringWithFormat:@"+%@", value];
                        }

                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];
                    } else if ([flag isEqualToString:@"2"]) {//交易类型,根据返回的transCode取对应的中文
//                            NSArray *transCode = [self.dicTransCodes[kSaftToNSString(dic[keys[0]])] componentsSeparatedByString:@","];
//                            value = transCode[0];
                        value = self.strTransString;
                        if (!value) {  //显示未知类型
                            DDLogInfo(@"明细详情数据，未知交易类型代码为:%@", kSaftToNSString(dic[keys[0]]));
                            value = self.dicTransCodes[@"UNKNOW_TYPE"][0];
                        }
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];
                    } else if ([flag isEqualToString:@"3"]) { //货币代码转成中文
                        NSString *c_key = [@"currency_code_" stringByAppendingString:kSaftToNSString(dic[keys[0]])];
                        NSString *strValue = self.dicCurrencyCodes[c_key];
                        if (!strValue) {  //显示未知类型
                            DDLogInfo(@"明细详情数据，未知货币类型代码为:%@", kSaftToNSString(dic[keys[0]]));
                            strValue = self.dicCurrencyCodes[@"currency_code_unknow"];
                        }
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":strValue}];
                    } else if ([flag isEqualToString:@"4"]) { //格式化时间
                        NSTimeInterval ti = [kSaftToNSString(dic[keys[0]]) doubleValue] / 1000;
                        NSDate *date = [NSDate dateWithTimeIntervalSince1970:ti];
                        NSString *strValue = [GYUtils dateToString:date dateFormat:@"yyyy-MM-dd HH:mm:ss"];
                        if ([strValue hasPrefix:@"1970-"]) {  //防止后台不厚道，有时返回毫秒时间，有返回格式化后的时间。
                            strValue = kSaftToNSString(dic[keys[0]]);
                        }
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":strValue}];
                    } else if ([flag isEqualToString:@"6"]) { //显示转入互生币（用于流通币）
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":[GYUtils formatCurrencyStyle:[self.dicItem[@"amount"] doubleValue]]}];
                    } else if ([flag isEqualToString:@"7"]) { //支付成功还是失败
                        NSString *value = [kSaftToNSString(dic[keys[0]]) lowercaseString];
                        //                                成功-N\失败-Y
                        NSString *str = kLocalized(@"GYHS_Common_Transfer_Successfully");
                        if ([value isEqualToString:@"y"]) {
                            str = kLocalized(@"GYHS_Common_Deal_With_Failure");
                        }
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":str}];
                    } else if ([flag isEqualToString:@"99"]) {
                        //                                NSString *value = [kSaftToNSString(dic[keys[0]]) lowercaseString];
                        //                                成功-N\失败-Y
                        NSString *str = kLocalized(@"GYHS_Common_Accept_Success");

                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":str}];
                    } else if ([flag isEqualToString:@"8"]) {//用于退货，撤单的撤销金额(退货金额)
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":kSaftToNSString(dic[@"transAmount"])}];
                    } else if ([flag isEqualToString:@"36"]) { //货币提现扣除转账手续费
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"sourceTransNo"]}];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"transDate"]}];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"transType"]}];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"amount"]}];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"remark"]}];
                    } else if ([flag isEqualToString:@"9"]) { //用于货币转银行状态

                        NSString *value = kSaftToNSString(dic[keys[0]]);

                        NSString *str = @"unknow";
                        if ([value isEqualToString:@"-1"]) {
                            str = kLocalized(@"GYHS_Common_ToBe_Submitted_ToBank");
                        } else if ([value isEqualToString:@"-99"]) {
                            str = kLocalized(@"GYHS_Common_Trading_Errors");
                        } else if ([value isEqualToString:@"1000"]) {
                            str = kLocalized(@"GYHS_Common_Drawal_Success");
                        } else if ([value isEqualToString:@"1001"]) {
                            str = kLocalized(@"GYHS_Common_Drawal_Failure");
                        } else if ([value isEqualToString:@"1002"]) {
                            str = kLocalized(@"GYHS_Common_In_Dealing_With_TheBank");
                        } else if ([value isEqualToString:@"1003"]) {
                            str = kLocalized(@"GYHS_Common_HS_BeRefund");
                        }


                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":str}];
                    } else if ([flag isEqualToString:@"10"]) { //写死的，显示配置key在value上
                        NSString *value = kSaftToNSString(keys[0]);
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];
                    } else if ([flag isEqualToString:@"11"]) { //当地结算货币，取登录返回的全局参数
                        NSString *value = globalData.custGlobalDataModel.currencyName;
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];
                    } else if ([flag isEqualToString:@"12"]) { //从传过来item的获取
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":kSaftToNSString(self.dicItem[keys[0]])}];
                    } else if ([flag isEqualToString:@"13"]) { //货币兑换互生币 受理方式
                        NSDictionary *dicTypes = @{@"WEB":kLocalized(@"GYHS_Common_HS_WebTerminal"),
                                                   @"POS":kLocalized(@"GYHS_Common_POS_Terminal"),
                                                   @"MCR":kLocalized(@"GYHS_Common_MCRTerminal"),
                                                   @"MOBILE":kLocalized(@"GYHS_Common_MOBILETerminal"),
                                                   @"HSPAD":kLocalized(@"GYHS_Common_PAD"),
                                                   @"SYS":kLocalized(@"GYHS_Common_SYSTerminal"),
                                                   @"IVR":kLocalized(@"GYHS_Common_IVRTerminal"),
                                                   @"SHOP":kLocalized(@"GYHS_Common_ManagementPlatform")};
                        NSString *_k = kSaftToNSString(dic[keys[0]]);
                        [self.arrDataSource addObject:@{
                             @"title":title,
                             @"value":kLocalized(@"GYHS_Common_ManagementPlatform")
                         }];
                    } else if ([flag isEqualToString:@"14"]) { //积分
                        if ([dic[@"payMode"] isEqualToString:@"MIX_PAY"]) {
                            [self.arrDataSource addObject:@{@"title":title,
                                                            @"value":@"--"}];
                        } else {
                            [self.arrDataSource addObject:@{@"title":title,
                                                            @"value":kSaftToNSString(dic[keys[0]])}];
                        }
                    } else if ([flag isEqualToString:@"15"]) { //积分
                        float toAmountFloat = [kSaftToNSString(dic[keys[0]]) floatValue];

                        NSString *toAmountStr = [NSString stringWithFormat:@"%.2f", toAmountFloat];

                        [self.arrDataSource addObject:@{@"title":title, @"value":toAmountStr}];

                    } else if ([flag isEqualToString:@"100"]) { //add by zxm20160202 在金额全面增加“+”

                        value = [NSString stringWithFormat:@"+%@", value];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];


                    } else if ([flag isEqualToString:@"101"]) { //add by zxm20160202 在金额全面增加“+”
                        value = [NSString stringWithFormat:@"-%@", value];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];

                    } else if ([flag isEqualToString:@"26"]) { //消费积分 添加支付方式字段
                        NSString *paymentStr = self.dicItem[@"transType"];
                        paymentStr = [paymentStr substringWithRange:NSMakeRange(2, 1)];
                        if ([paymentStr isEqualToString:@"1"]) {
                            value = kLocalized(@"GYHS_Common_HSB_Pay");
                        } else if ([paymentStr isEqualToString:@"2"]) {
                            value = kLocalized(@"GYHS_Common_Bank_Pay");
                        } else if ([paymentStr isEqualToString:@"3"]) {
                            value = kLocalized(@"GYHS_Common_Cash_Payments");
                        }
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];
                    } else if ([flag isEqualToString:@"16"]) { //积分
                        NSString *value;
                        if ([self.dicItem[@"businessType"] isEqualToNumber:@2]) {
                            //支出
                            value = kLocalized(@"GYHS_Common_Spending");
                        } else {
                            //收入
                            value = kLocalized(@"GYHS_Common_Income");
                        }
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];


                    } else if ([flag isEqualToString:@"28"]) { //显示免费医疗与伤害保障的时间字段（用于流通币）
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"transDate"]}];
                    } else if ([flag isEqualToString:@"17"]) {//显示列表与详情界面的流水号字段（用于流通币）
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":self.dicItem[@"sourceTransNo"]}];
                    } else if ([flag isEqualToString:@"18"]) {//积分转互生币 发生积分数字段（用于流通币）
                        value = [NSString stringWithFormat:@"-%@", value];
                        [self.arrDataSource addObject:@{@"title":title,
                                                        @"value":value}];

                    }


                }

            } else { //返回失败数据
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHS_Common_Failed_Get_Details") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        } else {
            [GYUtils showMessage:[error localizedDescription]];
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.arrDataSource && self.arrDataSource.count > 0)
                self.tableView.hidden = NO;

            [self.tableView reloadData];


        });

    }];
}

/**
 *   Input:str:传入的数字字符串(eg:@"100") decimalPointNum:需要的小数点位数(eg:2)
 *   Output:100.00
 */
- (NSString *)formatString:(NSString *)str decimalPointNum:(NSInteger)decimalPointNum {

    if (decimalPointNum == 4) return [NSString stringWithFormat:@"%.4f", [str doubleValue]];
    else return [NSString stringWithFormat:@"%.2f", [str doubleValue]];

}

@end
