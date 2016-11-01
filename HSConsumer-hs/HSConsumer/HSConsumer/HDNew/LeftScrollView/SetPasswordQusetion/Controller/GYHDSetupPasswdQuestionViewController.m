//
//  GYHDSetupPasswdQuestionViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSetupPasswdQuestionViewController.h"
#import "GYBaseControlView.h"
#import "GYNetRequest.h"
#import "NSString+YYAdd.h"
#import "YYKit.h"
#import "GYAlertView.h"

@interface GYHDSetupPasswdQuestionViewController ()<UITextFieldDelegate,GYNetRequestDelegate>

@property (nonatomic,strong) UITextField *inputAnswertextField;
@property (nonatomic,strong) UILabel *selectQuestionLabel;//问题
@property (nonatomic,strong) NSString *questionString;  //问题
@property (nonatomic,strong) NSString *answerString;  //答案
@property (nonatomic,strong) UIButton *selectQuestionBtn;//选择问题按钮
@property (nonatomic,strong) UIButton *showQuestionBtn;//选择问题按钮
@property (nonatomic,strong) NSArray* array;  //获取密保问题数组

@end

@implementation GYHDSetupPasswdQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self addContentView];
}

-(void)addContentView
{
    //密保设置Label
    UILabel *secrectSetLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 70, 15, 100, 21)];
    secrectSetLabel.text = kLocalized(@"GYHD_HDNew_SecrectProtectSet");
    secrectSetLabel.textColor = kCorlorFromHexcode(0x000000);
    secrectSetLabel.textAlignment = NSTextAlignmentCenter;
    secrectSetLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:secrectSetLabel];
    //线View
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 1)];
    line.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line];
    //问题Label
    UILabel *qustionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 100, 21)];
    qustionLabel.text = kLocalized(@"GYHD_HDNew_Question");
    qustionLabel.textColor = kCorlorFromHexcode(0x000000);
    qustionLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:qustionLabel];
    //选择文体Label
    _selectQuestionLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 60, kScreenWidth - 170, 21)];
    _selectQuestionLabel.text = kLocalized(@"GYHD_HDNew_SelectQuestion");
    _selectQuestionLabel.textColor = kCorlorFromHexcode(0x666666);
    _selectQuestionLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_selectQuestionLabel];
    //选择问题按钮
    _selectQuestionBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 50, 70, 13 , 7)];
    [_selectQuestionBtn setBackgroundImage:[UIImage imageNamed:@"gy_hd_red_down_arrow"] forState:UIControlStateNormal];
    [_selectQuestionBtn addTarget:self action:@selector(selectQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectQuestionBtn];
    //显示问题
    _showQuestionBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 65, kScreenWidth - 170 , 21)];
    [_showQuestionBtn addTarget:self action:@selector(selectQuestion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_showQuestionBtn];
    //线Line
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 94, kScreenWidth, 1)];
    line1.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line1];
    //确认密码Label
    UILabel *confirmPwdLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 107, 100, 21)];
    confirmPwdLabel.text = kLocalized(@"GYHD_HDNew_Answer");
    confirmPwdLabel.textColor = kCorlorFromHexcode(0x000000);
    confirmPwdLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:confirmPwdLabel];
    //输入答案TextField
    _inputAnswertextField = [[UITextField alloc]initWithFrame:CGRectMake(110, 107, kScreenWidth - 130, 21)];
    _inputAnswertextField.placeholder = kLocalized(@"GYHD_HDNew_InputAnswer");
    _inputAnswertextField.delegate = self;
    _inputAnswertextField.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_inputAnswertextField];
    //线View
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, kScreenWidth, 1)];
    line2.backgroundColor = kCorlorFromHexcode(0xebebeb);
    [self.view addSubview:line2];
    //确定Button
    UIButton *confrimBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 160, kScreenWidth - 60, 41)];
    confrimBtn.titleLabel.textColor = [UIColor whiteColor];
    confrimBtn.layer.cornerRadius = 15;
    confrimBtn.clipsToBounds = YES;
    [confrimBtn setTitle:kLocalized(@"GYHD_HDNew_Confirm") forState:UIControlStateNormal];
    [confrimBtn setBackgroundColor: [UIColor redColor]];
    [confrimBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confrimBtn];
    //提示Label
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 210, kScreenWidth - 60, 51)];
    tipLabel.text = kLocalized(@"GYHD_HDNew_TipPwdCanFindLgoinSecrectOneWayOnceSetSecrectQuestionPleaseRemeber");
    tipLabel.numberOfLines = 0;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:tipLabel];
}

#pragma mark --privateMtthod
-(void)selectQuestion
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlListPwdQuestion parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        } else {
            if ([responseObject[@"retCode"] isEqualToNumber:@200] && responseObject[@"data"]) {
                _array =responseObject[@"data"];
                NSArray *questionArray = [[NSArray alloc] initWithObjects:_array[0][@"question"],_array[1][@"question"],_array[2][@"question"],nil];
                NSLog(@"选择问题");
                CGPoint point = CGPointMake(_selectQuestionBtn.frame.origin.x - 222 + 40, (kScreenHeight - 271 - 65) * 0.5 + 46);
                GYBaseControlView *pop = [[GYBaseControlView alloc] initWithPoint:point titles:questionArray images:nil width:222 selectName:_selectQuestionLabel.text];
                pop.selectRowAtIndex = ^(NSInteger index){
                    _selectQuestionLabel.text = questionArray[index];
                    _questionString = questionArray[index];
                    _inputAnswertextField.text = nil;
                    _answerString = nil;
                };
                [pop show];
                
            } else {
                [GYAlertView showMessage:kErrorMsg];
            }
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

-(void)confirmClick
{
    if ([GYUtils isBlankString:_questionString]) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_PleaseChooseQuestion")];
        return;
    }
    else if ([GYUtils isBlankString:_answerString]) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_InputAnswerEmpty_PleaseEnterAgain")];
        return;
    }else if ( _answerString == nil) {
        [GYUtils showMessage:kLocalized(@"GYHD_HDNew_InputAnswerEmpty_PleaseEnterAgain")];
        return;
    }
    else if (_answerString.length > 50) {
        [GYUtils showToast:kLocalized(@"GYHD_HDNew_EncryptedAnswersNoExceed50Words")];
        return;
    }
    NSDictionary* dict = @{ @"custId" : kSaftToNSString(globalData.loginModel.custId),
                            @"question" : kSaftToNSString(_questionString),
                            @"answer" : kSaftToNSString(_answerString.md5String) };
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kUrlSetPwdQuestion parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"Error:%@", [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        else {
            if ([responseObject[@"retCode"] isEqualToNumber:@200]) {
                NSString *message = [responseObject objectForKey:@"msg"];
                [GYUtils showMessage:message confirm:^{
                    
                    [self.view.superview.superview removeFromSuperview];
                }];
            }
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

#pragma mark Textfield delegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    _answerString = textField.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
