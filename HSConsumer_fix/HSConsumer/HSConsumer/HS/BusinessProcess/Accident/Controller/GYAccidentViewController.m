//
//  GYAccidentViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-20.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAccidentViewController.h"
#import "GYDiePeopleViewController.h"
#import "GYAccidentInfoController.h"
#import "GYAccidtMedicalViewController.h"
#import "GYHSLoginManager.h"

@interface GYAccidentViewController () {
    NSInteger applyType; // 1为自己申请 0为待他人申请

    __weak IBOutlet UIScrollView* scvAccident; //scrollView

    __weak IBOutlet UIView* vContent; //保障内容底图
    __weak IBOutlet UILabel* lbContentTitle; //保障内容标题
    __weak IBOutlet UILabel* lbContent; //保障内容
    __weak IBOutlet UILabel* lbTimeTitle; //有效时间标题
    __weak IBOutlet UILabel* lbTime; //有效时间

    __weak IBOutlet UIView* vApply; //申请底图
    __weak IBOutlet UILabel* lbApplyTitle; //申请标题
    __weak IBOutlet UILabel* lbSafeguardTitle; //保障金标题
    __weak IBOutlet UILabel* lbDie; //身故保障金
    __weak IBOutlet UILabel* lbMedical; //医疗保障金

    __weak IBOutlet UILabel* lbExplainTitle; //说明标题
    __weak IBOutlet UILabel* lbExplainContent1; //保障内用第一点
    __weak IBOutlet UILabel* lbExplainContent2; //保障内容第二点

    __weak IBOutlet UIImageView* imgWarn;
    __weak IBOutlet UILabel* lbWarn;

    __weak IBOutlet UIButton* btnApply;

    __weak IBOutlet UITextField* tfResNo;

    __weak IBOutlet UITextField* tfName;

    __weak IBOutlet UIView* vPromit;

    __weak IBOutlet UIView* vTf;
}

@property (weak, nonatomic) IBOutlet UIButton* btnDie;

@property (weak, nonatomic) IBOutlet UIButton* btnMedical;
@property (weak, nonatomic) IBOutlet UIView* vBack;

// 互生意外伤害保障条款”链接
@property (weak, nonatomic) IBOutlet UIButton* btnAccidentInfoShow;
/**表示是否有300*/
@property (nonatomic, assign) BOOL isOK;
@property (nonatomic, copy) NSString* canNotMessage;
@property (nonatomic, copy) NSString* name;

@property (nonatomic, assign) BOOL isfreeMedical;

@end

@implementation GYAccidentViewController

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        applyType = 100;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    //添加边框
    [vContent addAllBorder];
    [vApply addAllBorder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.btnAccidentInfoShow setTitle:kLocalized(@"HSAccidentHarmToSafeguardClause") forState:UIControlStateNormal];
    //国际化
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    self.vBack.backgroundColor = kDefaultVCBackgroundColor;

    self.title = kLocalized(@"accident_harm_security");
    lbContentTitle.text = kLocalized(@"security_content");
    lbContent.text = kLocalized(@"HSSecurityContent");
    lbTimeTitle.text = kLocalized(@"valid_time");
    lbApplyTitle.text = kLocalized(@"apply_for_1");
    lbSafeguardTitle.text = kLocalized(@"security");
    lbDie.text = kLocalized(@"apply_for_death_benefits");
    lbMedical.text = kLocalized(@"apply_for_medical_insurance");
    lbExplainTitle.text = kLocalized(@"security_instruction");

    lbExplainContent1.text = kLocalized(@"HSOneSecurityContent");
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: lbExplainContent1.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lbExplainContent1.text length])];
    lbExplainContent1.attributedText = attributedString;
    [vPromit addSubview:lbExplainContent1];
    [lbExplainContent1 sizeToFit];

    lbExplainContent2.text = kLocalized(@"HSTwoSecurityContent");

    [btnApply setTitle:kLocalized(@"Now_apply") forState:UIControlStateNormal];
    [btnApply setBackgroundImage:[UIImage imageNamed:@"ep_btn_show_order"] forState:UIControlStateNormal];

    btnApply.layer.cornerRadius = 4.0;
    [tfResNo addTarget:self action:@selector(tfResChage) forControlEvents:UIControlEventEditingChanged];

    [self btnMedical:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    NSString* toBeStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == tfResNo) {
        if (toBeStr.length > 11) {
            textField.text = [toBeStr substringToIndex:11];
            return NO;
        }
    }

    return YES;
}

- (void)tfResChage
{

    if (tfResNo.text.length == 11) {
        [self.view endEditing:YES];
        WS(weakSelf);
        [self get_person_welf_qualification:^(NSNumber* welfareType, NSNumber* isvalid) {
            [weakSelf changeFrame:YES];
            [weakSelf showWarnInfo:welfareType isvalid:isvalid];
        }];
    }
}

