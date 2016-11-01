//
//  GYHSExchangeHSBViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSExchangeHSBViewController.h"
#import "GYHSTableViewWarmCell.h"
#import "GYHSButtonCell.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSExchangeHSBNextViewController.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"

@interface GYHSExchangeHSBViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSButtonCellDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UITableView *exchangeHSBTableView;
@property (nonatomic,strong)NSMutableArray *warmPromptArray;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *rightArray;
@property (nonatomic, strong) NSString* notRegisteredBuyHsbMaxmum;
@property (nonatomic, strong) NSString* notRegisteredBuyHsbMinimum;
@property (nonatomic, strong) NSString* registeredBuyHsbMaxmum;
@property (nonatomic, strong) NSString* registeredBuyHsbMinimum;
@property (nonatomic, assign) double todayCanBuyHSBAmount; //今日还可以购互生币数  持卡人
@property (nonatomic, assign) double todatCanHanderHSBAmount; ///今日还可以兑换互生币数量 非持卡人
@property (nonatomic, copy) NSString* realnameAuthErrorInfo;
@property (nonatomic, copy) NSString* noRealnameAuthErrorInfo;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, copy) NSString* textFieldString;//购互生币数
@property (nonatomic, copy) NSString* transNo; //流水号
@property (nonatomic, assign)CGFloat labelheight;
@end

