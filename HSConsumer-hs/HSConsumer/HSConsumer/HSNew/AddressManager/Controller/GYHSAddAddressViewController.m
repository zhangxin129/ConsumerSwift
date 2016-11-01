//
//  GYHSAddAddressViewController.m
//
//  Created by lizp on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGoodDetailTag 500
#define kFoodDetailTag 600

#import "GYHSAddAddressViewController.h"
#import "GYHSAddAddressCell.h"
#import "GYAddressModel.h"
#import "GYCityAddressModel.h"
#import "GYProvinceModel.h"
#import "GYAddressData.h"
#import "YYKit.h"
#import "GYProvinceChooseViewController.h"
#import "GYHSProvinceViewController.h"
#import "GYCityChooseViewController.h"
#import "GYHSCityAddressViewController.h"
#import "GYAreaChooseViewController.h"
#import "GYProvinceChooseModel.h"
#import "GYCityChooseModel.h"
#import "GYAreaChooseModel.h"
#import "GYHSTools.h"

@interface GYHSAddAddressViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate,GYCityAddressViewControllerDelegate,selectProvinceDelegate,selectProvince,selectCity,selectArea>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源

@property (nonatomic, strong) GYAddressModel* addModel;//详情的model

@property (nonatomic,strong) GYCityAddressModel* cityModel;//城市（互生）
@property (nonatomic,strong) GYProvinceModel* provinceModel;//省份（互生）
@property (nonatomic,strong) GYProvinceChooseModel *foodProModel;//省份 餐饮
@property (nonatomic,strong) GYCityChooseModel *foodCityModel;//城市 餐饮
@property (nonatomic,strong) GYAreaChooseModel *foodAreaModel;//地区 餐饮
@property (nonatomic,strong) UIButton *defaultBtn;//设置默认
@property (nonatomic,strong) UIButton *saveBtn;//保存

@property (nonatomic,copy) NSString *reciver;//收货人
@property (nonatomic,copy) NSString *mobile;//手机
@property (nonatomic,copy) NSString *telPhone;//固定电话
@property (nonatomic,copy) NSString *postCode;//邮编
@property (nonatomic,copy) NSString *address;//详细地址
@property (nonatomic,copy) NSString *province;//省份
@property (nonatomic,copy) NSString *city;//城市
@property (nonatomic,copy) NSString *area;//区域

@end

@implementation GYHSAddAddressViewController

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
    
    if(self.isFood == YES) {
        if(textField.tag - kFoodDetailTag == 4) {//手机
            self.mobile = textField.text;
        }
    }else {
        if(textField.tag - kGoodDetailTag == 3) {//收货人
            self.reciver = textField.text;
        }else if (textField.tag - kGoodDetailTag == 4) {//手机
            self.mobile = textField.text;
        }else if (textField.tag - kGoodDetailTag == 5) {//固定电话
            self.telPhone = textField.text;
        }else if (textField.tag - kGoodDetailTag == 6) {//邮编
            self.postCode = textField.text;
        }
    }
    
    [self.dataSource removeAllObjects];
    [self addDataSource];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidEndEditing:(UITextView *)textView {
    
    self.address = textView.text;
    [self.dataSource removeAllObjects];
    [self addDataSource];
}

#pragma mark - CustomDelegate
#pragma mark - GYCityAddressViewControllerDelegate
//城市选择回调 互生
- (void)returnPopCity:(GYCityAddressModel*)model {

    self.cityModel = model;
    self.city = model.cityName;
    [self removeDataSourceAndReloadData];
}

#pragma mark - selectProvinceDelegate
//省份选择回调 互生
- (void)returnPopPvovince:(GYProvinceModel*)model {

    self.provinceModel = model;
    self.province = model.provinceName;
    self.city = @"";
    [self removeDataSourceAndReloadData];
}

#pragma mark - selectProvince
//省份选择回调 餐饮
- (void)selectOneProvince:(GYProvinceChooseModel *)model {
    
    self.foodProModel = model;
    self.province = model.areaName;
    self.city = @"";
    self.area = @"";
    [self removeDataSourceAndReloadData];
}

