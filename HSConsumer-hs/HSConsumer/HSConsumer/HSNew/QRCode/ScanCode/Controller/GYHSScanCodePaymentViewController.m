//
//  GYHSScanCodePaymentViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScanCodePaymentViewController.h"
#import "GYHSCollectionCodeModel.h"
#import "GYHSQRPayModel.h"
#import "GYHSVoucherModel.h"
#import "GYHSScanCodeInfoTableViewCell.h"
#import "GYPasswordKeyboardView.h"
#import "IQKeyboardManager.h"
#import "Masonry.h"
#import "UIButton+GYTimeOut.h"
#import "NSString+YYAdd.h"
#import "GYHSHSBAccountInfoTableViewCell.h"
#import "GYHSPopView.h"
#import "GYHSPayLimitationSetViewController.h"

#define kScanCodeInfoCell @"ScanCodeInfoTableViewCell"
#define kHSBAccountInfo @"HSBAccountInfoTableViewCell"
#define kKeyBoardHeight kScreenWidth / 2

@interface GYHSScanCodePaymentViewController () <UITableViewDataSource, UITableViewDelegate, GYPasswordKeyboardViewDelegate, UITextFieldDelegate, GYHSSettingSuccessDategale>

@property (nonatomic, strong) UITableView* tabView;
@property (nonatomic, strong) NSArray* dataSourceArray;
@property (nonatomic, strong) NSArray* titleArray;
@property (nonatomic, strong) GYPasswordKeyboardView* keyboardView;
@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UIButton* submitButton; //提交按钮
@property (nonatomic, strong) UIButton* setupButton; //免密额度设置按钮
@property (nonatomic, strong) UILabel* tipLabel; //显示提示语Label
@property (nonatomic, copy) NSString* tipString; //提示语
@property (nonatomic, copy) NSString* amountStr; //互生币金额
@property (nonatomic, copy) NSString* pointRate; //积分比率
@property (nonatomic, assign) BOOL isFreePwdPay; //是否是免密支付
@property (nonatomic, assign) BOOL isSetFreePay; //是否设置了免密支付
@property (nonatomic, assign) BOOL isEnough; //互生币余额是否充足
@property (nonatomic, copy) NSString* restNum; //互生币账户余数
@property (nonatomic, copy) NSString* pointSum; //上传的积分总数

@end

@implementation GYHSScanCodePaymentViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.left.bottom.top.mas_equalTo(self.view);
    }];
    self.restNum = @"";
    if (self.paymentState == GYHSNearPaymentWay) {
        self.pointRate = [self calculatePointRate]; //得到积分比率；
    }
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.section > 0) {
        return nil;
    }
    if (indexPath.row == self.titleArray.count - 1) {
        GYHSHSBAccountInfoTableViewCell* accountCell = [tableView dequeueReusableCellWithIdentifier:kHSBAccountInfo forIndexPath:indexPath];
        accountCell.selectionStyle = UITableViewCellSelectionStyleNone;
        accountCell.titleLabel.text = self.titleArray[indexPath.row];
        accountCell.remainTagLabel.text = kLocalized(@"(互生币账户余数)");
        accountCell.contentLabel.text = self.dataSourceArray[indexPath.row];
        accountCell.remainNumLabel.text = self.restNum;
        return accountCell;
    }
    else {
        GYHSScanCodeInfoTableViewCell* infoCell = [tableView dequeueReusableCellWithIdentifier:kScanCodeInfoCell forIndexPath:indexPath];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        infoCell.titleLabel.text = self.titleArray[indexPath.row];
        if (self.isNeedInput) {
            if (indexPath.row == 1) {
                infoCell.contentTextField.enabled = YES;
                infoCell.isKeepDecimal = YES;
                infoCell.contentTextField.delegate = self;
                infoCell.contentTextField.placeholder = kLocalized(@"请输入金额");
                
            }
            else {
                infoCell.contentTextField.enabled = NO;
            }
        }
        infoCell.contentTextField.text = self.dataSourceArray[indexPath.row];
        return infoCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == self.titleArray.count - 1) {
        return 65.0f;
    }
    return 44.0f;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    //UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];

    [self.backView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
//        make.centerX.mas_equalTo(backView);
//        make.top.equalTo(backView).offset(5);
//        make.bottom.equalTo(backView).offset(0);
//        make.width.offset(210);
        make.top.left.bottom.right.mas_equalTo(self.backView);
    }];

    [self.backView addSubview:self.setupButton];
    [self.setupButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(self.backView).offset(-5);
        make.top.bottom.equalTo(self.backView).offset(0);
        make.width.offset(45);
    }];
    return self.backView;
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    double moneyNumber = kSaftToDouble(textField.text);
    NSString* hsCoinString = nil;
    BOOL isBlank = NO;
    NSString* inputString = [NSString stringWithFormat:@"%.2lf", moneyNumber];
    if (moneyNumber == 0) {
        isBlank = YES;
        self.dataSourceArray = @[ self.codeModel.entName, @"", @"", @"" ];
        [self setTableFooterView:YES];
    }
    else {
        
        hsCoinString = [NSString stringWithFormat:@"%.2lf", moneyNumber * globalData.custGlobalDataModel.currencyToHsbRate.doubleValue];
        NSString* pvString = [self calculatePvNum:[NSString stringWithFormat:@"%lf", moneyNumber * globalData.custGlobalDataModel.currencyToHsbRate.doubleValue]]; //没有直接用“hsCoinString”，是考虑到转换比率导致的精度问题
        if (globalData.loginModel.cardHolder) { //持卡人
            self.dataSourceArray = @[ self.codeModel.entName, inputString, [GYUtils formatCurrencyStyle:pvString.doubleValue], [GYUtils formatCurrencyStyle:hsCoinString.doubleValue]];
        }
        else {
            self.dataSourceArray = @[ self.codeModel.entName, inputString, [GYUtils formatCurrencyStyle:hsCoinString.doubleValue]];
        }
        
        self.codeModel.amount = hsCoinString; //将得到的互生币金额存入model中
    }
    self.amountStr = inputString;
    [self getAccountRestMoneyFromNet:isBlank withAmount:hsCoinString];
    
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    if (_keyboardView) {
        [_keyboardView dismiss];
        _keyboardView = nil;
    }
    if (_tipLabel) {
        _tipLabel.text = @"";
    }
    if (_setupButton) {
        _setupButton.hidden = YES;
    }
    if (self.submitButton) {
        //self.submitButton.backgroundColor = kCorlorFromRGBA(152, 153, 154, 1);
        //self.submitButton.enabled = NO;
        [self.submitButton removeFromSuperview];
    }
}

#pragma mark - GYPasswordKeyboardViewDelegate
- (void)returnPasswordKeyboard:(GYPasswordKeyboardView*)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString*)password
{

    if (password.length != 8) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }
    [self scanCodePaymentAction:[password md5String]];
}

- (void)returnCommitBtn:(UIButton*)button
{
    [button controlTimeOut];
}

- (void)cancelClick
{
    if ([self.delegate respondsToSelector:@selector(loadScanCodeInterface)]) {
        [self.delegate loadScanCodeInterface];
    }
}

#pragma mark - GYHSSettingSuccessDategale
- (void)settingQuotasSuccess
{
    [self queryPayLimitInfoFromNet:self.amountStr];
}

#pragma mark - private methods
- (void)initData
{

    if (self.paymentState == GYHSNearPaymentWay) {
        if ([self.codeModel.codeType isEqualToString:@"31"]) { //固定金额
            self.isNeedInput = NO;
        }
        else {
            self.isNeedInput = YES;
        }
    }
    else {
        self.isNeedInput = NO;
    }

    //NSString* amountStr = nil;
    if (!self.isNeedInput) {
        if (self.paymentState == GYHSNearPaymentWay) {
            self.amountStr = self.codeModel.amount;
        }
        else {
            self.amountStr = self.payModel.transAmount;
        }
    }
    [self getAccountRestMoneyFromNet:self.isNeedInput withAmount:self.amountStr];
}

/**
 *  设置tableFooterView
 *
 *  @param isBlank 是否有输入金额
 */
