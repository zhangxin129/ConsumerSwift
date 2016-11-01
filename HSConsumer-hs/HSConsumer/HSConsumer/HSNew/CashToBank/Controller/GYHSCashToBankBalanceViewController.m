//
//  GYHSCashToBankBalanceViewController.m
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCashToBankBalanceViewController.h"
#import "GYHSCashToBankBalanceCell.h"
#import "GYHSCashToBalanceFooterView.h"
#import "GYHSBankCardListViewController.h"
#import "GYHSCashToBankConfirmViewController.h"
#import "GYHSCardBandModel.h"
#import "Masonry.h"


@interface GYHSCashToBankBalanceViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSBankCardListViewControllerDelegate,GYHSCashToBankConfirmViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;//数据源
@property (nonatomic,strong) GYHSCashToBalanceFooterView *footerView;//tableView 尾部视图
@property (nonatomic,copy) NSString *balance;//货币账户余额

@property (nonatomic,strong) GYHSCardBandModel *model;
@property (nonatomic,copy) NSString *cashStr;//输入的金额


@end

@implementation GYHSCashToBankBalanceViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate  
#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.text  = @"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.cashStr = textField.text;
    if (textField.text.length > 0) {
         textField.text = [GYUtils formatCurrencyStyle:kSaftToDouble(textField.text)];
    }
   
}

