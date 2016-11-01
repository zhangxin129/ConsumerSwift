//
//  GYHSEditAddressVC.m
//
//  Created by apple on 16/8/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  互生Store申购工具、资源申购的收货地址管理界面，用于新增和修改收货地址的操作
 *
 */
#import "GYHSEditAddressVC.h"
#import "UILabel+Category.h"
#import "GYHSStoreHttpTool.h"
#import "GYAreaHttpTool.h"
#import "GYShowPullDownViewVC.h"
#import "GYAddressCountryModel.h"
#import "GYHSAddressListModel.h"

@interface GYHSEditAddressVC ()<UITextFieldDelegate ,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UITextField *addressTextField;
@property (nonatomic, strong) UITextField *postCodeTextField;
@property (nonatomic, strong) UITextField *contactNameTextField;
@property (nonatomic, strong) UITextField *contactPhoneTextField;
@property (nonatomic, strong) UITextField *contactNumField;
@property (nonatomic, strong) NSMutableArray *provinceArray;
@property (nonatomic, strong) UITextField *selectProvinceTextField;
@property (nonatomic, strong) GYShowPullDownViewVC* toolVC;
@property (nonatomic, assign) NSInteger selectProvinceIndex;
@property (nonatomic, strong) UITextField *selectCityTextField;
@property (nonatomic, assign) NSInteger selectCityIndex;
@property (nonatomic, copy) NSString *provinceCodeStr;
@property (nonatomic, copy) NSString *cityCodeStr;
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, strong) UIButton *staButton;

@end

@implementation GYHSEditAddressVC
/**
 *  懒加载
 */
#pragma mark - lazy load
-(NSMutableArray *)provinceArray{
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc] init];
    }
    return _provinceArray;
}
- (NSMutableArray *)cityArray{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}
#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self createFooterView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestGetAddressProvince];
    if (self.type == GYHSEditAddressVCTypeChange) {
        [self requestGetProvinceName];
        [self requestGetCityName];
    }
    
    
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - private methods
- (void)initView
{
    if (self.type == GYHSEditAddressVCTypeChange) {
        self.title = kLocalized(@"GYHS_HSStore_PurchaseTools_ChangeAddress");
    }else{
        self.title = kLocalized(@"GYHS_HSStore_PurchaseTools_AddNewAddress");
    }
    
    self.view.backgroundColor = kWhiteFFFFFF;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self setupUI];
}
/**
 *  创建界面
 */
