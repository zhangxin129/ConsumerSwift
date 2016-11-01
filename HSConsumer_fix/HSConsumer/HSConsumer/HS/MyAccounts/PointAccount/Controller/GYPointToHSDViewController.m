//
//  GYPointToCashViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-24.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//积分转互生币与积分投资、互生币转货币页面

#import "GYPointToHSDViewController.h"
#import "GYPointToHSDNextViewController.h"
#import "GYGIFHUD.h"
#import "GYAlertView.h"
#import "GYHSImageTitleNumberCell.h"
#import "GYHSTableViewWarmCell.h"
#import "GYHSButtonCell.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSLoginManager.h"

@interface GYPointToHSDViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate, GYHSButtonCellDelegate> {
}

@property (nonatomic, strong) UITableView* pointHSBTableView;
@property (nonatomic, copy) NSArray* warnArray;
@property (nonatomic, copy) NSArray* titleArray;
@property (nonatomic, copy) NSMutableArray* titleRequesArray;
@property (nonatomic, copy) NSString* textFieldString;
@property (nonatomic, copy) NSString* titleStrng;
@property (nonatomic, copy) NSString* textPor;
@property (nonatomic, copy) NSString* detString;
@property (nonatomic, copy) NSDictionary* requestDic;
@property (nonatomic, assign)CGFloat labelheight;
@end