- (void)setTableFooterView:(BOOL)isBlank
{
    if (self.isNeedInput && isBlank) { //非固额且输入金额为空
        self.setupButton.hidden = YES;
        self.tabView.tableFooterView = [self createSubmitButton:NO];
        return;
    }
    if (self.isEnough) { //互生币账户余额是否充足
        if (!self.isSetFreePay) { //是否设置了免密支付额度
            [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
            self.tipLabel.text = kLocalized(@"可设置免密支付额度");
            self.setupButton.tag = 555;
            [self.setupButton mas_remakeConstraints:^(MASConstraintMaker* make) {
                make.right.equalTo(self.backView).offset(-5);
                make.top.bottom.equalTo(self.backView).offset(0);
                make.width.offset(45);
            }];
            [_setupButton setTitle:kLocalized(@"设置") forState:UIControlStateNormal];
            self.setupButton.hidden = NO;
            self.tabView.tableFooterView = [self addFooterView];
        }
        else {
            if (self.isFreePwdPay) {
                self.tipLabel.text = kLocalized(@"当前消费金额小于免密支付额度!");
                self.setupButton.hidden = YES;
                self.tabView.tableFooterView = [self createSubmitButton:YES];
            }
            else {
                [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
                self.tipLabel.text = kLocalized(@"当前消费金额大于免密支付额度!");
                self.setupButton.hidden = YES;
                self.tabView.tableFooterView = [self addFooterView];
            }
        }
        self.tipLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    else {
        self.setupButton.hidden = NO;
        self.tabView.tableFooterView = nil;

        NSMutableAttributedString* AttributedStr = [[NSMutableAttributedString alloc] initWithString:@"互生币账户余数不足以完成本次支付,兑换互生币"];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:kCorlorFromRGBA(102, 102, 102, 1) range:NSMakeRange(0, 17)];
        [AttributedStr addAttribute:NSForegroundColorAttributeName value:kCorlorFromRGBA(41, 132, 216, 1) range:NSMakeRange(17, 5)];

        self.tipLabel.attributedText = AttributedStr;
        self.tipLabel.font = [UIFont systemFontOfSize:12.0f];
        self.tipString = @"";
        self.setupButton.tag = 556;
        [self.setupButton mas_remakeConstraints:^(MASConstraintMaker* make) {
            make.top.left.bottom.right.mas_equalTo(self.backView);
        }];
        [self.setupButton setTitle:@"" forState:UIControlStateNormal];
    }
}

- (UIView*)addFooterView
{
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100 + kKeyBoardHeight)];
    [footerView addSubview:self.keyboardView];
    [self.keyboardView pop:footerView];
    return footerView;
}

/**
 *  创建提交按钮
 *
 *  @param isCanSubmit 是否能够提交
 *
 *  @return 背景View
 */
- (UIView*)createSubmitButton:(BOOL)isCanSubmit
{
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 41)];

    if (isCanSubmit) {
        self.submitButton.backgroundColor = kCorlorFromRGBA(30, 125, 215, 1);
        //self.submitButton.enabled = YES;
    }
    else {
        self.submitButton.backgroundColor = kCorlorFromRGBA(152, 153, 154, 1);
        //self.submitButton.enabled = NO;
    }

    [backView addSubview:self.submitButton];
    return backView;
}

//提交按钮点击事件
- (void)submitButtonClick:(UIButton*)sender
{
    if (kSaftToDouble(self.amountStr) <= 0 && self.isNeedInput) {
        [GYUtils showToast:kLocalized(@"请输入金额")];
        return;
    }
    [sender controlTimeOut];
    [self scanCodePaymentAction:nil];
}

//拼接pos机器终端类型
- (NSString*)getNewSourceNo:(NSString*)sourceNo
{
    if ([sourceNo hasPrefix:@"9"]) {
        return [sourceNo stringByAppendingString:@"3"];
    }
    else {
        return [@"3" stringByAppendingString:sourceNo];
    }
}

//设置按钮点击事件
- (void)setupButtonClick:(UIButton*)sender
{
    if (sender.tag == 555) {
        GYHSPopView* popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        GYHSPayLimitationSetViewController* vc = [[GYHSPayLimitationSetViewController alloc] init];
        vc.successDategale = self;
        vc.tradingPasswordType = GYHSTradingPasswordTypeModify;
        popView.hiddenCloseBtn = YES;
        [popView showView:vc withViewFrame:CGRectMake(20, 30, kScreenWidth - 40, 390)];
    }
    else {
        if ([self.delegate respondsToSelector:@selector(jumpToExchangeHSB)]) {
            [self.delegate jumpToExchangeHSB];
        }
    }
}

