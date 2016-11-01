//
//  GYQuickPayViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  快捷支付
 */
#import "GYQuickPayViewController.h"
#import "GYHSBankCradModel.h"
#import "GYHSPayTool.h"
#import "GYHSPublicMethod.h"
#import "GYHSToolPayModel.h"
#import "GYPayBankCell.h"
#import "GYPaySuccessVC.h"
#import "GYQuickPayWebViewController.h"
#import <GYKit/UIButton+GYExtension.h>
#import <MJExtension/MJExtension.h>
#import <YYKit/NSAttributedString+YYText.h>
#import <YYKit/YYLabel.h>
static NSString* bankCellID = @"GYBankCell";
@interface GYQuickPayViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, GYPayBankCellDelegate>

@property (nonatomic, strong) YYLabel* orderLabel;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UITextField* codeTextField;
@property (nonatomic, strong) UIButton* codeButton;
@property (nonatomic, strong) NSMutableArray* cardArray;
@property (nonatomic, assign) BOOL isFarword;
@property (nonatomic, strong) GYHSBankCradModel* seletModel;
@property (nonatomic, copy) NSString* codeString;
@property (nonatomic, strong) UILabel* tipLable;

@end

@implementation GYQuickPayViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestBankCardList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}
/**
 *  懒加载
 */
- (NSMutableArray*)cardArray
{
    if (!_cardArray) {
        _cardArray = [[NSMutableArray alloc] init];
    }
    return _cardArray;
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHSPay_FastCardPayment");
    self.view.backgroundColor = kWhiteFFFFFF;
    [self createRetailView];
    [self createBottomView];
}
/**
 *  创建视图
 */
