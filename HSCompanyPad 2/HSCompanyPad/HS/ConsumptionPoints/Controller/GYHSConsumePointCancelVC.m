//
//  GYHSConsumePointCancelVC.m
//
//  Created by apple on 16/8/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumePointCancelVC.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSConsumeCancelListCell.h"
#import "GYHSEdgeLabel.h"
#import "GYHSPayKeyView.h"
#import "GYHSPointCancelModel.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointInputView.h"
#import "GYHSPointPassInputView.h"
#import "GYHSPublicMethod.h"
#import "GYPointTool.h"
#import "GYPOSService.h"
#import "GYCardReaderModel.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import "UITextField+GYHSPointTextField.h"
#import "GYTextField.h"
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYPOSService.h"
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define KLineHeight kDeviceProportion(3)
#define kCellHeight kDeviceProportion(123)
#define kTipHeight kDeviceProportion(30)

@interface GYHSConsumePointCancelVC () <UITextFieldDelegate, GYHSPayKeyDelegate, UITableViewDataSource, UITableViewDelegate, GYHSPointInputDelegate, GYHSCodeReaderDelegate>
@property (nonatomic, weak) GYHSPointInputView* cardView;
@property (nonatomic, weak) GYHSPayKeyView* keyView;
@property (nonatomic, strong) UITextField* selectField;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) GYHSPointPassInputView* passwordView;
@property (nonatomic, strong) GYHSPointCancelModel* selectModel; //所选撤单单子
@property (nonatomic, strong) GYPOSBatchModel* batchModel; // 批次号和终端流水号
@property (nonatomic, strong) GYPointTool* pointTool; /**积分获取工具*/
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isDown;

@end

@implementation GYHSConsumePointCancelVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_Point_Consume_Cancel");
    @weakify(self);
    [self loadInitViewType:GYStopTypeAll :^{
        @strongify(self);
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
        [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
        // 得到交易密码
        [kDefaultNotificationCenter addObserver:self selector:@selector(backInfo:) name:GYPOSShounldInputLoginPasswordNotification object:nil];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.passwordView.passField.userInteractionEnabled = NO;
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
     [kDefaultNotificationCenter  removeObserver:self];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Point_Consume_Cancel");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    //互生卡行
    GYHSPointInputView* cardView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_payment_card" placeholder:kLocalized(@"GYHS_Point_Swipe_Input_Number")];
    cardView.textfield.delegate = self;
    cardView.isShowRightView = YES;
    cardView.delegate = self;
    [cardView.textfield becomeFirstResponder];
    [self.view addSubview:cardView];
    self.cardView = cardView;
    
    //温馨提示
    GYHSEdgeLabel* tipLabel = [[GYHSEdgeLabel alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.cardView.frame) + 1, kInputViewWidth, kTipHeight)];
    tipLabel.backgroundColor = [UIColor whiteColor];
    tipLabel.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    NSString* tipString = kLocalized(@"GYHS_Point_Only_Cancel_Tip");
    NSMutableAttributedString* placeholder = [[NSMutableAttributedString alloc] initWithString:tipString attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGrayCCCCCC }];
    NSRange range = [tipString rangeOfString:@"＊"];
    if (range.location != NSNotFound) {
        [placeholder addAttribute:NSForegroundColorAttributeName value:kRedE40011 range:NSMakeRange(range.location, range.length)];
    }
    
    tipLabel.attributedText = placeholder;
    [self.view addSubview:tipLabel];
    
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
        make.top.equalTo(tipLabel).offset(KLineHeight + CGRectGetHeight(tipLabel.frame));
        make.width.mas_equalTo(kInputViewWidth);
        make.bottom.equalTo(self.view).offset(-2 * kLetfwidth - kCommonHeight);
    }];
    
    //输入密码行
    GYHSPointPassInputView* passwordView = [[GYHSPointPassInputView alloc] initWithFrame:CGRectMake(kLetfwidth, self.view.height - kLetfwidth - kCommonHeight - kMainHeadHeight, kInputViewWidth, kCommonHeight) type:kPasswordLogin];
    passwordView.passField.delegate = self;
    passwordView.hidden = YES;
    [self.view addSubview:passwordView];
    self.passwordView = passwordView;
    
    @weakify(self);
    self.passwordView.passField.userInteractionEnabled = NO;
    UIGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id _Nonnull sender) {
        @strongify(self);
        if (![self.POSService.posInfo isConnected]) {
            self.passwordView.passField.userInteractionEnabled = YES;
            [self.passwordView.passField becomeFirstResponder];
            
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
            [self selectView:self.passwordView];
            [self.POSService inputPwdWithPwdLength:6];
        }
        
    }];
    [self.passwordView addGestureRecognizer:tap];

}
#pragma mark - GYHSPayKeyDelegate
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
    }
    else if (self.selectField == self.passwordView.passField) {
        self.selectField.text = [self.selectField subLoginField];
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
            self.selectField.text = [self.selectField inputCardField];
        }
        else if (self.selectField == self.passwordView.passField) {
            self.selectField.text = [self.selectField subLoginField];
        }
    }
}