#pragma mark -  私有方法
//设置边框函数
- (void)setBorderWithView:(UIView*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(CGColorRef)color
{
    view.layer.borderWidth = width;
    view.layer.borderColor = color;
    view.layer.cornerRadius = radius;
}

/**
 *  是否有意外伤害保障金
 *
 *  @parameter  pv  yes：有意外伤害保障金资格  no：没有意外伤害保障金
 */
- (void)showResultViewAndPv:(NSString*)msg
{
    lbWarn.font = [UIFont systemFontOfSize:12];
    imgWarn.frame = CGRectMake(15, CGRectGetMaxY(btnApply.frame) + 20, 15, 13);
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [msg length])];
    lbWarn.attributedText = attributedString;
    [scvAccident addSubview:lbWarn];
    [lbWarn sizeToFit];

    CGSize warnSize = [GYUtils sizeForString:lbWarn.text font:[UIFont systemFontOfSize:12] width:lbWarn.frame.size.width];
    lbWarn.frame = CGRectMake(CGRectGetMaxX(imgWarn.frame) + 10, CGRectGetMaxY(btnApply.frame) + 20, warnSize.width, warnSize.height+70);
    scvAccident.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(lbWarn.frame) + 20);
//    imgWarn.frame = CGRectMake(15, lbWarn.frame.origin.y, 15, 13);
}

- (void)uploadApplayInfo
{

    if (applyType == 0) {
        GYDiePeopleViewController* vcDie = [[GYDiePeopleViewController alloc] init];
        vcDie.title = lbDie.text;

        vcDie.dicParams = @{
            @"deathResNo" : kSaftToNSString(tfResNo.text),
            @"diePeopleName" : kSaftToNSString(tfName.text),
            @"applyDate" : kSaftToNSString(lbTime.text),
            @"explain" : kSaftToNSString(lbContent.text)
        };
        [self.navigationController pushViewController:vcDie animated:YES];
    }
    else if (applyType == 1) {
        GYAccidtMedicalViewController* vcMedica = [[GYAccidtMedicalViewController alloc] init];
        vcMedica.title = kLocalized(@"medical_insurance");

        vcMedica.dicParams = @{
            @"applyDate" : kSaftToNSString(lbTime.text),
            @"explain" : kSaftToNSString(lbContent.text)
        };

        [self.navigationController pushViewController:vcMedica animated:YES];
    }
    else {
        [GYUtils showMessage:kLocalized(@"HSChooseApplicationSecurityType")];
    }
}

- (void)changeFrame:(BOOL)show
{
    if (show) {
        vTf.hidden = NO;
        vPromit.hidden = YES;
        lbWarn.hidden = YES;
        imgWarn.hidden = YES;
        vTf.frame = CGRectMake(0, CGRectGetMaxY(vApply.frame) + 20, self.view.frame.size.width, 88);
        btnApply.frame = CGRectMake(15, CGRectGetMaxY(vTf.frame) + 20, self.view.frame.size.width - 30, 45);
        scvAccident.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(btnApply.frame) + 30);
    }
    else {
        vTf.hidden = YES;
        vPromit.hidden = NO;
        lbWarn.hidden = NO;
        imgWarn.hidden = NO;
        vPromit.frame = CGRectMake(0, CGRectGetMaxY(vApply.frame) + 20, self.view.frame.size.width, 145);
        btnApply.frame = CGRectMake(15, CGRectGetMaxY(vPromit.frame) + 20, self.view.frame.size.width - 30, 45);
    }
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

- (void)reloadTime:(NSDictionary*)dic complete:(void (^)())complete
{
    NSString* strStart, *strEnd;
    strStart = [self cutTimeShort:dic[@"effectDate"]];
    strEnd = [self cutTimeShort:dic[@"failureDate"]];
    if (!(strEnd == nil || [strEnd isEqualToString:@""])) {
        lbTime.text = [NSString stringWithFormat:@"%@%@%@", strStart, kLocalized(@"HSTo"), strEnd];
    }
    dispatch_async(dispatch_get_main_queue(), ^{

        if (complete) {
            complete();
        }
    });
}

#pragma mark - btnAction
//代他人身故保障金
- (IBAction)btnDie:(id)sender
{
    lbTime.text = nil;
    [self.btnDie setImage:[UIImage imageNamed:@"btn_round_click.png"] forState:UIControlStateNormal];
    [self.btnMedical setImage:[UIImage imageNamed:@"btn_round_noclick.png"] forState:UIControlStateNormal];
    applyType = 0;

    [self changeFrame:YES];
}

//申请意外伤害保障金
- (IBAction)btnMedical:(id)sender
{
    applyType = 1;
    [self.btnMedical setImage:[UIImage imageNamed:@"btn_round_click.png"] forState:UIControlStateNormal];
    [self.btnDie setImage:[UIImage imageNamed:@"btn_round_noclick.png"] forState:UIControlStateNormal];

    WS(weakSelf);
    [self get_person_welf_qualification:^(NSNumber* welfareType, NSNumber* isvalid) {
        [weakSelf changeFrame:NO];
        [weakSelf showWarnInfo:welfareType isvalid:isvalid];
    }];
}

