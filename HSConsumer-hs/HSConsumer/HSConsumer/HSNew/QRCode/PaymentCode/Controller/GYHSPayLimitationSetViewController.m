//
//  GYHSPayLimitationSetViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPayLimitationSetViewController.h"
#import "Masonry.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSSetTradePasswordBtnCell.h"
#import "GYHSWarmPromptLimCell.h"
#import "GYHSCancelDetermineCell.h"
#import "GYHSSwitchHSBCell.h"
#import "GYHSPopView.h"
#import "GYHDSetTradingPasswordViewController.h"
#import "NSString+YYAdd.h"
#import "GYHsbPayLimitModel.h"
#import "MJExtension.h"
#import "GYHSTools.h"
#import "IQKeyboardManager.h"

#define kGYHSLableTextFileTableViewCell @"GYHSLableTextFileTableViewCell"
#define kGYHSSetTradePasswordBtnCell @"GYHSSetTradePasswordBtnCell"
#define kGYHSWarmPromptLimCell @"GYHSWarmPromptLimCell"
#define kGYHSCancelDetermineCell @"GYHSCancelDetermineCell"
#define kGYHSSwitchHSBCell @"GYHSSwitchHSBCell"

@interface GYHSPayLimitationSetViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSImmediatelySetDelegate,GYHSPopViewDelegate,GYHSCancelDetermineDelegate,GYHSSwitchHSBDelegate,GYHSLableTextFileTableViewCellDeleget>
@property(nonatomic,strong)UITableView *payLimitationTableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy)NSString *transPwd;   //交易密码
@property (nonatomic,strong)GYHsbPayLimitModel *model;



@end

