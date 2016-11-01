//
//  GYHealthViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHealthViewController.h"
#import "GYInstructionViewController.h"
#import "GYDatePiker.h"

#import "GYHealthUploadImgViewController.h"

@interface GYHealthViewController () <UITextFieldDelegate, GYDatePikerDelegate> {
    IBOutlet UIView* viewTipBkg;
    IBOutlet UIView* viewContentBkg;

    __weak IBOutlet UIScrollView* scvMedical; //scrollView

    __weak IBOutlet UIView* vMedical; //医保行
    __weak IBOutlet UILabel* lbMedical; //医保号标题
    __weak IBOutlet UITextField* tfInputMedical; //输入医保号

    __weak IBOutlet UIView* vMedicalStart; //医疗开始行
    __weak IBOutlet UILabel* lbMedicalStart; //医疗开始标题
    __weak IBOutlet UITextField* tfMedicalStartTime; //开始时间
    __weak IBOutlet UIButton* btnSeleSatrtTime; //选择开始时间按钮

    __weak IBOutlet UIView* vMedicalStop; //医疗结束行
    __weak IBOutlet UILabel* lbMedicalStop; //医疗结束标题
    __weak IBOutlet UITextField* tfMedicalStopTime; //结束时间
    __weak IBOutlet UIButton* btnSeleStopTime; //选择结束时间按钮

    __weak IBOutlet UIView* vCity; //所在城市行
    __weak IBOutlet UILabel* lbCity; //所在城市标题
    __weak IBOutlet UITextField* tfInputCity; //输入所在城市

    __weak IBOutlet UIView* vHospital; //所在医院行
    __weak IBOutlet UILabel* lbHospital; //所在医院标题
    __weak IBOutlet UITextField* tfInputHospital; //输入所在医院

    __weak IBOutlet UIButton* btnInstruction; //说明按钮
    __weak IBOutlet UIButton* btnCommit; //确认按钮

    GYDatePiker* datePicker; //日期选择器
    int btnType; //按钮类型

    __weak IBOutlet UIImageView* imgWarn; //警告图标

    __weak IBOutlet UILabel* lbWarn; //警告文字

    MBProgressHUD* hud; // 网络等待弹窗

    BOOL isCanCommit;
    NSString* errorMsg;

    // 生效时间、失效时间
    NSDate* effectDate;

    // 用户选择的时间
    NSDate* startDate;
    NSDate* endDate;
}
@end

@implementation GYHealthViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //初始化
        btnType = 100;
    }
    return self;
}

//日期选择按钮，两个btn共用一个按钮
- (IBAction)dataPickerClick:(UIButton*)sender
{
    NSDate* date = nil;
    if (sender == btnSeleSatrtTime) {
        btnType = 0;
        date = startDate;
    }
    else {
        btnType = 1;
        date = endDate;
    }

    if (!datePicker) {
        datePicker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, 0, 0, 0) date:date];
        datePicker.delegate = self;
        [self.view addSubview:datePicker];
        datePicker = nil;
    }
}

//免费医疗计划说明按钮
- (IBAction)btnInstructionClick:(UIButton*)sender
{
    GYInstructionViewController* vcInstruction = [[GYInstructionViewController alloc] init];
    vcInstruction.title = kLocalized(@"GYHS_BP_Free_Medical");

    vcInstruction.strTitle = kLocalized(@"GYHS_BP_Free_Medical_Program_Instructions");
    vcInstruction.strContent = kLocalized(@"GYHS_BP_That_Free_Medical_Care_Plan");
    [self.navigationController pushViewController:vcInstruction animated:YES];
}

