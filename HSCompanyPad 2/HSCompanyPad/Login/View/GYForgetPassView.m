//
//  GYForgetPassView.m
//  HSCompanyPad
//
//  Created by User on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYForgetPassView.h"
#import <GYKit/UIView+Extension.h>
#import "GYPassKindView.h"
#import "GYPassPhoneView.h"
#import "GYPassMailView.h"
#import "GYPassQuestionView.h"
#import "AppDelegate.h"
#import "GYNetwork.h"
#import "GYNetAPiMacro.h"
#import <YYKit/NSString+YYAdd.h>

#define kShowViewWitdh 480

//忘记密码企业类型
typedef NS_ENUM(NSUInteger, ForgetPasswdType) {
    kForgetPasswdNone = 0, //无对应类型
    kForgetPasswdMembercom = 2, //成员企业
    kForgetPasswdTrustcom = 3, //托管企业
    kForgetPasswdServicecom = 4, //服务公司
};


@interface GYForgetPassView()<UITextFieldDelegate,GYPassPhoneDelegate>{

    NSString *result;
    NSString *custId;
}

@property (weak, nonatomic) IBOutlet UILabel *confirmLabel;//确认账号

@property (weak, nonatomic) IBOutlet UILabel *passFindLabel;//密码找回方式

@property (weak, nonatomic) IBOutlet UILabel *passResetLabel;//登录密码重置
@property (weak, nonatomic) IBOutlet UILabel *finishLabel;//完成

@property (weak, nonatomic) IBOutlet UITextField *hsCardTF;//企业互生号输入框
@property (weak, nonatomic) IBOutlet UITextField *staffNoTF;//员工号输入框
@property (weak, nonatomic) IBOutlet UIView *hsCardBackView;

@property (weak, nonatomic) IBOutlet UIView *staffNoBackView;
@property (weak, nonatomic) IBOutlet UIImageView *hsCardImageView;//互生号logo

@property (weak, nonatomic) IBOutlet UIImageView *staffNoImageView;//员工号logo

@end

@implementation GYForgetPassView

-(void)awakeFromNib{

    [self setDefaultRound:_rateLabelOne];
    [self setDefaultRound:_rateLabelTwo];
    [self setDefaultRound:_rateLabelThree];
    [self setDefaultRound:_rateLabelFour];
    [self setFinishRound:_rateLabelOne];
    
    [_progressView setProgressViewStyle:UIProgressViewStyleBar];
    
    [_progressView setProgress:0];
//    [_progressView setProgressTintColor:kNavigationBarColor];
    
    CGRect rect = _progressView.frame;
    rect.size.height=30;
    [_progressView setFrame:rect];
    
    self.step = 1;
    
    self.nextBtn.layer.cornerRadius = 6;
    self.nextBtn.backgroundColor = kGrayCCCCCC;
    
    self.staffNoBackView.backgroundColor =[UIColor clearColor];
    
    self.hsCardBackView.backgroundColor =[UIColor clearColor];
    self.hsCardTF.delegate = self;
    
    [self setDeaultBackLine:self.staffNoBackView];
    
    [self setDeaultBackLine:self.hsCardBackView];
    
    _confirmLabel.textColor = kBlue2d89f0;//默认选中1

}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    _progressView.transform = CGAffineTransformMakeScale(1.0f,3.0f);

    _hsCardImageView.customBorderType = UIViewCustomBorderTypeRight;
    _staffNoImageView.customBorderType =UIViewCustomBorderTypeRight;
    
}

#pragma mark - method
+(void)show{

    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    UIViewController *rootVC = delegate.window.rootViewController;
    
    UIView *maskView =[[UIView alloc]initWithFrame:rootVC.view.bounds];
    
    maskView.backgroundColor = kMaskViewColor;
    
    GYForgetPassView *forgetView =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYForgetPassView.class) owner:self options:nil][0];
    
    [rootVC.view addSubview:maskView];
    
    [maskView addSubview:forgetView];
    
    [forgetView setCenter:maskView.center];
    
    [forgetView mas_updateConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(97);
        make.width.mas_equalTo(500);
        make.centerX.equalTo(forgetView.superview.mas_centerX);
        make.bottom.mas_equalTo(-45);
        
    }];
}

