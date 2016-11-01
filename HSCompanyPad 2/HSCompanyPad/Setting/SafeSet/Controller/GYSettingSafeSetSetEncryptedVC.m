//
//  GYSettingSafeSetEncryptedVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingSafeSetSetEncryptedVC.h"
#import "GYNetwork.h"
#import "GYSetSafeSetQuestionModel.h"
#import "GYShowPullDownViewVC.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import <BlocksKit/BlocksKit.h>
#import <YYKit/NSString+YYAdd.h>

@interface GYSettingSafeSetSetEncryptedVC () <UITextFieldDelegate, UIGestureRecognizerDelegate> {
    GYShowPullDownViewVC* toolVC;
}

@property (nonatomic, strong) UITextField* choseQuestionTextField;
@property (nonatomic, strong) UITextField* inputAnswerTextField;
@property (nonatomic, strong) UILabel* tipLabel;
@property (nonatomic, strong) UIButton* comfirmButtom;
@property (nonatomic, strong) NSMutableArray* qustionArray;
@property (nonatomic, assign) NSInteger selectQuestionIndex;

@end

@implementation GYSettingSafeSetSetEncryptedVC

#pragma mark - life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self getListOfQuestion];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
    [self inputViewBeNil];
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    if (textField == self.choseQuestionTextField) {
        return NO;
    }
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    
    if ([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIView class]]) {
        
        id view = (UITextField*)touch.view;
        
        if (view == _choseQuestionTextField || view == _choseQuestionTextField.rightView) {
            //点击选择问题列表
            [self tapAlertView];
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - event
- (void)tapAlertView
{
    DDLogInfo(@"弹出框");
    NSMutableArray* array = [NSMutableArray array];
    for (GYSetSafeSetQuestionModel* model in self.qustionArray) {
        [array addObject:model.question];
    }
    toolVC = [[GYShowPullDownViewVC alloc] initWithView:_choseQuestionTextField PullDownArray:array direction:UIPopoverArrowDirectionUp];
    @weakify(self);
    toolVC.selectBlock = ^(NSInteger index) {
        @strongify(self);
        self.selectQuestionIndex = index;
        self.choseQuestionTextField.text = array[index];
    };
}

- (void)comfirmButtonAction
{
    DDLogInfo(@"点击确认");
    if (_choseQuestionTextField.text.length == 0) {
        [_choseQuestionTextField tipWithContent:kLocalized(@"GYSetting_Set_Select_Question") animated:YES];
        return;
    }
    
    if (_inputAnswerTextField.text.length == 0) {
        [_inputAnswerTextField tipWithContent:kLocalized(@"GYSetting_Set_Please_Input_Answer") animated:YES];
        return;
    }
    
    [self postDataToService];
}

#pragma mark - request

- (void)postDataToService
{
    
    GYSetSafeSetQuestionModel* model = self.qustionArray[self.selectQuestionIndex];
    
    NSDictionary* dicParams = @{
                                @"custId" : globalData.loginModel.entCustId,
                                @"answer" : _inputAnswerTextField.text.md5String, //企业
                                @"question" : model.question,
                                @"questionId" : kSaftToNSString(model.questionId)
                                };
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSSetUpdatePwdQuestion)
         parameter:dicParams
           success:^(id returnValue) {
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   [GYUtils showToast:kLocalized(@"GYSetting_Set_Set_Encrypted")];
                   [self inputViewBeNil];
               }
           }
           failure:^(NSError* error) {
               
           }
       isIndicator:YES];
}

- (void)getListOfQuestion
{
    
    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListPwdQuestion)
         parameter:nil
           success:^(id returnValue) {
               
               if ([returnValue[GYNetWorkCodeKey] isEqualToNumber:@200]) {
                   NSArray* array = [GYSetSafeSetQuestionModel arrayOfModelsFromDictionaries:returnValue[GYNetWorkDataKey] error:nil];
                   for (NSString* str in array) {
                       [self.qustionArray addObject:str];
                   }
               }
           }
           failure:^(NSError* error){
               
           }];
}