@implementation GYPointToHSDViewController
- (void)integralQuery
{
    NSString* accCategory;
    if ([self.type isEqualToString:@"2"]) {
        accCategory = kTypeHSDBalanceDetail;
    }
    else {
        accCategory = kTypePointBalanceDetail;
    }
    NSDictionary* allFixParas = @{
        @"accCategory" : accCategory,
        @"systemType" : kSystemTypeConsumer,
        @"custId" : globalData.loginModel.custId
    };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kAccountBalanceDetailUrlString parameters:allFixParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{

    self.requestDic = responseObject[@"data"];
    if (![responseObject isKindOfClass:[NSNull class]] && responseObject && responseObject.count) {
        if (![self.requestDic isKindOfClass:[NSNull class]] && self.requestDic && self.requestDic.count) {
            if ([self.type isEqualToString:@"2"]) { //互生币账户
                globalData.user.HSDToCashAccBal = [kSaftToNSString(self.requestDic[@"ltbBalance"]) doubleValue];
                globalData.user.hsdToCashCurrencyConversionFee = [kSaftToNSString(self.requestDic[@"hsbChangeHbRatio"]) doubleValue];
                self.integral = self.requestDic[@"ltbBalance"];
            }
            else { //积分账户
                globalData.user.pointAccBal = [self.requestDic[@"accountBalance"] doubleValue];
                globalData.user.availablePointAmount = [self.requestDic[@"canUsePoints"] doubleValue];
                globalData.user.todayPointAmount = [self.requestDic[@"todayPoints"] doubleValue];
                self.integral = self.requestDic[@"canUsePoints"];
            }
            [self.pointHSBTableView reloadData];
        }
    }
    else {
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:@"GYHSImageTitleNumberCell" bundle:nil] forCellReuseIdentifier:@"GYHSImageTitleNumberCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:@"GYHSTableViewWarmCell" bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:@"GYHSLableTextFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTwoTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    self.pointHSBTableView.backgroundColor = kDefaultVCBackgroundColor;
    self.pointHSBTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self integralQuery];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self integralQuery];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
        return 1;
    }
    else if (section == 1) {
        return self.titleArray.count;
    }
    else if (section == 2) {
        return self.warnArray.count;
    }
    else {
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHSImageTitleNumberCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSImageTitleNumberCell"];
        cell.titleLabel.textColor = kCellItemTitleColor;
        if ([self.type isEqualToString:@"2"]) {
            cell.imgV.image = [UIImage imageNamed:@"hs_cell_img_HSC_to_cash_acc"];
            cell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_coins_to_cash_account_available_balance");
        }
        else {
            cell.imgV.image = [UIImage imageNamed:@"hs_cell_img_points_account"];
            cell.titleLabel.text = kLocalized(@"GYHS_MyAccounts_available_Points");
        }
        cell.numberLabel.text = [GYUtils formatCurrencyStyle:[self.integral floatValue]];
        return cell;
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            GYHSLableTextFileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell"];
            cell.titleLabel.textColor = kCellItemTitleColor;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if (self.titleRequesArray.count > indexPath.row) {
                cell.textField.placeholder = self.titleRequesArray[indexPath.row];
            }
            cell.textField.text = self.textFieldString;
        
            cell.textField.delegate = self;
            if ([self.type isEqualToString:@"2"] || [self.type isEqualToString:@"1"]) {
                cell.titlelabelWith.constant = 150;
            }
            return cell;
        }
        else {
            GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell"];
            cell.titleLabel.textColor = kCellItemTitleColor;
            [cell.detLabel setTextColor:kValueRedCorlor];
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if ([self.type isEqualToString:@"2"]) {
                cell.detLabel.textColor = kCellItemTitleColor;
                if (indexPath.row == 2) {
                    NSString* string = @"1%";
                    NSString* str = [NSString stringWithFormat:@"%@(%@)", self.titleArray[indexPath.row], string];
                    NSMutableAttributedString* attrstr = [[NSMutableAttributedString alloc] initWithString:str];
                    [attrstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([self.titleArray[indexPath.row] length] + 1, [string length])];
                    cell.titleLabel.attributedText = attrstr;
                }
                cell.titleLabelWith.constant = 150;
                [cell.detLabel setTextColor:kCellItemTitleColor];
                if (indexPath.row != 3) {
                    cell.bottomlb.hidden =YES;
                }
                if (indexPath.row ==1) {
                    cell.toplb.hidden =YES;
                }
            }
            if ([self.type isEqualToString:@"1"]) {
                cell.titleLabelWith.constant = 150;
            }
            if (indexPath.row == 1) {
                cell.toplb.hidden =YES;
            }
            if (self.titleRequesArray.count > indexPath.row) {
                cell.detLabel.text = self.titleRequesArray[indexPath.row];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        GYHSTableViewWarmCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell"];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        if (indexPath.row == 0) {
            cell.redImage.hidden = YES;
            cell.labelspacing.constant = -10;
        }
        if (self.warnArray.count > indexPath.row) {
            cell.label.text = self.warnArray[indexPath.row];
        }
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.label setTextColor:kCellItemTextColor];
        cell.label.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.type isEqualToString:@"1"]) {
            if (indexPath.row == 2) {
                cell.label.lineBreakMode = NSLineBreakByWordWrapping;
                CGSize size = [cell.label sizeThatFits:CGSizeMake(cell.label.frame.size.width, MAXFLOAT)];
                self.labelheight = size.height;
            }
        }else {
            if (indexPath.row == 1) {
                cell.label.lineBreakMode = NSLineBreakByWordWrapping;
                CGSize size = [cell.label sizeThatFits:CGSizeMake(cell.label.frame.size.width, MAXFLOAT)];
                self.labelheight = size.height;
            }

        }
      return cell;
    }
    else {
        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell"];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        if ([self.type isEqualToString:@"2"]) {
            [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_change_next") forState:UIControlStateNormal];
        }
        else {
            [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_next_step") forState:UIControlStateNormal];
        }
        [cell.btnTitle setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
        cell.btnDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 0.1;
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.section == 0) {
        return 75;
    }

    else if (indexPath.section == 2) {
        if ([self.type isEqualToString:@"0"]) {
            return 20;
        }
        else if ([self.type isEqualToString:@"1"]) {
            if (indexPath.row == 2) {
                
                return self.labelheight;
            }
            else {
               return 20;
            }
        }
        else {
            if (indexPath.row == 0) {
                return 25;
            }
            else {
                return self.labelheight+4;
            }
        }
    }
    else if (indexPath.section == 3) {
        return 60;
    }
    else {
        return 50;
    }
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.view endEditing:YES];
}