- (void)keyClick:(NSInteger)index
{
    if (index == 0) {
        //清除
        self.cardView.textfield.text = @"";
        [self clearUI];
    }
    else {
        //点击ok
        if ([self isDataAllright]) {
            if (self.tableView.hidden) {
                self.tableView.hidden = NO;
                [self addRefreshView];
            }
            else {
                if (self.dataArray.count < 1) {
                    [GYUtils showToast:kLocalized(@"GYHS_Point_No_Canel_List")];
                    return;
                }
                if (self.selectModel == nil) {
                    [GYUtils showToast:kLocalized(@"GYHS_Point_Select_Cancel_List")];
                    return;
                }
                if (self.passwordView.passField.text.length != 6) {
                    [self.passwordView.passField tipWithContent:kLocalized(@"GYHS_Point_Consume_Input_Login_Passwd") animated:YES];
                    return;
                }
                [GYAlertView alertWithTitle:kLocalized(@"GYHS_Point_Tip")
                                    Message:kLocalized(@"GYHS_Point_Sure_Consume_Cancel")
                                   topColor:TopColorBlue
                               comfirmBlock:^{
                                   //进行撤单
                                   [self submitRequest];
                               }];
            }
            [self.keyView.sureBtn controlTimeOut];
        }
    }
}

#pragma mark - 数据是否正确
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

#pragma mark - GYHSPointInputDelegate
- (void)clickRightAction:(NSInteger)index
{
    [self.cardView.textfield becomeFirstResponder];
    if (index == 1) {
           [[GYPOSService sharedInstance] swipingCard];
        self.passwordView.passField.userInteractionEnabled = NO;
    }
    else {
        //扫一扫
        GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
        codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
        codeReaderVC.delegate = self;
        [self.navigationController pushViewController:codeReaderVC animated:YES];
    }
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

#pragma mark -refresh
- (void)addRefreshView
{
    self.page = 1;
    self.pageSize = 10;
    
    @weakify(self);
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = YES;
        self.page = 1;
        [self requestData];
    }];
    
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.isDown = NO;
        self.page++;
        [self requestData];
        
    }];
    
    self.tableView.mj_footer = footer;
}

- (void)endRefresh
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - request
- (void)requestData
{
    @weakify(self);
    //互生卡
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    //业务类型（11：查询撤单，12：查询退货）
    NSDate* nowDate = [NSDate date];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString* locationString = [dateformatter stringFromDate:nowDate];
    [GYHSPointHttpTool checkPointWithEntCustId:globalData.loginModel.entCustId
        hsResNo:cardStr
        startDate:locationString
        businessType:@"11"
        curPage:[@(self.page) stringValue]
        pageSize:[@(self.pageSize) stringValue]
        success:^(id responsObject) {
            @strongify(self);
            if (self.isDown) {
                [self.dataArray removeAllObjects];
            }
            if (responsObject[GYNetWorkDataKey]) {
                NSArray* array = responsObject[GYNetWorkDataKey];
                for (NSDictionary* temp in array) {
                    GYHSPointCancelModel* model = [[GYHSPointCancelModel alloc] initWithDictionary:temp error:nil];
                    [self.dataArray addObject:model];
                }
            }
            self.selectModel = nil;
            [self.tableView reloadData];
            [self endRefresh];
            
        }
        failure:^{
            [self endRefresh];
            
        }];
}