- (IBAction)dimissBtnAction:(id)sender {
    
    if (self.superview) {
        
        [self.superview removeFromSuperview];
    }
    [self removeFromSuperview];
    
}
#pragma mark - 下一步action
- (IBAction)nextStepAction:(id)sender {
    
    if (self.step>4) {
        //超过100%不操作,发送更改后的新密码请求
        
      //  [self reSetLoginPassByForgetPassword];
        [self dimissBtnAction:nil];
        
        return;
    }
    
    if ([self HSCardString:self.hsCardTF.text] == kForgetPasswdNone) {
        [self.hsCardTF tipWithContent:kLocalized(@"GYHS_Login_ResNO_Is_Not_Right") animated:YES];
        return;

    }
    if ([GYUtils isServiceHSCardNo:self.hsCardTF.text]) {
        [self.hsCardTF tipWithContent:kLocalized(@"服务公司用户暂不支持通过该终端找回登录密码业务。") animated:YES];
        return;
    }
//    self.step+=1;
    
    switch (self.step) {
       
        case 1:{
            
            //选择找回密码方式视图
            self.kindView  =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYPassKindView.class) owner:self options:nil][0];
            [self.bodyScrollView addSubview: self.kindView];
            self.step+=1;
            [self.nextBtn setBackgroundColor:kRedE40011];

        }
            break;
        case 2:{
            
            _rateLabelTwo.backgroundColor=kBlue2d89f0;
            
            _passFindLabel.textColor = kBlue2d89f0;

             [self.progressView setProgress:1/3.0 animated:YES];
            

            if (self.kindView.selectType==kForgetPassType_Phone) {
                
                self.phoneView  =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYPassPhoneView.class)   owner:self options:nil][0];
                self.phoneView.delegate = self;
                
                [self.bodyScrollView addSubview: self.phoneView];
            }
            
            else if (self.kindView.selectType==kForgetPassType_Mail){
                
                self.mailView  =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYPassMailView.class)  owner:self options:nil][0];
                
                [self.bodyScrollView addSubview: self.mailView];
            }
            else if (self.kindView.selectType==kForgetPassType_Question){
                
                self.questionView  =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYPassQuestionView.class) owner:self options:nil][0];
                
                [self.bodyScrollView addSubview: self.questionView];
            }
            self.step+=1;
            
        }
            break;
        case 3:{
            
            if (self.kindView.selectType==kForgetPassType_Phone) {
                
                //没输入验证码，不进入下一步，不请求校验验证码
                    if (self.phoneView.codeTF.text.length==0) {
                        [self.phoneView.codeTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Code") animated:YES];
                        return;
                    }
                
                if (self.phoneView.phoneTF.text.length==0) {
                    [self.phoneView.phoneTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Phone_Number") animated:YES];
                    DDLogCInfo(@"请输入用户名和验证码");
                    
                    return;
                }
                else{
                    [self checkCodeRequest];
                }
            }
            
            else if (self.kindView.selectType==kForgetPassType_Mail){
            
                if (![self.mailView.mailTF.text isEmailAddress]) {
                    //不符合邮箱格式则返回
                    [self.mailView.mailTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Right_Email") animated:YES];
                    return;
                }
                else{
                    //验证服务器邮箱
                    [self checkEmailRequest];
                }
            
            }
            
            else if (self.kindView.selectType==kForgetPassType_Question){
            
                if ([self.questionView.questionBtn.titleLabel.text isEqualToString:kLocalized(@"GYHS_Login_Please_Select_Question")]) {
                    [GYUtils showToast:kLocalized(@"GYHS_Login_Please_Select_Question")];
                    return;
                }
                if (self.questionView.answerTF.text.length==0) {
                    [self.questionView.answerTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Answer") animated:YES];
                    return;
                }
                    //发起验证密保问题请求
                    [self checkQuestionRequest];
                
            }
           
            
           
            
           
        }break;
        case 4:{
        
            if (self.resetView.passNewTF.text.length==0) {
                [self.resetView.passNewTF tipWithContent:kLocalized(@"GYHS_Login_Input_Password") animated:YES];
                return;
            }
            else if (self.resetView.passConfirmTF.text.length==0){
                [self.resetView.passConfirmTF tipWithContent:kLocalized(@"GYHS_Login_Input_Password") animated:YES];
                return;
            }
          else  if (![self.resetView.passNewTF.text isEqualToString: self.resetView.passConfirmTF.text]) {
              
              NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]
                                                 initWithString:kLocalized(@"GYHS_Login_Password_Is_Diffrence")];
              
              
              NSTextAttachment *imageMent =[[NSTextAttachment alloc]init];
              
              imageMent.image =kLoadPng(@"gy_error_red");
              imageMent.bounds = CGRectMake(2, -5, 20, 20);
              
              NSAttributedString *imageAttr =
              [NSAttributedString attributedStringWithAttachment:imageMent];
              
              [attr insertAttributedString:imageAttr atIndex:0];
              
              self.resetView.tintLabel.attributedText=attr;
              //两次密码输入不一致，请重新输入
              [self.resetView.passConfirmTF tipWithContent:kLocalized(@"GYHS_Login_Password_Is_Diffrence") animated:YES];
                return;
            }
          
          else  if (self.resetView.passNewTF.text.length!=6) {
              
              [self.resetView.passNewTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Six_Password_Code") animated:YES];
              
              DDLogInfo(@"请输入6位密码");
              return;
          }
          else if (self.resetView.passConfirmTF.text.length!=6){
              [self.resetView.passConfirmTF tipWithContent:kLocalized(@"GYHS_Login_Please_Input_Six_Password_Code") animated:YES];
              
              DDLogInfo(@"请输入6位密码");
              return;
          }
            
          else{
          
              /*
               kForgetPassType_Phone = 0, //手机号
               kForgetPassType_Mail ,    //邮箱
               kForgetPassType_Question
               */
              if (self.kindView.selectType==kForgetPassType_Phone) {
                   [self reSetLoginPassByForgetPassword];
              }
              else if(self.kindView.selectType==kForgetPassType_Mail) {
                  //流程有问题，暂未实现
              }
              else if(self.kindView.selectType==kForgetPassType_Question) {
                  
                  [self reSetLoginPassBySecurity];
              }
              
             
          }
            
        }break;
        default:
            break;
    }
    
    
}


-(void)setDeaultBackLine:(UIView*)view{
    
    view.layer.borderWidth=1;
    
    view.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    view.backgroundColor =[UIColor clearColor];
    
}

-(void)setFinishRound:(UIView*)view{
    
     view.backgroundColor =kBlue2d89f0;
}

-(void)setDefaultRound:(UIView*)view{
    
    view.layer.cornerRadius=view.frame.size.width/2.0;
    view.layer.masksToBounds = YES;
}

//显示重置密码
-(void)showResetView{

    self.resetView  =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYPassResetView.class) owner:self options:nil][0];
    self.resetView.passNewTF.delegate = self;
    self.resetView.passConfirmTF.delegate = self;
    
    [self.bodyScrollView addSubview: self.resetView];
    
    
    _rateLabelThree.backgroundColor=kBlue2d89f0;
    //
    _passResetLabel.textColor = kBlue2d89f0;
    //
    
    [self.progressView setProgress:2/3.0 animated:YES];
    self.step +=1;
    
    [self.nextBtn setTitle:kLocalized(@"GYHS_Login_Confirm") forState:UIControlStateNormal];
    
    [self.nextBtn setBackgroundColor:kRedE40011];
}

