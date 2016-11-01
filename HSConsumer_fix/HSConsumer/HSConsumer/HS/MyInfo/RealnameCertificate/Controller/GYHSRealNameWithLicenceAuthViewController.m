//
//  GYHSRealNameWithLicenceAuthViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSRealNameWithLicenceAuthViewController.h"
#import "GYNetRequest.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSPostscriptCertificationCell.h"
#import "GYRealNameAuthConfirmViewController.h"
#import "GYDatePiker.h"

@interface GYHSRealNameWithLicenceAuthViewController ()<UITableViewDataSource,UITableViewDelegate,GYNetRequestDelegate,GYHSRealNameRegistrationCellDelegate,GYHSPostscriptCertificationCellDelegate,GYDatePikerDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;
@property (nonatomic, copy) NSMutableArray* businessLicenceArray;//营业执照数据源
@property (nonatomic,strong)NSMutableDictionary* dictInside;//传到下一界面的字典
@property (nonatomic,copy)NSString *companyTypeRow;//公司类型
@property (nonatomic,copy)NSString* bulidDate; //成立日期
@property (nonatomic,copy)NSString *postscript;//附言
@property (nonatomic,strong)GYDatePiker* datePiker;
@property (nonatomic,copy)NSString *realNameStr;//企业名称
@property (nonatomic,copy)NSString *nationaltyRow;//国籍  注册地址行
@property (nonatomic,copy)NSString *certificationNumberRow;//证件号码
@property (nonatomic, assign)CGFloat textViewheight;//文本高度
@end

@implementation GYHSRealNameWithLicenceAuthViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_RealName_Next_Step") style:UIBarButtonItemStyleBordered target:self action:@selector(confirm)];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTextViewButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSPostscriptCertificationCell" bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    [self loadDataFromNetwork];
}
- (void)confirm
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
    
    GYRealNameAuthConfirmViewController* vcAuthConfirm = [[GYRealNameAuthConfirmViewController alloc] initWithNibName:@"GYRealNameAuthConfirmViewController" bundle:nil];
    vcAuthConfirm.dictInside = self.dictInside;
    vcAuthConfirm.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    vcAuthConfirm.useType = useForAuth;
    [self.navigationController pushViewController:vcAuthConfirm animated:YES];
}
#pragma mark --  查询实名注册信息GYNetRequestDelegate
- (void)loadDataFromNetwork
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kQueryRegisterRealNameUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    [GYGIFHUD show];
}
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    [GYGIFHUD dismiss];
    NSDictionary *dataDic = responseObject[@"data"];
    self.realNameStr = [NSString stringWithFormat:@"%@", kSaftToNSString(dataDic[@"entName"])];
    self.certificationNumberRow = [GYUtils encryptBusinessLicense:[NSString stringWithFormat:@"%@", dataDic[@"cerNo"]]];
    self.nationaltyRow = [NSString stringWithFormat:@"%@", dataDic[@"entRegAddr"]];
    [self.businessLicenceArray[0][0] setObject:self.realNameStr forKey:@"Value"];
    [self.businessLicenceArray[0][2] setObject:self.certificationNumberRow forKey:@"Value"];
    [self.registrationTableView reloadData];
}
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error
{
    [GYGIFHUD dismiss];
        DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
        [GYUtils parseNetWork:error resultBlock:nil];
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
    }else {
        GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
        
        [self setCellValues:cell dataDic:dic indexPath:indexPath];
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0 ) {
            return self.textViewheight+28;
        }
        return 44;
    }else if (indexPath.section == 1) {
        return 44;
    }else {
        return 200;
    }
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
    [cell LicenceLbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"gyhs_shoping_top" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
    CGSize size = [GYUtils sizeForString:value2 font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
    self.textViewheight = size.height;
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
        _registrationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _registrationTableView.delegate = self;
        _registrationTableView.dataSource = self;
        [self.view addSubview:_registrationTableView];
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
    if (_businessLicenceArray == nil) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        
        NSArray *valueAry = @[kLocalized(@"GYHS_RealName_An_Enterprise_Name"), @"", @"",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"),kLocalized(@"GYHS_RealName_The_Business_License"),@"", [NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"), @"", @"",[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_The_Registered_Address"), @"", kLocalized(@"GYHS_RealName_Choose_The_Registered_Address"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Type_Of_Company"),@"",kLocalized(@"GYHS_RealName_Enter_Type_Of_Company"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Founded_Date"),@"",kLocalized(@"GYHS_RealName_Please_Enter_Company_Founded_Date"),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Certification_Of_Ps"),@"",kLocalized(@"GYHS_RealName_Please_Input_Certification_Of_Ps"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
       _businessLicenceArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _businessLicenceArray;
}

@end