@implementation GYHSExchangeHSBViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self initUI];
    if (globalData.loginModel.cardHolder) {
        self.userName = globalData.loginModel.custName;
    }
    else {
        [self queryUserInfo];
    }
    //兑换互生币成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hsCoinChange) name:@"hsCoinChange" object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadqueryCusTipsUrlString];
}
-(void)initUI
{
    [self.view addSubview:self.exchangeHSBTableView];
    [self.exchangeHSBTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
     self.exchangeHSBTableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.exchangeHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLableTextFileTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.exchangeHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.exchangeHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.exchangeHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSTableViewWarmCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
}
#pragma mark -- 
-(void)hsCoinChange
{
    self.textFieldString = @"";
    self.rightArray = nil;
    [self.exchangeHSBTableView reloadData];
}
#pragma mark - 网络数据交换
- (void)queryUserInfo
{
    self.userName = @"";
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSGetInfo parameters:@{ @"userId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        self.userName = kSaftToNSString(dic[@"name"]);
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark -－查询消费者兑换互生币温馨提示数据
- (void)loadqueryCusTipsUrlString
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard };
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHScardqueryCusTipsUrlString parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        [self.warmPromptArray removeAllObjects];
        globalData.user.todayBuyHsbTotalAmount = [dic[@"dayHadBuyHsb"] intValue];
        if (globalData.loginModel.cardHolder) {////持卡人
            self.notRegisteredBuyHsbMaxmum = dic[@"notRegBuyHsbMax"];
            self.notRegisteredBuyHsbMinimum= dic[@"notRegBuyHsbMin"];
            self.registeredBuyHsbMaxmum = dic[@"regBuyHsbMax"];
            self.registeredBuyHsbMinimum = dic[@"regBuyHsbMin"];
            [self.warmPromptArray addObject:[NSString stringWithFormat:@"%@:", kLocalized(@"GYHS_MyAccounts_well_tip")]];
            [self.warmPromptArray addObject:[NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_userCanBuyHSCoinOneOrder"), [dic[@"regBuyHsbMin"] intValue], [dic[@"regBuyHsbMax"] intValue]]];
            [self.warmPromptArray addObject:[NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_unRealNameRegist_user_exchange_HSCoin_range"), [dic[@"notRegBuyHsbMin"] intValue], [dic[@"notRegBuyHsbMax"] intValue]]];
            self.realnameAuthErrorInfo = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_exchange_HSCoin_range"), [dic[@"regBuyHsbMin"] intValue], [dic[@"regBuyHsbMax"] intValue]];
            self.noRealnameAuthErrorInfo = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_unRealNameRegist_user_exchange_HSCoin_info"), [dic[@"notRegBuyHsbMin"] intValue], [dic[@"notRegBuyHsbMax"] intValue]];
            //将今日还可以兑换数量变成 红色
            NSString *key = ![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes] ? @"regDayBuyHsbMax" :@"notRegDayBuyHsbMax" ;//标记是否实名注册的获取最大限额的key
            self.todayCanBuyHSBAmount = [dic[key] doubleValue] - [dic[@"dayHadBuyHsb"] doubleValue];
            NSString *str = [NSString stringWithFormat:@"每日兑换互生币数量最多为%zd，今日还可以兑换%.2f互生币。",  [dic[key] intValue], self.todayCanBuyHSBAmount];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
            [attStr addAttribute:NSForegroundColorAttributeName value:kNavigationBarColor range:[str rangeOfString:[NSString stringWithFormat:@"%.2f", self.todayCanBuyHSBAmount]]];
           [self.warmPromptArray addObject:attStr];
        } else {///非持卡人
            self.notRegisteredBuyHsbMaxmum = dic[@"notRegBuyHsbMax"];
            self.notRegisteredBuyHsbMinimum= dic[@"notRegBuyHsbMin"];
            self.registeredBuyHsbMaxmum = dic[@"regBuyHsbMax"];
            self.registeredBuyHsbMinimum = dic[@"regBuyHsbMin"];
            [self.warmPromptArray addObject:[NSString stringWithFormat:@"%@:", kLocalized(@"GYHS_MyAccounts_well_tip")]];
            [self.warmPromptArray addObject:[NSString stringWithFormat:@"已填真实姓名用户单笔兑换数量为%.0f-%.0f互生币", [dic[@"regBuyHsbMin"] doubleValue], [dic[@"regBuyHsbMax"] doubleValue]]];
            [self.warmPromptArray addObject:[NSString stringWithFormat:@"未填真实姓名用户单笔兑换数量为%.0f-%.0f互生币", [dic[@"notRegBuyHsbMin"] doubleValue], [dic[@"notRegBuyHsbMax"] doubleValue]]];
            self.realnameAuthErrorInfo = [NSString stringWithFormat:@"已填真实姓名用户单笔兑换数量为%.0f-%.0f，请正确输入兑换数量", [dic[@"regBuyHsbMin"] doubleValue], [dic[@"regBuyHsbMax"] doubleValue]];
            self.noRealnameAuthErrorInfo = [NSString stringWithFormat:@"未填真实姓名用户单笔兑换数量为%.0f-%.0f，请正确输入兑换数量", [dic[@"notRegBuyHsbMin"] doubleValue], [dic[@"notRegBuyHsbMax"] doubleValue]];
            double buyHsb = [dic[self.userName.length > 0 ? @"regDayBuyHsbMax": @"notRegDayBuyHsbMax"] doubleValue] - [dic[@"dayHadBuyHsb"] doubleValue];
            self.todatCanHanderHSBAmount = buyHsb;
            NSString *str = [NSString stringWithFormat:@"每日兑换互生币数量最多为%.0f，今日还可以兑换%.2f互生币。", [dic[self.userName.length > 0 ? @"regDayBuyHsbMax": @"notRegDayBuyHsbMax"] doubleValue], buyHsb];
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:nil];
            [attStr addAttribute:NSForegroundColorAttributeName value:kNavigationBarColor range:[str rangeOfString:[NSString stringWithFormat:@"%.2f", buyHsb]]];
            [self.warmPromptArray addObject:attStr];
        }
        [self.exchangeHSBTableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark -－兑换互生币
- (void)exchangeHSB
{
    NSString* amount = [NSString stringWithFormat:@"%.2f", [self.textFieldString doubleValue]];
    NSDictionary* allFixParas = @{
                                  @"channel" : kChannelMOBILE,
                                  @"buyHsbAmt" : kSaftToNSString(amount),
                                  @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    if (globalData.loginModel.cardHolder) {
        [allParas setValue:kCustTypeCard forKey:@"custType"];
    }
    else {
        [allParas setValue:kCustTypeNoCard forKey:@"custType"];
    }
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:globalData.loginModel.resNo ? kSaftToNSString(globalData.loginModel.resNo) : kSaftToNSString(globalData.loginModel.userName) forKey:@"hsResNo"];
    [allParas setValue:kSaftToNSString(self.userName) forKey:@"custName"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSExchangeHsbUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        NSDictionary *dic = responseObject;
        if (error) {
            NSInteger  errorRetCode = [error code];
            if ( errorRetCode == 43268)
            {
                [GYUtils showMessage:[NSString stringWithFormat:@"该业务暂时不能受理！原因：%@",dic[@"msg"]]];
                return;
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        self.transNo = kSaftToNSString(dic[@"data"]);
        NSString *shouldPayStr = self.rightArray[4];
        shouldPayStr = [shouldPayStr stringByReplacingOccurrencesOfString:@"," withString:@""];
        GYHSExchangeHSBNextViewController *currencyVC = kLoadVcFromClassStringName(NSStringFromClass([GYHSExchangeHSBNextViewController class]));
        currencyVC.inputValue = [shouldPayStr doubleValue];
        currencyVC.transNo = self.transNo;
        currencyVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_exchange_HSCoin_confirm");
        [self.navigationController pushViewController:currencyVC animated:YES];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

#pragma mark －－ 下一步
-(void)nextBtn
{
    if ( self.textFieldString.length > 0 ) { //输入合法
        if (globalData.loginModel.cardHolder) { // 区分持卡人与非持卡人
            if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes] ||
                [globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadCertify]) { //实名注册的
                if (!((self.textFieldString.doubleValue >= self.registeredBuyHsbMinimum.doubleValue) && (self.textFieldString.doubleValue <= self.registeredBuyHsbMaxmum.doubleValue))) {
                    [GYUtils showMessage:self.realnameAuthErrorInfo];
                    return;
                }
            }
            else {
                if ((self.textFieldString.doubleValue < self.notRegisteredBuyHsbMinimum.doubleValue)) {
                    [GYUtils showMessage:self.noRealnameAuthErrorInfo];
                    return;
                }
                if ((self.textFieldString.doubleValue > self.notRegisteredBuyHsbMaxmum.doubleValue)) {
                    [GYUtils showMessage:self.noRealnameAuthErrorInfo];
                    return;
                }
            }
        }
        else {
            if (self.userName.length > 0) { //填写真实姓名
                if (!((self.textFieldString.doubleValue >= self.registeredBuyHsbMinimum.doubleValue) && (self.textFieldString.doubleValue <= self.registeredBuyHsbMaxmum.doubleValue))) {
                    [GYUtils showMessage:self.realnameAuthErrorInfo];
                    return;
                }
            }
            else {
                if ((self.textFieldString.doubleValue < self.notRegisteredBuyHsbMinimum.doubleValue)) {
                    [GYUtils showMessage:self.noRealnameAuthErrorInfo];
                    return;
                }
                if ((self.textFieldString.doubleValue > self.notRegisteredBuyHsbMaxmum.doubleValue)) {
                    [GYUtils showMessage:self.noRealnameAuthErrorInfo];
                    return;
                }
            }
        }
        [self exchangeHSB];
    }
    else { //输入不合法
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_input_HSCoin")];
    }
}
#pragma mark - UITextFieldDelegate
//输入兑换互生币数量，同步显示将转成现金数
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (len > 12 ||
        [toBeString doubleValue] < 0) {
        return NO;
    }
    else {
        self.textFieldString = toBeString;
        double v2 = [toBeString doubleValue];
        [self.rightArray replaceObjectAtIndex:3 withObject:[GYUtils formatCurrencyStyle:v2]];
        [self.rightArray replaceObjectAtIndex:4 withObject:[GYUtils formatCurrencyStyle:v2]];
        NSIndexPath* ind3 = [NSIndexPath indexPathForRow:3 inSection:0];
        NSIndexPath* ind4 = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.exchangeHSBTableView reloadRowsAtIndexPaths:@[ ind3, ind4 ] withRowAnimation:UITableViewRowAnimationNone];
        NSCharacterSet* cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}

#pragma mark -- UITableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.titleArray.count;
    }else if (section == 2){
        return  self.warmPromptArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 2) {
        return 33;
    }
    else if (indexPath.section == 1) {
        return 60;
    }
    else {
        return 50;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GYHSLableTextFileTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell" forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if (self.rightArray.count > indexPath.row) {
                cell.textField.placeholder = self.rightArray[indexPath.row];
            }
            cell.textField.text = self.textFieldString;
            cell.textField.delegate =self;
            cell.titlelabelWith.constant = 150;
            return cell;
        }else{
            GYHSLabelTwoTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if (self.rightArray.count > indexPath.row) {
                cell.detLabel.text = self.rightArray[indexPath.row];
            }
            if (indexPath.row > 1) {
                [cell.detLabel setTextColor:kValueRedCorlor];
            }
            cell.toplb.hidden = YES;
            cell.titleLabelWith.constant = 150;
            return cell;
        }
    }else if (indexPath.section == 1){
        GYHSButtonCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kDefaultVCBackgroundColor;
        [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_go_to_pay") forState:UIControlStateNormal];
        [cell.btnTitle setBackgroundImage:[UIImage imageNamed:@"gyhs_nextbtn"] forState:UIControlStateNormal];
        cell.btnDelegate = self;
        return cell;
    }else{
        GYHSTableViewWarmCell * cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell" forIndexPath:indexPath];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.backgroundColor = kDefaultVCBackgroundColor;
        if (indexPath.row == 0) {
            cell.redImage.hidden = YES;
            cell.labelspacing.constant = -10;
        }
        if (self.warmPromptArray.count > indexPath.row) {
            if (indexPath.row == 3) {
                cell.label.attributedText = self.warmPromptArray[indexPath.row];
            }else {
                cell.label.text = self.warmPromptArray[indexPath.row];
            }
        }
        return cell;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==2 || section == 0) {
        return 1;
    }
    return 15;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
}

#pragma mark -- 懒加载
-(UITableView*)exchangeHSBTableView
{
    if (!_exchangeHSBTableView) {
        _exchangeHSBTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _exchangeHSBTableView.dataSource = self;
        _exchangeHSBTableView.delegate = self;
    }
    return _exchangeHSBTableView;
}
-(NSMutableArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = [[NSMutableArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_exchange_hsCoin_count"),
        kLocalized(@"GYHS_MyAccounts_local_settlement_currency"),
        kLocalized(@"GYHS_MyAccounts_hsCointoCash_rate"),
        kLocalized(@"GYHS_MyAccounts_buyHSCoinConvertCash"),
        kLocalized(@"GYHS_MyAccounts_buyHSCoinShouldPaymentAmount"),nil];
    }
    return _titleArray;
}
-(NSMutableArray*)warmPromptArray
{
    if (!_warmPromptArray) {
        _warmPromptArray = [[NSMutableArray alloc] init];
    }
    return _warmPromptArray;
}
-(NSMutableArray*)rightArray
{
    if (!_rightArray) {
        _rightArray = [[NSMutableArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_input_HSCoin"),
                       kLocalized(@"GYHS_MyAccounts_RMB"),
                       [NSString stringWithFormat:@"%.4f", [globalData.custGlobalDataModel.hsbToHbRate doubleValue] * 100],
                       @"0.00",
                       @"0.00", nil];
    }
    return _rightArray;
}
@end