//查询互生币账户余额
- (void)getAccountRestMoneyFromNet:(BOOL)isBlank withAmount:(NSString*)amountStr
{
    if (!globalData.isLogined) {
        return;
    }
    NSDictionary* paramsDic = @{ @"accCategory" : kTypeHSDBalanceDetail,
        @"systemType" : kSystemTypeConsumer,
        @"custId" : globalData.loginModel.custId };

    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString parameters:paramsDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            self.restNum = @"";
            [self setTableFooterView:YES];
            return;
        }
        NSString *ltb = kSaftToNSString(responseObject[@"data"][@"ltbBalance"]);
        NSString *xfb = kSaftToNSString(responseObject[@"data"][@"xfbBalance"]);
        if (isBlank) {
            self.restNum = @"";
            [self setTableFooterView:YES];
        } else {
            self.restNum = [GYUtils formatCurrencyStyle:(ltb.doubleValue + xfb.doubleValue)];
            NSString *remainNum = [NSString stringWithFormat:@"%.2f", ltb.doubleValue + xfb.doubleValue];
            if (remainNum.doubleValue < amountStr.doubleValue) {
                self.isEnough = NO;
                [self setTableFooterView:NO];
            } else {
                self.isEnough = YES;
                
                [self queryPayLimitInfoFromNet:kSaftToNSString(amountStr)];
            }
        }
        [self.tabView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//查询互生币支付限额
- (void)queryPayLimitInfoFromNet:(NSString*)amountStr
{
    NSDictionary* allParas = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
        @"systemType" : kSystemTypeConsumer };
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHsbQueryPayLimitUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            self.isSetFreePay = NO;
            [self setTableFooterView:NO];
            return ;
        }
        NSString *isOpen = kSaftToNSString(responseObject[@"data"][@"payFreeMaxSwitch"]);
        if ([isOpen isEqualToString:@"Y"]) {
            self.isSetFreePay = YES;
            [self getFreePwdPayStateFromNet:amountStr];
        } else {
            self.isSetFreePay = NO;
            [self setTableFooterView:NO];
        }

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//查询免密支付状态
- (void)getFreePwdPayStateFromNet:(NSString*)amountStr
{
    NSDictionary* dict = @{ @"amount" : amountStr,
        @"custId" : globalData.loginModel.custId,
        @"channel" : @"0" };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:[HSReconsitutionUrl stringByAppendingString:@"/common/isFreePay"] parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            self.isFreePwdPay = NO;
            [self setTableFooterView:NO];
            return;
        }
        NSString *stateString = responseObject[@"data"][@"freePayType"];
        if ([stateString isEqualToString:@"0"]) {
            self.isFreePwdPay = YES;
        } else {
            self.isFreePwdPay = NO;
        }
        [self setTableFooterView:NO];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//计算积分比率
- (NSString*)calculatePointRate
{
    double maxPointRate = [self.codeModel.maxPointRate doubleValue];
    double minPointRate = [self.codeModel.minPointRate doubleValue];
    double resultRate = minPointRate;
    NSInteger randomX = 0;
    if (maxPointRate - minPointRate >= 0.0002) {
        randomX = arc4random() % 101;
        if (randomX < 50) {
            resultRate = minPointRate + randomX * (maxPointRate - minPointRate) / 75;
        }
        else {
            resultRate = minPointRate + (randomX + 50) * (maxPointRate - minPointRate) / 150;
        }
    }
    else if (maxPointRate - minPointRate >= 0.0001) {
        randomX = arc4random() % 100;
        if (randomX < 30) {
            resultRate = minPointRate;
        }
        else {
            resultRate = maxPointRate;
        }
    }
    else {
        resultRate = minPointRate;
    }
    NSLog(@"&&&&&&&----%d------>%lf", randomX, resultRate);
    return [NSString stringWithFormat:@"%.4lf", resultRate];
}

