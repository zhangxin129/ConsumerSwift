//
//  GYHSHealthPlanViewController.m
//
//  Created by lizp on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSHealthPlanViewCellTag 800

#import "GYHSHealthPlanViewController.h"
#import "YYKit.h"
#import "GYHSHealthPlanViewCell.h"
#import "GYDatePiker.h"
#import "GYHSHealthUploadImgViewController.h"
#import "GYHSMedicalInstructionViewController.h"
#import "IQKeyboardManager.h"
#import "GYHSTools.h"


@interface GYHSHealthPlanViewController ()<UITableViewDataSource,UITableViewDelegate,GYDatePikerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *dataSource;//数据源
@property (nonatomic,strong) UIButton *instructionsBtn;//互生医疗补贴计划说明
@property (nonatomic,strong) UIButton *nextStep;//下一步
@property (nonatomic,strong) GYDatePiker *picker;//日期
@property (nonatomic,strong) NSDate *startDate;//起始时间
@property (nonatomic,strong) NSDate *endDate;//结束时间
@property (nonatomic,assign) BOOL isStart;//是否选择开始时间
@property (nonatomic,strong) NSDate *effectDate;// 生效时间、失效时间
@property (nonatomic,assign) BOOL isCanCommit;//是否可以提交
@property (nonatomic,copy) NSString *errorMsg;//提示语
@property (nonatomic,copy) NSString *tipType;//提示语类型 0.用户没有申请福利资格  1.具备资格 3.企业类型


@end

@implementation GYHSHealthPlanViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate   
#pragma mark - GYDatePikerDelegate
- (void)getDate:(NSString*)date WithDate:(NSDate*)date1 {

    NSIndexPath *indexPath ;
    GYHSHealthPlanViewCell *cell;
    if (self.isStart) {
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextField.text = date;
        self.startDate = date1;
    }
    else {
        indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.detailTextField.text = date;
        self.endDate = date1;
    }
}