- (void)setupUI{

    _mainView = [[UIView alloc] init];
    _mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_mainView];
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(44);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth)));
        make.height.equalTo(@(kDeviceProportion(kScreenHeight  - 44 -70)));
    }];
    
    float spaceW = 211;
    float lableW = 105;
    float textFieldW = 505;
    NSString *areaStr = kLocalized(@"GYHS_HSStore_PurchaseTools_Area");
    NSMutableAttributedString *areaString = [[NSMutableAttributedString alloc]initWithString:areaStr];
    [areaString addAttribute:NSForegroundColorAttributeName value:kRedE50012 range:NSMakeRange(0, 1)];
    [areaString addAttribute:NSForegroundColorAttributeName value:kGray333333 range:NSMakeRange(1, 5)];
    [areaString addAttribute:NSFontAttributeName value:kFont32  range:NSMakeRange(0, 5)];
    
    NSString *addressStr = kLocalized(@"GYHS_HSStore_PurchaseTools_Address");
    NSMutableAttributedString *addressString = [[NSMutableAttributedString alloc]initWithString:addressStr];
    [addressString addAttribute:NSForegroundColorAttributeName value:kRedE50012 range:NSMakeRange(0, 1)];
    [addressString addAttribute:NSForegroundColorAttributeName value:kGray333333 range:NSMakeRange(1, 5)];
    [addressString addAttribute:NSFontAttributeName value:kFont32  range:NSMakeRange(0, 5)];

    NSString *nameStr = kLocalized(@"GYHS_HSStore_PurchaseTools_BeneficiarysName");
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc]initWithString:nameStr];
    [nameString addAttribute:NSForegroundColorAttributeName value:kRedE50012 range:NSMakeRange(0, 1)];
    [nameString addAttribute:NSForegroundColorAttributeName value:kGray333333 range:NSMakeRange(1, 6)];
    [nameString addAttribute:NSFontAttributeName value:kFont32  range:NSMakeRange(0, 6)];

    NSString *phoneStr = kLocalized(@"GYHS_HSStore_PurchaseTools_Phone");
    NSMutableAttributedString *phoneString = [[NSMutableAttributedString alloc]initWithString:phoneStr];
    [phoneString addAttribute:NSForegroundColorAttributeName value:kRedE50012 range:NSMakeRange(0, 1)];
    [phoneString addAttribute:NSForegroundColorAttributeName value:kGray333333 range:NSMakeRange(1, 5)];
    [phoneString addAttribute:NSFontAttributeName value:kFont32  range:NSMakeRange(0, 5)];

    for (int i = 0; i < 6; i++) {
        UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(spaceW, 21 + i * 40 + i * 20, lableW, 30)];
        if (i == 0) {
            titleLab.attributedText = areaString;
        }else if (i ==1){
            titleLab.attributedText = addressString;
        }else if (i == 2){
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.textColor = kGray333333;
            titleLab.font = kFont32;
            titleLab.text = kLocalized(@"GYHS_HSStore_PurchaseTools_PostCode");
        }else if (i == 3){
            titleLab.attributedText = nameString;
        }else if (i == 4){
            titleLab.attributedText = phoneString;
        }else{
            titleLab.textAlignment = NSTextAlignmentLeft;
            titleLab.textColor = kGray333333;
            titleLab.font = kFont32;
            titleLab.text = kLocalized(@"GYHS_HSStore_PurchaseTools_TelephoneNumber");
        }
        [_mainView addSubview:titleLab];
    }

    _selectProvinceTextField = [[UITextField alloc] init];
    _selectProvinceTextField.font = kFont32;
    _selectProvinceTextField.placeholder = kLocalized(@"GYHS_HSStore_PurchaseTools_SelectProvince");
    _selectProvinceTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    _selectProvinceTextField.layer.borderWidth = 1.0f;
    _selectProvinceTextField.leftViewMode = UITextFieldViewModeAlways;
    _selectProvinceTextField.rightViewMode = UITextFieldViewModeAlways;
    _selectProvinceTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _selectProvinceTextField.delegate = self;
    UIImageView* choseQuestionLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
    _selectProvinceTextField.leftView = choseQuestionLeftView;
    UIImageView* inputAnswerRightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
    inputAnswerRightView.image = [UIImage imageNamed:@"gycom_gray_pullDown"];
    inputAnswerRightView.userInteractionEnabled = YES;
    inputAnswerRightView.multipleTouchEnabled = YES;
    inputAnswerRightView.contentMode = UIViewContentModeCenter;
    _selectProvinceTextField.rightView = inputAnswerRightView;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
    tap.delegate = self;
    [_selectProvinceTextField addGestureRecognizer:tap];
    [_mainView addSubview:_selectProvinceTextField];
    [self.selectProvinceTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_mainView.mas_top).offset(16);
        make.left.equalTo(_mainView.mas_left).offset(spaceW + lableW);
        make.width.equalTo(@(kDeviceProportion(245)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];

    _selectCityTextField = [[UITextField alloc] init];
    _selectCityTextField.font = kFont32;
    _selectCityTextField.placeholder = kLocalized(@"GYHS_HSStore_PurchaseTools_SelectCity");
    _selectCityTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    _selectCityTextField.layer.borderWidth = 1.0f;
    _selectCityTextField.leftViewMode = UITextFieldViewModeAlways;
    _selectCityTextField.rightViewMode = UITextFieldViewModeAlways;
    _selectCityTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _selectCityTextField.delegate = self;
    UIImageView* choseCityLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
    _selectCityTextField.leftView = choseCityLeftView;
    UIImageView* choseCityView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
    choseCityView.image = [UIImage imageNamed:@"gycom_gray_pullDown"];
    choseCityView.userInteractionEnabled = YES;
    choseCityView.multipleTouchEnabled = YES;
    choseCityView.contentMode = UIViewContentModeCenter;
    _selectCityTextField.rightView = choseCityView;
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc] init];
    tapGes.delegate = self;
    [_selectCityTextField addGestureRecognizer:tapGes];
    [_mainView addSubview:_selectCityTextField];
    [self.selectCityTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_mainView.mas_top).offset(16);
        make.left.equalTo(_selectProvinceTextField.mas_left).offset(245 + 15);
        make.width.equalTo(@(kDeviceProportion(245)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];

    for (int i = 1; i < 6; i ++) {
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(lableW + spaceW, 16 + i * 40 + i * 20, textFieldW, 40)];
        textField.layer.borderColor = kGrayCCCCCC.CGColor;
        textField.layer.borderWidth = 1.0f;
        textField.leftViewMode = UITextFieldViewModeAlways;
        UIImageView* choseQuestionLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(10), kDeviceProportion(40))];
        textField.leftView = choseQuestionLeftView;
        textField.delegate = self;
        textField.tag = i;
        [_mainView addSubview:textField];
        
        if (textField.tag == 1){
            self.addressTextField = textField;
            self.addressTextField.keyboardType = UIKeyboardTypeDefault;
        }else if (textField.tag == 2){
            self.postCodeTextField = textField;
            self.postCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (textField.tag == 3){
            self.contactNameTextField = textField;
            self.contactNameTextField.keyboardType = UIKeyboardTypeDefault;
        }else if (textField.tag == 4){
            self.contactPhoneTextField = textField;
            self.contactPhoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else if (textField.tag == 5){
            self.contactNumField = textField;
            self.contactNumField.keyboardType = UIKeyboardTypeNumberPad;
        }
        textField.placeholder = kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseEnter");
    }
  
    self.staButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.staButton.frame = CGRectMake(lableW + spaceW, CGRectGetMaxY(self.contactNumField.frame) + 32, 16, 16);
    [self.staButton setImage:[UIImage imageNamed:@"gyhs_normal"] forState:UIControlStateNormal];
    [self.staButton setImage:[UIImage imageNamed:@"gyhs_select"] forState:UIControlStateSelected];
    [self.staButton addTarget:self action:@selector(staAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:self.staButton];
    
    UILabel *setLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.staButton.frame) + 10, CGRectGetMaxY(self.contactNumField.frame) + 32, 200, 16)];
    [setLable initWithText:kLocalized(@"GYHS_HSStore_PurchaseTools_SetAsDefaultShippingAddress") TextColor:kGray333333 Font:kFont32 TextAlignment:0];
    [_mainView addSubview:setLable];
    
    if (self.type == GYHSEditAddressVCTypeChange) {
        self.addressTextField.text = self.model.contactAddr;
        self.contactNameTextField.text = self.model.contactName;
        self.contactPhoneTextField.text = self.model.contactPhone;
        self.postCodeTextField.text = self.model.postCode;
        self.contactNumField.text = self.model.telphone;
        self.staButton.selected = self.model.isDefault.boolValue ;
    }
    
}
/**
 *  创建底部按钮视图
 */
