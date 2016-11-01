//
//  GYHSBandAccountAddVC.m
//  HSCompanyPad
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSBankAccountAddVC.h"
#import "GYAddressCountryModel.h"
#import "GYAreaHttpTool.h"
#import "GYHSBankAccountCell.h"
#import "GYHSBankAccountInputCell.h"
#import "GYHSBankPopVC.h"
#import "GYHSmyhsHttpTool.h"
#import <GYKit/GYPinYinConvertTool.h>
#import "GYShowPullDownViewVC.h"
#define kTopHeight 70
#define kMargin 212
#define kBottomHeight kDeviceProportion(70)
#define kTableViewHeight kDeviceProportion(52.5 * 7)
#define kTableViewWidth kDeviceProportion(600)

@interface GYHSBankAccountAddVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GYHSBankAccountDelegate>
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) BankModel* bankModel;
@property (nonatomic, strong) GYCityAddressModel* addressModel;
@property (nonatomic, strong) UITextField* bankField;
@property (nonatomic, copy) NSString* isDefault;
@property (nonatomic, strong) NSMutableArray* provinceArray;
@property (nonatomic, strong) NSMutableArray* cityArray;
@property (nonatomic, strong) NSMutableDictionary* nameDictionary;
@property (nonatomic, strong) GYShowPullDownViewVC* toolVC;
@property (nonatomic, strong) GYHSBankPopVC* bankVC;
@property (nonatomic, copy) NSString* provinceCodeStr;

@end

