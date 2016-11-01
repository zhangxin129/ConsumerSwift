//
//  GYHSBankCardAddViewController.m
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kDetailTextFieldTag 800

#import "GYHSBankCardAddViewController.h"
#import "GYHSBankCardAddCell.h"
#import "YYKit.h"
#import "GYHSSelectBankListViewController.h"
#import "GYHSBankListModel.h"
#import "GYHSSelectCountryViewController.h"
#import "GYHSCityAddressModel.h"
#import "Masonry.h"
#import "IQKeyboardManager.h"
#import "GYHSTools.h"

@interface GYHSBankCardAddViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSSelectBankListViewControllerDelegate,GYHSSelectCountryViewControllerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;//数据源
@property (nonatomic,strong) UIButton *bindingBtn;//立即绑定

@property (nonatomic,strong) GYHSBankListModel *bankModel;
@property (nonatomic,strong) GYHSCityAddressModel *areaModel;

@property (nonatomic,copy) NSString *bankNumber;//银行账号
@property (nonatomic,copy) NSString *confirmBankNumber;//确认银行账号
@property (nonatomic,weak) UISwitch *defaultSwitch;//设置为默认银行卡
@end

@implementation GYHSBankCardAddViewController

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
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if (textField.tag == kDetailTextFieldTag + 4) {
        self.bankNumber = textField.text;
    }else if (textField.tag == kDetailTextFieldTag + 5) {
        self.confirmBankNumber = textField.text;
    }
}

#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSBankCardAddCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSBankCardAddCellIdentifier];
    if (!cell) {
        cell = [[GYHSBankCardAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSBankCardAddCellIdentifier ];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextField.delegate = self;
    [cell.detailTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    cell.detailTextField.tag = indexPath.row + kDetailTextFieldTag;
    if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 6) {
        cell.detailTextField.enabled = NO;
    }else {
        cell.detailTextField.enabled = YES;
        cell.detailTextField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    if (indexPath.row == 2 || indexPath.row == 3) {
        cell.selectImageView.hidden = NO;
        if(indexPath.row == 2) {
            cell.areaBtn.hidden = YES;
            cell.selectImageView.image = [UIImage imageNamed:@"hs_cell_btn_bank"];
            cell.selectImageView.frame = CGRectMake(kScreenWidth - 18 - 30, 10, 30, 20);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBank)];
            cell.selectImageView.userInteractionEnabled = YES;
            [cell.selectImageView addGestureRecognizer:tap];
        }else {
            cell.areaBtn.hidden = NO;
            cell.selectImageView.image = [UIImage imageNamed:@"hs_cell_btn_right_arrow"];
            cell.selectImageView.frame = CGRectMake(kScreenWidth - 18 - 10, 11, 10, 18);
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectArea)];
            cell.selectImageView.userInteractionEnabled = YES;
            [cell.selectImageView addGestureRecognizer:tap];
            cell.areaBtn.frame = CGRectMake(kScreenWidth - 18 - 40, 10, 40, 25);
            [cell.areaBtn addTarget:self action:@selector(selectArea) forControlEvents:UIControlEventTouchUpInside];
        }
        cell.detailTextField.frame = CGRectMake(111 ,13, cell.selectImageView.left -111, 14);
    }else {
        cell.selectImageView.hidden = YES;
        cell.areaBtn.hidden = YES;
        cell.detailTextField.frame = CGRectMake(111, 13, kScreenWidth -111, 14);
    }
    
    
    if (indexPath.row == 6) {
        cell.defaultSwitch.hidden = NO;
        cell.titleLabel.frame = CGRectMake(13, 13, 150, 14);
        self.defaultSwitch = cell.defaultSwitch;
    }else {
        cell.defaultSwitch.hidden = YES;
        cell.titleLabel.frame = CGRectMake(13, 13, 98, 14);
    }
    
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    if (indexPath.row == 2) {
        [cell refreshTitle:dict[@"title"] placeholder:dict[@"placehold"] detail:self.bankModel.bankName ? self.bankModel.bankName : @""];
    }else if (indexPath.row == 3) {
        [cell refreshTitle:dict[@"title"] placeholder:dict[@"placehold"] detail:self.areaModel.cityFullName ? self.areaModel.cityFullName : @""];
    }else if (indexPath.row == 4) {
        [cell refreshTitle:dict[@"title"] placeholder:dict[@"placehold"] detail:self.bankNumber ? self.bankNumber :@""];
    }else if (indexPath.row == 5) {
        [cell refreshTitle:dict[@"title"] placeholder:dict[@"placehold"] detail:self.confirmBankNumber ? self.confirmBankNumber : @""];
    }else {
        [cell refreshTitle:dict[@"title"] placeholder:dict[@"placehold"] detail:dict[@"detail"]];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 40;
}