- (void)createFooterView{
    _footerView = [[UIView alloc] init];
    _footerView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];     [self.view addSubview:_footerView];
    [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(kScreenHeight  - 62 - 70 - 20);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth)));
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmButton.backgroundColor = kRedE50012;
    confirmButton.layer.cornerRadius = 6;
    [confirmButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [confirmButton setTitle:kLocalized(@"GYHS_HSStore_PurchaseTools_Save") forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmButton.tag = 102;
    [_footerView addSubview:confirmButton];
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView.mas_top).offset((70 - 33) / 2);
        make.left.equalTo(_footerView.mas_left).offset((kScreenWidth - 120) / 2);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(33)));
    }];
}
/**
 *  底部按钮的触发事件
*/
- (void)btnAction:(UIButton *)sender{
    
    if (self.type == GYHSEditAddressVCTypeAdd) {
        [self requestAddAddress];
    }else{
        [self requestChangeAddress];
    }

}
/**
 *  默认收货地址按钮的事件
 */
-(void)staAction:(UIButton *)sender{
    if (sender == self.staButton) {
        sender.selected = !sender.selected;
    }
   
}
/**
 *  获取省列表的请求
 */
#pragma mark - request
- (void)requestGetAddressProvince{
    [GYAreaHttpTool getQueryProvinceWithCountryNo:globalData.loginModel.countryCode success:^(id responsObject) {
        _provinceArray = responsObject;
    } failure:^{
        
    }];

}
/**
 *  获取市列表的请求
 */
