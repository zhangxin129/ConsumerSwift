//
//  GYHDImportantChangeIdentifyViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDImportantChangeIdentifyViewController.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYHSPostscriptCertificationCell.h"
#import "UIActionSheet+Blocks.h"
#import "GYDatePiker.h"
#import "GYHDCountrySelectionViewController.h"
#import "GYHSValidPeriodCell.h"
#import "GYHSButtonCell.h"
#import "GYHSTools.h"
#import "GYHSPopView.h"
#import "GYBaseControlView.h"

@interface GYHDImportantChangeIdentifyViewController ()<GYNetRequestDelegate,UITableViewDataSource,UITableViewDelegate,GYHSPostscriptCertificationCellDelegate,GYHSRealNameRegistrationCellDelegate,GYDatePikerDelegate,selectNationalityDelegate,GYHSValidPeriodDelegate,GYHSButtonCellDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;
@property (nonatomic,copy) NSString* strCountry;

@property (nonatomic,strong)NSMutableArray *identifyArray;//护照数据源
@property (nonatomic,copy)NSMutableDictionary *dicParams;//传到下一界面的新字典
@property (nonatomic,copy)NSMutableDictionary *olddicParams;//传到下一界面的旧字典
@property (nonatomic,copy)NSMutableArray *changeItemArr;//所有变更项数组
@property (nonatomic,copy)NSString *realNameStr;//姓名
@property (nonatomic,copy)NSString *nationaltyRow;//国籍
@property (nonatomic,copy)NSString *certificationNumberRow;//证件号码
@property (nonatomic,copy)NSString *sexString;//性别
@property (nonatomic,copy)NSString *validDate; //有效日期
@property (nonatomic,copy)NSString *birthAddress;//户籍地址
@property (nonatomic,copy)NSString *paperOrganization;//签发机关
@property (nonatomic,copy)NSString *postscript;//附言
@property (nonatomic,strong)GYDatePiker* datePiker;
@property (nonatomic)BOOL islongPeriod;//长期
@property (nonatomic, assign)CGFloat textViewheight;//文本高度
//变更前内容
@property (nonatomic,copy)NSString *oldFullUserName;
@property (nonatomic,copy)NSString *oldnationaltyRow;
@property (nonatomic,copy)NSString *oldfullIdentityCard;
@property (nonatomic,copy)NSString *oldsex;
@property (nonatomic,copy)NSString *oldvalidDate;
@property (nonatomic,copy)NSString *oldBirthAddress;//签发地点
@property (nonatomic,copy)NSString *oldPaperOrganization;//签发机关

@property(nonatomic,strong)GYHSPopView *pop;
@end

@implementation GYHDImportantChangeIdentifyViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.islongPeriod = YES;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_MyInfo_Important_Informatiron_Change");
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTextViewButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPostscriptCertificationCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSValidPeriodCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSValidPeriodCell"];
     [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self loadDataFromNetwork];
       
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
        self.oldFullUserName = [GYUtils encryptUserName:dic[@"userName"]];
        self.realNameStr = [GYUtils encryptUserName:dic[@"userName"]];
        self.strCountry = dic[@"countryCode"];
        self.oldnationaltyRow = [[GYAddressData shareInstance] queryCountry:self.strCountry].countryName;
        self.nationaltyRow = [[GYAddressData shareInstance] queryCountry:self.strCountry].countryName;
        self.oldfullIdentityCard = dic[@"cerNo"];
        self.certificationNumberRow = dic[@"cerNo"];
        
        if ([dic[@"sex"] isEqualToString:@"1"]) {
            self.sexString =  kLocalized(@"GYHS_MyInfo_Man");
            self.oldsex =  kLocalized(@"GYHS_MyInfo_Man");
        }
        else {
            self.sexString= kLocalized(@"GYHS_MyInfo_Woman");
            self.oldsex =  kLocalized(@"GYHS_MyInfo_Woman");
        }
        self.oldvalidDate = [NSString stringWithFormat:@"%@", [dic valueForKey:@"validDate"]];
        self.validDate =  [NSString stringWithFormat:@"%@", [dic valueForKey:@"validDate"]];
        
        self.oldPaperOrganization = dic[@"issuingOrg"];
        self.paperOrganization = dic[@"issuingOrg"];
        self.birthAddress = dic[@"birthAddress"];
        self.oldBirthAddress = dic[@"birthAddress"];
        
        
        [self.identifyArray[0][0] setObject:kSaftToNSString(self.realNameStr) forKey:@"Value"];
        [self.identifyArray[0][1] setObject:kSaftToNSString(self.sexString) forKey:@"Value"];
        [self.identifyArray[0][2] setObject:kSaftToNSString(self.nationaltyRow) forKey:@"Value"];
        [self.identifyArray[0][4] setObject:[GYUtils encryptIdentityCard:kSaftToNSString(self.certificationNumberRow)] forKey:@"Value"];
        
        if ([kLocalized(@"GYHS_MyInfo_Long_Time") isEqualToString:self.oldvalidDate]) {
            self.islongPeriod = NO;
            [self.identifyArray[0][5] setObject:@"" forKey:@"Value"];
            [self chooseSelectButtonValidPeriod:nil];
        }
        else {
            [self.identifyArray[0][5] setObject:kSaftToNSString(dic[@"validDate"]) forKey:@"Value"];
        }
        
        [self.identifyArray[0][6] setObject:kSaftToNSString(dic[@"issuingOrg"]) forKey:@"Value"];
        [self.identifyArray[0][7] setObject:kSaftToNSString(dic[@"birthAddress"]) forKey:@"Value"];
        [self.registrationTableView reloadData];
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
#pragma mark 返回国家代理方法
- (void)selectNationalityModel:(GYAddressCountryModel*)CountryInfo
{
    self.nationaltyRow = CountryInfo.countryName;
    self.strCountry = CountryInfo.countryNo;
    [self.identifyArray[0][2] setObject:self.nationaltyRow forKey:@"Value"];
    [self.registrationTableView reloadData];
}
#pragma mark --GYHSRealNameRegistrationCellDelegate
- (void)chooseSelectButton:(NSIndexPath*)indexPath
{
    if (indexPath.row ==2) {
        _pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        GYHDCountrySelectionViewController* vcChangeCountry = [[GYHDCountrySelectionViewController alloc] init];
        vcChangeCountry.countryName = self.nationaltyRow;
        [_pop showView:vcChangeCountry];
        vcChangeCountry.Delegate = self;
    }else if (indexPath.row == 1) {
        NSArray* arrSex = @[kLocalized(@"GYHS_RealName_Man"), kLocalized(@"GYHS_RealName_Woman")];
        CGRect rectTableView = [self.registrationTableView rectForRowAtIndexPath:indexPath];
        CGRect rect = [self.registrationTableView convertRect:rectTableView toView:[self.registrationTableView superview]];
        CGPoint point = CGPointMake(130, rect.origin.y+63);
        GYBaseControlView *pop = [[GYBaseControlView alloc] initWithPoint:point titles:arrSex images:nil width:kScreenWidth - 130 selectName:self.sexString];
        pop.selectRowAtIndex = ^(NSInteger index){
            self.sexString = arrSex[index];
            [self.identifyArray[0][1] setObject:self.sexString forKey:@"Value"];
            [self.registrationTableView reloadData];
        };
        [pop show];
    }
}
-(void)emptyStarText:(NSIndexPath *)indexPath textView:(UITextView *)textView
{
    if (indexPath.section == 0) {
        if(indexPath.row == 0){
            textView.text = @"";
        }else if(indexPath.row == 4){
            textView.text = @"";
        }
    }
}
#pragma mark -- GYHSValidPeriodDelegate
- (void)tfDidBegin:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 &&  indexPath.row ==5) {
        if (!self.datePiker) {
            self.datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:nil];
            self.datePiker.delegate = self;
            [self.datePiker noMaxTime];
            [self.view addSubview:self.datePiker];
            self.datePiker = nil;
        }
    }
    else if (indexPath.section == 0 && indexPath.row == 1){
        [self chooseSelectButton:nil];
    }
}
#pragma mark -- GYHSValidPeriodDelegate
-(void)chooseSelectButtonValidPeriod:(UIButton *)btn
{
    UIButton* ValidPeriod = btn;
    if (self.islongPeriod) {
        self.islongPeriod = !self.islongPeriod;
        ValidPeriod.selected = YES;
        self.validDate = kLocalized(@"GYHS_MyInfo_Long_Time");
        [self.dicParams setValue:kLocalized(@"GYHS_MyInfo_Long_Time") forKey:@"validDate"];
        [self.identifyArray[0][5] setObject:[NSNumber numberWithBool:YES] forKey:@"textViewClick"];
    }
    else {
        self.islongPeriod = !self.islongPeriod;
        self.validDate = self.identifyArray[0][5][@"Value"];
        ValidPeriod.selected = NO;
        [self.identifyArray[0][5] setObject:[NSNumber numberWithBool:NO] forKey:@"textViewClick"];
    }
    [self.registrationTableView reloadData];
}

