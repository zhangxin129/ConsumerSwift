//
//  GYEasybuyGoodsInfoViewController.m
//  HSConsumer
//
//  Created by zhangqy on 15/11/11.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import "GYEasybuyGoodsInfoViewController.h"
#import "GYHSLoginViewController.h"
#import "GYShopDescribeController.h"
#import "GYEasyBuyModel.h"
#import "GYHSLoginManager.h"
#import "GYEasybuyGoodsInfoModel.h"
#import "GYEasybuyGoodsInfoTableViewCell.h"
#import "GYHDChatViewController.h"
#import "GYEasybuyGoodsInfoItemTableViewCell.h"
#import "GYEasybuyGoodsInfoPropListTableViewCell.h"
#import "GYEasybuyGoodsInfoPropBuyNumTableViewCell.h"
#import "UIView+CustomBorder.h"
#import "GYNetRequest.h"
#import "JSONModel+ResponseObject.h"
#import "GYEasybuyShopAddressViewController.h"
#import "GYEasybuyBasicInfoViewController.h"
#import "GYEasybuyEvaluationViewController.h"
#import "GYPhotoGroupView.h"
#import "GYSocialDataService.h"
#import "GYHEUtil.h"
#import "Masonry.h"
#import "GYPhotoScrollView.h"
#import "GYEasybuyGoodsInfoPropView.h"
#import "GYAppDelegate.h"

#define GYEasybuyGoodsInfoTableViewCellReuseId @"GYEasybuyGoodsInfoTableViewCellReuseId"
#define GYEasybuyGoodsInfoItemTableViewCellReuseId @"GYEasybuyGoodsInfoItemTableViewCellReuseId"

#define GYEasybuyGoodsInfoPropListTableViewCellReuseId @"GYEasybuyGoodsInfoPropListTableViewCellReuseId"
#define GYEasybuyGoodsInfoPropBuyNumTableViewCellReuseId @"GYEasybuyGoodsInfoPropBuyNumTableViewCellReuseId"

@interface GYEasybuyGoodsInfoViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIWebViewDelegate, GYNetRequestDelegate, GYEasybuyGoodsInfoTableViewCellDelegate>

@property (strong, nonatomic) GYEasybuyGoodsInfoModel* model;
@property (nonatomic, copy) NSString* skuId;
@property (nonatomic, copy) NSString* sku;
@property (nonatomic, strong) NSMutableDictionary* skuDict;

@property (strong, nonatomic) UIScrollView* photoScrollView;//左右
@property (strong, nonatomic) UIPageControl* pageControl;
@property (strong, nonatomic) NSMutableArray* goodsImageurlstrings;//图片数组
@property (strong, nonatomic) UIView* headerView;
@property (strong, nonatomic) NSMutableArray* itemDataSource;//[选择营业点，选择，基本参数，商品详情]
@property (strong, nonatomic) IBOutlet UIScrollView* mainScrollView;//上下
@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) IBOutlet UIWebView* webView;
@property (weak, nonatomic) IBOutlet UIView* gotoShopView;//进入商铺
@property (weak, nonatomic) IBOutlet UIView* contactCustomerServiceView;//联系卖家
@property (weak, nonatomic) IBOutlet UIButton* buyButton;//立即购买
@property (weak, nonatomic) IBOutlet UIButton* putToCartButton;//加入购物车
@property (weak, nonatomic) IBOutlet UILabel* gotoShopLabel;
@property (weak, nonatomic) IBOutlet UILabel* contactCustomerServiceLabel;

@property (weak, nonatomic) IBOutlet UIView* backgroundHalpBalckView;//半透明黑色背景
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* mainScrollViewTopConstraint;

@property (nonatomic, strong) GYEasybuyGoodsInfoPropView *popView;//颜色尺码属性视图
@property (nonatomic, assign) BOOL isPropTVShow; //是否弹出商品颜色尺码属性视图
@property (nonatomic, assign) BOOL isColorSelected; //判断是否选了颜色尺码

@property (assign, nonatomic) CGFloat pageHeight;
@property (strong, nonatomic) GYRefreshHeader* header;
@property (strong, nonatomic) GYRefreshFooter* footer;
@property (strong, nonatomic) NSMutableDictionary* params;
@property (assign, nonatomic) BOOL webViewIsShow;
@property (nonatomic, strong) UIButton *toTopBtn;


//跳转立即购买需要传的参数
@property (nonatomic, strong) NSDictionary* goodData; //商品的response[@"data"]
@property (nonatomic, strong) NSDictionary* skuData; //sku的response[@"data"]

//分享内容
@property (nonatomic, copy) NSString* shareContent;
//抵扣券视图高度
@property (nonatomic, assign) float couponViewHeight;
//购物车最大数量
@property (nonatomic, assign) NSInteger cartMaxGoodsNum;
//回传第2个cell，已选择商品参数的名称数组([颜色，大小])
@property (nonatomic, strong) NSMutableArray* selectParamsArr;

