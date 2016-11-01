//
//  GYRealNameRegistrationViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/8/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYRealNameRegistrationViewController.h"
#import "GYNetRequest.h"
#import "GYHSButtonCell.h"
#import "GYHSTableViewWarmCell.h"
#import "GYHSLabelTextViewButtonCell.h"
#import "GYAddressCountryModel.h"
#import "GYAddressData.h"
#import "GYCountrySelectionViewController.h"
#import "GYCertificationType.h"
#import "GYCertificationTypeViewController.h"
#import "GYHSBindCardInfoVC.h"
#import "GYCashTransfersViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface GYRealNameRegistrationViewController ()<UITableViewDataSource,UITableViewDelegate,GYNetRequestDelegate,GYHSRealNameRegistrationCellDelegate,GYHSButtonCellDelegate,GYSenderTestDataDelegate>
@property (nonatomic,strong)UITableView *registrationTableView;
@property (nonatomic, copy) NSArray* warnArray;//温馨提示数组
@property (nonatomic, copy) NSMutableArray* identifyArray;//身份证数据源 护照数据源
@property (nonatomic, copy) NSMutableArray* businessLicenceArray;//营业执照数据源
@property (nonatomic, copy) NSMutableArray* dataArray;//临时数据源
@property (nonatomic, copy) NSString* creTypeString;
//当前选中的证件类型索引
@property (nonatomic, assign) NSInteger currentCertificationTypeIndex; //0:身份证 1：护照 2：营业执照
@property (nonatomic,copy)NSString *certificationType;//证件类型
@property (nonatomic,copy)NSString *countryareaCode;
@property (nonatomic,copy)NSString *realNameStr;
@property (nonatomic,copy)NSString *nationaltyRow;//国籍  注册地址行
@property (nonatomic,copy)NSString *certificationNumberRow;//证件号码
@property (nonatomic, assign)CGFloat textViewheight;//文本高度
@end

@implementation GYRealNameRegistrationViewController
#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_RealName_Register");
    self.creTypeString = kCertypeIdentify; //@"1"：身份证
    self.currentCertificationTypeIndex = [self.creTypeString integerValue] - 1; //0:身份证
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSLabelTextViewButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSLabelTextViewButtonCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSTableViewWarmCell" bundle:nil] forCellReuseIdentifier:@"GYHSTableViewWarmCell"];
    [self.registrationTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        [self get_RealName_Info];//查询实名注册详情
        self.registrationTableView.scrollEnabled = NO;
    }
    else {
        self.certificationType =  kLocalized(@"GYHS_RealName_Id_Card");
    }
    [self.dataArray addObjectsFromArray:[self getDataAry]];
}