#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSCashToBankBalanceCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCashToBankBalanceCellIdentifier] ;
    if(!cell) {
        cell = [[GYHSCashToBankBalanceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSCashToBankBalanceCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.row == 1 || indexPath.row == 2) {
        cell.detailTextField.textColor = UIColorFromRGB(0x333333);
    }else {
        cell.detailTextField.textColor = UIColorFromRGB(0xef4136);
    }
    cell.detailTextField.delegate = self;
    
    if(indexPath.row == 2) {
        cell.selectBankImageView.hidden = NO;
        cell.detailTextField.frame = CGRectMake(cell.detailTextField.frame.origin.x, cell.detailTextField.frame.origin.y, cell.selectBankImageView.frame.origin.x -cell.detailTextField.frame.origin.x, cell.detailTextField.frame.size.height);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBank)];
        cell.selectBankImageView.userInteractionEnabled = YES;
        [cell.selectBankImageView addGestureRecognizer:tap];
        
    }else {
        cell.selectBankImageView.hidden = YES;
        cell.detailTextField.frame = CGRectMake(cell.detailTextField.frame.origin.x, cell.detailTextField.frame.origin.y, kScreenWidth -cell.detailTextField.frame.origin.x, cell.detailTextField.frame.size.height);
    }
    
    if(indexPath.row != 1) {
        cell.detailTextField.enabled = NO;
    }else {
        cell.detailTextField.enabled = YES;
        cell.detailTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    if (indexPath.row == 1 ) {
        [cell refreshTitle:dict[@"title"] placehold:dict[@"placehold"] detail:self.cashStr ?  [GYUtils formatCurrencyStyle:[self.cashStr doubleValue]] : @""];
    }else if (indexPath.row == 2) {
        NSString *bankAccNo;
        if(self.model.bankAccNo.length > 8) {
            bankAccNo = [NSString stringWithFormat:@"%@ **** **** %@",[self.model.bankAccNo substringToIndex:4],[self.model.bankAccNo substringFromIndex:self.model.bankAccNo.length -4]];
        }else {
            bankAccNo = self.model.bankAccNo;
        }
        [cell refreshTitle:dict[@"title"] placehold:dict[@"placehold"] detail:bankAccNo];
    }else {
        [cell refreshTitle:dict[@"title"] placehold:dict[@"placehold"] detail:dict[@"detail"]];
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

#pragma mark - CustomDelegate
//选择银行卡回调
-(void)selectBankCard:(GYHSCardBandModel *)model {

    self.model = model;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    GYHSCashToBankBalanceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(model.bankAccNo.length > 8) {
        cell.detailTextField.text = [NSString stringWithFormat:@"%@ **** **** %@",[model.bankAccNo substringToIndex:4],[model.bankAccNo substringFromIndex:model.bankAccNo.length -4]];
    }else {
        cell.detailTextField.text = model.bankAccNo;
    }
}

//重新获取银行卡默认接口
-(void)bankCardChange {
    
    [self loadNetWorkForDefaultBankCard];
}

#pragma mark - GYHSCashToBankConfirmViewControllerDelegate
//货币转银行成功
-(void)cashToCashSuccess {
    
    self.dataSource = nil;
    self.model = nil;
    self.cashStr = nil;
    [self loadNetWorkForBalance];
    
}


#pragma mark - event response
-(void)loadNetWorkForDefaultBankCard {

    NSDictionary* dict = @{ @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                            @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    [GYGIFHUD show];
    [Network GET:kUrlListBindBank parameters:dict completion:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (!error) {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                NSArray *arrData = responseObject[@"data"];
                
                BOOL isHaveDefault = NO;//是否有默认银行卡
                for (NSDictionary *tempDic in arrData) {
                    if ([tempDic[@"isDefault"] isEqualToString:@"1"]) {
                        GYHSCardBandModel *model = [[GYHSCardBandModel alloc] initWithDictionary:tempDic error:nil];
                        self.model = model;
                        self.dataSource = nil;
                        [self.tableView reloadData];
                        isHaveDefault = YES;
                    }
                }
                
                if (isHaveDefault == NO) {
                    self.model = nil;
                    self.dataSource = nil;
                    [self.tableView reloadData];
                }
            } else {
                [GYUtils showToast:kLocalized(@"GYHS_Banding_QueryDataFailure")];
            }
            
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
}

//获取账户余额
-(void)loadNetWorkForBalance {

    NSMutableDictionary* allParas = [[NSMutableDictionary alloc] init];
    [allParas setValue:kTypeCashBalanceDetail forKey:@"accCategory"];
    [allParas setValue:kSystemTypeConsumer forKey:@"systemType"];
    [allParas setValue:globalData.loginModel.custId forKey:@"custId"];
    [GYGIFHUD show];
    GYNetRequest *request =[[GYNetRequest alloc] initWithBlock:kAccountBalanceDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }else {
            NSDictionary *dic = responseObject;
            self.balance = dic[@"data"][@"accountBalance"];
            [self loadNetWorkForDefaultBankCard];
            
        }
        
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//选择银行卡
-(void)selectBank {

    [self.view endEditing:YES];
    GYHSBankCardListViewController *bankVC = [[GYHSBankCardListViewController alloc] init];
    bankVC.delegate = self;
    bankVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self addChildViewController:bankVC];
    [self.view addSubview:bankVC.view];
}

//下一步
-(void)nextStepClick {

     DDLogInfo(@"下一步");
    [self.view endEditing:YES];
    
    if(![self isDataValid]) {
        return ;
    }
    GYHSCashToBankConfirmViewController *confrimVC =  [[GYHSCashToBankConfirmViewController alloc] init];
    confrimVC.cashStr = self.cashStr;
    confrimVC.delegate = self;
    confrimVC.model = self.model;
    [self.navigationController pushViewController:confrimVC animated:YES];
}



#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self setUp];
    [self loadNetWorkForBalance];
}

-(void)setUp {

    self.footerView = [[GYHSCashToBalanceFooterView alloc] init];
    self.tableView.tableFooterView = self.footerView;
    [self.footerView.nextStep addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
}

-(BOOL)isDataValid {
    
    NSIndexPath *indexPath;
    GYHSCashToBankBalanceCell *cell ;
    double cash = [self.cashStr doubleValue];
    if (!(cell.detailTextField.text && cash >= 0)) { //输入合法
        
        if (cash == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_inputTransferAmountCannotBe0")];
            return NO;
        }
        
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (cell.detailTextField.text.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_pleaseSelectIntoBankAccounts")];
            return NO;
        }
        
        
        if (cash > [self.balance doubleValue]) { //输入大于账号余额
            [GYUtils showToast:kLocalized(@"GYHS_MyAccounts_greaterThanTheAmountInputsCurrencyAccountPleaseEnterAgain")];
            return NO;
        }
        
        if (cash < globalData.custGlobalDataModel.hbToBankMin.doubleValue) { //个人积分转现最少
            NSString* message = [NSString stringWithFormat:kLocalized(@"GYHS_MyAccounts_moneyTransferBankAmountIsNotLessThan%@Integer"), [GYUtils formatCurrencyStyle:globalData.custGlobalDataModel.hbToBankMin.doubleValue]];
            [GYUtils showToast:message];
            return NO;
        }
        
        if (cash > 2000000000) { //必须低于2000000000
            NSString* message = kLocalized(@"GYHS_MyAccounts_moneyTransferBankAmountMustBeInteger");
            [GYUtils showToast:message];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 刷新界面数据
-(void)reloadData {

    [self cashToCashSuccess];
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerClass:[GYHSCashToBankBalanceCell class] forCellReuseIdentifier:kGYHSCashToBankBalanceCellIdentifier];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
        
    }
    return _tableView;
}


-(NSArray *)dataSource {

    if(!_dataSource) {
        _dataSource = @[@{@"title":kLocalized(@"GYHS_HSAccount_cashAccountBalance"),
                          @"placehold":kLocalized(@""),
                          @"detail": self.balance != nil ? [GYUtils formatCurrencyStyle:[self.balance doubleValue]] : kLocalized(@"0.00"),
                          },
                        @{@"title":kLocalized(@"GYHS_MyAccounts_apply_transfer_amount"),
                          @"placehold":kLocalized(@"GYHS_MyAccounts_input_transfer_amount"),
                          @"detail":kLocalized(@""),
                          },
                        @{@"title":kLocalized(@"GYHS_MyAccounts_transfer_to_bank_account"),
                          @"placehold":kLocalized(@"GYHS_MyAccounts_SelectBankCardNumber"),
                          @"detail":self.model.bankAccNo != nil ? self.model.bankAccNo : kLocalized(@""),
                          },
                        @{@"title":kLocalized(@"GYHS_MyAccounts_settlement_currency"),
                          @"placehold":kLocalized(@""),
                          @"detail":kSaftToNSString(globalData.custGlobalDataModel.currencyName),
                          }
                        ];
    }
    return _dataSource;
}

@end
