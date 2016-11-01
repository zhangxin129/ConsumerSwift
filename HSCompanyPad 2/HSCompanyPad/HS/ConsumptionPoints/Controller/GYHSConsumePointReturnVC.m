//
//  GYHSConsumePointReturnVC.m
//
//  Created by apple on 16/9/8.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumePointReturnVC.h"
#import "GYHSPointInputView.h"
#import "GYHSPayKeyView.h"
#import "UITextField+GYHSPointTextField.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSConsumeReturnListCell.h"
#import "GYHSPointReturnModel.h"
#import "GYHSPointHttpTool.h"
#import <MJExtension/MJExtension.h>
#import "GYHSPointPassInputView.h"
#import "GYTextField.h"
#import "GYHSPublicMethod.h"
#import "GYPointTool.h"
#import "GYUtils+companyPad.h"
#import "NSDecimalNumber+GYPOSDecimalNumber.h"
#import "GYPOSService.h"
#import <GYKit/UIButton+GYExtension.h>
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYCardReaderModel.h"
#import <YYKit/YYTextKeyboardManager.h>
static NSString* consumeReturnListCellID = @"GYHSConsumeReturnListCell";
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define kCellHeight kDeviceProportion(186)
@interface GYHSConsumePointReturnVC ()<GYHSPointInputDelegate,GYHSPayKeyDelegate,UITextFieldDelegate,GYHSCodeReaderDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, weak) GYHSPointInputView* cardView;
@property (nonatomic, weak) GYHSPayKeyView* keyView;
@property (nonatomic, strong) UITextField* selectField;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* returnDataArray;  //线下退货数据源
@property (nonatomic, strong) GYHSPointReturnModel* selectModel;
@property (nonatomic, strong) UIView *testView;
@property (nonnull, strong) UIView *mainView;
@property (nonatomic, strong) GYHSPointPassInputView* inputPasswordView;
@property (nonatomic, strong) GYTextField *moneyTextField;
@property (nonatomic, strong) UILabel *timeLable;
@property (nonatomic, strong) UILabel *orderNoLable;
@property (nonatomic, strong) UILabel *conAccountLable;
@property (nonatomic, strong) UILabel *actAccountLable;
@property (nonatomic, strong) UILabel *pointRateLable;
@property (nonatomic, strong) UILabel *disPointLable;
@property (nonatomic, copy) NSString *sourceTransNo;
@property (nonatomic, strong) UILabel *returnPointLable;
@property (nonatomic, strong) GYHSPointReturnModel *dealModel;
// 批次号和终端流水号
@property (nonatomic, strong) GYPOSBatchModel* BatchNoAndPosRunCodeModel;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码
@end

@implementation GYHSConsumePointReturnVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Point_Consume_Return");
    @weakify(self);
    [self loadInitViewType:GYStopTypeAll :^{
        @strongify(self);
        [self initView];
        [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
        // 得到交易密码
        [kDefaultNotificationCenter addObserver:self selector:@selector(backInfo:) name:GYPOSShounldInputLoginPasswordNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];

    }];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.inputPasswordView.passField.userInteractionEnabled = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
     [kDefaultNotificationCenter  removeObserver:self];
    
}
/**
 *  set方法获取选中的数据模型并赋值
 */
- (void)setSelectModel:(GYHSPointReturnModel *)selectModel{
    _selectModel = selectModel;
    self.timeLable.text = selectModel.sourceTransDate;
    self.orderNoLable.text = selectModel.sourceTransNo;
    self.conAccountLable.text = [GYHSPublicMethod keepTwoDecimal:selectModel.transAmount];
    self.actAccountLable.text = [GYHSPublicMethod keepTwoDecimal:selectModel.orderAmount];
    self.pointRateLable.text = selectModel.pointRate;
    self.disPointLable.text = [GYHSPublicMethod keepTwoDecimal:selectModel.perPoint];
    self.dealModel = selectModel;
}

#pragma mark - private methods
/**
 *  创建视图
 */
