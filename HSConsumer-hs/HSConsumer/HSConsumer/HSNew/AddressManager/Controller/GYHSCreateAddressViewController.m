//
//  GYHSCreateAddressViewController.m
//
//  Created by lizp on 2016/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSCreateAddressViewController.h"
#import "GYHSCreateAddressCell.h"
#import "YYKit.h"

@interface GYHSCreateAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,strong) UIButton *defaultBtn;//设置默认地址按钮
@property (nonatomic,strong) UIButton *saveBtn;//保存

@property (nonatomic,copy) NSString *reciver;//收货人
@property (nonatomic,copy) NSString *mobile;//手机
@property (nonatomic,copy) NSString *telPhone;//固定电话
@property (nonatomic,copy) NSString *postCode;//邮编
@property (nonatomic,copy) NSString *address;//详细地址
@property (nonatomic,copy) NSString *area;//省、市、区

@end

@implementation GYHSCreateAddressViewController

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
    
    if (textField.superview.tag == kGYHSCreateAddressCellTag ) {
        self.reciver = textField.text;
    }else if (textField.superview.tag == kGYHSCreateAddressCellTag + 1 ) {
        self.mobile = textField.text;
    }else if (textField.superview.tag == kGYHSCreateAddressCellTag + 2 ) {
        self.telPhone = textField.text;
    }else if (textField.superview.tag == kGYHSCreateAddressCellTag  + 4) {
        self.postCode = textField.text;
    }
    
    [self.dataSource removeAllObjects];
    [self addDataSource];
}

#pragma mark -UITextViewDelegate 
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text containsString:kLocalized(@"详细地址")]) {
        textView.textColor = UIColorFromRGB(0x666666);
        textView.text = @"";
    }
    
}



-(void)textViewDidEndEditing:(UITextView *)textView {

    if (textView.text.length == 0) {
        textView.text = kLocalized(@"详细地址");
        textView.textColor = [UIColor lightGrayColor];
    }else {
        textView.textColor = UIColorFromRGB(0x666666);
    }
}