- (void)requestGetAddressCity{
    [GYAreaHttpTool getQueryCityWithCountryNo:globalData.loginModel.countryCode provinceNo:self.provinceCodeStr success:^(id responsObject) {
        _cityArray = responsObject;
    } failure:^{
        
    }];

}
/**
 *  获取省名称的请求
 */
- (void)requestGetProvinceName{

    [GYAreaHttpTool queryProvinceInfoWithNo:self.model.provinceNo success:^(id responsObject) {
        GYProvinceModel *model = responsObject;
        self.selectProvinceTextField.text = model.provinceName;
        self.provinceCodeStr = self.model.provinceNo;
    } failure:^{
        
    }];
}
/**
 *  获取市名称的请求
 */
- (void)requestGetCityName{
    [GYAreaHttpTool queryCityINfoWithNo:self.model.cityNo success:^(id responsObject) {
       GYCityAddressModel *model = responsObject;
        self.selectCityTextField.text = model.cityName;
        self.cityCodeStr = self.model.cityNo;
    } failure:^{
        
    }];
}
/**
 *  新增收货地址的请求
 */
- (void)requestAddAddress{
    if (![self isDataAllRight]) {
        return;
    }
    [GYHSStoreHttpTool postAddAddressWithReceiver:self.contactNameTextField.text provinceNo:self.provinceCodeStr cityNo:self.cityCodeStr area:@"" address:self.addressTextField.text postCode:self.postCodeTextField.text phone:self.contactNumField.text mobile:self.contactPhoneTextField.text isDefault:[@(self.staButton.isSelected) stringValue] success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_AddedSuccessfully")];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        
    }];
}
/**
 *  修改收货地址的请求
 */
- (void)requestChangeAddress{
    if (![self isDataAllRight]) {
        return;
    }
    [GYHSStoreHttpTool updateAddressWithAddrId:self.model.addressId receiver:self.contactNameTextField.text provinceNo:self.provinceCodeStr cityNo:self.cityCodeStr area:@"" address:self.addressTextField.text postCode:self.postCodeTextField.text phone:self.contactNumField.text mobile:self.contactPhoneTextField.text isDefault:[@(self.staButton.isSelected) stringValue] success:^(id responsObject) {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_UpdateSuccess")];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        
    }];
}
/**
 *  进行新增或修改收货地址操作的先决条件
 */