- (void)showWarnInfo:(NSNumber*)welfareType isvalid:(NSNumber*)isvalid
{
    //没福利资格
    self.isOK = NO;
    if ([isvalid isEqualToNumber:kreplyNoQualification]) {

        self.canNotMessage = kLocalized(@"HSNotMedicalInsuranceQualification");
    }
    else if ([isvalid isEqualToNumber:kreplyHaveQualification]) {
        if ([welfareType isEqualToNumber:kreplyTypeAccidt]) { //意外伤害
            self.isOK = YES;
            self.canNotMessage = kLocalized(@"HS_Accid_Tips_Person");
        }
        else if ([welfareType isEqualToNumber:kreplyTypeCare]) { // 免费医疗
            self.canNotMessage = kLocalized(@"目前您已在享受互生医疗补贴计划，互生意外伤害保障不再享受！");

            // 当代他人时，提示信息与Android保存一致
            if (applyType == 0) {
                self.canNotMessage = kLocalized(@"该用户没有意外伤害保障资格");
            }
        }
        else {
            self.canNotMessage = kLocalized(@"HSNotMedicalInsuranceQualification");
        }
    }
    else {
        self.canNotMessage = kLocalized(@"HSNotMedicalInsuranceQualification");
    }
    [self showResultViewAndPv:self.canNotMessage];
}

- (IBAction)btnApplyClick:(id)sender
{
    [self.view endEditing:YES];
    if (applyType == 1) { // 自己申请

        //判断手机号是否认证
        if (![globalData.loginModel.isAuthMobile isEqualToString:kAuthHad]) {
            [GYUtils showToast:kLocalized(@"HSPleaseCompletePhoneNumberBinding")];
            return;
        }

        //判断实名注册，实名认证
        if ([GYUtils checkStringInvalid:globalData.loginModel.isRealnameAuth] ||
            [globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
            [GYUtils showToast:kLocalized(@"你未实名注册，无法申请该业务！")];
            return;
        }

        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusHadRes]) {
            [GYUtils showToast:kLocalized(@"你未实名认证，无法申请该业务！")];
            return;
        }
    }
    else if (applyType == 0) { // 代他人申请

        if (tfResNo.text.length == 0) {
            [GYUtils showToast:kLocalized(@"请输入被保障人互生卡号")];
            return;
        }

        if (tfName.text.length == 0) {
            [GYUtils showToast:kLocalized(@"请输入被保障人姓名")];
            return;
        }
        if (tfResNo.text.length != 11) {
            [GYUtils showToast:kLocalized(@"HSInputPointsCardNumberNotCorrect")];
            return;
        }

        if (![tfName.text isEqualToString:self.name]) {
            [GYUtils showToast:kLocalized(@"HSPointsCardNumberAndUserNameNotMatch")];
            return;
        }

        if ([globalData.loginModel.isRealnameAuth isEqualToString:kRealNameStatusNoRes]) {
            [GYUtils showToast:kLocalized(@"您未进行实名注册，不能代他人申请身故保障金")];
            return;
        }
    }

    //是否有资格的接口处理结果判断
    if (!self.isOK) {
        [GYUtils showToast:self.canNotMessage];
    }
    else {
        [self uploadApplayInfo];
    }
}

- (IBAction)btnAccidentShowClick
{

    GYAccidentInfoController* vc = [[GYAccidentInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 网络请求
- (void)get_person_welf_qualification:(void (^)(NSNumber* welfareType, NSNumber* isvalid))success
{
    NSString* strRes, *strApplyType;
    if (applyType == 0) {
        if (tfResNo.text.length != 11) {
            [GYUtils showToast:kLocalized(@"HSInputPointsCardNumberNotCorrect")];
            return;
        }
        strRes = tfResNo.text;
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
    [GYGIFHUD show];

    [Network GET:kUrlFindWelfareQualify parameters:dict completion:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        
        if (error) {
            [GYUtils showToast:kLocalized(@"networkerror_check_network")];
        } else {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                NSDictionary *dicResult = responseObject[@"data"];
                if ([dicResult isKindOfClass:[NSNull class]]) {
                    return ;
                }
                WS(weakSelf);
                [self reloadTime:dicResult complete:^{
                    if (success) {
                        weakSelf.name = dicResult[@"custName"];
                        success(dicResult[@"welfareType"], dicResult[@"isvalid"]);
                    }
                }];
                
            }  else {
                
                if ([responseObject[@"retCode"] isEqualToNumber:@160204] && applyType == 0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view endEditing:YES];
                        tfResNo.text = nil;
                        [self.view makeToast:kErrorMsg duration:1 position:CSToastPositionBottom];
                    });
                    
                } else if ([responseObject[@"retCode"] isEqualToNumber:@160205] && applyType == 0){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.view endEditing:YES];
                        tfResNo.text = nil;
                        [self.view makeToast:kLocalized(@"该账号未实名认证") duration:1 position:CSToastPositionBottom];
                    });
                } else {
                    [GYUtils showMessage:kLocalized(@"HSQueryPersonalWelfareQualificationInformationFailed")];
                }
            }
        }
    }];
}

@end
