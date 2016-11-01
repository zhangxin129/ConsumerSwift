//
//  GYHEShoppingCartListViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShoppingCartListViewController.h"
#import "GYHECartSectionHeaderView.h"
#import "GYHEShoppingCartListTableViewCell.h"
#import "GYHECartListModel.h"
#import "GYHESCOrderModel.h"
#import "GYHESCConfirmOrderViewController.h"
#import "SWTableViewCell.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYHEShopDetailViewController.h"

#define kListCell @"ShoppingCartListTableViewCell"
#define kSectionHeaderView @"CartSectionHeaderView"

@interface GYHEShoppingCartListViewController () <UITableViewDataSource, UITableViewDelegate, SWTableViewCellDelegate, GYHEShoppingCartListTableViewCellDelegate, GYHECartSectionHeaderViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView* tabView;
@property (weak, nonatomic) IBOutlet UIButton* chooseAllButton;
@property (weak, nonatomic) IBOutlet UIButton* accountButton;
@property (weak, nonatomic) IBOutlet UILabel* coinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* pvNumberLabel;

@property (weak, nonatomic) IBOutlet UIView* emptyCartView; //空购物车显示视图
@property (weak, nonatomic) IBOutlet UILabel* emptyTipLabel; //空购物车提示
@property (weak, nonatomic) IBOutlet UIView* noNetWorkView; //无网络界面
@property (weak, nonatomic) IBOutlet UILabel* netErrorLabel; //网络错误
@property (weak, nonatomic) IBOutlet UILabel* setNetAgainLabel; //检查网络

@property (nonatomic, strong) NSMutableArray* dataSourceArray; //数据源
@property (nonatomic, assign) NSInteger maxNumber; //最大购买数量
//@property (nonatomic, assign) BOOL isChooseAll; //是否全选

@end

@implementation GYHEShoppingCartListViewController

#pragma mark - lifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationController.navigationBar.hidden = NO;

    [self maxNumberNetworkRequest];
    [self basicSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHECartListModel *listModel = self.dataSourceArray[section];
    return listModel.itemInfos.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEShoppingCartListTableViewCell* listCell = [tableView dequeueReusableCellWithIdentifier:kListCell forIndexPath:indexPath];
    listCell.selectionStyle = UITableViewCellSelectionStyleNone;
    [listCell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
    listCell.delegate = self;
    listCell.cellDelegate = self;
    listCell.tag = indexPath.section + 50;
    listCell.cellScrollView.tag = indexPath.section + 50;

    listCell.maxNumber = self.maxNumber;
    listCell.indexPath = indexPath;
    GYHECartListModel *listModel = self.dataSourceArray[indexPath.section];
    GYHECartItemModel *itemModel = listModel.itemInfos[indexPath.row];
    listCell.itemModel = itemModel;
    return listCell;
}

#pragma mark - UITableViewDelegate
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    GYHECartSectionHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kSectionHeaderView];
    headerView.delegate = self;
    headerView.section = section;
    headerView.listModel = self.dataSourceArray[section];

    return headerView;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60.0f;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001f;
}

#pragma mark - SWTableViewCellDelegate
- (void)swipeableTableViewCell:(SWTableViewCell*)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
//    NSArray* cells = [self.tabView visibleCells];
//    for (UITableViewCell* cel in cells) {
//        if (cel.tag == cell.cellScrollView.tag) {
//
//            GYHECartListModel* listModel = self.dataSourceArray[cel.tag - 50];
//
//            [GYUtils showMessge:kLocalized(@"HE_SC_CartConfirmDeleteGood") confirm:^{
//                [self deleteGoodsList:listModel.cartId];
//            } cancleBlock:nil];
//        }
//    }
}

- (NSArray*)rightButtons
{
    NSMutableArray* buttonMary = [[NSMutableArray alloc] init];
    [buttonMary sw_addUtilityButtonWithColor:kNavigationBarColor title:kLocalized(@"删除")];
    return buttonMary;
}

#pragma mark - GYHEShoppingCartListTableViewCellDelegate
- (void)updateShowState:(NSIndexPath*)indexPath
{
    GYHECartListModel* listModel = self.dataSourceArray[indexPath.section];
    BOOL isSelectedAll = YES;
    for (GYHECartItemModel *itemModel in listModel.itemInfos) {
        if (!itemModel.isSelect) {
            isSelectedAll = NO;
        }
    }
    listModel.isSelect = isSelectedAll;
    
    GYHECartSectionHeaderView* sectionView = (GYHECartSectionHeaderView*)[self.tabView headerViewForSection:indexPath.section];
    sectionView.chooseButton.selected = listModel.isSelect;

    [self accountAndUpdateShowState];
}