#pragma mark - CustomDelegate                                                                                                                                                                                                                                                                                                                                  
#pragma mark - GYHSSelectBankListViewControllerDelegate
-(void)didSelectBank:(GYHSBankListModel *)model {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    GYHSBankCardAddCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextField.text = model.bankName;
    self.bankModel = model;
}

#pragma mark - GYHSSelectCountryViewControllerDelegate 
-(void)selectArea:(GYHSCityAddressModel *)model {
    
    for (UIViewController *VC in self.childViewControllers) {
        [VC.view removeFromSuperview];
        [VC removeFromParentViewController];
    }

    NSString *cityFullName = @"";
    NSRange rang ;
    for (NSInteger i = 0; i<model.cityFullName.length; i++) {
        rang = NSMakeRange(i, 1);
        NSString *str = [model.cityFullName substringWithRange:rang];
        if (![str containsString:@"-"]) {
            cityFullName = [NSString stringWithFormat:@"%@%@",cityFullName,str];
        }
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    GYHSBankCardAddCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextField.text = cityFullName;
    self.areaModel = model;
}

#pragma mark - event response
//立即绑定
-(void)bindingRightNow {
    
    DDLogInfo(@"立即绑定");

    NSString *confirmNumber = @"";
    NSRange rang ;
    for (NSInteger i = 0; i<self.confirmBankNumber.length; i++) {
        rang = NSMakeRange(i, 1);
        NSString *str = [self.confirmBankNumber substringWithRange:rang];
        if (![str containsString:@" "]) {
            confirmNumber = [NSString stringWithFormat:@"%@%@",confirmNumber,str];
        }
    }
    self.confirmBankNumber = confirmNumber;
    
    NSString *bankNumber = @"";
    for (NSInteger i = 0; i<self.bankNumber.length; i++) {
        rang = NSMakeRange(i, 1);
        NSString *str = [self.bankNumber substringWithRange:rang];
        if (![str containsString:@" "]) {
            bankNumber = [NSString stringWithFormat:@"%@%@",bankNumber,str];
        }
    }
    self.bankNumber = bankNumber;

    if ([GYUtils checkStringInvalid:self.bankModel.bankName] ||
        [GYUtils checkStringInvalid:self.bankModel.bankNo]) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Please_Select_Bank")];
        return;
    }
    
    if ([GYUtils checkStringInvalid:self.areaModel.countryNo] ||
        [GYUtils checkStringInvalid:self.areaModel.provinceNo] ||
        [GYUtils checkStringInvalid:self.areaModel.cityNo]) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Please_Select_Account_Area")];
        return;
    }
    
    if (self.bankNumber.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Bank_Card_Number_Cannot_Empty")];
        return;
    }
    
    if (self.confirmBankNumber.length == 0) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Confirm_Card_Number_Cannot_Empty")];
        return;
    }
    
    if (![self.bankNumber isEqualToString:self.confirmBankNumber]) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Card_Number_Not_Agree_Please_Confirm_Again")];
        return;
    }
    
    if ([GYUtils isValidCreditNumber:self.bankNumber] ||
        [GYUtils isValidCreditNumber:self.confirmBankNumber]) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Enter_Bank_Account_Not_Correct")];
        return;
    }
    
    if((self.bankNumber.length < 5 || self.bankNumber.length >30) || (self.confirmBankNumber.length < 5 || self.confirmBankNumber.length >30)) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Bank_Card_Number5To30")];
        return;
    }
    
    if([GYUtils isIncludeChineseInString:self.bankNumber]) {
        [GYUtils showToast:kLocalized(@"GYHS_Banding_Bank_Card_Number_Illegal")];
        return;
    }
    
    
    [self loadNetwordForAddBankCard:self.confirmBankNumber];
}

//开户银行
-(void)selectBank {


    GYHSSelectBankListViewController *listVC = [[GYHSSelectBankListViewController alloc] init];
    listVC.delegate = self;
    listVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    listVC.view.frame = [UIScreen mainScreen].bounds;
    [self addChildViewController:listVC];
    [self.view addSubview:listVC.view];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:listVC.view];
    
    
}

//开户地区
-(void)selectArea {

    GYHSSelectCountryViewController *countryVC = [[GYHSSelectCountryViewController alloc] init];
    countryVC.delegate = self;
    countryVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    countryVC.view.frame = [UIScreen mainScreen].bounds;
    [self addChildViewController:countryVC];
    [self.view addSubview:countryVC.view];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:countryVC.view];
    
}

