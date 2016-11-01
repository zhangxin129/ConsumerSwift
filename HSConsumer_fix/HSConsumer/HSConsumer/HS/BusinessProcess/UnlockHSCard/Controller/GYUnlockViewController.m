//
//  GYUnlockViewController.m
//  HSConsumer
//
//  Created by 00 on 14-10-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYUnlockViewController.h"
#import <unistd.h>
#import "GYAlertView.h"
#import "GYHSLoginManager.h"
#import "NSString+GYExtension.h"

@interface GYUnlockViewController () <UITextFieldDelegate> {
    __weak IBOutlet UIScrollView* scvUnlock; //scrillView
    __weak IBOutlet UIView* vSMS; //互生号行
    __weak IBOutlet UIButton* btnCommit; //确认按钮
    __weak IBOutlet UILabel* lbHSCardTitle;
    __weak IBOutlet UILabel* lbHSCard;
    __weak IBOutlet UIView* vState; //状态行
    __weak IBOutlet UILabel* lbStateTitle; //状态title
    __weak IBOutlet UILabel* lbState; //状态
    __weak IBOutlet UIView* vPwd; //密码行
    __weak IBOutlet UILabel* lbPwd; //密码title
    __weak IBOutlet UITextField* tfPwd; //输入密码tf
    BOOL isCanCommit;
    id resultCode;
    GlobalData* data;
}
@end

@implementation GYUnlockViewController

//获取验证码点击事件

//确认提交 按钮点击事件
- (IBAction)btnCommitClick:(id)sender
{
    if (!isCanCommit) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Points_Card_Number_State_Normal_Can't_Operation") confirmBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        return;
    }

    if (tfPwd.text.length != 6) {
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Placeholder_Verified_Pwd")];
        return;
    }
    [self cancel_loss_card_new];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    //国际化
    self.title = kLocalized(@"GYHS_BP_Unlock_Points_Card");
    isCanCommit = YES;

    data = globalData;

    //确认提交按钮设置
    btnCommit.layer.cornerRadius = 4.0f;
    [btnCommit setBackgroundImage:[UIImage imageNamed:@"gyhs_btn_orange"] forState:UIControlStateNormal];
    [btnCommit setTitle:kLocalized(@"GYHS_BP_Confirm_To_Submit") forState:UIControlStateNormal];

    [tfPwd setSecureTextEntry:YES];
    [tfPwd setKeyboardType:UIKeyboardTypeNumberPad];
    tfPwd.delegate = self;

    lbHSCardTitle.text = kLocalized(@"GYHS_BP_HS_Number");
    lbHSCard.text = [GYUtils formatCardNo:data.loginModel.resNo];

    lbStateTitle.text = kLocalized(@"GYHS_BP_Points_Card_Number_State");
    lbState.text = @"--";

    lbPwd.text = kLocalized(@"GYHS_BP_Login_Pwd");
    tfPwd.placeholder = kLocalized(@"GYHS_BP_Placeholder_Verified_Pwd");

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];

    [self getAppendResult];
}

- (void)hidenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [vSMS addTopBorderAndBottomBorder];
    [vPwd addTopBorderAndBottomBorder];
    [vState addTopBorderAndBottomBorder];
}

#pragma mark - 接口重构  by zxm 20151230
- (void)cancel_loss_card_new
{ //提交

    NSDictionary* allFixParas = @{
        @"custId" : globalData.loginModel.custId,
        @"loginPwd" : [kSaftToNSString(tfPwd.text) md5String16:globalData.loginModel.custId],
        @"cardStatus" : kHSCardStatusUnlock
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];

    [allParas setValue:data.loginModel.custId forKey:@"custId"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kHSCardLossUnlockUrlString parameters:allParas requestMethod:GYNetRequestMethodPUT requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            NSInteger  errorRetCode = [error code];
            if ( errorRetCode == 206)
            {
                [GYAlertView showMessage:kLocalized(@"GYHS_BP_Alternate_Card_Has_Hung")];
                return ;
            }
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        [GYAlertView showMessage:kLocalized(@"GYHS_BP_Unlock_Success") confirmBlock:^{
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
    if (textField == tfPwd) {
        if (len > 6)
            return NO;
    }
    return YES;
}

- (void)getAppendResult
{
    NSDictionary* allParas = @{ @"resNo" : data.loginModel.resNo };

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:ksearchHsCardInfoByResNoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            isCanCommit = NO;
            return ;
        }
        if (![responseObject[@"data"] isKindOfClass:[NSNull class]]) {
            if ([responseObject[@"data"] isEqualToNumber:@1]) {
                lbState.text = kLocalized(@"GYHS_BP_Normal");
                isCanCommit = NO;
            } else if ([responseObject[@"data"] isEqualToNumber:@2]) {
                lbState.text = kLocalized(@"GYHS_BP_Already_ReportLoss");
                isCanCommit = YES;
            } else {
                lbState.text = kLocalized(@"GYHS_BP_Stop_Use");
                isCanCommit = NO;
            }
        } else {
            lbState.text = kLocalized(@"GYHS_BP_Normal");
            isCanCommit = NO;
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