- (void)createRetailView
{
    _orderLabel = [[YYLabel alloc] init];
    [self.view addSubview:_orderLabel];
    
    [_orderLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(self.view.mas_top).offset(44 + 25);
        make.left.equalTo(self.view.mas_left).offset(15);
        make.width.equalTo(@(kDeviceProportion(kScreenWidth - 15)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    {
        NSMutableAttributedString* tipMsg = [[NSMutableAttributedString alloc] init];
        
        UIImage* image1 = [UIImage imageNamed:@"gypay_tick"];
        NSMutableAttributedString* attachText1 = [NSMutableAttributedString attachmentStringWithContent:image1 contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(kDeviceProportion(39), kDeviceProportion(39)) alignToFont:kFont28 alignment:YYTextVerticalAlignmentCenter];
        [tipMsg appendAttributedString:attachText1];
        
        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_SuccessfulOrderSubmission,OrderNumber") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGray333333 }]];
        
        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:self.model.orderNo attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kRedE50012 }]];
        
        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:kLocalized(@"GYHSPay_PaymentAmount") attributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kGray333333 }]];
        
        UIImage* image2 = [UIImage imageNamed:@"gypay_hsb"];
        NSMutableAttributedString* attachText2 = [NSMutableAttributedString attachmentStringWithContent:image2 contentMode:UIViewContentModeCenter attachmentSize:CGSizeMake(kDeviceProportion(23), kDeviceProportion(23)) alignToFont:kFont28 alignment:YYTextVerticalAlignmentCenter];
        [tipMsg appendAttributedString:attachText2];
        
        [tipMsg appendAttributedString:[[NSAttributedString alloc] initWithString:[GYUtils formatCurrencyStyle:self.model.hsbAmount.doubleValue] attributes:@{ NSFontAttributeName : kFont28, NSForegroundColorAttributeName : kRedE50012 }]];
        
        _orderLabel.attributedText = tipMsg;
    }
    
    _orderLabel.customBorderType = UIViewCustomBorderTypeBottom;
    
    UILabel* quickLable = [[UILabel alloc] init];
    quickLable.text = kLocalized(@"GYHSPay_FastCardPayment");
    quickLable.textColor = kGray333333;
    quickLable.textAlignment = NSTextAlignmentCenter;
    quickLable.font = kFont42;
    [self.view addSubview:quickLable];
    [quickLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_orderLabel.mas_top).offset(50 + 48);
        make.left.equalTo(self.view.mas_left).offset((kScreenWidth - 120) / 2);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(50)));
    }];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 44 + 50 + 57 + 48 + 25, kDeviceProportion(kScreenWidth - 40), 200) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kWhiteFFFFFF;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPayBankCell class]) bundle:nil] forCellWithReuseIdentifier:bankCellID];
    [self.view addSubview:_collectionView];
    
    UIView* addView = [[UIView alloc] init];
    addView.layer.borderWidth = 1.0f;
    addView.layer.borderColor = kGrayCCCCCC.CGColor;
    [self.view addSubview:addView];
    [addView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_collectionView.mas_top).offset(200 + 20);
        make.left.equalTo(self.view.mas_left).offset(20);
        make.width.equalTo(@(kDeviceProportion(482)));
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton* addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setBackgroundImage:[UIImage imageNamed:@"gyhs_add_address"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addButton];
    [addButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(addView.mas_top).offset(28);
        make.left.equalTo(self.view.mas_left).offset(141);
        make.width.equalTo(@(kDeviceProportion(15)));
        make.height.equalTo(@(kDeviceProportion(15)));
    }];
    
    UIButton* addtitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addtitleBtn setTitle:kLocalized(@"GYHSPay_AddQuickPaymentBankCard") forState:UIControlStateNormal];
    [addtitleBtn setTitleColor:kGray666666 forState:UIControlStateNormal];
    [addtitleBtn setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 2, 0)];
    [addtitleBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [addView addSubview:addtitleBtn];
    [addtitleBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(addView.mas_top).offset(25);
        make.left.equalTo(addButton.mas_left).offset(5);
        make.width.equalTo(@(kDeviceProportion(200)));
        make.height.equalTo(@(kDeviceProportion(20)));
    }];
    
    _codeTextField = [[UITextField alloc] init];
    _codeTextField.layer.borderColor = kGrayCCCCCC.CGColor;
    _codeTextField.layer.borderWidth = 1.0f;
    _codeTextField.secureTextEntry = YES;
    _codeTextField.delegate = self;
    _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_codeTextField addTarget:self action:@selector(code:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_codeTextField];
    [_codeTextField mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_collectionView.mas_top).offset(200 + 20);
        make.left.equalTo(addView.mas_left).offset(20 + 482);
        make.width.equalTo(@(kDeviceProportion(332)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    _codeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeButton setTitle:kLocalized(@"GYHSPay_GetVerificationCode") forState:UIControlStateNormal];
    [_codeButton addTarget:self action:@selector(obtainCode:) forControlEvents:UIControlEventTouchUpInside];
    [_codeButton setBackgroundColor:kGray333333];
    [_codeButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [self.view addSubview:_codeButton];
    [_codeButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_collectionView.mas_top).offset(200 + 20);
        make.left.equalTo(_codeTextField.mas_left).offset(332);
        make.width.equalTo(@(kDeviceProportion(150)));
        make.height.equalTo(@(kDeviceProportion(40)));
    }];
    
    UILabel* tipLable = [[UILabel alloc] init];
    tipLable.text = kLocalized(@"GYHSPay_YouWillReceiveAPaymentOfPingAnBankChinaUnionPayPaymentVerificationCodeMessage");
    tipLable.textColor = kRedE50012;
    tipLable.font = kFont32;
    tipLable.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tipLable];
    [tipLable mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(_codeTextField.mas_top).offset(40);
        make.left.equalTo(addView.mas_left).offset(20 + 482);
        make.width.equalTo(@(kDeviceProportion(482)));
        make.height.equalTo(@(kDeviceProportion(30)));
    }];
    self.tipLable = tipLable;
}
- (void)createBottomView
{

    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    [bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.borderWidth = 1;
    nextButton.layer.borderColor = kWhiteFFFFFF.CGColor;
    nextButton.layer.masksToBounds = YES;
    nextButton.enabled = NO;
    [nextButton setTitle:kLocalized(@"GYHSPay_confirmPay") forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:kGray333333];
    [nextButton addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:nextButton];
    self.nextButton = nextButton;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
}
/**
 *  按钮的触发事件
 *
 */
#pragma mark-- buttonAction
- (void)btnAction:(UIButton*)sender
{
    [self.view endEditing:YES];
    [self requestQuickPay];
}

/**
 *  获取验证码的网络请求
 *
 */
- (void)obtainCode:(UIButton*)button
{
    if (!self.seletModel) {
        [GYUtils showToast:@"请先选择快捷卡"];
        return;
    }
    
    @weakify(self);
    [button startTime:120 title:kLocalized(@"GYHSPay_GetVerificationCode") waitTittle:kLocalized(@"GYHSPay_AfterAcquiringS")];
    [GYHSPayTool QuickPaymentSmsCodeTransNo:_model.orderNo
                                  bindingNo:self.seletModel.signNo
                             bindingChannel:@"P"
                                    success:^(id responsObject) {
                                        @strongify(self);
                                        [GYUtils showToast:kLocalized(@"GYHSPay_GetSuccessful")];
                                        self.isFarword = YES;
                                    }
                                    failure:^{
                                    }];
}
/**
 *  绑定快捷支付卡的网络请求，通过在webView上操作
 *
 */
- (void)addBtnAction:(UIButton*)sender
{
    [GYHSPayTool getPinganQuickBindBankUrlWithCustId:globalData.loginModel.entCustId
                                             success:^(id responsObject) {
                                                 GYQuickPayWebViewController* webViewVC = [[GYQuickPayWebViewController alloc] init];
                                                 webViewVC.urlStr = responsObject[GYNetWorkDataKey][@"bindBankUrl"];
                                                 webViewVC.returnUrlStr = responsObject[GYNetWorkDataKey][@"returnUrl"];
                                                 [self.navigationController pushViewController:webViewVC animated:YES];
                                             }
                                             failure:^{
                                             
                                             }];
}
#pragma mark - 短信验证码
/**
 *  对输入短信验证码的限制
 *
 */
- (void)code:(UITextField*)textField
{
    if (textField.text.length > 6) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
        [textField tipWithContent:kLocalized(@"GYHSPay_VerificationCodeTip") animated:YES];
        [textField resignFirstResponder];
    }
    self.codeString = textField.text;
}