#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(section == 0) {
        return 3;
    }
    
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSHealthPlanViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:kGYHSHealthPlanViewCellIdentifier];
    if(!cell) {
        cell = [[GYHSHealthPlanViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSHealthPlanViewCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section *3 + indexPath.row == 1 || indexPath.section *3 + indexPath.row == 2) {
        cell.arrowBtn.hidden = NO;
        cell.detailTextField.enabled = NO;
        cell.detailTextField.frame = CGRectMake(130, 0, kScreenWidth - 130 -40, 39);
    }else {
        cell.arrowBtn.hidden = YES;
        cell.detailTextField.enabled = YES;
        cell.detailTextField.frame = CGRectMake(130, 0, kScreenWidth - 130 -15, 39);
    }
    
    if(indexPath.section *3 + indexPath.row == 0) {
        cell.detailTextField.keyboardType = UIKeyboardTypeNumberPad;
        [cell.detailTextField addTarget:self action:@selector(detailTextFieldEdtingChange:) forControlEvents:UIControlEventEditingChanged];
    }else {
        cell.detailTextField.keyboardType = UIKeyboardTypeDefault;
    }
    
    cell.tag = indexPath.section *3 + indexPath.row +kGYHSHealthPlanViewCellTag;
    [cell.arrowBtn addTarget:self action:@selector(arrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary *dict = self.dataSource[indexPath.section *3 + indexPath.row];
    [cell refreshTitle:dict[@"title"] placeholder:dict[@"placeholder"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 39;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if(section == 0) {
       return 10;
    }
   
    return 0.1f;
}

// #pragma mark - CustomDelegate
#pragma mark - event response  
//网络请求数据
-(void)loadNetWorkForHealthPlan {

    GlobalData* global = globalData;
    NSDictionary* allParas = @{ @"resNo" : kSaftToNSString(global.loginModel.resNo),
                                @"applyType" : @"1" //applyType：0，后台验证实名认证，实名注册、1，后台只验证实名注册
                                };
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlFindWelfareQualify parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            NSDictionary *serverDic = responseObject[@"data"];
            if ([GYUtils checkDictionaryInvalid:serverDic]) {
                DDLogDebug(@"Failed, serverDic:%@", serverDic);
                [GYUtils showMessage:kLocalized(@"GYHS_BP_Query_Qualification_Information_Failure")];
                return;
            }
            
            NSString *strEffectDate = [serverDic valueForKey:@"effectDate"];
            if (![GYUtils checkStringInvalid:strEffectDate]) {
                self.effectDate = [GYUtils dateFromeString:strEffectDate formate:@"yyyy-MM-dd HH:mm:ss"];
            }
            
            
            NSString *welfareType = [NSString stringWithFormat:@"%@", [serverDic valueForKey:@"welfareType"]];
            
            // 积分类型是意外伤害，后不允许申请
            if (![GYUtils checkStringInvalid:welfareType] &&
                ([welfareType integerValue] == 0)) {
                self.isCanCommit = NO;
                self.errorMsg = kLocalized(@"GYHS_BP_User_Not_Have_Apply_Welfare");
                self.tipType = @"0";
            }
            else {
                NSString *isvalid = [NSString stringWithFormat:@"%@", [serverDic valueForKey:@"isvalid"]];
                
                if (![GYUtils checkStringInvalid:isvalid] && ([isvalid integerValue] == 1)) {
                    self.isCanCommit = YES;
                    self.tipType = @"1";
                }
                else if ([globalData.loginModel.creType isEqualToString:@"3"]) {
                    self.isCanCommit = NO;
                    self.errorMsg = kLocalized(@"GYHS_BP_Points_Card_Registered_Type_Enterprise_Not_Enjoy_Consumer_Welfare");
                    self.tipType = @"3";
                } else if (![GYUtils checkStringInvalid:isvalid] && ([isvalid integerValue] == 0)) {
                    self.isCanCommit = NO;
                    self.errorMsg = kLocalized(@"GYHS_BP_User_Not_Have_Apply_Welfare");
                    self.tipType = @"0";
                }
            }
            
            self.tableView.tableFooterView = [self addFooterView];
        }
    }];
    [request setValue:global.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

//限制医保卡号长度
-(void)detailTextFieldEdtingChange:(UITextField *)textField {

    UIView *view = textField.superview;
    if(view.tag - kGYHSHealthPlanViewCellTag == 0) {
        if(textField.text.length >= 20) {
            textField.text = [textField.text substringToIndex:20];
            [textField endEditing:YES];
        }
    }
}

//互生医疗补贴计划说明 事件
-(void)instructionsBtnClick {

    GYHSMedicalInstructionViewController* vcInstruction = [[GYHSMedicalInstructionViewController alloc] init];
    vcInstruction.title = kLocalized(@"GYHS_BP_Free_Medical_Program_Instructions");
    
    vcInstruction.strTitle = kLocalized(@"GYHS_BP_Free_Medical_Program_Instructions");
    vcInstruction.strContent = kLocalized(@"GYHS_BP_That_Free_Medical_Care_Plan");
    vcInstruction.strNote = kLocalized(@"GYHS_BP_Note");
    [self.navigationController pushViewController:vcInstruction animated:YES];
}

//下一步
-(void)nextStepClick {

    [self.view endEditing:YES];
    
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
    
    if (!self.isCanCommit) {
        [GYUtils showToast:self.errorMsg];
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    GYHSHealthPlanViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *medical = cell.detailTextField.text;
    
    indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *startTime = cell.detailTextField.text;
    
    indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *endTime = cell.detailTextField.text;
    
    indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *city = cell.detailTextField.text;

    indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *hospital = cell.detailTextField.text;

    

    
    if([GYUtils checkStringInvalid:startTime]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Select_Diagnosis_And_Start_Date")];
        return;
    }
    
    if([GYUtils checkStringInvalid:endTime]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Select_Diagnosis_And_End_Date")];
        return;
    }
    
    if([GYUtils checkStringInvalid:city]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Enter_The_City")];
        return;
    }
    
    if([GYUtils checkStringInvalid:hospital]) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Enter_The_Hospital")];
        return;
    }
    
    
    if ((medical.length < 6 || medical.length > 20) && medical.length != 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Please_Enter_The_6_To_20_Health_Care_Card_Number")];
        return;
    }
  
    
    // 结束日期不能早于开始日期
    int a = [self compareOneDay:self.endDate withAnotherDay:self.startDate];
    if (a < 0) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Diagnosis_And_End_Date_Must_Be_Greater_Than_Diagnosis_And_Start_Date")];
        return;
    }
    
    // 开始时间不能早于保障生效时间
    a = [self compareOneDay:self.startDate withAnotherDay:self.effectDate];
    if (a < 0) {
        NSString* strEffectDate = [GYUtils dateToString:self.effectDate dateFormat:@"yyyy-MM-dd"];
        NSString* msg = [NSString stringWithFormat:@"%@%@",kLocalized(@"GYHS_BP_Start_Time_Can't_Earlier_Than_To_Ensure_Effective_Time_Time_For\n_To_Take_Effect"), strEffectDate];
        [GYUtils showMessage:msg];
        return;
    }

    
    if ([startTime compare:endTime] == NSOrderedDescending) {
        [self setAlertViewWithMessage:kLocalized(@"GYHS_BP_Input_Correct_Date")];
        return;
    }
    
    if (hospital.length < 2 && hospital.length > 64) {
        [GYUtils showToast:kLocalized(@"GYHS_BP_The_Hospital_Length_Not_Less_Than_Two_Chinese_Characters_Please_Enter_Again")];
        return;
    }
    
    NSDictionary* dictInfo = @{ @"healthCardNo" : kSaftToNSString(medical),
                                @"startDate" : kSaftToNSString(startTime),
                                @"endDate" : kSaftToNSString(endTime),
                                @"hospital" : kSaftToNSString(hospital),
                                @"city" : kSaftToNSString(city) };
    
    GYHSHealthUploadImgViewController* vcDetial = [[GYHSHealthUploadImgViewController alloc] init];
    vcDetial.dictBaseInfo = dictInfo;
    vcDetial.healthCardNo = kSaftToNSString(medical);
    vcDetial.title = self.title;
    
    [self.navigationController pushViewController:vcDetial animated:YES];
}

//右边箭头点击
-(void)arrowBtnClick:(UIButton *)sender {

    UIView *view = sender.superview;
    NSDate *date;
    if(view.tag - kGYHSHealthPlanViewCellTag == 1) {
        self.isStart = YES;
        if (self.startDate) {
            date = self.startDate;
        }else {
            date = [NSDate date];
        }
    }else if (view.tag - kGYHSHealthPlanViewCellTag == 2) {
        self.isStart = NO;
        if (self.endDate) {
            date = self.endDate;
        }else {
            date = [NSDate date];
        }
    }
    
    if (!self.picker) {
        self.picker = [[GYDatePiker alloc] initWithFrame:CGRectMake(0, kScreenHeight/4, kScreenWidth, 200) date:date];
        self.picker.delegate = self;
        [self.view addSubview:self.picker];
        self.picker = nil;
    }

}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"GYHS_BP_Health_Benefits");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);

    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    self.isCanCommit = NO;
    self.errorMsg = kLocalized(@"GYHS_BP_User_Not_Have_Apply_Welfare");
    
    [self loadNetWorkForHealthPlan];
}