#pragma mark - selectCity
//城市选择回调 餐饮
- (void)selectOneCity:(GYCityChooseModel *)model {

    self.foodCityModel = model;
    self.city = model.areaName;
    self.area = @"";
    [self removeDataSourceAndReloadData];
}

#pragma mark - selectArea
- (void)selectOneArea:(GYAreaChooseModel *)model {

    self.foodAreaModel = model;
    self.area = model.areaName;
    [self removeDataSourceAndReloadData];
}

#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    if(self.isFood == YES) {
        return 1;
    }
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.isFood == YES) {
        return 5;
    }
    
    if(section == 0) {
        return 3;
    }else {
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSAddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSAddAddressCellIdentifier];
    if(!cell) {
        cell = [[GYHSAddAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSAddAddressCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    NSDictionary *dict;
    if(self.isFood == YES) {
        if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
            cell.arrowImageView.hidden = NO;
            cell.addressTextView.hidden = YES;
            cell.detailTextField.enabled = NO;
        }else if (indexPath.row == 3) {
            cell.arrowImageView.hidden = YES;
            cell.addressTextView.hidden = NO;
            cell.detailTextField.enabled = YES;
            cell.detailTextField.keyboardType = UIKeyboardTypeDefault;
        } else {
            cell.arrowImageView.hidden = YES;
            cell.addressTextView.hidden = YES;
            cell.detailTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        cell.detailTextField.tag = indexPath.row +kFoodDetailTag ;
        [cell.detailTextField addTarget:self action:@selector(detailTextFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        dict = self.dataSource[indexPath.row];
    }else {
        cell.detailTextField.tag = indexPath.section*3 +indexPath.row + kGoodDetailTag;
        [cell.detailTextField addTarget:self action:@selector(detailTextFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        
        if(indexPath.section*3 +indexPath.row == 4 || indexPath.section*3 +indexPath.row == 5) {
            cell.detailTextField.keyboardType = UIKeyboardTypePhonePad;
        }else if (indexPath.section*3 +indexPath.row == 6) {
            cell.detailTextField.keyboardType = UIKeyboardTypeNumberPad;
        }else {
            cell.detailTextField.keyboardType = UIKeyboardTypeDefault;
        }
        
        if(indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1)) {
            cell.arrowImageView.hidden = NO;
            cell.detailTextField.enabled = NO;
        }else {
            cell.arrowImageView.hidden = YES;
            cell.detailTextField.enabled = YES;
        }
        
        if(indexPath.section == 0 && indexPath.row == 2) {
            cell.detailTextField.hidden = YES;
            cell.addressTextView.hidden = NO;
        }else {
            cell.detailTextField.hidden = NO;
            cell.addressTextView.hidden = YES;
        }

        dict = self.dataSource[indexPath.section*3 +indexPath.row ];
    }
    
    cell.detailTextField.delegate = self;
    cell.addressTextView.delegate = self;
    [cell refreshTitle:dict[@"title"] detail:dict[@"detail"] address:dict[@"address"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.isFood == YES) {
        if(indexPath.row == 3) {
            return 86;
        }else {
            return 46;
        }
    }
    
    if(indexPath.section == 0 && indexPath.row == 2) {
        return 86;
    }else {
        return 46;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if(self.isFood == YES) {
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        GYHSAddAddressCell *cell = [self.tableView cellForRowAtIndexPath:path];
        if(indexPath.row == 0) {
            GYProvinceChooseViewController* vcChangeProvince = [[GYProvinceChooseViewController alloc] init];
            vcChangeProvince.delegate = self;
            [self.navigationController pushViewController:vcChangeProvince animated:YES];
        }else if (indexPath.row == 1) {

            GYCityChooseViewController *vcChangeCity = [[GYCityChooseViewController alloc] init];
            vcChangeCity.parentName = cell.detailTextField.text;
            vcChangeCity.isUnderProvinceSelected = YES;
            vcChangeCity.delegate = self;
            [self.navigationController pushViewController:vcChangeCity animated:YES];
        }else if (indexPath.row == 2) {
            path = [NSIndexPath indexPathForRow:1 inSection:0];
            cell = [self.tableView cellForRowAtIndexPath:path];
            GYAreaChooseViewController* vcChangeArea = [[GYAreaChooseViewController alloc] init];
            vcChangeArea.delegate = self;
            vcChangeArea.parentName = cell.detailTextField.text;
            [self.navigationController pushViewController:vcChangeArea animated:YES];
        }
    }else {
        if(indexPath.section == 0 && indexPath.row == 0) {
            
                GYHSProvinceViewController* popVC = [[GYHSProvinceViewController alloc] init];
                popVC.delegate = self;
                popVC.areaId = globalData.localInfoModel.countryNo;
                popVC.type = provinceTypePop;
                [self.navigationController pushViewController:popVC animated:YES];
            
        }else if (indexPath.section == 0 && indexPath.row == 1) {
            
                GYHSCityAddressViewController* popVC = [[GYHSCityAddressViewController alloc] init];
                popVC.type = cityTypePop;
                popVC.delegate = self;
                popVC.areaIdString = self.provinceModel.provinceNo;
                popVC.areaIdcounyry = self.provinceModel.countryNo;
                [self.navigationController pushViewController:popVC animated:YES];
        }
    }
    
    
}

#pragma mark - event response  
//获取收址详情
-(void)loadNetworkForAddressDetail {
    
//    if (self.isFood) {
//        self.addModel = self.model;
//        self.province = self.model.province;
//        self.city = self.model.city;
//        self.area = self.model.area;
//        self.mobile = self.model.mobile;
//        self.address = self.model.detail;
//        
//        [self.dataSource removeAllObjects];
//        [self addDataSource];
//        [self.tableView reloadData];
//        if([self.addModel.beDefault isEqualToString:@"1"]) {
//            self.defaultBtn.selected = YES;
//        }else {
//            self.defaultBtn.selected = NO;
//        }
//        
//    }
//    else {
//        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
//                                @"addrId" : kSaftToNSString(self.addrId) };
//        
//        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlAddressDetail parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//            [GYGIFHUD dismiss];
//            if(error) {
//                [GYUtils parseNetWork:error resultBlock:nil];
//            }else {
//                self.addModel = [[GYAddressModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
//                self.cityModel = [[GYAddressData shareInstance] queryCityNo:self.addModel.cityNo];
//                self.provinceModel = [[GYAddressData shareInstance] queryProvinceNo:self.addModel.provinceNo];
//
//                self.address = self.addModel.address == nil ? @"" :self.addModel.address;
//                self.reciver = self.addModel.receiver == nil ? @"":self.addModel.receiver;
//                self.mobile = self.addModel.mobile == nil ? @"":self.addModel.mobile;
//                self.telPhone = self.addModel.telphone == nil ? @"" : self.addModel.telphone;
//                self.postCode = self.addModel.postCode == nil ? @"" :self.addModel.postCode;
//                self.province = self.provinceModel.provinceName;
//                self.city = self.cityModel.cityName;
//           
//                [self.dataSource removeAllObjects];
//                [self addDataSource];
//                [self.tableView reloadData];
//                
//                if([self.addModel.isDefault isEqualToString:@"1"]) {
//                    self.defaultBtn.selected = YES;
//                }else {
//                    self.defaultBtn.selected = NO;
//                }
//                
//            }
//        }];
//        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
//        [GYGIFHUD show];
//        [request start];
//    }

}

//删除点击
- (void)tipDelete {
    WS(weakSelf)
    [GYUtils showMessge:kLocalized(@"GYHS_Address_Confirm_Delete_Shipping_Address") confirm:^{
        [weakSelf deleteAddress];
    } cancleBlock:^{
    }];
}

//设置默认地址
-(void)defaultBtnClick:(UIButton *)sender {

    sender.selected = !sender.selected;
}

//保存点击
-(void)saveBtnClick:(UIButton *)sender {

    [self.view endEditing:YES];
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
                [self addAddress];
            }
        });
    });
    
}

//修改收货地址 （互生）
-(void)modifyAddress {
    
    if (self.isFood) {
        [self checkInfoForFood];
    }
    else {
        [self checkInfoForGoods];
    }
}

//添加餐饮地址
-(void)addAddressForFoodAddress:(NSString *)address phone:(NSString *)phone {

    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"];
    [dict setValue:kSaftToNSString(self.foodProModel.areaName) forKey:@"province"];
    [dict setValue:@"" forKey:@"provinceNo"];
    [dict setValue:kSaftToNSString(self.foodCityModel.areaName) forKey:@"city"];
    [dict setValue:@"" forKey:@"cityNo"];
    [dict setValue:kSaftToNSString(self.foodAreaModel.areaName) forKey:@"area"];
    [dict setValue:kSaftToNSString(address) forKey:@"address"];
    [dict setValue:@"" forKey:@"receiverName"];
    [dict setValue:kSaftToNSString(phone) forKey:@"phone"];
    [dict setValue:@"" forKey:@"postcode"];
    [dict setValue:@"" forKey:@"fixedTelephone"];
    [dict setValue:self.defaultBtn.selected == YES ? @"1" : @"0" forKey:@"isDefault"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:EasyBuySaveDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_CongratulationsAddShippingAddressSuccess") confirm:^{
                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshGoodList)]) {
                    [weakSelf.delegate refreshGoodList];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}

//修改餐饮地址
-(void)modifyAddressForFoodAddress:(NSString *)address phone:(NSString *)phone {

//    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//    [dict setValue:kSaftToNSString(globalData.loginModel.token) forKey:@"key"];
//    [dict setValue:kSaftToNSString(self.foodProModel.areaName == nil ? self.model.province :self.foodProModel.areaName) forKey:@"province"];
//    [dict setValue:@"" forKey:@"provinceNo"];
//    [dict setValue:kSaftToNSString(self.foodCityModel.areaName == nil ? self.model.city :self.foodCityModel.areaName ) forKey:@"city"];
//    [dict setValue:@"" forKey:@"cityNo"];
//    [dict setValue:kSaftToNSString(self.foodAreaModel.areaName == nil ? self.model.area :self.foodAreaModel.areaName) forKey:@"area"];
//    [dict setValue:kSaftToNSString(address) forKey:@"address"];
//    [dict setValue:@"" forKey:@"receiverName"];
//    [dict setValue:kSaftToNSString(phone) forKey:@"phone"];
//    [dict setValue:self.defaultBtn.selected == YES ? @"1" : @"0" forKey:@"isDefault"];
//    [dict setValue:@"" forKey:@"postcode"];
//    [dict setValue:@"" forKey:@"fixedTelephone"];
//    [dict setValue:kSaftToNSString(self.model.idString) forKey:@"id"];
//    
//     GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:EasyBuyUpdateDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//         [GYGIFHUD dismiss];
//         if(error) {
//             [GYUtils parseNetWork:error resultBlock:nil];
//         }else {
//             [GYUtils showToast:kLocalized(@"GYHS_Address_Save_Success")];
//             if(self.delegate && [self.delegate respondsToSelector:@selector(refreshGoodList)]) {
//                 [self.delegate refreshGoodList];
//                 [self.navigationController popViewControllerAnimated:YES];
//             }
//         }
//     }];
//    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
//    [GYGIFHUD show];
//    [request start];
}

//修改收货地址(互生)
-(void)modifyAddressForGoodReceive:(NSString *)receive phone:(NSString *)phone telPhone:(NSString *)telPhone postCode:(NSString *)postCode address:(NSString *)address {

    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"addrId" : kSaftToNSString(self.addModel.addrId),
                            @"receiver" : kSaftToNSString(receive),
                            @"isDefault" : self.defaultBtn.selected == YES ? @"1" : @"0",
                            @"mobile" : kSaftToNSString(phone),
                            @"phone" : kSaftToNSString(telPhone),
                            @"postCode" : kSaftToNSString(postCode),
                            @"address" : kSaftToNSString(address),
                            @"area" : kSaftToNSString(@""),
                            @"cityNo" : self.cityModel.cityNo ? self.cityModel.cityNo : self.addModel.cityNo,
                            @"provinceNo" : self.provinceModel.provinceNo ? self.provinceModel.provinceNo : self.addModel.provinceNo,
                            @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) };
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlUpdateAddress parameters:dict requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            [GYUtils showToast:kLocalized(@"GYHS_Address_Modify_Shipping_Address_Complete")];
            [GYUtils showToast:kLocalized(@"GYHS_Address_Save_Success")];
            if(self.delegate && [self.delegate respondsToSelector:@selector(refreshGoodList)]) {
                [self.delegate refreshGoodList];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}

