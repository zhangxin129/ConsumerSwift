//
//  GYHDImportantChangeLicenceViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDImportantChangeLicenceViewController.h"
#import "GYNetRequest.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSPostscriptCertificationCell.h"
#import "GYDatePiker.h"
#import "GYHSButtonCell.h"
#import "GYHSTools.h"

@interface GYHDImportantChangeLicenceViewController ()<UITableViewDataSource,UITableViewDelegate,GYNetRequestDelegate,GYHSRealNameRegistrationCellDelegate,GYHSPostscriptCertificationCellDelegate,GYDatePikerDelegate,GYHSButtonCellDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;
@property (nonatomic, copy) NSMutableArray* businessLicenceArray;//营业执照数据源
@property (nonatomic,copy)NSMutableDictionary *dicParams;//传到下一界面的新字典
@property (nonatomic,copy)NSMutableDictionary *olddicParams;//传到下一界面的旧字典
@property (nonatomic,copy)NSMutableArray *changeItemArr;//所有变更项数组
@property (nonatomic,copy)NSString *companyTypeRow;//公司类型
@property (nonatomic,copy)NSString* bulidDate; //成立日期
@property (nonatomic,copy)NSString *postscript;//变更信息
@property (nonatomic,strong)GYDatePiker* datePiker;
@property (nonatomic,copy)NSString *realNameStr;//企业名称
@property (nonatomic,copy)NSString *nationaltyRow;// 注册地址行
@property (nonatomic,copy)NSString *certificationNumberRow;//证件号码
@property (nonatomic, assign)CGFloat textViewheight;//文本高度
//变更前内容
@property (nonatomic,copy)NSString *oldFullUserName;
@property (nonatomic,copy)NSString *oldfullIdentityCard;
@property (nonatomic,copy)NSString *oldentRegAddr;
@property (nonatomic,copy)NSString *oldentType;
@property (nonatomic,copy)NSString *oldauthDate;

@end

@implementation GYHDImportantChangeLicenceViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_MyInfo_Important_Informatiron_Change");
   
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTextViewButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPostscriptCertificationCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self loadDataFromNetwork];
}
- (void)nextBtn
{
    [self.view endEditing:YES];
    if (self.realNameStr.length < 2 || self.realNameStr.length > 64) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Enterprise_Name_Character_Length_Is_Between_2_To_64_Please_Fill_In_According_To_The_Requirement")];
        return;
    }if (self.certificationNumberRow.length < 7 || self.certificationNumberRow.length > 30) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Business_License_Number_Input_Errors")];
        return;
    }if ( self.nationaltyRow.length < 2 || self.nationaltyRow.length > 128) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Address_Character_Length_Between_2_128_Please_Fill_As_Required")];
        return;
    }if ([GYUtils isBlankString:self.companyTypeRow]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Please_Enter_Type_Of_Company")];
        return;
    }
    if (self.companyTypeRow.length >20 || self.companyTypeRow.length <2) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Enterprise_Type_For_2_To_20_Characters")];
        return;
    }if ([GYUtils isBlankString:self.bulidDate]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Please_Enter_The_Founded_Date")];
        return;
    }if (self.postscript.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Change_Reason_Not_To_Fill_Out")];
        return;
    }
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* datenow = [formatter dateFromString:self.bulidDate];
    NSDate* currentDate = [NSDate date];
    NSDate* earlierDate = [datenow earlierDate:currentDate];
    if (earlierDate != datenow) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_RealName_Enterprises_Set_Up_Date_Must_Be_Less_Than_The_Current_Date")];
        return;
    }
    // 保护 * 认为没有修改
    NSString *RealNameRow,*CerNumberRow;
    NSRange rangeRealName = [self.realNameStr rangeOfString:@"*"];
    if (rangeRealName.location != NSNotFound) {
        RealNameRow = self.oldFullUserName;
    }else {
        RealNameRow = self.realNameStr;
    }
    NSRange rangeCerNumber = [self.certificationNumberRow rangeOfString:@"*"];
    
    if (rangeCerNumber.location != NSNotFound) {
        CerNumberRow = self.oldfullIdentityCard;
    }else {
        CerNumberRow = self.certificationNumberRow;
    }
    if ([self.oldFullUserName isEqualToString:RealNameRow ] &&  [self.oldfullIdentityCard isEqualToString:CerNumberRow] &&[self.oldauthDate isEqualToString:self.bulidDate] && [self.oldentType isEqualToString:self.companyTypeRow] && [self.oldentRegAddr isEqualToString:self.nationaltyRow]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_You_Do_Not_Change_Any_Content_Cannot_Be_An_Application_Regarding_The_Change_Of_Important_Information")];
        return;
    }
    [self queryCustomerInfo];
}
-(void)queryCustomerInfo
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:CustomerInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *authInfodic = responseObject[@"data"][@"authInfo"];
        NSRange rangeRealName = [self.realNameStr rangeOfString:@"*"];
        if (self.realNameStr.length > 0  &&  (rangeRealName.location == NSNotFound && ![self.oldFullUserName isEqualToString:self.realNameStr]) ) {
            
            [self.dicParams setValue:kSaftToNSString(self.realNameStr) forKey:@"entNameNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"entName"]) forKey:@"entNameOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_An_Enterprise_Name")];
            
            
        }if (![self.oldentRegAddr isEqualToString:self.nationaltyRow]) {
            [self.dicParams setValue:self.nationaltyRow forKey:@"entRegAddrNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"entRegAddr"]) forKey:@"entRegAddrOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_The_Registered_Address")];
        }
        [self.dicParams setValue:@3 forKey:@"creTypeNew"];
        [self.olddicParams setValue:@3  forKey:@"creTypeOld"];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Papers_Type")];
        
        
        NSRange rangeCerNumber = [self.certificationNumberRow rangeOfString:@"*"];
        if (self.certificationNumberRow.length > 0 && (rangeCerNumber.location == NSNotFound &&![self.oldfullIdentityCard isEqualToString:self.certificationNumberRow])) {
            [self.dicParams setValue:kSaftToNSString(self.certificationNumberRow) forKey:@"creNoNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerNo"]) forKey:@"creNoOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Papers_Number")];
        }if (self.companyTypeRow.length > 0 &&![self.companyTypeRow isEqual:authInfodic[@"entType"]]) {
            [self.dicParams setValue:self.companyTypeRow forKey:@"entTypeNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"entType"]) forKey:@"entTypeOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_The_Enterprise_Type")];
        }
        if (self.bulidDate.length > 0 &&![self.bulidDate isEqualToString:kSaftToNSString(authInfodic[@"entBuildDate"])]) {
            [self.dicParams setValue:self.bulidDate forKey:@"entBuildDateNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"entBuildDate"]) forKey:@"entBuildDateOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Enterprises_Set_Up_The_Date")];
        }if (self.postscript.length > 0) {
            [self.dicParams setValue:self.postscript forKey:@"applyReason"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Change_Reason")];
        }
        [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerPica"]) forKey:@"creFacePicOld"];
        [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerPich"]) forKey:@"creHoldPicOld"];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certificate_Front")];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Holding_Papers_Photos")];
       
        if ([_changeLicenceDelegate respondsToSelector:@selector(importantChangeLicence:olddic:changeItem:)]) {
            [self.changeLicenceDelegate  importantChangeLicence:self.dicParams olddic:self.olddicParams changeItem:self.changeItemArr];
        }
        
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    
}
#pragma mark --  查询实名认证信息
- (void)loadDataFromNetwork
{
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId) };
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSGetsearchRealNameAuthInfo parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject[@"data"];
        self.oldFullUserName = dic[@"entName"];
        self.oldfullIdentityCard = dic[@"cerNo"];
        self.oldentRegAddr = dic[@"entRegAddr"];
        self.oldentType = dic[@"entType"];
        self.oldauthDate = [NSString stringWithFormat:@"%@", [dic valueForKey:@"entBuildDate"]];
        self.realNameStr = dic[@"entName"];
        self.certificationNumberRow = dic[@"cerNo"];
        self.nationaltyRow = dic[@"entRegAddr"];
        self.companyTypeRow = dic[@"entType"];
        self.bulidDate = [NSString stringWithFormat:@"%@", [dic valueForKey:@"entBuildDate"]];
        
        [self.businessLicenceArray[0][0] setObject:self.realNameStr forKey:@"Value"];
        [self.businessLicenceArray[0][2] setObject:[GYUtils encryptBusinessLicense:self.certificationNumberRow] forKey:@"Value"];
        [self.businessLicenceArray[0][3] setObject:kSaftToNSString(dic[@"entRegAddr"]) forKey:@"Value"];
        [self.businessLicenceArray[1][0] setObject:kSaftToNSString(dic[@"entType"]) forKey:@"Value"];
        [self.businessLicenceArray[1][1] setObject:self.oldauthDate forKey:@"Value"];
        [self.registrationTableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark --GYHSRealNameRegistrationCellDelegate
-(void)textViewDidBeginindexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row ==1) {
        if (!self.datePiker) {
            self.datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:nil];
            self.datePiker.delegate = self;
            [self.datePiker noMaxTime];
            
            [self.view addSubview:self.datePiker];
            self.datePiker = nil;
        }
    }else {
        return;
    }
}
-(void)emptyStarText:(NSIndexPath *)indexPath textView:(UITextView *)textView
{
    if (indexPath.section == 0) {
        if(indexPath.row == 2){
            textView.text = @"";
        }
    }
}
#pragma mark --TextView
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.businessLicenceArray[indexPath.section][indexPath.row];
    [dic setObject:value forKey:@"Value"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.realNameStr = value;
        }else if (indexPath.row == 2){
            self.certificationNumberRow = value;
        }else if (indexPath.row == 3){
            self.nationaltyRow = value;
        }
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        self.companyTypeRow = value;
    }
}
#pragma mark --GYHSPostscriptCertificationCellDelegate
-(void)inputPostscriptValue:(NSString *)value
{
    NSMutableDictionary *dic = self.businessLicenceArray[1][0];
    [dic setObject:value forKey:@"Value"];
    self.postscript = value;
}
#pragma mark datepiker 代理方法
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    self.bulidDate = date;
    [self.businessLicenceArray[1][1] setObject:self.bulidDate forKey:@"Value"];
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
    }else if(indexPath.section == 1 || indexPath.section == 0){
        GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setCellValues:cell dataDic:dic indexPath:indexPath];
        return cell;
    }else {
        GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnTitle setTitle:kLocalized(@"GYHS_MyInfo_Next_Step") forState:UIControlStateNormal];
        cell.btnTitle.backgroundColor = kButtonCellBtnCorlor;
        cell.btnDelegate  = self;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 || indexPath.row == 3) {
            return self.textViewheight+28;
        }
        return 44;
    }else if (indexPath.section == 1) {
        return 44;
    }else if(indexPath.section  == 2){
        return 200;
    }
    return 50;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    return view;
}
//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kDefaultMarginToBounds;
    }
    else {
        return 1.0f;
    }
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
    [cell LicenceLbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
    CGSize size = [GYUtils sizeForString:value2 font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
    self.textViewheight = size.height;
    cell.realNameDelegate = self;
}
- (void)setPostscriptCellValues:(GYHSPostscriptCertificationCell*)cell
                        dataDic:(NSDictionary*)dataDic
                      indexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* value2 = [dataDic valueForKey:@"Value"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    [cell postscriptlbText:name placeholderlbText:placeHolder tfTextViewText:value2];
}
#pragma mark -- 懒加载
-(UITableView*)registrationTableView
{
    if (!_registrationTableView) {
        _registrationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-20) style:UITableViewStyleGrouped];
        _registrationTableView.delegate = self;
        _registrationTableView.dataSource = self;
        [self.view addSubview:_registrationTableView];
    }
    return _registrationTableView;
}
-(NSMutableDictionary*)dicParams
{
    if (_dicParams == nil) {
        _dicParams = [[NSMutableDictionary alloc] init];
    }
    return _dicParams;
}
-(NSMutableDictionary*)olddicParams
{
    if (_olddicParams == nil) {
        _olddicParams = [[NSMutableDictionary alloc] init];
    }
    return _olddicParams;
}
-(NSMutableArray*)changeItemArr
{
    if (_changeItemArr == nil) {
        _changeItemArr = [[NSMutableArray alloc] init];
    }
    return _changeItemArr;
}
-(NSMutableArray*)businessLicenceArray
{
    if (_businessLicenceArray == nil) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        
        NSArray *valueAry = @[kLocalized(@"GYHS_MyInfo_An_Enterprise_Name"), @"", kLocalized(@"GYHS_MyInfo_Input_An_Enterprise_Name"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Papers_Type"),kLocalized(@"GYHS_MyInfo_The_Business_License"),@"", [NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Papers_Number"), @"", kLocalized(@"GYHS_MyInfo_Input_Papers_Number"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_The_Registered_Address"), @"", kLocalized(@"GYHS_MyInfo_Input_The_Registered_Address"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Type_Of_Company"),@"",kLocalized(@"GYHS_MyInfo_Enter_Type_Of_Company"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Set_Up_The_Date"),@"",kLocalized(@"GYHS_MyInfo_Enter_The_Company_Set_Up_Date"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Change_Reason"),@"",kLocalized(@"GYHS_MyInfo_Please_Input_Change_Reason"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@""];
        [array4  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _businessLicenceArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3,array4, nil];
    }
    return _businessLicenceArray;
}

@end
