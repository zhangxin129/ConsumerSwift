//
//  GYHSTradingPasswordViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/2.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTradingPasswordViewController.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSButtonCell.h"
#import "GYHSTableViewWarmCell.h"
#import "GYNetRequest.h"
#import "NSString+YYAdd.h"
#import "GYAlertView.h"
#import "NSString+GYExtension.h"


@interface GYHSTradingPasswordViewController ()<UITableViewDelegate,UITableViewDataSource,GYHSButtonCellDelegate,GYNetRequestDelegate,GYHSLableTextFileTableViewCellDeleget>
@property (nonatomic,strong)UITableView * tradingPasswordTableView;
@property (nonatomic,copy)NSArray *placeholderArray;//textFile占位符数组
@property (nonatomic,copy)NSArray *textFiletitleArray;//textFile标题数组
@property (nonatomic,copy)NSString *originalPassword;//原交易密码
@property (nonatomic,copy)NSString *nePassword;//新密码
@property (nonatomic,copy)NSString *confirmPassword;//确认密码
@end

@implementation GYHSTradingPasswordViewController

#pragma  mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
        self.title = kLocalized(@"GYHS_Pwd_Set_Trading_Password");
    }else {
        self.title = kLocalized(@"GYHS_Pwd_Change_Trade_Pwd");
    }
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.tradingPasswordTableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.tradingPasswordTableView registerNib:[UINib nibWithNibName:@"GYHSLableTextFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.tradingPasswordTableView registerNib:[UINib nibWithNibName:@"GYHSTableViewWarmCell" bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
    [self.tradingPasswordTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
}
#pragma mark --GYNetRequest
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    NSString *msg;
    if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
        msg =kLocalized(@"GYHS_Pwd_Set_Trading_Password_Successfully");
    }else if (self.tradingPasswordType == GYHSTradingPasswordTypeModify){
        msg =kLocalized(@"GYHS_Pwd_Modify_Trading_Password_Successfully");
    }
    [GYUtils showMessage:msg confirm:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    if (netRequest.retCode == 160360) {//特殊处理
        [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Original_Transaction_Password_Mistake_Please_Enter_Again") confirm:^{
        }];
        return;
    }
    [GYUtils parseNetWork:error resultBlock:nil];
}


#pragma mark - GYHSButtonCellDelegate
-(void)nextBtn
{
    if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
        if (self.nePassword.length != 8 || !self.nePassword) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Enter_Password_For_Eight_New_Deals")];
            return;
        }
        if (![self.nePassword isEqualToString:self.confirmPassword]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_New_Trade_Password_And_Confirm_Password_Donot_Match")];
            return;
        }
    }else {
        if (self.originalPassword.length != 8 || !self.originalPassword) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Enter_Password_For_Eight_Original_Deal")];
            return;
        }if (self.nePassword.length != 8 || !self.nePassword) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Enter_Password_For_Eight_New_Deals")];
            return;
        }
        if (self.confirmPassword.length != 8 || !self.confirmPassword) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Please_Confirm_Password_Input_Eight")];
            return;
        }
        if (![self.nePassword isEqualToString:self.confirmPassword]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_New_Trade_Password_And_Confirm_Password_Donot_Match")];
            return;
        }
        if ([self.originalPassword isEqualToString:self.nePassword]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Original_TransactionPassword_In_Accordance_With_New_Trading_Password")];
            return;
        }
    }
    if ([self.nePassword isSimpleTransPwd] == NSOrderedStringSame) {
        [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Please_Donot_Set_Same_Number_Password_Reset")];
        return;
    }
    if ([self.nePassword isSimpleTransPwd] == NSOrderedStringAscending || [self.confirmPassword isSimpleTransPwd] == NSOrderedStringDescending) {
        [GYUtils showMessage:kLocalized(@"GYHS_Pwd_Password_Please_Donot_Set_Continuous_Lifting_Arrangement_Rreset")];
        return;
    }

    [self requestData];
}
#pragma mark -- GYHSLableTextFileTableViewCellDeleget
- (void)textField:(NSString*)string indextPath:(NSIndexPath*)indexPath
{
    
    if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {//设置交易密码
        if (indexPath.row == 0) {
            self.nePassword = string;
        }
        else if (indexPath.row == 1) {
            self.confirmPassword =  string;
        }
    }else if(self.tradingPasswordType == GYHSTradingPasswordTypeModify){
        if (indexPath.row == 0) {
            self.originalPassword = string;
        }
        else if (indexPath.row == 1) {
            self.nePassword =  string;
        }else{
            self.confirmPassword = string;
        }

    }
}
#pragma mark - tableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.placeholderArray.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return 20;
    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHSLableTextFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.textFiletitleArray.count > indexPath.row) {
            cell.titleLabel.text = self.textFiletitleArray[indexPath.row];
        }
        if (self.placeholderArray.count > indexPath.row) {
            cell.textField.placeholder = self.placeholderArray[indexPath.row];
        }
        [cell.textField setSecureTextEntry:YES];
        cell.textFiledlength =8;
        if (indexPath.row !=0) {
            cell.toplinelb.hidden = YES;
        }
        cell.textFiledDegelte = self;
        cell.indexpath = indexPath;
        return cell;
    }else if (indexPath.section == 1){
        GYHSTableViewWarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.redImage.hidden =YES;
        cell.labelspacing.constant = -8;
        cell.backgroundColor = kDefaultVCBackgroundColor;
        cell.label.text = kLocalized(@"GYHS_Pwd_TipTrade_Password_Consists_Of_8_Digits");
        return cell;
    }else {
        GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnTitle setTitle:kLocalized(@"GYHS_Pwd_Confirm") forState:UIControlStateNormal];
        cell.btnTitle.backgroundColor = kNavigationBarColor;
        cell.btnDelegate = self;
        return cell;
    }
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kDefaultMarginToBounds;
    }else if (section == 1){
        return 8;
    }
    else {
        return .1;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return .1;
}