//添加收货地址 （互生）
-(void)addAddress {
    
    if(self.isFood == YES) {
        [self checkInfoForFood];
    }else {
        [self checkInfoForGoods];
    }
    
}

//添加收货地址(互生)
-(void)addAddressForGoodReceive:(NSString *)receive phone:(NSString *)phone telPhone:(NSString *)telPhone postCode:(NSString *)postCode address:(NSString *)address {
    
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"receiver" : kSaftToNSString(receive),
                            @"isDefault" : self.defaultBtn.selected == YES ? @"1" : @"0",
                            @"mobile" : kSaftToNSString(phone),
                            @"phone" : kSaftToNSString(telPhone) == nil ? @"" : kSaftToNSString(telPhone),
                            @"postCode" : kSaftToNSString(postCode),
                            @"address" : kSaftToNSString(address),
                            @"area" : @"",
                            @"cityNo" : kSaftToNSString(self.cityModel.cityNo),
                            @"provinceNo" : kSaftToNSString(self.provinceModel.provinceNo),
                            @"countryNo" : kSaftToNSString(globalData.localInfoModel.countryNo) };
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlAddAddress parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {

            WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Address_CongratulationsAddShippingAddressSuccess") confirm:^{
                if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshGoodList)]) {
                    [weakSelf.delegate refreshGoodList];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
            
            
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [GYGIFHUD show];
    [request start];
}