@end

@implementation GYEasybuyGoodsInfoViewController

#pragma mark - 生命周期



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTopView];
    _showCoupon = YES;
    _couponViewHeight = 220;
    [self loadData];
    [self.gotoShopView addAllBorder];
    [self.contactCustomerServiceView addAllBorder];
    self.gotoShopLabel.text = kLocalized(@"GYHE_Easybuy_enterShops");
    self.contactCustomerServiceLabel.text = kLocalized(@"GYHE_Easybuy_contact_shop");
    [self.buyButton setTitle:kLocalized(@"GYHE_Easybuy_buy_now") forState:UIControlStateNormal];
    [self.putToCartButton setTitle:kLocalized(@"GYHE_Easybuy_add_into_cart") forState:UIControlStateNormal];
    self.itemDataSource = [@[ kLocalized(@"GYHE_Easybuy_selectOperations"), kLocalized(@"GYHE_Easybuy_select"), kLocalized(@"GYHE_Easybuy_basicParameters"), kLocalized(@"GYHE_Easybuy_goodsEvaluateion") ] mutableCopy];
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePropTableView)];
    [_backgroundHalpBalckView addGestureRecognizer:tap];
    [self setupMainScrollView];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)netRequest didSuccessWithData:(NSDictionary*)responseObject
{

    [GYGIFHUD dismiss];
    if (netRequest.tag == kGYEasyBuyGetGoodsInfoURL) {
        [self getGoodsInfoWithDict:responseObject];
    }
    else if (netRequest.tag == kGYEasyBuyGoodsSkuURL) {

        _skuData = [[NSDictionary alloc] init];
        _skuData = responseObject[@"data"];
        //设置参数对应图片
        NSDictionary* picDict = [_skuData[@"picList"] firstObject];

        [self.popView.propHeaderImageView setImageWithURL:picDict[@"url"] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
        self.popView.propHeaderPriceLabel.text = [NSString stringWithFormat:@"%.2f", [_skuData[@"price"] doubleValue]];
        //求sku，skuId
        _skuId = responseObject[@"data"][@"skuId"];

        NSMutableArray* skuArr = [[NSMutableArray alloc] init];
        NSString* str = responseObject[@"data"][@"sku"];
        NSArray* arr = [str componentsSeparatedByString:@","];
        for (int i = 0; i < arr.count; i++) {
            NSArray* a = [arr[i] componentsSeparatedByString:@":"];
            [skuArr addObject:a.lastObject];
        }
        _sku = [skuArr componentsJoinedByString:@","];
        _isColorSelected = YES;
        //发传参数到cell
        GYEasybuyGoodsInfoItemTableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        cell.itemTitleLabel.text = kLocalized(@"GYHE_Easybuy_didSelected");
        cell.itemDetailLabel.text = [skuArr componentsJoinedByString:@" "];
    }
    else if (netRequest.tag == kGYEasyBuyAddCartURL) {
        [GYUtils showToast:kLocalized(@"GYHE_Easybuy_addCartSuccess")]; //HESuccessAddedShoppingCart
        [self hidePropTableView];
        //加入购物车成功，将商品属性的选中状态置为未选中（颜色尺码）
//        _isColorSelected = NO;
//        NSArray* cellArr = [self.popView.propTableView visibleCells];
//        for (GYEasybuyGoodsInfoPropListTableViewCell* cell in cellArr) {
//            if ([cell isKindOfClass:[GYEasybuyGoodsInfoPropListTableViewCell class]]) {
//                for (UIButton* btn in cell.btnView.subviews) {
//                    if ([btn isKindOfClass:[UIButton class]]) {
//                        btn.selected = NO;
//                    }
//                }
//            }
//        }
    }
    else if (netRequest.tag == kGYEasyBuyCollectURL) {
        [GYUtils showToast:kLocalized(@"GYHE_Easybuy_collectionSuccess")];
        //收藏成功，改变收藏图片
        GYEasybuyGoodsInfoTableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.beFocusIv.image = [UIImage imageNamed:@"gyhe_collect_yes"];
        cell.beFocusLabel.text = kLocalized(@"GYHE_Easybuy_didCollection");
        cell.collectBtn.enabled = NO;//不能取消收藏
    }
    else if (netRequest.tag == kGYEasyBuyGetCartMaxSizeURL) {

        NSDictionary* serverDic = responseObject;
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The ServerDic:%@ is invalid.", serverDic);
            return;
        }
        _cartMaxGoodsNum = kSaftToNSInteger(serverDic[@"data"]);
    }
}

