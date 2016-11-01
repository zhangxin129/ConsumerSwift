//
//  GYHESCShoppingCartViewController.m
//  GYHSConsumer_MyHE
//
//  Created by admin on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#define kShoppingCartCell @"shoppingCartCell"

#import "GYHESCShoppingCartViewController.h"
#import "GYAlertView.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYHESCCartListModel.h"
#import "GYHESCCartTableViewCell.h"
#import "GYHESCChooseAreaModel.h"
#import "GYHESCChooseAreaViewController.h"
#import "GYHESCConfirmOrderViewController.h"
#import "GYHESCOrderModel.h"
#import "JSONModel+ResponseObject.h"

typedef NS_ENUM(NSInteger, GYHESCCartRequestType) {
    GYHESCCartList = 100, //购物车列表
    GYHESCDeleteGoodsList, //删除购物车
    GYHESCCartMaxNumber //最大购买数量
};

@interface GYHESCShoppingCartViewController () <UITableViewDelegate, UITableViewDataSource, GYNetRequestDelegate, GYHESCCartCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView* tabView;
@property (weak, nonatomic) IBOutlet UILabel* selectedAlllabel;
@property (weak, nonatomic) IBOutlet UIButton* selectedAllButton; //全选按钮
@property (weak, nonatomic) IBOutlet UILabel* totalLabel; //总计标签
@property (weak, nonatomic) IBOutlet UILabel* moneyLabel; //金额总数
@property (weak, nonatomic) IBOutlet UILabel* pvLabel; //积分总数
@property (weak, nonatomic) IBOutlet UIButton* accountButton; //结算按钮

@property (nonatomic, strong) NSMutableArray* dataSourceArray; //数据源
@property (nonatomic, assign) BOOL isSelectAll; //是否全选
@property (nonatomic, assign) NSInteger maxNumber; //最大购买数量

@property (weak, nonatomic) IBOutlet UIView* emptyCartView; //空购物车界面
@property (weak, nonatomic) IBOutlet UIView* noNetWorkView; //无网络界面
@property (weak, nonatomic) IBOutlet UILabel* emptyCartLabel; //空购物车提醒
@property (weak, nonatomic) IBOutlet UIButton* goToBuyButton; //去购买
@property (weak, nonatomic) IBOutlet UILabel* netErrorLabel; //网络错误
@property (weak, nonatomic) IBOutlet UILabel* setNetAgainLabel; //检查网络

@end

