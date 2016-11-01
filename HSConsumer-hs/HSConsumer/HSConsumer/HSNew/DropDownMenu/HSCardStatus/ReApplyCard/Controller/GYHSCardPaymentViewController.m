//
//  GYHSCardPaymentViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCardPaymentViewController.h"
#import "IQKeyboardManager.h"
#import "GYPasswordKeyboardView.h"
#import "GYHSMakeUpCardInfoTableViewCell.h"
#import "GYHSMakeUpCardPaymentTableViewCell.h"
#import "GYHSMakeUpCardOtherPayView.h"
#import "libPayecoPayPlugin.h"
#import "NSString+YYAdd.h"
#import "UIButton+GYTimeOut.h"

#define kInfoCell @"MakeUpCardInfoTableViewCell"
#define kPaymentCell @"MakeUpCardPaymentTableViewCell"
#define kKeyBoardHeight kScreenWidth / 2

@interface GYHSCardPaymentViewController () <UITableViewDataSource,UITableViewDelegate,GYPasswordKeyboardViewDelegate,PayEcoPpiDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) GYPasswordKeyboardView *keyboardView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, copy) NSString *retainMoney;
@property (nonatomic, assign) BOOL isEnough;
// 易联支付类
@property (nonatomic, strong) PayEcoPpi* payEcoPpi;

@end

@implementation GYHSCardPaymentViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.retainMoney = @"-";
    [self initView];
    [self accountInfoRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        GYHSMakeUpCardInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kInfoCell forIndexPath:indexPath];
//        infoCell.orderNumLabel.text = kSaftToNSString(self.orderNo);
//        infoCell.payMoneyLabel.text = [GYUtils formatCurrencyStyle:kSaftToNSString(self.realMoney).doubleValue];
//        return infoCell;
//    } else {
        GYHSMakeUpCardPaymentTableViewCell *paymentCell = [tableView dequeueReusableCellWithIdentifier:kPaymentCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            paymentCell.titleLabel.text = kLocalized(@"支付金额");
            paymentCell.imgView.hidden = YES;
            paymentCell.contentLabel.text = [GYUtils formatCurrencyStyle:kSaftToNSString(self.realMoney).doubleValue];
            paymentCell.contentLabel.textColor = [UIColor redColor];
        } else {
            paymentCell.titleLabel.text = kLocalized(@"互生币支付");
            paymentCell.imgView.hidden = NO;
            NSString *moneyStr = [GYUtils formatCurrencyStyle:kSaftToNSString(self.retainMoney).doubleValue];
            paymentCell.contentLabel.text = [NSString stringWithFormat:@"%@%@",kLocalized(@"余额"),moneyStr];
        }
        paymentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return paymentCell;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableViewDelegate

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 100.0f;
//    } else {
//        return 44.0f;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 1) {
//        return 35.0f;
//    }
//    return 15.0f;
    return 35.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    GYHSMakeUpCardOtherPayView *otherView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSMakeUpCardOtherPayView class]) owner:self options:nil] firstObject];
    otherView.backgroundColor = [UIColor clearColor];
    
    if (self.isEnough) {
        otherView.chooseOtherWayLabel.text = kLocalized(@"选择其他支付方式:");
        otherView.chooseOtherWayLabel.textColor = [UIColor blackColor];
    } else {
        otherView.chooseOtherWayLabel.text = kLocalized(@"互生币账户余额不足,请选择:");
        otherView.chooseOtherWayLabel.textColor = [UIColor redColor];
    }
    
    [otherView.paymentWayButton setTitle:kLocalized(@"认证卡支付") forState:UIControlStateNormal];
    [otherView.paymentWayButton addTarget:self action:@selector(chooseOtherPaymentMethodsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return otherView;

}

#pragma mark -GYPasswordKeyboardViewDelegate
-(void)returnPasswordKeyboard:(GYPasswordKeyboardView *)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString *)password {
    
    if (password.length != 8) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }

    [self makeUpCardLoadDataFromNetwork:password];
    
}

-(void)returnCommitBtn:(UIButton *)button {
    [button controlTimeOut];
}

- (void)cancelClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"互生卡补办");
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    [self.view addSubview:self.tabView];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMakeUpCardInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:kInfoCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSMakeUpCardPaymentTableViewCell class]) bundle:nil] forCellReuseIdentifier:kPaymentCell];
    
}