- (void)netRequest:(GYNetRequest*)netRequest didFailureWithError:(NSError*)error
{
    [GYGIFHUD dismiss];
    DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", netRequest.URLString, (long)[error code], [error localizedDescription]);
    //商品数量超过最大购买数
    if([kSaftToNSString(netRequest.responseObject[@"retCode"]) isEqualToString:@"502"]) {
        [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_moreToMaxNum")];
        return;
    }
    //商品下架
    if([kSaftToNSString(netRequest.responseObject[@"retCode"]) isEqualToString:@"507"]) {
        [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_goodsUnderFrame")];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //商铺已经关闭
    if([kSaftToNSString(netRequest.responseObject[@"retCode"]) isEqualToString:@"855"]) {
        [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_shopClocePleaseTryLater")];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    //其他错误码
    [GYUtils parseNetWork:error resultBlock:nil];
    //当选择商品属性请求失败，将选中属性还原
    if (netRequest.tag == kGYEasyBuyGoodsSkuURL) {
        _isColorSelected = NO;
        NSArray* cellArr = [self.popView.propTableView visibleCells];
        for (GYEasybuyGoodsInfoPropListTableViewCell* cell in cellArr) {
            if ([cell isKindOfClass:[GYEasybuyGoodsInfoPropListTableViewCell class]]) {
                for (UIButton* btn in cell.btnView.subviews) {
                    if ([btn isKindOfClass:[UIButton class]]) {
                        btn.selected = NO;
                    }
                }
            }
        }
    }

}

- (void)getGoodsInfoWithDict:(NSDictionary*)responseObject
{
    self.footer.hidden = NO;
    if (responseObject[@"data"]) {
        _goodData = [[NSDictionary alloc] init];
        _goodData = responseObject[@"data"];
    }

    NSArray* arr = [GYEasybuyGoodsInfoModel modelArrayWithResponseObject:responseObject error:nil];

    //过滤掉propList商品属性出现的一次，一份
    [self.selectParamsArr removeAllObjects];
    GYEasybuyGoodsInfoModel* mod = arr.firstObject;
    NSMutableArray* deleteStrArr = [[NSMutableArray alloc] init];
    NSMutableArray* propListArr = mod.propList.mutableCopy;
    for (int i = 0;i < mod.propList.count; i++) {
        GYEasybuyGoodsinfoPropListModel* propModel = mod.propList[i];
        NSMutableArray* arr = propModel.subs.mutableCopy;
        for (GYEasybuyGoodsinfoPropListSubsModel* subMod in propModel.subs) {
            if ([subMod.vname isEqualToString:@"一次"] || [subMod.vname isEqualToString:@"一份"]) {
                //将删除的一次，一份id存到数组
                [deleteStrArr addObject:subMod.vid];
                [arr removeObject:subMod];
            }
        }
        [self.selectParamsArr addObject:propModel.name];
        propModel.subs = arr.copy;
        //当没有小标题删除大标题
        if (propModel.subs.count == 0) {
            [propListArr removeObject:propModel];
        }
        //一个类别只有一个属性默认选中
        if(propModel.subs.count == 1) {
            GYEasybuyGoodsinfoPropListSubsModel *subMod = propModel.subs.firstObject;
            subMod.isSelected = YES;
            [self.skuDict setValue:subMod.vid forKey:[NSString stringWithFormat:@"%d", i]];
        }
        
        //计算动态适应的GYEasybuyGoodsInfoPropListTableViewCell的高度
        [propModel getPropListCellHeightWithTitle:propModel.name subs:propModel.subs];
    }

    mod.propList = propListArr.copy;
    self.model = mod;

    //计算动态适应的GYEasybuyGoodsInfoTableViewCell的高度，有无抵扣券
    [self.model getGoodsInfoCellHeightWithTitle:self.model.title beTicket:self.model.beTicket];

    //当商品没有任何属性是，直接请求sku（原本是选中所有属性才请求）
    if (mod.propList.count == 0) {
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[deleteStrArr componentsJoinedByString:@","] forKey:@"sku"];
        [dict setValue:_itemId forKey:@"itemId"];
        [dict setValue:_model.vShopId forKey:@"vShopId"];

        __block GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetGoodsSkuUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = kGYEasyBuyGoodsSkuURL;
        [GYGIFHUD show];
        [request start];
    }else if(self.skuDict.count == self.model.propList.count) {
        //当商品属性每一类只有一个，默认选中，当所有类都默认选中，直接请求sku
        _isColorSelected = YES;
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[[self.skuDict allValues] componentsJoinedByString:@","] forKey:@"sku"];
        [dict setValue:_itemId forKey:@"itemId"];
        [dict setValue:_model.vShopId forKey:@"vShopId"];
        
        __block GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetGoodsSkuUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
        request.tag = kGYEasyBuyGoodsSkuURL;
        [GYGIFHUD show];
        [request start];
    }
    

    [self.tableView reloadData];
    [self setupPhotoScrollView];
    [_popView.propTableView reloadData];

    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.model.picDetails]];
    [self.webView loadRequest:request];
    
    
    //存到最近浏览的商品
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSDictionary* dic = [ud objectForKey:kKeyForBrowsingHistory];
    
    NSMutableDictionary* mutDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    
    NSDictionary* dict = @{ @"goodsId" : self.model.id,
                            @"shopId" : self.model.vShopId,
                            @"goodsPictureUrl" : self.model.picList.firstObject[@"url"],
                            @"goodsName" : self.model.title,
                            @"goodsPrice" : self.model.price ,
                            @"numBroweTime" : @([[NSDate date] timeIntervalSince1970])};
    [mutDic setValue:dict forKey:self.model.id];
    [ud setObject:mutDic forKey:kKeyForBrowsingHistory];
    [ud synchronize];
    
}

#pragma mark UITableView DataSource  Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView == self.tableView) {
        return 2;
    }
    else if (tableView == self.popView.propTableView) {
        return 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.model) {
        return 0;
    }
    if (tableView == self.tableView) {
        if (section == 0) {
            return 1;
        }
        return 4;
    }
    else if (tableView == self.popView.propTableView) {
        return self.model.propList.count + 1; //多一个购买数量
    }
    return 0;
}

