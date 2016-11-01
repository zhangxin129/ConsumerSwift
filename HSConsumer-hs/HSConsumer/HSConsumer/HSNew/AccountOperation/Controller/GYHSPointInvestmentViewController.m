 //
//  GYHSPointInvestmentViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSPointInvestmentViewController.h"
#import "GYHSPointInvestmentNextViewController.h"
#import "GYGIFHUD.h"
#import "GYAlertView.h"
#import "GYHSTableViewWarmCell.h"
#import "GYHSButtonCell.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSLoginManager.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"

@interface GYHSPointInvestmentViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate, GYHSButtonCellDelegate,GYHSSuccessfulDealDelegate> {
}
@property (nonatomic, strong) UITableView* pointHSBTableView;
@property (nonatomic, copy) NSArray* warnArray;
@property (nonatomic, copy) NSArray* titleArray;
@property (nonatomic, copy) NSMutableArray* titleRequesArray;
@property (nonatomic, copy) NSString* textFieldString;
@property (nonatomic, copy) NSDictionary* requestDic;
@property (nonatomic, assign)CGFloat labelheight;
@property (nonatomic, copy)NSString *integral;
@end

@implementation GYHSPointInvestmentViewController
#pragma mark -- life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSTableViewWarmCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLableTextFileTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
    [self.pointHSBTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    self.pointHSBTableView.backgroundColor = kDefaultVCBackgroundColor;
    self.pointHSBTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self integralQuery];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self integralQuery];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}