- (void)accountInfoRequest {
    NSDictionary *parameterDic = @{ @"accCategory" : kTypeHSDBalanceDetail,
                                    @"systemType" : kSystemTypeConsumer,
                                    @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString
                                                     parameters:parameterDic
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           //网络请求错误
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       //NSString *xfbBalance = kSaftToNSString(responseObject[@"data"][@"xfbBalance"]);
                                                       NSString *ltbBalance = kSaftToNSString(responseObject[@"data"][@"ltbBalance"]);
                                                        self.retainMoney = [NSString stringWithFormat:@"%.2f", [ltbBalance doubleValue]];
                                                       if (kSaftToDouble(self.retainMoney) < kSaftToDouble(self.realMoney)) {
                                                           self.isEnough = NO;
                                                       } else {
                                                           self.isEnough = YES;
                                                       }
                                                       
                                                       //[self setTableHeaderViewWithRetainMoney:self.retainMoney];
                                                       [self.tabView reloadData];
                                                       self.tabView.tableFooterView = [self addFooterView];
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//余额不够时的头部显示
- (void)setTableHeaderViewWithRetainMoney:(NSString *)retainMoney {
    if (kSaftToDouble(retainMoney) < kSaftToDouble(self.realMoney)) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        headerView.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        backView.backgroundColor = kCorlorFromRGBA(250, 255, 213, 1);
        [headerView addSubview:backView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        tipLabel.center = CGPointMake(backView.center.x + 20, backView.center.y);
        tipLabel.text = kLocalized(@"GYHE_SC_AccountNotEnoughToChooseOtherWay");
        tipLabel.textColor = [UIColor redColor];
        tipLabel.font = [UIFont systemFontOfSize:14.0f];
        [backView addSubview:tipLabel];
        
        CGFloat imageX = (tipLabel.frame.origin.x - 20) > 0 ? tipLabel.frame.origin.x - 20 : 0;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, 13, 15, 15)];
        imgView.image = [UIImage imageNamed:@"msg_fail"];
        [backView addSubview:imgView];
        self.tabView.tableHeaderView = headerView;
    } else {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        headerView.backgroundColor = [UIColor clearColor];
        self.tabView.tableHeaderView = headerView;
    }
}

- (void)makeUpCardLoadDataFromNetwork:(NSString *)passWordStr {
    NSMutableDictionary *allParas = [NSMutableDictionary dictionary];
    
    [allParas setValue:kSaftToNSString(self.orderNo) forKey:@"orderNo"];
    [allParas setValue:kSaftToNSString(@"200") forKey:@"payChannel"];
    [allParas setValue:[passWordStr md5String] forKey:@"tradePwd"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kUserTypeCard forKey:@"userType"];
    
    [GYGIFHUD show];
    
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSCardMendCardPayUrlString
                                                     parameters:allParas
                                                  requestMethod:GYNetRequestMethodPOST
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary *responseObject, NSError *error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           NSInteger errorRetCode = [error code];
                                                           if (errorRetCode == -9000) {
                                                               [GYUtils showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability") confirm:^{
                                                                   [self.navigationController popViewControllerAnimated:YES];
                                                               }];
                                                           } else {
                                                               DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                               [GYUtils parseNetWork:error resultBlock:nil];
                                                           }
                                                           return;
                                                       }
                                                       
                                                       [GYUtils showMessage:kLocalized(@"GYHE_SC_YourOrderPaySuccess") confirm:^{
                                                           [self.navigationController popToRootViewControllerAnimated:YES];
                                                       }];
                                                   }];
    request.noShowErrorMsg = YES;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

-( void)chooseOtherPaymentMethodsAction {
    [self queryEcoPpiOrder];
}

- (void)queryEcoPpiOrder
{
    NSDictionary* paramDic = @{
                               @"operateCode" : kGYHSXT_BS_0001,
                               @"orderNo" : kSaftToNSString(self.orderNo),
                               @"transAmount" : self.realMoney,
                               @"key" : kSaftToNSString(globalData.loginModel.token)
                               };
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kUrlPayOperateOrderInfo parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if (errorRetCode == -9000) {
                [GYUtils showMessage:kLocalized(@"GYHE_SC_ServiceUnavailability") confirm:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                return;
            }
            if ( errorRetCode == 6011)
            {
                [GYUtils showToast:kErrorMsg];
                return ;
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
        [self.navigationController popToRootViewControllerAnimated:YES];
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


#pragma mark - lazyLoad
- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
        _tabView.backgroundColor = kDefaultVCBackgroundColor;
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.sectionHeaderHeight = 0.1f;
        _tabView.sectionFooterHeight = 15.0f;
        
        _tabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        //_tabView.tableFooterView = [self addFooterView];
        _tabView.delaysContentTouches = NO;
    }
    return _tabView;
}

-(UIView *)addFooterView {
    if (self.isEnough) {
        self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,100 + kKeyBoardHeight)];
        [self.footerView addSubview:self.keyboardView];
        [self.keyboardView pop:self.footerView];
    } else {
        self.footerView = nil;
    }
    return self.footerView;
}

- (GYPasswordKeyboardView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[GYPasswordKeyboardView alloc] init];
        _keyboardView.frame = CGRectMake(0, 0, kScreenWidth, 100 + kKeyBoardHeight);
        _keyboardView.style = GYPasswordKeyboardStyleTrading;
        _keyboardView.type = GYPasswordKeyboardReturnTypeCommit;
        _keyboardView.colorType = GYPasswordKeyboardCommitColorTypeRed;
        //[keyboardView settingInputView:];
        _keyboardView.delegate = self;
        //[_keyboardView pop:self.footerView];
    }
    return _keyboardView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