- (void)pushToItemDetailWithIndexPath:(NSIndexPath*)indexPath
{
    GYEasybuyGoodsInfoViewController* vc = [[GYEasybuyGoodsInfoViewController alloc] init];
    GYHECartItemModel* itemModel = self.dataSourceArray[indexPath.section][indexPath.row];
    ;
    vc.itemId = itemModel.itemId;
    vc.vShopId = itemModel.vshopId;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - GYHECartSectionHeaderViewDelegate
- (void)updateStateWithAction:(NSInteger)section
{
    GYHECartListModel* listModel = self.dataSourceArray[section];
    
    
    for (GYHECartItemModel *itemModel in listModel.itemInfos) {
        itemModel.isSelect = listModel.isSelect;
    }
    for (NSInteger index; index < listModel.itemInfos.count; index ++) {
        GYHECartItemModel *itemModel = listModel.itemInfos[index];
        itemModel.isSelect = listModel.isSelect;
        
        NSIndexPath* indexPath = [NSIndexPath indexPathForRow:index inSection:section];
        GYHEShoppingCartListTableViewCell* listCell = (GYHEShoppingCartListTableViewCell*)[self.tabView cellForRowAtIndexPath:indexPath];
        listCell.chooseButton.selected = listModel.isSelect;
    }

    [self accountAndUpdateShowState];
}

//跳转至店铺首页
- (void)pushToShopHomePage:(NSInteger)section
{
    GYHEShopDetailViewController* vc = [[GYHEShopDetailViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PrivateMethods
//基本设置
- (void)basicSettings
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = kLocalized(@"HE_SC_CartShoppingCartTitle");

    self.coinNumberLabel.text = @"0.00";
    self.pvNumberLabel.text = @"0.00";

    self.tabView.rowHeight = 120.0f;

    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShoppingCartListTableViewCell class]) bundle:nil] forCellReuseIdentifier:kListCell];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHECartSectionHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:kSectionHeaderView];

    //以下为空购物车和无网络状态时的显示设置
    self.emptyTipLabel.text = kLocalized(@"购物车空空如也来挑几件好货吧!");
    self.netErrorLabel.text = kLocalized(@"HE_SC_CartNetError");
    self.setNetAgainLabel.text = kLocalized(@"HE_SC_Cartpleasecheckthenetwork");
}

//最大购买数量网络请求
- (void)maxNumberNetworkRequest
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:EasyBuyGetCartMaxSizeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            //如果没有获取到最大购买量，设为100
            self.maxNumber = 100;
        }
        self.maxNumber = [responseObject[@"data"] integerValue];
        [self shoppingCartNetworkRequest];//购物车商品列表网络请求

    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

//购物车商品列表网络请求
- (void)shoppingCartNetworkRequest
{
    NSMutableDictionary* mParameterDic = [[NSMutableDictionary alloc] init];
    //[mParameterDic setValue:@"4" forKey:@"channelType"];
    [mParameterDic setValue:@"1" forKey:@"currentPageIndex"];
    [mParameterDic setValue:@"10" forKey:@"pageSize"];
    //[mParameterDic setValue:globalData.loginModel.custId forKey:@"custId"];
    //[mParameterDic setValue:globalData.loginModel.resNo forKey:@"resNo"];
    //[mParameterDic setValue:globalData.loginModel.token forKey:@"token"];
    

    [GYGIFHUD showFullScreen];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kCartFindCartListUrl parameters:mParameterDic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            self.noNetWorkView.hidden = NO;
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            return;
        }
        self.noNetWorkView.hidden = YES;
        [self.dataSourceArray removeAllObjects];
//        for (NSDictionary *dict in responseObject[@"data"]) {
//            GYHESCCartListModel *listModel = [[GYHESCCartListModel alloc] initWithDictionary:dict error:nil];
//            //过滤不合格的商品
//            if ([listModel.count integerValue] > 0 && [listModel.count integerValue] <= self.maxNumber) {
//                [self.dataSourceArray addObject:listModel];
//            }
//        }
        self.dataSourceArray = [[GYHECartListModel modelArrayWithResponseObject:responseObject error:nil] mutableCopy];
//        for (NSDictionary *dict in responseObject[@"data"]) {
//            GYHECartListModel *listModel = [[GYHECartListModel alloc] initWithDictionary:dict error:nil];
//            [self.dataSourceArray addObject:listModel];
//        }

        if (self.dataSourceArray.count == 0) {
            self.emptyCartView.hidden = NO;
        }
        else {
            self.emptyCartView.hidden = YES;
            [self.tabView reloadData];
        }
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

// 删除购物车列表,网络请求函数，包含网络等待弹窗控件，数据解析回调函数
- (void)deleteGoodsList:(NSString*)cartId
{
    NSDictionary* parameterDic = @{ @"key" : globalData.loginModel.token,
        @"cartItemsId" : cartId };

    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:EasyBuyDeleteCartUrl parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (error) {
            [GYUtils showMessage:kLocalized(@"HE_SC_CartDeleteFail") confirm:nil];
            return;
        }
        [GYUtils showMessage:kLocalized(@"HE_SC_CartDeleteSuccess") confirm:^{
            [self shoppingCartNetworkRequest];//购物车商品列表网络请求
            self.chooseAllButton.selected = NO;
            self.coinNumberLabel.text = @"0.00";
            self.pvNumberLabel.text = @"0.00";
        }];
    }];

    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