//删除地址
-(void)deleteAddress {

//    if (self.isFood) {
//        
//        NSDictionary* dict = @{ @"id" : kSaftToNSString(self.model.idString),
//                                @"key" : kSaftToNSString(globalData.loginModel.token) };
//        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:EasyBuyDeleteDeliveryAddressUrl parameters:dict requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//            [GYGIFHUD dismiss];
//            if(error) {
//                [GYUtils parseNetWork:error resultBlock:nil];
//            }else {
//                WS(weakSelf)
//                [GYUtils showMessage:kLocalized(@"GYHS_Address_TheAddressWasRemovedSuccessfully")  confirm:^{
//                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshGoodList)]) {
//                        [weakSelf.delegate refreshGoodList];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                }];
//            }
//        }];
//        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
//        [GYGIFHUD show];
//        [request start];
//    }
//    else {
//        
//        NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
//                                @"addrId" : kSaftToNSString(self.addModel.addrId) };
//
//        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlDeleteAddress parameters:dict requestMethod:GYNetRequestMethodDELETE requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
//            [GYGIFHUD dismiss];
//            if(error) {
//                [GYUtils parseNetWork:error resultBlock:nil];
//            }else {
//                WS(weakSelf)
//                [GYUtils showMessage:kLocalized(@"GYHS_Address_TheAddressWasRemovedSuccessfully")  confirm:^{
//                    if(weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshGoodList)]) {
//                        [weakSelf.delegate refreshGoodList];
//                        [self.navigationController popViewControllerAnimated:YES];
//                    }
//                }];
//            }
//        }];
//        [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
//        [GYGIFHUD show];
//        [request start];
//    }
}

