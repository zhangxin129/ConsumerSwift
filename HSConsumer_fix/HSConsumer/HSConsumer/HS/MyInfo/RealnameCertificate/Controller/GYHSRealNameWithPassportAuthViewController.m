//
//  GYHSRealNameWithPassportAuthViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSRealNameWithPassportAuthViewController.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYHSPostscriptCertificationCell.h"
#import "GYRealNameAuthConfirmViewController.h"
#import "UIActionSheet+Blocks.h"
#import "GYDatePiker.h"
#import "GYCountrySelectionViewController.h"

@interface GYHSRealNameWithPassportAuthViewController ()<GYNetRequestDelegate,UITableViewDataSource,UITableViewDelegate,GYHSPostscriptCertificationCellDelegate,GYHSRealNameRegistrationCellDelegate,GYDatePikerDelegate,selectNationalityDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;

@property (nonatomic,copy)NSString *nationaltyRow;//国籍
@property (nonatomic,strong)NSMutableArray *passportArray;//护照数据源
@property (nonatomic,strong)NSMutableDictionary* dictInside;//传到下一界面的字典
@property (nonatomic,copy)NSString *postscript;//附言
@property (nonatomic,copy)NSString *sexString;
@property (nonatomic,strong)GYDatePiker* datePiker;
@property (nonatomic,copy)NSString* validDate; //有效日期
@property (nonatomic,copy)NSString *countryareaCode;
@end

@implementation GYHSRealNameWithPassportAuthViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTextViewButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSPostscriptCertificationCell" bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    //[self loadDataFromNetwork];
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
            [self.passportArray[1][1] setObject:self.sexString forKey:@"Value"];
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
    [self.passportArray[1][0] setObject:self.nationaltyRow forKey:@"Value"];
    [self.registrationTableView reloadData];
}
-(void)textViewDidBeginindexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row ==2) {
        if (!self.datePiker) {
            self.datePiker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:nil];
            self.datePiker.delegate = self;
            [self.datePiker noMaxTime];
            
            [self.view addSubview:self.datePiker];
            self.datePiker = nil;
        }
    }else if (indexPath.section == 1 && indexPath.row ==1) {
        [self chooseSelectButton:nil];
    }
}
#pragma mark datepiker 代理方法
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    self.validDate = date;
    [self.passportArray[1][2] setObject:self.validDate forKey:@"Value"];
    [self.registrationTableView reloadData];
}
#pragma mark --TextView
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = self.passportArray[indexPath.section][indexPath.row];
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
    return self.passportArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.passportArray[section] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    NSMutableDictionary* dic = self.passportArray[indexPath.section][indexPath.row];
    if (indexPath.section == 2) {
        GYHSPostscriptCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSPostscriptCertificationCell" forIndexPath:indexPath];
        [self setPostscriptCellValues:cell dataDic:dic indexPath:indexPath];
        cell.postscriptDelegate = self;
        return cell;
    }else {
        GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
        
        [self setCellValues:cell dataDic:dic indexPath:indexPath];
        cell.realNameDelegate = self;
        return cell;
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
- (void)confirm
{
    [self.view endEditing:YES];
    NSString *InputBirthAddressRow   = self.passportArray[1][3][@"Value"];
    NSString *InputSignUpAddressRow  = self.passportArray[1][4][@"Value"];
    NSString *InputPaperOrganization = self.passportArray[1][5][@"Value"];
    if (!([self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Man")] || [self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Woman")])) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Gender")];
        return;
    }
    if ([GYUtils isBlankString:self.sexString]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Gender")];
        return;
    }
    [self.dictInside setValue:self.validDate forKey:@"validDate"];
    NSString* str = self.validDate;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatter dateFromString:str];
    NSDate* currentDate = [NSDate date];
    NSDate* earlierDate = [date earlierDate:currentDate];
    if ([GYUtils isBlankString:str]) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_A_Valid")];
            return;
    }
    if (earlierDate == date) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_Valid")];
            return;
    }
    if ( InputBirthAddressRow.length < 2 || InputBirthAddressRow.length > 128) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Place_Of_Birth_Length_Should_Be_2_To_128_Words")];
        return;
    }
    
    if (InputSignUpAddressRow.length < 2 || InputSignUpAddressRow.length > 128) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Place_Of_Issue_Length_Should_Be_2_To_128_Words")];
        return;
    }
    if (InputPaperOrganization.length < 2 || InputPaperOrganization.length > 128) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Issuing_Authority_Should_Be_2_To_128_Characters_In_Length")];
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
    
    [self.dictInside setValue:InputPaperOrganization forKey:@"licenceIssuing"];
    [self.dictInside setValue:globalData.loginModel.creType forKey:@"certype"];
    [self.dictInside setValue:globalData.loginModel.creNo forKey:@"credentialsNo"];
    
    [self.dictInside setValue:InputSignUpAddressRow forKey:@"issuePlace"];
    
    self.postscript = [GYUtils exchangeENCommaToChCommaWithString:self.postscript];
    [self.dictInside setValue:self.postscript forKey:@"postScript"];
    [self.dictInside setValue:InputBirthAddressRow forKey:@"birthAddr"];
    
    GYRealNameAuthConfirmViewController* vcAuthConfirm = [[GYRealNameAuthConfirmViewController alloc] initWithNibName:@"GYRealNameAuthConfirmViewController" bundle:nil];
    vcAuthConfirm.dictInside = self.dictInside;
    vcAuthConfirm.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    vcAuthConfirm.useType = useForAuth;
    [self.navigationController pushViewController:vcAuthConfirm animated:YES];
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
-(NSMutableArray*)passportArray
{
    if (_passportArray == nil) {
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
                     kLocalized(@"GYHS_RealName_Passport"),
                     @"",
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Number"),
                     [GYUtils encryptPassport:globalData.loginModel.creNo],
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
        
        valueAry = @[kLocalized(@"GYHS_RealName_Certification_Valid_Date"),@"",kLocalized(@"GYHS_RealName_Enter_The_Period_Of_Validity"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Birthplace"),@"",kLocalized(@"GYHS_RealName_Input_Birthplace"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Issue_Place"),@"",kLocalized(@"GYHS_RealName_Input_Issue_Place"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Issuing_Authority"),@"",kLocalized(@"GYHS_RealName_Input_Issuing_Authority"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:NO]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Certification_Of_Ps"),@"",kLocalized(@"GYHS_RealName_Please_Input_Certification_Of_Ps"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [array3  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _passportArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3, nil];
    }
    return _passportArray;
}
@end