//头部
-(UIView *)addHeaderView {

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 37)];
    
    self.instructionsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.instructionsBtn.frame = CGRectMake(15, 8, 120, 21);
    self.instructionsBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.instructionsBtn setTitle:kLocalized(@"GYHS_BP_Alternate_Medical_Subsidy_Program_Instructions") forState:UIControlStateNormal];
    self.instructionsBtn.titleLabel.font = [UIFont systemFontOfSize:11];//字体不做宏定义
    [self.instructionsBtn setTitleColor:UIColorFromRGB(0xef4136) forState:UIControlStateNormal];
    [self.instructionsBtn addTarget:self action:@selector(instructionsBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.instructionsBtn];
    
    return headerView;
}

//尾部
-(UIView *)addFooterView {
    
    CGFloat leftEdge = 15;
    CGFloat topEdge = 16;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = kDefaultVCBackgroundColor;
    self.nextStep = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextStep.frame = CGRectMake(leftEdge, topEdge, kScreenWidth -2*leftEdge, 41);
    [self.nextStep setTitle:kLocalized(@"GYHS_BP_Next_Step") forState:UIControlStateNormal];
    [self.nextStep setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    self.nextStep.backgroundColor = UIColorFromRGB(0x1d7dd6);
    self.nextStep.layer.cornerRadius = 21.5;
    self.nextStep.clipsToBounds = YES;
    [self.nextStep addTarget:self action:@selector(nextStepClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:self.nextStep];
    
#pragma mark - 判断是否已经获得资格
    UIView *infoView;
    if([self.tipType isEqualToString:@"0"]) {
        infoView = [self tipInfoViewNoQualification];
    }else if ([self.tipType isEqualToString:@"1"]) {
        infoView = [self tipInfoViewQualification];
    }else if ([self.tipType isEqualToString:@"3"]) {
        infoView = [self tipInfoViewCompanyType];
    }
    
    infoView.frame = CGRectMake(0, self.nextStep.bottom , infoView.frame.size.width, infoView.frame.size.height);
    [footerView addSubview:infoView];
    
    footerView.frame = CGRectMake(0, 0, kScreenWidth, infoView.bottom);
    
    return footerView;
}

//温馨提示  未获得资格
-(UIView *)tipInfoViewNoQualification {
    
    CGFloat leftEdge = 15;
    CGFloat topEdge = 16;
    CGFloat textHeight = 11;
    CGSize size;
    
    UIFont *font = kHealthPlanFont;
    UIColor *color = UIColorFromRGB(0x666666);
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    //温馨提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge, topEdge, 160, textHeight)];
    tipLabel.font = font;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = color;
    tipLabel.text = kLocalized(@"GYHS_MyAccounts_WellTip");
    [tipView addSubview:tipLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge + 7 +5, tipLabel.bottom +topEdge, kScreenWidth - 2*leftEdge -7-5, textHeight)];
    infoLabel.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_Health_Benefits_Long_AttributedText") textHeight:textHeight color:color font:font];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.numberOfLines = 0;
    [tipView addSubview:infoLabel];
    

    
    //小圆点
    UIView *round1 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2, 7, 7)];
    round1.layer.cornerRadius = 3.5;
    round1.clipsToBounds = YES;
    round1.backgroundColor = [UIColor redColor];
    [tipView addSubview:round1];
   
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_You_Do_Not_Get_Platform_Of_Alternate_Medical_Subsidies") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round2 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height, 7, 7)];
    round2.layer.cornerRadius = 3.5;
    round2.clipsToBounds = YES;
    round2.backgroundColor = [UIColor redColor];
    [tipView addSubview:round2];

    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_10000_Score_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round3 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height +textHeight, 7, 7)];
    round3.layer.cornerRadius = 3.5;
    round3.clipsToBounds = YES;
    round3.backgroundColor = [UIColor redColor];
    [tipView addSubview:round3];
    
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_The_Cumulative_Category_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round4 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height +textHeight, 7, 7)];
    round4.layer.cornerRadius = 3.5;
    round4.clipsToBounds = YES;
    round4.backgroundColor = [UIColor redColor];
    [tipView addSubview:round4];
    
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_Company_Type_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round5 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height +textHeight, 7, 7)];
    round5.layer.cornerRadius = 3.5;
    round5.clipsToBounds = YES;
    round5.backgroundColor = [UIColor redColor];
    [tipView addSubview:round5];
    
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_Health_Benefits_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    
    infoLabel.frame = CGRectMake(leftEdge + 7 +5, tipLabel.bottom +topEdge, kScreenWidth - 2*leftEdge -7-5, size.height);
    tipView.frame = CGRectMake(0, tipView.bounds.origin.y, kScreenWidth, infoLabel.bottom);
    
    return tipView;
}