- (void)showSuccessView{
 
    self.successView  =[[NSBundle mainBundle]loadNibNamed:NSStringFromClass(GYSuccessView.class)owner:self options:nil][0];
    
    [self.bodyScrollView addSubview: self.successView];
    
    _rateLabelFour.backgroundColor=kBlue2d89f0;
    //
    _finishLabel.textColor = kBlue2d89f0;
    
    [self.progressView setProgress:1 animated:YES];
    self.step +=1;
    
    [self.nextBtn setTitle:kLocalized(@"GYHS_Login_Confirm") forState:UIControlStateNormal];

}

#pragma mark--- btn倒计时
- (void)buttonTitleTime:(UIButton *)button
{
    
    [button setBackgroundColor:kGrayCCCCCC];
    
    __block int timeout = 120; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                
                [button setTitle:kLocalized(@"重新获取") forState:UIControlStateNormal];
                [button setBackgroundColor:kBlue2d89f0];
                
                button.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = timeout % (120 + 1);
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@%@后重新获取",strTime,@"秒"] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                
            });
            
            timeout--;
            
        }
    });
    
    dispatch_resume(_timer);
}


#pragma mark - 手写判断企业类型（2成员企业,3托管企业,4服务公司，0无效企业互生号）
- (ForgetPasswdType)HSCardString:(NSString*)cardString
{
    if (cardString.length != 11) {
        return kForgetPasswdNone;
    }
    //输入正确互生卡号(前两位不为00且3到5位不为000)
    NSString* stringOne = [cardString substringWithRange:NSMakeRange(0, 2)];
    NSString* stringTwo = [cardString substringWithRange:NSMakeRange(2, 3)];
    //第67位(00为成员企业和服务公司，非00为托管企业)
    NSString* stringThree = [cardString substringWithRange:NSMakeRange(5, 2)];
    //最后四位(0000为服务公司和托管企业，非0000为成员企业)
    NSString* stringFour = [cardString substringFromIndex:7];
    if ([stringOne isEqualToString:@"00"] || [stringTwo isEqualToString:@"000"] ) {
        return kForgetPasswdNone;
    }else {
        if (![stringThree isEqualToString:@"00"]) {
            //托管企业
            return kForgetPasswdTrustcom;
        }else {
            if ([stringFour isEqualToString:@"0000"]) {
                //服务公司
                return kForgetPasswdServicecom;
            }else {
                //成员企业
                return kForgetPasswdMembercom;
            }
        }
    }
}