#pragma mark - 撤单
- (void)submitRequest
{
    NSString* equipmentNo;
    NSString* equipmentType;
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
    NSString* transType = [self.selectModel.transType stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"1"]; //第四位为1的时候为撤单 详细参考transType对应表格
    [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSString* sourceTransNo = responsObject;
        //互生卡号
        NSString* cardStr = [self.cardView.textfield deleteSpaceField];
        [GYHSPointHttpTool cancelEarnestWithOldTransNo:self.selectModel.sourceTransNo
                                         sourceTransNo:sourceTransNo
                                         sourceTransDt:self.selectModel.sourceTransDate
                                           termRunCode:self.batchModel.posRunCode
                                             ecretCode:@""
                                              transPwd:self.passwordView.passField.text
                                             transType:transType
                                              perResNo:cardStr
                                           equipmentNo:equipmentNo
                                         sourceBatchNo:self.batchModel.batchNo
                                                  frag:@"0"
                                               success:^(id responsObject) {
                                                   if (kHTTPSuccessResponse(responsObject)) {
                                                       [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Consume_Cancel_Success")
                                                                                         topColor:TopColorBlue
                                                                                     comfirmBlock:^{
                                                                                         self.isDown = YES;
                                                                                         self.passwordView.passField.text = @"";
                                                                                         self.page = 1;
                                                            [self requestData];
                                                                                     }];
                                                   } else {
                                                       [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Point_Consume_Cancel_Fail")
                                                                                         topColor:TopColorRed
                                                                                     comfirmBlock:^{
                                                                                     }];
                                                       NSString* transTypeRevove = [transType substringFromIndex:1];
                                                       transTypeRevove = [transTypeRevove stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"1"];
                                                       [GYHSPointHttpTool correctWithTransType:transTypeRevove
                                                                                       transNo:sourceTransNo
                                                                                  returnReason:kLocalized(@"GYHS_Point_Consume_Cancel_Correct")
                                                                                equitpmentType:equipmentType
                                                                                      initiate:@"MOBILE"
                                                                                   termRunCode:self.batchModel.posRunCode
                                                                                      perResNo:cardStr
                                                                                   equipmentNo:equipmentNo
                                                                                    secretCode:@""
                                                                                 sourceBatchNo:self.batchModel.batchNo
                                                                                       success:^(id responsObject) {
                                                                                       
                                                                                       }
                                                                                       failure:^{
                                                                                       
                                                                                       }];
                                                   }
                                               }
                                               failure:^{
                                                   self.passwordView.passField.text = nil;
                                               }];
    }
        failure:^{
        
        }];
}

#pragma mark - 键盘显示通知
- (void)keyboardWillShow:(NSNotification*)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

#pragma mark - 处理刷卡器相关
- (void)getHsCardNumber:(NSNotification*)notice
{
    NSString* cardNumAndCipher = [notice object];
    if (cardNumAndCipher && cardNumAndCipher.length > 0) {
        NSArray* arrCardAndCipher = [cardNumAndCipher componentsSeparatedByString:@","];
        if (arrCardAndCipher.count == 2 ) { //当刷卡信息置空的时候赋值
             self.cardView.textfield.text = [GYUtils formatCardNo:arrCardAndCipher.firstObject];
            [self clearUI];
            self.cardModel.HSCardNum = arrCardAndCipher[0];
            self.cardModel.CipherNum = arrCardAndCipher[1];
        }
    }
}

#pragma mark - 获取6位登录密码信息
- (void)backInfo:(NSNotification*)notice
{
    if ([[notice name] isEqualToString:GYPOSShounldInputLoginPasswordNotification]) {
        self.passwordView.passField.text = [notice object];
        [self submitRequest];
    }
}


#pragma mark - 清空页面
- (void)clearUI
{
    if (self.dataArray.count > 1){
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }
    self.tableView.hidden = YES;
    self.passwordView.passField.text = @"";
    self.passwordView.hidden = YES;
    [self.cardView.textfield becomeFirstResponder];

}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [self deleteView:self.passwordView];
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

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    self.tableView.mj_footer.hidden = self.dataArray.count < 2;
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSConsumeCancelListCell* cell = [tableView dequeueReusableCellWithIdentifier:consumeCancelCell forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    self.passwordView.hidden = NO;
    self.selectModel = self.dataArray[indexPath.section];
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
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSConsumeCancelListCell class]) bundle:nil] forCellReuseIdentifier:consumeCancelCell];
    }
    return _tableView;
}

- (NSMutableArray*)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - lazy load
- (GYPointTool*)pointTool
{
    if (_pointTool == nil) {
        _pointTool =  [GYPointTool shareInstance];
    }
    return _pointTool;
}

- (GYPOSBatchModel*)batchModel
{
    if (_batchModel == nil) {
        _batchModel = [GYPOSBatchModel shareInstance];
    }
    return _batchModel;
}

- (GYCardInfoModel *)cardModel
{
    if (_cardModel == nil) {
        _cardModel = [[GYCardInfoModel alloc]init];
    }
    return _cardModel;
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

@end