//温馨提示  有资格
-(UIView *)tipInfoViewQualification {
    
    CGFloat leftEdge = 15;
    CGFloat topEdge = 16;
    CGFloat textHeight = 11;
    CGSize size;
    
    UIFont *font = kHealthPlanFont;
    UIColor *color = UIColorFromRGB(0x666666);
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    //温馨提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge, topEdge, 160, textHeight)];
    tipLabel.font = font;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = color;
    tipLabel.text = kLocalized(@"GYHS_MyAccounts_WellTip");
    [tipView addSubview:tipLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge + 7 +5, tipLabel.bottom +topEdge, kScreenWidth - 2*leftEdge -7-5, textHeight)];
    infoLabel.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_The_Legal_Responsibility_Long_AttributedText") textHeight:textHeight color:color font:font];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.numberOfLines = 0;
    [tipView addSubview:infoLabel];
    
    
    
    //小圆点
    UIView *round1 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2, 7, 7)];
    round1.layer.cornerRadius = 3.5;
    round1.clipsToBounds = YES;
    round1.backgroundColor = [UIColor redColor];
    [tipView addSubview:round1];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_Qualification_For_Plan_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round2 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height, 7, 7)];
    round2.layer.cornerRadius = 3.5;
    round2.clipsToBounds = YES;
    round2.backgroundColor = [UIColor redColor];
    [tipView addSubview:round2];
    
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_To_Apply_For_Conditions_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round3 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height +textHeight, 7, 7)];
    round3.layer.cornerRadius = 3.5;
    round3.clipsToBounds = YES;
    round3.backgroundColor = [UIColor redColor];
    [tipView addSubview:round3];
    
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_Issue_Certificate_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    //小圆点
    UIView *round4 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2 +size.height +textHeight, 7, 7)];
    round4.layer.cornerRadius = 3.5;
    round4.clipsToBounds = YES;
    round4.backgroundColor = [UIColor redColor];
    [tipView addSubview:round4];
    
    
    label.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_The_Legal_Responsibility_Long_AttributedText") textHeight:textHeight color:color font:font];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:label];
    
    infoLabel.frame = CGRectMake(leftEdge + 7 +5, tipLabel.bottom +topEdge, kScreenWidth - 2*leftEdge -7-5, size.height);
    tipView.frame = CGRectMake(0, tipView.bounds.origin.y, kScreenWidth, infoLabel.bottom);
    
    return tipView;
}

