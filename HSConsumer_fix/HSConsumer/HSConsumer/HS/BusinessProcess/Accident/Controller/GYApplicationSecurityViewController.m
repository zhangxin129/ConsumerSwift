//
//  GYApplicationSecurityViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYApplicationSecurityViewController.h"
#import "GYAccidentPromptTableViewCell.h"
#import "GYVApplyTableViewCell.h"
#import "GYHSButtonCell.h"
#import "GYAccidentInfoController.h"
#import "GYHSLableTextFileTableViewCell.h"
#import "GYNetRequest.h"
#import "GYDiePeopleViewController.h"
#import "GYAccidtMedicalViewController.h"

@interface GYApplicationSecurityViewController ()<UITableViewDelegate,UITableViewDataSource,GYHSButtonCellDelegate,GYHSbtnAccidentInfoShowDelegate,GYHSbtnDieDeletage,GYHSbtnMedicalDeletage,GYNetRequestDelegate,GYHSLableTextFileTableViewCellDeleget>
@property (nonatomic,strong)UITableView *ApplicationSecurityTableView;
@property (nonatomic, assign)CGFloat labelheight;//温馨提示文本高度
@property (nonatomic,assign) NSInteger applyType;// 1为自己申请 0为待他人申请
@property (nonatomic, copy) NSArray* titleArray;//输入框标题
@property (nonatomic, copy) NSArray* titleRequesArray;//输入框占位符
@property (nonatomic, copy) NSDictionary* requestDic;//返回字典
@property (nonatomic,copy)NSString *tipLable;//温馨提示语
@property (nonatomic,copy)NSString * datelb;//保障时间
@property (nonatomic,copy)NSString * tfResNo;//被保障人互生号
@property (nonatomic,copy)NSString * tfName;//被保障人姓名
@property (nonatomic)BOOL isbtnMedical;//选择的业务类型 YES:代他人
@property (nonatomic, assign) BOOL isOK;/**表示是否有300*/

@end

