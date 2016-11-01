//
//  GYReportLossViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-15.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "GYHSReportLossViewController.h"
#import "InputCellStypeView.h"
#import "NSString+GYExtension.h"
#import <unistd.h>

@interface GYHSReportLossViewController () <UITextViewDelegate, UITextFieldDelegate> {
    IBOutlet InputCellStypeView* viewRow0;
    IBOutlet InputCellStypeView* viewRow1;
    IBOutlet InputCellStypeView* viewPwd;

    IBOutlet UIButton* btnCommit; //确认按钮

    IBOutlet UIView* viewResonBkg;
    IBOutlet UITextView* tvReportReason; //输入挂失原因
    IBOutlet UILabel* lbReportReason; //挂失原因标
    IBOutlet UILabel* lbPlaceholder; //textView 自定义占位符

    GlobalData* data;
    BOOL isCanCommit; //默认为no
}
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//挂失原因字数计数

@end

@implementation GYHSReportLossViewController

//确认提交 按钮点击事件
- (IBAction)btnCommitClick:(id)sender
{

    if (!isCanCommit) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Not_Allowed_Report_Loss")
                    confirmBlock:^{
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
        return;
    }

    if (tvReportReason.text.length < 1) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Loss_Reason")];
        return;
    }
    if (tvReportReason.text.length > 100) {
        [GYUtils showMessage:kLocalized(@"GYHS_BP_Fill_The_Report_Loss_Of_Reason_Not_More_Than_100_Words")];
        return;
    }

    if (viewPwd.tfRightTextField.text.length != 6) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Placeholder_Verified_Pwd")];
        return;
    }

    [self commit_new];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self getAppendResult];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //国际化
    self.title = kLocalized(@"GYHS_BP_Report_Loss_Points_Card");

    data = globalData;
    viewRow0.lbLeftlabel.text = kLocalized(@"GYHS_BP_HS_Number");
    viewRow0.tfRightTextField.text = [GYUtils formatCardNo:data.loginModel.resNo];

    viewRow1.lbLeftlabel.text = kLocalized(@"GYHS_BP_Points_Card_Number_State");
    viewRow1.tfRightTextField.text = @"--";

    viewPwd.lbLeftlabel.text = kLocalized(@"GYHS_BP_Login_Pwd");
    viewPwd.tfRightTextField.placeholder = kLocalized(@"请输入6位登录密码");//GYHS_BP_Placeholder_Verified_Pwd
    [viewPwd.tfRightTextField setSecureTextEntry:YES];
    [viewPwd.tfRightTextField setKeyboardType:UIKeyboardTypeNumberPad];
    viewPwd.tfRightTextField.delegate = self;
    viewPwd.lbLeftlabel.textColor = kCellItemTitleColor;

    lbReportReason.text = kLocalized(@"GYHS_BP_Report_Loss_Reason");
    [lbReportReason setTextColor:kNumDarkgrayColor];
    
    self.numberLabel.text = @"100";
    
    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 20.0f;
    btnCommit.titleLabel.text = kLocalized(@"GYHS_BP_Confirm_To_Submit");
    //[btnCommit setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];

    [viewResonBkg addTopBorderAndBottomBorder];
    //获取验证码

    //textView delegate
    lbPlaceholder.text = kLocalized(@"请填写挂失原因");
    lbPlaceholder.textColor = kTextFieldPlaceHolderColor;
    lbPlaceholder.enabled = NO;
    tvReportReason.delegate = self;

    isCanCommit = NO;

    [self get_person_card_infomation];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}

- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView*)textView
{
    if (textView.text.length > 100) {
        textView.text = [textView.text substringToIndex:100];
        lbPlaceholder.text = @"";
        return;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(100 - textView.text.length)];
    if (textView.text.length == 0) {
        lbPlaceholder.text = kLocalized(@"请填写挂失原因");//GYHS_BP_Input_Report_Loss_Reason
    } else {
        lbPlaceholder.text = @"";
    }
}

#pragma mark - 网络数据交换
- (void)get_person_card_infomation
{
    viewRow1.tfRightTextField.text = kLocalized(@"GYHS_BP_Normal");
    isCanCommit = YES;
    return;
}

#pragma mark - 接口重构  by zxm 20151230
- (void)commit_new
{ //提交
    NSDictionary* allFixParas = @{
        @"loginPwd" : [kSaftToNSString(viewPwd.tfRightTextField.text) md5String16:globalData.loginModel.custId],
        @"cardStatus" : kHSCardStatusLoss,
        @"lossReason" : kSaftToNSString(tvReportReason.text),
        @"custId" : kSaftToNSString(globalData.loginModel.custId)
    };

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSCardLossUnlockUrlString
                                                     parameters:allFixParas
                                                  requestMethod:GYNetRequestMethodPUT
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           NSInteger errorRetCode = [error code];
                                                           if (errorRetCode == 206) {
                                                               [GYAlertView showMessage:kLocalized(@"GYHS_BP_Alternate_Card_Has_Report_Loss")];
                                                               return;
                                                           }
                                                           DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       [GYAlertView showMessage:kLocalized(@"GYHS_BP_Report_Loss_Success")
                                                                   confirmBlock:^{
                                                                       [self.navigationController popViewControllerAnimated:YES];
                                                                   }];
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string
{
    // modify by songjk 计算长度修改
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    unsigned long len = toBeString.length;
    if (textField == viewPwd.tfRightTextField) {
        if (len > 6)
            return NO;
    }
    return YES;
}

- (void)getAppendResult
{
    NSDictionary* allParas = @{ @"resNo" : kSaftToNSString(data.loginModel.resNo) };

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:ksearchHsCardInfoByResNoUrl
                                                     parameters:allParas
                                                  requestMethod:GYNetRequestMethodGET
                                              requestSerializer:GYNetRequestSerializerJSON
                                                   respondBlock:^(NSDictionary* responseObject, NSError* error) {
                                                       [GYGIFHUD dismiss];
                                                       if (error) {
                                                           DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
                                                           [GYUtils parseNetWork:error resultBlock:nil];
                                                           return;
                                                       }
                                                       if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
                                                           if ([responseObject[@"data"] isEqualToNumber:@1]) {
                                                               viewRow1.tfRightTextField.text = kLocalized(@"GYHS_BP_Normal");
                                                           } else if ([responseObject[@"data"] isEqualToNumber:@2]) {
                                                               viewRow1.tfRightTextField.text = kLocalized(@"GYHS_BP_Already_ReportLoss");
                                                           } else {
                                                               viewRow1.tfRightTextField.text = kLocalized(@"GYHS_BP_Stop_Use");
                                                           }
                                                       }
                                                   }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
