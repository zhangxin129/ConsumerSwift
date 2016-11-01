//
//  GYHDRealNameWithLicenceAuthViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRealNameWithLicenceAuthViewController.h"
#import "GYNetRequest.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSPostscriptCertificationCell.h"
#import "GYDatePiker.h"
#import "Masonry.h"
#import "GYHSButtonCell.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSTools.h"

@interface GYHDRealNameWithLicenceAuthViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSRealNameRegistrationCellDelegate,GYHSPostscriptCertificationCellDelegate,GYDatePikerDelegate,GYHSButtonCellDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;
@property (nonatomic, copy) NSMutableArray* businessLicenceArray;//营业执照数据源
@property (nonatomic,strong)NSMutableDictionary* dictInside;//传到下一界面的字典
@property (nonatomic,copy)NSString *companyTypeRow;//公司类型
@property (nonatomic,copy)NSString* bulidDate; //成立日期
@property (nonatomic,copy)NSString *postscript;//附言
@property (nonatomic,strong)GYDatePiker* datePiker;

@property (nonatomic,copy)NSString *nationaltyRow;//国籍  注册地址行

@property (nonatomic, assign)CGFloat lbheight;//文本高度
@end

@implementation GYHDRealNameWithLicenceAuthViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    [self.view addSubview:self.registrationTableView];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTwoTableViewCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTextViewButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPostscriptCertificationCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    
}

- (void)nextBtn
{
    [self.view endEditing:YES];
    if (self.nationaltyRow.length < 2 || self.nationaltyRow.length > 128) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Enterprises_Registered_Address_Character_Length_Is_Between_2_To_128_Please_Fill_In_According_To_The_Requirement")];
        return;
    }
    
    if ([GYUtils isBlankString:self.companyTypeRow]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_Type_Of_Company")];
        return;
    }
    if (self.companyTypeRow.length >20 || self.companyTypeRow.length <2) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Enterprise_Type_For_2_To_20_Characters")];
        return;
    }
    
    if ([GYUtils isBlankString:self.bulidDate]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_The_Founded_Date")];
        return;
    }
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* datenow = [formatter dateFromString:self.bulidDate];
    NSDate* currentDate = [NSDate date];
    NSDate* earlierDate = [datenow earlierDate:currentDate];
    if (earlierDate != datenow) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Enterprises_Set_Up_Date_Must_Be_Less_Than_The_Current_Date")];
        return;
    }
    if (globalData.loginModel.resNo.length)
        [self.dictInside setValue:globalData.loginModel.resNo forKey:@"perResNo"];
    if (globalData.loginModel.custId.length)
        [self.dictInside setValue:globalData.loginModel.custId forKey:@"perCustId"];
    if (globalData.loginModel.custName.length)
        [self.dictInside setValue:globalData.loginModel.custName forKey:@"entName"];
    
    [self.dictInside setValue:globalData.loginModel.creType forKey:@"certype"];
    [self.dictInside setValue:globalData.loginModel.creNo forKey:@"credentialsNo"];
    [self.dictInside setValue:self.nationaltyRow forKey:@"entRegAddr"];
    [self.dictInside setValue:self.companyTypeRow forKey:@"entType"];
    self.postscript = [GYUtils exchangeENCommaToChCommaWithString:self.postscript];
    [self.dictInside setValue:self.postscript forKey:@"postScript"];
    [self.dictInside setValue:self.bulidDate forKey:@"entBuildDate"]; //上传与显示的格式不一样
    if ([_licenceDelegate respondsToSelector:@selector(licenceAuth:)]) {
        [self.licenceDelegate licenceAuth:self.dictInside];
    }
}

