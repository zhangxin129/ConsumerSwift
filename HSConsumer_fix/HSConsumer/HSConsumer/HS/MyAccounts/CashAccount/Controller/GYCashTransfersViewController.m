//
//  GYCashTransfersViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYCashTransfersViewController.h"
#import "InputCellStypeView.h"
#import "GYHSConfirmTransferInfoVC.h"
#import "GYAlertView.h"
#import "GYHSCardBandModel.h"

#import "GYHSLoginViewController.h"
#import "GYAddressData.h"
#import "GYHSLoginManager.h"

#import "GYHSImageTitleNumberCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSTowLabelButtonCell.h"
#import "GYHSTableViewWarmCell.h"
#import "GYHSButtonCell.h"
#import "GYHSBindBankCardListVC.h"
#import "GYCashAccountViewController.h"
#import "GYNoRegisterForSkipViewController.h"
#import "GYHSAddBankCardInfoVC.h"

@interface GYCashTransfersViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate, GYHSBindBankCardListVCDelegate> {
    GlobalData* data; //全局单例
    double inputValue; //转现的金额
    NSString* bankID;
    NSString* _bankNum;
}
@property (nonatomic, strong) UITableView* cashTransTableView;
@property (nonatomic, strong) GYHSCardBandModel* model;
@property (nonatomic, copy) NSString* userName;
@property (nonatomic, strong) NSMutableArray* arrPassStrings;
@property (nonatomic, copy) NSArray* titleArray;
@property (nonatomic, copy) NSArray* warArray;
@property (nonatomic, copy) NSString* integral;
@property (nonatomic, assign)CGFloat labelheight;
@property (nonatomic,copy)NSString *RealName;//非持卡人姓名

@end