- (void)initView
{
    self.title = kLocalized(@"GYHS_Point_return_PointReturn");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    //互生卡行
    GYHSPointInputView* cardView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_payment_card" placeholder:kLocalized(@"GYHS_Point_Swipe_Input_Number")];
    cardView.isShowRightView = YES;
    cardView.textfield.delegate = self;
    cardView.delegate = self;
    [cardView.textfield becomeFirstResponder  ];
    [self.view addSubview:cardView];
    self.cardView = cardView;
    
    //键盘
    GYHSPayKeyView* keyView = [[GYHSPayKeyView alloc] init];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    self.keyView = keyView;
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view).offset(CGRectGetMaxX(self.cardView.frame) + kLetfwidth);
    }];

    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kLetfwidth);
        make.top.equalTo(self.keyView).offset(100);
        make.width.mas_equalTo(kInputViewWidth);
        make.bottom.equalTo(self.view).offset(kLetfwidth);
    }];

    UIView *testView = [[UIView alloc] init];
    [self.view addSubview:testView];
    [testView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kLetfwidth);
        make.top.equalTo(self.keyView).offset(90);
        make.width.mas_equalTo(kInputViewWidth);
        make.height.mas_equalTo(kDeviceProportion(kScreenHeight - 90));
    }];
    self.testView = testView;
    self.testView.hidden = YES;
    
    UIView *plainView = [[UIView alloc] init];
    plainView.backgroundColor = kWhiteFFFFFF;
    [self.testView addSubview:plainView];
    [plainView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kLetfwidth);
        make.top.equalTo(self.testView).offset(0);
        make.width.mas_equalTo(kInputViewWidth);
        make.height.mas_equalTo(kDeviceProportion(185));
    }];
    
    NSArray *titleArr = @[kLocalized(@"GYHS_Point_return_OrderSerialNumber"),kLocalized(@"GYHS_Point_return_ConsumptionAmount"),kLocalized(@"GYHS_Point_return_RealCash"),kLocalized(@"GYHS_Point_return_PointRate"),kLocalized(@"GYHS_Point_return_DistributionPoints")];
    for (int i = 0; i < titleArr.count; i ++) {
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30 * i + 1 * i, kDeviceProportion(110), kDeviceProportion(30))];
        titleLable.text = titleArr[i];
        titleLable.textColor = kGray666666;
        titleLable.font = kFont24;
        [plainView addSubview: titleLable];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30 * i + 30, kDeviceProportion(kInputViewWidth), kDeviceProportion(1))];
        lineView.backgroundColor = [UIColor lightGrayColor];
        [plainView addSubview:lineView];
        
        
    }
    
       UILabel *conAccountLable = [[UILabel alloc] initWithFrame:CGRectMake(kInputViewWidth - 170, 31, kDeviceProportion(150), kDeviceProportion(30))];
        conAccountLable.textColor = kGray333333;
        conAccountLable.font = kFont24;
        conAccountLable.textAlignment = NSTextAlignmentRight;
        [plainView addSubview:conAccountLable];
        self.conAccountLable = conAccountLable;

    
    UILabel *actAccountLable = [[UILabel alloc] initWithFrame:CGRectMake(kInputViewWidth - 170, 62, kDeviceProportion(150), kDeviceProportion(30))];
    actAccountLable.textColor = kGray333333;
    actAccountLable.font = kFont24;
    actAccountLable.textAlignment = NSTextAlignmentRight;
    [plainView addSubview:actAccountLable];
    self.actAccountLable = actAccountLable;
    
    UILabel *pointRateLable = [[UILabel alloc] initWithFrame:CGRectMake(kInputViewWidth - 170, 93, kDeviceProportion(150), kDeviceProportion(30))];
    pointRateLable.textColor = kGray333333;
    pointRateLable.font = kFont24;
    pointRateLable.textAlignment = NSTextAlignmentRight;
    [plainView addSubview:pointRateLable];
    self.pointRateLable = pointRateLable;
    
    UILabel *disPointLable = [[UILabel alloc] initWithFrame:CGRectMake(kInputViewWidth - 170, 124, kDeviceProportion(150), kDeviceProportion(30))];
    disPointLable.textColor = kGray333333;
    disPointLable.font = kFont24;
    disPointLable.textAlignment = NSTextAlignmentRight;
    [plainView addSubview:disPointLable];
    self.disPointLable = disPointLable;
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 185 - 30, kDeviceProportion(150), kDeviceProportion(30))];
    timeLable.textColor = kGray666666;
    timeLable.font = kFont24;
    [plainView addSubview:timeLable];
    self.timeLable = timeLable;
    
    UILabel *orderNoLable = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, kDeviceProportion(150), kDeviceProportion(30))];
    orderNoLable.textColor = kGray333333;
    orderNoLable.font = kFont24;
    [plainView addSubview:orderNoLable];
    self.orderNoLable = orderNoLable;
    
    
    UIView *returnMoneyView = [[UIView alloc] init];
    returnMoneyView.backgroundColor = kWhiteFFFFFF;
    [self.testView addSubview:returnMoneyView];
    [returnMoneyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.testView).offset(0);
        make.top.equalTo(self.testView).offset(185 + 20);
        make.width.mas_equalTo(kInputViewWidth);
        make.height.mas_equalTo(kDeviceProportion(31));
    }];
    UILabel *returnMoneyLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kDeviceProportion(60), kDeviceProportion(20))];
    returnMoneyLable.text = kLocalized(@"GYHS_Point_return_ReturnAmount");
    returnMoneyLable.textColor = kGray666666;
    returnMoneyLable.font = kFont24;
    returnMoneyLable.textAlignment = NSTextAlignmentLeft;
    [returnMoneyView addSubview:returnMoneyLable];
    
    _moneyTextField = [[GYTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(returnMoneyLable.frame) + 10, 5, kDeviceProportion(150), kDeviceProportion(20))];
    _moneyTextField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    _moneyTextField.delegate = self;
    _moneyTextField.placeholder = kLocalized(@"GYHS_Point_return_InputReturnAmount");
    [returnMoneyView addSubview:_moneyTextField];
    UIView *reLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kDeviceProportion(kInputViewWidth), kDeviceProportion(1))];
    reLineView.backgroundColor = kGrayDDDDDD;
    [returnMoneyView addSubview:reLineView];
    
    self.mainView = [[UIView alloc] init];
    self.mainView.backgroundColor = kWhiteFFFFFF;
    [self.testView addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.testView).offset(0);
        make.top.equalTo(self.testView).offset(185 + 20 + 31);
        make.width.mas_equalTo(kInputViewWidth);
        make.height.mas_equalTo(kDeviceProportion(121));
    }];
    self.mainView.hidden = YES;

    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, kDeviceProportion(60), kDeviceProportion(20))];
    lable.text = kLocalized(@"GYHS_Point_return_ReturnPointsNumber");
    lable.textColor = kGray666666;
    lable.font = kFont24;
    lable.textAlignment = NSTextAlignmentLeft;
    [self.mainView addSubview:lable];
    
    _returnPointLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lable.frame) + 10, 5, kDeviceProportion(60), kDeviceProportion(20))];
    _returnPointLable.textColor = kGray333333;
    _returnPointLable.font = kFont24;
    _returnPointLable.textAlignment = NSTextAlignmentLeft;
    _returnPointLable.text = @"0.00";
    [self.mainView addSubview:_returnPointLable];
        
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, kDeviceProportion(kInputViewWidth), kDeviceProportion(1))];
    lineView.backgroundColor = kGrayDDDDDD;
    [self.mainView addSubview:lineView];
    
    UILabel *tipsLable = [[UILabel alloc] init];
    tipsLable.numberOfLines = 0;
    NSString *tipsStr = [NSString stringWithFormat:@"%@\n%@%@\n%@%@", kLocalized(@"GYHS_Point_return_Tips"),@"*",kLocalized(@"GYHS_Point_return_Tips1"),@"*",kLocalized(@"GYHS_Point_return_Tips2")];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineSpacing = 10;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tipsStr attributes:@{NSFontAttributeName : kFont24, NSForegroundColorAttributeName : kGray666666 ,NSParagraphStyleAttributeName:paragraphStyle}];
    
    NSRange range1 = [tipsStr rangeOfString:@"*" options:NSCaseInsensitiveSearch];
    [text addAttributes:@{ NSFontAttributeName : kFont24, NSForegroundColorAttributeName : kRedE50012 } range:range1];
    NSRange range2 = [tipsStr rangeOfString:@"*" options:NSBackwardsSearch];
    [text addAttributes:@{ NSFontAttributeName : kFont24, NSForegroundColorAttributeName : kRedE50012 } range:range2];
    
    tipsLable.attributedText = text;
    [self.mainView addSubview:tipsLable];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.mainView).offset(10);
        make.top.equalTo(self.mainView).offset(31);
        make.width.mas_equalTo(kDeviceProportion(kInputViewWidth - 10));
        make.height.mas_equalTo(kDeviceProportion(90));
    }];
    
    _inputPasswordView = [[GYHSPointPassInputView alloc] initWithFrame:CGRectMake(0, 186 + 10 + 152 + 10 + 20, kDeviceProportion(kInputViewWidth), kDeviceProportion(40)) type:kPasswordLogin];
    _inputPasswordView.layer.borderColor = kGrayDDDDDD.CGColor;
    _inputPasswordView.layer.borderWidth = 1.0f;
    _inputPasswordView.passField.delegate = self;
    [self.testView addSubview:_inputPasswordView];
    _inputPasswordView.hidden = YES;
    
    @weakify(self);
    self.inputPasswordView.passField.userInteractionEnabled = NO;
    UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id _Nonnull sender) {
        @strongify(self);
        if (![self.POSService.posInfo isConnected]) {
            self.inputPasswordView.passField.userInteractionEnabled = YES;
            [self.inputPasswordView.passField becomeFirstResponder];
            
        } else {
            @strongify(self);
            if (![self isDataAllright]) {
                return ;
            }
            if (self.selectModel == nil) {
                [GYUtils showToast:kLocalized(@"GYHS_Point_Select_Cancel_List")];
                return;
            }
            [self.selectField resignFirstResponder];
            [self selectView:self.inputPasswordView];
            [self.POSService inputPwdWithPwdLength:6];
        }
        
    }];
    [self.inputPasswordView addGestureRecognizer:tap];

}