#pragma mark-- request
/**
 *  获取绑定的快捷支付卡列表的网络请求
 */
- (void)requestBankCardList
{
    @weakify(self);
    [GYHSPayTool getListQkBanksByBindingChannelWithCustId:globalData.loginModel.entCustId
                                                 UserType:GYUserTypeCompany
                                           BindingChannel:@"P"
                                                  success:^(id responsObject) {
                                                      @strongify(self);
                                                      if (kHTTPSuccessResponse(responsObject)) {
                                                          NSMutableArray* modelArrM = [NSMutableArray array];
                                                          
                                                          id arr = responsObject[GYNetWorkDataKey];
                                                          
                                                          if ([arr isKindOfClass:[NSNull class]]) {
                                                          
                                                              return;
                                                          } else if ([arr isKindOfClass:[NSArray class]]) {
                                                          
                                                              NSArray* dictArr = responsObject[GYNetWorkDataKey];
                                                              
                                                              for (NSDictionary* d in dictArr) {
                                                              
                                                                  GYHSBankCradModel* model = [GYHSBankCradModel mj_objectWithKeyValues:d];
                                                                  
                                                                  [modelArrM addObject:model];
                                                              }
                                                              self.cardArray = modelArrM;
                                                              [self.collectionView reloadData];
                                                              if (self.cardArray.count >= 1) {
                                                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                      [self collectionView:self.collectionView didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                                                                  });
                                                              }
                                                          }
                                                      } else if ([responsObject[GYNetWorkCodeKey] isEqualToNumber:@204]) {
                                                      
                                                          self.collectionView.hidden = YES;
                                                          self.codeTextField.hidden = YES;
                                                          self.codeButton.hidden = YES;
                                                          self.tipLable.hidden = YES;
                                                      }
                                                  }
                                                  failure:^{
                                                  
                                                  }];
}
/**
 *  删除绑定的快捷支付卡的网络请求
 */
