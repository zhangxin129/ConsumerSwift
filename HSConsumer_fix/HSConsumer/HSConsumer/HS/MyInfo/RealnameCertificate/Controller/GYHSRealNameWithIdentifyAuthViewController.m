//
//  GYHSRealNameWithIdentifyAuthViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSRealNameWithIdentifyAuthViewController.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYHSPostscriptCertificationCell.h"
#import "GYRealNameAuthConfirmViewController.h"
#import "UIActionSheet+Blocks.h"
#import "GYDatePiker.h"
#import "GYHSValidPeriodCell.h"
#import "GYCountrySelectionViewController.h"

@interface GYHSRealNameWithIdentifyAuthViewController ()<GYNetRequestDelegate,UITableViewDataSource,UITableViewDelegate,GYHSPostscriptCertificationCellDelegate,GYHSRealNameRegistrationCellDelegate,GYDatePikerDelegate,GYHSValidPeriodDelegate,selectNationalityDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;

@property (nonatomic,copy)NSString *nationaltyRow;//国籍
@property (nonatomic,strong)NSMutableArray *identifyArray;//护照数据源
@property (nonatomic,strong)NSMutableDictionary* dictInside;//传到下一界面的字典
@property (nonatomic,copy)NSString *postscript;//附言
@property (nonatomic,copy)NSString *sexString;
@property (nonatomic,strong)GYDatePiker* datePiker;
@property (nonatomic,copy)NSString* validDate; //有效日期
@property (nonatomic)BOOL islongPeriod;
@property (nonatomic,copy)NSString *countryareaCode;
@end

@implementation GYHSRealNameWithIdentifyAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.islongPeriod = YES;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTextViewButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSPostscriptCertificationCell" bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSValidPeriodCell" bundle:nil] forCellReuseIdentifier:@"GYHSValidPeriodCell"];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kLocalized(@"GYHS_RealName_Next_Step") style:UIBarButtonItemStyleBordered target:self action:@selector(confirm)];
}
#pragma mark --GYHSRealNameRegistrationCellDelegate
- (void)chooseSelectButton:(NSIndexPath*)indexPath
{
    NSArray* arrSex = @[ kLocalized(@"GYHS_RealName_Woman"), kLocalized(@"GYHS_RealName_Man") ];
    if (indexPath.section == 1 && indexPath.row == 1) {
        [UIActionSheet showInView:self.view withTitle:kLocalized(@"GYHS_RealName_Please_Select_Gender") cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:arrSex tapBlock:^(UIActionSheet* _Nonnull actionSheet, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:
                {
                    self.sexString = kLocalized(@"GYHS_RealName_Woman");
                }
                    break;
                case 1:
                {
                    self.sexString = kLocalized(@"GYHS_RealName_Man");
                }
                    break;
                default:
                    break;
            }
            [self.identifyArray[1][1] setObject:self.sexString forKey:@"Value"];
            [self.registrationTableView reloadData];
        }];
    }else if (indexPath.section == 1 && indexPath.row == 0){
        GYCountrySelectionViewController* vcChangeCountry = [[GYCountrySelectionViewController alloc] initWithNibName:@"GYCountrySelectionViewController" bundle:nil];
                    vcChangeCountry.Delegate = self;
                    [self.navigationController pushViewController:vcChangeCountry animated:YES];
    }
}
#pragma mark 返回国家代理方法
- (void)selectNationalityModel:(GYAddressCountryModel*)CountryInfo
{
    self.nationaltyRow = CountryInfo.countryName;
    self.countryareaCode = CountryInfo.countryNo;
    [self.identifyArray[1][0] setObject:self.nationaltyRow forKey:@"Value"];
    [self.registrationTableView reloadData];
}
#pragma mark -- GYHSValidPeriodDelegate
- (void)tfDidBegin:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 &&  indexPath.row ==4) {
        if (!self.datePiker) {
            self.datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:nil];
            self.datePiker.delegate = self;
            [self.datePiker noMaxTime];
            [self.view addSubview:self.datePiker];
            self.datePiker = nil;
        }
    }
    else if (indexPath.section == 1 && indexPath.row == 1){
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
        [self.dictInside setValue:kLocalized(@"GYHS_RealName_Long_Time") forKey:@"validDate"];
        [self.identifyArray[1][4] setObject:[NSNumber numberWithBool:YES] forKey:@"textViewClick"];
    }
    else {
        self.islongPeriod = !self.islongPeriod;
        ValidPeriod.selected = NO;
        [self.identifyArray[1][4] setObject:[NSNumber numberWithBool:NO] forKey:@"textViewClick"];
    }
    [self.registrationTableView reloadData];
}
#pragma mark datepiker 代理方法
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    self.validDate = date;
    [self.identifyArray[1][4] setObject:self.validDate forKey:@"Value"];
    [self.registrationTableView reloadData];
}
#pragma mark --TextView
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.identifyArray[indexPath.section][indexPath.row];
    [dic setObject:value forKey:@"Value"];
}
#pragma mark --GYHSPostscriptCertificationCellDelegate
-(void)inputPostscriptValue:(NSString *)value
{
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
    if (indexPath.section == 2) {
            GYHSPostscriptCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSPostscriptCertificationCell" forIndexPath:indexPath];
            [self setPostscriptCellValues:cell dataDic:dic indexPath:indexPath];
            cell.postscriptDelegate = self;
            return cell;
    }else {
        if (indexPath.section == 1 && indexPath.row == 4) {
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
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
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
- (void)confirm
{
    [self.view endEditing:YES];
    NSString *InputJob   = self.identifyArray[1][3][@"Value"];
    NSString *InputPaperOrganization  = self.identifyArray[1][5][@"Value"];
    NSString *InputRegAddress = self.identifyArray[1][2][@"Value"];
    if (!([self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Man")] || [self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Woman")])) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Gender")];
        return;
    }
    else if ([GYUtils isBlankString:InputJob]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_The_Profession")];
        return;
    }
    else if (InputJob.length < 2 || InputJob.length > 20) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Professional_Name_Cannot_Less_Than_2_Or_More_Than_20_Characters")];
        return;
    }
    if (self.islongPeriod) {
        //不是长期，长期身份证在按钮点击事件设置字段{@"validDate" : @"long_term"}
        [self.dictInside setValue:self.validDate forKey:@"validDate"];
        
        NSString* str = self.validDate;
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate* date = [formatter dateFromString:str];
        NSDate* currentDate = [NSDate date];
        NSDate* earlierDate = [date earlierDate:currentDate];
        
        if ([GYUtils isBlankString:str]) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_Valid")];
            return;
        }
        if (earlierDate == date) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_Valid_Time")];
            return;
        }
    }
    
    if (InputPaperOrganization.length < 2 || InputPaperOrganization.length > 20) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_The_Certificate_Office_Name_Cannot_Less_Than_2_Or_More_Than_128_Characters")];
        return;
    }
    else if (InputRegAddress.length < 2 || InputRegAddress.length > 128) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Census_Register_Address_Not_Less_Than_2_Or_Greater_Than_128_Characters")];
        return;
    }
    if (globalData.loginModel.resNo.length)
        [self.dictInside setValue:globalData.loginModel.resNo forKey:@"perResNo"];
    if (globalData.loginModel.custId.length)
        [self.dictInside setValue:globalData.loginModel.custId forKey:@"perCustId"];
    if (globalData.loginModel.custName.length)
        [self.dictInside setValue:globalData.loginModel.custName forKey:@"name"];
    if ([self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Man")]) {
        
        [self.dictInside setValue:kSexMan forKey:@"sex"];
    }
    else {
        [self.dictInside setValue:kSexWoman forKey:@"sex"];
    }
    if (self.countryareaCode.length)
        [self.dictInside setValue:self.countryareaCode forKey:@"countryNO"];
    [self.dictInside setValue:InputRegAddress forKey:@"birthAddr"];
    [self.dictInside setValue:InputPaperOrganization forKey:@"licenceIssuing"];
    [self.dictInside setValue:globalData.loginModel.creType forKey:@"certype"];
    [self.dictInside setValue:globalData.loginModel.creNo forKey:@"credentialsNo"];
    [self.dictInside setValue:InputJob forKey:@"profession"];
    self.postscript = [GYUtils exchangeENCommaToChCommaWithString:self.postscript];
    [self.dictInside setValue:self.postscript forKey:@"postScript"];
    GYRealNameAuthConfirmViewController* vcAuthConfirm = [[GYRealNameAuthConfirmViewController alloc] initWithNibName:@"GYRealNameAuthConfirmViewController" bundle:nil];
    vcAuthConfirm.dictInside = self.dictInside;
    vcAuthConfirm.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    vcAuthConfirm.useType = useForAuth;
    [self.navigationController pushViewController:vcAuthConfirm animated:YES];
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
    [cell LicenceLbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"hs_cell_btn_menu1.png" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
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
-(void)setperiodCellValues:(GYHSValidPeriodCell*)cell
                   dataDic:(NSDictionary*)dataDic
                 indexPath:(NSIndexPath*)indexPath
{
    NSString* name = [dataDic valueForKey:@"Name"];
    NSString* value2 = [dataDic valueForKey:@"Value"];
    NSString* placeHolder = [dataDic valueForKey:@"placeHolder"];
    BOOL showClick = [[dataDic valueForKey:@"textViewClick"] boolValue];
    [cell LbLeftlabelText:name placeholderlbText:placeHolder tftextFieldText:value2 textFieldClick:showClick tag:indexPath];
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
-(NSMutableArray*)identifyArray
{
    if (_identifyArray == nil) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        
        NSArray *valueAry = @[kLocalized(@"GYHS_RealName_User_Name"),
                              [NSString stringWithFormat:@"%@ **", [globalData.loginModel.custName substringToIndex:1]],
                              @"",
                              [NSNumber numberWithBool:NO],
                              [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
       
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"),
                     kLocalized(@"GYHS_RealName_Id_Card"),
                     @"",
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"),
                     [GYUtils encryptIdentityCard:globalData.loginModel.creNo],
                     @"",
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Nationality"),
                     @"",
                     kLocalized(@"GYHS_RealName_Select_Nationality"),
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Sex"),@"",kLocalized(@"GYHS_RealName_Select_Gender"),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Famliy_Reigster_Address"),@"",kLocalized(@"GYHS_RealName_Enter_The_Hukou_Address"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Professional"),@"",kLocalized(@"GYHS_RealName_Input_Job"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Certification_Valid_Date"),@"",kLocalized(@"GYHS_RealName_Enter_The_Period_Of_Validity"),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_License_Issuing_Agencies"),@"",kLocalized(@"GYHS_RealName_Input_License_Issuing_Agencies"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Certification_Of_Ps"),@"",kLocalized(@"GYHS_RealName_Please_Input_Certification_Of_Ps"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _identifyArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _identifyArray;
}
@end