#pragma mark - GYHSPayKeyDelegate
/**
 *  处理各输入框的赋值
 *
 */
- (void)keyPayAddWithString:(NSString*)string
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Point_Select_Edit_Field")];
        return;
    }
    self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
    if (self.selectField == self.cardView.textfield) {
        self.cardModel = nil;
        self.selectField.text = [self.selectField inputCardField];
    }else if (self.selectField == self.inputPasswordView.passField) {
        self.selectField.text = [self.selectField subLoginField];
    }else if (self.selectField == self.moneyTextField){
        self.selectField.text = [self.selectField inputEditField];
        if (self.selectField.text.length) {
//            self.selectField.text = [GYUtils transPOSAmount:self.selectField.text];
            NSString* strHSMoney = [NSString stringWithFormat:@"%lf", [self.selectField.text doubleValue] * [ globalData.config.currencyToHsbRate doubleValue]];
            //    退款金额小于实付金额：=退款金额 * 积分比例 /2 用进一法
            //    退款金额等于实付金额：
            //    =原分配积分数
            //实付金额
            NSString * realStr = [GYUtils transPOSAmount:self.dealModel.transAmount];
            if([self.selectField.text isEqualToString:realStr]){
                
                _returnPointLable.text = [GYUtils transPOSAmount:self.dealModel.perPoint];
            }else
            {
                NSDecimalNumber * pointDeciamal = [[NSDecimalNumber decimalNumberWithString:strHSMoney] operatDecimal:[NSDecimalNumber decimalNumberWithString:self.dealModel.pointRate] type:kDecimalMultiplication];
                pointDeciamal = [pointDeciamal roundCustomedScale:2 mode:NSRoundDown];
                pointDeciamal = [pointDeciamal operatDecimal:[NSDecimalNumber decimalNumberWithString:@"0.50"] type:kDecimalMultiplication];
                pointDeciamal = [pointDeciamal roundCustomedScale:2 mode:NSRoundUp];
                _returnPointLable.text = [GYUtils transPOSAmount:pointDeciamal.stringValue];
            }
        }
    }

}