- (void)requestDeleteBankCardWithAccId:(GYHSBankCradModel*)model
{
    //    [GYHSPayTool deleteQiuckBankWithAccId:accId success:^(id responsObject) {
    //        [GYUtils showToast:kLocalized(@"GYHSPay_RemoveQuickPaymentCardSuccess")];
    //        [self requestBankCardList];
    //    } failure:^{
    //
    //    }];
    
    [GYHSPayTool getDeleteQiuckBankWithAccId:model.accId
                                   bindingNo:model.signNo
                                     success:^(id responsObject) {
                                         [GYUtils showToast:kLocalized(@"GYHSPay_RemoveQuickPaymentCardSuccess")];
                                         [self requestBankCardList];
                                     }
                                     failure:^{
                                     
                                     }];
}
/**
 *  快捷支付的网络请求
 */
- (void)requestQuickPay
{
    if (!self.isFarword) {
        [GYUtils showToast:kLocalized(@"GYHSPay_PleaseFirstVerificationCode")];
        return;
    }
    
    if (self.codeString.length != 6) {
    
        [GYUtils showToast:kLocalized(@"GYHSPay_PleaseEnterCurrectVerificationCode")];
        return;
    }
    
    @weakify(self);
    switch (self.type) {
    case QuickPaymentTypeTool:
    case QuickPaymentTypePersonCardOrder:
    case QuickPaymentTypeHSCardPurchase: {
        [GYHSPayTool PaymentByQuickPayOrderNo:_model.orderNo
                                      smsCode:self.codeString
                                    bindingNo:self.seletModel.signNo
                                   payChannel:GYPayChannelQuickPay
                               bindingChannel:@"P"
                                      success:^(id responsObject) {
                                          @strongify(self);
                                          if (kHTTPSuccessResponse(responsObject)) {
                                          
                                              [GYUtils showToast:kLocalized(@"GYHSPay_OrderPaymentProcessingSuccess")];
                                              GYPaySuccessVC* paySuccessVC = [[GYPaySuccessVC alloc] init];
                                              if (self.isQueryDetailVC == YES) {
                                                  paySuccessVC.isQueryDetailVC = YES;
                                              } else {
                                                  if (self.type == QuickPaymentTypeTool) {
                                                      paySuccessVC.type = GYPaymentTypeToolPurchase;
                                                  } else if (self.type == QuickPaymentTypeHSCardPurchase) {
                                                      paySuccessVC.type = GYPaymentTypeResourcePurchase;
                                                  } else if (self.type == QuickPaymentTypePersonCardOrder) {
                                                      paySuccessVC.type = GYPaymentTypePersonalCard;
                                                  }
                                              }
                                              paySuccessVC.payStr = _model.hsbAmount;
                                              [self.navigationController pushViewController:paySuccessVC animated:YES];
                                          } else {
                                              [GYUtils showToast:kLocalized(@"GYHSPay_SMSVerificationCodeIncorrect,pleasere-Being")];
                                              self.codeString = nil;
                                              self.isFarword = NO;
                                              self.codeButton.userInteractionEnabled = YES;
                                              [self.codeButton setTitle:kLocalized(@"GYHSPay_GetVerificationCode") forState:UIControlStateNormal];
                                          }
                                          
                                      }
                                      failure:^{
                                      
                                      }];
                                      
    } break;
    
    case QuickPaymentTypeFee: {
    
        [GYHSPayTool payAnnualFeeOrderOrderNo:_model.orderNo
                                   payChannel:GYPayChannelQuickPay
                                    bindingNo:self.seletModel.signNo
                                      smsCode:self.codeString
                                     tradePwd:@""
                                      success:^(id responsObject) {
                                          @strongify(self);
                                          if (kHTTPSuccessResponse(responsObject)) {
                                              [GYUtils showToast:kLocalized(@"GYHSPay_OrderPaymentProcessingSuccess")];
                                              GYPaySuccessVC* paySuccessVC = [[GYPaySuccessVC alloc] init];
                                              if (self.isQueryDetailVC == YES) {
                                                  paySuccessVC.isQueryDetailVC = YES;
                                              } else {
                                                  paySuccessVC.type = GYPaymentTypePayAnnualFee;
                                              }
                                              paySuccessVC.payStr = _model.hsbAmount;
                                              [self.navigationController pushViewController:paySuccessVC animated:YES];
                                          } else {
                                          
                                              [GYUtils showToast:kLocalized(@"GYHSPay_SMSVerificationCodeIncorrect,pleasere-Being")];
                                              self.codeString = nil;
                                              self.isFarword = NO;
                                              self.codeButton.userInteractionEnabled = YES;
                                              [self.codeButton setTitle:kLocalized(@"GYHSPay_GetVerificationCode") forState:UIControlStateNormal];
                                          }
                                          
                                      }
                                      failure:^{
                                      
                                      }];
    }
    
    break;
    
    case QuickPaymentTypeBehalf: {
        [GYHSPayTool paymentByQuickPayWithTransNo:_model.orderNo
                                        bindingNo:self.seletModel.signNo
                                          smsCode:self.codeString
                                   bindingChannel:@"P"
                                          success:^(id responsObject) {
                                              @strongify(self);
                                              if (kHTTPSuccessResponse(responsObject)) {
                                                  [GYUtils showToast:kLocalized(@"GYHSPay_OrderPaymentProcessingSuccess")];
                                                  GYPaySuccessVC* paySuccessVC = [[GYPaySuccessVC alloc] init];
                                                  paySuccessVC.type = GYPaymentTypeExchangeHSCurrency;
                                                  paySuccessVC.payStr = _model.cashAmount;
                                                  [self.navigationController pushViewController:paySuccessVC animated:YES];
                                              } else {
                                                  [GYUtils showToast:kLocalized(@"GYHSPay_SMSVerificationCodeIncorrect,pleasere-Being")];
                                                  self.codeString = nil;
                                                  self.isFarword = NO;
                                                  self.codeButton.userInteractionEnabled = YES;
                                                  [self.codeButton setTitle:kLocalized(@"GYHSPay_GetVerificationCode") forState:UIControlStateNormal];
                                              }
                                              
                                          }
                                          failure:^{
                                          
                                          }];
    } break;
    default:
        break;
    }
}
#pragma mark--UICollectionViewDataSource

