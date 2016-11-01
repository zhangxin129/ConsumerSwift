//
//  GYSetupPasswdQuestionViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSetupPasswdQuestionViewController.h"
#import "GYHSLoginManager.h"
#import "UIButton+GYExtension.h"
#import "NSString+YYAdd.h"
#import "GlobalData.h"
#import "GYAlertView.h"

@implementation GYSetupPasswdQuestionViewController {

    __weak IBOutlet UILabel* lbQuestion;
    __weak IBOutlet UILabel* lbAnswer;
    __weak IBOutlet UITextField* tfQuestion;
    __weak IBOutlet UITextField* tfAnswer;
    __weak IBOutlet UIButton* btnChoose;
    __weak IBOutlet UIView* vUpBgView;
    __weak IBOutlet UILabel* lbTips;
    __weak IBOutlet UIView* vDownBgView;
    NSArray* array;
}



#pragma mark - life cycle
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self setSeprator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    self.title = kLocalized(@"GYHS_Security_Set_Pwd_Prompt_Question");
    
    [self modifyName];
    [self setTextColor];
    //修改导航栏右边按钮
    UIButton* btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(0, 0, 44, 44);
    [btnRight setTitle:kLocalized(@"GYHS_Security_Confirm") forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [btnRight setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    tfAnswer.placeholder = kLocalized(@"GYHS_Security_Input_Your_Answer");
    tfQuestion.placeholder = kLocalized(@"GYHS_Security_Input_Your_Question");
    [GYUtils setPlaceholderAttributed:tfAnswer withSystemFontSize:17.0 withColor:kTextFieldPlaceHolderColor];
    [btnChoose setEnlargEdgeWithTop:20.0 right:20.0 bottom:20.0 left:10.0];
}


#pragma mark - SystemDelegate
#pragma mark textfield delegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if (textField.tag == 10) {
        _strContent = textField.text;
    }
    else {
        _strAnswer = textField.text;
    }
}



#pragma mark--UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        tfAnswer.text = array[0][@"question"];
    }
    else if (buttonIndex == 1) {
        tfAnswer.text = array[1][@"question"];
    }
    else if (buttonIndex == 2) {
        tfAnswer.text = array[2][@"question"];
    }
}
- (void)actionSheetCancel:(UIActionSheet*)actionSheet
{
    DDLogDebug(@"");
}


#pragma mark TableView Delegate

#pragma mark - CustomDelegate

#pragma mark - event response
- (IBAction)btnChooseMethod:(id)sender
{
    [GYUtils hideKeyboard];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlListPwdQuestion parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        } else {
            if ([responseObject[@"retCode"] isEqualToNumber:@200] && responseObject[@"data"]) {
                array =responseObject[@"data"];
                
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:kLocalized(@"GYHS_Security_Set_Pwd_Prompt_Question") delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:array[0][@"question"],array[1][@"question"],array[2][@"question"], nil];
                sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;//设置样式
                [sheet showInView:self.view];
                
            } else {
                [GYAlertView showMessage:kErrorMsg];
            }
            
        }
        
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    
}

- (void)confirmAction
{
    [GYUtils hideKeyboard];
    [self LoadDataFromNetwork];
}


#pragma mark - private methods
- (void)willPresentActionSheet:(UIActionSheet*)actionSheet
{
    for (UIView* subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton* button = (UIButton*)subViwe;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

- (void)LoadDataFromNetwork
{
    
    if ([GYUtils isBlankString:tfAnswer.text]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Security_Please_First_Choice_Problem")];
        return;
    }
    else if ([GYUtils isBlankString:_strAnswer]) {
        [GYUtils showMessage:kLocalized(@"GYHS_Security_Enter_Answer_Empty_Please_Enter_Again")];
        return;
    }
    else if (tfAnswer.text.length > 50) {
        [GYUtils showToast:kLocalized(@"GYHS_Security_Encrypted_Answers_May_Not_Exceed_50_Words")];
        return;
    }
    
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"question" : kSaftToNSString(tfAnswer.text),
                            @"answer" : kSaftToNSString(_strAnswer.md5String) };
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlSetPwdQuestion parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"Error:%@", [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        else {
            DDLogDebug(@"responseObject:%@", responseObject);
            
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                NSString *message = [responseObject objectForKey:@"msg"];
                [GYUtils showMessage:message confirm:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

- (void)modifyName
{
    tfQuestion.backgroundColor = [UIColor whiteColor];
    tfAnswer.backgroundColor = [UIColor whiteColor];
    lbQuestion.text = kLocalized(@"GYHS_Security_Problem");
    lbAnswer.text = kLocalized(@"GYHS_Security_Answer");
    lbTips.text = kLocalized(@"GYHS_Security_Question_And_Answer_Comment");
}

//设置label的字体颜色
- (void)setTextColor
{
    lbTips.textColor = kCellItemTextColor;
    lbAnswer.textColor = kCellItemTitleColor;
    lbQuestion.textColor = kCellItemTitleColor;
    tfAnswer.textColor = kCellItemTitleColor;
    tfAnswer.enabled = NO;
    tfQuestion.textColor = kCellItemTitleColor;
}

//设置分割线
- (void)setSeprator
{
    [vUpBgView addAllBorder];
    [vDownBgView addAllBorder];
}

#pragma mark - getters and setters

@end