//扫码支付
- (void)scanCodePaymentAction:(NSString*)passWord
{
    kCheckLogined;
    [self.view endEditing:YES];

    WS(weakSelf)
        [GYGIFHUD show];
    //互生币支付transType 21000
    NSString* entResNo = nil;
    if (self.paymentState == GYHSNearPaymentWay) {
        entResNo = kSaftToNSString(self.codeModel.entResNo);
    }
    else {
        entResNo = kSaftToNSString(self.payModel.entResNo);
    }

    [Network GET:[HSReconsitutionUrl stringByAppendingString:@"/cardReader/sourceTransNo"] parameters:@{ @"entResNo" : kSaftToNSString(entResNo) } completion:^(id responseObject, NSError* error) {
        if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
            NSString *str = [self getNewSourceNo:responseObject[@"data"]];//拼接pos机器终端类型
            NSMutableDictionary *paramDic = [self setRequestBody:str];
            if (!self.isFreePwdPay && passWord) {
                [paramDic setValue:passWord forKey:@"tradePwd"];
            }
            
            [Network Post:[HSReconsitutionUrl stringByAppendingString:@"/customer/posPoint"]  parameters:paramDic completion:^(id responseObject, NSError *error) {
                [GYGIFHUD dismiss];
                
                if (!error && [responseObject[@"retCode"] isEqualToNumber:@200]) {
                    [GYUtils showMessage:@"消费积分成功!" confirm:^{
                        if ([weakSelf.delegate respondsToSelector:@selector(jumpToTradeVoucher:)]) {
                            GYHSVoucherModel *model = [[GYHSVoucherModel alloc] init];
                            model.date = kSaftToNSString(responseObject[@"data"][@"accountantDate"]);
                            model.hsbAmount = paramDic[@"transAmount"];
                            model.pvNum = [NSString stringWithFormat:@"%.2lf",floor([paramDic[@"pointSum"] doubleValue] * 0.5 * 100) / 100];
                            model.shopName = paramDic[@"entName"];
                            model.AmountNum = paramDic[@"sourceTransAmount"];
                            model.orderNum = kSaftToNSString(responseObject[@"data"][@"transNo"]);
                            
                            [weakSelf.delegate jumpToTradeVoucher:model];
                        }
                    } withColor:UIColorFromRGB(0x1d7dd6)];
                } else if (!error && [responseObject[@"retCode"] isEqualToNumber:@220]) {
                    [GYUtils showToast:kLocalized(@"GYHS_QR_thisDealIsPaid")];
                    if ([weakSelf.delegate respondsToSelector:@selector(loadMainInterface)]) {
                        [weakSelf.delegate loadMainInterface];
                    }
                } else {
                    [GYUtils showMessage:kErrorMsg confirm:nil withColor:UIColorFromRGB(0x1d7dd6)];//消费积分失败,请重试!
                    //[GYUtils showToast:kErrorMsg];
                }
            }];
        } else {
            [GYGIFHUD dismiss];
        }
    }];
}

