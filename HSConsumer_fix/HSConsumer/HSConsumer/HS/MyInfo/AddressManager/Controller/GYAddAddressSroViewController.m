//
//  GYAddAddressSroViewController.m
//  HSConsumer
//
//  Created by apple on 15-4-8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddAddressSroViewController.h"
#import "InputCellStypeView.h"
#import "FMDatabase.h"
#import "GYProvinceViewController.h"
#import "UIButton+GYExtension.h"
#import "GYProvinceViewController.h"
#import "GYCityAddressViewController.h"
#import "GYProvinceModel.h"
#import "GYCityAddressModel.h"
#import "GYAddressCountryViewController.h"
#import "GYGIFHUD.h"
#import "GYProvinceChooseModel.h"
#import "GYCityChooseModel.h"
#import "GYAreaChooseModel.h"
#import "GYAddressData.h"


@interface GYAddAddressSroViewController () <selectProvinceDelegate, GYCityAddressViewControllerDelegate,GYNetRequestDelegate>

@property (nonatomic, strong) GYAddressModel* AddModel;
@property (nonatomic, weak) UIButton* defaultBtn;
@property (nonatomic, weak) UILabel* defaultLabel;
@property (nonatomic, weak) UIButton* saveBtn;
@property (nonatomic, strong) GYProvinceModel* provinceModel;
@property (nonatomic, strong) GYCityAddressModel* cityModel;

@end

