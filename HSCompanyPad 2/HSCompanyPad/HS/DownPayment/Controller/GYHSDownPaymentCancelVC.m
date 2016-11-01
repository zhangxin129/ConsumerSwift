//
//  GYHSDownPaymentCancelVC.m
//
//  Created by apple on 16/8/4.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSDownPaymentCancelVC.h"
#import "GYHSCodeReaderViewController.h"
#import "GYHSPayKeyView.h"
#import "GYHSPaymentCancelCell.h"
#import "GYHSPaymentCheckModel.h"
#import "GYHSPointHttpTool.h"
#import "GYHSPointInputView.h"
#import "GYPointTool.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import "UITextField+GYHSPointTextField.h"
#import <GYKit/UIView+Extension.h>
#import "GYTextField.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <YYKit/YYTextKeyboardManager.h>
#import "GYPOSService.h"
#import <YYKit/UIGestureRecognizer+YYAdd.h>
#import "GYCardReaderModel.h"
#import <GYKit/UIButton+GYExtension.h>
#define kLetfwidth kDeviceProportion(20)
#define kInputViewWidth kDeviceProportion(429)
#define kCommonHeight kDeviceProportion(45)
#define KLineHeight kDeviceProportion(3)
@interface GYHSDownPaymentCancelVC () <UITextFieldDelegate, GYHSPayKeyDelegate, UITableViewDelegate, UITableViewDataSource, GYHSPaymentCancelDelegate, GYHSPointInputDelegate, GYHSCodeReaderDelegate>
@property (nonatomic, weak) GYHSPointInputView* cardView;
@property (nonatomic, weak) GYHSPayKeyView* keyView;
@property (nonatomic, strong) UITextField* selectField;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, weak) UIView* heardView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) GYPOSBatchModel* batchModel; // 批次号和终端流水号
@property (nonatomic, strong) GYPointTool* pointTool; /**积分获取工具*/
@property (nonatomic, strong) GYCardReaderModel * posInfo;
@property (nonatomic, strong) GYPOSService* POSService;
@property (nonatomic, strong) GYCardInfoModel * cardModel; // 互生号和暗码
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) BOOL isDown;

@end

@implementation GYHSDownPaymentCancelVC

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
     [kDefaultNotificationCenter addObserver:self selector:@selector(getHsCardNumber:) name:GYCardNumAndCipherNotification object:nil];
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
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIWindowDidBecomeVisibleNotification object:nil];
    [kDefaultNotificationCenter removeObserver:self];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_Down_Payment_Cancel");
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIWindowDidBecomeVisibleNotification object:nil];
    
    //互生卡行
    GYHSPointInputView* cardView = [[GYHSPointInputView alloc] initWithFrame:CGRectMake(kLetfwidth, kLetfwidth + kNavigationHeight, kInputViewWidth, kCommonHeight) imageName:@"gyhs_payment_card" placeholder:kLocalized(@"GYHS_Down_Swipe_Input_Number")];
    cardView.textfield.delegate = self;
    cardView.isShowRightView = YES;
    cardView.delegate = self;
    [cardView.textfield becomeFirstResponder];
    [self.view addSubview:cardView];
    self.cardView = cardView;
    
    GYHSPayKeyView* keyView = [[GYHSPayKeyView alloc] init];
    keyView.delegate = self;
    [self.view addSubview:keyView];
    self.keyView = keyView;
    [self.keyView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(kNavigationHeight);
        make.left.equalTo(self.view).offset(CGRectGetMaxX(self.cardView.frame) + kLetfwidth);
    }];
    
    UIView* heardView = [[UIView alloc] initWithFrame:CGRectMake(kLetfwidth, CGRectGetMaxY(self.cardView.frame) + KLineHeight, kInputViewWidth, kCommonHeight)];
    heardView.hidden = YES;
    heardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:heardView];
    self.heardView = heardView;
    CGFloat tradeLaWidth = (heardView.width - 10 - 40) * 5 / 15;
    CGFloat cashLaWidhth = (heardView.width - 10 - 40) * 6 / 15;
    CGFloat dealLaWidth = (heardView.width - 10 - 40) * 4 / 15;
    UILabel* tradeLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tradeLaWidth, heardView.height)];
    tradeLab.text = kLocalized(@"GYHS_Down_Trade_Time");
    tradeLab.font = kFont24;
    tradeLab.textColor = kGray777777;
    [heardView addSubview:tradeLab];
    
    UILabel* cashLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tradeLab.frame), 0, cashLaWidhth, heardView.height)];
    cashLab.text = kLocalized(@"GYHS_Down_Payment_Cash");
    cashLab.textAlignment = NSTextAlignmentRight;
    cashLab.font = kFont24;
    cashLab.textColor = kGray777777;
    [heardView addSubview:cashLab];
    
    UILabel* dealLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cashLab.frame), 0, dealLaWidth, heardView.height)];
    dealLab.text = kLocalized(@"GYHS_Down_Operate");
    dealLab.textAlignment = NSTextAlignmentRight;
    dealLab.font = kFont24;
    dealLab.textColor = kGray777777;
    [heardView addSubview:dealLab];
    
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self.view).offset(kLetfwidth);
        make.top.equalTo(heardView).offset(KLineHeight + CGRectGetHeight(heardView.frame));
        make.width.mas_equalTo(kInputViewWidth);
        make.bottom.equalTo(self.view).offset(-kLetfwidth);
    }];
}

