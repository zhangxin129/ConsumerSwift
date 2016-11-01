//
//  GYHSSysResPurchaseVC.m
//
//  Created by apple on 16/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  针对托管企业，将消费者互生号分为10段，分别是首段（托管企业系统消费者）资源、二段（托管企业系统消费者）资源一直到十段（托管企业系统消费者）资源；
 申报类型为首段资源的托管企业，申报成功后，可依次采购其他段消费者资源。只能依次顺序申购，不能跳段申购。
 托管企业在申购系统资源时，必须先同意《购买托管企业系统消费者资源协议》方可提交申购订单。
 在申购系统资源时，可选择使用标准卡样和个性定制卡样。选择个性定制卡样必须先支付个性卡定制服务费并且确认卡样后方可进行。
 */
#import "GYHSSysResPurchaseVC.h"
#import "GYHSMemberProgressView.h"
#import "GYHSSelResView.h"
#import "GYHSStoreHttpTool.h"
#import "GYHSResSegmentModel.h"
#import <MJExtension/MJExtension.h>
#import "GYHSSelectCardTypeView.h"
#import "GYHSCardTypeModel.h"
#import "GYHSSubmitOrderView.h"
#import "GYHSAddressListModel.h"
#import "GYHSEditAddressVC.h"
#import "GYPayViewController.h"
#import "GYHSToolPayModel.h"

#import "GYHSCardSubmitVC.h"

@interface GYHSSysResPurchaseVC ()<GYHSSubmitViewDelegate, GYHSTansSelectModelDelegate, GYHSSelectCardTypeViewDelegate, GYPayViewDelegate>

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) GYHSMemberProgressView* progressView;
@property (nonatomic, weak) UIScrollView* scroll;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) GYHSSelResView *selResView;
@property (nonatomic, strong) GYHSSelectCardTypeView *selectCardTypeView;
@property (nonatomic, strong) NSMutableArray *stanTypeArr;
@property (nonatomic, strong) NSMutableArray *perTypeArr;
@property (nonatomic, strong) GYHSSubmitOrderView *submitOrderView;
@property (nonatomic, strong) GYHSCardTypeModel *cardSelectModel;
@property (nonatomic, strong) GYPayViewController *payVC;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic, strong) NSDictionary* addressDict;
@property (nonatomic, strong) GYHSAddressListModel *addressModel;
@property (nonatomic, strong) GYHSToolPayModel *toolPayModel;
@property (nonatomic, strong) GYSegmentModel *segmentModel;

@end

@implementation GYHSSysResPurchaseVC
/**
 *  懒加载资源申购的步骤名称
 */
#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray: @[kLocalized(@"选择资源段"),kLocalized(@"选择卡样"),kLocalized(@"提交订单"),kLocalized(@"选择支付方式"),kLocalized(@"完成付款")]];
    }
    return _dataArray;
}
/**
 *  懒加载标准卡样数据源
 */
- (NSMutableArray *)stanTypeArr{
    if (!_stanTypeArr) {
        _stanTypeArr = [[NSMutableArray alloc] init];
    }
    return _stanTypeArr;
}
/**
 *  懒加载个性卡样数据源
 */
- (NSMutableArray *)perTypeArr{
    if (!_perTypeArr) {
        _perTypeArr = [[NSMutableArray alloc] init];
    }
    return _perTypeArr;
}
#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [self loadInitViewType:GYStopTypeStopPointAct :^{
        @strongify(self);
        [self initView];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestQueryResSegment];
    [self requestAddressList];
}

- (void)dealloc
{
   
}


#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_HSStore_SysResPurchase_SystemResourcePurchase");
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    [self createLeftView];
    [self createRightView];
    [self createBottomView];
}
/**
 *  创建左边资源申购步骤名称视图
 */