//温馨提示  企业类型
-(UIView *)tipInfoViewCompanyType {

    CGFloat leftEdge = 15;
    CGFloat topEdge = 16;
    CGFloat textHeight = 11;
    CGSize size;
    
    UIFont *font = kHealthPlanFont;
    UIColor *color = UIColorFromRGB(0x666666);
    
    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    //温馨提示
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge, topEdge, 160, textHeight)];
    tipLabel.font = font;
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.textColor = color;
    tipLabel.text = kLocalized(@"GYHS_MyAccounts_WellTip");
    [tipView addSubview:tipLabel];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge + 7 +5, tipLabel.bottom +topEdge, kScreenWidth - 2*leftEdge -7-5, textHeight)];
    infoLabel.attributedText = [self obtainAttributedWithString:kLocalized(@"GYHS_BP_Points_Card_Registered_Type_Enterprise_Not_Enjoy_Consumer_Welfare") textHeight:textHeight color:color font:font];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.numberOfLines = 0;
    [tipView addSubview:infoLabel];
    
    //小圆点
    UIView *round1 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom +topEdge + 2, 7, 7)];
    round1.layer.cornerRadius = 3.5;
    round1.clipsToBounds = YES;
    round1.backgroundColor = [UIColor redColor];
    [tipView addSubview:round1];
    
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:infoLabel];
    size = [self adaptLabelWithWidth:kScreenWidth - 2*leftEdge -7-5 andLabel:infoLabel];
    infoLabel.frame = CGRectMake(leftEdge + 7 +5, tipLabel.bottom +topEdge, kScreenWidth - 2*leftEdge -7-5, size.height);
    tipView.frame = CGRectMake(0, tipView.bounds.origin.y, kScreenWidth, infoLabel.bottom);
    
    return tipView;
    
}

//日期比较
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

-(NSMutableAttributedString *)obtainAttributedWithString:(NSString *)string textHeight:(CGFloat)textHeight color:(UIColor *)color  font:(UIFont *)font {

    NSMutableAttributedString *infoStr = [[NSMutableAttributedString alloc] initWithString:string];
    infoStr.lineSpacing = textHeight;
    infoStr.color = color;
    infoStr.font = font;
    return infoStr;
}

//创建警告框
- (void)setAlertViewWithMessage:(NSString*)message {
    
    [GYUtils showMessage:message confirm:nil];
}

-(CGSize)adaptLabelWithWidth:(CGFloat)width andLabel:(UILabel *)label {

    label.lineBreakMode = NSLineBreakByWordWrapping;
    return [label sizeThatFits:CGSizeMake(width, CGFLOAT_MAX)];
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight -64-49) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.tableHeaderView = [self addHeaderView];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSArray *)dataSource {

    if(!_dataSource) {
        _dataSource = @[@{@"title":kLocalized(@"GYHS_BP_Medicare_Number"),
                          @"placeholder":kLocalized(@"GYHS_BP_Input_Medicare_Number")
                          },
                        @{@"title":kLocalized(@"GYHS_BP_Medical_Start_Date"),
                          @"placeholder":kLocalized(@"")
                          },
                        @{@"title":kLocalized(@"GYHS_BP_Medical_end_date"),
                          @"placeholder":kLocalized(@"")
                          },
                        @{@"title":kLocalized(@"GYHS_BP_Local_City"),
                          @"placeholder":kLocalized(@"GYHS_BP_Enter_The_City_No")
                          },
                        @{@"title":kLocalized(@"GYHS_BP_Local_Hospital"),
                          @"placeholder":kLocalized(@"GYHS_BP_Input_Hospital")
                          }
                        ];
    }
    return _dataSource;
}

@end