@implementation GYHESCShoppingCartViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    kCheckLogined
        [self maxNumberNetworkRequest];
    [self basicSettings];
    [self.tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHESCCartTableViewCell class]) bundle:nil] forCellReuseIdentifier:kShoppingCartCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    // TODO:没有从错误码中获取
    DDLogDebug(@"%@", error);
    if (netRequest.tag == GYHESCDeleteGoodsList) {
        [GYAlertView showMessage:kLocalized(@"HE_SC_CartDeleteFail")];
    } else if (netRequest.tag == GYHESCCartList) {
        [GYGIFHUD dismiss];
        self.noNetWorkView.hidden = NO;
    } else {
        //如果没有获取到最大购买量，设为100
        self.maxNumber = 100;
        [self networkRequestData];
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{
    self.noNetWorkView.hidden = YES;
    if (netRequest.tag == GYHESCCartList) {
        [GYGIFHUD dismiss];
        //        NSArray* array = [GYHESCCartListModel modelArrayWithResponseObject:responseObject error:nil];
        //        self.dataSourceArray = [NSMutableArray arrayWithArray:array];
        [self.dataSourceArray removeAllObjects];
        for (NSDictionary* dict in responseObject[@"data"]) {
            GYHESCCartListModel* listModel = [[GYHESCCartListModel alloc] initWithDictionary:dict error:nil];
            //过滤不合格的商品
            if ([listModel.count integerValue] > 0 && [listModel.count integerValue] <= self.maxNumber) {
                [self.dataSourceArray addObject:listModel];
            }
        }
        if (self.dataSourceArray.count == 0) {
            self.emptyCartView.hidden = NO;
        } else {
            self.emptyCartView.hidden = YES;
        }
        [self.tabView reloadData];

        self.isSelectAll = NO;
        self.selectedAllButton.selected = self.isSelectAll;
        self.moneyLabel.text = @"0.00";
        self.pvLabel.text = @"0.00";
    } else if (netRequest.tag == GYHESCDeleteGoodsList) {
        [GYAlertView showMessage:kLocalized(@"HE_SC_CartDeleteSuccess")
                    confirmBlock:^{
                        [self networkRequestData]; //删除成功后再次请求数据
                    }];
    } else {
        self.maxNumber = [responseObject[@"data"] integerValue];
        [self networkRequestData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHESCCartTableViewCell* cartCell = [tableView dequeueReusableCellWithIdentifier:kShoppingCartCell forIndexPath:indexPath];
    [cartCell setSelectionStyle:UITableViewCellSelectionStyleNone]; //隐藏cell点击效果
    cartCell.delegate = self;
    cartCell.indexPath = indexPath;
    cartCell.maxNumber = self.maxNumber;
    GYHESCCartListModel* cartModel = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        cartModel = self.dataSourceArray[indexPath.row];
    }
    cartCell.listModel = cartModel;
    WS(weakSelf);
    cartCell.accountBlock = ^{
        double totalPrice = 0;
        double totalPv = 0;
        BOOL isChooseAll = YES;
        for (GYHESCCartListModel* listModel in weakSelf.dataSourceArray) {
            if (listModel.isSelect) {
                totalPrice += [listModel.count doubleValue] * [listModel.price doubleValue];
                totalPv += [listModel.count doubleValue] * [listModel.pv doubleValue];
            } else {
                isChooseAll = NO;
            }
        }
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2lf", totalPrice];
        weakSelf.pvLabel.text = [NSString stringWithFormat:@"%.2lf", totalPv];
        weakSelf.isSelectAll = isChooseAll;
        weakSelf.selectedAllButton.selected = isChooseAll;
    };

    [cartCell refreshDataWithModel:cartModel];
    return cartCell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHESCCartListModel* listModel = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        listModel = self.dataSourceArray[indexPath.row];
    }
    if (listModel.couponDesc && listModel.couponDesc.length > 0 && listModel.isShowMore) {
        return 335.0f;
    } else if (listModel.couponDesc && listModel.couponDesc.length > 0 && !listModel.isShowMore) {
        return 310.0f;
    } else {
        return 280.0f;
    }
}

#pragma mark - GYHESCCartCellDelegate
- (void)pushToChooseAreaWithIndexPath:(NSIndexPath*)indexPath
{
    GYHESCChooseAreaViewController* vc = [[GYHESCChooseAreaViewController alloc] init];
    vc.chooseBlock = ^(GYHESCChooseAreaModel* areaModel) {
        GYHESCCartListModel* listModel = nil;
        if (self.dataSourceArray.count > indexPath.row) {
            listModel = self.dataSourceArray[indexPath.row];
        }
        listModel.shopName = areaModel.shopName;
        listModel.shopId = areaModel.shopId;
        GYHESCCartTableViewCell* cartCell = (GYHESCCartTableViewCell*)[self.tabView cellForRowAtIndexPath:indexPath];
        cartCell.storeLabel.text = listModel.shopName;
    }; //返回营业点名称

    GYHESCCartListModel* cartModel = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        cartModel = self.dataSourceArray[indexPath.row];
    }
    vc.vShopId = cartModel.vShopId;
    vc.itemId = cartModel.id;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToItemDetailWithIndexPath:(NSIndexPath*)indexPath
{
    GYEasybuyGoodsInfoViewController* vc = [[GYEasybuyGoodsInfoViewController alloc] init];
    GYHESCCartListModel* listModel = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        listModel = self.dataSourceArray[indexPath.row];
    }
    vc.itemId = listModel.id;
    vc.vShopId = listModel.vShopId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteCartCell:(NSIndexPath*)indexPath
{
    GYHESCCartListModel* listModel = nil;
    if (self.dataSourceArray.count > indexPath.row) {
        listModel = self.dataSourceArray[indexPath.row];
    }
    [self deleteGoodsList:listModel.cartId removeCellForIndex:indexPath.row];
}

- (void)resetCartCell:(NSIndexPath*)indexPath
{
    [self.tabView reloadData];
}

#pragma mark - custom methods
//网络请求
- (void)networkRequestData
{

    NSMutableDictionary* mParameterDic = [[NSMutableDictionary alloc] init];
    [mParameterDic setValue:globalData.loginModel.token forKey:@"key"];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyGetCartListUrl parameters:mParameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = GYHESCCartList;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    [GYGIFHUD showFullScreen];
}

// 删除购物车列表,网络请求函数，包含网络等待弹窗控件，数据解析回调函数
- (void)deleteGoodsList:(NSString*)cartId removeCellForIndex:(NSInteger)index
{
    NSDictionary* parameterDic = @{ @"key" : globalData.loginModel.token,
        @"cartItemsId" : cartId };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyDeleteCartUrl parameters:parameterDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = GYHESCDeleteGoodsList;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//最大购买数量网络请求
- (void)maxNumberNetworkRequest
{
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self baseURL:nil URLString:EasyBuyGetCartMaxSizeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = GYHESCCartMaxNumber;
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

//基本设置
- (void)basicSettings
{
    self.title = kLocalized(@"HE_SC_CartShoppingCartTitle");
    self.tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tabView setTableFooterView:[[UIView alloc] init]];

    //    [self.selectedAllButton setTitle:kLocalized(@"HE_SC_CartChooseAll") forState:UIControlStateNormal];
    self.selectedAlllabel.text = kLocalized(@"HE_SC_CartChooseAll");

    self.totalLabel.text = kLocalized(@"HE_SC_CartTotal");
    [self.accountButton setTitle:kLocalized(@"HE_SC_CartAccount") forState:UIControlStateNormal];
    //以下为空购物车和无网络状态时的显示设置
    self.emptyCartLabel.text = kLocalized(@"HE_SC_CartEmptyShopingNow");
    self.netErrorLabel.text = kLocalized(@"HE_SC_CartNetError");
    self.setNetAgainLabel.text = kLocalized(@"HE_SC_Cartpleasecheckthenetwork");
    [self.goToBuyButton setTitle:kLocalized(@"HE_SC_CartGoToBuy") forState:UIControlStateNormal];
    self.goToBuyButton.layer.borderWidth = 1.0f;
    self.goToBuyButton.layer.cornerRadius = 2.0f;
    self.goToBuyButton.layer.borderColor = kDefaultViewBorderColor.CGColor;
}

// 拆单
- (NSMutableArray*)buildShopArray
{
    NSMutableArray* mutableArray = [[NSMutableArray alloc] init];
    for (GYHESCCartListModel* listModel in self.dataSourceArray) {
        if (listModel.isSelect && [listModel.count integerValue] > 0) {
            [mutableArray addObject:listModel];
        }
    }

    //构建排序描述器
    NSSortDescriptor* shopIdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"shopId" ascending:YES];
    NSSortDescriptor* skuIdDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"skuId" ascending:YES];
    //把排序描述器放进数组里，放入的顺序就是你想要排序的顺序
    NSArray* descriptorArray = [NSArray arrayWithObjects:shopIdDescriptor, skuIdDescriptor, nil];
    NSArray* sortedArray = [mutableArray sortedArrayUsingDescriptors:descriptorArray];

    NSMutableArray* finalArray = [[NSMutableArray alloc] init];
    NSString* shopIdString = @"0";
    for (GYHESCCartListModel* listModel in sortedArray) {
        if (![shopIdString isEqualToString:listModel.shopId]) {
            GYHESCOrderModel* model = [[GYHESCOrderModel alloc] init];
            model.vShopName = listModel.vShopName;
            model.vShopId = listModel.vShopId;
            model.modelArray = [[NSMutableArray alloc] initWithObjects:listModel, nil];
            model.totalNumber = listModel.count;
            model.totalMoney = [NSString stringWithFormat:@"%.2lf", [listModel.price doubleValue] * [listModel.count integerValue]];
            model.totalPv = [NSString stringWithFormat:@"%.2lf", [listModel.pv doubleValue] * [listModel.count integerValue]];
            model.shopName = listModel.shopName;
            model.shopId = listModel.shopId;
            model.sendWay = kLocalized(@"HE_SC_OrderDistributionWay");
            model.payOffWay = kLocalized(@"HE_SC_OrderPaymentMethod");

            if ([listModel.isApplyCard isEqualToString:@"1"]) {
                model.enableApplyCard = YES;
            }
            [finalArray addObject:model];
        } else {
            GYHESCOrderModel* model = [finalArray lastObject];
            [model.modelArray addObject:listModel];
            model.totalNumber = [NSString stringWithFormat:@"%ld", [model.totalNumber integerValue] + [listModel.count integerValue]];
            model.totalMoney = [NSString stringWithFormat:@"%.2lf", [model.totalMoney doubleValue] + [listModel.price doubleValue] * [listModel.count integerValue]];
            model.totalPv = [NSString stringWithFormat:@"%.2lf", [model.totalPv doubleValue] + [listModel.pv doubleValue] * [listModel.count integerValue]];
        }
        shopIdString = listModel.shopId;
    }

    return finalArray;
}

