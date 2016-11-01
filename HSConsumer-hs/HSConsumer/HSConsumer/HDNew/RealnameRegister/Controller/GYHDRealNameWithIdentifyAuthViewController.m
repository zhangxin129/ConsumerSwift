//
//  GYHDRealNameWithIdentifyAuthViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDRealNameWithIdentifyAuthViewController.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYHSPostscriptCertificationCell.h"

#import "UIActionSheet+Blocks.h"
#import "GYDatePiker.h"
#import "GYHSValidPeriodCell.h"
#import "Masonry.h"
#import "GYHSLabelTwoTableViewCell.h"
#import "GYHSTools.h"
#import "GYHSButtonCell.h"
#import "GYHSPopView.h"
#import "GYHDCountrySelectionViewController.h"
#import "GYBaseControlView.h"

@interface GYHDRealNameWithIdentifyAuthViewController ()<GYNetRequestDelegate,UITableViewDataSource,UITableViewDelegate,GYHSPostscriptCertificationCellDelegate,GYHSRealNameRegistrationCellDelegate,GYDatePikerDelegate,GYHSValidPeriodDelegate,selectNationalityDelegate,GYHSButtonCellDelegate>
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

@property (nonatomic,strong)GYHSPopView *pop;
@end

@implementation GYHDRealNameWithIdentifyAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.islongPeriod = YES;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_RealName_Authentication_Authentication");
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTwoTableViewCell class]) bundle:nil] forCellReuseIdentifier: @"GYHSLabelTwoTableViewCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSLabelTextViewButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPostscriptCertificationCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSPostscriptCertificationCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSValidPeriodCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSValidPeriodCell"];
     [self.registrationTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSButtonCell class]) bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
}

#pragma mark --GYHSRealNameRegistrationCellDelegate
- (void)chooseSelectButton:(NSIndexPath*)indexPath
{
   
    if (indexPath.section == 1 && indexPath.row == 0) {
   
        CGRect rectTableView = [self.registrationTableView rectForRowAtIndexPath:indexPath];
        CGRect rect = [self.registrationTableView convertRect:rectTableView toView:[self.registrationTableView superview]];
      
        NSArray* arrSex = @[kLocalized(@"GYHS_RealName_Man"), kLocalized(@"GYHS_RealName_Woman")];
        CGPoint point = CGPointMake(130, rect.origin.y+130);
        GYBaseControlView *pop = [[GYBaseControlView alloc] initWithPoint:point titles:arrSex images:nil width:kScreenWidth - 110 selectName:self.sexString];
        pop.selectRowAtIndex = ^(NSInteger index){
            NSLog(@"select index:%ld", (long)index);
            self.sexString = arrSex[index];
            [self.identifyArray[1][0] setObject:self.sexString forKey:@"Value"];
            [self.registrationTableView reloadData];
        };
        [pop show];
     }else if (indexPath.section == 1 && indexPath.row == 1){
        _pop = [[GYHSPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
         GYHDCountrySelectionViewController* vcChangeCountry = [[GYHDCountrySelectionViewController alloc] init];
         vcChangeCountry.countryName = self.nationaltyRow;
        [_pop showView:vcChangeCountry];
        vcChangeCountry.Delegate = self;
    }
}
#pragma mark 返回国家代理方法
- (void)selectNationalityModel:(GYAddressCountryModel*)CountryInfo
{
    self.nationaltyRow = CountryInfo.countryName;
    self.countryareaCode = CountryInfo.countryNo;
    [self.identifyArray[1][1] setObject:self.nationaltyRow forKey:@"Value"];
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
    else if (indexPath.section == 1 && indexPath.row == 0){
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
    NSMutableDictionary *dic = self.identifyArray[2][0];
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
    if (indexPath.section == 0) {
        GYHSLabelTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTwoTableViewCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.identifyArray[indexPath.section][indexPath.row][@"Name"];
        cell.detLabel.text = self.identifyArray[indexPath.section][indexPath.row][@"Value"];
        cell.detLabel.textAlignment = NSTextAlignmentRight;
        cell.detLabel.font = kButtonCellFont;
        cell.titleLabel.font = kButtonCellFont;
        if (indexPath.row != 0 ) {
            cell.toplb.hidden = YES;
        }
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 4) {
            GYHSValidPeriodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSValidPeriodCell" forIndexPath:indexPath];
            [self setperiodCellValues:cell dataDic:dic indexPath:indexPath];
            cell.periodDelegate = self;
            return cell;
        }else{
            GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
            [self setCellValues:cell dataDic:dic indexPath:indexPath];
            cell.realNameDelegate = self;
            return cell;
        }
    }
    else if (indexPath.section == 2) {
        GYHSPostscriptCertificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSPostscriptCertificationCell" forIndexPath:indexPath];
        [self setPostscriptCellValues:cell dataDic:dic indexPath:indexPath];
        cell.postscriptDelegate = self;
        return cell;
    }else{
        GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
        [cell.btnTitle setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];
        cell.btnTitle.backgroundColor = kButtonCellBtnCorlor;
        cell.btnDelegate  = self;
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        return 200;
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
    if (section == 0 || section  == 1) {
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
- (void)nextBtn
{
    [self.view endEditing:YES];
    NSString *InputJob   = self.identifyArray[1][3][@"Value"];
    NSString *InputPaperOrganization  = self.identifyArray[1][5][@"Value"];
    NSString *InputRegAddress = self.identifyArray[1][2][@"Value"];
    if ([GYUtils isBlankString:self.nationaltyRow]) {
        [GYUtils showMessage:kLocalized(@"GYHD_RealnameRegister_Please_Enter_Nationality")];
    }
    else if (!([self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Man")] || [self.sexString isEqualToString:kLocalized(@"GYHS_RealName_Woman")])) {
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
    if ([_identifyDelegate respondsToSelector:@selector(identifyAuth:)]) {
        [self.identifyDelegate identifyAuth:self.dictInside];
    }    
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
-(NSMutableArray*)identifyArray
{
    if (_identifyArray == nil) {
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSMutableArray *array1 = [[NSMutableArray alloc] init];
        NSMutableArray *array2 = [[NSMutableArray alloc] init];
        NSMutableArray *array3 = [[NSMutableArray alloc] init];
        NSMutableArray *array4 = [[NSMutableArray alloc] init];
        
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
        
        valueAry = @[kLocalized(@"GYHS_MyInfo_Papers_Number"),
                     [GYUtils encryptIdentityCard:globalData.loginModel.creNo],
                     @"",
                     [NSNumber numberWithBool:NO],
                     [NSNumber numberWithBool:YES]];
        [array1 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Sex"),@"",kLocalized(@"GYHS_RealName_Select_Gender"),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:YES]];
        [array2 addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Nationality"),
                     @"",
                     kLocalized(@"GYHS_RealName_Select_Nationality"),
                     [NSNumber numberWithBool:YES],
                     [NSNumber numberWithBool:YES]];
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
        
        valueAry = @[@""];
        [array4  addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        _identifyArray = [[NSMutableArray alloc] initWithObjects:array1,array2,array3,array4, nil];
    }
    return _identifyArray;
}
@end