@implementation GYHSPayLimitationSetViewController
#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.payLimitationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLableTextFileTableViewCell class]) bundle:nil] forCellReuseIdentifier:kGYHSLableTextFileTableViewCell];
    [self.payLimitationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSSetTradePasswordBtnCell class]) bundle:nil] forCellReuseIdentifier:kGYHSSetTradePasswordBtnCell];
    [self.payLimitationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSWarmPromptLimCell class]) bundle:nil] forCellReuseIdentifier:kGYHSWarmPromptLimCell];
    [self.payLimitationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSCancelDetermineCell class]) bundle:nil] forCellReuseIdentifier:kGYHSCancelDetermineCell];
     [self.payLimitationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSSwitchHSBCell class]) bundle:nil] forCellReuseIdentifier:kGYHSSwitchHSBCell];
     [self tableHeaderView];
    [self get_payLimit_info];
    //接收设置交易密码成功刷新页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadcheckInfoStatus) name:@"setTransPwdSuccessNotification" object:nil];
}
-(void)loadcheckInfoStatus
{
    self.dataArray = nil;
    self.tradingPasswordType = GYHSTradingPasswordTypeModify;
    [self.payLimitationTableView reloadData];
}
#pragma mark -- The custom method
-(void)tableHeaderView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.payLimitationTableView.frame.size.width/2, 40)];
    label.text = @"支付额度设置";
    label.textAlignment = NSTextAlignmentCenter;
    self.payLimitationTableView.tableHeaderView  = label;
}
#pragma mark -- GYHSCancelDetermineDelegate取消
-(void)cancelLimitation
{
    [self.view.superview.superview removeFromSuperview];
}
#pragma mark -- GYHSCancelDetermineDelegate确定
-(void)determineLimitation
{
    if ([GYUtils checkStringInvalid:self.model.payMax] && [self.model.payMaxSwitch isEqualToString:@"Y"]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_pleaseInputPerLimitPay")];
        return;
    }
    if ([GYUtils checkStringInvalid:self.model.payDayMax] &&[self.model.payDayMaxSwitch isEqualToString:@"Y"]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_pleaseInputPerDayLimitPay")];
        return;
    }
    if ([GYUtils checkStringInvalid:self.model.payFreeMax] &&[self.model.payFreeMaxSwitch isEqualToString:@"Y"]) {
        [GYUtils showMessage:kLocalized(@"请输入单笔免密支付额度")];
        return;
    }
    if ([self.model.payDayMax doubleValue] > [self.model.sysPayDayMax doubleValue] && self.model.sysPayDayMax) {
        [self.view makeToast:[NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_MyAccounts_dailyPayIsNotGreaterThanTheLimit"), self.model.sysPayDayMax] duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([self.model.payMax doubleValue] > [self.model.sysPayMax doubleValue] && self.model.sysPayMax) {
        [self.view makeToast:[NSString stringWithFormat:@"%@%@", kLocalized(@"GYHS_MyAccounts_singlePayNoMoreThanTheLimit"), self.model.sysPayMax] duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([self.model.payFreeMax doubleValue] > [self.model.consumerFreePaymentMax doubleValue] && self.model.consumerFreePaymentMax) {
        [self.view makeToast:[NSString stringWithFormat:@"单笔免密支付限额不大于%@", self.model.sysPayMax] duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([self.model.payMax doubleValue] > [self.model.payDayMax doubleValue] && [self.model.payMaxSwitch isEqualToString: @"Y"] && [self.model.payDayMaxSwitch isEqualToString: @"Y"]) {
        [GYUtils showMessage:@"单笔支付额度不能大于每日支付总额度"];
        return;
    }
    if ([self.model.payFreeMax doubleValue] > [self.model.payDayMax doubleValue] &&[self.model.payFreeMaxSwitch isEqualToString:@"Y"] && [self.model.payDayMaxSwitch isEqualToString: @"Y"]) {
        [GYUtils showMessage:@"单笔免密支付额度不能大于每日支付总额度"];
        return;
    }
    if ([self.model.payFreeMax doubleValue] > [self.model.payMax doubleValue] && [self.model.payFreeMaxSwitch isEqualToString:@"Y"] && [self.model.payMaxSwitch isEqualToString: @"Y"]) {
        [GYUtils showMessage:@"单笔免密支付额度不能大于单笔支付额度"];
        return;
    }
    if (!self.transPwd || self.transPwd.length != 8) {
        [self.view makeToast:kLocalized(@"GYHS_MyAccounts_pleaseEnterTheCorrectPassword") duration:1 position:CSToastPositionCenter];
        return;
    }
    if ([self.transPwd stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [self.view makeToast:kLocalized(@"GYHS_MyAccounts_pleaseInputTradeCode") duration:1 position:CSToastPositionCenter];
        return;
    }
    [self request];
}
#pragma mark -- GYHSImmediatelySetDelegate立即设置
-(void)immediatelySetButton
{
    
    GYHSPopView *popView = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    GYHDSetTradingPasswordViewController* vc = [[GYHDSetTradingPasswordViewController alloc] init];
    vc.entranceType = 2;
    [popView showView:vc withViewFrame:CGRectMake(10, 90, kScreenWidth - 20, 241)];
}
#pragma mark -- GYHSSwitchHSBDelegate是否网上互生币支付
-(void)hsbSwitch:(UISwitch *)hsbswitch indextPath:(NSIndexPath *)indexPath
{
    if(!hsbswitch.on){
        NSLog(@"关");
        if (indexPath.row == 0) {
            self.model.payMaxSwitch = @"N";
           
            [self.dataArray[0][0] setObject:@"N" forKey:@"Switch"];
        }else if (indexPath.row == 1){
            self.model.payDayMaxSwitch = @"N";
            
            [self.dataArray[0][1] setObject:@"N" forKey:@"Switch"];
        }else if (indexPath.row == 2){
            self.model.payFreeMaxSwitch = @"N";
            
            [self.dataArray[0][2] setObject:@"N" forKey:@"Switch"];
        }else if (indexPath.row == 4){
            self.model.payOnlineSwitch = @"N";
            [self.dataArray[0][4] setObject:@"N" forKey:@"Switch"];
        }
    }
    else{
        NSLog(@"开");
        if (indexPath.row == 0) {
            self.model.payMaxSwitch = @"Y";
             [self.dataArray[0][0] setObject:@"Y" forKey:@"Switch"];
        }else if (indexPath.row == 1){
            self.model.payDayMaxSwitch = @"Y";
            [self.dataArray[0][1] setObject:@"Y" forKey:@"Switch"];
        }else if (indexPath.row == 2){
            self.model.payFreeMaxSwitch = @"Y";
            [self.dataArray[0][2] setObject:@"Y" forKey:@"Switch"];
        }else if (indexPath.row == 4){
            self.model.payOnlineSwitch = @"Y";
            [self.dataArray[0][4] setObject:@"Y" forKey:@"Switch"];
        }
    }
    [self.payLimitationTableView reloadData];
}

#pragma mark -- GYHSLableTextFileTableViewCellDeleget密码项
-(void)textField:(NSString *)string indextPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    [dic setObject:string forKey:@"Value"];
    self.transPwd = string;
}
#pragma mark -- 限额输入项textField
-(void)switchtextField:(NSString *)string indextPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    [dic setObject:string forKey:@"Value"];
    if (indexPath.row == 0) {
        self.model.payMax = string;
    }else if (indexPath.row == 1){
        self.model.payDayMax = string;
    }else if (indexPath.row == 2){
        self.model.payFreeMax = string;
    }
}
#pragma mark -- UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==  3) {
        return 110;
    }
    return 40;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSMutableDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
    if (indexPath.row == 3) {
        GYHSWarmPromptLimCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSWarmPromptLimCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.valueLb.text =  dic[@"Name"];
        return cell;
    }
    else if (indexPath.row == 5) {
        if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
            GYHSSetTradePasswordBtnCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSSetTradePasswordBtnCell forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.immediatelyDelegate = self;
            return cell;
        }else{
            GYHSLableTextFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSLableTextFileTableViewCell forIndexPath:indexPath];
            [self returnTextFile:cell dict:dic indexpath:indexPath];
            cell.textFiledlength = 8;
            cell.textField.secureTextEntry = YES;
            return cell;
        }
    }
    else if (indexPath.row == 6) {
        GYHSCancelDetermineCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCancelDetermineCell forIndexPath:indexPath];
        [self cancelDetermine:cell dict:dic indexpath:indexPath];
        return cell;
    }else{
        GYHSSwitchHSBCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSSwitchHSBCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //cell.valueTextField.delegate = self;
        cell.titleLabel.text = dic[@"Name"];
        if (indexPath.row == 0) {
            cell.textFiledlength = self.model.sysPayMax.length;
        }else if(indexPath.row == 1){
            cell.textFiledlength = self.model.sysPayDayMax.length;
        }else if (indexPath.row == 2){
            cell.textFiledlength = self.model.consumerFreePaymentMax.length;
        }
        if ([dic[@"Switch"] isEqualToString:@"Y"]) {
            [cell.HSBSwitch setOn:YES];
            cell.valueTextField.userInteractionEnabled = YES;
            cell.valueTextField.text = dic[@"Value"];
            cell.valueTextField.placeholder = dic[@"placeHolder"];
        }else{
            [cell.HSBSwitch setOn:NO];
            cell.valueTextField.userInteractionEnabled = NO;
            cell.valueTextField.placeholder = @"";
            cell.valueTextField.text = @"";
        }
        if (indexPath.row == 4) {
            cell.valueTextField.hidden = YES;
        }else{
            cell.valueTextField.hidden = NO;
        }
        cell.indexpath = indexPath;
        cell.switchHSBDelegate = self;
        return cell;
    }
}
-(void)returnTextFile:(GYHSLableTextFileTableViewCell*)cell dict:(NSMutableDictionary*)dic indexpath:(NSIndexPath*)indexpath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.titleLabel setTextColor:kCellTitleBlack];
    cell.bottomlb.hidden = YES;
    cell.toplinelb.hidden = YES;
    cell.titleLabel.text = dic[@"Name"];
    cell.textField.text = dic[@"Value"];
    cell.textField.placeholder = dic[@"placeHolder"];
    cell.indexpath = indexpath;
    cell.textFiledDegelte = self;
}
-(void)cancelDetermine:(GYHSCancelDetermineCell*)cell dict:(NSMutableDictionary*)dic indexpath:(NSIndexPath*)indexpath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cancelDetermineDelegate = self;
}
#pragma mark -- 设置互生币支付限额
- (void)request {
    NSString* payMax = [GYUtils deformatterCurrencyStyle:self.model.payMax flag:@","];
    NSString* payDayMax = [GYUtils deformatterCurrencyStyle:self.model.payDayMax flag:@","];
    NSDictionary* allParas = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                                @"custName" : globalData.loginModel.cardHolder ? kSaftToNSString(globalData.loginModel.custName) : globalData.loginModel.userName, //非持卡人传userName
                                @"hsResNo" : kSaftToNSString(globalData.loginModel.resNo),
                                @"systemType" : kSaftToNSString(kSystemTypeConsumer),
                                @"payMax" :[self.model.payMaxSwitch isEqualToString:@"Y"] ? kSaftToNSString(payMax) : @"0" , //不设置传0
                                @"payDayMax" :[self.model.payDayMaxSwitch isEqualToString:@"Y"] ? kSaftToNSString(payDayMax) : @"0" ,
                                @"payFreeMax": [self.model.payFreeMaxSwitch isEqualToString:@"Y"] ? kSaftToNSString(self.model.payFreeMax) : @"0" ,
                                @"payMaxSwitch": self.model.payMaxSwitch,
                                @"payDayMaxSwitch" : self.model.payDayMaxSwitch,
                                @"payFreeMaxSwitch" : self.model.payFreeMaxSwitch,
                                @"payOnlineSwitch":self.model.payOnlineSwitch,
                                @"transPwd" : [self.transPwd md5String],
                                @"userType" : kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard) };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHsbSetPayLimitUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_setTheAlternateCurrencyPayLimitationSuccess") confirm:^{
            if (self.successDategale && [_successDategale respondsToSelector:@selector(settingQuotasSuccess)])  {
                [self.successDategale settingQuotasSuccess];
            }
            [self.view.superview.superview removeFromSuperview];
        } withColor:kotherPayBtnCorlor];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark --查询互生币支付限额