-(void)detailTextFieldValueChange:(UITextField *)sender {

    //收货地址
    if(sender.tag - kGoodDetailTag == 4) {
        if(sender.text.length >= 11) {
            sender.text = [sender.text substringToIndex:11];
            [sender endEditing:YES];
        }
    }else if (sender.tag - kGoodDetailTag == 6) {
        if(sender.text.length >= 6) {
            sender.text = [sender.text substringToIndex:6];
            [sender endEditing:YES];
        }
    }
    
    //餐饮地址
    if(sender.tag - kFoodDetailTag == 4) {
        if(sender.text.length >= 11) {
            sender.text = [sender.text substringToIndex:11];
            [sender endEditing:YES];
        }
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Address_Management");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);

    [self addDataSource];
    [self.tableView reloadData];
    
    if(self.boolstr) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_Address_Delete") style:UIBarButtonItemStyleBordered target:self action:@selector(tipDelete)];
        [self loadNetworkForAddressDetail];
    }else {
        [self loadAddGoodAddressView];
    }
    
}

-(UIView *)addFooterView {

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    UIView *defaultView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 46)];
    defaultView.backgroundColor = UIColorFromRGB(0xffffff);
    [footerView addSubview:defaultView];
    
    self.defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.defaultBtn.frame = CGRectMake(12, 13, 20, 20);
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gy_he_unselected_icon"] forState:UIControlStateNormal];
    [self.defaultBtn setBackgroundImage:[UIImage imageNamed:@"gycommon_circular_selected_red"] forState:UIControlStateSelected];
    [self.defaultBtn addTarget:self action:@selector(defaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [defaultView addSubview:self.defaultBtn];
    
    UILabel *defaultLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.defaultBtn.right +10, 0, kScreenWidth -self.defaultBtn.right -10, 46)];
    defaultLabel.text = kLocalized(@"GYHS_Address_SettingDefault");
    defaultLabel.textAlignment = NSTextAlignmentLeft;
    defaultLabel.textColor = UIColorFromRGB(0x000000);
    defaultLabel.font = kAddAddressViewControllerFont;
    [defaultView addSubview:defaultLabel];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame = CGRectMake(12, defaultView.bottom +20, kScreenWidth -24, 40);
    [self.saveBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    self.saveBtn.backgroundColor = [UIColor redColor];
    [self.saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveBtn setTitle:kLocalized(@"GYHS_Address_AddressSave") forState:UIControlStateNormal];
    self.saveBtn.layer.cornerRadius = 20;
    self.saveBtn.clipsToBounds = YES;
    [footerView addSubview:self.saveBtn];
    
    return footerView;
    
}