#pragma mark - private methods
#pragma mark -- 网络请求
-(void)requestData
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"operCustId"];
    NSString *urlString ;
    if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
        urlString = kHSsetTradePwdUrlString;
        [allParas setValue:kSaftToNSString([self.nePassword md5String]) forKey:@"tradePwd"];
        [allParas setValue:kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard) forKey:@"userType"];
    }else if (self.tradingPasswordType == GYHSTradingPasswordTypeModify){
        urlString = kHSupdateTradePwdUrlString;
        [allParas setValue:kSaftToNSString([self.originalPassword md5String]) forKey:@"oldTradePwd"];
        [allParas setValue:kSaftToNSString([self.nePassword md5String]) forKey:@"newTradePwd"];
        [allParas setValue:kSaftToNSString(globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard) forKey:@"userType"];
    }
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:urlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
#pragma mark -- 懒加载
-(UITableView*)tradingPasswordTableView
{
    if (!_tradingPasswordTableView) {
        _tradingPasswordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tradingPasswordTableView.dataSource= self;
        _tradingPasswordTableView.delegate = self;
        [self.view addSubview:_tradingPasswordTableView];
    }
    return _tradingPasswordTableView;
}
-(NSArray*)placeholderArray
{
    if (!_placeholderArray) {
        if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
            _placeholderArray =[NSArray arrayWithObjects:kLocalized(@"GYHS_Pwd_Enter_New_Password"),kLocalized(@"GYHS_Pwd_Enter_New_Password_Again"), nil];
        }else {
            _placeholderArray =[NSArray arrayWithObjects:kLocalized(@"GYHS_Pwd_Enter_Original_Password"),kLocalized(@"GYHS_Pwd_Enter_New_Pwd"),kLocalized(@"GYHS_Pwd_Enter_New_Password_Again"), nil];
        }
    }
    return _placeholderArray;
}
-(NSArray*)textFiletitleArray
{
    if (!_textFiletitleArray) {
        if (self.tradingPasswordType == GYHSTradingPasswordTypeSet) {
            _textFiletitleArray = [NSArray arrayWithObjects:kLocalized(@"GYHS_Pwd_New_Pwd"),kLocalized(@"GYHS_Pwd_Login_Confirm_Trade_Pwd"), nil];
        }else {
            _textFiletitleArray = [NSArray arrayWithObjects:kLocalized(@"GYHS_Pwd_Original_Password"),kLocalized(@"GYHS_Pwd_New_Trade_Password"),kLocalized(@"GYHS_Pwd_Login_Confirm_Trade_Pwd"), nil];
        }
    }
    return _textFiletitleArray;
}
@end