- (void)showCouponView:(GYEasybuyGoodsInfoTableViewCell*)cell
{
    _showCoupon = !_showCoupon;
    cell.downBtn.selected = !_showCoupon;
    if (_showCoupon) {
        cell.couponViewHeight.constant = 26;
    }
    else {
        cell.couponViewHeight.constant = 0;
    }
    [self.tableView reloadData];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == self.tableView) {

        if (indexPath.section == 0) {
            GYEasybuyGoodsInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYEasybuyGoodsInfoTableViewCellReuseId forIndexPath:indexPath];
            cell.vc = self;
            cell.model = self.model;
            cell.delegate = self;
            [cell.collectBtn addTarget:self action:@selector(collect:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
        }
        if (indexPath.section == 1) {
            GYEasybuyGoodsInfoItemTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYEasybuyGoodsInfoItemTableViewCellReuseId forIndexPath:indexPath];
            if (self.itemDataSource.count > indexPath.row)
                cell.itemTitleLabel.text = self.itemDataSource[indexPath.row];
            if (indexPath.row == 0) {
                cell.itemDetailLabel.text = self.model.shopName;
            }
            if (indexPath.row == 1) {

                cell.itemTitleLabel.text = self.itemDataSource[1];
                NSString* str = [self.selectParamsArr componentsJoinedByString:@" "];
                cell.itemDetailLabel.text = str;
            }
            if (indexPath.row == 3) {
                cell.itemDetailLabel.text = [NSString stringWithFormat:kLocalized(@"GYHE_Easybuy_evaluation"), self.model.evacount];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (tableView == self.popView.propTableView) {

        if (indexPath.row == self.model.propList.count) {
            GYEasybuyGoodsInfoPropBuyNumTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYEasybuyGoodsInfoPropBuyNumTableViewCellReuseId forIndexPath:indexPath];
            if (_cartMaxGoodsNum) {
                cell.maxNum = _cartMaxGoodsNum;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else {
            GYEasybuyGoodsInfoPropListTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYEasybuyGoodsInfoPropListTableViewCellReuseId forIndexPath:indexPath];
    
            if(self.model.propList.count > indexPath.row) {
                GYEasybuyGoodsinfoPropListModel *propModel = self.model.propList[indexPath.row];
                cell.model = propModel;
                WS(weakSelf);
                //当属性选中时
                cell.block = ^(NSString* selectStr,NSInteger index) {
                    if(self.model.propList.count > indexPath.row) {
                        GYEasybuyGoodsinfoPropListModel *propModel =  self.model.propList[indexPath.row];
                        for(GYEasybuyGoodsinfoPropListSubsModel *sub in propModel.subs) {
                            sub.isSelected = NO;
                        }
                        if(propModel.subs.count > index) {
                            GYEasybuyGoodsinfoPropListSubsModel *subModel =  propModel.subs[index];
                            
                            //选择的颜色尺码的Id
                            if (!selectStr) {
                                subModel.isSelected = NO;
                                [weakSelf.skuDict removeObjectForKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                            } else {
                                subModel.isSelected = YES;
                                [weakSelf.skuDict setValue:selectStr forKey:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
                            }
                            //当所有参数选中时,请求skuId
                            if (weakSelf.skuDict.count == weakSelf.model.propList.count) {
                                
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                [dict setValue:[[weakSelf.skuDict allValues] componentsJoinedByString:@","] forKey:@"sku"];
                                [dict setValue:weakSelf.itemId forKey:@"itemId"];
                                [dict setValue:weakSelf.model.vShopId forKey:@"vShopId"];
                                
                                __block GYNetRequest *request = [[GYNetRequest alloc] initWithDelegate:weakSelf URLString:GetGoodsSkuUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
                                request.tag = kGYEasyBuyGoodsSkuURL;
                                [GYGIFHUD show];
                                [request start];
                            }else {
                                _isColorSelected = NO;
                            }
                            
                        }
                    }
                    
                };
            }
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (tableView == self.tableView) {

        if (indexPath.section == 1) {
            switch (indexPath.row) {
            case 0: { //选择营业点
                GYEasybuyShopAddressViewController* vc = [[GYEasybuyShopAddressViewController alloc] init];
                vc.itemId = self.itemId;

                vc.blockAddress = ^(NSString* address) {
                        
                        GYEasybuyGoodsInfoItemTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                        cell.itemDetailLabel.text = address;
                };
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                [self removeProp];
            } break;
            case 1: { //选择颜色
                [self showPropTableView];
            } break;
            case 2: { //基本参数
                if (self.model) {
                    GYEasybuyBasicInfoViewController* vc = [[GYEasybuyBasicInfoViewController alloc] init];
                    vc.basicParameterArray = self.model.basicParameter;
                    vc.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    [self removeProp];
                }

            } break;
            case 3: { //商品评价
                GYEasybuyEvaluationViewController* vc = [[GYEasybuyEvaluationViewController alloc] init];
                vc.itemId = self.itemId;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
                [self removeProp];
            } break;

            default:
                break;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        if (section == 0) {
            return 16;
        }
        return 0.1;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView == self.tableView) {

        if (section == 1) {
            return 0.1;
        }
        return 16;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == self.tableView) {
        //判断是否有抵扣券
        if (indexPath.section == 0) {
            if (!self.model.goodsInfoCellHeight)
                return 220;

            //是否显示抵扣券
            if (self.showCoupon) {
                return self.model.goodsInfoCellHeight;
            }
            else {
                return self.model.goodsInfoCellHeight - 26;
            }
        }
        else
            return 44;
    }
    else if (tableView == self.popView.propTableView) {

        if (indexPath.row == self.model.propList.count) {
            return 44;
        }
        else {

            if (self.model.propList.count > indexPath.row) {
                GYEasybuyGoodsinfoPropListModel* model = self.model.propList[indexPath.row];
                return model.propListCellHeight;
            }
            return 70;
        }
    }

    return 44;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView == self.photoScrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat x = offsetX / kScreenWidth;
        self.pageControl.currentPage = (int)(x + 0.5);
    }
}

#pragma mark - 点击事件
//将商品加到购物车
- (IBAction)pushToCart:(id)sender
{

    kCheckLogined

    if (globalData.loginModel)
    {
        //所有商品选中 或者 商品原本没有任何商品属性时 并且 属性视图已经弹出
        if (_isPropTVShow && (_isColorSelected || self.model.propList.count == 0)) {
            GYEasybuyGoodsInfoPropBuyNumTableViewCell* cell = [self.popView.propTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.propList.count inSection:0]];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            [dict setValue:cell.num forKey:@"num"];
            [dict setValue:self.model.price forKey:@"originalPrice"];
            [dict setValue:self.model.vShopId forKey:@"vShopId"];
            [dict setValue:self.model.vShopName forKey:@"vShopName"];
            [dict setValue:self.model.shopId forKey:@"shopId"];
            [dict setValue:self.model.shopName forKey:@"shopName"];
            [dict setValue:self.itemId forKey:@"itemId"];
            [dict setValue:self.skuId forKey:@"skuId"];
            [dict setValue:self.sku forKey:@"skus"];
            [dict setValue:globalData.loginModel.token forKey:@"key"];
            [dict setValue:@"2" forKey:@"sourceId"];

            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:GetAddCartUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];

            request.tag = kGYEasyBuyAddCartURL;
            [GYGIFHUD show];
            [request start];
        }
        else {
            if (!_isPropTVShow) {
                [self showPropTableView];
            }
            else {
                [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_selectGoodsParam")];
            }
        }
    }
}

//立即购买
- (IBAction)buyBtnClicked:(UIButton*)sender
{
    kCheckLogined
    if (globalData.loginModel){
        //所有商品选中 或者 商品原本没有任何商品属性时 并且 属性视图已经弹出
        if (_isPropTVShow && (_isColorSelected || self.model.propList.count == 0)) {
            if (_skuData && _goodData) {
                GYEasybuyGoodsInfoPropBuyNumTableViewCell* cell = [self.popView.propTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.model.propList.count inSection:0]];

                UIViewController* vc = [[NSClassFromString(@"GYHESCConfirmOrderViewController") alloc] init];
                [vc setValue:_skuData forKey:@"skuDict"];
                [vc setValue:_goodData forKey:@"goodsDict"];
                [vc setValue:@"1" forKey:@"isRightAway"];
                [vc setValue:cell.num forKey:@"goodsNumber"];
                [vc hidesBottomBarWhenPushed];
                
                
                [self.navigationController pushViewController:vc animated:YES];
                
                [self removeProp];
            }
        }
        else {
            if (!_isPropTVShow) {
                [self showPropTableView];
            }
            else {
                [GYUtils showMessage:kLocalized(@"GYHE_Easybuy_selectGoodsParam")];
            }
        }
    }
}

- (void)collect:(UIButton*)btn
{

    kCheckLogined if (globalData.loginModel)
    {
        if (!self.model.beFocus) {
            //收藏
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            if (globalData.loginModel.token) {
                [dict setValue:globalData.loginModel.token forKey:@"key"];
            }
            [dict setValue:self.itemId forKey:@"itemId"];
            [dict setValue:self.model.vShopId forKey:@"vShopId"];
            GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:[NSString stringWithFormat:@"%@/easybuy/collectionGoods", globalData.retailDomain] parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
            request.tag = kGYEasyBuyCollectURL;
            [GYGIFHUD show];
            [request start];
        }
    }
}

//分享
- (void)share:(UIButton*)btn
{

    GYSocialDataModel* model = [[GYSocialDataModel alloc] init];
    //创建分享参数
    NSInteger maxlength = 140;
    _shareContent = [NSString stringWithFormat:@"%@%@%@", self.model.title, self.model.itemUrl, self.model.introduces];
    if (_shareContent.length > maxlength) {
        _shareContent = [_shareContent substringToIndex:maxlength];
    }
    model.content = _shareContent;
    model.title = self.model.title;
    model.toUrl = self.model.itemUrl;

    YYWebImageManager* manager = [YYWebImageManager sharedManager];
    [manager requestImageWithURL:[NSURL URLWithString:self.goodsImageurlstrings[0]] options:kNilOptions progress:nil transform:nil completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
        if (!error) {
            model.image = image;
        }
        [GYSocialDataService postWithSocialDataModel:model  presentedController:self];

    }];
}

//查看购物车
- (void)gotoCart:(UIButton*)btn
{
    kCheckLogined
        UIViewController* vc = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
    [vc hidesBottomBarWhenPushed];
    [self.navigationController pushViewController:vc animated:YES];
    [self removeProp];
}

//商铺
- (IBAction)toShop:(UIButton*)sender
{

    [self hidePropTableView];
    // 屏蔽 进入新界面
    GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];

    ShopModel* model = [[ShopModel alloc] init];
    model.strVshopId = self.vShopId;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [self removeProp];
}
//联系卖家
- (IBAction)contactPerson:(UIButton*)sender
{
    kCheckLogined

    [self hidePropTableView];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];

    [dict setValue:self.model.companyResourceNo forKey:@"resourceNo"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];

    [GYGIFHUD show];

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
       
        if (!error) {
            NSDictionary *dic = responseObject;
            NSString *retCode = [NSString stringWithFormat:@"%@", dic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"] && [dic[@"data"] isKindOfClass:[NSDictionary class]]) {
                dic = dic[@"data"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    GYHDChatViewController *chatViewController = [[GYHDChatViewController alloc] init];
                    NSMutableDictionary *comDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                    NSString *price;
                    if([self.model.lowPrice floatValue] == [self.model.price floatValue]) {
                        price = [NSString stringWithFormat:@"%.2f",[self.model.price doubleValue]] ;
                    }else {
                        price = [NSString stringWithFormat:@"%.2f起",[self.model.lowPrice doubleValue]];
                    }
                    NSString *pv;
                    if([self.model.lowPv floatValue] ==[self.model.pv floatValue]) {
                        pv = [NSString stringWithFormat:@"%.2f",[self.model.pv doubleValue]];
                    }else {
                        pv = [NSString stringWithFormat:@"%.2f起",[self.model.lowPv doubleValue]];
                    }
                    
                    
                    [comDict setValue:@{
                                        @"prod_id":kSaftToNSString(self.itemId) ,
                                        @"prod_name":kSaftToNSString(self.model.title),
                                        @"prod_des":kSaftToNSString(self.model.introduces),
                                        @"prod_price":kSaftToNSString(price),
                                        @"prod_pv":kSaftToNSString(pv),
                                        @"imageNailsUrl":kSaftToNSString(self.model.picList.firstObject[@"url"])
                                        } forKey:@"goods"];
                    [comDict setValue:@"" forKey:@"orders"];
                    
                    chatViewController.companyInformationDict = comDict;
                    [self.navigationController pushViewController:chatViewController animated:YES];
                    [self removeProp];
                });
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        
    }];
    [request start];
}

#pragma mark - 自定义方法
- (void)removeProp {
    self.backgroundHalpBalckView.hidden = YES;
    [self.popView removeFromSuperview];
    self.popView = nil;
    _isPropTVShow = NO;

}
//设置选择颜色尺码的弹出视图PropTableView相关
- (void)showPropTableView
{
    _isPropTVShow = YES;
    _backgroundHalpBalckView.hidden = NO;
    

    WS(weakSelf);

    [UIView animateWithDuration:0.25 animations:^{
       
        [weakSelf.popView mas_updateConstraints:^(MASConstraintMaker *make) {

            make.top.equalTo(self.view).with.offset(kScreenHeight/3.0 - 49 - 64);
        }];
        
//        if (!weakSelf.webViewIsShow) {
//
//            [weakSelf.view layoutIfNeeded];
//        }

    }];
}
//隐藏 选择颜色尺码
- (void)hidePropTableView
{
    _isPropTVShow = NO;
    [self.view endEditing:YES];
    _backgroundHalpBalckView.hidden = YES;

    WS(weakSelf);

    [UIView animateWithDuration:0.25 animations:^{

        [weakSelf.popView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(kScreenHeight - 49);
        }];
//        [weakSelf.view layoutIfNeeded];
//        if (!weakSelf.webViewIsShow) {
//            [weakSelf.view layoutIfNeeded];
//        }

    }];
}

- (void)setupPropHeaderView
{
    NSArray* picList = _model.picList;
    NSDictionary* dict = picList[0];
    NSString* url = dict[@"url"];
    [self.popView.propHeaderImageView setImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    self.popView.propHeaderTitleLabel.text = _model.title;
    self.popView.propHeaderPriceLabel.text = [NSString stringWithFormat:@"%.2f", _model.price.doubleValue];
}

//设置主ScrollView，上下方向
- (void)setupMainScrollView
{
    self.pageHeight = kScreenHeight - 64 - 49;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"GYEasybuyGoodsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:GYEasybuyGoodsInfoTableViewCellReuseId];
    [self.tableView registerNib:[UINib nibWithNibName:@"GYEasybuyGoodsInfoItemTableViewCell" bundle:nil] forCellReuseIdentifier:GYEasybuyGoodsInfoItemTableViewCellReuseId];

    [self setupTableHeaderView];

    WS(weakSelf);

    self.footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        [weakSelf.mainScrollView scrollRectToVisible:CGRectMake(0, weakSelf.pageHeight, kScreenWidth, weakSelf.pageHeight) animated:YES];
        weakSelf.webViewIsShow = YES;
        weakSelf.toTopBtn.hidden = NO;
        [weakSelf.header endRefreshing];
    }];
    self.footer.automaticallyRefresh = NO;
    [self.footer setTitle:kLocalized(@"GYHE_Easybuy_continueDragShowDetails") forState:MJRefreshStateIdle];
    self.tableView.mj_footer = self.footer;
    self.footer.hidden = YES;
    self.header = [GYRefreshHeader headerWithRefreshingBlock:^{
        [weakSelf.mainScrollView scrollRectToVisible:CGRectMake(0, 0, kScreenWidth, weakSelf.pageHeight) animated:YES];
        weakSelf.webViewIsShow = NO;
        weakSelf.toTopBtn.hidden = YES;
        [weakSelf.footer endRefreshing];
    }];
    self.header.lastUpdatedTimeLabel.hidden = YES;
    [self.header setTitle:kLocalized(@"GYHE_Easybuy_releaseBackDetail") forState:MJRefreshStatePulling];
    [self.header setTitle:kLocalized(@"GYHE_Easybuy_downBackDetail") forState:MJRefreshStateIdle];
    self.header.backgroundColor = kDefaultVCBackgroundColor;
    self.webView.backgroundColor = kDefaultVCBackgroundColor;
    self.webView.scrollView.mj_header = self.header;
}

