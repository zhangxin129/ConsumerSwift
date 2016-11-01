//
//  GYShopDescribeController.m
//  HSConsumer
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopDescribeController.h"
#import "GYAlertView.h"
#import "MenuTabView.h"
#import "GYShopHeader.h"
#import "MJExtension.h"
#import "GYEasyBuyModel.h"
#import "GYShopBaseInfoModel.h"
#import "GYShopGoodListModel.h"
#import "GYArroundGoodDetailViewController.h"
#import "GYAroundSearchShopGoodsViewController.h"
#import "GYPhotoGroupView.h"
#import "GYShopAboutViewController.h"
#import "GYStoreTableViewCell.h"
#import "GYMallBaseInfoModel.h"
#import "GYGIFHUD.h"
//品牌专区
#import "GYShopBrandsController.h"
//分类
#import "GYAroundShopsCategoryController.h"
#import "GYHSLoginViewController.h"
#import "GYHDChatViewController.h"
#import "GYHSLoginManager.h"

#define kCellIdentifier @"storeCellIndentifer"

// 热卖商品用
#define pageCount 6
@interface GYShopDescribeController () <MenuTabViewDelegate, ShopHeaderDelegate, UITableViewDataSource, UITableViewDelegate, StoreTableViewCellDelegate, GYShopBrandsControllerDelegate>
@property (nonatomic, strong) GYShopHeader* headerView;
//**店铺详细*/
@property (nonatomic, strong) GYMallBaseInfoModel* mallDetailInfo;
@property (nonatomic, strong) NSMutableArray* marrAllGoods;
@property (nonatomic, strong) NSMutableArray* marrHotGoods;
@property (nonatomic, strong) NSMutableArray* marrBrandGoods;
@property (weak, nonatomic) IBOutlet UIView* vBottom;
@property (weak, nonatomic) IBOutlet UIButton* btnChat;
@property (weak, nonatomic) IBOutlet UIButton* btnIntrouduce;
@property (weak, nonatomic) IBOutlet UIView* vNavationBar;
@property (weak, nonatomic) IBOutlet UIButton* btnBack;
@property (weak, nonatomic) IBOutlet UIView* searchView;
@property (weak, nonatomic) IBOutlet UILabel* searchLabel;
@property (weak, nonatomic) IBOutlet UIButton* btnType;
@property (weak, nonatomic) IBOutlet UIView* category;

@property (copy, nonatomic) NSString* strBrandName;
@property (nonatomic, strong) UITableView* tableView;
// 热卖商品用
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, assign) BOOL shouldRefresh;
@property (weak, nonatomic) IBOutlet UILabel* classificationLabel; //分类
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, assign) BOOL isNoMoreData;
@property (nonatomic, assign) BOOL isSelectBrand;

@end

@implementation GYShopDescribeController {
    MenuTabView* menu; //菜单视图
}


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self saveHistory];
    self.shouldRefresh = NO;
    self.currentPage = 1;
    self.totalPage = 0;
    self.flag = 0;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
    [self.category addGestureRecognizer:tap];
    self.category.userInteractionEnabled = YES;
    self.category.backgroundColor = kNavigationBarColor;
    [self.btnChat setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    self.btnChat.backgroundColor = [UIColor whiteColor];
    [self.btnIntrouduce setTitleColor:kCellItemTitleColor forState:UIControlStateNormal];
    self.btnIntrouduce.backgroundColor = [UIColor whiteColor];
    [self.btnIntrouduce setTitle:kLocalized(@"GYHE_SurroundVisit_ShopsIntroduction") forState:UIControlStateNormal];
    [self.btnChat setTitle:kLocalized(@"GYHE_SurroundVisit_ContactShop") forState:UIControlStateNormal];
    
    [self.btnType addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.classificationLabel.text = kLocalized(@"GYHE_SurroundVisit_Category");
    self.searchLabel.text = kLocalized(@"GYHE_SurroundVisit_SearchStoreGoods");
    UITapGestureRecognizer* searchTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchTapClick)];
    [self.searchView addGestureRecognizer:searchTap];
    
    self.vNavationBar.backgroundColor = kNavigationBarColor;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    //加载商铺信息（从商铺简介返回时刷新关注状态）
    [self httpRequestForShopInfo];
    
    if(_isSelectBrand) {
        [menu updateMenu:1];
        self.flag = 1;
    }else {
        [menu updateMenu:menu.selectedIndex];
        self.flag = menu.selectedIndex;
    }
    [self.tableView reloadData];
    
}