- (BOOL)isDataAllRight{
    if (self.type == GYHSEditAddressVCTypeAdd) {
        if (self.selectProvinceTextField.text.length == 0 || self.selectCityTextField.text.length == 0) {
            [self.selectCityTextField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseSelectArea") animated:YES];

            return NO;
        }
        
    }
    
    if (self.addressTextField.text.length == 0) {
        [self.addressTextField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseFillInTheFullAddress") animated:YES];

        return NO;
    }
    
    if (self.contactNameTextField.text.length == 0) {
        [self.contactNameTextField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseFillInReceiverName") animated:YES];

        return NO;
    }
    
    if (self.contactPhoneTextField.text.length == 0) {
        [self.contactPhoneTextField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseFillInCellphoneNumber") animated:YES];
//        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseFillInCellphoneNumber")];
        return NO;
    }
    if (self.postCodeTextField.text.length > 0) {
        if (![self.postCodeTextField.text isValidPostalcode]) {
            [self.postCodeTextField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_EnteredPostCodeIncorrectly") animated:YES];

            return NO;
        }else{
            return YES;
        }
    }
    
    if (![self.contactPhoneTextField.text isMobileNumber]) {
        [self.contactPhoneTextField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_EnteredPhoneNumberIncorrectly") animated:YES];
        return NO;
    }
    if (self.contactNumField.text.length > 0) {
        if (![self.contactNumField.text isMobileNumber]) {
            [self.contactNumField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_EnteredPhoneNumberIncorrectly") animated:YES];
            return NO;
        }
    }
    
    return YES;
}
/**
 *  UITextFieldDelegate 对输入框进行限制
 */
#pragma  mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.postCodeTextField) {
        if (toBeString.length > 6) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_PostCodeCannotMoreThanSixDigit") animated:YES];
        }else{
            return YES;
        }
    }
    
    if (textField == self.contactPhoneTextField) {
        if (toBeString.length > 11) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_ThePhoneNumberCannotExceed 11 Digits") animated:YES];
        }else{
            return YES;
        }
    }
    
    if (textField == self.addressTextField) {
        if (toBeString.length > 100) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_ShippingAddressCannotExceed 100 Words") animated:YES];
        }else{
            return YES;
        }
    }
    
    if (textField == self.contactNameTextField) {
        if (toBeString.length > 20) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_ReceiverNameCannotBeMoreThan 20 Words") animated:YES];

        }else{
            return YES;
        }
    }

    if (textField == self.contactNumField) {
        if (toBeString.length > 20) {
            [textField resignFirstResponder];
            [textField tipWithContent:kLocalized(@"GYHS_HSStore_PurchaseTools_ThePhoneNumberCannotExceed 20 Characters") animated:YES];

        }else{
            return YES;
        }
    }

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _selectProvinceTextField||textField == _selectCityTextField) {
        return NO;
    }
    return YES;
}
/**
 *  当选中某个输入框进行编辑时，输入框的边框颜色
 */
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (self.addressTextField.isEditing) {
        self.addressTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.postCodeTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactPhoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNumField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.postCodeTextField.isEditing) {
        self.addressTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postCodeTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.contactNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactPhoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNumField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.contactNameTextField.isEditing) {
        self.addressTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postCodeTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNameTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.contactPhoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNumField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.contactPhoneTextField.isEditing) {
        self.addressTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postCodeTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactPhoneTextField.layer.borderColor = kBlue64A9FD.CGColor;
        self.contactNumField.layer.borderColor = kGrayCCCCCC.CGColor;
    }else if (self.contactNumField.isEditing) {
        self.addressTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.postCodeTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNameTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactPhoneTextField.layer.borderColor = kGrayCCCCCC.CGColor;
        self.contactNumField.layer.borderColor = kBlue64A9FD.CGColor;
    }
}
/**
 *  给选择省和市的输入框加手势
 */
#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    
    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIView class]]) {
        
        id view = (UITextField*)touch.view;
        
        if (view == _selectProvinceTextField || view == _selectProvinceTextField.rightView) {
            //点击省列表
            [self tapAlertView:_selectProvinceTextField];
            return YES;
        }else if (view == _selectCityTextField || view == _selectCityTextField.rightView){
            //点击市列表
            [self tapAlertView:_selectCityTextField];
            return YES;
        }
    }
    
    return NO;
}
/**
 *  选择省或市的下拉弹出框
 */
#pragma mark - event
- (void)tapAlertView:(UITextField *)textField
{
    if (textField == _selectProvinceTextField) {
        NSMutableArray* array = [NSMutableArray array];
        for (GYProvinceModel *model in self.provinceArray) {
            [array addObject:model.provinceName];
        }
        NSMutableArray *provinceCodeArray = [NSMutableArray array];
        for (GYProvinceModel *model in self.provinceArray) {
            [provinceCodeArray addObject:model.provinceNo];
        }
        
        _toolVC = [[GYShowPullDownViewVC alloc] initWithView:_selectProvinceTextField PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            self.selectProvinceIndex = index;
            self.selectProvinceTextField.text = array[index];
            self.selectCityTextField.text = @"";
            self.provinceCodeStr = provinceCodeArray[index];
            [self requestGetAddressCity];
        };
    }else if (textField == _selectCityTextField){
        NSMutableArray* array = [NSMutableArray array];
        for (GYCityAddressModel *model in self.cityArray) {
            [array addObject:model.cityName];
        }
        NSMutableArray *cityCodeArray = [NSMutableArray array];
        for (GYCityAddressModel *model in self.cityArray) {
            [cityCodeArray addObject:model.cityNo];
        }
        _toolVC = [[GYShowPullDownViewVC alloc] initWithView:_selectCityTextField PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        _toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            self.selectCityIndex = index;
            self.selectCityTextField.text = array[index];
            self.cityCodeStr = cityCodeArray[index];
        };

    }
}

@end