//确认提交按钮 点击事件
- (IBAction)btnCommitClick:(id)sender
{

    if ([globalData.loginModel.creType isEqualToString:kCertypeBusinessLicence]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Registered_Type_Business_License_Not_Enjoy_Medical_Subsidy_Plan")];
        return;
    }

    if (![globalData.loginModel.isAuthMobile isEqualToString:kAuthHad]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Finish_Binding_Mobile_Phone_Number")];
        return;
    }

    if ([GYUtils checkStringInvalid:globalData.loginModel.isRealnameAuth] ||
        [globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_You_Not_Real-name_Registration_Apply_For_Health_Benefits")];
        return;
    }

    if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes]) {

        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_BP_You_Not_Real-name_Authentication_Apply_For_Health_Benefits") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        return;
    }

    if (!isCanCommit) {
        [GYUtils showToast:errorMsg];
        return;
    }

    if (![GYUtils checkStringInvalid:tfInputMedical.text]) {
        if (tfInputMedical.text.length < 6 || tfInputMedical.text.length > 20) {
            [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Enter_The_6_To_20_Health_Care_Card_Number")];
            return;
        }
    }

    // 结束日期不能早于开始日期
    int a = [self compareOneDay:endDate withAnotherDay:startDate];
    if (a < 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_End_Date_Not_Earlier_Than_Start_Date")];
        return;
    }

    // 开始时间不能早于保障生效时间
    a = [self compareOneDay:startDate withAnotherDay:effectDate];
    if (a < 0) {
        NSString* strEffectDate = [GYUtils dateToString:effectDate dateFormat:@"yyyy-MM-dd"];
        NSString* msg = [NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_BP_Start_Time_Can't_Earlier_Than_To_Ensure_Effective_Time_Time_For\n_To_Take_Effect"), strEffectDate];
        [GYUtils showMessage:msg];
        return;
    }

    if (tfInputCity.text.length == 0 || tfInputHospital.text.length == 0) {
        [self setAlertViewWithMessage:kLocalized(@"GYHS_BP_Please_Enter_Complete_Information")];
        return;
    }

    if ([tfMedicalStartTime.text compare:tfMedicalStopTime.text] == NSOrderedDescending) {
        [self setAlertViewWithMessage:kLocalized(@"GYHS_BP_Input_Correct_Date")];
        return;
    }
    if (tfInputHospital.text.length < 2 && tfInputHospital.text.length > 64) {
        [GYUtils showToast:kLocalized(@"GYHS_BP_The_Hospital_Length_Not_Less_Than_Two_Chinese_Characters_Please_Enter_Again")];
        return;
    }

    NSDictionary* dictInfo = @{ @"healthCardNo" : kSaftToNSString(tfInputMedical.text),
        @"startDate" : kSaftToNSString(tfMedicalStartTime.text),
        @"endDate" : kSaftToNSString(tfMedicalStopTime.text),
        @"hospital" : kSaftToNSString(tfInputHospital.text),
        @"city" : kSaftToNSString(tfInputCity.text) };

    GYHealthUploadImgViewController* vcDetial = [[GYHealthUploadImgViewController alloc] init];
    vcDetial.dictBaseInfo = dictInfo;
    vcDetial.healthCardNo = kSaftToNSString(tfInputMedical.text);
    vcDetial.title = self.title;

    [self.navigationController pushViewController:vcDetial animated:YES];
}

//创建警告框
- (void)setAlertViewWithMessage:(NSString*)message
{
    [GYUtils showMessage:message confirm:nil];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [vMedical addTopBorder];
    [vMedicalStart addTopBorder];
    [vMedicalStart addBottomBorder];
    [vMedicalStop addBottomBorder];
    [vCity addTopBorder];
    [vCity addBottomBorder];
    [vHospital addBottomBorder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //国际化
    self.title = kLocalized(@"GYHS_BP_Health_Benefits");
    lbMedical.text = kLocalized(@"GYHS_BP_Medicare_Number");
    tfInputMedical.placeholder = kLocalized(@"GYHS_BP_Input_Health_Number");
    lbMedicalStart.text = kLocalized(@"GYHS_BP_Medical_Start_Date");

    lbMedicalStop.text = kLocalized(@"GYHS_BP_Medical_end_date");
    lbCity.text = kLocalized(@"GYHS_BP_Local_City");
    tfInputCity.placeholder = kLocalized(@"GYHS_BP_Input_City");
    lbHospital.text = kLocalized(@"GYHS_BP_Local_Hospital");
    tfInputHospital.placeholder = kLocalized(@"GYHS_BP_Input_Hospital");
    [btnInstruction setTitle:[NSString stringWithFormat:@"%@?", kLocalized(@"GYHS_BP_Free_Medical_Program_Instructions")] forState:UIControlStateNormal];
    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    btnCommit.titleLabel.text = kLocalized(@"GYHS_BP_Confirm_To_Submit");
    [btnCommit setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];

    tfMedicalStartTime.delegate = self;
    tfMedicalStopTime.delegate = self;

    isCanCommit = NO;
    errorMsg = kLocalized(@"GYHS_BP_User_Not_Have_Apply_Welfare");

    // 生效、过期的缺省时间
    effectDate = [GYUtils dateFromeString:@"2000-01-01" formate:@"yyyy-MM-dd"];

    viewTipBkg.backgroundColor = kDefaultVCBackgroundColor;
    [self get_person_welf_qualification];
    [tfInputMedical addTarget:self action:@selector(tfInputMedicalEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    tfInputHospital.delegate = self;
}

#pragma mark - GYDatePikerDelegate
//回调函数
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1
{
    if (btnType == 0) {
        tfMedicalStartTime.text = date;
        startDate = date1;
    }
    else {
        tfMedicalStopTime.text = date;
        endDate = date1;
    }
}

- (void)get_person_welf_qualification
{
    GlobalData* global = globalData;
    NSDictionary* allParas = @{ @"resNo" : kSaftToNSString(global.loginModel.resNo),
        @"applyType" : @"1" //applyType：0，后台验证实名认证，实名注册、1，后台只验证实名注册
    };

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlFindWelfareQualify parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *serverDic = responseObject[@"data"];
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"Failed, serverDic:%@", serverDic);
            [GYUtils showMessage:kLocalized(@"GYHS_BP_Query_Qualification_Information_Failure")];
            return;
        }
        
        NSString *strEffectDate = [serverDic valueForKey:@"effectDate"];
        if (![GYUtils checkStringInvalid:strEffectDate]) {
            effectDate = [GYUtils dateFromeString:strEffectDate formate:@"yyyy-MM-dd HH:mm:ss"];
        }
        
        
        NSString *welfareType = [NSString stringWithFormat:@"%@", [serverDic valueForKey:@"welfareType"]];
        
        // 积分类型是意外伤害，后不允许申请
        if (![GYUtils checkStringInvalid:welfareType] &&
            ([welfareType integerValue] == 0)) {
            lbWarn.text = kLocalized(@"GYHS_BP_Didn't_Get_Free_Medical_Subsidy_Program");
            isCanCommit = NO;
            errorMsg = kLocalized(@"GYHS_BP_User_Not_Have_Apply_Welfare");
        }
        else {
            NSString *isvalid = [NSString stringWithFormat:@"%@", [serverDic valueForKey:@"isvalid"]];
            
            if (![GYUtils checkStringInvalid:isvalid] && ([isvalid integerValue] == 1)) {
                isCanCommit = YES;
                lbWarn.text = kLocalized(@"GYHS_BP_Has_Got_The_Certificate_Free_Medical_Treatment_Subsidy_Program");
            }
            else if ([globalData.loginModel.creType isEqualToString:@"3"]) {
                isCanCommit = NO;
                errorMsg = kLocalized(@"GYHS_BP_Points_Card_Registered_Type_Enterprise_Not_Enjoy_Consumer_Welfare");
                lbWarn.text = kLocalized(@"GYHS_BP_Points_Card_Registered_Type_Enterprise_Not_Enjoy_Consumer_Welfare");
            } else if (![GYUtils checkStringInvalid:isvalid] && ([isvalid integerValue] == 0)) {
                isCanCommit = NO;
                errorMsg = kLocalized(@"GYHS_BP_User_Not_Have_Apply_Welfare");
                lbWarn.text = kLocalized(@"GYHS_BP_Didn't_Get_Free_Medical_Subsidy_Program");
            }
        }
        
        [self changeWarningFrame];

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)changeWarningFrame
{
    CGFloat warnY = 345;
    if (btnCommit.hidden == YES) {
        CGFloat margin = viewContentBkg.frame.size.height - btnCommit.frame.origin.y;
        warnY -= margin;
        CGRect frame = imgWarn.frame;
        frame.origin.y -= margin;
        imgWarn.frame = frame;
    }
    lbWarn.frame = CGRectMake(37, warnY, kScreenWidth - 37 - 10, 20);
    CGFloat height = [GYUtils heightForString:lbWarn.text fontSize:13 andWidth:kScreenWidth -40];
    CGRect lbFrame = lbWarn.frame;
    lbFrame.size.height = height ;//+ 120;
    lbWarn.frame = lbFrame;

    CGRect topViewRect = viewTipBkg.frame;
    topViewRect.size.height = 44;
    viewTipBkg.frame = topViewRect;
    CGRect bottomViewRect = viewContentBkg.frame;
    bottomViewRect.origin.y = topViewRect.origin.y + 50;
    viewContentBkg.frame = bottomViewRect;
    scvMedical.contentSize = CGSizeMake(kScreenWidth, lbWarn.frame.size.height + lbWarn.frame.origin.y);
}

- (int)compareOneDay:(NSDate*)oneDay withAnotherDay:(NSDate*)anotherDay
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString* oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString* anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate* dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate* dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    DDLogDebug(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending) {
        return -1;
    }
    
    return 0;
}

//add by zhangqy  医保卡号长度校验
- (void)tfInputMedicalEditingChanged:(UITextField *)textField {
    if (textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == tfInputHospital) {
        if (len > 64) {
            textField.text = [toBeString substringToIndex:64];
            return NO;
        }
    }
    
   
    
    return YES;
}
@end