@implementation GYApplicationSecurityViewController
#pragma mark -- The life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tipLable = kLocalized(@"GYHS_BP_Alternate_Accident_Harm_Security_Warm_Prompt_No_Permit");
    self.applyType = 1;
    [self requestData];
    [self.ApplicationSecurityTableView registerNib:[UINib nibWithNibName:@"GYVApplyTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYVApplyTableViewCell"];
    [self.ApplicationSecurityTableView registerNib:[UINib nibWithNibName:@"GYHSButtonCell" bundle:nil] forCellReuseIdentifier:@"GYHSButtonCell"];
    [self.ApplicationSecurityTableView registerNib:[UINib nibWithNibName:@"GYAccidentPromptTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYAccidentPromptTableViewCell"];
    [self.ApplicationSecurityTableView registerNib:[UINib nibWithNibName:@"GYHSLableTextFileTableViewCell" bundle:nil] forCellReuseIdentifier:@"GYHSLableTextFileTableViewCell"];
}
#pragma mark-- 网络请求
- (void)requestData
{
    NSString* strApplyType, *strRes;
    if (self.applyType == 0) {
        if (self.tfResNo.length != 11) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Input_HSNumber_Not_Correct")];
            return;
        }
        strRes = self.tfResNo;
        strApplyType = @"0";
    }
    else {
        strRes = globalData.loginModel.resNo;
        strApplyType = @"1";
    }
    NSDictionary* dict = @{
                           @"resNo" : kSaftToNSString(strRes),
                           @"applyType" : strApplyType //applyType：0，后台验证实名认证，实名注册、1，后台只验证实名注册
                           };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:kUrlFindWelfareQualify parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    self.requestDic = responseObject[@"data"];
    self.tipLable = kLocalized(@"GYHS_BP_Alternate_Accident_Harm_Security_Warm_Prompt_No_Permit");
    
    if (![self.requestDic isKindOfClass:[NSNull class]] && self.requestDic && self.requestDic.count) {
        if ([self.requestDic[@"isvalid"] isEqualToNumber:kreplyNoQualification]) {
            self.isOK = NO;
        }
        else if ([self.requestDic[@"isvalid"] isEqualToNumber:kreplyHaveQualification]) {
            if ([self.requestDic[@"welfareType"] isEqualToNumber:kreplyTypeAccidt]) { //意外伤害
                self.isOK = YES;
                self.tipLable = kLocalized(@"GYHS_BP_Alternate_Accident_Harm_Security_Warm_Prompt");
            }
            else if ([self.requestDic[@"welfareType"] isEqualToNumber:kreplyTypeCare]) { // 免费医疗
                self.tipLable = kLocalized(@"GYHS_BP_Now_You_Have_Enjoying_Alternate_Medical_Subsidy_Scheme_Alternate_Accident_Harm_Ensure_No_Enjoy");
                self.isOK = NO;
            }
        }
        NSString* strStart, *strEnd;
        strStart = [self cutTimeShort:self.requestDic[@"effectDate"]];
        strEnd = [self cutTimeShort:self.requestDic[@"failureDate"]];
        if (!(strEnd == nil || [strEnd isEqualToString:@""])) {
            self.datelb = [NSString stringWithFormat:@"%@%@%@", strStart, kLocalized(@"GYHS_BP_To"), strEnd];
        }
    }
    CGSize size = [GYUtils sizeForString:self.tipLable font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
    self.labelheight = size.height;
    [self.ApplicationSecurityTableView reloadData];
}
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    [GYUtils parseNetWork:error resultBlock:nil];
}
/**时间截取到日*/
- (NSString*)cutTimeShort:(NSString*)str
{
    if (str == nil || [str isEqualToString:@""]) {
        return nil;
    }
    else {
        str = [str substringToIndex:10];
    }
    return str;
}
#pragma mark -- GYHSButtonCellDelegate
- (void)nextBtn //立即申请
{
    if (self.applyType == 1) { // 自己申请 意外伤害
        //判断手机号是否认证
        if (![globalData.loginModel.isAuthMobile isEqualToString:kAuthHad]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Please_Complete_Phone_Number_Binding")];
            return;
        }
        //判断实名注册，实名认证
        if ([GYUtils checkStringInvalid:globalData.loginModel.isRealnameAuth] ||
            [globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_You_Not_Real-name_Registration_Apply_For_Business")];
            return;
        }

        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_You_Not_Real-name_Certification_Can_Not_Apply_For_Business")];
            return;
        }
    }
    else if (self.applyType == 0) { // 代他人申请
        //判断手机号是否认证
        if (![globalData.loginModel.isAuthMobile isEqualToString:kAuthHad]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Please_Complete_Phone_Number_Binding")];
            return;
        }
        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_You_Not_Real-name_Registration_Can't_Give_Others_Die_Security_Application")];
            return;
        }
        if (self.tfResNo.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Please_Enter_Security_People_Alternate_Card_Number")];
            return;
        }
        if (self.tfResNo.length != 11) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Input_HSNumber_Not_Correct")];
            return;
        }
        if ([self.tfResNo isEqualToString:globalData.loginModel.resNo]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Can't_Give_His_Application_Die_Security")];
            return;
        }
        if (self.tfName.length == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_Please_Enter_Security_Person's_Name")];
            return;
        }
        if (![self.tfName isEqualToString:self.requestDic[@"custName"]]) {
            [GYUtils showToast:kLocalized(@"GYHS_BP_HSNumber_And_UserName_Not_Match")];
            return;
        }
    }
    if (!self.isOK) {
        [GYUtils showToast:kLocalized(@"GYHS_BP_The_User_Not_Have_Accident_Harm_Guarantee_Qualification")];
    }
    else {
        [self uploadApplayInfo];
    }
}
- (void)uploadApplayInfo
{
    if (self.applyType == 0) {
        GYDiePeopleViewController* vcDie = [[GYDiePeopleViewController alloc] init];
        vcDie.title = kLocalized(@"GYHS_BP_Apply_For_Death_Benefits");
        ;
        vcDie.dicParams = @{
            @"deathResNo" : kSaftToNSString(self.tfResNo),
            @"diePeopleName" : kSaftToNSString(self.tfName),
            @"applyDate" : kSaftToNSString(self.datelb),
            @"explain" : kSaftToNSString(kLocalized(@"GYHS_BP_Security_Content"))
        };
        [self.nav pushViewController:vcDie animated:YES];
    }
    else if (self.applyType == 1) {
        GYAccidtMedicalViewController* vcMedica = [[GYAccidtMedicalViewController alloc] init];
        vcMedica.title = kLocalized(@"GYHS_BP_Medical_Insurance");
        vcMedica.dicParams = @{
            @"applyDate" : kSaftToNSString(self.datelb),
            @"explain" : kSaftToNSString(kLocalized(@"GYHS_BP_Security_Content"))
        };
        [self.nav pushViewController:vcMedica animated:YES];
    }
    else {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Choose_Application_SecurityType")];
    }
}
#pragma mark-- GYHSbtnDieDeletage
- (void)btnDie // 意外伤害
{
    self.isbtnMedical = NO;
    self.applyType = 1;
    [self.ApplicationSecurityTableView reloadData];
}
#pragma mark-- GYHSbtnMedicalDeletage
- (void)btnMedical //代他人身故
{
    self.isbtnMedical = YES;
    self.applyType = 0;
    [self.ApplicationSecurityTableView reloadData];
}
#pragma mark-- GYHSbtnAccidentInfoShowDelegate
- (void)btnAccidentInfoShow
{
    GYAccidentInfoController* vc = [[GYAccidentInfoController alloc] init];
    [self.nav pushViewController:vc animated:YES];
}
#pragma mark textfield
- (void)textField:(NSString*)string indextPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        self.tfResNo = string;
        [self.view endEditing:YES];
        [self requestData];
        if (string.length >= 11) {
            [self.view endEditing:NO];
            return;
        }
    }
    else {
        self.tfName = string;
    }
}
#pragma mark-- UITableView代理
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isbtnMedical == YES) {
        if (section == 1) {
            return 2;
        }
        return 1;
    }
    else {
        return 1;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (self.isbtnMedical == YES) {
        return 4;
    }
    return 3;
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.isbtnMedical == YES) {
        if (indexPath.section == 0) {
            return 90;
        }
        else if (indexPath.section == 2) {
            return 60;
        }
        else if (indexPath.section == 1) {
            return 50;
        }
        return self.labelheight + 150;
    }
    else {
        if (indexPath.section == 0) {
            return 90;
        }
        else if (indexPath.section == 1) {
            return 60;
        }
        return self.labelheight + 150;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        GYVApplyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYVApplyTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accidentHarmlb.text = kLocalized(@"GYHS_BP_Medical_Insurance");
        cell.btnDieDeletage = self;
        cell.dielb.text = kLocalized(@"GYHS_BP_Apply_For_Death_Benefits");
        cell.btnMedicalDeletage = self;
        return cell;
    }
    if (self.isbtnMedical) {
        if (indexPath.section == 1) {
            GYHSLableTextFileTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSLableTextFileTableViewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.textColor = kCellItemTitleColor;
            cell.titleLabel.font = kGYTitleFont;
            if (self.titleArray.count > indexPath.row) {
                cell.titleLabel.text = self.titleArray[indexPath.row];
            }
            if (self.titleRequesArray.count > indexPath.row) {
                cell.textField.placeholder = self.titleRequesArray[indexPath.row];
            }
            cell.textField.font = kGYTitleFont;
            cell.titlelabelWith.constant = 140;
            cell.indexpath = indexPath;
            cell.textFiledDegelte = self;
            if (indexPath.row == 0) {
                cell.textFiledlength = 11;
            }
            if (indexPath.row ==1) {
                cell.textFiledlength = 20;
                cell.toplinelb.hidden =YES;
                cell.textField.keyboardType = UIKeyboardAppearanceDefault;
            }
            return cell;
        }
        else if (indexPath.section == 2) {
            GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell"];
            [self dequeueReusableButtonCell:cell];
            return cell;
        }
        else {
            GYAccidentPromptTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYAccidentPromptTableViewCell" forIndexPath:indexPath];
            [self dequeueReusableCell:cell];
            return cell;
        }
    }
    else {
        if (indexPath.section == 1) {
            GYHSButtonCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHSButtonCell"];
            [self dequeueReusableButtonCell:cell];
            return cell;
        }
        else {
            GYAccidentPromptTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYAccidentPromptTableViewCell" forIndexPath:indexPath];
            [self dequeueReusableCell:cell];
            return cell;
        }
    }
}
-(void)dequeueReusableCell:(GYAccidentPromptTableViewCell*)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnAccidentInfoShowDelegate = self;
    cell.contentView.backgroundColor = kDefaultVCBackgroundColor;
    if (self.isbtnMedical) {
        cell.tipLable.hidden = YES;
        cell.warmLable.hidden = YES;
        cell.warnImageView.hidden = YES;
        cell.tipLable.text = @"";
    }else {
        cell.tipLable.hidden = NO;
        cell.warmLable.hidden = NO;
        cell.warnImageView.hidden = NO;
        cell.tipLable.text = self.tipLable;
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:cell.tipLable.text];
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5]; //调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [cell.tipLable.text length])];
        cell.tipLable.attributedText = attributedString;
        [cell.tipLable sizeToFit];
    }

}
-(void)dequeueReusableButtonCell:(GYHSButtonCell*)cell
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.btnTitle setTitle:kLocalized(@"GYHS_BP_Now_Apply") forState:UIControlStateNormal];
    [cell.btnTitle setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
    cell.backgroundColor = kDefaultVCBackgroundColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.btnDelegate = self;
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
    [self.view endEditing:YES];
}
#pragma mark -- 懒加载
-(UITableView*)ApplicationSecurityTableView
{
    if (!_ApplicationSecurityTableView) {
        _ApplicationSecurityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44) style:UITableViewStyleGrouped];
        _ApplicationSecurityTableView.delegate = self;
        _ApplicationSecurityTableView.dataSource = self;
        [self.view addSubview:_ApplicationSecurityTableView];
    }
    return _ApplicationSecurityTableView;
}
- (NSArray*)titleArray
{
    if (!_titleArray) {
       _titleArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_BP_By_Security_People_HSNumber"), kLocalized(@"GYHS_BP_By_Safeguard_People's_Name"),  nil];
    }
    return _titleArray;
}
- (NSArray*)titleRequesArray
{
    if (!_titleRequesArray) {
            _titleRequesArray = [[NSArray alloc] initWithObjects:kLocalized(@"GYHS_BP_Alternate_Number_Input_Die_People"), kLocalized(@"GYHS_BP_Die_Name_Input"),  nil];
    }
    return _titleRequesArray;
}
@end