@implementation GYHSBankAccountAddVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    self.nameDictionary = [NSMutableDictionary dictionary];
    [self requestGetAddressProvince];
    [self getBank];
}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = kLocalized(@"GYHS_Myhs_Bank_Account");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.isDefault = @"0";
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kMargin);
        make.top.equalTo(self.view).offset(kTopHeight + kNavigationHeight);
        make.size.mas_equalTo(CGSizeMake(kTableViewWidth, kTableViewHeight));
    }];
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kBottomHeight));
    }];
    
    UIButton* comfirmButtom = [UIButton buttonWithType:UIButtonTypeCustom];
    comfirmButtom.layer.cornerRadius = 5;
    comfirmButtom.layer.borderWidth = 1;
    comfirmButtom.layer.borderColor = kRedE50012.CGColor;
    comfirmButtom.layer.masksToBounds = YES;
    [comfirmButtom setTitle:kLocalized(@"GYHS_Myhs_Finish") forState:UIControlStateNormal];
    [comfirmButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [comfirmButtom setBackgroundColor:kRedE50012];
    [comfirmButtom addTarget:self action:@selector(comfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:comfirmButtom];
    [comfirmButtom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
}

#pragma mark - 获取省市数据
- (void)requestGetAddressProvince
{
    [GYAreaHttpTool getQueryProvinceWithCountryNo:globalData.loginModel.countryCode
        success:^(id responsObject) {
                                              _provinceArray = responsObject;
        }
        failure:^{
        
        }];
}

#pragma mark - 获取银行列表
- (void)getBank
{
    [GYHSmyhsHttpTool getQueryBank:^(id responsObject) {
    
        self.nameDictionary = responsObject;
        
    }
        failure:^{
        
        }];
}
- (void)requestGetAddressCity
{
    [GYAreaHttpTool getQueryCityWithCountryNo:globalData.loginModel.countryCode
        provinceNo:self.provinceCodeStr
        success:^(id responsObject) {
                                          _cityArray = responsObject;
                                          
        }
        failure:^{
        
        }];
}

- (void)comfirmButtonAction
{
    if (![self isAllRight]) {
        return;
    }
    @weakify(self);
    [GYHSmyhsHttpTool bindBankInfoWithBankCode:self.bankModel.bankNo
        bankName:self.bankModel.bankName
        bankAcctNo:self.bankField.text
        countryCode:self.addressModel.countryNo
        provinceCode:self.addressModel.provinceNo
        cityCode:self.addressModel.cityNo
        isDefault:self.isDefault
        success:^(id responsObject) {
                                           @strongify(self);
                                           [kDefaultNotificationCenter postNotification:[NSNotification notificationWithName:GYChangeBankCardOrChageMainHSNotification object:nil]];
                                           [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Myhs_Add_Bank_Success")
                                                                             topColor:TopColorBlue
                                                                         comfirmBlock:^{
                                                        [self.navigationController popViewControllerAnimated:YES];
                                                                         }];
                                                                         
        }
        failure:^{
        
        }];
}

#pragma mark - 数据是否正确
- (BOOL)isAllRight
{
    if (self.bankModel == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Select_Bank")];
        return NO;
    }
    if (self.addressModel == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Myhs_Select_Area")];
        return NO;
    }
    //银行账户输入(5~30)
    GYHSBankAccountInputCell* cell = [self.tableView visibleCells][4];
    self.bankField = cell.secondTextField;
    if (self.bankField.text.length == 0) {
        [self.bankField tipWithContent:kLocalized(@"GYHS_Myhs_Input_Bank_Number") animated:YES];
        return NO;
    }
    if (self.bankField.text.length < 5 || self.bankField.text.length > 30) {
        [self.bankField tipWithContent:kLocalized(@"GYHS_Myhs_Input_Ture_Bank_Number") animated:YES];
        return NO;
    }
    //确认银行账号
    GYHSBankAccountInputCell* sureCell = [self.tableView visibleCells][5];
    if (![sureCell.secondTextField.text isEqualToString:self.bankField.text]) {
        [sureCell.secondTextField tipWithContent:kLocalized(@"GYHS_Myhs_Bank_Mix_Tip") animated:YES];
        return NO;
    }
    return YES;
}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* array = @[ kLocalized(@"GYHS_Myhs_Select"), @[ kLocalized(@"GYHS_Myhs_Select"), kLocalized(@"GYHS_Myhs_Select") ], kLocalized(@"GYHS_Myhs_Input_Bank_Account"), kLocalized(@"GYHS_Myhs_Sure_Bank_Number") ];
    GYHSBankAccountInputCell* cell = [GYHSBankAccountInputCell tableViewCellWith:tableView indexPath:indexPath dataArray:self.dataArray placeholderArray:array];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

#pragma mark - GYHSBankAccountDelegate
- (void)bankDefault:(NSString*)isdefault
{
    self.isDefault = isdefault;
}

- (void)clickWithCell:(GYHSBankAccountInputCell*)cell textField:(UITextField*)textField tag:(NSInteger)tag
{
    [self.view endEditing:YES];
    if (tag == 0) {
        //选择省份
        NSMutableArray* array = [NSMutableArray array];
        for (GYProvinceModel* model in self.provinceArray) {
            [array addObject:model.provinceName];
        }
        NSMutableArray* provinceCodeArray = [NSMutableArray array];
        for (GYProvinceModel* model in self.provinceArray) {
            [provinceCodeArray addObject:model.provinceNo];
        }
        _toolVC = [[GYShowPullDownViewVC alloc] initWithView:textField PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            textField.text = array[index];
            cell.thirdRightField.text = @"";
            self.addressModel = nil;
            self.provinceCodeStr = provinceCodeArray[index];
            [self requestGetAddressCity];
        };
    }
    else if (tag == 1) {
        //选择城市
        NSMutableArray* array = [NSMutableArray array];
        for (GYCityAddressModel* model in self.cityArray) {
            [array addObject:model.cityName];
        }
        _toolVC = [[GYShowPullDownViewVC alloc] initWithView:textField PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            textField.text = array[index];
            self.addressModel = self.cityArray[index];
        };
    }
    else if (tag == 2) {
        _bankVC = [[GYHSBankPopVC alloc] initWithView:textField dict:self.nameDictionary direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _bankVC.selectBlock = ^(BankModel* model) {
            @strongify(self);
            textField.text = model.bankName;
            self.bankModel = model;
        };
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.customBorderType = UIViewCustomBorderTypeTop;
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray:@[ kLocalized(@"GYHS_Myhs_Account_Name_Colon"), kLocalized(@"GYHS_Myhs_Settle_Kind_Colon"), kLocalized(@"GYHS_Myhs_Open_Bank_Colon"), kLocalized(@"GYHS_Myhs_Open_Area_Colon"), kLocalized(@"GYHS_Myhs_Bank_Account_Colon"), kLocalized(@"GYHS_Myhs_Sure_Account_Colon"), kLocalized(@"GYHS_Myhs_Is_Default_Bank_Colon") ]];
    }
    return _dataArray;
}

- (NSMutableArray*)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc] init];
    }
    return _provinceArray;
}

- (NSMutableArray*)cityArray
{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}




@end
