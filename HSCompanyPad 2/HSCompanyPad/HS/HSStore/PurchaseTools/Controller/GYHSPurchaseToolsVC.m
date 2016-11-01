//
//  GYHSPurchaseToolsVC.m
//
//  Created by apple on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  对企业进行pos机、积分刷卡器、消费刷卡器、消费者系统资源、个性卡定制服务申购单查询。可以查看出货情况和购买工具详细信息；对未付款订单可进行付款操作；对未确认订单进行取消订单操作；查看申购单详情。
 */
#import "GYHSPurchaseToolsVC.h"
#import "GYHSMemberProgressView.h"
#import "GYHSPurchToolsCollectionView.h"
#import "GYPurchaseToolsCell.h"
#import "GYHSSubmitOrderView.h"
#import "GYHSPaymentView.h"
#import "GYHSPaidView.h"
#import "GYHSStoreHttpTool.h"
#import "GYHSToolPurchaseModel.h"
#import "GYHSAddressListModel.h"
#import "GYHSEditAddressVC.h"
#import "GYPayViewController.h"
#import "GYHSToolPayModel.h"


static NSString *purchaseToolsCellId = @"GYPurchaseToolsCell";

@interface GYHSPurchaseToolsVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,GYHSSubmitViewDelegate, GYPayViewDelegate>
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, weak) GYHSMemberProgressView* progressView;
@property (nonatomic, weak) UIScrollView* scroll;
@property (nonatomic, strong) UIView* bottomBackView;
@property (nonatomic, strong) UIButton* nextButton;
@property (nonatomic, strong) NSMutableArray *toolDataArray;
@property (nonatomic, strong)GYHSPurchToolsCollectionView *purchView;
/**记录选择的项目*/
@property (nonatomic, strong) GYHSToolPurchaseModel* selectedModel;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, weak) GYHSSubmitOrderView *submitView;
@property (nonatomic, strong) NSMutableArray *selectedArrM;
@property (nonatomic, assign) BOOL isAddressSelected;
@property (nonatomic, strong) GYHSAddressListModel *addressModel;
@property (nonatomic, strong) NSDictionary* addressDict;
@property (nonatomic, strong) GYHSToolPayModel *toolPayModel;
@property (nonatomic, copy) NSString *passwordStr;

@end

@implementation GYHSPurchaseToolsVC

#pragma mark - lazy load

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    @weakify(self);
    [self loadInitViewType:GYStopTypeStopPointAct :^{
        @strongify(self);
        [self initView];
    }];

//    [self initView];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
    [self requestApplyProgressTool];
    [self requestAddressList];
    self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);

}
/**
 *  懒加载
 *
 *  @param NSMutableArray 工具申购步骤名称
 *
 */
#pragma  mark - 懒加载
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithArray: @[kLocalized(@"GYHS_HSStore_PurchaseTools_ToolPurchase"),kLocalized(@"GYHS_HSStore_PurchaseTools_SubmitOrders")]];
    }
    return _dataArray;
}
/**
 *  懒加载工具列表数据源
 *
 */
- (NSMutableArray *)toolDataArray{
    if (!_toolDataArray) {
        _toolDataArray = [[NSMutableArray alloc] init];
    }
    return _toolDataArray;
}
/**
 *  懒加载收货地址列表数据源
 */
- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [[NSMutableArray alloc] init];
    }
    return _addressArray;
}
#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHS_HSStore_PurchaseTools_HSTool");
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gyhs_back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
    [self createLeftView];
    [self createRightView];
    [self createBottomView];
}
/**
 *  创建左边申购工具步骤名称视图
 */
-(void)createLeftView{
    GYHSMemberProgressView* progressView = [[GYHSMemberProgressView alloc] initWithFrame:CGRectMake(0, kNavigationHeight, kDeviceProportion(201), kScreenHeight - kNavigationHeight - kDeviceProportion(70)) array:self.dataArray];
    progressView.index = 1;
    [self.view addSubview:progressView];
    self.progressView = progressView;
    self.progressView.customBorderType = UIViewCustomBorderTypeRight;
}
/**
 *  创建右边申购工具步骤视图
 */