#pragma mark -- 网络请求GYNetRequestDelegate
- (void)get_RealName_Info
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kQueryRegisterRealNameUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag = 0;
    [request start];
    [GYGIFHUD show];
}
#pragma mark -- 提交实名注册
-(void)loadDataFromNetwork
{
    NSDictionary* allFixParas = @{
                                  @"realName" : kSaftToNSString(self.realNameStr),
                                  @"certype" : kSaftToNSString(self.creTypeString),
                                  @"cerNo" : kSaftToNSString(self.certificationNumberRow)
                                  };
    
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    if ([self.creTypeString isEqualToString:@"3"]) {
        [allParas setValue:kSaftToNSString(self.realNameStr) forKey:@"entName"];
       
    }
    [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:self URLString:kPushRegisterRealNameUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    request.tag =1;
    [request start];
    [GYGIFHUD show];
}
-(void)netRequest:(GYNetRequest *)request didSuccessWithData:(NSDictionary *)responseObject
{
    [GYGIFHUD dismiss];
     NSDictionary *dataDic = responseObject[@"data"];
    if (request.tag == 0) {
        if (dataDic && dataDic.count) {
            [self.dataArray removeAllObjects];
            globalData.loginModel.creNo = kSaftToNSString(dataDic[@"cerNo"]);
            globalData.loginModel.creType = kSaftToNSString(dataDic[@"certype"]);
            globalData.loginModel.custName = kSaftToNSString(dataDic[@"realName"]);
            self.countryareaCode = kSaftToNSString(dataDic[@"countryCode"]);
            self.creTypeString = kSaftToNSString(dataDic[@"certype"]);
            NSString *strName;
            if (globalData.loginModel.custName.length <= 0) {
                strName = [NSString stringWithFormat:@"%@ ** ", globalData.loginModel.custName];
            }
            else {
                strName = [NSString stringWithFormat:@"%@ ** ", [globalData.loginModel.custName substringToIndex:1 ]];
            }
            if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
                strName = [NSString stringWithFormat:@"%@", kSaftToNSString(dataDic[@"entName"])];
            }
            //姓名
            self.realNameStr = strName;
            [self.identifyArray[0] setObject:strName forKey:@"Value"];
            [self.businessLicenceArray[0] setObject:strName forKey:@"Value"];
            //证件类型
            if ([globalData.loginModel.creType isEqualToString:kCertypeIdentify]) {
                self.certificationType = kLocalized(@"GYHS_RealName_Id_Card");
            }
            else if ([globalData.loginModel.creType isEqualToString:kCertypePassport]) {
                self.certificationType = kLocalized(@"GYHS_RealName_Passport");
            }
            else if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
                self.certificationType = kLocalized(@"GYHS_RealName_The_Business_License");
            }
            [self.identifyArray[1] setObject:self.certificationType forKey:@"Value"];
            [self.businessLicenceArray[1] setObject:self.certificationType forKey:@"Value"];
            //证件号码
            NSString *numberString = [self setStarMarkCount:globalData.loginModel.creType.integerValue WithCerNumber:globalData.loginModel.creNo];
            self.certificationNumberRow = numberString;
            [self.identifyArray[2] setObject:self.certificationNumberRow forKey:@"Value"];
            [self.businessLicenceArray[2] setObject:self.certificationNumberRow forKey:@"Value"];
            [self.dataArray addObjectsFromArray:[self getDataAry]];
            [self.registrationTableView reloadData];
        }
    }else if (request.tag == 1) {
        globalData.personInfo.creType = self.creTypeString;
        globalData.loginModel.isRealnameAuth = kRealNameStatusHadRes;
        globalData.loginModel.custName = kSaftToNSString(self.realNameStr);
        globalData.loginModel.creType = self.creTypeString;
        globalData.loginModel.creNo = self.certificationNumberRow;
        globalData.loginModel.entRegAddr = self.nationaltyRow;
        NSNotificationCenter *notification = [NSNotificationCenter defaultCenter];
        [notification postNotificationName:@"refreshPersonInfo" object:self];
        [GYUtils showMessage:responseObject[@"msg"] confirm:^{
            for (UIViewController* popVc in self.navigationController.viewControllers) { //如果栈中有就直接回去
                if ([popVc isKindOfClass:[GYHSBindCardInfoVC class]]) {
                    [self.navigationController popToViewController:popVc animated:YES];
                    return;
                }else if([popVc isKindOfClass:[GYCashTransfersViewController class]]) {
                    [self.navigationController popToViewController:popVc animated:YES];
                    return;
                }
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error
{
    [GYGIFHUD dismiss];
    if (request.tag == 0) {
        DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
        [GYUtils parseNetWork:error resultBlock:nil];
    }else if (request.tag == 1){
        [GYUtils parseNetWork:error resultBlock:nil];
    }
}
#pragma mark -- 区分不同国籍的证件号码的眼吗规则
- (NSString*)setStarMarkCount:(NSInteger)type WithCerNumber:(NSString*)number
{
    NSString* cerNumber = @"";
    //身份证
    if (type == 1) {
        cerNumber = [GYUtils encryptIdentityCard:number];
    }
    //护照
    else if (type == 2) {
        cerNumber = [GYUtils encryptPassport:number];
    }
    //营业执照
    else if (type == 3) {
        cerNumber = [GYUtils encryptBusinessLicense:number];
    }
    return cerNumber;
}
#pragma mark --GYHSButtonCellDelegate
- (void)nextBtn
{
    // 检查姓名
    NSString* name = kSaftToNSString(self.realNameStr);
    NSString* message;
    if ([self.creTypeString isEqualToString:kCertypeBusinessLicence]) {
        if (name.length < 2 || name.length > 64) {
            message = kLocalized(@"GYHS_RealName_Enterprise_Name_Character_Length_Is_Between_2_To_64_Please_Fill_In_According_To_The_Requirement");
            [GYUtils showMessage:message];
            return;
        }
    }
    else {
        if (name.length < 2 || name.length > 20) {
            message = kLocalized(@"GYHS_RealName_Name_Character_Length_Between_2_To_20_Please_Fill_According_The_Requirement");
            [GYUtils showMessage:message];
            return;
        }
        if (![GYUtils isUserName:name]) {
            NSString* message = kLocalized(@"GYHS_RealName_The_Name_Format_Wrong_Please_Fill_According_To_The_Requirements");
            if ([self.creTypeString isEqualToString:kCertypeBusinessLicence])
                message = kLocalized(@"GYHS_RealName_An_Enterprise_Name_Format_Wrong_Please_Fill_According_To_Requirements");
            [GYUtils showMessage:message];
            return;
        }
    }
    if ([GYUtils isBlankString:self.certificationNumberRow]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Select_Card_Type")];
        return;
    }
    // 营业执照为30位
    if ([self.creTypeString isEqualToString:kCertypeBusinessLicence]) {
        if (self.certificationNumberRow.length > 30 || self.certificationNumberRow.length < 7) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Business_License_Of_Input_Errors")];
            return;
        }
    }
    else if ([self.creTypeString isEqualToString:kCertypePassport]) {
        if (![GYUtils isPassportNo:self.certificationNumberRow]) {
            [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_The_Correct_Passport")];
            return;
            return;
        }
    }
    // 添加身份证验证
    else if (![GYUtils verifyIDCardNumber:self.certificationNumberRow country:self.nationaltyRow]) {
        [GYUtils showMessage:kLocalized(@"GYHS_RealName_Please_Enter_The_Correct_Id_Number")];
        return;
    }
 
    [GYUtils showMessge:kLocalized(@"GYHS_RealName_Please_Check_Real_Name_Registration_Information_Accurate_Data_Will_Not_Able_Change_After_Submitted") confirm:^{
    [self loadDataFromNetwork];
    } cancleBlock:^{
        
    }];
}
#pragma mark --GYHSRealNameRegistrationCellDelegate
-(void)chooseSelectButton:(NSIndexPath *)indexPath
{
    GYCertificationTypeViewController* vcTest = [[GYCertificationTypeViewController alloc] initWithNibName:@"GYCertificationTypeViewController" bundle:nil];
    vcTest.selectIndex = self.currentCertificationTypeIndex;
    vcTest.delegate = self;
    [self.navigationController pushViewController:vcTest animated:YES];
}

#pragma mark 选择证件类型代理方法。
- (void)sendSelectDataWithMod:(GYCertificationType*)model
{
    [self.dataArray removeAllObjects];
    self.certificationType = model.strCretype;
    self.creTypeString = model.strCretIdstring;
    self.currentCertificationTypeIndex = model.selectIndex;
    [self.dataArray addObjectsFromArray:[self getDataAry]];
    [self.registrationTableView reloadData];
}
#pragma mark --TextView
-(void)inputRealNameValue:(NSString *)value indexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *tmpDic = nil;
    if (self.dataArray.count > indexPath.row) {
        tmpDic = self.dataArray[indexPath.row];
    }
    if (indexPath.row == 0) {
        self.realNameStr = value;
    }
    if (indexPath.row == 2){
        self.certificationNumberRow =value;
    }
    [tmpDic setObject:value forKey:@"Value"];
}
#pragma mark -- UItableView代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        return 1;
    }
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
         return   self.identifyArray.count;
    }else {
        if (section == 0) {
            return self.identifyArray.count;
        }else if (section == 1)
        {
            return self.warnArray.count;
        }
        return 1;
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYHSLabelTextViewButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLabelTextViewButtonCell" forIndexPath:indexPath];
       NSMutableDictionary* dic = nil;
        if (self.dataArray.count > indexPath.row) {
            dic = self.dataArray[indexPath.row];
        }
        if (indexPath.row == 1)
        {
            [dic setObject:kSaftToNSString(self.certificationType) forKey:@"Value"];
        }

        if (indexPath.row > [self.dataArray count]) {
            return nil;
        }
        [self setCellValues:cell dataDic:dic indexPath:indexPath];
         return cell;
    }
    if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes])
    {
        return nil;
    }else{
        if (indexPath.section == 1)
        {
            GYHSTableViewWarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSTableViewWarmCell" forIndexPath:indexPath];
            cell.backgroundColor = kDefaultVCBackgroundColor;
            if (indexPath.row == 0) {
                cell.redImage.hidden = YES;
                cell.labelspacing.constant = -10;
            }
            if (self.warnArray.count > indexPath.row) {
                cell.label.text = self.warnArray[indexPath.row];
            }
            cell.label.lineBreakMode = NSLineBreakByWordWrapping;
            [cell.label setTextColor:kCellItemTextColor];
            cell.label.numberOfLines = 0;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            GYHSButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell" forIndexPath:indexPath];
            [cell.btnTitle setTitle:kLocalized(@"GYHS_RealName_Register_Rightnow") forState:UIControlStateNormal];
            cell.btnDelegate  = self;
            return cell;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (![globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]){
            if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence] && indexPath.row == 0 ) {
                return self.textViewheight+28;
            }
            return 44;
        }
        return 44;
    }else if (indexPath.section == 1) {
        return 36;
    }else {
        return 50;
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
    [cell LbLeftlabel:name tfTextView:value2 Lbplaceholder:placeHolder setBackgroundImageSelectButton:@"hs_cell_btn_right_arrow.png" tag:indexPath showSelectButton:showSmsBtn textViewClick:showtextViewClick];
    CGRect rect = [value2 boundingRectWithSize:CGSizeMake(kScreenWidth-129, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
   
    self.textViewheight = rect.size.height;
    cell.realNameDelegate = self;
}

- (NSMutableArray*)getDataAry
{
    if ([self.creTypeString isEqualToString:kCertypeBusinessLicence] ) {
        [self.dataArray addObjectsFromArray:self.businessLicenceArray];
    }
    else {
        [self.dataArray addObjectsFromArray:self.identifyArray];
    }
    return  self.dataArray;
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
-(NSMutableArray*)identifyArray
{
    if (_identifyArray == nil) {
        _identifyArray = [[NSMutableArray alloc] init];
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSArray *valueAry = @[kLocalized(@"GYHS_RealName_User_Name"), kSaftToNSString(self.realNameStr),kLocalized(@"GYHS_RealName_Input_Receive_Name"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [_identifyArray addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"), @"", kSaftToNSString(self.certificationType),[NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO]];
        [_identifyArray addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Number"), kSaftToNSString(self.certificationNumberRow), kLocalized(@"GYHS_RealName_Input_Papers_Number"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [_identifyArray addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
    }
    return _identifyArray;
}

-(NSMutableArray*)businessLicenceArray
{
    if (_businessLicenceArray == nil) {
        _businessLicenceArray = [[NSMutableArray alloc] init];
        NSArray *keyAry = @[@"Name", @"Value", @"placeHolder",@"showSmsBtn",@"textViewClick"];
        NSArray *valueAry = @[kLocalized(@"GYHS_RealName_An_Enterprise_Name"), @"", kLocalized(@"GYHS_RealName_Enter_Company_Name"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [_businessLicenceArray addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Type"),kSaftToNSString(self.certificationType),@"", [NSNumber numberWithBool:YES],[NSNumber numberWithBool:NO]];
        [_businessLicenceArray addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
        valueAry = @[kLocalized(@"GYHS_RealName_Papers_Number"), @"", kLocalized(@"GYHS_RealName_Input_Papers_Number"),[NSNumber numberWithBool:NO],[NSNumber numberWithBool:YES]];
        [_businessLicenceArray addObject:[GYUtils valueArray:valueAry keyArray:keyAry]];
        
    }
    return _businessLicenceArray;
}
-(NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray  = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSArray*)warnArray
{
    if (!_warnArray) {
        _warnArray =  @[kLocalized(@"GYHS_RealName_Well_Tip"),
                        kLocalized(@"GYHS_RealName_Registration_Content_One"),
                        kLocalized(@"GYHS_RealName_Registration_Content_Two"),
                        kLocalized(@"GYHS_RealName_Registration_Content_Three"),
                        kLocalized(@"GYHS_RealName_Registration_Content_Four"),
                    kLocalized(@"GYHS_RealName_After_The_Success_Of_The_Real_Rame_Registration_Consumption_Integral_And_Integral_Investment_May_As_Integral_Welfare_Statistical_Sategory")];
    }
    return _warnArray;
}
@end