#pragma mark - event
-(void)createLeftView{
    self.num = 0;
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kDeviceProportion(201), kScreenHeight - kNavigationHeight - kDeviceProportion(70)) array:self.dataArray];
    progressView.index = 1;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    self.progressView.customBorderType = UIViewCustomBorderTypeRight;
}
/**
 *  创建右边资源申购步骤视图
 */
- (void)createRightView{
    
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progressView.frame) + 16, kNavigationHeight, kScreenWidth - self.progressView.width, kScreenHeight - kNavigationHeight - kDeviceProportion(70))];
    scroll.scrollEnabled = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    self.scroll.contentSize = CGSizeMake(scroll.width * (self.dataArray.count - 1), 0);
    
    GYHSSelResView *selResView = [[GYHSSelResView alloc] initWithFrame:CGRectMake(0, 0, self.scroll.width - 32 , self.scroll.height - kNavigationHeight - kDeviceProportion(70)) ];
    self.selResView = selResView;
    [self.scroll addSubview:self.selResView];
    self.selResView.delegate = self;
    _selectCardTypeView = [[GYHSSelectCardTypeView alloc] initWithFrame:CGRectMake(self.scroll.width, 0, self.scroll.width - 32 , self.scroll.height - kNavigationHeight - kDeviceProportion(70)) ];
    _selectCardTypeView.delegate = self;
    [self.scroll addSubview:_selectCardTypeView];
    
    _submitOrderView = [[GYHSSubmitOrderView alloc] initWithFrame:CGRectMake(self.scroll.width * 2, 0, self.scroll.width - 32 , self.scroll.height - kNavigationHeight - kDeviceProportion(70)) ];
    [self.scroll addSubview:_submitOrderView];
    _submitOrderView.delegate = self;
    _submitOrderView.type = GYHSSubmitTypeResourceSegment;
    
     
}
/**
 *  创建底部按钮视图
 */
- (void)createBottomView{
    
    UIView* bottomBackView = [[UIView alloc] init];
    bottomBackView.backgroundColor = [UIColor colorWithHex:0x000000 andAlpha:0.16];
    [self.view addSubview:bottomBackView];
    self.bottomBackView = bottomBackView;
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.equalTo(@(kDeviceProportion(70)));
    }];
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.borderWidth = 1;
    nextButton.layer.borderColor = kRedE50012.CGColor;
    nextButton.layer.masksToBounds = YES;
    [nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Next") forState:UIControlStateNormal];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextButton setBackgroundColor:kRedE50012];
    [nextButton addTarget:self action:@selector(nextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBackView addSubview:nextButton];
    self.nextButton = nextButton;
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker* make) {
        make.height.equalTo(@(kDeviceProportion(33)));
        make.width.equalTo(@(kDeviceProportion(120)));
        make.centerX.centerY.equalTo(bottomBackView);
    }];
    self.num = 1;
    
}
/**
 *  资源申购左边步骤名称视图
 */
- (void)leftClick
{
    if (self.progressView.index == self.dataArray.count) {
        self.progressView.hidden = YES;
        self.bottomBackView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    self.progressView.index--;
    self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
    if (self.progressView.index < 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [self setBtnTitle];
}
/**
 *  底部按钮触发事件
 */
- (void)nextButtonAction
{
    if (![self ISDataRight]) {
        return;
    }
    
    [self setBtnTitle];
    
    if (self.progressView.index == 1) {
        [self requestCardTypeList];
    }
    if (self.progressView.index == 2){
        [self goSubmitView];
    }
    if (self.progressView.index == 3){
        [self requestSubmitToolBuyOrder];
    }else{
        self.progressView.index++;
        self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
        self.progressView.hidden = NO;
        self.bottomBackView.hidden = NO;
    }
   
}
/**
 *  判断进行下一步操作的先决条件
 */
- (BOOL)ISDataRight{

    if (self.progressView.index == 1) {
        if (self.transArray.count == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_SysResPurchase_PleaseSelectConsumerResourcesSectionFirst")];
            return NO;
        }

    }else if (self.progressView.index == 2){
        if (!self.cardSelectModel) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_SysResPurchase_PleaseSelectCardTypeFirst")];
            return NO;
        }
    }else if (self.progressView.index == 3){
        if (!self.addressDict) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_SysResPurchase_PleaseSelectReceiveAddressFirst")];
            return NO;
        }
    }else if (self.progressView.index == 4){
        if (self.passwordStr == nil || [self.passwordStr isEqualToString:@""]) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_PlaceholderInputTradePwd")];
            return NO;
        }
        if (![self.passwordStr isValidNumber]) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PerCardCustomization_TransactionPasswordCanOnlyBePureDigital")];
            return NO;
        }
    }
    
    return YES;
}
/**
 *  将选择的资源段数据源传给提交订单界面
 */