- (void)keyPayDeleteWithString
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Point_Select_Edit_Field")];
        return;
    }
    if (self.selectField.text.length > 0) {
        self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
        if (self.selectField == self.cardView.textfield) {
            self.cardModel = nil;
            [self clearUI];
            self.tableView.hidden = YES;
//            self.inputPasswordView.passField.text = @"";
            self.inputPasswordView.hidden = YES;
            self.selectField.text = [self.selectField inputCardField];
            
        }else if (self.selectField == self.inputPasswordView.passField) {
            self.selectField.text = [self.selectField subLoginField];
        }else if (self.selectField == self.moneyTextField){
            self.selectField.text = [self.selectField inputEditField];
            

        }
    }

}
/**
 *  处理自定义键盘上按键的操作
 *
 */
- (void)keyClick:(NSInteger)index
{
    if (index == 0) {
        //清除
        self.cardView.textfield.text = @"";
        [self deleteView:(UIView*)[self.selectField superview]];
        self.selectField = nil;
        self.tableView.hidden = YES;
        self.inputPasswordView.hidden = YES;
    } else {
        //点击ok
        if (self.tableView.hidden) {
            self.tableView.hidden = NO;
            [self requestData];
        }
        if(self.selectField == self.inputPasswordView.passField){
            self.tableView.hidden = YES;
            if (self.selectModel == nil) {
                [GYUtils showToast:kLocalized(@"GYHS_Point_Select_Cancel_List")];
                return;
            }
            if (self.inputPasswordView.passField.text.length != 6) {
                [self.inputPasswordView.passField tipWithContent:kLocalized(@"GYHS_Point_Consume_Input_Login_Passwd") animated:YES];
                return;
            }
            @weakify(self);
            [GYAlertView alertWithTitle:kLocalized(@"GYHS_Point_Tip")
                                Message:kLocalized(@"GYHS_Point_Sure_Consume_Return")
                               topColor:TopColorBlue
                           comfirmBlock:^{
                               @strongify(self);
                               [self.keyView.sureBtn controlTimeOut];
                               //进行撤单
                               [self requestReturn];
                           }];
        }else if (self.selectField == self.moneyTextField)
            self.tableView.hidden = YES;
    }
}