@implementation GYAddAddressSroViewController {

    __weak IBOutlet InputCellStypeView* InputProvinceRow;
    __weak IBOutlet InputCellStypeView* InputCityRow;
    __weak IBOutlet InputCellStypeView* InputAreaRow;
    __weak IBOutlet InputCellStypeView* InputDetailAddress;
    __weak IBOutlet InputCellStypeView* InputReceivePerson;
    __weak IBOutlet InputCellStypeView* InputPhoneNumber;
    __weak IBOutlet InputCellStypeView* InputTelPhone;
    __weak IBOutlet InputCellStypeView* InputPostCode;
    __weak IBOutlet UIScrollView* mainSroview;
    __weak IBOutlet UIButton* btnChangeAreaRef;
    __weak IBOutlet UIButton* btnChangeProvince;
    __weak IBOutlet UIButton* btnChangeCityRef;
    __weak IBOutlet UILabel* lbPlaceholder;
    __weak IBOutlet UITextView* tvDetailAddress;

    NSString* strCityName;
    NSString *strProvinceName;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mainSroview.backgroundColor = kDefaultVCBackgroundColor;
    
    self.provinceModel = [[GYProvinceModel alloc] init];
    self.cityModel = [[GYCityAddressModel alloc] init];
    if(self.isFood) {
        strProvinceName = self.model.province;
        strCityName = self.model.city;
    }else {
        self.provinceModel.countryNo = self.model.countryNo;
        self.provinceModel.provinceNo = self.model.provinceNo;
    }
    
    InputProvinceRow.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputCityRow.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputAreaRow.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputDetailAddress.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputPhoneNumber.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputTelPhone.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputPostCode.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    InputReceivePerson.lbLeftlabel.textColor = UIColorFromRGB(0x464646);
    
    InputProvinceRow.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    InputCityRow.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    InputAreaRow.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    InputDetailAddress.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    tvDetailAddress.textColor = UIColorFromRGB(0x787878);
    lbPlaceholder.textColor = UIColorFromRGB(0x787878);
    InputReceivePerson.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    InputPhoneNumber.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    InputTelPhone.tfRightTextField.textColor = UIColorFromRGB(0x787878);
    InputPostCode.tfRightTextField.textColor = UIColorFromRGB(0x787878);

    [btnChangeAreaRef setEnlargEdgeWithTop:5.0 right:10 bottom:5.0 left:20];
    [btnChangeCityRef setEnlargEdgeWithTop:5.0 right:10 bottom:5.0 left:20];
    [btnChangeProvince setEnlargEdgeWithTop:5.0 right:10 bottom:5.0 left:20];

    UIButton* defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultBtn.selected = NO;
    defaultBtn.frame = CGRectMake(15, CGRectGetMaxY(InputPostCode.frame) + 15, 20, 20);
    [defaultBtn setBackgroundImage:[UIImage imageNamed:@"hs_un_select"] forState:UIControlStateNormal];
    [defaultBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_didSelect"] forState:UIControlStateSelected];
    [defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [mainSroview addSubview:defaultBtn];
    self.defaultBtn = defaultBtn;

    UILabel* defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(defaultBtn.frame) + 10, defaultBtn.frame.origin.y, 200, 20)];
    defaultLabel.font = [UIFont systemFontOfSize:17];
    defaultLabel.text = kLocalized(@"GYHS_Address_SetTheDefaultAddress");
    defaultLabel.textColor = UIColorFromRGB(0x8C8C8C);
    [mainSroview addSubview:defaultLabel];
    self.defaultLabel = defaultLabel;

    UIButton* saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(15, CGRectGetMaxY(defaultBtn.frame) + 15, kScreenWidth - 30, 45);
    saveBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [saveBtn setTitle:kLocalized(@"GYHS_Address_Save") forState:UIControlStateNormal];
    [saveBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    saveBtn.backgroundColor = UIColorFromRGB(0xF0823C);
    [saveBtn addTarget:self action:@selector(saveBtn:) forControlEvents:UIControlEventTouchUpInside];
    [mainSroview addSubview:saveBtn];
    self.saveBtn = saveBtn;

    [self modifyName];

    [InputPhoneNumber.tfRightTextField addTarget:self action:@selector(tfRightTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [InputPostCode.tfRightTextField addTarget:self action:@selector(tfRightTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [InputTelPhone.tfRightTextField addTarget:self action:@selector(tfRightTextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];

    if (self.boolstr == YES) {
        if (self.isFood) {
            if ([self.model.beDefault isEqualToString:@"1"]) {
                self.defaultBtn.selected = YES;
            }
        }
        else {
            if ([self.model.isDefault isEqualToString:@"1"]) {
                self.defaultBtn.selected = YES;
            }
        }
        [self loadAddresDetailFromNetwork];
    }
}

- (void)tfRightTextFieldEditingChanged:(UITextField*)textField
{
    NSString* str = textField.text;
    if (textField == InputPhoneNumber.tfRightTextField) {
        if (str.length >= 11) {
            textField.text = [str substringToIndex:11];
        }
    }
    if (textField == InputPostCode.tfRightTextField) {
        if (str.length >= 6) {
            textField.text = [str substringToIndex:6];
        }
    }
    if (textField == InputTelPhone.tfRightTextField) {
        if (str.length >= 20) {
            textField.text = [str substringToIndex:13];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = kLocalized(@"GYHS_Address_Shipping_Address");

    if (!self.isFood) {

        InputAreaRow.tfRightTextField.enabled = YES;
        InputCityRow.tfRightTextField.enabled = YES;
        InputPostCode.tfRightTextField.enabled = YES;
        InputProvinceRow.tfRightTextField.enabled = YES;
        InputPhoneNumber.tfRightTextField.enabled = YES;
        InputReceivePerson.tfRightTextField.enabled = YES;
        InputTelPhone.tfRightTextField.enabled = YES;

        InputDetailAddress.frame = CGRectMake(0, CGRectGetMaxY(InputCityRow.frame), InputDetailAddress.frame.size.width, InputDetailAddress.frame.size.height);
        InputReceivePerson.frame = CGRectMake(0, CGRectGetMaxY(InputDetailAddress.frame) + 13, InputReceivePerson.frame.size.width, InputReceivePerson.frame.size.height);
        InputPhoneNumber.frame = CGRectMake(0, CGRectGetMaxY(InputReceivePerson.frame), InputReceivePerson.frame.size.width, InputReceivePerson.frame.size.height);
        InputTelPhone.frame = CGRectMake(0, CGRectGetMaxY(InputPhoneNumber.frame), InputTelPhone.frame.size.width, InputTelPhone.frame.size.height);
        InputPostCode.frame = CGRectMake(0, CGRectGetMaxY(InputTelPhone.frame), InputPostCode.frame.size.width, InputPostCode.frame.size.height);
        self.defaultBtn.frame = CGRectMake(15, CGRectGetMaxY(InputPostCode.frame) + 15, 20, 20);
        self.defaultLabel.frame = CGRectMake(CGRectGetMaxX(self.defaultBtn.frame) + 15, self.defaultBtn.frame.origin.y, 200, 20);
        self.saveBtn.frame = CGRectMake(15, CGRectGetMaxY(self.defaultBtn.frame) + 15, kScreenWidth - 30, 45);

        tvDetailAddress.editable = YES;
        btnChangeProvince.hidden = NO;
        btnChangeAreaRef.hidden = NO;
        btnChangeCityRef.hidden = NO;
    }
    else {
        InputAreaRow.tfRightTextField.enabled = YES;
        InputCityRow.tfRightTextField.enabled = YES;

        InputProvinceRow.tfRightTextField.enabled = YES;
        InputPhoneNumber.tfRightTextField.enabled = YES;
        InputReceivePerson.hidden = YES;
        InputTelPhone.hidden = YES;
        InputPostCode.hidden = YES;

        InputPhoneNumber.frame = CGRectMake(0, CGRectGetMaxY(InputDetailAddress.frame), InputPhoneNumber.frame.size.width, InputPhoneNumber.frame.size.height);
        self.defaultBtn.frame = CGRectMake(15, CGRectGetMaxY(InputPhoneNumber.frame) + 15, 20, 20);
        self.defaultLabel.frame = CGRectMake(CGRectGetMaxX(self.defaultBtn.frame) + 15, self.defaultBtn.frame.origin.y, 200, 20);
        self.saveBtn.frame = CGRectMake(15, CGRectGetMaxY(self.defaultBtn.frame) + 15, kScreenWidth - 30, 45);

        tvDetailAddress.editable = YES;
        btnChangeProvince.hidden = NO;
        btnChangeAreaRef.hidden = NO;
        btnChangeCityRef.hidden = NO;
    }

    if (self.boolstr) {
        //导航栏右边按钮的名称
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleBordered target:self action:@selector(tipDelete)];
    }
}

- (void)tipDelete
{
    WS(weakSelf)
        [GYUtils showMessge:kLocalized(@"GYHS_Address_Confirm_Delete_Shipping_Address") confirm:^{
        [weakSelf deleteAddress];
        } cancleBlock:^{
        }];
}

- (void)deleteAddress
{
    if (self.isFood) {

        NSDictionary* dict = @{ @"id" : kSaftToNSString(self.model.idString),
            @"key" : kSaftToNSString(globalData.loginModel.token) };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyDeleteDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 701;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
    else {

        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
            @"addrId" : kSaftToNSString(self.AddModel.addrId) };
        
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlDeleteAddress parameters:dict requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 702;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
}

- (void)defaultBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (void)saveBtn:(UIButton*)sender
{

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        sleep(2);
        sender.userInteractionEnabled = YES;
    });

    dispatch_async(queue, ^{

        dispatch_sync(dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = NO;
            if (self.boolstr) {
                [self modifyAddress];
            } else {
                [self addAddressRequest];
            }
        });
    });
}

- (void)modifyAddress
{
    if (self.isFood) {
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"]; //
        [dict setValue:kSaftToNSString(InputProvinceRow.tfRightTextField.text) forKey:@"province"]; //
        [dict setValue:@"" forKey:@"provinceNo"]; //
        [dict setValue:kSaftToNSString(InputCityRow.tfRightTextField.text) forKey:@"city"]; //
        [dict setValue:@"" forKey:@"cityNo"]; //
        [dict setValue:kSaftToNSString(InputAreaRow.tfRightTextField.text) forKey:@"area"]; //
        [dict setValue:kSaftToNSString(tvDetailAddress.text) forKey:@"address"]; //
        [dict setValue:@"" forKey:@"receiverName"]; //
        [dict setValue:kSaftToNSString(InputPhoneNumber.tfRightTextField.text) forKey:@"phone"]; //
        [dict setValue:self.defaultBtn.selected == YES ? @"1" : @"0" forKey:@"isDefault"]; //
        [dict setValue:@"" forKey:@"postcode"]; //
        [dict setValue:@"" forKey:@"fixedTelephone"];
        [dict setValue:kSaftToNSString(self.model.idString) forKey:@"id"];
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyUpdateDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 703;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
    else {
        if (![self checkInputCommonParam]) {
            return;
        }

        if (![self checkUserInfo]) {
            return;
        }

        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
            @"addrId" : kSaftToNSString(self.AddModel.addrId),
            @"receiver" : kSaftToNSString(InputReceivePerson.tfRightTextField.text),
            @"isDefault" : self.defaultBtn.selected == YES ? @"1" : @"0",
            @"mobile" : kSaftToNSString(InputPhoneNumber.tfRightTextField.text),
            @"phone" : kSaftToNSString(InputTelPhone.tfRightTextField.text),
            @"postCode" : kSaftToNSString(InputPostCode.tfRightTextField.text),
            @"address" : kSaftToNSString(tvDetailAddress.text),
            @"area" : kSaftToNSString(InputAreaRow.tfRightTextField.text),
            @"cityNo" : self.cityModel.cityNo ? self.cityModel.cityNo : self.AddModel.cityNo,
            @"provinceNo" : self.provinceModel.provinceNo ? self.provinceModel.provinceNo : self.AddModel.provinceNo,
            @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlUpdateAddress parameters:dict requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 704;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
}

//修改完成需要重新刷新
- (void)initdataInChangeGetGood
{
    lbPlaceholder.text = nil;

    GYCityAddressModel* cityModel = [[GYAddressData shareInstance] queryCityNo:self.AddModel.cityNo];
    GYProvinceModel* provinceModel = [[GYAddressData shareInstance] queryProvinceNo:self.AddModel.provinceNo];

    if (self.isFood) {
        InputProvinceRow.tfRightTextField.text = self.model.province;
        InputCityRow.tfRightTextField.text = self.model.city;
        tvDetailAddress.text = self.model.detail;
        InputAreaRow.tfRightTextField.text = self.model.area;
    }
    else {
        InputProvinceRow.tfRightTextField.text = provinceModel.provinceName;
        InputCityRow.tfRightTextField.text = cityModel.cityName;
        tvDetailAddress.text = self.AddModel.address;
        InputAreaRow.tfRightTextField.text = self.AddModel.area;
    }

    InputPhoneNumber.tfRightTextField.text = self.AddModel.mobile;
    InputReceivePerson.tfRightTextField.text = self.AddModel.receiver;

    InputPostCode.tfRightTextField.text = self.AddModel.postCode;
    InputTelPhone.tfRightTextField.text = self.AddModel.telphone;

    if (self.boolstr) {
        strProvinceName = self.model.province;
        strCityName = InputCityRow.tfRightTextField.text;
    }
}

- (void)modifyName
{
    InputProvinceRow.lbLeftlabel.text = kLocalized(@"GYHS_Address_Provinces");
    InputCityRow.lbLeftlabel.text = kLocalized(@"GYHS_Address_City_Name");
    InputAreaRow.lbLeftlabel.text = kLocalized(@"GYHS_Address_Area");
    InputDetailAddress.lbLeftlabel.text = kLocalized(@"GYHS_Address_Detailed_Address");

    InputReceivePerson.lbLeftlabel.text = kLocalized(@"GYHS_Address_Receive_Person");
    InputPhoneNumber.lbLeftlabel.text = kLocalized(@"GYHS_Address_Cell_Phone");
    InputTelPhone.lbLeftlabel.text = kLocalized(@"GYHS_Address_Telphone");
    InputTelPhone.tfRightTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    InputPostCode.lbLeftlabel.text = kLocalized(@"GYHS_Address_Zip_Code");

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    mainSroview.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(self.saveBtn.frame) + 30);
}

#pragma mark 选择省的代理方法
- (void)selectOneProvince:(GYProvinceChooseModel*)model
{
    InputProvinceRow.tfRightTextField.text = model.areaName;
    strProvinceName = model.areaName;
    strCityName = nil;
}

- (void)returnPopPvovince:(GYProvinceModel*)model
{
    self.provinceModel = model;
    InputProvinceRow.tfRightTextField.text = model.provinceName;
}

#pragma mark 选择城市代理方法
- (void)selectOneCity:(GYCityChooseModel*)model
{
    InputCityRow.tfRightTextField.text = model.areaName;
    strCityName = model.areaName;
}

- (void)returnPopCity:(GYCityAddressModel*)model
{
    self.cityModel = model;
    InputCityRow.tfRightTextField.text = model.cityName;
}

#pragma mark 选择区代理方法
- (void)selectOneArea:(GYAreaChooseModel*)model
{
    InputAreaRow.tfRightTextField.text = model.areaName;
}

- (IBAction)btnChangeProvince:(id)sender
{

    InputCityRow.tfRightTextField.text = nil;
    InputAreaRow.tfRightTextField.text = nil;
    if (self.isFood) {
        GYProvinceChooseViewController* vcChangeProvince = [[GYProvinceChooseViewController alloc] init];
        vcChangeProvince.delegate = self;

        [self.navigationController pushViewController:vcChangeProvince animated:YES];
    }
    else {

        GYProvinceViewController* popVC = [[GYProvinceViewController alloc] init];
        popVC.delegate = self;
        popVC.areaId = globalData.localInfoModel.countryNo;
        popVC.type = provinceTypePop;
        [self.navigationController pushViewController:popVC animated:YES];
    }
}

- (IBAction)btnChangeCity:(id)sender
{
    InputAreaRow.tfRightTextField.text = nil;

    if (self.isFood) {
        GYCityChooseViewController* vcChangeCity = [[GYCityChooseViewController alloc] init];
        vcChangeCity.parentName = strProvinceName;
        vcChangeCity.isUnderProvinceSelected = YES;
        vcChangeCity.delegate = self;
        [self.navigationController pushViewController:vcChangeCity animated:YES];
    }
    else {

        GYCityAddressViewController* popVC = [[GYCityAddressViewController alloc] init];
        popVC.type = cityTypePop;
        popVC.delegate = self;
        popVC.areaIdString = self.provinceModel.provinceNo;
        popVC.areaIdcounyry = self.provinceModel.countryNo;

        [self.navigationController pushViewController:popVC animated:YES];
    }
}

- (IBAction)btnChangeArea:(id)sender
{
    GYAreaChooseViewController* vcChangeArea = [[GYAreaChooseViewController alloc] init];
    vcChangeArea.delegate = self;
    vcChangeArea.parentName = strCityName;
    [self.navigationController pushViewController:vcChangeArea animated:YES];
}

#pragma mark textview代理方法
- (void)textViewDidChange:(UITextView*)textView
{
    lbPlaceholder.text = @"";
}

#pragma mark textfield代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField.tag == 10) {
        [self btnChangeProvince:nil];
    }
    else if (textField.tag == 11) {
        [self btnChangeCity:nil];
    }
    else if (textField.tag == 12) {

        [self btnChangeArea:nil];
    }
    else {

        return YES;
    }
    return NO;
}

- (void)loadAddresDetailFromNetwork
{

    if (self.isFood) {
        self.AddModel = self.model;
        [self initdataInChangeGetGood];
    }
    else {
        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
            @"addrId" : kSaftToNSString(self.addrId) };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlAddressDetail parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 705;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
}

- (void)addAddressRequest
{

    if (![self checkInputCommonParam]) {
        return;
    }

    if (self.isFood) {

        if ([GYUtils isBlankString:InputPhoneNumber.tfRightTextField.text]) {
            [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterMobilePhoneNumber")];
            self.saveBtn.userInteractionEnabled = YES;
            return;
        }
        else if (![GYUtils isMobileNumber:InputPhoneNumber.tfRightTextField.text]) {
            [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectPhoneNumber")];
            self.saveBtn.userInteractionEnabled = YES;
            return;
        }

        if ([tvDetailAddress.text rangeOfString:@","].location != NSNotFound) {
            tvDetailAddress.text = [GYUtils exchangeENCommaToChCommaWithString:tvDetailAddress.text];
            DDLogDebug(@"tvDetailAddress.text == %@", tvDetailAddress.text);
        }

        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"]; //
        [dict setValue:kSaftToNSString(InputProvinceRow.tfRightTextField.text) forKey:@"province"]; //
        [dict setValue:@"" forKey:@"provinceNo"]; //
        [dict setValue:kSaftToNSString(InputCityRow.tfRightTextField.text) forKey:@"city"]; //
        [dict setValue:@"" forKey:@"cityNo"]; //
        [dict setValue:kSaftToNSString(InputAreaRow.tfRightTextField.text) forKey:@"area"]; //
        [dict setValue:kSaftToNSString(tvDetailAddress.text) forKey:@"address"]; //
        [dict setValue:@"" forKey:@"receiverName"]; //
        [dict setValue:kSaftToNSString(InputPhoneNumber.tfRightTextField.text) forKey:@"phone"]; //
        [dict setValue:@"" forKey:@"postcode"]; //
        [dict setValue:@"" forKey:@"fixedTelephone"]; //
        [dict setValue:self.defaultBtn.selected == YES ? @"1" : @"0" forKey:@"isDefault"]; //

        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuySaveDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 706;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
    else {

        if (![self checkUserInfo]) {
            return;
        }

        if ([tvDetailAddress.text rangeOfString:@","].location != NSNotFound) {
            tvDetailAddress.text = [GYUtils exchangeENCommaToChCommaWithString:tvDetailAddress.text];
            DDLogDebug(@"tvDetailAddress.text == %@", tvDetailAddress.text);
        }
        DDLogDebug(@"%@", globalData.loginModel.custId);

        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
            @"receiver" : kSaftToNSString(InputReceivePerson.tfRightTextField.text),
            @"isDefault" : self.defaultBtn.selected == YES ? @"1" : @"0",
            @"mobile" : kSaftToNSString(InputPhoneNumber.tfRightTextField.text),
            @"phone" : kSaftToNSString(InputTelPhone.tfRightTextField.text) == nil ? @"" : kSaftToNSString(InputTelPhone.tfRightTextField.text),
            @"postCode" : kSaftToNSString(InputPostCode.tfRightTextField.text),
            @"address" : kSaftToNSString(tvDetailAddress.text),
            @"area" : @"",
            @"cityNo" : kSaftToNSString(self.cityModel.cityNo),
            @"provinceNo" : kSaftToNSString(self.provinceModel.provinceNo),
            @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) };
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlAddAddress parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
        request.tag = 707;
        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
        [GYGIFHUD show];
        [request start];
    }
}

- (BOOL)checkInputCommonParam
{
    if ([GYUtils isBlankString:InputProvinceRow.tfRightTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheProvince")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if ([GYUtils isBlankString:InputCityRow.tfRightTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCity")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if ([GYUtils isBlankString:InputAreaRow.tfRightTextField.text] && self.isFood) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseInputArea")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if ([GYUtils isBlankString:tvDetailAddress.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_Please_Fill_Out_Detailed_Address")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if (tvDetailAddress.text.length > 128 || tvDetailAddress.text.length < 2) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_DetailedAddressNotLessThan2OrGreaterThan128Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }

    return YES;
}

- (BOOL)checkUserInfo
{
    if ([GYUtils isBlankString:InputReceivePerson.tfRightTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_Please_Fill_In_Consignee")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if (![GYUtils isValidTureWithName:InputReceivePerson.tfRightTextField.text]) { //联系人名字
        [GYUtils showToast:kLocalized(@"GYHS_Address_Input_Contains_Illegal_Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if (InputReceivePerson.tfRightTextField.text.length > 20 || InputReceivePerson.tfRightTextField.text.length < 2) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_TheRecipientNotLessThan2OrMoreThan20Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if ([GYUtils isBlankString:InputPhoneNumber.tfRightTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterMobilePhoneNumber")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    else if (![GYUtils isMobileNumber:InputPhoneNumber.tfRightTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectPhoneNumber")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    
    if (![GYUtils checkStringInvalid:InputTelPhone.tfRightTextField.text]) {
        if (![GYUtils isValidFixedLineTelephone:InputTelPhone.tfRightTextField.text]) {
            
            [GYUtils showToast:kLocalized(@"GYHS_Address_Fixed_Telephone_Input_Wrong")];
            self.saveBtn.userInteractionEnabled = YES;
            return NO;
        }
    }
    
    if (![GYUtils isBlankString:InputPostCode.tfRightTextField.text] && ![GYUtils isValidZipcode:InputPostCode.tfRightTextField.text]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectZipCode")];
        self.saveBtn.userInteractionEnabled = YES;
        return NO;
    }
    return YES;
}

#pragma mark- GYNetRequestDelegate
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject {
    [GYGIFHUD dismiss];
    if(request.tag == 701) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_TheAddressWasRemovedSuccessfully")  confirm:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_DeleteTheAddressFailed")  confirm:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else if(request.tag == 702) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_TheAddressWasRemovedSuccessfully")  confirm:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
        else {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_DeleteTheAddressFailed")  confirm:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    }else if(request.tag == 703) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            
            [GYUtils showToast:kLocalized(@"GYHS_Address_Save_Success")];
            [self.navigationController popViewControllerAnimated:YES];
            
            
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"GYGetGoodViewController")]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
                    
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            [GYUtils showToast:kLocalized(@"GYHS_Address_Universally_UpdataError")];
        }
    }else if(request.tag == 704) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            
            [GYUtils showToast:kLocalized(@"GYHS_Address_Modify_Shipping_Address_Complete")];
            [GYUtils showToast:kLocalized(@"GYHS_Address_Save_Success")];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:NSClassFromString(@"GYGetGoodViewController")]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
                    [self.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            [GYUtils showMessage:kLocalized(@"GYHS_Address_Universally_UpdataError")];
        }
    }else if(request.tag == 705) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            self.AddModel = [[GYAddressModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
            [self initdataInChangeGetGood];
        }
    }else if(request.tag == 706) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_CongratulationsAddShippingAddressSuccess") confirm:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [GYUtils showMessage:kLocalized(@"GYHS_Address_AddShippingAddressFailed")];
        }
    }else if(request.tag == 707) {
        if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kReceiveGoodsLocationChanged object:nil];
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_CongratulationsAddShippingAddressSuccess") confirm:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [GYUtils showMessage:kLocalized(@"GYHS_Address_CongratulationsAddShippingAddressSuccess")];
        }
    }
}

-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

@end