#pragma mark - 懒加载
- (NSMutableArray*)dataSourceArray
{
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}

#pragma mark - xib event response
//全选按钮点击事件
- (IBAction)chooseAllButtonClick:(UIButton*)sender
{
    self.isSelectAll = !self.isSelectAll;
    double totalPrice = 0;
    double totalPv = 0;
    if (self.isSelectAll) {
        sender.selected = YES;
        for (GYHESCCartListModel* listModel in self.dataSourceArray) {
            listModel.isSelect = self.isSelectAll;
            totalPrice += [listModel.count doubleValue] * [listModel.price doubleValue];
            totalPv += [listModel.count doubleValue] * [listModel.pv doubleValue];
        }
    } else {
        sender.selected = NO;
        for (GYHESCCartListModel* listModel in self.dataSourceArray) {
            listModel.isSelect = self.isSelectAll;
        }
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2lf", totalPrice];
    self.pvLabel.text = [NSString stringWithFormat:@"%.2lf", totalPv];
    [self.tabView reloadData];
}

//结算按钮点击事件
- (IBAction)accountButtonClick:(UIButton*)sender
{
    NSMutableArray* mArray = [self buildShopArray];
    if (mArray.count > 0) {
        GYHESCConfirmOrderViewController* vc = [[GYHESCConfirmOrderViewController alloc] init];
        vc.dataSourceArray = mArray;
        vc.isRightAway = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [GYAlertView showMessage:kLocalized(@"HE_SC_CartSelectGoods")];
    }
}

//去购买按钮点击事件
- (IBAction)goToBuyButtonClick:(UIButton*)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