#pragma mark - private methods
- (void)inputViewBeNil
{
    self.choseQuestionTextField.text = nil;
    self.inputAnswerTextField.text = nil;
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.choseQuestionTextField];
    [self.choseQuestionTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view).offset(kDeviceProportion(16));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.inputAnswerTextField];
    [self.inputAnswerTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.choseQuestionTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.inputAnswerTextField.mas_bottom).offset(kDeviceProportion(20));
        make.left.equalTo(self.view).offset(kDeviceProportion(342));
        make.right.equalTo(self.view).offset(kDeviceProportion(-342));
        make.height.equalTo(@(kDeviceProportion(60)));
    }];
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    [bottomBackView addSubview:self.comfirmButtom];
    [self.comfirmButtom mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
}

#pragma mark - lazy load

- (NSMutableArray*)qustionArray
{
    if (!_qustionArray) {
        _qustionArray = [NSMutableArray array];
    }
    return _qustionArray;
}

- (UIButton*)comfirmButtom
{
    if (!_comfirmButtom) {
        _comfirmButtom = [[UIButton alloc] init];
        _comfirmButtom.layer.cornerRadius = 5;
        _comfirmButtom.layer.borderWidth = 1;
        _comfirmButtom.layer.borderColor = kRedE50012.CGColor;
        _comfirmButtom.layer.masksToBounds = YES;
        [_comfirmButtom setTitle:kLocalized(@"GYSetting_Comfirm") forState:UIControlStateNormal];
        [_comfirmButtom setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_comfirmButtom setBackgroundColor:kRedE50012];
        [_comfirmButtom addTarget:self action:@selector(comfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _comfirmButtom;
}

- (UITextField*)choseQuestionTextField
{
    if (!_choseQuestionTextField) {
        _choseQuestionTextField = [[UITextField alloc] init];
        _choseQuestionTextField.font = kFont32;
        _choseQuestionTextField.placeholder = kLocalized(@"GYSetting_Set_Select_Question");
        _choseQuestionTextField.borderStyle = UITextBorderStyleLine;
        _choseQuestionTextField.leftViewMode = UITextFieldViewModeAlways;
        _choseQuestionTextField.rightViewMode = UITextFieldViewModeAlways;
        _choseQuestionTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _choseQuestionTextField.delegate = self;
        UIImageView* choseQuestionLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(20), kDeviceProportion(40))];
        _choseQuestionTextField.leftView = choseQuestionLeftView;
        UIImageView* inputAnswerRightView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(40), kDeviceProportion(40))];
        inputAnswerRightView.image = [UIImage imageNamed:@"gycom_blue_pullDowm"];
        inputAnswerRightView.userInteractionEnabled = YES;
        inputAnswerRightView.multipleTouchEnabled = YES;
        inputAnswerRightView.contentMode = UIViewContentModeCenter;
        _choseQuestionTextField.rightView = inputAnswerRightView;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [_choseQuestionTextField addGestureRecognizer:tap];
    }
    return _choseQuestionTextField;
}

- (UITextField*)inputAnswerTextField
{
    if (!_inputAnswerTextField) {
        _inputAnswerTextField = [[UITextField alloc] init];
        _inputAnswerTextField.delegate = self;
        _inputAnswerTextField.font = kFont32;
        _inputAnswerTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _inputAnswerTextField.placeholder = kLocalized(@"GYSetting_Set_Please_Input_Answer");
        _inputAnswerTextField.borderStyle = UITextBorderStyleLine;
        _inputAnswerTextField.leftViewMode = UITextFieldViewModeAlways;
        _inputAnswerTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        UIImageView* inputAnswerLeftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(20), kDeviceProportion(40))];
        _inputAnswerTextField.leftView = inputAnswerLeftView;
    }
    return _inputAnswerTextField;
}

- (UILabel*)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.numberOfLines = 0;
        NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYSetting_Set_Tip_Answer")
                                                                                      attributes:@{ NSFontAttributeName : kFont32,
                                                                                                    NSForegroundColorAttributeName : kGray333333 }];
        [attString setAttributes:@{ NSForegroundColorAttributeName : kRedE50012,
                                    NSFontAttributeName : kFont32 }
                           range:NSMakeRange(0, 5)];
        _tipLabel.attributedText = attString;
    }
    return _tipLabel;
}


@end