-(void)refreshAccountBalance
{
    [self integralQuery];
}
#pragma mark -- 网络请求
- (void)integralQuery
{
    NSString* accCategory;
    if (self.accountOperationType  == GYHSHSBCurrencyType) {
        accCategory = kTypeHSDBalanceDetail;
    }
    else {
        accCategory = kTypePointBalanceDetail;
    }
    NSDictionary* allFixParas = @{
                                  @"accCategory" : accCategory,
                                  @"systemType" : kSystemTypeConsumer,
                                  @"custId" : kSaftToNSString(globalData.loginModel.custId) 
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
            if (self.accountOperationType  == GYHSHSBCurrencyType) { //互生币账户
                globalData.user.HSDToCashAccBal = [kSaftToNSString(self.requestDic[@"ltbBalance"]) doubleValue];
                globalData.user.hsdToCashCurrencyConversionFee = [kSaftToNSString(self.requestDic[@"hsbChangeHbRatio"]) doubleValue];
                self.integral = self.requestDic[@"ltbBalance"];
                [self.titleRequesArray replaceObjectAtIndex:0 withObject:[GYUtils formatCurrencyStyle:globalData.user.HSDToCashAccBal]];
            }
            else { //积分账户
                globalData.user.pointAccBal = [self.requestDic[@"accountBalance"] doubleValue];
                globalData.user.availablePointAmount = [self.requestDic[@"canUsePoints"] doubleValue];
                globalData.user.todayPointAmount = [self.requestDic[@"todayPoints"] doubleValue];
                self.integral = self.requestDic[@"canUsePoints"];
                [self.titleRequesArray replaceObjectAtIndex:0 withObject:[GYUtils formatCurrencyStyle: globalData.user.availablePointAmount]];
            }
            if ([self.integral doubleValue]<=0) {
                self.integral =@"0.00";
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
#pragma mark -- GYHSSuccessfulDealDelegate
-(void)successfulDeal
{
    [self integralQuery];
    self.textFieldString = @"";
    if (self.accountOperationType  == GYHSHSBCurrencyType) {
        [self.titleRequesArray replaceObjectAtIndex:3 withObject:@"0.00"];
        [self.titleRequesArray replaceObjectAtIndex:4 withObject:@"0.00"];
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
        return self.titleArray.count;
    }
    else if (section == 2) {
        return self.warnArray.count;
    }
    else {
        return 1;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 1){
            GYHSLableTextFileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.textColor = kCellItemTitleColor;
            cell.titlelabelWith.constant = 150;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if (self.titleRequesArray.count > indexPath.row) {
            cell.textField.placeholder = self.titleRequesArray[indexPath.row];
            }
            cell.toplinelb.hidden = YES;
            cell.textField.text = self.textFieldString;
            cell.textField.delegate = self;
            return cell;
        }
        else {
            GYHSLabelTwoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell"];
            cell.titleLabel.textColor = kCellItemTitleColor;
            cell.titleLabelWith.constant = 150;
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if (indexPath.row == 0) {
                
                if (self.titleRequesArray.count > indexPath.row) {
                    cell.detLabel.text = self.titleRequesArray[indexPath.row];
                }
                return cell;
            }else{
                if (self.titleRequesArray.count > indexPath.row) {
                    cell.detLabel.text = self.titleRequesArray[indexPath.row];
                }
                
                if (self.accountOperationType  == GYHSHSBCurrencyType) {
                    if (indexPath.row == 3) {
                        NSString* string = @"1%";
                        NSString* str = [NSString stringWithFormat:@"%@(%@)", self.titleArray[indexPath.row], string];
                        NSMutableAttributedString* attrstr = [[NSMutableAttributedString alloc] initWithString:str];
                        [attrstr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange([self.titleArray[indexPath.row] length] + 1, [string length])];
                        cell.titleLabel.attributedText = attrstr;
                    }
                    [cell.detLabel setTextColor:kCellItemTitleColor];
                    if (indexPath.row != 4) {
                        cell.bottomlb.hidden =YES;
                    }
                }
                if (indexPath.row == 2) {
                    cell.toplb.hidden =YES;
                    [cell.detLabel setTextColor:kValueRedCorlor];
                }
                return cell;
            }
        }
    }
    else if (indexPath.section == 1) {
        GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = kDefaultVCBackgroundColor;
        if (self.accountOperationType  == GYHSHSBCurrencyType) {
            [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_change_next") forState:UIControlStateNormal];
        }
        else {
            [cell.btnTitle setTitle:kLocalized(@"GYHS_MyAccounts_next_step") forState:UIControlStateNormal];
        }
        [cell.btnTitle setBackgroundImage:[UIImage imageNamed:@"gyhs_nextbtn"] forState:UIControlStateNormal];
        cell.btnDelegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else {
        GYHSTableViewWarmCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell"];
        cell.backgroundColor = kDefaultVCBackgroundColor;
        if (indexPath.row == 0) {
            cell.redImage.hidden = YES;
            cell.labelspacing.constant = -10;
        }else{
           cell.redImage.hidden = NO;
        }
        if (self.warnArray.count > indexPath.row) {
            cell.label.text = self.warnArray[indexPath.row];
        }
        cell.label.lineBreakMode = NSLineBreakByWordWrapping;
        [cell.label setTextColor:kCellItemTextColor];
        cell.label.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
   if (indexPath.section == 2) {
       CGFloat everyTipHeight;
       CGFloat distance = 8.0f;
       everyTipHeight = [GYUtils sizeForString:self.warnArray[indexPath.row] font:[UIFont systemFontOfSize:12.0] width:kScreenWidth - 70].height;
          return everyTipHeight + distance;
    }
    else if (indexPath.section == 1) {
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
        if (self.accountOperationType  == GYHSHSBCurrencyType) {
            if ([self.textFieldString doubleValue] > globalData.user.HSDToCashAccBal) { //输入大于可用互生币余额
                [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_inputAmountGreaterThanTheAccountBalancePleaseEnterAgain")];
                return;
            }
            if ([self.textFieldString doubleValue] < globalData.custGlobalDataModel.hsbToHbMin.doubleValue) {
                NSString* message = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_alternateCurrencyTransferCurrencyAccountForNotLessThan%@Integers"),globalData.custGlobalDataModel.hsbToHbMin];
                [GYUtils showMessage:message];
                return;
            }
        }
        else {
            if ([self.textFieldString doubleValue] > globalData.user.availablePointAmount) { //输入大于可用积分
                if (self.accountOperationType  == GYHSPointInvestmentType) {
                   [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_inputTheNumberGreaterThanTheAvailableIntegralPleaseEnterAgain")];
                }else if(self.accountOperationType  == GYHSPointHSBType){
                   [GYUtils showMessage:kLocalized(@"转出积分数大于可用积分数，请重新输入!")];
                }
                
                return;
            }
            NSString *msg1;
            if (self.accountOperationType  == GYHSPointInvestmentType) {
                msg1 = kLocalized(@"GYHS_MyAccounts_minimum_limit_of_point_investment");
            }else if (self.accountOperationType  == GYHSPointHSBType){
                msg1 = kLocalized(@"GYHS_MyAccounts_integralAlternateCurrencyIntegralIntegerNumberIsNotLessThan");
            }
            if ([self.textFieldString doubleValue] < globalData.custGlobalDataModel.investPointMin.doubleValue) { //个人积分转现最少
                
                [GYUtils showMessage:msg1];
                return;
            }
        }
        //进入下一步
        GYHSPointInvestmentNextViewController* nextVC = kLoadVcFromClassStringName(NSStringFromClass([GYHSPointInvestmentNextViewController class]));
        nextVC.successfulDealDelegate = self;
        nextVC.integral = self.textFieldString;
        nextVC.accountOperationType = self.accountOperationType;
        if (self.accountOperationType  == GYHSPointHSBType) { //积分转互生币
            nextVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_point_to_hsd_confirm");
        }
        else if (self.accountOperationType  == GYHSPointInvestmentType) { //积分投资
            if ((int)[self.textFieldString doubleValue] % 100 > 0) { //100的整数倍
                [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_investmentAmountTo100IntegerTimes")];
                return;
            }
            nextVC.navigationItem.title = kLocalized(@"GYHS_MyAccounts_point_to_invest_confirm");
        }
        else if (self.accountOperationType  == GYHSHSBCurrencyType) {
            nextVC.title = kLocalized(@"GYHS_MyAccounts_hsdtocash_to_cash_confirm");
            nextVC.delArray = @[ [GYUtils formatCurrencyStyle:self.textFieldString.doubleValue],
                                 self.titleRequesArray[3],
                                 self.titleRequesArray[4],
                                 ];
        }
        
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    else { //输入不合法
        NSString *message;
        if (self.accountOperationType  == GYHSHSBCurrencyType) {
            message = kLocalized(@"GYHS_MyAccounts_hsdtocash_tipinput");
        }else if (self.accountOperationType  == GYHSPointInvestmentType){
            message = kLocalized(@"GYHS_MyAccounts_pleaseEnterTheInvestmentIntegralNumber");
        }else {
            message = kLocalized(@"转出积分数不能为空！");
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
        if (self.accountOperationType  == GYHSHSBCurrencyType) {
            double v1 = [toBeString doubleValue] * globalData.user.hsdToCashCurrencyConversionFee;
            double v2 = [toBeString doubleValue] - v1;
            [self.titleRequesArray replaceObjectAtIndex:3 withObject:[GYUtils formatCurrencyStyle:v1]];
            [self.titleRequesArray replaceObjectAtIndex:4 withObject:[GYUtils formatCurrencyStyle:v2]];
            NSIndexPath* ind3 = [NSIndexPath indexPathForRow:3 inSection:0];
            NSIndexPath* ind4 = [NSIndexPath indexPathForRow:4 inSection:0];
            [self.pointHSBTableView reloadRowsAtIndexPaths:@[ ind3, ind4 ] withRowAnimation:UITableViewRowAnimationNone];
        }
        NSCharacterSet* cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }
    return YES;
}
//- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
//{
//    [self.view endEditing:YES];
//}

#pragma mark 懒加载 0 积分转互生币  1 积分投资 2 互生币转货币
- (NSArray*)warnArray
{
    if (!_warnArray) {
        if (self.accountOperationType  == GYHSPointHSBType) {
            _warnArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_WellTip"), kLocalized(@"GYHS_MyAccounts_point_to_cash_tip1"), kLocalized(@"GYHS_MyAccounts_point_to_hsd_tip2"), nil];
        }
        else if (self.accountOperationType  == GYHSPointInvestmentType) {
            _warnArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_investment_instructions"),
                               kLocalized(@"GYHS_MyAccounts_investment_instructions_2"),
                               kLocalized(@"GYHS_MyAccounts_investmentAmountTo100IntegerTimes"),kLocalized(@"GYHS_MyAccounts_investment_instructions_3"), nil];
//            CGSize size = [GYUtils sizeForString:_warnArray[1] font:[UIFont systemFontOfSize:12.0] width:kScreenWidth - 43];
//            self.labelheight = size.height;
        }
        else if (self.accountOperationType  == GYHSHSBCurrencyType) {
            _warnArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_WellTip"), [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_hsd_to_cash_tip1"), [NSString stringWithFormat:@"%zd",globalData.custGlobalDataModel.hsbToHbMin.integerValue]], [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_hsd_to_cash_tip2"), [NSString stringWithFormat:@"%d%%", (int)([globalData.custGlobalDataModel.hsbToHbRate doubleValue] * 100)]], nil];
//            CGSize size = [GYUtils sizeForString:_warnArray[1] font:[UIFont systemFontOfSize:12.0] width:kScreenWidth - 43];
//            self.labelheight = size.height;
        }
    }
    return _warnArray;
}

- (NSArray*)titleArray
{
    if (!_titleArray) {
        if (self.accountOperationType  == GYHSPointHSBType) {
            _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_available_Points"),kLocalized(@"GYHS_MyAccounts_number_of_turn_to_cash"), kLocalized(@"GYHS_MyAccounts_tra_to_account"), nil];
        }
        else if (self.accountOperationType  == GYHSPointInvestmentType) {
            _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_available_Points"),kLocalized(@"GYHS_MyAccounts_investment_points"), kLocalized(@"GYHS_MyAccounts_tra_to_account"), nil];
        }
        else if (self.accountOperationType  == GYHSHSBCurrencyType) {
            _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_MyAccounts_coins_to_cash_account_available_balance"),kLocalized(@"GYHS_MyAccounts_input_hsdtocash_to_cash_amount"), kLocalized(@"GYHS_MyAccounts_tra_to_account"), kLocalized(@"GYHS_MyAccounts_hsdtocash_to_cash_fee"), kLocalized(@"GYHS_MyAccounts_hsd_to_cash_actual_amount"), nil];
        }
    }
    return _titleArray;
}

- (NSMutableArray*)titleRequesArray
{
    if (!_titleRequesArray) {
        _titleRequesArray = [[NSMutableArray alloc] init];
        if (self.accountOperationType  == GYHSPointHSBType) {
            [_titleRequesArray addObject:[GYUtils formatCurrencyStyle:globalData.user.availablePointAmount]];
            [_titleRequesArray addObject:kLocalized(@"GYHS_MyAccounts_input_points")];
            [_titleRequesArray addObject:kLocalized(@"GYHS_MyAccounts_accounts")];
        }
        else if (self.accountOperationType  == GYHSPointInvestmentType) {
            [_titleRequesArray addObject:[GYUtils formatCurrencyStyle:globalData.user.availablePointAmount]];
            [_titleRequesArray addObject:kLocalized(@"GYHS_MyAccounts_input_number_of_points_to_invest")];
            [_titleRequesArray addObject:kLocalized(@"GYHS_MyAccounts_investment_account")];
        }
        else if (self.accountOperationType  == GYHSHSBCurrencyType) {
            [_titleRequesArray addObject:[GYUtils formatCurrencyStyle:[self.integral doubleValue]]];
            [_titleRequesArray addObject:kLocalized(@"GYHS_MyAccounts_hsdtocash_tipinput")];
            [_titleRequesArray addObject:kLocalized(@"GYHS_MyAccounts_cash_account")];
            [_titleRequesArray addObject:@"0.00"];
            [_titleRequesArray addObject:@"0.00"];
        }
    }
    return _titleRequesArray;
}

- (UITableView*)pointHSBTableView
{
    if (!_pointHSBTableView) {
        _pointHSBTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _pointHSBTableView.delegate = self;
        _pointHSBTableView.dataSource = self;
        [self.view addSubview:_pointHSBTableView];
        [_pointHSBTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _pointHSBTableView;
}
@end