#pragma mark - GYHSPointInputDelegate
/**
 *  处理刷卡和扫一扫的事件
 *
 */
- (void)clickRightAction:(NSInteger)index
{
    if (index == 1) {
        [[GYPOSService sharedInstance] swipingCard];
        self.inputPasswordView.passField.userInteractionEnabled = NO;
    } else {
        //扫一扫
        GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
        codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
        codeReaderVC.delegate = self;
        [self.navigationController pushViewController:codeReaderVC animated:YES];

    }
}
#pragma mark - request
/**
 *  查询消费积分退货列表数据的网络请求
 */
- (void)requestData
{
    @weakify(self);
    if (![self isDataAllright]) {
        return;
    }
    //互生卡
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString* locationString = [dateformatter stringFromDate:nowDate];

    [GYHSPointHttpTool checkPointWithEntCustId:globalData.loginModel.entCustId hsResNo:cardStr startDate:locationString businessType:@"12" curPage:@"1" pageSize:@"10000" success:^(id responsObject) {
        @strongify(self);
        [self.returnDataArray removeAllObjects];
        if (responsObject[GYNetWorkDataKey]) {
            NSArray * array = responsObject[GYNetWorkDataKey];
            for (NSDictionary * temp in array) {
                GYHSPointReturnModel *model = [GYHSPointReturnModel mj_objectWithKeyValues:temp];
                [self.returnDataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        
    } failure:^{
        
    }];

}
/**
 *  消费积分退货的网络请求
 */
- (void)requestReturn{
    NSString * equipmentNo;
    NSString * equipmentType;
    if (self.cardModel.CipherNum.length) {
        equipmentNo = self.posInfo.posId;
        equipmentType = GYPOSDeviceCardReader;
    }else{
        NSUUID* deviceUDID = [[UIDevice currentDevice] identifierForVendor];
        NSString* strUDID = [deviceUDID UUIDString];
        strUDID = [strUDID substringToIndex:18];
        equipmentNo = strUDID;
        equipmentType = GYPOSDeviceMoblie;
    }

    @weakify(self);
    [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSString* sourceTransNo = responsObject;
        NSString* transType = [self.dealModel.transType stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"2"];
        NSString* transAmount = [NSString stringWithFormat:@"%.2f", [self.moneyTextField.text doubleValue] * [globalData.config.currencyToHsbRate doubleValue]];
        [GYHSPointHttpTool returnGoodsWithOldTransNo:self.dealModel.sourceTransNo sourceTransNo:sourceTransNo sourceTransAmount:self.moneyTextField.text transAmount:transAmount termRunCode:self.BatchNoAndPosRunCodeModel.posRunCode equipmentNo:equipmentNo secretCode:@"" transPwd:self.inputPasswordView.passField.text transType:transType perResNo:self.dealModel.perResNo strBatchNo:self.BatchNoAndPosRunCodeModel.batchNo success:^(id responsObject) {
            if (kHTTPSuccessResponse(responsObject)) {
                
                [GYUtils showToast:kLocalized(@"GYHS_Point_return_ReturnSuccess")];
            } else {
                
                [GYUtils showToast:kLocalized(@"GYHS_Point_return_ReturnFail")];
                self.inputPasswordView.passField.text = nil;
                NSString* transTypeRevo = [transType substringFromIndex:1];
                transTypeRevo = [transTypeRevo stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"1"];
                [GYHSPointHttpTool correctWithTransType:transTypeRevo
                                                              transNo:self.dealModel.transNo
                                                         returnReason:kLocalized(@"GYHS_Point_return_ReturnCorrect")
                                                       equitpmentType:equipmentType
                                                             initiate:@"MOBILE"
                                                          termRunCode:self.BatchNoAndPosRunCodeModel.posRunCode
                                                             perResNo:self.dealModel.perResNo
                                                          equipmentNo:equipmentNo
                                                           secretCode:self.dealModel.strCipherNum ? self.dealModel.strCipherNum:@""
                                                        sourceBatchNo:self.BatchNoAndPosRunCodeModel.batchNo
                                                              success:^(id responsObject) {
                                                              }
                                                              failure:^{
                                                            }];

            }
        } failure:^{
            self.inputPasswordView.passField.text = nil;
        }];
    } failure:^{
        
    }];


}
#pragma mark - 获取8位交易密码
- (void)backInfo:(NSNotification*)notice
{
    if ([[notice name] isEqualToString:GYPOSShounldInputLoginPasswordNotification]) {
        self.inputPasswordView.passField.text = [notice object];
        [self requestReturn];
    }
}

#pragma mark - 键盘显示通知
- (void)keyboardWillShow:(NSNotification*)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

/**判断数据是否正确*/
- (BOOL)isDataAllright
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Point_Select_Edit_Field")];
        return NO;
    }
    
    
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    if (![GYUtils isHSCardNo:cardStr]) {
        [self.cardView.textfield tipWithContent:kLocalized(@"GYHS_Point_Input_Number_Error_Tip") animated:YES];
        [self.cardView.textfield becomeFirstResponder];
        return NO;
    }

    return YES;
}



- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [self deleteView:self.inputPasswordView];
    [self selectView:(UIView*)[textField superview]];
    self.selectField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self deleteView:(UIView*)[textField superview]];
    
}

- (void)selectView:(UIView*)selectView
{
    selectView.layer.borderWidth = 1;
    selectView.layer.borderColor = [[UIColor redColor] CGColor];
}


- (void)deleteView:(UIView*)deleteView
{
    deleteView.layer.borderWidth = 0;
    deleteView.layer.borderColor = [[UIColor clearColor] CGColor];
}

#pragma mark - 处理刷卡器相关
- (void)getHsCardNumber:(NSNotification*)notice
{
    NSString* cardNumAndCipher = [notice object];
    if (cardNumAndCipher && cardNumAndCipher.length > 0) {
        NSArray* arrCardAndCipher = [cardNumAndCipher componentsSeparatedByString:@","];
        if (arrCardAndCipher.count == 2 ) { //当刷卡信息置空的时候赋值
            
            self.cardView.textfield.text = [GYUtils formatCardNo:arrCardAndCipher.firstObject];
//            [self.cardView.textfield inputCardField];
            [self clearUI];
            self.cardModel.HSCardNum = arrCardAndCipher[0];
            self.cardModel.CipherNum = arrCardAndCipher[1];
        }
    }
}