//设置图片ScrollView，左右方向
- (void)setupTableHeaderView
{

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 300)];
    self.photoScrollView = [[UIScrollView alloc] initWithFrame:self.headerView.bounds];
    [self.headerView addSubview:self.photoScrollView];
    self.tableView.tableHeaderView = self.headerView;
    self.photoScrollView.pagingEnabled = YES;
    self.photoScrollView.backgroundColor = [UIColor whiteColor];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 280, CGRectGetWidth(self.headerView.bounds), 20)];
    self.pageControl.tintColor = [UIColor blackColor];
    [self.headerView addSubview:self.pageControl];
    self.pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.photoScrollView.delegate = self;
    self.photoScrollView.showsHorizontalScrollIndicator = NO;
}

//给图片ScrollView添加图片
- (void)setupPhotoScrollView
{
    NSArray* picList = self.model.picList;
    self.goodsImageurlstrings = [[NSMutableArray alloc] init];
    for (int i = 0; i < picList.count; i++) {
        [self.goodsImageurlstrings addObject:[picList[i] objectForKey:@"url"]];
    }
    self.photoScrollView.contentSize = CGSizeMake(kScreenWidth * picList.count, 300);
    for (int i = 0; i < picList.count; i++) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenWidth, 0, kScreenWidth, 300)];
        imageView.tag = 200 + i;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [imageView addGestureRecognizer:tap];

        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setImageWithURL:[NSURL URLWithString:self.goodsImageurlstrings[i]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
        [self.photoScrollView addSubview:imageView];
    }
    [self.photoScrollView bringSubviewToFront:self.pageControl];
    self.pageControl.numberOfPages = picList.count;
}