- (void)createRightView{
    
    UIScrollView* scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.progressView.frame) + 16, kNavigationHeight, kScreenWidth - self.progressView.width, kScreenHeight - kNavigationHeight - kDeviceProportion(70))];
    scroll.scrollEnabled = NO;
    scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scroll];
    self.scroll = scroll;
    self.scroll.contentSize = CGSizeMake(scroll.width * (self.dataArray.count - 1), 0);

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 20;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    GYHSPurchToolsCollectionView *purchView = [[GYHSPurchToolsCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.scroll.width , self.scroll.height - kNavigationHeight - kDeviceProportion(70)) collectionViewLayout:flowLayout];

    [purchView registerNib:[UINib nibWithNibName:NSStringFromClass([GYPurchaseToolsCell class]) bundle:nil] forCellWithReuseIdentifier:purchaseToolsCellId];
    purchView.delegate = self;
    purchView.dataSource = self;
    [self.scroll addSubview:purchView];
    self.purchView = purchView;
    
    GYHSSubmitOrderView *submitView = [[GYHSSubmitOrderView alloc] initWithFrame: CGRectMake(self.scroll.width, 0, self.scroll.width - 32 , self.scroll.height - kNavigationHeight - kDeviceProportion(70))];
    [self.scroll addSubview:submitView];
    self.submitView = submitView;
    self.submitView.delegate = self;
    self.submitView.type = GYHSSubmitTypeToolPurchase;

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

}
/**
 *  底部按钮的触发事件
 */
- (void)nextButtonAction
{
    if (![self isDataAllRight]) {
        return;
    }
    [self setBtnTitle];
    if (self.progressView.index == 1) {
        _submitView.toolPurArray = self.selectedArrM;
        [self requestAddressList];
    }
    if (self.progressView.index == 2){
        [self requestSubmitToolBuyOrder];
//        _payVC.type = GYPaymentServiceTypeToolPurchase;
        
    }else{
    
        self.progressView.index++;
        self.scroll.contentOffset = CGPointMake((self.progressView.index - 1) * self.scroll.width, 0);
        self.progressView.hidden = NO;
        self.bottomBackView.hidden = NO;
    }
}
/**
 *  判断下一步操作的先决条件
 */