#pragma mark - 格式化银行账号
-(void)textChange:(UITextField *)textField {

    NSInteger row   = textField.text.length /5;
    if (row != 0 ) {
        NSMutableString *str = [[NSMutableString alloc] initWithString:textField.text];
        for (NSInteger i = 0; i<row; i++) {
            if (![[str substringWithRange:NSMakeRange(i*5+4, 1)] containsString:@" "]) {
                [str insertString:@" " atIndex:i*5+4];
            }
        }
        textField.text = str;
    }
    
    if ([textField.text hasSuffix:@" "]) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }

}

-(void)loadNetwordForAddBankCard:(NSString *)bankNumber {

    if (globalData.loginModel.custName == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Cash_Please_First_Real_Name_Registration")];
        return ;
    }
    NSString* url = kUrlBindBank;
    NSDictionary* paramDic = @{
                               @"custId" : globalData.loginModel.custId,
                               @"bankCode" : self.bankModel.bankNo,
                               @"bankName" : self.bankModel.bankName,
                               @"bankAcctNo" : bankNumber,
                               @"isDefault" : self.defaultSwitch.isOn == YES ? @"1": @"0",
                               @"userType" : globalData.loginModel.cardHolder ? kUserTypeCard : kUserTypeNoCard,
                               @"bankBranch" : @"",
                               @"acctType" : @"1",
                               @"countryCode" : self.areaModel.countryNo,
                               @"provinceCode" : self.areaModel.provinceNo,
                               @"cityCode" : self.areaModel.cityNo,
                               @"bankAccName" : kSaftToNSString(globalData.loginModel.custName),
                               @"hsResNo" :globalData.loginModel.resNo
                               };
    
     GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url parameters:paramDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
         [GYGIFHUD dismiss];
         if(error){
             [GYUtils parseNetWork:error resultBlock:nil];
         }else {
             WS(weakSelf)
             [GYUtils showMessage:kLocalized(@"GYHS_Banding_Tip_Your_Card_Is_Banding") confirm:^{
                 
                 [weakSelf.view removeFromSuperview];
                 [weakSelf removeFromParentViewController];
                 if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(addBankCardSuccess)]) {
                     [weakSelf.delegate addBankCardSuccess];
                 }
             } withColor:kBtnBlue];
        }
     }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [IQKeyboardManager sharedManager].enable  = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    [self.view addSubview:self.tableView];
}

//添加尾部 立即绑定
-(UIView *)addFooterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    self.bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.bindingBtn.frame = CGRectMake(13, 16, kScreenWidth -26, 41);
    [self.bindingBtn setTitle:kLocalized(@"GYHS_Banding_Rightnow") forState:UIControlStateNormal];
    [self.bindingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.bindingBtn.backgroundColor = UIColorFromRGB(0x1d7dd6);
    self.bindingBtn.layer.cornerRadius = 15;
    self.bindingBtn.clipsToBounds = YES;
    [self.bindingBtn addTarget:self action:@selector(bindingRightNow) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.bindingBtn];
    return footerView ;
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GYHSBankCardAddCell class] forCellReuseIdentifier:kGYHSBankCardAddCellIdentifier];
        _tableView.tableFooterView = [self addFooterView];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.mas_equalTo(0);
        }];
    }
    return _tableView;
}

-(NSArray *)dataSource {

    if(!_dataSource) {
        _dataSource = @[@{@"title":kLocalized(@"GYHS_Banding_RealName"),
                          @"placehold":kLocalized(@""),
                          @"detail":kSaftToNSString(globalData.loginModel.custName),
                          },
                        @{@"title":kLocalized(@"GYHS_Banding_SettlementCurrency"),
                          @"placehold":kLocalized(@""),
                          @"detail": globalData.custGlobalDataModel.currencyName,
                          },
                        @{@"title":kLocalized(@"GYHS_Banding_Bank"),
                          @"placehold":kLocalized(@"GYHS_Banding_PleaseSelect"),
                          @"detail":kLocalized(@""),
                          },
                        @{@"title":kLocalized(@"GYHS_MyAccounts_bank_open_area"),
                          @"placehold":kLocalized(@"GYHS_Banding_PleaseSelect"),
                          @"detail":kLocalized(@""),
                          },
                        @{@"title":kLocalized(@"GYHS_Banding_Bank_Card_Number"),
                          @"placehold":kLocalized(@"GYHS_Banding_Input_Bank_Card_Number"),
                          @"detail":kLocalized(@""),
                          },
                        @{@"title":kLocalized(@"GYHS_Banding_ConfirmCardNumber"),
                          @"placehold":kLocalized(@"GYHS_Banding_InputBankCardNoAgain"),
                          @"detail":kLocalized(@""),
                          },
                        
                        @{@"title":kLocalized(@"GYHS_Banding_Default_Card"),
                          @"placehold":kLocalized(@""),
                          @"detail":kLocalized(@""),
                          },
                        
                        ];
    }
    return  _dataSource;
}

@end