- (NSMutableDictionary*)setRequestBody:(NSString*)str
{
    if (self.paymentState == GYHSNearPaymentWay) {
        //UUID截取
        NSString* strUDID = [GYUtils deviceUdid];
        strUDID = [strUDID substringToIndex:18];
        NSDictionary* tempParamDic = @{ @"transType" : @"21000",
            @"entResNo" : self.codeModel.entResNo,
            @"entCustId" : self.codeModel.entCustId,
            @"channelType" : @"4",
            @"sourceTransNo" : str,
            //@"sourcePosDate":[GYUtils dateToString:date],
            @"sourceCurrencyCode" : globalData.custGlobalDataModel.currencyCode,
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"pointRate" : self.pointRate,
            @"equipmentNo" : strUDID, //UUID截取
            @"sourceBatchNo" : [GYUtils dateToString:[NSDate date] dateFormat:@"yyyyMMdd"], //使用年月日
            @"perCustId" : globalData.loginModel.custId,
            @"entName" : self.codeModel.entName,
            @"equipmentType" : @"4",
            @"pointSum" : [NSString stringWithFormat:@"%.2lf", ceil(self.codeModel.amount.doubleValue * self.pointRate.doubleValue * 100) / 100], //积分金额 amount 与self.codemodel.miniPointrate乘法后做进一法
            @"transAmount" : self.codeModel.amount,
            @"sourceTransAmount" : [NSString stringWithFormat:@"%.2lf", self.codeModel.amount.doubleValue / globalData.custGlobalDataModel.currencyToHsbRate.doubleValue],
            @"qrCodeType" : self.codeModel.codeType,
            @"qrCode" : self.codeModel.codeId,
            @"qrCodeName" : self.codeModel.codeName
        };
        NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] initWithDictionary:tempParamDic];
        if (globalData.loginModel.cardHolder) {
            [paramDic setValue:globalData.loginModel.resNo forKey:@"perResNo"];
        }
        return paramDic;
    }
    else {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init]; //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyyMMddHHmmss"]; //设定时间格式,这里可以设置成自己需要的格式
        NSDate* date = [dateFormat dateFromString:self.payModel.date];
        NSDictionary* tempParamDic = @{ @"transType" : @"21000",
            @"entResNo" : self.payModel.entResNo,
            @"entCustId" : self.payModel.entCustId,
            @"channelType" : @"4",
            @"sourceTransNo" : str,
            @"sourcePosDate" : [GYUtils dateToString:date],
            @"sourceCurrencyCode" : self.payModel.currencyCode,
            @"userType" : kUserTypeCard,
            @"pointRate" : self.payModel.pointRate,
            //@"tradePwd":self.tradepwdTf.text.md5String,
            @"perResNo" : globalData.loginModel.resNo,
            @"equipmentNo" : self.payModel.posDeviceNo,
            @"sourceBatchNo" : self.payModel.batchNo,
            @"perCustId" : globalData.loginModel.custId,
            @"entName" : self.payModel.entName,
            @"equipmentType" : @"2",
            @"termRunCode" : self.payModel.voucherNo,
            @"pointSum" : self.payModel.acceptScore,
            @"qrCodeType" : self.codeType };
        NSMutableDictionary* paramDic = [[NSMutableDictionary alloc] initWithDictionary:tempParamDic];
        if (self.paymentState == GYHSOldPaymentWay) {
            [paramDic setValue:self.payModel.hsbAmount forKey:@"transAmount"];
            [paramDic setValue:self.payModel.tradeAmount forKey:@"sourceTransAmount"];
        }
        else {
            [paramDic setValue:self.payModel.transAmount forKey:@"transAmount"];
            [paramDic setValue:[@(self.payModel.transAmount.doubleValue / globalData.custGlobalDataModel.currencyToHsbRate.doubleValue) stringValue] forKey:@"sourceTransAmount"];
            [paramDic setValue:self.payModel.hsbAmount forKey:@"orderAmount"];
            [paramDic setValue:self.payModel.couponNum forKey:@"deductionVoucher"];
        }
        return paramDic;
    }
}

//计算积分数
- (NSString*)calculatePvNum:(NSString*)amountStr
{
    NSString* serveNum = [NSString stringWithFormat:@"%.2lf", ceil(amountStr.doubleValue * self.pointRate.doubleValue * 100) / 100]; //先做进一法
    NSString* finalPvNum = [NSString stringWithFormat:@"%.2lf", floor([serveNum doubleValue] * 0.5 * 100) / 100]; //再做去尾法
    return finalPvNum;
}

#pragma mark - lazyLoad
- (UITableView*)tabView
{
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.sectionFooterHeight = 40.0f;
        _tabView.backgroundColor = [UIColor whiteColor];
        _tabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        _tabView.delaysContentTouches = NO;
        [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSScanCodeInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:kScanCodeInfoCell];
        [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSHSBAccountInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:kHSBAccountInfo];
    }
    return _tabView;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        if (self.paymentState == GYHSOldPaymentWay) {
            _titleArray = @[ kLocalized(@"消费商家"), kLocalized(@"消费金额"), kLocalized(@"积分"), kLocalized(@"支付互生币") ];
        }
        else if (self.paymentState == GYHSNewPaymentWay) {
            _titleArray = @[ kLocalized(@"消费商家"), kLocalized(@"消费金额"), kLocalized(@"GYHS_QR_posDiscountCoupon"), kLocalized(@"积分"), kLocalized(@"支付互生币") ];
        }
        else {
            if (globalData.loginModel.cardHolder) {
                _titleArray = @[ kLocalized(@"消费商家"), kLocalized(@"消费金额"), kLocalized(@"积分"), kLocalized(@"支付互生币") ];
            }
            else {
                _titleArray = @[ kLocalized(@"消费商家"), kLocalized(@"消费金额"), kLocalized(@"支付互生币") ];
            }
        }
    }
    return _titleArray;
}