#pragma mark - 校验验证码request
- (void)checkCodeRequest{

    NSDictionary *params =@{
                            @"mobile":self.phoneView.phoneTF.text,
                            @"smsCode":self.phoneView.codeTF.text
                            };
                            
    /*
     3.3.2.3 输入参数
     名称	类型	是否必填	示例值	默认值	描述
     mobile	String	是			手机号
     smsCode	String	是			短信验证码
     */
    
    
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSCheckSmsCode) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            //
              [self showResetView];
            self.phoneView.wrongCodeLabel.hidden=YES;

        }
        
        else{
        
            self.phoneView.wrongCodeLabel.hidden=NO;
            
            [GYUtils showToast:returnValue[@"msg"]];

        }
      
        
    } failure:^(NSError *error) {
        
        [GYUtils showToast:kLocalized(@"网络连接错误")];
        
    } isIndicator:YES];

}

#pragma mark - 服务器验证邮箱request

-(void)checkEmailRequest{

   NSDictionary *params = @{ @"hsResNo" : _hsCardTF.text,
       @"entUserName" : @"0000",
       @"email" : self.mailView.mailTF.text,
       @"userType" : @"3",//
       @"custType" : @([self HSCardString:_hsCardTF.text])
                        };
//
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSResetLoginPwdByEmail) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            //
            [self showResetView];
        }
        else{
            //
           [GYUtils showToast:returnValue[@"msg"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
       

    } isIndicator:YES];

    
}

#pragma mark - 重置密码request(手机方式)
- (void)reSetLoginPassByForgetPassword{
    
    
    //GYHSResetLoginPwdByMobile,通过手机找回密码
    
    NSString *newLoginPwd = self.resetView.passNewTF.text;
    NSString *smsCode = self.phoneView.codeTF.text;
    
    NSString *GYUserTypeCompany = @"4";
    NSString *hsResNo = self.hsCardTF.text;
    NSString *mobile = self.phoneView.phoneTF.text;
    //密码加密
    newLoginPwd = [newLoginPwd encodeWithKey:mobile];
    
    NSDictionary *params =@{ @"newLoginPwd" : newLoginPwd?newLoginPwd:@"",
                             @"smsCode" : smsCode?smsCode:@"",
                             @"userType" : GYUserTypeCompany?GYUserTypeCompany:@"",
                             @"hsResNo" : hsResNo?hsResNo:@"",
                             @"mobile" : mobile?mobile:@"",
                             @"entUserName" : @"0000"
                             };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSResetLoginPwdByMobile) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            //修改密码成功
            [self showSuccessView];
        }
        else{
        
            [GYUtils showToast:returnValue[@"msg"]];
        
        }
        
        
    } failure:^(NSError *error) {
       
      
        
    } isIndicator:YES];
    
}

#pragma mark - 重置密码request(邮箱方式)
- (void)reSetLoginPassByEmail{
    
    
    //流程有问题，暂不实现
    /*
    NSString *newLoginPwd = self.resetView.passNewTF.text;
    
    NSString *hsResNo = self.hsCardTF.text;

    NSString *GYUserTypeOperater =@"3";
    
 NSDictionary *params = @{ @"hsResNo" : hsResNo,
       @"entUserName" : @"0000",
       @"email" : self.mailView.mailTF.text,
       @"userType" : GYUserTypeOperater,
       @"custType" : @([self HSCardString:_hsCardTF.text])
                           };

    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSResetLoginPwdByEmail) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            //修改密码成功
        }
        else{
            
            
        }
        
        
        
    } failure:^(NSError *error) {
        
    } isIndicator:YES];
    */
}
#pragma mark - 重置密码request(密保方式)