//计算并更新显示状态
- (void)accountAndUpdateShowState
{
    double totalPrice = 0;
    double totalPv = 0;
    NSInteger count = 0;
    BOOL isChooseAll = YES;
    for (GYHECartListModel* listModel in self.dataSourceArray) {
        for (GYHECartItemModel *itemModel in listModel.itemInfos) {
            if (itemModel.isSelect) {
                totalPrice += [[GYUtils decimalNumberMutiplyWithString:itemModel.num othersString:itemModel.skuPrice] doubleValue];
                
                totalPv += [[GYUtils decimalNumberMutiplyWithString:itemModel.num othersString:itemModel.skuPv] doubleValue];
                ;
                
                count += [itemModel.num integerValue];
            } else {
                isChooseAll = NO;
            }
        }
    }
    self.coinNumberLabel.text = [GYUtils formatCurrencyStyle:totalPrice];
    
    self.pvNumberLabel.text = [GYUtils formatCurrencyStyle:totalPv];

    [self.accountButton setTitle:[NSString stringWithFormat:@"结算(%ld)", count] forState:UIControlStateNormal & UIControlStateSelected];

    self.chooseAllButton.selected = isChooseAll;
}

// 拆单
//- (NSMutableArray*)buildShopArray
//{
//    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
//    for (GYHESCCartListModel* listModel in self.dataSourceArray) {
//        if (listModel.isSelect && [listModel.count integerValue] > 0) {
//            [mutableArray addObject:listModel];
//        }
//    }
//
//    //构建排序描述器
//    NSSortDescriptor* shopIdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"shopId" ascending:YES];
//    NSSortDescriptor* skuIdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"skuId" ascending:YES];
//    //把排序描述器放进数组里，放入的顺序就是你想要排序的顺序
//    NSArray* descriptorArray = [NSArray arrayWithObjects:shopIdDescriptor, skuIdDescriptor, nil];
//    NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:descriptorArray];
//    return [sortedArray mutableCopy];
//}

// 得到提交订单数据源
//- (NSMutableArray*)getDataSource:(NSMutableArray*)sortedArray {
//    NSMutableArray* finalArray = [[NSMutableArray alloc] init];
//    NSString* shopIdString = @"0";
//    for (GYHESCCartListModel* listModel in sortedArray) {
//        if (![shopIdString isEqualToString:listModel.shopId]) {
//            GYHESCOrderModel* model = [[GYHESCOrderModel alloc] init];
//            model.vShopName = listModel.vShopName;
//            model.vShopId = listModel.vShopId;
//            model.modelArray = [[NSMutableArray alloc] initWithObjects:listModel, nil];
//            model.totalNumber = listModel.count;
//            model.totalMoney = [NSString stringWithFormat:@"%.2lf", [listModel.price doubleValue] * [listModel.count integerValue]];
//            model.totalPv = [NSString stringWithFormat:@"%.2lf", [listModel.pv doubleValue] * [listModel.count integerValue]];
//            model.shopName = listModel.shopName;
//            model.shopId = listModel.shopId;
//            model.sendWay = kLocalized(@"HE_SC_OrderDistributionWay");
//            model.payOffWay = kLocalized(@"HE_SC_OrderPaymentMethod");
//            
//            if ([listModel.isApplyCard isEqualToString:@"1"]) {
//                model.enableApplyCard = YES;
//            }
//            [finalArray addObject:model];
//        }
//        else {
//            GYHESCOrderModel* model = [finalArray lastObject];
//            [model.modelArray addObject:listModel];
//            model.totalNumber = [NSString stringWithFormat:@"%ld", [model.totalNumber integerValue] + [listModel.count integerValue]];
//            model.totalMoney = [NSString stringWithFormat:@"%.2lf", [model.totalMoney doubleValue] + [listModel.price doubleValue] * [listModel.count integerValue]];
//            model.totalPv = [NSString stringWithFormat:@"%.2lf", [model.totalPv doubleValue] + [listModel.pv doubleValue] * [listModel.count integerValue]];
//        }
//        shopIdString = listModel.shopId;
//    }
//    
//    return finalArray;
//}

#pragma mark - xib event response
//全选按钮点击事件
- (IBAction)chooseAllButtonClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    for (GYHECartListModel* listModel in self.dataSourceArray) {
        listModel.isSelect = sender.isSelected;
    }
    [self accountAndUpdateShowState];
    [self.tabView reloadData];
}

//结算按钮点击事件
- (IBAction)accountButtonClick:(UIButton*)sender
{
//    NSMutableArray* mArr = [self buildShopArray];
//    NSMutableArray* mArray = [self getDataSource:mArr];
//    if (mArray.count > 0) {
//        GYHESCConfirmOrderViewController* vc = [[GYHESCConfirmOrderViewController alloc] init];
//        vc.dataSourceArray = mArray;
//        vc.isRightAway = @"0";
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else {
//        [GYUtils showToast:kLocalized(@"HE_SC_CartSelectGoods")];
//    }
}

//去购买按钮点击事件
- (IBAction)goToBuyButtonClick:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - LazyLoad
- (NSMutableArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