#pragma mark datepiker 代理方法
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    self.validDate = date;
    [self.identifyArray[0][5] setObject:self.validDate forKey:@"Value"];
    [self.registrationTableView reloadData];
}
#pragma mark --TextView
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.identifyArray[indexPath.section][indexPath.row];
    [dic setObject:value forKey:@"Value"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.realNameStr = value;
        }else if (indexPath.row == 1){
            self.sexString = value;
        }else if (indexPath.row == 2){
            self.nationaltyRow = value;
        }else if (indexPath.row == 4){
            self.certificationNumberRow = value;
        }else if (indexPath.row == 6){
            self.paperOrganization = value;
        }else if (indexPath.row == 7){
            self.birthAddress = value;
        }
    }
    
}
#pragma mark --GYHSPostscriptCertificationCellDelegate
-(void)inputPostscriptValue:(NSString *)value
{
    NSMutableDictionary *dic = self.identifyArray[1][0];
    [dic setObject:value forKey:@"Value"];
    self.postscript = value;
}
#pragma mark -- UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.identifyArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.identifyArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSMutableDictionary* dic = self.identifyArray[indexPath.section][indexPath.row];
    if (indexPath.section == 1) {
        GYHSPostscriptCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSPostscriptCertificationCell" forIndexPath:indexPath];
        [self setPostscriptCellValues:cell dataDic:dic indexPath:indexPath];
        cell.postscriptDelegate = self;
        return cell;
    }else if(indexPath.section == 0){
        if (indexPath.row == 5) {
            GYHSValidPeriodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSValidPeriodCell" forIndexPath:indexPath];
            [self setperiodCellValues:cell dataDic:dic indexPath:indexPath];
            cell.periodDelegate = self;
            return cell;
        }else {
            GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
            
            [self setCellValues:cell dataDic:dic indexPath:indexPath];
            cell.realNameDelegate = self;
            return cell;
        }
        
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
        if (indexPath.row == 6|| indexPath.row == 7) {
            return self.textViewheight+30;
        }
        
        return 44;
    }else if(indexPath.section == 1){
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
    [cell LicenceLbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"gyhd_right" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
    CGSize size = [GYUtils sizeForString:value2 font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
    self.textViewheight = size.height;
}
-(void)setperiodCellValues:(GYHSValidPeriodCell*)cell
                   dataDic:(NSDictionary*)dataDic
                 indexPath:(NSIndexPath*)indexPath
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* value2 = [dataDic valueForKey:@"Value"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    BOOL showClick = [[dataDic valueForKey:@"textViewClick"] boolValue];
    [cell LbLeftlabelText:name placeholderlbText:placeHolder tftextFieldText:value2 textFieldClick:showClick tag:indexPath];
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
- (void)nextBtn
{
    [self.view endEditing:YES];
    if (![self.oldFullUserName isEqualToString:self.realNameStr]) {
        if (self.realNameStr.length > 0 && (![GYUtils isUserName:self.realNameStr])) {
            [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_The_Name_Format_Not_Correct")];
            return;
        }
    }if (self.realNameStr.length > 0 && (self.realNameStr.length < 2 || self.realNameStr.length > 20)) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Name_Character_Length_Between_2_To_20_Please_Fill_According_The_Requirement")];
        return;
    } if (![GYUtils verifyIDCardNumber:self.certificationNumberRow country:self.nationaltyRow]) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Please_Enter_The_Correct_Id_Number")];
        return;
    }
    if (self.islongPeriod) {
        NSString* str = self.validDate;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [formatter dateFromString:str];
        NSDate* currentDate = [NSDate date];
        NSDate* earlierDate = [date earlierDate:currentDate];
        if ([GYUtils isBlankString:str]) {
            [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Please_Select_A_Valid")];
            return;
        }
        if (earlierDate == date) {
            [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Please_Enter_Valid")];
            return;
        }
    }
    
    if (![GYUtils checkStringInvalid:self.paperOrganization] && (self.paperOrganization.length < 2 || self.paperOrganization.length > 128)) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_License_Issuing_Organ_Character_Length_Between_2_To_20_Please_Fill_As_Required")];
        return;
    }if (![GYUtils checkStringInvalid:self.birthAddress] && (self.birthAddress.length < 2 || self.birthAddress.length > 128)) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Character_Length_Is_Between_2_To_128_Census_Register_Address_Please_Fill_In_According_To_The_Requirement")];
        return;
    }if (self.postscript.length == 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_MyInfo_Change_Reason_Not_To_Fill_Out")];
        return;
    } // 保护 * 认为没有修改
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
    if ([self.oldFullUserName isEqualToString:RealNameRow] && [self.oldfullIdentityCard isEqualToString:CerNumberRow] && [self.oldsex isEqualToString:self.sexString] && [self.oldnationaltyRow isEqualToString:self.nationaltyRow] && [self.oldPaperOrganization isEqualToString:self.paperOrganization] && [self.oldBirthAddress isEqualToString:self.birthAddress] && [self.oldvalidDate isEqualToString:self.validDate] ) {
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
            [self.dicParams setValue:kSaftToNSString(self.realNameStr) forKey:@"nameNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"userName"]) forKey:@"nameOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_User_Name")];
        }
        if (self.sexString.length > 0 && ![self.oldsex isEqualToString:self.sexString]) {
            if ([self.sexString isEqualToString:@"男"]) {
                [self.dicParams setValue:kSexMan forKey:@"sexNew"];
            }else{
                [self.dicParams setValue:kSexWoman forKey:@"sexNew"];
            }
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"sex"]) forKey:@"sexOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Sex")];
        }
        if(![self.oldnationaltyRow isEqualToString:self.nationaltyRow]){
            
            NSString *countryCodestr = [[GYAddressData shareInstance] queryCountryName:self.nationaltyRow].countryNo;
            NSCharacterSet *inset = [NSCharacterSet characterSetWithCharactersInString:@"."];
            
            NSArray *arr = [countryCodestr componentsSeparatedByCharactersInSet:inset];
            NSArray *arr1 = [authInfodic[@"countryCode"] componentsSeparatedByCharactersInSet:inset];
            NSString *str = arr[0];
            NSString *str1 = arr1[0];
            [self.dicParams setValue:str forKey:@"nationalityNew"];
            [self.olddicParams setValue:str1 forKey:@"nationalityOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Nationality")];
        }
        [self.dicParams setValue:@1 forKey:@"creTypeNew"];
        [self.olddicParams setValue:@1  forKey:@"creTypeOld"];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Papers_Type")];
        
        NSRange rangeCerNumber = [self.certificationNumberRow rangeOfString:@"*"];
        if (self.certificationNumberRow.length > 0 && (rangeCerNumber.location == NSNotFound &&![self.oldfullIdentityCard isEqualToString:self.certificationNumberRow])) {
            [self.dicParams setValue:kSaftToNSString(self.certificationNumberRow) forKey:@"creNoNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerNo"]) forKey:@"creNoOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Papers_Number")];
        }
        if (![self.birthAddress isEqualToString:kSaftToNSString(authInfodic[@"birthAddress"])]) {
            // 出生地点
            [self.dicParams setValue:kSaftToNSString(self.birthAddress) forKey:@"registorAddressNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"birthAddress"]) forKey:@"registorAddressOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Famliy_Reigster_Address")];
        }
        if(![self.paperOrganization isEqual:kSaftToNSString(authInfodic[@"issuingOrg"])] && self.paperOrganization.length > 0){
            [self.dicParams setValue:self.paperOrganization forKey:@"creIssueOrgNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"issuingOrg"]) forKey:@"creIssueOrgOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Issuing_Authority")];
        }
        
        if (self.islongPeriod) {
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"validDate"]) forKey:@"creExpireDateOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Long_Time")];
        }
        
        if(![self.validDate isEqualToString:kSaftToNSString(authInfodic[@"validDate"])]){
            [self.dicParams setValue:self.validDate forKey:@"creExpireDateNew"];
            [self.olddicParams setValue:kSaftToNSString(authInfodic[@"validDate"]) forKey:@"creExpireDateOld"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certification_Valid_Date")];
        }
        if (self.postscript.length > 0) {
            [self.dicParams setValue:self.postscript forKey:@"applyReason"];
            [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Change_Reason")];
        }
        [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerPich"]) forKey:@"creHoldPicOld"];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Holding_Certificates_Bust")];
        [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerPica"]) forKey:@"creFacePicOld"];
        [self.olddicParams setValue:kSaftToNSString(authInfodic[@"cerPich"]) forKey:@"creHoldPicOld"];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Certificate_Front")];
        [self.changeItemArr addObject:kLocalized(@"GYHS_MyInfo_Holding_Papers_Photos")];
        if ([_changeIdentifyDelegate respondsToSelector:@selector(importantChangeIdentify:olddic:changeItem:)]) {
            [self.changeIdentifyDelegate importantChangeIdentify:self.dicParams olddic:self.olddicParams changeItem:self.changeItemArr];
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
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
-(NSMutableArray*)identifyArray
{
    if (_identifyArray == nil) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        
        NSArray *valueAry = @[kLocalized(@"GYHS_MyInfo_User_Name"),
                              [NSString stringWithFormat:@"%@ **", [globalData.loginModel.custName substringToIndex:1]],
                              kLocalized(@"GYHS_MyInfo_Input_Receive_Name"),
                              [NSNumber numberWithBool:NO],
                              [NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Sex"),@"",kLocalized(@"GYHS_MyInfo_Select_Gender"),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Nationality"),
                     @"",
                     @"",
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Papers_Type"),
                     kLocalized(@"GYHS_MyInfo_Id_Card"),
                     @"",
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Papers_Number"),
                     [GYUtils encryptPassport:globalData.loginModel.creNo],
                     kLocalized(@"GYHS_MyInfo_Input_Papers_Number"),
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Certification_Valid_Date"),@"",kLocalized(@"GYHS_MyInfo_Enter_The_Period_Of_Validity"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Issuing_Authority"),@"",kLocalized(@"GYHS_MyInfo_Enter_The_License_Issuing_Agencies"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Famliy_Reigster_Address"),@"",kLocalized(@"GYHS_MyInfo_Enter_The_Hukou_Address"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Change_Reason"),@"",kLocalized(@"GYHS_MyInfo_Please_Input_Change_Reason"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array2  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[@""];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _identifyArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _identifyArray;
}

@end
