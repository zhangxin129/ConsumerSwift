//
//  GYHSCashToBankConfirmViewController.m
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCashToBankConfirmViewController.h"
#import "GYHSCashToBankConfirmCell.h"
#import "GYPasswordKeyboardView.h"
#import "IQKeyboardManager.h"
#import "NSString+YYAdd.h"
#import "GYAlertView.h"

@interface GYHSCashToBankConfirmViewController ()<UITableViewDataSource,UITableViewDelegate,GYPasswordKeyboardViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,copy) NSString *feeStr;//货币转换费
@property (nonatomic,copy) NSString *userName;//非持卡人信息

@end

@implementation GYHSCashToBankConfirmViewController

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

// #pragma mark - SystemDelegate   
#pragma mark TableView Delegate    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHSCashToBankConfirmCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kGYHSCashToBankConfirmCellIdentifier];
    if(!cell) {
        cell = [[GYHSCashToBankConfirmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSCashToBankConfirmCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    [cell refreshTitle:dict[@"title"] detail:dict[@"value"]];
    

    return cell;
}

#pragma mark - CustomDelegate

#pragma mark -GYPasswordKeyboardViewDelegate 
-(void)returnPasswordKeyboard:(GYPasswordKeyboardView *)passwordKeyboard style:(GYPasswordKeyboardStyle)style type:(GYPasswordKeyboardReturnType)type password:(NSString *)password {
    if (password.length != 8) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_please_enter_trade_pwd")];
        return;
    }

    
    if(globalData.loginModel.cardHolder) {
        [self loadNetworkForCashToBank:password];
    }else {
        [self loadNetworkForNoCardInfo:password];
    }
    
}


-(void)cancelClick {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - event response
//获取非持卡人的信息
-(void)loadNetworkForNoCardInfo:(NSString *)password {

    [GYGIFHUD show];
    WS(weakSelf)
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSGetInfo parameters:@{ @"userId" : kSaftToNSString(globalData.loginModel.custId) } requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        self.userName = kSaftToNSString(dic[@"name"]);
        
        if(self.userName) {
            [weakSelf loadNetworkForCashToBank:password];
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//货币转银行提交
-(void)loadNetworkForCashToBank:(NSString *)password {

    NSDictionary* allFixParas = @{
                                  @"channel" : kChannelMOBILE,
                                  @"custType" : globalData.loginModel.cardHolder ? kCustTypeCard : kCustTypeNoCard, //非持卡人传51
                                  @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                                  @"transPwd" : [password md5String],
                                  
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"hsResNo"];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    [allParas setValue:kSaftToNSString(self.model.bankAccNo) forKey:@"bankAcctNo"];
    if (globalData.loginModel.cardHolder) {
        [allParas setValue:kSaftToNSString(globalData.loginModel.custName) forKey:@"custName"];
        [allParas setValue:kSaftToNSString(globalData.loginModel.resNo) forKey:@"reqOptId"];
        [allParas setValue:kSaftToNSString(globalData.loginModel.custName) forKey:@"reqOptName"];
    }
    else {
        [allParas setValue:kSaftToNSString(self.userName) forKey:@"custName"];
        [allParas setValue:kSaftToNSString(globalData.loginModel.userName) forKey:@"reqOptId"];
        [allParas setValue:kSaftToNSString(self.userName) forKey:@"reqOptName"];
    }
    
    [allParas setValue:kSaftToNSString(self.model.bankCode) forKey:@"bankNo"];
    [allParas setValue:kSaftToNSString(self.model.provinceCode) forKey:@"bankProvinceNo"];
    [allParas setValue:kSaftToNSString(self.model.cityCode) forKey:@"bankCityNo"];
    [allParas setValue:kSaftToNSString(self.model.bankAccName) forKey:@"bankAcctName"];
    [allParas setValue:kSaftToNSString(globalData.custGlobalDataModel.currencyCode) forKey:@"currencyCode"];
    
    [allParas setValue:kSaftToNSString(self.cashStr) forKey:@"amount"];
    [allParas setValue:kSaftToNSString(self.model.bankBranch) forKey:@"bankBranch"];
    [allParas setValue:kSaftToNSString(self.model.isValidAccount) forKey:@"isVerify"];
    [allParas setValue:kSaftToNSString(self.feeStr) forKey:@"feeAmt"];
    //银行账号编号
    [allParas setValue:kSaftToNSString(self.model.accId) forKey:@"accId"];
    
     GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kUrlSaveTransOut parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
         [GYGIFHUD dismiss];
         if (error) {
             [GYUtils parseNetWork:error resultBlock:nil];
         }else {
             [GYAlertView showMessage:kLocalized(@"GYHS_Cash_Commit_To_Bank_success") confirmBlock:^{
                 if(self.delegate && [self.delegate respondsToSelector:@selector(cashToCashSuccess)]) {
                     [self.delegate cashToCashSuccess];
                 }
                 [self.navigationController popViewControllerAnimated:YES];
             } withColor:UIColorFromRGB(0x1d7dd6)];
         }
     }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}

//获取转换费
-(void)loadNetworkForCashToBankFee {
   
    NSDictionary* allFixParas = @{
                                  @"transAmount" : self.cashStr,
                                  @"sysFlag" : @"N"
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:kSaftToNSString(self.model.bankCode) forKey:@"inAccBankNode"];
    [allParas setValue:kSaftToNSString(self.model.cityCode) forKey:@"inAccCityCode"];
    
    GYNetRequest* requset = [[GYNetRequest alloc] initWithBlock:kUrlGetBankTransFee parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            NSString *feeStr = responseObject[@"data"];
            self.feeStr = feeStr;
            NSDictionary *dict = @{@"title":kLocalized(@"GYHS_MyAccounts_NumberToBankAccount"),
                                   @"value":[GYUtils formatCurrencyStyle:[self.cashStr doubleValue]]
                                   };
            [self.dataSource replaceObjectAtIndex:1 withObject:dict];
            dict = @{@"title":kLocalized(@"GYHS_MyAccounts_transfer_fee"),
                     @"value":[GYUtils formatCurrencyStyle:[feeStr doubleValue]]
                     };
            [self.dataSource replaceObjectAtIndex:2 withObject:dict];
            [self.tableView reloadData];
            
        }
    }];
    [requset setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    requset.tag = 1;
    [GYGIFHUD show];
    [requset start];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"GYHS_MyAccounts_cash_to_bank");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
    [self loadNetworkForCashToBankFee];
    self.tableView.tableFooterView = [self footerView];
}

-(UIView *)footerView {
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];

    GYPasswordKeyboardView *keyboardView = [[GYPasswordKeyboardView alloc] init];
    keyboardView.frame = CGRectMake(0, 0, kScreenWidth, 300);
    keyboardView.style = GYPasswordKeyboardStyleTrading;
    keyboardView.delegate = self;
    [keyboardView pop:footerView];
    
    return footerView;
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delaysContentTouches = NO;
        [_tableView registerClass:[GYHSCashToBankConfirmCell class] forCellReuseIdentifier:kGYHSCashToBankConfirmCellIdentifier];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSArray *)dataSource {

    if(!_dataSource) {
        _dataSource = [NSMutableArray arrayWithArray:
                       @[@{@"title":kLocalized(@"GYHS_MyAccounts_NumberForCashToBank"),
                           @"value":[GYUtils formatCurrencyStyle:[self.cashStr doubleValue]]
                        },
                       @{@"title":kLocalized(@"GYHS_MyAccounts_NumberToBankAccount"),
                         @"value":@"0.00"
                         },
                         @{@"title":kLocalized(@"GYHS_MyAccounts_transfer_fee"),
                           @"value":@"0.00"
                           },
                         ]
                       ];
        
    }
    return _dataSource;
}

@end