#pragma mark - GYHSPayKeyDelegate
- (void)keyClick:(NSInteger)index
{
    if (index == 0) {
        //清除
        self.cardView.textfield.text = @"";
        [self.cardView.textfield becomeFirstResponder];
        [self clearUI];
    }
    else {
        //点击ok
        if ([self isDataAllright]) {
            self.heardView.hidden = NO;
            self.tableView.hidden = NO;
            [self addRefreshView];
            [self.keyView.sureBtn controlTimeOut];
        }
    }
}

#pragma mark - GYHSPointInputDelegate
- (void)clickRightAction:(NSInteger)index
{
    if (index == 1) {
        //刷卡
     [[GYPOSService sharedInstance] swipingCard];
    }
    else {
        //扫一扫
        GYHSCodeReaderViewController* codeReaderVC = [[GYHSCodeReaderViewController alloc] init];
        codeReaderVC.modalPresentationStyle = UIModalPresentationFormSheet;
        codeReaderVC.title = kLocalized(@"GYHS_Down_Scan_To");
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

#pragma mark - 数据是否正确
- (BOOL)isDataAllright
{
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return NO;
    }
    
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    if (![GYUtils isHSCardNo:cardStr]) {
        [self.cardView.textfield tipWithContent:kLocalized(@"GYHS_Down_Input_Number_Error_Tip") animated:YES];
        return NO;
    }
    return YES;
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

#pragma mark - 键盘显示通知
- (void)keyboardWillShow:(NSNotification*)Notification

{
    [YYTextKeyboardManager defaultManager].keyboardWindow.alpha = 0;
}

- (void)clearUI
{
    if (self.dataArray.count > 1){
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }
    self.heardView.hidden = YES;
    self.tableView.hidden = YES;

}

#pragma mark - 撤销列表请求
- (void)requestData
{
    //互生卡号
    NSString* cardStr = [self.cardView.textfield deleteSpaceField];
    @weakify(self);
    [GYHSPointHttpTool searchPosEarnestWithperResNo:cardStr
        curPage:[@(self.page) stringValue]
        pageSize:[@(self.pageSize) stringValue]
        startDate:@"all"
        success:^(id responsObject) {
            @strongify(self);
            if (self.isDown) {
                [self.dataArray removeAllObjects];
            }
            if (responsObject[GYNetWorkDataKey][@"result"]) {
                NSArray* array = responsObject[GYNetWorkDataKey][@"result"];
                for (NSDictionary* temp in array) {
                    GYHSPaymentCheckModel* model = [[GYHSPaymentCheckModel alloc] initWithDictionary:temp error:nil];
                    [self.dataArray addObject:model];
                }
            }
            [self.tableView reloadData];
            [self endRefresh];
            
        }
        failure:^{
            [self endRefresh];
            
        }];
}

#pragma mark - GYHSPayKeyDelegate
- (void)keyPayAddWithString:(NSString*)string
{
    self.cardModel = nil;
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return;
    }
    self.selectField.text = [NSString stringWithFormat:@"%@%@", self.selectField.text, string];
    self.selectField.text = [self.selectField inputCardField];
}

- (void)keyPayDeleteWithString
{
    self.cardModel = nil;
    if (self.selectField == nil) {
        [GYUtils showToast:kLocalized(@"GYHS_Down_Select_Edit_Field")];
        return;
    }
    self.tableView.hidden = YES;
    self.heardView.hidden = YES;
    if (self.selectField.text.length > 0) {
        self.selectField.text = [self.selectField.text substringToIndex:self.selectField.text.length - 1];
    }
    self.selectField.text = [self.selectField inputCardField];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    if (self.selectField) {
        [self deleteView:(UIView*)[self.selectField superview]];
    }
    self.selectField = textField;
    [self selectView:(UIView*)[self.selectField superview]];
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
    self.tableView.mj_footer.hidden = self.dataArray.count < 1;
    return self.dataArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHSPaymentCancelCell* cell = [tableView dequeueReusableCellWithIdentifier:paymentCancel];
    cell.model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - GYHSPaymentCancelDelegate
- (void)cancelWithPayment:(GYHSPaymentCheckModel*)model
{
    @weakify(self);
    [GYAlertView alertWithTitle:kLocalized(@"GYHS_Down_Tip")
                        Message:kLocalized(@"GYHS_Down_Sure_Cancel_Hsb_Down")
                       topColor:TopColorBlue
                   comfirmBlock:^{
                       //预付定金撤销
                       @strongify(self);
                       [self requestCancel:model];
                   }];
}

#pragma mark - 撤销请求
- (void)requestCancel:(GYHSPaymentCheckModel*)model
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
    NSString* transType = [model.transType stringByReplacingCharactersInRange:NSMakeRange(3, 1) withString:@"9"];
    [GYHSPointHttpTool getSourceTransNoWithsuccess:^(id responsObject) {
        @strongify(self);
        NSString* sourceTransNo = responsObject;
        //互生卡号
        NSString* cardStr = [self.cardView.textfield deleteSpaceField];
        [GYHSPointHttpTool cancelEarnestWithOldTransNo:model.sourceTransNo
                                         sourceTransNo:sourceTransNo
                                         sourceTransDt:model.sourceTransDate
                                           termRunCode:self.batchModel.posRunCode
                                             ecretCode:@""
                                              transPwd:nil
                                             transType:transType
                                              perResNo:cardStr
                                           equipmentNo:equipmentNo
                                         sourceBatchNo:self.batchModel.batchNo
                                                  frag:@"1"
                                               success:^(id responsObject) {
                                                   if (kHTTPSuccessResponse(responsObject)) {
                                                       [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Down_Cancel_Hsb_Down_Success")
                                                                                         topColor:TopColorBlue
                                                                                     comfirmBlock:^{
                                                                                         @strongify(self);
                                                            self.isDown = YES;
                                                                                         self.page = 1;                           [self requestData];
                                                                                     }];
                                                   } else {
                                                       [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_Down_Cancel_Hsb_Down_Fail")
                                                                                         topColor:TopColorRed
                                                                                     comfirmBlock:^{
                                                                                     }];
                                                       [GYHSPointHttpTool correctWithTransType:@"21910"
                                                                                       transNo:sourceTransNo
                                                                                  returnReason:@"POS_DownPaymentCorrect"
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
                                               
                                               }];
    }
        failure:^{
        
        }];
}

#pragma mark - lazy load
- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPaymentCancelCell class]) bundle:nil] forCellReuseIdentifier:paymentCancel];
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

- (GYPointTool*)pointTool
{
    if (_pointTool == nil) {
        _pointTool = [GYPointTool shareInstance];
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