#pragma mark - 清空页面
- (void)clearUI
{
    if (self.returnDataArray.count > 1){
        [self.returnDataArray removeAllObjects];
        [self.tableView reloadData];
    }
    self.tableView.hidden = YES;
    self.inputPasswordView.passField.text = @"";
    self.inputPasswordView.hidden = YES;
    self.testView.hidden = YES;
    self.mainView.hidden = YES;
    [self.cardView.textfield becomeFirstResponder];
    
}


#pragma mark - GYHSCodeReaderDelegate
- (void)reader:(GYHSCodeReaderViewController*)reader didScanResult:(NSString*)result
{
    if ([GYUtils isPointCode:result]) {
        self.cardView.textfield.text = [GYUtils formatCardNo:[GYUtils PointCode:result]];
        [self clearUI];
        [reader.navigationController popViewControllerAnimated:YES];
    }else{
        [reader startScanning];
    }

}
#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
   
    return self.returnDataArray.count;
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSConsumeReturnListCell * cell = [tableView dequeueReusableCellWithIdentifier:consumeReturnListCellID forIndexPath:indexPath];
    cell.model = self.returnDataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    
        self.selectModel = self.returnDataArray[indexPath.section];
        self.tableView.hidden = YES;
        self.testView.hidden = NO;
        self.mainView.hidden = NO;
        self.inputPasswordView.hidden = NO;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    
    return 5.0f;
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = kCellHeight;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSConsumeReturnListCell class]) bundle:nil] forCellReuseIdentifier:consumeReturnListCellID];
    }
    return _tableView;
}


- (NSMutableArray *)returnDataArray{
    if (!_returnDataArray) {
        _returnDataArray = [[NSMutableArray alloc] init];
    }
    return _returnDataArray;
}

- (GYPOSBatchModel*)BatchNoAndPosRunCodeModel
{
    if (_BatchNoAndPosRunCodeModel == nil) {
        _BatchNoAndPosRunCodeModel = [GYPOSBatchModel shareInstance];
    }
    return _BatchNoAndPosRunCodeModel;
}

- (GYCardReaderModel*)posInfo
{
    _posInfo = self.POSService.posInfo;
    return _posInfo;
}

- (GYPOSService*)POSService
{
    if (_POSService == nil) {
        _POSService = [GYPOSService sharedInstance];
    }
    return _POSService;
}
- (GYCardInfoModel *)cardModel
{
    if (_cardModel == nil) {
        _cardModel = [[GYCardInfoModel alloc]init];
    }
    return _cardModel;
}

@end