- (NSArray*)dataSourceArray
{

    if (!_dataSourceArray) {
        if (self.paymentState == GYHSOldPaymentWay) {
            _dataSourceArray = @[ self.payModel.entName, [GYUtils formatCurrencyStyle:self.payModel.tradeAmount.doubleValue], [NSString stringWithFormat:@"%.2f", self.payModel.acceptScore.doubleValue], [GYUtils formatCurrencyStyle:self.payModel.hsbAmount.doubleValue] ];
        }
        else if (self.paymentState == GYHSNewPaymentWay) {
            double allCouponNum = [self.payModel.couponNum integerValue] * [self.payModel.couponValue doubleValue];
            NSString* numberStr = nil;
            if (allCouponNum > 0) {
                numberStr = [NSString stringWithFormat:@"-%.2lf", allCouponNum];
            }
            else {
                numberStr = [NSString stringWithFormat:@"%.2lf", allCouponNum];
            }
            _dataSourceArray = @[ self.payModel.entName, [GYUtils formatCurrencyStyle:self.payModel.tradeAmount.doubleValue], numberStr, [GYUtils formatCurrencyStyle:floor(self.payModel.acceptScore.doubleValue * 0.5 * 100) / 100], [GYUtils formatCurrencyStyle:self.payModel.transAmount.doubleValue]];
        }
        else {
            if (globalData.loginModel.cardHolder) { //持卡人
                if (self.isNeedInput) {
                    _dataSourceArray = @[ self.codeModel.entName, @"", @"", @"" ];
                }
                else {
                    //double pvNum = floor((ceil(self.codeModel.amount.doubleValue * self.codeModel.minPointRate.doubleValue * 100) / 100) * 0.5 * 100) / 100;//先做进一法再做去尾法
                    double moneyNum = self.codeModel.amount.doubleValue / globalData.custGlobalDataModel.currencyToHsbRate.doubleValue;
                    _dataSourceArray = @[ self.codeModel.entName, [GYUtils formatCurrencyStyle:moneyNum], [GYUtils formatCurrencyStyle:[self calculatePvNum:self.codeModel.amount].doubleValue], [GYUtils formatCurrencyStyle:self.codeModel.amount.doubleValue]];
                }
            }
            else { //非持卡人无积分项
                if (self.isNeedInput) {
                    _dataSourceArray = @[ self.codeModel.entName, @"", @"" ];
                }
                else {
                    double moneyNum = self.codeModel.amount.doubleValue / globalData.custGlobalDataModel.currencyToHsbRate.doubleValue;
                    _dataSourceArray = @[ self.codeModel.entName, [GYUtils formatCurrencyStyle:moneyNum], [GYUtils formatCurrencyStyle:self.codeModel.amount.doubleValue]];
                }
            }
        }
    }
    return _dataSourceArray;
}

- (GYPasswordKeyboardView*)keyboardView
{
    if (!_keyboardView) {
        _keyboardView = [[GYPasswordKeyboardView alloc] init];
        _keyboardView.frame = CGRectMake(0, 0, kScreenWidth, 100 + kKeyBoardHeight);
        _keyboardView.style = GYPasswordKeyboardStyleTrading;
        _keyboardView.type = GYPasswordKeyboardReturnTypeCommit;
        _keyboardView.delegate = self;
    }
    return _keyboardView;
}

- (UILabel*)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.font = [UIFont systemFontOfSize:14.0f];
        _tipLabel.textColor = kNavigationBarColor;
    }
    return _tipLabel;
}

- (UIButton*)submitButton
{
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(15, 0, kScreenWidth - 30, 41);
        [_submitButton setTitle:kLocalized(@"支付") forState:UIControlStateNormal];
        _submitButton.layer.cornerRadius = 20.0f;
        [_submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

- (UIButton*)setupButton
{
    if (!_setupButton) {
        _setupButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //[_setupButton setTitle:kLocalized(@"设置") forState:UIControlStateNormal];
        _setupButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_setupButton setTitleColor:kCorlorFromRGBA(32, 127, 216, 1) forState:UIControlStateNormal];
        [_setupButton addTarget:self action:@selector(setupButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setupButton;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    }
    return _backView;
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