#pragma mark --GYHSRealNameRegistrationCellDelegate
- (void)chooseSelectButton:(NSIndexPath*)indexPath
{
    if (!self.datePiker) {
        self.datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:nil];
        self.datePiker.delegate = self;
        [self.datePiker noMaxTime];
        
        [self.view addSubview:self.datePiker];
        self.datePiker = nil;
    }
}
#pragma mark --TextView
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.businessLicenceArray[indexPath.section][indexPath.row];
    [dic setObject:value forKey:@"Value"];
    if (indexPath.section == 1 && indexPath.row == 1) {
        self.companyTypeRow = value;
    }else if(indexPath.section == 1 && indexPath.row == 0){
        self.nationaltyRow = value;
    }
}
#pragma mark --GYHSPostscriptCertificationCellDelegate
-(void)inputPostscriptValue:(NSString *)value
{
    NSMutableDictionary *dic = self.businessLicenceArray[2][0];
    [dic setObject:value forKey:@"Value"];
    self.postscript = value;
}
#pragma mark datepiker 代理方法
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    self.bulidDate = date;
    [self.businessLicenceArray[1][2] setObject:self.bulidDate forKey:@"Value"];
    [self.registrationTableView reloadData];
}
#pragma mark -- UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.businessLicenceArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businessLicenceArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSMutableDictionary* dic = self.businessLicenceArray[indexPath.section][indexPath.row];
    if (indexPath.section == 2) {
        GYHSPostscriptCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSPostscriptCertificationCell" forIndexPath:indexPath];
        [self setPostscriptCellValues:cell dataDic:dic indexPath:indexPath];
        cell.postscriptDelegate = self;
        return cell;
    }else if (indexPath.section == 0) {
        GYHSLabelTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
        if (indexPath.row != 0 ) {
            cell.toplb.hidden = YES;
        }
        cell.titleLabel.text = self.businessLicenceArray[indexPath.section][indexPath.row][@"Name"];
        cell.detLabel.text = self.businessLicenceArray[indexPath.section][indexPath.row][@"Value"];
        cell.detLabel.textAlignment = NSTextAlignmentRight;
        cell.detLabel.font = kButtonCellFont;
        cell.titleLabel.font = kButtonCellFont;
        CGSize size = [GYUtils sizeForString:cell.detLabel.text font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
        self.lbheight = size.height;
        return cell;
    }else if (indexPath.section == 3){
        GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        [cell.btnTitle setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];
        cell.btnTitle.backgroundColor = kButtonCellBtnCorlor;
        cell.btnDelegate  = self;
        return cell;
    }else {
        GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
        
        [self setCellValues:cell dataDic:dic indexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 2) {
        return 200;
    }else if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            return self.lbheight+28;
        }
        return 44;
    }else {
        return 44;
    }
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 180, 10)];
    lb.font = kWarmCellFont;
    lb.textColor = kcurrencyBalanceCorlor;
    if (section == 0) {
        lb.text =kLocalized( @"GYHD_RealnameRegister_Registration_Information");
        
    }else if (section == 1){
        lb.text = kLocalized(@"GYHD_RealnameRegister_Authentication_Information");
    }
    [view addSubview:lb];
    return view;

}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 22.0f;
    }
    else {
        return 1.0f;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1.0f;
    }
    return 20.0f;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}
- (void)setCellValues:(GYHSLabelTextViewButtonCell*)cell
              dataDic:(NSDictionary*)dataDic
            indexPath:(NSIndexPath*)indexPath
{
    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* value2 = [dataDic valueForKey:@"Value"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    BOOL showSmsBtn = [[dataDic valueForKey:@"showSmsBtn"] boolValue];
    BOOL showtextViewClick = [[dataDic valueForKey:@"textViewClick"] boolValue];
    [cell LicenceLbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"gyhs_shoping_top" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
   
    cell.realNameDelegate = self;
}
- (void)setPostscriptCellValues:(GYHSPostscriptCertificationCell*)cell
                        dataDic:(NSDictionary*)dataDic
                      indexPath:(NSIndexPath*)indexPath
{
    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* value2 = [dataDic valueForKey:@"Value"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    [cell postscriptlbText:name placeholderlbText:placeHolder tfTextViewText:value2];
}
#pragma mark -- 懒加载
-(UITableView*)registrationTableView
{
    if (!_registrationTableView) {
        _registrationTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _registrationTableView.delegate = self;
        _registrationTableView.dataSource = self;
        [self.view addSubview:_registrationTableView];
        [_registrationTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
    }
    return _registrationTableView;
}
-(NSMutableDictionary*)dictInside
{
    if (_dictInside == nil) {
        _dictInside = [[NSMutableDictionary alloc] init];
    }
    return _dictInside;
}
-(NSMutableArray*)businessLicenceArray
{
    if (!_businessLicenceArray) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        
        NSArray *valueAry = @[kLocalized(@"GYHS_RealName_An_Enterprise_Name"),globalData.loginModel.custName,@"",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"),kLocalized(@"GYHS_RealName_The_Business_License"),@"", [NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Papers_Number"), [GYUtils encryptBusinessLicense:globalData.loginModel.creNo], @"",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_The_Registered_Address"), @"", kLocalized(@"GYHS_RealName_Choose_The_Registered_Address"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Type_Of_Company"),@"",kLocalized(@"GYHS_RealName_Enter_Type_Of_Company"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Founded_Date"),@"",kLocalized(@"GYHS_RealName_Please_Enter_Company_Founded_Date"),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Certification_Of_Ps"),@"",kLocalized(@"GYHS_RealName_Please_Input_Certification_Of_Ps"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@""];
        [array4  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _businessLicenceArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3,array4, nil];
    }
    return _businessLicenceArray;
}

@end