- (void)reSetLoginPassBySecurity{
    
    NSString *newLoginPwd = self.resetView.passNewTF.text;
    
    NSString *GYUserTypeCompany = @"4";
   
    if (custId) {
        newLoginPwd = [newLoginPwd encodeWithKey:custId];
    }
    
   NSDictionary *params= @{
      @"userType" : GYUserTypeCompany,
      @"newLoginPwd" : newLoginPwd?newLoginPwd:@"",
      @"custId" : custId?custId:@"",
      @"result" : result?result:@""
      };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSResetLoginPwdBySecurity) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            //修改密码成功,显示成功状态图
            [self showSuccessView];

        }
        else{
        
            [GYUtils showToast:returnValue[@"msg"]];
            
        }
        
        
    } failure:^(NSError *error) {
       

    } isIndicator:YES];


}
#pragma mark - 校验密保问题request
- (void)checkQuestionRequest{
    
    NSString *hsResNo = self.hsCardTF.text;
    NSString *answer = self.questionView.answerTF.text;
     answer = answer.md5String;
    NSString *question = self.questionView.questionBtn.titleLabel.text;
    NSDictionary *params =@{ @"answer" : answer?answer:@"",
                             @"question" : question?question:@"",
                             @"entUserName" : @"0000",
                             @"resNo" : hsResNo?hsResNo:@"",
                             @"usertype":GYUserTypeOperater
                             };
    
    [GYNetwork POST:GY_HSDOMAINAPPENDING(GYHSCheckPwdQuestion) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            //返回result,返回custId
            result = returnValue[GYNetWorkDataKey][@"result"];
             custId = returnValue[GYNetWorkDataKey][@"custId"];

            DDLogInfo(@"校验密保问题成功");
            
            [self showResetView];
        }
        else{
            DDLogInfo(@"");
            
            [GYUtils showToast:kLocalized(@"GYHS_Login_VerifyTheSecurityIssueFailed")];

        }
        
        
    } failure:^(NSError *error) {
       

    } isIndicator:YES];

}

#pragma mark - GYPassPhoneDelegate- 获取验证码
//选中获取验证码按钮，回传手机号
-(void)didSelectCodeBtnRequest:(NSString*)phoneText{
    
        if (self.phoneView.phoneTF.text.length==0) {
            DDLogCInfo(@"请输入有效手机号");
            return;
        }
    //新用户名，
//    NSDictionary *params =@{
//                             @"userType":@"3",//企业操作员
//                             @"userName":@"0000",//固定用户名
//                             @"mobile":phoneText,//手机号
//                             @"entResNo":_hsCardTF.text,//资源号
//                             @"custType":@([self HSCardString:_hsCardTF.text])//企业类型
//                            };
    
 NSDictionary *params= @{ @"userType" : @"3",
                          @"entResNo" : _hsCardTF.text,
                          @"userName" : @"0000",
                          @"mobile" : phoneText,
                          @"custType" : @([self HSCardString:_hsCardTF.text])
                      };
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSSendCode) parameter:params success:^(id returnValue) {
        
        if (kHTTPSuccessResponse(returnValue)) {
            
            [self buttonTitleTime:self.phoneView.codeBtn];
            
           
        }
        
        else if ([returnValue[GYNetWorkCodeKey]isEqualToNumber:@160140]){
        
          [GYUtils showToast:kLocalized(@"GYHS_Login_ThePhoneNumberIsIncorrect")];
        }
        
        else{
            [GYUtils showToast:kLocalized(@"GYHS_Login_FailedToGetVerificationOfMissingCode")];
        }
        
        
    } failure:^(NSError *error) {
        
        [GYUtils showToast:kLocalized(@"GYHS_Login_TheNetworkConnectionFailed")];
    } isIndicator:YES];
    
}

#pragma mark - 获取密保问题列表

-(void)didSelectQuestionBtn:(NSString*)questionStr{


}

#pragma mark - UITextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textField:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    
//    NSCharacterSet * muteSet = [NSCharacterSet characterSetWithCharactersInString:@"-/:;()$&@.,?!'''＂、[]{}#%^*+=_\\|~＜＞$€^•''\""];
//    
//    NSRange stringRange = [string rangeOfCharacterFromSet:muteSet];
//    
//    if (stringRange.location!=NSNotFound) {
//        [self endEditing:YES];
//        return NO;
//    }
    
    NSCharacterSet* cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString* filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest) {
        return NO;
    }
    NSString* toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if ([textField isEqual:self.hsCardTF]&& toBeString.length > 11) {
        [self.nextBtn setBackgroundColor:kRedE40011];
        [self endEditing:YES];
        return NO;
        
    }else{
        self.nextBtn.backgroundColor = kGrayCCCCCC;
    }
    
    if ([textField isEqual:self.staffNoTF]&& toBeString.length > 4){
        
        [self endEditing:YES];
        return NO;
    }
    
    else if ([textField isEqual:self.resetView.passNewTF]&& toBeString.length > 6){
        
        [self endEditing:YES];
        return NO;
    }
    
    else if ([textField isEqual:self.resetView.passConfirmTF]&& toBeString.length > 6){
        
        [self endEditing:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark - UIScrollView Delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    
}
@end