//定义展示的Section的个数

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView

{
    return 1;
}

//定义展示的UICollectionViewCell的个数

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section

{
    return self.cardArray.count;
}

//每个UICollectionView展示的内容

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath

{
    GYPayBankCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:bankCellID forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.delegate = self;
    cell.model = self.cardArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSArray* cellArray = [collectionView visibleCells];
    for (GYPayBankCell* cell in cellArray) {
        [self upStatusWithCell:cell select:NO];
    }
    GYPayBankCell* cell = (GYPayBankCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self upStatusWithCell:cell select:YES];
    self.seletModel = self.cardArray[indexPath.item];
    [self.codeButton stopTimerWithTitle:kLocalized(@"GYHSPay_GetVerificationCode")];
    self.codeTextField.text = @"";
}

- (void)upStatusWithCell:(GYPayBankCell*)cell select:(BOOL)select
{
    cell.backgroundView = [[UIImageView alloc] initWithImage:[GYHSPublicMethod buttonImageStrech:select ? @"gyhs_point_select" : @"gyhs_point_noselect"]];
    cell.layer.borderWidth = 1;
    cell.layer.borderColor = select ? kRedE40011.CGColor : kGrayCCCCCC.CGColor;
}

#pragma mark-- UICollectionViewDelegate && UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath

{
    return CGSizeMake(kDeviceProportion(482), kDeviceProportion(70));
}

//定义每个UICollectionView 的边距

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}
#pragma mark-- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField*)textField
{
    [self.nextButton setBackgroundColor:kRedE50012];
    self.nextButton.enabled = YES;
}
#pragma mark -- GYBankCellDelegate

- (void)deleteActionModel:(GYHSBankCradModel *)model{
    [self requestDeleteBankCardWithAccId:model];
}

@end