- (void)goSubmitView{
       _submitOrderView.resSegArray = self.transArray;
    [self requestAddressList];
}
/**
 *  设置底部按钮视图
 */
- (void)setBtnTitle
{
    if (self.progressView.index == 3) {
        [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_ConfirmPaied") forState:UIControlStateNormal];
    }else if (self.progressView.index == 4){
        [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Paid") forState:UIControlStateNormal];
    }else {
        [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Next") forState:UIControlStateNormal];
    }
}
/**
 *  查询系统资源段网络请求
 */
#pragma mark - request
- (void)requestQueryResSegment{
    [GYHSStoreHttpTool getQueryEntResourceSegmentWithSuccess:^(id responsObject) {
        _selResView.model = [GYHSResSegmentModel mj_objectWithKeyValues:responsObject];
    } failure:^{
        
    }];
}
/**
 *  查询卡样列表的网络请求
 */
- (void)requestCardTypeList{
    [GYHSStoreHttpTool getListConfirmCardStyle:^(id responsObject) {
        for (GYHSCardTypeModel *model in responsObject) {
            if (model.isSpecial.boolValue) {
                [self.perTypeArr addObject:model];
            }else {
                [self.stanTypeArr addObject:model];
            }
            self.selectCardTypeView.staTypeArray = self.stanTypeArr;
            self.selectCardTypeView.perTypeArray = self.perTypeArr;
        }

    } failure:^{
        
    }];
}
/**
 *  查询收货地址列表的网络请求
 */
- (void)requestAddressList{
    
    [GYHSStoreHttpTool getReciveAddr:^(id responsObject) {
        self.submitOrderView.addrDataArray = (NSMutableArray *)responsObject;
    } failure:^{
        
    }];
    
}
/**
 *  删除收货地址的网络请求
 */
- (void)requestDeleteAddress:(GYHSAddressListModel *)model{
    
    [GYHSStoreHttpTool deleteAddressWithAddrId:model.addressId
                                       success:^(id responsObject) {
                                           
                                           [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_DeletedAddressSuccessfully")];
                                           
                                           [self requestAddressList];
                                       }
                                       failure:^{
                                           
                                       }];
}
/**
 *  提交生成订单的网络请求
 */
- (void)requestSubmitToolBuyOrder
{
    NSMutableArray *toolListArray = [NSMutableArray array];
    NSDictionary *toolListDic = [NSDictionary dictionary];
    if (_cardSelectModel != nil) {
    
        toolListDic = @{
                        @"categoryCode" : GYHSCardPurchaseCode,
                        @"productId" : self.productModel.productId,
                        @"productName" : self.productModel.productName,
                        @"price" : self.productModel.price,
                        @"quanilty" : self.productModel.buyCardNumber,
                        @"cardStyleId" : self.cardSelectModel.cardStyleId
                        };
        [toolListArray addObject:toolListDic];
    }
    if (  [NSString stringWithFormat:@"%@",self.addressDict[@"fullAddr"]].length < 1|| [NSString stringWithFormat:@"%@",self.addressDict[@"linkman"]].length < 1 || [NSString stringWithFormat:@"%@",self.addressDict[@"mobile"]].length < 1) {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_YourSelectedAddressInformationWasIncompleted, PleaseReselect")];
        return;
    }

    @weakify(self);
    [GYHSStoreHttpTool submitToolBuyOrderToolList:toolListArray addr:self.addressDict orderType:@"110" orderHsbAmount:self.price success:^(id responsObject) {
        @strongify(self);
        
        self.toolPayModel = (GYHSToolPayModel *)responsObject;
        GYPayViewController *payVC =  [[GYPayViewController alloc]initWithNibName:NSStringFromClass([GYPayViewController class]) bundle:nil];
        payVC.model = self.toolPayModel;
        payVC.type = GYPaymentServiceTypeResourcePurchase;
        [self.navigationController pushViewController:payVC animated:YES];
    } failure:^{
        
    }];
}
/**
 *  互生币支付的网络请求
 */
- (void)requestHSBPayment{
    [GYHSStoreHttpTool HSBpayToolOrderOrderNo:_payVC.model.orderNo payChannel:[NSNumber numberWithInteger:[GYPayChannelHSBPay integerValue]] tradePwd:self.passwordStr success:^(id responsObject) {
        
        if (kHTTPSuccessResponse(responsObject)) {
            [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_HSStore_PerCardCustomization_OrderProcessedSuccessful") topColor:1 comfirmBlock:^{
                //                self.scroll.contentOffset = CGPointMake(self.scroll.width * 2, 0);
                self.scroll.contentOffset = CGPointMake(0, 0);
                self.progressView.index = 1;
            }];
        }else{
//            [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"互生币支付失败") topColor:0 comfirmBlock:^{
//                
//            }];
        }
        
    } failure:^{
        
    }];
}
/**
 *  新增、删除、修改收货地址的代理传值
 */
#pragma mark -- GYHSSubmitViewDelegate
- (void)deleteAddress:(GYHSAddressListModel *)model{
    [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_HSStore_PurchaseTools_ConfirmDeleteShippingAddress") topColor:0 comfirmBlock:^{
        [self requestDeleteAddress:model];
    }];
    
}

-(void)changeAddress:(GYHSAddressListModel *)model{
    GYHSEditAddressVC *editAddressVC = [[GYHSEditAddressVC alloc] init];
    editAddressVC.type = GYHSEditAddressVCTypeChange;
    editAddressVC.model = model;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}
-(void)addAddress{
    GYHSEditAddressVC *editAddressVC = [[GYHSEditAddressVC alloc] init];
    editAddressVC.type = GYHSEditAddressVCTypeAdd;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}
- (void)transSelectedMode:(GYHSAddressListModel *)model{
    self.addressModel = model;
    if (model.addressId.length > 1) {
        @weakify(self);
        [model getDetailArressWithBlock:^(NSString *address) {
            @strongify(self);
            self.addressDict = @{@"fullAddr":address,@"linkman":self.addressModel.contactName,@"mobile":self.addressModel.contactPhone};
        }];
    }else{
        self.addressDict = @{@"fullAddr":model.contactAddr,@"linkman":self.addressModel.contactName,@"mobile":self.addressModel.contactPhone};
    }
}
-(void)transPriceStr:(NSString *)priceStr{

    self.price = priceStr;
}

#pragma mark -- GYHSTansSelectModelDelegate
-(void)transSelectModelArr:(NSMutableArray *)dataArray ProductModel:(GYProductModel *)productModel{
    self.transArray = dataArray;
    self.productModel = productModel;
}
#pragma mark -- GYHSSelectCardTypeViewDelegate
- (void)transSlectModel:(GYHSCardTypeModel *)model{
    self.cardSelectModel = model;
}
- (void)customizeButtonAction{
    GYHSCardSubmitVC *cardSubmitVC = [[GYHSCardSubmitVC alloc] init];
    [self.navigationController pushViewController:cardSubmitVC animated:YES];
}
#pragma mark -- GYPayViewDelegate
- (void)transPassword:(NSString *)password{
    self.passwordStr = password;
}

@end