#pragma mark - 自定义方法
//下一步操作
- (void)nextBtn
{

    if (self.textFieldString.length > 0 && self.textFieldString > 0) { //输入合法
        if ([self.type isEqualToString:@"2"]) {
            if ([self.textFieldString doubleValue] > globalData.user.HSDToCashAccBal) { //输入大于可用互生币余额
                [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_inputAmountGreaterThanTheAccountBalancePleaseEnterAgain")];
                return;
            }
            if ([self.textFieldString doubleValue] < globalData.custGlobalDataModel.hsbToHbMin.doubleValue) {
                NSString* message = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_alternateCurrencyTransferCurrencyAccountForNotLessThan%@Integers"), [GYUtils formatCurrencyStyle:globalData.custGlobalDataModel.hsbToHbMin.doubleValue]];
                [GYUtils showMessage:message];
                return;
            }
        }
        else {
            if ([self.textFieldString doubleValue] > globalData.user.availablePointAmount) { //输入大于可用积分
                [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_inputTheNumberGreaterThanTheAvailableIntegralPleaseEnterAgain")];
                return;
            }
            NSString *msg1;
            if ([self.type isEqualToString:@"1"]) {
                msg1 = kLocalized(@"GYHS_MyAccounts_minimum_limit_of_point_investment");
            }else if ([self.type isEqualToString:@"0"]){
                msg1 = kLocalized(@"GYHS_MyAccounts_integralAlternateCurrencyIntegralIntegerNumberIsNotLessThan%@");
            }
            if ([self.textFieldString doubleValue] < globalData.custGlobalDataModel.investPointMin.doubleValue) { //个人积分转现最少
                NSString* message = [NSString stringWithFormat:msg1, [GYUtils formatCurrencyStyle:globalData.custGlobalDataModel.investPointMin.doubleValue]];
                [GYUtils showMessage:message];
                return;
            }
        }
        //进入下一步
        GYPointToHSDNextViewController* nextVC = kLoadVcFromClassStringName(NSStringFromClass([GYPointToHSDNextViewController class]));
        nextVC.integral = self.textFieldString;
        nextVC.type = self.type;
        if ([self.type isEqualToString:@"0"]) { //积分转互生币
            nextVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_point_to_hsd_confirm");
        }
        else if ([self.type isEqualToString:@"1"]) { //积分投资
            if ((int)[self.textFieldString doubleValue] % 100 > 0) { //100的整数倍
                [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_investmentAmountTo100IntegerTimes")];
                return;
            }
            nextVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_point_to_invest_confirm");
        }
        else if ([self.type isEqualToString:@"2"]) {
            nextVC.title = kLocalized(@"GYHS_MyAccounts_hsdtocash_to_cash_confirm");
            nextVC.delArray = @[ [GYUtils formatCurrencyStyle:self.textFieldString.doubleValue],
                kLocalized(@"GYHS_MyAccounts_cash_account"),
                self.titleRequesArray[2],
                self.titleRequesArray[3],
                kLocalized(@"GYHS_MyAccounts_RMB"),
                [NSString stringWithFormat:@"%.4f", [globalData.custGlobalDataModel.currencyToHsbRate doubleValue]],
                self.titleRequesArray[3] ];
        }
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else { //输入不合法
        NSString *message;
        if ([self.type isEqualToString:@"0"]) {
            message = kLocalized(@"GYHS_MyAccounts_input_points");
        }else if ([self.type isEqualToString:@"1"]){
            message = kLocalized(@"GYHS_MyAccounts_pleaseEnterTheInvestmentIntegralNumber");
        }else {
            message = kLocalized(@"GYHS_MyAccounts_pleaseEnterTheIntegralNumber");
        }
        [GYUtils showMessage:message];
    }
}

#pragma mark - UITextFieldDelegate
//输入积分数，同步显示将转成现金数
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
        if ([self.type isEqualToString:@"2"]) {

            double v1 = [toBeString doubleValue] * globalData.user.hsdToCashCurrencyConversionFee;
            double v2 = [toBeString doubleValue] - v1;
            [self.titleRequesArray replaceObjectAtIndex:2 withObject:[GYUtils formatCurrencyStyle:v1]];
            [self.titleRequesArray replaceObjectAtIndex:3 withObject:[GYUtils formatCurrencyStyle:v2]];
            NSIndexPath* ind3 = [NSIndexPath indexPathForRow:2 inSection:1];
            NSIndexPath* ind4 = [NSIndexPath indexPathForRow:3 inSection:1];
            [self.pointHSBTableView reloadRowsAtIndexPaths:@[ ind3, ind4 ] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSCharacterSet* cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
        
    }
    return YES;
}
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}

#pragma mark 懒加载 0 积分转互生币  1 积分投资 2 互生币转货币
- (NSArray*)warnArray
{
    if (!_warnArray) {
        if ([self.type isEqualToString:@"0"]) {
            _warnArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_WellTip"), kLocalized(@"GYHS_MyAccounts_point_to_cash_tip1"), [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_point_to_hsd_tip2"), globalData.custGlobalDataModel.pointMin], nil];
        }
        else if ([self.type isEqualToString:@"1"]) {
            _warnArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_investment_instructions"), kLocalized(@"GYHS_MyAccounts_investmentAmountTo100IntegerTimes"), kLocalized(@"GYHS_MyAccounts_investment_instructions_2"), kLocalized(@"GYHS_MyAccounts_investment_instructions_3"), nil];
        }
        else if ([self.type isEqualToString:@"2"]) {
            _warnArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_WellTip"), [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_hsd_to_cash_tip1"), [NSString stringWithFormat:@"%ld",globalData.custGlobalDataModel.hsbToHbMin.integerValue]], [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_hsd_to_cash_tip2"), [NSString stringWithFormat:@"%d%%", (int)([globalData.custGlobalDataModel.hsbToHbRate doubleValue] * 100)]], nil];
        }
    }
    return _warnArray;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        if ([self.type isEqualToString:@"0"]) {
            _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_number_of_turn_to_cash"), kLocalized(@"GYHS_MyAccounts_tra_to_account"), nil];
        }
        else if ([self.type isEqualToString:@"1"]) {
            _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_investment_points"), kLocalized(@"GYHS_MyAccounts_tra_to_account"), nil];
        }
        else if ([self.type isEqualToString:@"2"]) {
            _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_input_hsdtocash_to_cash_amount"), kLocalized(@"GYHS_MyAccounts_tra_to_account"), kLocalized(@"GYHS_MyAccounts_hsdtocash_to_cash_fee"), kLocalized(@"GYHS_MyAccounts_hsd_to_cash_actual_amount"), nil];
        }
    }
    return _titleArray;
}

- (NSMutableArray*)titleRequesArray
{
    if (!_titleRequesArray) {
        if ([self.type isEqualToString:@"0"]) {
            _titleRequesArray = [[NSMutableArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_input_points"), kLocalized(@"GYHS_MyAccounts_accounts"), nil];
        }
        else if ([self.type isEqualToString:@"1"]) {
            _titleRequesArray = [[NSMutableArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_input_number_of_points_to_invest"), kLocalized(@"GYHS_MyAccounts_investment_account"), nil];
        }
        else if ([self.type isEqualToString:@"2"]) {
            _titleRequesArray = [[NSMutableArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_hsdtocash_tipinput"), kLocalized(@"GYHS_MyAccounts_cash_account"), @"0.00", @"0.00", nil];
        }
    }
    return _titleRequesArray;
}

- (UITableView*)pointHSBTableView
{
    if (!_pointHSBTableView) {
        _pointHSBTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _pointHSBTableView.delegate = self;
        _pointHSBTableView.dataSource = self;
        [self.view addSubview:_pointHSBTableView];
    }
    return _pointHSBTableView;
}
@end