- (void)get_payLimit_info
{
    NSDictionary* allParas = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                                @"systemType" : kSystemTypeConsumer };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHsbQueryPayLimitUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary* dict = responseObject[@"data"];
        
        self.model = [GYHsbPayLimitModel mj_objectWithKeyValues:responseObject[@"data"]];
        if ([kSaftToNSString(dict[@"payMaxSwitch"]) isEqualToString:@"Y"]) {
            [self.dataArray[0][0] setObject:[GYUtils formatCurrencyStyle:[kSaftToNSString(dict[@"payMax"]) doubleValue]] forKey:@"Value"];
        }
        if ([kSaftToNSString(dict[@"payDayMaxSwitch"]) isEqualToString:@"Y"]) {
            [self.dataArray[0][1] setObject:[GYUtils formatCurrencyStyle:[kSaftToNSString(dict[@"payDayMax"]) doubleValue]] forKey:@"Value"];
        }
        if ([kSaftToNSString(dict[@"payFreeMaxSwitch"]) isEqualToString:@"Y"]) {
            [self.dataArray[0][2] setObject:[GYUtils formatCurrencyStyle:[kSaftToNSString(dict[@"payFreeMax"]) doubleValue]] forKey:@"Value"];
        }
        [self.dataArray[0][0] setObject:kSaftToNSString(dict[@"payMaxSwitch"]) forKey:@"Switch"];
        [self.dataArray[0][1] setObject:kSaftToNSString(dict[@"payDayMaxSwitch"]) forKey:@"Switch"];
        [self.dataArray[0][2] setObject:kSaftToNSString(dict[@"payFreeMaxSwitch"]) forKey:@"Switch"];
        [self.dataArray[0][4] setObject:kSaftToNSString(dict[@"payOnlineSwitch"]) forKey:@"Switch"];
        
        [self.payLimitationTableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark -- 懒加载
-(UITableView*)payLimitationTableView
{
    if (!_payLimitationTableView) {
        _payLimitationTableView = [[UITableView alloc] init];
        _payLimitationTableView.dataSource = self;
        _payLimitationTableView.delegate = self;
        //_payLimitationTableView.scrollEnabled = NO;
        [self.view addSubview:_payLimitationTableView];
        [_payLimitationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _payLimitationTableView;
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"Switch"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSArray *valueAry = @[kLocalized(@"单笔支付额度"),
                              @"",
                              @"请输入",
                              @""
                              ];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@"每日支付总额度",
                     @"",
                     @"请输入",
                     @""];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@"单笔免密支付额度",
                     @"",
                     @"请输入",
                     @""];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@"免密支付额度设置仅应用于支付码互生币支付和扫商家二维码互生币支付，同时您也可以选择启用该设置应用于网上互生币支付(不含刷互生卡或者输入卡号的支付方式),单笔免密支付额度设置不能大于单笔支付额度。",
                     @"",
                     @"",
                     @""];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@"应用网上互生币支付",
                     @"",
                     @"",
                     @""];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];

        if (self.tradingPasswordType == GYHSTradingPasswordTypeModify) {
                 valueAry = @[@"交易密码",
                              @"",
                              @"请输入8位交易密码",
                              @""];
                [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
            }else{
                valueAry = @[@"交易密码",
                             @"立即设置",
                             @"",
                             @""];
                [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        }
        valueAry = @[@"取消",
                     @"确定",
                     @"",
                     @""];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];

        
        _dataArray = [[NSMutableArray alloc] initWithObjects:array1, nil];

    }
    return _dataArray;
}

@end