- (BOOL)isDataAllRight{
    if (self.progressView.index == 1) {
        if (self.selectedArrM.count == 0) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseSelectPurchaseTool")];
            return NO;
        }
        for (GYPurchaseToolsCell *cell in self.purchView.visibleCells) {
            if (cell.stateButton.isSelected && cell.toolNumTF.text.integerValue == 0) {
                [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PurchaseToolCanNotBeZero")];
                return NO;
            }
        }

    }else if (self.progressView.index == 2){
        if (!self.addressDict) {
            [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_PleaseSelectReceiveAddress")];
            return NO;
        }
    }
    return YES;
}
/**
 *  左边步骤名称视图的逻辑
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
}

/**
 *  底部视图名称
 */
- (void)setBtnTitle
{
            [self.nextButton setTitle:kLocalized(@"GYHS_HSStore_PerCardCustomization_Next") forState:UIControlStateNormal];
}


/**
 *  获取申购工具列表的网络请求
 */
#pragma mark - request

- (void)requestApplyProgressTool{

    [GYHSStoreHttpTool getApplyProgressToolType:GY_Business_SWIPE_CARD success:^(id responsObject) {
        
        _toolDataArray = (NSMutableArray *)responsObject;
        [self.purchView reloadData];
        
    } failure:^{
        
    }];
}

/**
 *  获取收货地址列表网络请求
 */
- (void)requestAddressList{

    [GYHSStoreHttpTool getReciveAddr:^(id responsObject) {
        self.submitView.addrDataArray = (NSMutableArray *)responsObject;
    } failure:^{
        
    }];

}
/**
 *  删除收货地址列表的网络请求
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
 *  此处如果是工具申购生成订单，则互生币金额不需要填写
 */
- (void)requestSubmitToolBuyOrder
{
    NSMutableArray *toolListArray = [NSMutableArray array];
    NSDictionary *toolListDic = [NSDictionary dictionary];
    for (GYHSToolPurchaseModel *model in self.selectedArrM) {
        toolListDic = @{  @"categoryCode" : model.categoryCode,
                          @"productId" : model.productId,
                          @"productName" : model.productName,
                          @"price" : model.price,
                          @"quanilty" : model.quanilty
                          };
        [toolListArray addObject:toolListDic];
    }
    
    if (  [NSString stringWithFormat:@"%@",self.addressDict[@"fullAddr"]].length < 1|| [NSString stringWithFormat:@"%@",self.addressDict[@"linkman"]].length < 1 || [NSString stringWithFormat:@"%@",self.addressDict[@"mobile"]].length < 1) {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_PurchaseTools_YourSelectedAddressInformationWasIncompleted, PleaseReselect")];
        return;
    }
    @weakify(self);
    [GYHSStoreHttpTool submitToolBuyOrderToolList:toolListArray addr:self.addressDict orderType:@"103" orderHsbAmount:nil success:^(id responsObject) {
        @strongify(self);
        
        self.toolPayModel = (GYHSToolPayModel *)responsObject;
        GYPayViewController *vc =  [[GYPayViewController alloc]initWithNibName:NSStringFromClass([GYPayViewController class]) bundle:nil];
        vc.type = GYPaymentServiceTypeToolPurchase;
        vc.model = self.toolPayModel;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^{
        
    }];
}

#pragma mark --UICollectionViewDataSource

//定义展示的Section的个数

- (NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView

{
    return 1 ;
}


//定义展示的UICollectionViewCell的个数

- (NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section

{
    return _toolDataArray.count;
}

//每个UICollectionView展示的内容

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    GYPurchaseToolsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:purchaseToolsCellId forIndexPath:indexPath];
    GYHSToolPurchaseModel *model = _toolDataArray[indexPath.row];
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GYPurchaseToolsCell* cell = (GYPurchaseToolsCell *)[collectionView cellForItemAtIndexPath:indexPath];
    GYHSToolPurchaseModel *selectModel = _toolDataArray[indexPath.row];
    selectModel.selected = !selectModel.selected;
    cell.isSelect = selectModel.selected;
    cell.model = selectModel;
    NSMutableArray* selectedArray = @[].mutableCopy;
    NSArray *cellArray = [collectionView visibleCells];
    for (GYPurchaseToolsCell *cell in cellArray) {
        if (cell.isSelect == YES) {
            [selectedArray addObject:cell.model];
        }
    }
    self.selectedArrM = selectedArray;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark -- UICollectionViewDelegate && UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    return CGSizeMake (kDeviceProportion(388) , kDeviceProportion(160));
}

//定义每个UICollectionView 的边距

- (UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    return UIEdgeInsetsMake ( 15 , 16 , 15 , 15 );
}
/**
 *  GYHSSubmitViewDelegate,用于传值
 */
#pragma mark -- GYHSSubmitViewDelegate
/**
 *  删除收货地址的按钮的触发事件
 */
- (void)deleteAddress:(GYHSAddressListModel *)model{
    [GYAlertWithOneButtonView alertWithMessage:kLocalized(@"GYHS_HSStore_PurchaseTools_ConfirmDeleteShippingAddress") topColor:0 comfirmBlock:^{
        [self requestDeleteAddress:model];
    }];
}
/**
 *  修改收货地址的按钮的触发事件
 */
-(void)changeAddress:(GYHSAddressListModel *)model{
    GYHSEditAddressVC *editAddressVC = [[GYHSEditAddressVC alloc] init];
    editAddressVC.type = GYHSEditAddressVCTypeChange;
    editAddressVC.model = model;
    [self.navigationController pushViewController:editAddressVC animated:YES];
}
/**
 *  添加收货地址的按钮的触发事件
 */
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
#pragma mark -- GYPayViewDelegate
- (void)transPassword:(NSString *)password{
    self.passwordStr = password;
}

@end