- (void)tap:(UITapGestureRecognizer*)gesture
{

    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < _goodsImageurlstrings.count; i++) {
        GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
        item.thumbView = [self.photoScrollView viewWithTag:200 + i];
        item.largeImageURL = [NSURL URLWithString:_goodsImageurlstrings[i]];
        [items addObject:item];
    }

    GYPhotoGroupView* v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:gesture.view toContainer:self.tabBarController.view.window animated:YES completion:nil];
}

//请求数据
- (void)loadData
{

    [self getGoodsNum];

    self.params = [[NSMutableDictionary alloc] init];
    [self.params setValue:self.itemId forKey:@"itemId"];
    [self.params setValue:self.vShopId forKey:@"vShopId"];
    if (globalData.loginModel.token) {
        [self.params setValue:globalData.loginModel.token forKey:@"key"];
    }
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasybuyGetGoodsInfo parameters:_params requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kGYEasyBuyGetGoodsInfoURL;
    [GYGIFHUD show];
    [request start];
}
// 商品个数
- (void)getGoodsNum
{

    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetCartMaxSizeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = kGYEasyBuyGetCartMaxSizeURL;
    [GYGIFHUD show];
    [request start];
}
- (void)setNav
{

    self.navigationItem.title = kLocalized(@"GYHE_Easybuy_good_detail");

    UIButton* myHSButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect Hsframe = CGRectMake(0, 0, 27, 27);
    myHSButton.frame = Hsframe;
    [myHSButton setBackgroundImage:kLoadPng(@"gycommon_nav_share_white") forState:UIControlStateNormal];
    [myHSButton setTitle:@"" forState:UIControlStateNormal];
    [myHSButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting1 = [[UIBarButtonItem alloc] initWithCustomView:myHSButton];

    UIImage* image = kLoadPng(@"gycommon_nav_cart");
    CGRect backframe = CGRectMake(0, 0, 27, 27);
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = backframe;
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:@"" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoCart:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting2 = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[ btnSetting2, btnSetting1 ];
    
    UIButton* backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBut setImage:[UIImage imageNamed:@"gycommon_nav_back"] forState:UIControlStateNormal];
    backBut.frame = CGRectMake(0, 0, 40, 40);
    backBut.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBut addTarget:self action:@selector(pushBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc]initWithCustomView:backBut];
    
}