/*
 修改主界面返回时tabBar不显示问题 add by zhangx
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //只有返回首页才隐藏NavigationBarHidden
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - SystemDelegate

#pragma mark TableView Delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.flag == 2) {
        return self.marrHotGoods.count;
    }
    else if (self.flag == 1) {
        return self.marrBrandGoods.count;
    }
    else if (self.flag == 0) {
        return self.marrAllGoods.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if (kScreenWidth > 410) {
        
        return 280;
    }
    return 250;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYStoreTableViewCell* cell = [GYStoreTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray* arrcELL = nil;
    if (self.flag == 2) {
        arrcELL = self.marrHotGoods[indexPath.row];
    }
    else if (self.flag == 0) {
        arrcELL = self.marrAllGoods[indexPath.row];
    }
    else if (self.flag == 1) {
        arrcELL = self.marrBrandGoods[indexPath.row];
    }
    if (arrcELL.count == 2) {
        cell.leftModel = arrcELL[0];
        cell.rightModel = arrcELL[1];
    }
    else if (arrcELL.count == 1) {
        cell.leftModel = arrcELL[0];
    }
    cell.backgroundColor = kDefaultVCBackgroundColor;
    cell.delegate = self;
    return cell;
}

#pragma mark - CustomDelegate
#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    //    self.isHotGoods = NO;
    self.flag = index;
//    [menu updateMenu:index];
    DDLogDebug(@"%zi====index", index);
    
    if (index != 1) {
        [self setup];
        [self.marrAllGoods removeAllObjects];
        [self.marrHotGoods removeAllObjects];
        
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView reloadData];
    }
    
    if (index == 0) {
        [menu updateMenu:index];
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:nil sortType:nil];
    }
    else if (index == 2) {
        [menu updateMenu:index];
        [self getHotGoods];
    }
    else if (index == 1) {
        //        品牌专区
        if (self.isNoMoreData) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        else {
            [self.tableView.mj_footer endRefreshing];
        }
        [self.tableView reloadData];
        GYShopBrandsController* vcBrand = [[GYShopBrandsController alloc] init];
        vcBrand.strShopID = self.shopModel.strVshopId;
        vcBrand.delegate = self;
        [self.navigationController pushViewController:vcBrand animated:YES];
    }
}

- (void)menuTabViewDidSelectIndex:(NSInteger)index
{
    if (index == 1) {
        DDLogDebug(@"%zi====index", index);
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView reloadData];
        
        GYShopBrandsController* vcBrand = [[GYShopBrandsController alloc] init];
        vcBrand.strShopID = self.shopModel.strVshopId;
        vcBrand.delegate = self;
        [self.navigationController pushViewController:vcBrand animated:YES];
    }
}

#pragma mark ShopBrandDelegate
- (void)ShopBrandDidChooseBrand:(NSArray*)brand
{
    
    if (brand.count > 0) {
        _isSelectBrand = YES;
    }
    else {
        _isSelectBrand = NO;
    }
    
    NSString* brandName = [brand componentsJoinedByString:@","];
    [self setup];
    self.currentPage = 1;
    if (![self.strBrandName isEqualToString:brandName] && ![brandName isEqualToString:@""]) {
        
        [self.marrBrandGoods removeAllObjects];
        [self.tableView.mj_footer resetNoMoreData];
        [self.tableView reloadData];
        
        self.strBrandName = brandName;
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:brandName sortType:nil];
    }
}

#pragma mark ShopHeaderDelegate
- (void)ShopHeaderDidSelectShowBigPicWithHeader:(GYShopHeader*)header index:(NSInteger)index
{
    [self showBigPicWithIndex:index];
}

- (void)ShopHeaderDidSelectPayAtentionBtn:(GYShopHeader*)header
{
    // 关注或者取消关注
    [self concernShopRequest];
}

#pragma mark StoreTableViewCellDelegate
- (void)StoreTableView:(GYStoreTableViewCell*)cell chooseOne:(NSInteger)type model:(GYShopGoodListModel*)model
{
    [self loadHotGoodInfoWithItemid:model.itemId vShopid:self.shopModel.strVshopId shopID:model.shopId];
}

#pragma mark - event response
- (void)footerRereshing
{
    if (self.flag == 2) {
        [self getHotGoods];
    }
    else if (self.flag == 0) {
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:nil sortType:nil];
    }
    else {
        [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:self.strBrandName sortType:nil];
    }
}

- (IBAction)back:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tapClick
{
    GYAroundShopsCategoryController* vcCategory = [[GYAroundShopsCategoryController alloc] init];
    vcCategory.pushedVC = self;
    vcCategory.strShopID = self.shopModel.strVshopId;
    [self.navigationController pushViewController:vcCategory animated:YES];
}

- (void)searchTapClick
{
    //搜索
    GYAroundSearchShopGoodsViewController* searchVc = [[GYAroundSearchShopGoodsViewController alloc] init];
    searchVc.vshopId = self.shopModel.strVshopId;
    searchVc.isNeedLoad = NO;
    [self.navigationController pushViewController:searchVc animated:YES];
}

//商铺简介
- (IBAction)showIntroduct:(id)sender
{
    GYShopAboutViewController* vcShopDetail = [[GYShopAboutViewController alloc] init];
    vcShopDetail.ShopID = self.shopModel.strShopId;
    vcShopDetail.strVshopId = self.shopModel.strVshopId;
    [self.navigationController pushViewController:vcShopDetail animated:YES];
}

- (IBAction)chatClick:(id)sender
{
    [self contactShopRequest];
}

//热卖 getHotItemsByVshopId
- (void)getHotGoods
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.shopModel.strVshopId forKey:@"vshopId"];
    [dict setValue:[NSString stringWithFormat:@"%d", pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi", self.currentPage] forKey:@"currentPage"];
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetHotItemsByVshopIdUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        if (self.marrHotGoods.count > 0 && ![self.tableView.mj_footer isRefreshing]) {
            [self.marrHotGoods removeAllObjects];
        }
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            if (!error) {
                
                NSString *retCode = kSaftToNSString(ResponseDic[@"retCode"]);
                self.totalPage = kSaftToNSInteger(ResponseDic[@"totalPage"]);
                NSArray *arrData = ResponseDic[@"data"];
                if (![arrData isKindOfClass:[NSNull class]] && [retCode isEqualToString:@"200"]) {
                    if ([ResponseDic[@"data"] count] > 0) {
                        self.currentPage++;
                    }
                    NSMutableArray *arrCell = [NSMutableArray array];
                    for (int i = 0; i < arrData.count; i++) {
                        NSDictionary *tempDict = arrData[i];
                        GYShopGoodListModel *goodModel = [[GYShopGoodListModel alloc] init];
                        goodModel.itemId = kSaftToNSString(tempDict[@"itemId"]);
                        goodModel.itemName = kSaftToNSString(tempDict[@"itemName"]);
                        goodModel.price = kSaftToNSString(tempDict[@"price"]);
                        goodModel.pv = kSaftToNSString(tempDict[@"pv"]);
                        goodModel.rate = kSaftToNSString(tempDict[@"rate"]);
                        goodModel.salesCount = kSaftToNSString(tempDict[@"salesCount"]);
                        goodModel.url = kSaftToNSString(tempDict[@"url"]);
                        goodModel.shopId = kSaftToNSString(tempDict[@"shopId"]);
                        [arrCell addObject:goodModel];
                        if (i%2 == 1) {
                            [self.marrHotGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        } else if (i%2 != 1 && i == arrData.count-1) {
                            [self.marrHotGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                    }
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        [self.tableView reloadData];
        if (self.totalPage == 0 || self.totalPage == 1 || self.currentPage == self.totalPage+1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.mj_footer endRefreshing];
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}



#pragma mark - private methods
- (void)setup
{
    self.currentPage = 1;
    self.totalPage = 0;
}

#pragma mark 加载店铺信息
- (void)httpRequestForShopInfo
{
    [GYGIFHUD show];
    //经纬度传空
    [GYMallBaseInfoModel loadBigShopDataWithVshopid:self.shopModel.strVshopId landMark:@"" result:^(NSDictionary* dictData, NSError* error, NSString* retCode) {
        
        [GYGIFHUD dismiss];
        if (error.code == 855) {
            [GYAlertView showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")
                        confirmBlock:^{
                            [self.navigationController popViewControllerAnimated:YES];
                        }];
            return;
        }
        if (!dictData) {
            
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_RequestError")];
            
        }
        
        self.mallDetailInfo = [GYMallBaseInfoModel mj_objectWithKeyValues:dictData];
        if (self.headerView) {
            self.headerView.model = self.mallDetailInfo;
        }
        if (!self.shouldRefresh) {
            [self httpRequestForGoodsWithKeyWords:nil categoryName:nil brandName:nil sortType:nil];
        }
        
        [_headerView changePayAttentionBtnWithStatus:self.mallDetailInfo.beFocus];
    }];
}

//联系商家请求
- (void)contactShopRequest
{
    kCheckLogined
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@", self.mallDetailInfo.companyResourceNo] forKey:@"resourceNo"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            if (!error) {
                
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"] && [ResponseDic[@"data"] isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GYHDChatViewController *chatViewController = [[GYHDChatViewController alloc] init];
                        
                        chatViewController.companyInformationDict = responseObject;
                        [self.navigationController pushViewController:chatViewController animated:YES];
                        
                        
                    });
                }
            } else {
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ContactFailure") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [request start];
}

// add by songjk
- (void)loadHotGoodInfoWithItemid:(NSString*)itemid vShopid:(NSString*)vShopid shopID:(NSString*)shopID
{
    __block SearchGoodModel* MOD;
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    if (globalData.loginModel.token == nil) {
        
        [dict setValue:@"" forKey:@"key"];
    }
    else {
        [dict setValue:globalData.loginModel.token forKey:@"key"];
    }
    
    [dict setValue:[NSString stringWithFormat:@"%@", shopID] forKey:@"shopId"];
    [dict setValue:[NSString stringWithFormat:@"%@", itemid] forKey:@"itemId"];
    [dict setValue:[NSString stringWithFormat:@"%@", vShopid] forKey:@"vShopId"];
    
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            if (!error) {
                
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                
                
                if ([retCode isEqualToString:@"200"]) {
                    NSDictionary *tempDic = ResponseDic[@"data"];
                    MOD = [[SearchGoodModel alloc] init];
                    MOD.name = kSaftToNSString(tempDic[@"itemName"]);
                    MOD.addr = kSaftToNSString(tempDic[@"addr"]);
                    MOD.beCash = kSaftToNSString(tempDic[@"beCash"]);
                    MOD.beReach = kSaftToNSString(tempDic[@"beReach"]);
                    MOD.beSell = kSaftToNSString(tempDic[@"beSell"]);
                    MOD.beTake = kSaftToNSString(tempDic[@"beTake"]);
                    MOD.beTicket = kSaftToNSString(tempDic[@"beTicket"]);
                    MOD.goodsId = kSaftToNSString(tempDic[@"id"]);
                    NSNumber *lat = tempDic[@"lat"];
                    MOD.shoplat = [NSString stringWithFormat:@"%f", [lat floatValue]];
                    NSNumber *longitude = tempDic[@"longitude"];
                    MOD.shoplongitude = [NSString stringWithFormat:@"%f", [longitude floatValue]];
                    MOD.shopsName = kSaftToNSString(tempDic[@"name"]);
                    NSNumber *price = tempDic[@"price"];
                    MOD.price = [NSString stringWithFormat:@"%0.02f", [price floatValue]];
                    NSNumber *pv = tempDic[@"pv"];
                    MOD.goodsPv = [NSString stringWithFormat:@"%.02f", [pv floatValue]];
                    MOD.shopId = kSaftToNSString(tempDic[@"shopId"]);
                    
                    MOD.moonthlySales = kSaftToNSString(tempDic[@"monthlySales"]);
                    MOD.saleCount = kSaftToNSString(tempDic[@"salesCount"]);
                    if ([kSaftToNSString(tempDic[@"tel"]) length] > 0) {
                        MOD.shopTel = kSaftToNSString(tempDic[@"tel"]);
                    } else {
                        MOD.shopTel = @" ";
                    }
                    
                    
                    MOD.vShopId = kSaftToNSString(tempDic[@"vShopId"]);
                    MOD.shopSection = kSaftToNSString(tempDic[@"area"]);
                    
                    CLLocationCoordinate2D shopCoordinate;
                    shopCoordinate.latitude = MOD.shoplat.floatValue;
                    shopCoordinate.longitude = MOD.shoplongitude.floatValue;
                    BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                    BMKMapPoint mp1 = BMKMapPointForCoordinate(globalData.locationCoordinate);
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                    DDLogDebug(@"%f-----dis,mp1.x = %f,mp1.y = %f", dis, mp1.x, mp1.y);
                    MOD.shopDistance = [NSString stringWithFormat:@"%.01f", dis/1000];
                }
            }
            
            
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        
        
        GYArroundGoodDetailViewController *vcGoodDetail = [[GYArroundGoodDetailViewController alloc] initWithNibName:@"GYArroundGoodDetailViewController" bundle:nil];
        
        vcGoodDetail.model = MOD;
        
        [self.navigationController pushViewController:vcGoodDetail animated:YES];
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    
}

- (void)concernShopRequest
{
    kCheckLogined
    //已经关注  就取消关注
    if (self.mallDetailInfo.beFocus)
    {
        [GYGIFHUD show];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%@", self.shopModel.strVshopId] forKey:@"vShopId"];
        [dict setValue:self.shopModel.strVshopId forKey:@"shopId"];
        [dict setValue:globalData.loginModel.token forKey:@"key"];
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:CancelConcernShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            if (!error) {
                NSDictionary *ResponseDic = responseObject;
                if (!error) {
                    NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"]) {
                        self.mallDetailInfo.beFocus = !self.mallDetailInfo.beFocus;
                        [self.headerView changePayAttentionBtnWithStatus:self.mallDetailInfo.beFocus];
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_CancelShopFocusSuccess")];
                    } else {
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_CancelShopFail")];
                    }
                }
            }else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
        }];
        [request start];
    }
    else
    {
        [GYGIFHUD show];
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        if(self.mallDetailInfo) {
            [dict setValue:[NSString stringWithFormat:@"%@", self.shopModel.strVshopId] forKey:@"vShopId"];
            [dict setValue:globalData.loginModel.token forKey:@"key"];
            [dict setValue:self.mallDetailInfo.vShopName forKey:@"shopName"];
        }
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:ConcernShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            
            [GYGIFHUD dismiss];
            if (!error) {
                NSDictionary *ResponseDic = responseObject;
                if (!error) {
                    NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                    if ([retCode isEqualToString:@"200"]) {
                        self.mallDetailInfo.beFocus = !self.mallDetailInfo.beFocus;
                        [self.headerView changePayAttentionBtnWithStatus:self.mallDetailInfo.beFocus];
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_FocusShopSuccess")];
                    } else {
                        [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_FocusFail")];
                    }
                }
            }else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
        }];
        [request start];
    }
}

- (void)showBigPicWithIndex:(NSInteger)index
{
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, max = self.mallDetailInfo.picList.count; i < max; i++) {
        
        UIImageView *imageV = self.headerView.svBack.subviews[i];
        GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
        item.thumbView = imageV;
        GYShopBaseInfoPicListModel* model = self.mallDetailInfo.picList[i];
        
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString(model.url)];
        
        [items addObject:item];
    }
    
    GYPhotoGroupView* v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:self.headerView.svBack.subviews[index] toContainer:self.navigationController.view animated:YES completion:nil];
}

#pragma mark 加载全部商品
- (void)httpRequestForGoodsWithKeyWords:(NSString*)keyWords categoryName:(NSString*)categoryName brandName:(NSString*)brandName sortType:(NSString*)sortType
{
    self.shouldRefresh = YES;
    if (categoryName == nil) {
        categoryName = @"";
    }
    if (brandName == nil) {
        brandName = @"";
    }
    if (keyWords == nil) {
        keyWords = @"";
    }
    if (sortType == nil) {
        sortType = @"1";
    }
    //    keyWords = @"白酒";
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [dict setValue:self.shopModel.strVshopId forKey:@"vShopId"];
    [dict setValue:keyWords forKey:@"keyword"];
    [dict setValue:categoryName forKey:@"categoryName"];
    [dict setValue:@"" forKey:@"categoryId"]; // add by songjk 传入cid
    [dict setValue:brandName forKey:@"brandName"];
    [dict setValue:sortType forKey:@"sortType"];
    [dict setValue:[NSString stringWithFormat:@"%d", pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi", self.currentPage] forKey:@"currentPage"];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:SearchShopItemUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        
        if (!error) {
            if (self.flag == 0) {
                if (self.marrAllGoods.count > 0 && ![self.tableView.mj_footer isRefreshing]) {
                    [self.marrAllGoods removeAllObjects];
                }
            } else if (self.flag == 1) {
                if (self.marrBrandGoods.count > 0 && ![self.tableView.mj_footer isRefreshing]) {
                    [self.marrBrandGoods removeAllObjects];
                }
            }
            
            NSDictionary *ResponseDic = responseObject;
            
            NSInteger retCode = kSaftToNSInteger(ResponseDic[@"retCode"]);
            self.totalPage = kSaftToNSInteger(ResponseDic[@"totalPage"]);
            if (retCode == 200 && [ResponseDic[@"data"] isKindOfClass:[NSArray class]]) {
                if ([ResponseDic[@"data"] count] > 0) {
                    self.currentPage++;
                }
                NSArray *arrData = ResponseDic[@"data"];
                NSMutableArray *arrCell = [NSMutableArray array];
                for (int i = 0; i < arrData.count; i++) {
                    GYShopGoodListModel *goodModel = [GYShopGoodListModel mj_objectWithKeyValues:arrData[i]];
                    [arrCell addObject:goodModel];
                    if (i%2 == 1) {
                        if (self.flag == 0) {
                            [self.marrAllGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        } else if (self.flag == 1) {
                            [self.marrBrandGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                        
                    } else if (i%2 != 1 && i == arrData.count-1) {
                        if (self.flag == 0) {
                            [self.marrAllGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        } else if (self.flag == 1) {
                            [self.marrBrandGoods addObject:arrCell];
                            arrCell = [NSMutableArray array];
                        }
                        
                    }
                }
                
            }
            
        } else {
            [GYUtils parseNetWork:error resultBlock:nil];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        [self.tableView reloadData];
        if (self.totalPage == 0 || self.totalPage == 1 || self.currentPage == self.totalPage+1) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            if (self.flag == 1) {
                self.isNoMoreData = YES;
            }
        }
        if ([self.tableView.mj_footer isRefreshing]) {
            [self.tableView.
             
             mj_footer endRefreshing];
            if (self.flag == 1) {
                self.isNoMoreData = NO;
            }
        }
    }];
    [request start];
}

- (void)saveHistory {
    
    // 用于保存本地浏览记录
    NSData* visitdata = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyForVisitHistory];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:visitdata];
    NSMutableArray* visitArr = [[NSMutableArray alloc] init];
    if (array) {
        [visitArr addObjectsFromArray:array];
    }
    if (visitArr.count == 0) {
        [visitArr addObject:self.shopModel];
    }
    else {
        
        for (int i = 0;i < visitArr.count; i++) {
            ShopModel* tempModel = visitArr[i];
            if([tempModel.strShopId isEqualToString:self.shopModel.strShopId]) {
                [visitArr removeObject:tempModel];
            }
            
        }
        if (visitArr.count == 5) {
            [visitArr removeLastObject];
        }
        [visitArr insertObject:self.shopModel atIndex:0];
        
    }
    visitdata = [NSKeyedArchiver archivedDataWithRootObject:visitArr];
    [[NSUserDefaults standardUserDefaults] setObject:visitdata forKey:kKeyForVisitHistory];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - getters and setters
- (NSMutableArray*)marrHotGoods
{
    if (_marrHotGoods == nil) {
        _marrHotGoods = [[NSMutableArray alloc] init];
    }
    return _marrHotGoods;
}

- (NSMutableArray*)marrBrandGoods
{
    if (_marrBrandGoods == nil) {
        _marrBrandGoods = [[NSMutableArray alloc] init];
    }
    return _marrBrandGoods;
}

- (NSMutableArray*)marrAllGoods
{
    if (!_marrAllGoods) {
        _marrAllGoods = [NSMutableArray array];
    }
    return _marrAllGoods;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        CGFloat tableViewY = 64;
        CGFloat tableViewH = kScreenHeight - self.vBottom.frame.size.height - tableViewY;

        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableViewY, kScreenWidth, tableViewH)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [[UIView alloc] init];
        [self.tableView registerNib:[UINib nibWithNibName:@"GYStoreTableViewCell" bundle:nil] forCellReuseIdentifier:kCellIdentifier];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = kDefaultVCBackgroundColor;
        
        GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
            [self footerRereshing];

        }];

        self.tableView.mj_footer = footer;
        [self.view addSubview:self.tableView];
        
        UIView* HeaderView = [[UIView alloc] init];
        HeaderView.backgroundColor = [UIColor clearColor];

        self.headerView = [GYShopHeader initWithXib];
        self.headerView.frame = CGRectMake(0, 0, kScreenWidth, self.headerView.frame.size.height);
        self.headerView.model = self.mallDetailInfo;
        self.headerView.delegate = self;
        [HeaderView addSubview:self.headerView];

        CGFloat menuH = 40;
        //    NSArray *   menuTitles = @[@"全部商品", @"品牌专区",@"热销商品"];
        NSArray* menuTitles = @[ kLocalized(@"GYHE_SurroundVisit_AllCommodities"), kLocalized(@"GYHE_SurroundVisit_Brandzone"), kLocalized(@"GYHE_SurroundVisit_Hotseller") ];
        menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), kScreenWidth, menuH) isShowSeparator:YES];
        menu.delegate = self;
        [HeaderView addSubview:menu];
        HeaderView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(menu.frame));
        self.tableView.tableHeaderView = HeaderView;
        [self.view bringSubviewToFront:self.vNavationBar];
    }
    return _tableView;
}

- (NSString*)strBrandName
{
    if (!_strBrandName) {
        _strBrandName = @"";
    }
    return _strBrandName;
}


@end