#pragma mark TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSCreateAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSCreateAddressCellIdentifier];
    if (!cell) {
        cell = [[GYHSCreateAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSCreateAddressCellIdentifier];
    }
    cell.tag = kGYHSCreateAddressCellTag + indexPath.row;
    cell.titleTextField.delegate = self;
    cell.addressTextView.delegate = self;
    [cell.titleTextField addTarget:self action:@selector(titleTextFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 3) {
        cell.titleTextField.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.titleTextField.userInteractionEnabled = YES;
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (indexPath.row == 5) {
        cell.addressTextView.hidden = NO;
        cell.titleTextField.hidden = YES;
    }else {
        cell.addressTextView.hidden = YES;
        cell.titleTextField.hidden = NO;
    }
    
    NSDictionary *dic = self.dataSource[indexPath.row];
    [cell refreshPlaceholder:dic[@"placeholder"] detail:dic[@"detail"] textField:dic[@"textField"]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 3) {
        DDLogInfo(@"省、市、区");
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.view endEditing:YES];
    if (indexPath.row == 5) {
        return 86;
    }
    return 46;
}

#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - 检查数据是否合法(收货地址)
-(void)cheakDataValidForGoods {
    
    
    if ([GYUtils isBlankString:self.reciver]) {
        [GYUtils showToast:kLocalized(@"请填写收货人姓名")];
        return ;
    }else if (![GYUtils isValidTureWithName:self.reciver]) {
        [GYUtils showToast:kLocalized(@"收货人姓名输入内容含有非法字符")];
        return ;
    }else if (self.reciver.length > 20 || self.reciver.length < 2) {
        [GYUtils showToast:kLocalized(@"收货人姓名长度限制为2~20位")];
        return ;
    }else if ([GYUtils isBlankString:self.mobile]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterMobilePhoneNumber")];
        return ;
    }else if (![GYUtils isMobileNumber:self.mobile]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectPhoneNumber")];
        return ;
    }else if ([GYUtils isBlankString:self.area]) {
        [GYUtils showToast:kLocalized(@"请选择省、市、区")];
        return ;
    }else if ([GYUtils isBlankString:self.address]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_Please_Fill_Out_Detailed_Address")];
        return ;
    }else if (self.address.length > 128 || self.address.length < 2) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_DetailedAddressNotLessThan2OrGreaterThan128Characters")];
        return ;
    }
    
    
    
    
}

#pragma mark - titleTextFieldChange 
-(void)titleTextFieldChange:(UITextField *)textField {

    //收货地址
    if (textField.superview.tag == kGYHSCreateAddressCellTag + 1 ) {
        if(textField.text.length >= 11) {
            textField.text = [textField.text substringToIndex:11];
            [textField endEditing:YES];
        }
    }else if (textField.superview.tag == kGYHSCreateAddressCellTag  + 4) {
        if(textField.text.length >= 6) {
            textField.text = [textField.text substringToIndex:6];
            [textField endEditing:YES];
        }
    }
}

#pragma mark - 设置默认地址点击事件
-(void)defaultBtnClick {
    
    [self.view endEditing:YES];
    self.defaultBtn.selected = !self.defaultBtn.selected;
}

#pragma mark - 保存点击
-(void)saveBtnClick:(UIButton *)sender {

    [self.view endEditing:YES];
    
    if (self.isFood) {
        
    }else {
        if (self.boolstr) {
            
        }else {
            [self cheakDataValidForGoods];
            
        }
    }
}


#pragma mark - 添加地址  收货地址
-(void)loadNetWorkForAddGoodsAddress {

//    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
//                            @"receiver" : kSaftToNSString(self.reciver),
//                            @"isDefault" : self.defaultBtn.selected == YES ? @"1" : @"0",
//                            @"mobile" : kSaftToNSString(self.mobile),
//                            @"phone" : kSaftToNSString(self.telPhone) == nil ? @"" : kSaftToNSString(self.telPhone),
//                            @"postCode" : kSaftToNSString(self.postCode),
//                            @"address" : kSaftToNSString(self.address),
//                            @"area" : @"",
//                            @"cityNo" : kSaftToNSString(self.cityModel.cityNo),
//                            @"provinceNo" : kSaftToNSString(self.provinceModel.provinceNo),
//                            @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) };
//    
//    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlAddAddress parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//        
//        [GYGIFHUD dismiss];
//        if(error) {
//            [GYUtils parseNetWork:error resultBlock:nil];
//        }else {
//            
////            WS(weakSelf)
////            [GYUtils showMessage:kLocalized(@"GYHS_Address_CongratulationsAddShippingAddressSuccess") confirm:^{
////                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshGoodList)]) {
////                    [weakSelf.delegate refreshGoodList];
////                    [weakSelf.navigationController popViewControllerAnimated:YES];
////                }
////            }];
//            
//            
//        }
//    }];
//    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
//    [GYGIFHUD show];
//    [request start];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"新增地址");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    
    
    if (self.boolstr) {
        
    }else {
        [self addDataSource];
    }
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 尾部
-(UIView *)addFooterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20+ 46 + 20 +41 +30)];
    footerView.backgroundColor = kDefaultVCBackgroundColor;
    
    UIView *defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 46)];
    defaultView.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:defaultView];
    
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.defaultBtn.frame = CGRectMake(12, 13, 20, 20);
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gy_he_unselected_icon"] forState:UIControlStateNormal];
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_select_circle_blue"] forState:UIControlStateSelected];
    [self.defaultBtn addTarget:self action:@selector(defaultBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [defaultView addSubview:self.defaultBtn];
    
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.defaultBtn.right + 10, 0, kScreenWidth - self.defaultBtn.right -10, 46)];
    defaultLabel.text = kLocalized(@"设置默认地址");
    defaultLabel.textAlignment  = NSTextAlignmentLeft;
    defaultLabel.font = [UIFont systemFontOfSize:16];
    [defaultView addSubview:defaultLabel];
    
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame = CGRectMake(12, defaultView.bottom + 20, kScreenWidth - 12*2, 41);
    [self.saveBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = UIColorFromRGB(0x1d7dd6);
    [self.saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn setTitle:kLocalized(@"GYHS_Address_AddressSave") forState:UIControlStateNormal];
    self.saveBtn.layer.cornerRadius = 20.5;
    self.saveBtn.clipsToBounds = YES;
    [footerView addSubview:self.saveBtn];
    
    return footerView;
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GYHSCreateAddressCell class] forCellReuseIdentifier:kGYHSCreateAddressCellIdentifier];
        _tableView.tableFooterView = [self addFooterView];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)addDataSource {

    if (self.boolstr) {
        
        
    }else {
        _dataSource = [[NSMutableArray alloc] initWithArray:@[@{@"placeholder":kLocalized(@"收货人姓名"),
                                                               @"detail":self.reciver ? self.reciver : kLocalized(@""),
                                                               @"textField":kLocalized(@""),
                                                               },
                                                             @{@"placeholder":kLocalized(@"手机号码"),
                                                               @"detail":self.mobile ? self.mobile : kLocalized(@""),
                                                               @"textField":kLocalized(@""),
                                                               },
                                                             @{@"placeholder":kLocalized(@"固定电话"),
                                                               @"detail":self.telPhone ? self.telPhone : kLocalized(@""),
                                                               @"textField":kLocalized(@""),
                                                               },
                                                             @{@"placeholder":kLocalized(@""),
                                                               @"detail":self.area ? self.area : kLocalized(@"省、市、区"),
                                                               @"textField":kLocalized(@""),
                                                               },
                                                             @{@"placeholder":kLocalized(@"邮政编码"),
                                                               @"detail":self.postCode ? self.postCode : kLocalized(@""),
                                                               @"textField":kLocalized(@""),
                                                               },
                                                             @{@"placeholder":kLocalized(@""),
                                                               @"detail":self.address ? self.address : kLocalized(@""),
                                                               @"textField":kLocalized(@"详细地址"),
                                                               },
                                                             ]
                       ];
    }
    
}

@end