- (void)pushBack{
    for (NSLayoutConstraint *containt in self.view.constraints) {
        
        [self.view removeConstraint:containt];
        
    }
    
    self.photoScrollView.delegate = nil;
    self.mainScrollView.delegate = nil;
    self.webView.delegate = nil;
    self.webView = nil;
    self.tableView.delegate = nil;
    
    self.header = nil;
    self.footer = nil;
    self.popView = nil;
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTopView {
    //      返回顶部按钮
    _toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _toTopBtn.frame = CGRectMake(kScreenWidth - 35/2 - 40, kScreenHeight - 51 - 50 -64 - 5, 45, 45);
    [_toTopBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_backtotop"] forState:0];
    [_toTopBtn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];
    _toTopBtn.hidden = YES;
    [self.view addSubview:_toTopBtn];
}

- (void)backTop {
    [self.webView.scrollView.mj_header beginRefreshing];
}
#pragma mark - 懒加载
- (NSMutableDictionary *)skuDict {
    if (!_skuDict) {
        _skuDict = [[NSMutableDictionary alloc] init];
    }
    return _skuDict;
}
- (NSMutableArray *)selectParamsArr {
    if(!_selectParamsArr) {
        _selectParamsArr = [[NSMutableArray alloc] init];
    }
    return _selectParamsArr;
}
- (GYEasybuyGoodsInfoPropView *)popView {
    if(!_popView) {
        _popView = [[NSBundle mainBundle] loadNibNamed:@"GYEasybuyGoodsInfoPropView" owner:self options:0][0];
        [self setupPropHeaderView];
        [_popView.propTableView registerNib:[UINib nibWithNibName:@"GYEasybuyGoodsInfoPropListTableViewCell" bundle:nil] forCellReuseIdentifier:GYEasybuyGoodsInfoPropListTableViewCellReuseId];
        [_popView.propTableView registerNib:[UINib nibWithNibName:@"GYEasybuyGoodsInfoPropBuyNumTableViewCell" bundle:nil] forCellReuseIdentifier:GYEasybuyGoodsInfoPropBuyNumTableViewCellReuseId];
        _popView.propTableView.delegate = self;
        _popView.propTableView.dataSource = self;
        [_popView.propTableView reloadData];
        
        [self.view addSubview:_popView];
        
        [_popView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.trailing.equalTo(self.view);
            make.height.mas_equalTo(kScreenHeight/3.0*2);
            make.top.mas_equalTo(kScreenHeight - 49);
        }];
        
    }
    return _popView;
}
- (void)dealloc {
    
    
}

@end