@implementation GYCashTransfersViewController
#pragma mark--网络请求  //查询是否有默认银行卡
- (void)getBackListFromNetwork
{
    kCheckLogined
        NSDictionary* dict = @{
            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
            @"custId" : kSaftToNSString(globalData.loginModel.custId)
        };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlListBindBank parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
    request.tag = 1;
}
- (void)get_cash_act_info_new //现金账户信息
{
    kCheckLogined
        NSDictionary* dict = @{ @"accCategory" : kTypeCashBalanceDetail,
            @"systemType" : kSystemTypeConsumer,
            @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
    request.tag = 2;
}
- (void)requestData
{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"userId"];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kHSGetInfo parameters:params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 3;
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    if (request.tag == 1) {
        NSArray* arrData = responseObject[@"data"];
        for (NSDictionary* tempDic in arrData) {
            if ([tempDic[@"isDefault"] isEqualToString:@"1"]) {
                GYHSCardBandModel* model = [[GYHSCardBandModel alloc] initWithDictionary:tempDic error:nil];
                self.model = model;
                bankID = model.accId;
                _bankNum = model.bankAccNo;
                NSString* bankNum = tempDic[@"bankAccNo"];
                if (![globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence] && bankNum.length > 8) {
                    bankNum = [[[bankNum substringToIndex:4] stringByAppendingString:@"**** ****"] stringByAppendingString:[bankNum substringFromIndex:bankNum.length - 4]];
                }
                self.model.bankAccNo = bankNum;
            }
        }
    }
    else if(request.tag == 2){
        NSDictionary* dataDic = responseObject[@"data"];
        if (![dataDic isKindOfClass:[NSNull class]] && dataDic && dataDic.count) {
            data.user.cashAccBal = [dataDic[@"accountBalance"] doubleValue];
            self.balance = dataDic[@"accountBalance"];
        }
        else {
            self.balance = @"0.00";
            data.user.cashAccBal = 0.0;
        }
    }else if (request.tag == 3)
    {
        if (responseObject) {
                
                self.RealName = kSaftToNSString(responseObject[@"data"][@"name"]);
        }
        
    }
    [self.cashTransTableView reloadData];
}
- (void)netRequest:(GYNetRequest*)request didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);

    if (request.tag == 1) {
        [GYUtils parseNetWork:error resultBlock:nil];
    }
    else if(request.tag == 2){
        WS(weakSelf)
            [GYUtils parseNetWork:error resultBlock:^(NSInteger retCode) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
    }else if(request.tag == 3) {
        [GYUtils showToast:@"获取数据失败！"];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cashTransTableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.cashTransTableView registerNib:[UINib nibWithNibName:@"GYHSImageTitleNumberCell" bundle:nil] forCellReuseIdentifier:@"GYHSImageTitleNumberCell"];
    [self.cashTransTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.cashTransTableView registerNib:[UINib nibWithNibName:@"GYHSLableTextFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.cashTransTableView registerNib:[UINib nibWithNibName:@"GYHSTowLabelButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSTowLabelButtonCell"];
    [self.cashTransTableView registerNib:[UINib nibWithNibName:@"GYHSTableViewWarmCell" bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
    [self.cashTransTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    //查询个人信息非持卡人
    [self requestData];
    //查询是否有默认银行卡
    [self getBackListFromNetwork];
    //实例化单例
    data = globalData;
    data.user.isNeedRefresh = YES;
    //添加点击隐藏键盘
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.cashTransTableView addGestureRecognizer:tapGesture];
    bankID = nil;
    //查询是否有默认银行卡
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置初始值
    if (data.user.isNeedRefresh) {
        self.integral = @"";
        inputValue = 0.0;
        [self get_cash_act_info_new];
        data.user.isNeedRefresh = NO;
        [self.cashTransTableView reloadData];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else if (section == 2) {
        return 4;
    }
    else {
        return 3;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHSImageTitleNumberCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSImageTitleNumberCell" forIndexPath:indexPath];
        cell.imgV.image = [UIImage imageNamed:@"hs_cell_img_cash_account"];
        cell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_cash_account_balance_confirm");
        cell.numberLabel.text = [GYUtils formatCurrencyStyle:self.balance.doubleValue];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GYHSLableTextFileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell" forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            cell.textField.placeholder = kLocalized(@"GYHS_MyAccounts_input_transfer_amount");
            cell.textField.delegate = self;
            return cell;
        }
        else if (indexPath.row == 1) {
            GYHSTowLabelButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTowLabelButtonCell" forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            cell.bankNumberLabel.textColor = [UIColor grayColor];
            cell.bankNumberLabel.alpha = 1;
            if (self.model.bankAccNo.length > 8) {
                NSString* string = self.model.bankAccNo;
                NSString* string1 = self.model.bankAccNo;
                NSInteger index = string1.length - 4;
                string = [string substringToIndex:4]; //截取掉下标7之后的字符串
                cell.bankNumberLabel.text = [NSString stringWithFormat:@"%@**********%@", string, [string1 substringFromIndex:index]];
            }else if (self.model.bankAccNo.length == 0) {
                cell.bankNumberLabel.text = @"选择绑定银行";
                cell.bankNumberLabel.textColor = UIColorFromRGB(0x8C8C8C);
                cell.bankNumberLabel.alpha = 0.5;
            }
            else {
                cell.bankNumberLabel.text = self.model.bankAccNo;
            }
            
            
            
            [cell.button addTarget:self action:@selector(nextstep) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        else {
            GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.spacing.constant = 2;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            [cell.detLabel setTextColor:kValueRedCorlor];
            cell.detLabel.text = kLocalized(@"GYHS_MyAccounts_RMB");
            return cell;
        }
    }
    else {
        if (indexPath.row < 3) {
            GYHSTableViewWarmCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell" forIndexPath:indexPath];
            cell.backgroundColor = kDefaultVCBackgroundColor;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if (indexPath.row == 0) {
                cell.redImage.hidden = YES;
                cell.labelspacing.constant = -10;
            }
            [cell.label setTextColor:kCellItemTextColor];
            cell.label.numberOfLines = 0;
            if (self.warArray.count > 0) {
                cell.label.text = self.warArray[indexPath.row];
            }
            if (indexPath.row == 1) {
                cell.label.lineBreakMode = NSLineBreakByWordWrapping;
                CGSize size = [cell.label sizeThatFits:CGSizeMake(cell.label.frame.size.width, MAXFLOAT)];
                self.labelheight = size.height;
            }
            
            return cell;
        }
        else {
            GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
            cell.backgroundColor = kDefaultVCBackgroundColor;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_next_step") forState:UIControlStateNormal];
            [cell.btnTitle setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
            [cell.btnTitle addTarget:self action:@selector(btnNextClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 75;
    }
    else if (indexPath.section == 2 && indexPath.row == 0) {
        return 25;
    }
    else if (indexPath.section == 2 && indexPath.row == 1 ) {
       return self.labelheight+4;
       
    }
    else if (indexPath.section == 2 &&  indexPath.row == 2) {
       return 30;
       
    }
    else if (indexPath.section == 2 && indexPath.row == 3) {
        return 50;
    }
    else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

//银行选择菜单 点击事件
- (void)nextstep
{
    [self.view endEditing:YES];
    if (globalData.loginModel.cardHolder) {
        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
            GYNoRegisterForSkipViewController* vc = [[GYNoRegisterForSkipViewController alloc] init];
            vc.title = kLocalized(@"GYHS_MyAccounts_bank_card_binding");
            vc.strContent = kLocalized(@"GYHS_MyAccounts_youNotToRealNameRegistration");
            vc.strContentNext = kLocalized(@"GYHS_MyAccounts_pleaseAgainAfterForRealNameRegistration");
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        
        // 添加银行卡页面
        
        GYHSBindBankCardListVC* vcSelAcc = kLoadVcFromClassStringName(NSStringFromClass([GYHSBindBankCardListVC class]));
        vcSelAcc.type = @"1";
        vcSelAcc.bankcardDelegate = self;
        vcSelAcc.isPerfect = GYHSBindBankCardListVCTypePerfect;
        [self.navigationController pushViewController:vcSelAcc animated:YES];
    }else {
        
        GYHSBindBankCardListVC* vcSelAcc = kLoadVcFromClassStringName(NSStringFromClass([GYHSBindBankCardListVC class]));
        vcSelAcc.type = @"1";
        vcSelAcc.bankcardDelegate = self;
        if ([GYUtils isBlankString:self.RealName]) {
            vcSelAcc.isPerfect =GYHSBindBankCardListVCTypeNoPerfect;
        }else {
            vcSelAcc.isPerfect =GYHSBindBankCardListVCTypePerfect;
        }
        
        [self.navigationController pushViewController:vcSelAcc animated:YES];
    }
    
}
//下一步操作
- (void)btnNextClick:(id)sender
{
    if (self.integral && inputValue >= 0) { //输入合法

        if (inputValue == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_inputTransferAmountCannotBe0")];
            return;
        }
        if (self.model.bankAccNo.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_pleaseSelectIntoBankAccounts")];
            return;
        }

        if (inputValue > data.user.cashAccBal) { //输入大于账号余额
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_greaterThanTheAmountInputsCurrencyAccountPleaseEnterAgain")];
            return;
        }

        if (inputValue < data.custGlobalDataModel.hbToBankMin.doubleValue) { //个人积分转现最少
            NSString* message = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_moneyTransferBankAmountIsNotLessThan%@Integer"), [GYUtils formatCurrencyStyle:data.custGlobalDataModel.hbToBankMin.doubleValue]];
            [GYUtils showToast:message];
            return;
        }

        if (inputValue > 2000000000) { //必须低于2000000000
            NSString* message = kLocalized(@"GYHS_MyAccounts_moneyTransferBankAmountMustBeInteger");
            [GYUtils showToast:message];
            return;
        }
        [self hideKeyboard:nil];
        //进入下一步
        GYHSConfirmTransferInfoVC* nextVC = [[GYHSConfirmTransferInfoVC alloc] init];
        nextVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_cash_account_transfer_confirm");
        nextVC.bandCardModel = self.model;
        nextVC.inputValue = inputValue;
        nextVC.cashAccountValue = data.user.cashAccBal;

        NSMutableArray* arrPassStrings = [NSMutableArray array];
        [arrPassStrings addObject:self.integral];
        [arrPassStrings addObject:_bankNum];
        if (![GYUtils isBlankString:self.model.bankAccName]) {

            [arrPassStrings addObject:self.model.bankAccName];
        }
        else {

            [arrPassStrings addObject:@"***"];
        }

        [arrPassStrings addObject:self.model.bankName];

        GYCityAddressModel* cityModel = [[GYAddressData shareInstance] queryCityNo:self.model.cityCode];
        NSString* city = cityModel.cityFullName;
        if ([GYUtils isBlankString:city]) {

            [arrPassStrings addObject:@"****"];
        }
        else {
            [arrPassStrings addObject:city];
        }
        [arrPassStrings addObject:kLocalized(@"GYHS_MyAccounts_RMB")];
        NSString* str = self.integral;
        [arrPassStrings addObject:str];
        nextVC.arrStrings = arrPassStrings;
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else { //输入不合法
        [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_please_enter_the_complete_information")];
    }
}

#pragma mark - UITextFieldDelegate
//输入积分数，同步显示将转成现金数
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // modify by songjk 计算长度修改
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (len > 12){
        return NO;
    }
    
    NSString* str = [textField.text stringByReplacingCharactersInRange:range withString:string];
    inputValue = [str doubleValue];
    if (inputValue < 0){
        return NO;
    }
    NSCharacterSet* cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}
#pragma mark textfield
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    self.integral = textField.text;
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self hideKeyboard:nil];
}

- (void)hideKeyboard:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}
#pragma mark - 选择银行账户列表 代理
- (void)chooseBank:(GYHSCardBandModel*)model isAdd:(BOOL)isAdd
{
    if (isAdd) {
        _bankNum = model.bankAccNo;
        self.model = model;
        [self.cashTransTableView reloadData];
    }
    else {
        // 删除选择项，则清空
        if ([model.bankAccNo isEqualToString:self.model.bankAccNo] &&
            [model.bankName isEqualToString:self.model.bankName]) {
            
            _bankNum = nil;
            self.model = nil;
            [self.cashTransTableView reloadData];
        }
    }
}

#pragma mark-- 懒加载
- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYHS_MyAccounts_apply_transfer_amount"),
            kLocalized(@"GYHS_MyAccounts_transfer_to_bank_account"),
            kLocalized(@"GYHS_MyAccounts_local_settlement_currency") ];
    }
    return _titleArray;
}
- (NSArray*)warArray
{
    if (!_warArray) {
        _warArray = @[ kLocalized(@"GYHS_MyAccounts_WellTip"), [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_cash_to_bank_tip"), [NSString stringWithFormat:@"%d",data.custGlobalDataModel.hbToBankMin.intValue]], kLocalized(@"GYHS_MyAccounts_turnTheSecondCurrencyBankWarmPrompt") ];
    }
    return _warArray;
}

-(UITableView*)cashTransTableView
{
    if (!_cashTransTableView) {
        _cashTransTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _cashTransTableView.dataSource = self;
        _cashTransTableView.delegate = self;
        [self.view addSubview:_cashTransTableView];
    }
    return _cashTransTableView;
}
@end