//添加收货地址的视图
-(void)loadAddGoodAddressView {

    [self.view addSubview:self.tableView];
}

//检查餐饮地址 信息
-(void)checkInfoForFood {
    
    if ([GYUtils isBlankString:self.province]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheProvince")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if ([GYUtils isBlankString:self.city]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCity")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if ([GYUtils isBlankString:self.area]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseInputArea")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if ([GYUtils isBlankString:self.address]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_Please_Fill_Out_Detailed_Address")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if (self.address.length > 128 || self.address.length < 2) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_DetailedAddressNotLessThan2OrGreaterThan128Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    
   
    if ([GYUtils isBlankString:self.mobile]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterMobilePhoneNumber")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if (![GYUtils isMobileNumber:self.mobile]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectPhoneNumber")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    
    if(self.boolstr) {
        [self modifyAddressForFoodAddress:self.address phone:self.mobile];
    }else {
        [self addAddressForFoodAddress:self.address phone:self.mobile];
    }
    
}

//检查收货地址 信息
-(void)checkInfoForGoods {
    
    if ([GYUtils isBlankString:self.province]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheProvince")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if ([GYUtils isBlankString:self.city]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCity")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if ([GYUtils isBlankString:self.address]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_Please_Fill_Out_Detailed_Address")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if (self.address.length > 128 || self.address.length < 2) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_DetailedAddressNotLessThan2OrGreaterThan128Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    
    if ([GYUtils isBlankString:self.reciver]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_Please_Fill_In_Consignee")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if (![GYUtils isValidTureWithName:self.reciver]) { //联系人名字
        [GYUtils showToast:kLocalized(@"GYHS_Address_Input_Contains_Illegal_Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if (self.reciver.length > 20 || self.reciver.length < 2) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_TheRecipientNotLessThan2OrMoreThan20Characters")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if ([GYUtils isBlankString:self.mobile]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterMobilePhoneNumber")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    else if (![GYUtils isMobileNumber:self.mobile]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectPhoneNumber")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    
    if (![GYUtils checkStringInvalid:self.telPhone]) {
        if (![GYUtils isValidFixedLineTelephone:self.telPhone]) {
            
            [GYUtils showToast:kLocalized(@"GYHS_Address_Fixed_Telephone_Input_Wrong")];
            self.saveBtn.userInteractionEnabled = YES;
            return ;
        }
    }
    
    if (![GYUtils isBlankString:self.postCode] && ![GYUtils isValidZipcode:self.postCode]) {
        [GYUtils showToast:kLocalized(@"GYHS_Address_PleaseEnterTheCorrectZipCode")];
        self.saveBtn.userInteractionEnabled = YES;
        return ;
    }
    
    if ([self.address rangeOfString:@","].location != NSNotFound) {
        self.address = [GYUtils exchangeENCommaToChCommaWithString:self.address];
        DDLogDebug(@"tvDetailAddress.text == %@", self.address);
    }
    
    if(self.boolstr) {
        [self modifyAddressForGoodReceive:self.reciver phone:self.mobile telPhone:self.telPhone postCode:self.postCode address:self.address];
    }else {
        [self addAddressForGoodReceive:self.reciver phone:self.mobile telPhone:self.telPhone postCode:self.postCode address:self.address];
    }

}

-(void)addDataSource {

    if(self.isFood == YES) {
        if(self.boolstr) {
            self.dataSource = [[NSMutableArray alloc] initWithArray:@[
                                                                  @{@"title":kLocalized(@"GYHS_Address_Province"),
                                                                    @"detail":self.province == nil ? @"":self.province,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_City"),
                                                                    @"detail": self.city == nil ? @"":self.city,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_AreaAndCounty"),
                                                                    @"detail":self.area == nil ? @"":self.area,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Details"),
                                                                    @"detail":@"",
                                                                    @"address": self.address == nil ? @"":self.address
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Mobile"),
                                                                    @"detail": self.mobile == nil ? @"":self.mobile,
                                                                    @"address":@""
                                                                    }
                                                                  ]];
        }else {
            self.dataSource = [[NSMutableArray alloc] initWithArray:@[@{@"title":kLocalized(@"省份"),
                                                                        @"detail": self.province == nil ? @"" : self.province,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_City"),
                                                                    @"detail": self.city == nil ? @"" : self.city,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_AreaAndCounty"),
                                                                    @"detail": self.area ==nil ? @"" : self.area,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Details"),
                                                                    @"detail":@"",
                                                                    @"address": self.address == nil ? @"" : self.address
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Mobile"),
                                                                    @"detail":self.mobile == nil ? @"" :self.mobile,
                                                                    @"address":@""
                                                                    }
                                                                  ]];
            
        }
    }else {
        if(self.boolstr) {
            self.dataSource = [[NSMutableArray alloc] initWithArray:@[
                                                                  @{@"title":kLocalized(@"GYHS_Address_Province"),
                                                                    @"detail": self.province == nil ? @"":self.province,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_City"),
                                                                    @"detail": self.city == nil ? @"":self.city,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Details"),
                                                                    @"detail":@"",
                                                                    @"address":self.address == nil ? @"":self.address
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Sonsignee"),
                                                                    @"detail":self.reciver == nil ? @"":self.reciver,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Mobile"),
                                                                    @"detail":self.mobile == nil ? @"":self.mobile,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_FixedTelephone"),
                                                                    @"detail":self.telPhone == nil ? @"":self.telPhone,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Postcode"),
                                                                    @"detail":self.postCode == nil ? @"":self.postCode,
                                                                    @"address":@""
                                                                    }
                                                                  ]];
        }else {
            self.dataSource = [[NSMutableArray alloc] initWithArray:@[@{@"title":kLocalized(@"GYHS_Address_Province"),
                                                                    @"detail":self.province == nil ? @"":self.province,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_City"),
                                                                    @"detail":self.city == nil ? @"":self.city,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Details"),
                                                                    @"detail":@"",
                                                                    @"address":self.address == nil ? @"":self.address
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Sonsignee"),
                                                                    @"detail":self.reciver == nil ? @"":self.reciver,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Mobile"),
                                                                    @"detail":self.mobile == nil ? @"":self.mobile,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_FixedTelephone"),
                                                                    @"detail":self.telPhone == nil ? @"":self.telPhone,
                                                                    @"address":@""
                                                                    },
                                                                  @{@"title":kLocalized(@"GYHS_Address_Postcode"),
                                                                    @"detail":self.postCode == nil ? @"":self.postCode,
                                                                    @"address":@""
                                                                    }
                                                                  ]];
        }
    }
}

-(void)removeDataSourceAndReloadData {
    
    [self.dataSource removeAllObjects];
    [self addDataSource];
    [self.tableView reloadData];
}

#pragma mark - getters and setters
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerClass:[GYHSAddAddressCell class] forCellReuseIdentifier:kGYHSAddAddressCellIdentifier];
        _tableView.tableFooterView = [self addFooterView];
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

@end
