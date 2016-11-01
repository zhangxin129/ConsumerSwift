//
//  GYShopDetailViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYHESCConfirmOrderViewController.h"

#import "GYArroundGoodDetailViewController.h"
#import "GYGoodDetailHeaderView.h"
#import "GYDefaultTableViewCell.h"
//地址的cell
#import "GYShopLocationTableViewCell.h"
//商品详情
#import "GYGoodDetailListTableViewCell.h"
#import "GlobalData.h"
#import "GYSurrondGoodsDetailModel.h"
//星星的cell
#import "GYStarTableViewCell.h"

#import "GYSelCell.h"
#import "GYSelModel.h"
#import "GYSetNumCell.h"

#import "GYSelBtn.h"
#import "GYGoodsDetailModel.h"
#import "GYAlertView.h"
#import "GYBMKViewController.h"
#define hotGoodIdentifier @"hotGood"
#define locationCellIdentifier @"locationCell"
#define smailImageViewWidth 20
#define smailImageViewHeight 20
#define midleLabelWidth 90
#define sepraterSpace 10
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#import "GYAroundGoodsEvaluateDetailController.h"
#import "GYShopDetailHeaderView.h"
#import "GYGoodIntroductionCell.h"
#import "GYGoodIntroductionModel.h"
#import "GYGoodsDetailModel.h"
#import "GYEasybuyBasicInfoViewController.h"
#import "GYPhotoGroupView.h"
#import "GYSocialDataService.h"
#import "GYGIFHUD.h"
#import "GYDiscountListCell.h"
#import "GYAppDelegate.h"
#import "GYHSLoginViewController.h"
#import "MenuTabView.h"
#import "GYShopDescribeController.h"
#import "GYHDChatViewController.h"
#import "GYHSLoginManager.h"
#import "YYWebImageManager.h"

@interface GYArroundGoodDetailViewController () <GYSetNumCellDelegate, UIWebViewDelegate, MenuTabViewDelegate>
@property (nonatomic, assign) CGFloat fHeight;
@property (nonatomic, strong) NSMutableArray* photos;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) UIWebView* wvDetail;
@property (nonatomic, assign) CGFloat tableSCHeight;
@property (nonatomic, assign) BOOL bloadDetail;
@property (nonatomic, weak) UIImageView* imgArrow;
@property (nonatomic, assign) NSInteger dicountRow;
@property (nonatomic, strong) UIView* vDiscount;
@property (nonatomic, strong) NSMutableArray* marrDiscount;
@property (nonatomic, copy) NSString* btnStr;

@property (nonatomic, strong) GYAroundGoodsEvaluateDetailController* EvaluateVC;
@property (nonatomic, strong) NSMutableArray<GYSelBtn*>* mArrjson;

@property (nonatomic, strong) UIView* blackgroundView;

@property (nonatomic, assign) BOOL isAddShopingCart; //判断是否需要加入购物车
@property (nonatomic, strong) NSDictionary* skuDict;
@property (nonatomic, strong) NSDictionary* goodsDict;

@property (nonatomic, strong) NSDictionary *responseDic;



@end

@implementation GYArroundGoodDetailViewController {

    __weak IBOutlet UITableView* tvShopDetail; //商品详情的TV

    GYShopLocationTableViewCell* locationCell; //此cell不用复用，直接用全局变量

    GYStarTableViewCell* starCell; //此cell不用复用，直接用全局变量

    NSArray* arrTitle; //中间view 的label的 title

    NSDictionary* dic;

    NSInteger rows;

    BOOL isShow; //控制section 是否展开

    UIImageView* imgvArrow; //多个方法调用的箭头

    CGAffineTransform rotationTransform;

    GYSurrondGoodsDetailModel* GoodsDetailMod;

    UIView* touchView;

    UIView* vSel;

    CGRect frame;

    CGRect frameSel;

    UIView* vButton;

    GYGoodDetailHeaderView* header;

    __weak IBOutlet UIView* vPopView;

    CGFloat tbvSelHeight;

    NSMutableArray* mArrBtnView; //btnView

    NSMutableArray* mArrBtn; //按钮数组

    NSString* strRetShopName; //返回店名

    NSString* strRetParameter; //返回参数项目名字

    NSString* strRetParameterVl; //返回参数项目名字

    GYGoodsDetailModel* detailmodel;
    UIButton* btnRight;
    __weak IBOutlet UITableView* tvSkuView;

    __weak IBOutlet UILabel* lbTitle;
    
    

    BMKMapPoint mp;
    UIButton* _backTopBtn; //返回顶部按钮
    NSString* strPictureUrl;

    BOOL isShowSkuView;
    NSString* shareContent; ///分享内容
    __weak IBOutlet UIImageView* imgGoodsPic;

    __weak IBOutlet UILabel* lbGoodsName;
    NSString* shareitemUrl; ////分享商品链接
    NSString* sharegoods; ////分享商品详情

    MenuTabView* menu;
    
    
}


#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = kLocalized(@"GYHE_SurroundVisit_GoodDetail");
    CGRect rect = tvShopDetail.frame;
    rows = 0;
    isShow = YES;
    strRetParameterVl = @"";

    vPopView.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100);
    [self.tabBarController.view.window addSubview:self.blackgroundView];
    [self.blackgroundView addSubview:vPopView];
    CGRect popRect = self.blackgroundView.frame;
    popRect.origin.y = kScreenHeight;
    self.blackgroundView.frame = popRect;

    self.mArrjson = [[NSMutableArray alloc] init];
    mArrBtnView = [[NSMutableArray alloc] init];
    mArrBtn = [[NSMutableArray alloc] init];

    imgvArrow = [[UIImageView alloc] init];

    detailmodel = [[GYGoodsDetailModel alloc] init];

    rotationTransform = CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(360));

    lbTitle.textColor = kCellItemTitleColor;

    UIView* backgroundView = [[UIView alloc] initWithFrame:rect];
    backgroundView.backgroundColor = [UIColor whiteColor];
    tvShopDetail.backgroundView = backgroundView;
    tvShopDetail.delegate = self;
    tvShopDetail.dataSource = self;
    tvShopDetail.decelerationRate = 0.05;
    arrTitle = [NSArray arrayWithObjects:kLocalized(@"GYHE_SurroundVisit_DeliveryInTime"), kLocalized(@"GYHE_SurroundVisit_DeliveryGoodsToHome"), kLocalized(@"GYHE_SurroundVisit_CashOnDelivery"), kLocalized(@"GYHE_SurroundVisit_GetByYourself"), kLocalized(@"GYHE_SurroundVisit_SendTicketGood"), nil];

    [tvSkuView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSelCell class])  bundle:nil] forCellReuseIdentifier:@"CELLSEL"];
    [tvSkuView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSetNumCell class]) bundle:nil] forCellReuseIdentifier:@"CELLNUM"];

    [self setTheButton];

    [tvShopDetail registerNib:[UINib nibWithNibName:NSStringFromClass([GYShopLocationTableViewCell class]) bundle:nil] forCellReuseIdentifier:locationCellIdentifier];
    [tvShopDetail registerNib:[UINib nibWithNibName:NSStringFromClass([GYGoodDetailListTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"GoodCell"];
    [tvShopDetail registerClass:[GYDiscountListCell class] forCellReuseIdentifier:kGYDiscountListCell];
    [self removeGoodDetail];
    tvSkuView.tableFooterView = [[UILabel alloc] init];

    header = [[GYGoodDetailHeaderView alloc] initWithShopModel:_model WithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth / 750.0 * 450.0 + 115) WithOwer:self];
    [header.btnAttention addTarget:self action:@selector(addToCollectionRequest) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer* tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBigPic:)];
    [header.mainScrollView addGestureRecognizer:tap1];

    self.btnEnterShop.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.btnEnterShop setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.btnEnterShop setImage:[UIImage imageNamed:@"gyhe_enter_shop.png"] forState:UIControlStateNormal];
    self.btnEnterShop.imageEdgeInsets = UIEdgeInsetsMake(6, 22, 20, 20);
    self.btnEnterShop.titleEdgeInsets = UIEdgeInsetsMake(22, -self.btnEnterShop.frame.size.width + 28, 0, 0); // 调整按钮文字位置

    self.btnEnterShopPro.imageEdgeInsets = UIEdgeInsetsMake(6, 22, 20, 20);
    self.btnEnterShopPro.titleLabel.font = [UIFont systemFontOfSize:10.0];
    [self.btnEnterShopPro setImage:[UIImage imageNamed:@"gyhe_enter_shop.png"] forState:UIControlStateNormal];
    self.btnEnterShopPro.titleEdgeInsets = UIEdgeInsetsMake(26, -self.btnEnterShopPro.frame.size.width + 28, 0, 0);

    [self.btnContactShop setImage:[UIImage imageNamed:@"gycommon_contact_shop"] forState:UIControlStateNormal];
    self.btnContactShop.imageEdgeInsets = UIEdgeInsetsMake(6, 22, 18, 25);
    self.btnContactShop.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.btnContactShop.titleEdgeInsets = UIEdgeInsetsMake(22, -22, 0, 0);
    [self.btnContactShopPop setImage:[UIImage imageNamed:@"gycommon_contact_shop"] forState:UIControlStateNormal];
    self.btnContactShopPop.imageEdgeInsets = UIEdgeInsetsMake(6, 22, 18, 25);
    self.btnContactShopPop.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.btnContactShopPop.titleEdgeInsets = UIEdgeInsetsMake(26, -22, 0, 0);

    tvShopDetail.tableHeaderView = header;
    tvShopDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.btnContactShopPop.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.btnEnterShop setTitle:kLocalized(@"GYHE_SurroundVisit_EnterStore") forState:UIControlStateNormal];
    [self.btnEnterShopPro setTitle:kLocalized(@"GYHE_SurroundVisit_EnterStore") forState:UIControlStateNormal];

    //临时设置
    vButton.frame = CGRectMake(0, kScreenHeight - 44, vButton.frame.size.width, vButton.frame.size.height);
    [self.tabBarController.view.window addSubview:vButton];
    touchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 480)];
    touchView.backgroundColor = [UIColor blackColor];
    touchView.alpha = 0.5;
    tvSkuView.delegate = self;
    tvSkuView.dataSource = self;
    frame = CGRectMake(vButton.frame.origin.x, vButton.frame.origin.y, vButton.frame.size.width, vButton.frame.size.height);

    UIImage* image = kLoadPng(@"gycommon_nav_cart");
    CGRect backframe = CGRectMake(0, 0, image.size.width * 0.5, image.size.height * 0.5);
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = backframe;
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(pushCartVc:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    //    self.navigationItem.rightBarButtonItem = btnSetting;

    //      返回顶部按钮
    _backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    GYAppDelegate* app = (GYAppDelegate*)[UIApplication sharedApplication].delegate;

    _backTopBtn.frame = CGRectMake(app.window.bounds.size.width - 35 / 2 - 40, app.window.bounds.size.height - 51 - 50 +5, 45, 45);

    [_backTopBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_backtotop"] forState:0];

    [_backTopBtn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];

    _backTopBtn.hidden = YES;

    [app.window addSubview:_backTopBtn];

    tvShopDetail.showsHorizontalScrollIndicator = NO;
    tvShopDetail.showsVerticalScrollIndicator = NO;

    btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    [btnRight setImage:[UIImage imageNamed:@"gyhe_share_shop.png"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(sharebtnrating:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rig = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    self.navigationItem.rightBarButtonItems = @[ btnSetting, rig ]; //////分享

    // 分栏
    NSArray* menuTitles = @[ kLocalized(@"GYHE_SurroundVisit_Goods"),
        kLocalized(@"GYHE_SurroundVisit_Evaluate") ];
    menu = [[MenuTabView alloc] initMenuWithTitles:menuTitles withFrame:CGRectMake(0, 0, kScreenWidth, 44) isShowSeparator:YES];
    menu.delegate = self;
    //    [menu setDefaultItem:1];//设置默认选项
    [self.view addSubview:menu];
    [self loadDataFromNetwork];
    self.dicountRow = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = kNavigationBarColor;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

//视图消失时也应当关闭按钮
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    _backTopBtn.hidden = YES;
}

- (void)dealloc
{
    
    [vSel removeFromSuperview];
}



#pragma mark - MenuTabViewDelegate
- (void)changeViewController:(NSInteger)index
{
    [menu updateMenu:index];
    if (index == 1) {
        _backTopBtn.hidden = YES;
        [self.view bringSubviewToFront:self.EvaluateVC.view];
    }
    else {
        
        CGFloat wbHeight = kScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame);
        if(tvShopDetail.contentOffset.y < self.tableSCHeight + wbHeight - 130 + 40){
            
            _backTopBtn.hidden = YES;
        }else{
            
            _backTopBtn.hidden = NO;
        }
        [self.view sendSubviewToBack:self.EvaluateVC.view];
    }
}




#pragma mark 商品个数的代理方法GYSetNumCellDelegate
- (void)retNum:(NSInteger)Num {
    detailmodel.goodsNum = [NSString stringWithFormat:@"%ld", (long)Num];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.backgroundColor = [UIColor whiteColor];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView
{
    webView.backgroundColor = [UIColor whiteColor];
    DDLogDebug(@"Sucessed request:%@", webView.request);
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error
{
    webView.backgroundColor = [UIColor whiteColor];
    [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_NetworkRequestError")];
    DDLogDebug(@"Error Message:%@", [error localizedDescription]);
}




#pragma mark scrollview代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (scrollView == header.mainScrollView) {
        header.pageControl.currentPage = pageIndex;
        UIImageView* imageViewPic = [[UIImageView alloc] initWithFrame:CGRectMake(scrollView.contentOffset.x, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        imageViewPic.contentMode = UIViewContentModeScaleAspectFit;
        [imageViewPic setImageWithURL:[NSURL URLWithString:GoodsDetailMod.shopUrl[pageIndex][@"url"]] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        imageViewPic.tag = 300 + pageIndex;

        [scrollView addSubview:imageViewPic];
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    self.currentIndex = (scrollView.contentOffset.x + scrollView.frame.size.width * 0.5) / scrollView.frame.size.width;
    CGFloat wbHeight = kScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame);
    if (!self.bloadDetail) {
        if (scrollView == tvShopDetail) {

            CGFloat offHeight = scrollView.contentOffset.y;
            self.tableSCHeight = tvShopDetail.contentSize.height - tvShopDetail.frame.size.height;
            if (self.tableSCHeight + kScreenHeight * 0.1 < offHeight) {
                [self showGoodDetails];

                _backTopBtn.hidden = NO;
            }
        }
    }
    else if (scrollView == self.wvDetail.scrollView) {

        if (scrollView.contentOffset.y < -85) {
            [self removeGoodDetail];

            _backTopBtn.hidden = YES;
        }
    }
    else if (tvShopDetail.contentOffset.y < self.tableSCHeight + wbHeight - 130 + 40) {
        [self removeGoodDetail];

        _backTopBtn.hidden = YES;
    }
}





#pragma mark tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    if (tableView == tvSkuView) {
        return 1;
    }
    else {
        return 6;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tvSkuView) {
        return detailmodel.arrPropList.count + 1;
    }
    else {
        switch (section) {
            case 0:
                return 1;
                break;
            case 1:
                //                return 0;
                // 抵扣券信息
                return self.dicountRow;
                break;
            case 2:
                return 0;
                break;
            case 3:
                return rows;
                break;
            case 4: // add by songjk基本参数
                return 1;
                break;
            case 5:
                return 1;
                break;
            case 6:
                return 1;
                break;
            default:
                break;
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYGoodIntroductionModel* model = [[GYGoodIntroductionModel alloc] init];
    model.strData = GoodsDetailMod.introduces;
    if (tableView == tvSkuView) {
        if (indexPath.row == detailmodel.arrPropList.count) {
            return 44;
        }
        else {
            if(mArrBtnView.count >indexPath.row) {
                UIView* view = mArrBtnView[indexPath.row];
                return 44 + view.frame.size.height;
            }
            return 0;
        }
    }
    switch (indexPath.section) {
        case 0: {
            
            CGRect rect = [_model.name boundingRectWithSize:CGSizeMake(kScreenWidth - 135.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : kBigTitleFont } context:nil];
            
            CGRect rectAdd = [_model.addr boundingRectWithSize:CGSizeMake(kScreenWidth - 135.0, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:13] } context:nil];
            
            CGFloat totalHeight = 15 + rect.size.height + 10 + rectAdd.size.height + 10 + 20 + 15;
            return totalHeight > 85 ? totalHeight : 85;
        } break;
        case 1:
            if (self.marrDiscount.count > 0) { // 抵扣券信息
                return (20 + 10) * (self.marrDiscount.count - 1) + 20;
            }
            return 0;
            break;
        case 2:
            
            return model.fHight + 20;
            break;
        case 3:
            if(model.fHight == 0){
                 return model.fHight + 30;
            }else{
                 return model.fHight + 20;
            }
            return 44.f;
            break;
        case 4:
            return 44.f;
            break;
        case 5:
            return 44.f;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tvSkuView) {
        return nil;
    }
    else {
        switch (section) {
            case 0:
                return nil;
                break;
            case 1: {
                //                return [self listSurppotWay];
                // 显示抵扣券信息
                if (self.marrDiscount.count > 0) {
                    return [self discountList];
                }
                
            } break;
            case 2: {
                //                return [self  goodDetail];
                return [self listSurppotWay];
            } break;
            case 3: {
                //                return nil;
                return [self goodDetail];
            } break;
            case 4: {
            }
            case 5: {
                return nil;
            }
                return nil;
                break;
            default:
                break;
        }
        return nil;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView == tvSkuView) {
        return 0;
    }
    else {
        switch (section) {
            case 0:
                return 0;
                break;
            case 1:
                // 显示抵扣券系信息
                //                return 90;
                if (self.marrDiscount.count > 0) {
                    return 40;
                }
                else {
                    return 0;
                }
                break;
            case 2:
                //                return 40;
                return 40;
                break;
            case 3:
                //                return 0;
                return 40;
                break;
            case 4:
                return 0;
                break;
            case 5:
                return 0;
                break;
            default:
                break;
        }
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = nil;
    if (tableView == tvSkuView) {
        if (indexPath.row == detailmodel.arrPropList.count) {
            GYSetNumCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELLNUM"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
        else {
            GYSelCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELLSEL"];
            if(detailmodel.arrPropList.count > indexPath.row) {
                ArrModel* arrModel = detailmodel.arrPropList[indexPath.row];
                cell.lbTitle.text = arrModel.propName;
            }
            
            if ([self.btnStr isEqualToString:kLocalized(@"GYHE_SurroundVisit_OnePice")] || [self.btnStr isEqualToString:kLocalized(@"GYHE_SurroundVisit_OneTime")]) {
                
                cell.lbTitle.hidden = YES;
            }else {
                cell.lbTitle.hidden = NO;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            if (cell.btnView != nil) {
//                [cell.btnView removeFromSuperview];
//                cell.btnView = nil;
//            }

            if(mArrBtnView.count > indexPath.row)
                cell.btnView = mArrBtnView[indexPath.row];
            if (!([self.btnStr isEqualToString:kLocalized(@"GYHE_SurroundVisit_OnePice")] || [self.btnStr isEqualToString:kLocalized(@"GYHE_SurroundVisit_OneTime")])) {
                
                [cell addSubview:cell.btnView];
            }
            
            return cell;
        }
    }
    else {
        switch (indexPath.section) {
            case 0: {
                //商品名称的cell
                locationCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYShopLocationTableViewCell class]) owner:self options:nil] lastObject];
                
                locationCell.lbGoodName.text = GoodsDetailMod.itemName;
                
                // 距离用后台返回的数据:
                locationCell.lbDistance.text = [NSString stringWithFormat:@"%.1fkm", [detailmodel.dist doubleValue]];
                
                UIFont* font = [UIFont systemFontOfSize:13];
                NSString* strAddr = [NSString stringWithFormat:@"%@", GoodsDetailMod.addr];
                locationCell.lbShopAddress.text = strAddr;
                locationCell.lbShopAddress.font = font;
                
                [locationCell.btnShopTel setTitle:GoodsDetailMod.shopTel forState:UIControlStateNormal];
                [locationCell.btnShopTel addTarget:self action:@selector(callShop:) forControlEvents:UIControlEventTouchUpInside];
                [locationCell.btnCheckMap addTarget:self action:@selector(goToMap) forControlEvents:UIControlEventTouchUpInside];
                cell = locationCell;
                
            } break;
            case 1: {
                
                GYDiscountListCell* discountCell = [GYDiscountListCell cellWithTableView:tableView];
                discountCell.arryData = self.marrDiscount;
                cell = discountCell;
            } break;
            case 2: {
                //第二个section 中没有cell
                cell = nil;
            } break;
            case 3: {
                // modify by songjk
                GYGoodIntroductionModel* model = [[GYGoodIntroductionModel alloc] init];
                model.strData = GoodsDetailMod.introduces;
                GYGoodIntroductionCell* goodInfoCell = [GYGoodIntroductionCell cellWithTableView:tableView];
                goodInfoCell.model = model;
                cell = goodInfoCell;
                
            } break;
            case 4: {
                GYDefaultTableViewCell* baceInfoCell = [GYDefaultTableViewCell cellWithTableView:tableView];
                
                baceInfoCell.backgroundColor = [UIColor whiteColor];
                baceInfoCell.contentView.backgroundColor = [UIColor whiteColor];
                UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_cell_btn_right"]];
                imgv.frame = CGRectMake(40, 10, 9, 16);
                UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
                [accessoryView addSubview:imgv];
                baceInfoCell.accessoryView = accessoryView;
                
                baceInfoCell.textLabel.text = kLocalized(@"GYHE_SurroundVisit_BasicParameters");
                baceInfoCell.textLabel.textColor = kDetailBlackColor;
                baceInfoCell.textLabel.font = kCellTitleFont;
                baceInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                [baceInfoCell addTopBorder];
                cell = baceInfoCell;
            } break;
            case 5: {
                starCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYStarTableViewCell class]) owner:self options:nil] lastObject];
                
                starCell.btnStar1.selected = YES;
                starCell.btnStar2.selected = YES;
                starCell.btnStar3.selected = YES;
                starCell.btnStar4.selected = YES;
                if (GoodsDetailMod.rating.intValue <= 0) {
                    starCell.btnStar1.selected = NO;
                    starCell.btnStar2.selected = NO;
                    starCell.btnStar3.selected = NO;
                    starCell.btnStar4.selected = NO;
                    starCell.btnStar5.selected = NO;
                }
                else if (GoodsDetailMod.rating.intValue > 0 && GoodsDetailMod.rating.intValue <= 1) {
                    starCell.btnStar1.selected = YES;
                    starCell.btnStar2.selected = NO;
                    starCell.btnStar3.selected = NO;
                    starCell.btnStar4.selected = NO;
                    starCell.btnStar5.selected = NO;
                }
                else if (GoodsDetailMod.rating.intValue > 1 && GoodsDetailMod.rating.intValue <= 2) {
                    starCell.btnStar1.selected = YES;
                    starCell.btnStar2.selected = YES;
                    starCell.btnStar3.selected = NO;
                    starCell.btnStar4.selected = NO;
                    starCell.btnStar5.selected = NO;
                }
                else if (GoodsDetailMod.rating.intValue > 2 && GoodsDetailMod.rating.intValue <= 3) {
                    starCell.btnStar1.selected = YES;
                    starCell.btnStar2.selected = YES;
                    starCell.btnStar3.selected = YES;
                    starCell.btnStar4.selected = NO;
                    starCell.btnStar5.selected = NO;
                }
                else if (GoodsDetailMod.rating.intValue > 3 && GoodsDetailMod.rating.intValue <= 4) {
                    starCell.btnStar1.selected = YES;
                    starCell.btnStar2.selected = YES;
                    starCell.btnStar3.selected = YES;
                    starCell.btnStar4.selected = YES;
                    starCell.btnStar5.selected = NO;
                }
                else if (GoodsDetailMod.rating.intValue > 4 && GoodsDetailMod.rating.intValue <= 5) {
                    starCell.btnStar1.selected = YES;
                    starCell.btnStar2.selected = YES;
                    starCell.btnStar3.selected = YES;
                    starCell.btnStar4.selected = YES;
                    starCell.btnStar5.selected = YES;
                }
                
                starCell.lbPoint.text = [NSString stringWithFormat:@"%@", [NSString stringWithFormat:@"%.01f", [GoodsDetailMod.rating doubleValue]]];
                starCell.lbEvaluatePerson.text = [NSString stringWithFormat:kLocalized(@"GYHE_SurroundVisit_%@PresonEvalute"), GoodsDetailMod.evacount];
                UIImageView* imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gycommon_cell_btn_right"]];
                imgv.frame = CGRectMake(0, 10, 9, 16);
                UIView* accessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
                [accessoryView addSubview:imgv];
                starCell.accessoryView = accessoryView;
                
                [starCell.contentView addTopBorder];
                cell = starCell;
                
            } break;
            default:
                break;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 4: {
            // add by songjk
            if (detailmodel.arrBasicParameter.count == 0) {
                
                [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_GoodsNoParameterData")];
                return;
            }
            
            NSMutableArray* array = [[NSMutableArray alloc] init];
            GYEasybuyBasicInfoViewController* vc = [[GYEasybuyBasicInfoViewController alloc] init];
            
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
            for (ArrModel* mod in detailmodel.arrBasicParameter) {
                [dict setValue:mod.value forKey:@"value"];
                [dict setValue:mod.key forKey:@"key"];
                [array addObject:dict.copy];
            }
            vc.basicParameterArray = array;
            [self.navigationController pushViewController:vc animated:YES];
        } break;
            
        case 5: {
            GYAroundGoodsEvaluateDetailController* vcMainEvaluateDetail = [[GYAroundGoodsEvaluateDetailController alloc] init];
            vcMainEvaluateDetail.title = kLocalized(@"GYHE_SurroundVisit_EvaluateionCommnet");
            vcMainEvaluateDetail.strGoodId = _model.goodsId;
            [self.navigationController pushViewController:vcMainEvaluateDetail animated:YES];
        } break;
            
        default:
            break;
    }
}




#pragma mark 点击事件

//立即购买点击按钮
- (IBAction)btnBuyNow:(id)sender {
    kCheckLogined
    [self buyNowAction];
    
}
//重写加入购物车逻辑
- (IBAction)btnAddToShopCar:(id)sender
{
    
    kCheckLogined
    
    [self getSKUNetData];
    if (!isShowSkuView)
    {
        //没有属性直接请求sku
        if (self.mArrjson.count == 1 && !self.mArrjson.firstObject.selected && ([self.mArrjson.firstObject.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OnePice")] || [self.mArrjson.firstObject.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OneTime")])) {
            [self getSKUNetData];
        }
        
        [self showSKUView];
        return;
    }
    if (self.mArrjson.count == 1 && !self.mArrjson.firstObject.selected && ([self.mArrjson.firstObject.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OnePice")] || [self.mArrjson.firstObject.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OneTime")])) {
        self.mArrjson.firstObject.selected = YES;
        self.mArrjson.firstObject.hidden = YES;
        
        self.isAddShopingCart = YES;
        [self getSKUNetData];
        [self hideSKUView];
    }
    else {
        
        for (GYSelBtn* btn in self.mArrjson) {
            if (!btn.selected) {
                [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_PleaseSelectGoodsType")];
                break;
            }
            
            // add by songjk
            if ([detailmodel.goodsNum longLongValue] <= 0) {
                [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_PurchaseMinNumIsOne")];
                break;
            }
            if (btn == self.mArrjson[self.mArrjson.count - 1]) {
                if (detailmodel.strSkuId) {
                    [self addToNetCard];
                    [self hideSKUView];
                    btn.selected = NO;
                }
            }
        }
    }
}


//分享按钮
- (void)sharebtnrating:(UIButton*)sender
{
    GYSocialDataModel* model = [[GYSocialDataModel alloc] init];
    //创建分享参数
    NSInteger maxlength = 140;
    shareContent = [NSString stringWithFormat:@"%@%@%@", GoodsDetailMod.itemName, shareitemUrl, sharegoods];
    if (shareContent.length > maxlength) {
        shareContent = [shareContent substringToIndex:maxlength];
    }
    model.content = shareContent;
    model.title = detailmodel.title;
    model.toUrl = shareitemUrl;
    
    YYWebImageManager* manager = [YYWebImageManager sharedManager];
    [manager requestImageWithURL:[NSURL URLWithString:GoodsDetailMod.shopUrl[0][@"url"]] options:kNilOptions progress:nil transform:nil completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
        if (!error) {
            model.image = image;
        }
        [GYSocialDataService postWithSocialDataModel:model  presentedController:self];
        
    }];
}

- (void)showBigPic:(UITapGestureRecognizer*)gesture
{
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0, max = GoodsDetailMod.shopUrl.count; i < max; i++) {
        
        GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString(GoodsDetailMod.shopUrl[i][@"url"])];
        item.thumbView = [header.mainScrollView viewWithTag:300 + i];
        [items addObject:item];
    }
    
    GYPhotoGroupView* v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:[header.mainScrollView viewWithTag:300 + header.pageControl.currentPage] toContainer:self.navigationController.view animated:YES completion:nil];
}

- (IBAction)enterShop:(id)sender
{
    
    [self hideSKUView];
    
    GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
    CLLocationCoordinate2D shopCoordinate;
    shopCoordinate.latitude = _model.shoplat.doubleValue;
    shopCoordinate.longitude = _model.shoplongitude.doubleValue;
    mp = BMKMapPointForCoordinate(shopCoordinate);
    
    vc.currentMp1 = mp;
    ShopModel* model = [[ShopModel alloc] init];
    model.strVshopId = self.model.vShopId;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//进入购物车
- (void)pushCartVc:(id)sender
{
    kCheckLogined
    UIViewController* vcCart = [[NSClassFromString(@"GYHESCShoppingCartViewController") alloc] init];
    [self.navigationController pushViewController:vcCart animated:YES];
}


//按钮点击逻辑
- (void)btnClick:(GYSelBtn*)sender
{
    DDLogInfo(@"selected:%d",sender.selected);
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else {
        sender.selected = YES;
        for (GYSelBtn* btn in mArrBtn) {
            //判断按钮是否是同一行
            if ((btn.tag > sender.tag && (btn.tag - sender.tag) < 100) || (btn.tag < sender.tag && (sender.tag - btn.tag) < 100)) {
                btn.selected = NO;
                if (btn.selected == NO) {
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
        //设置按钮选择颜色为红色
        [sender setTitleColor:kNavigationBarColor forState:UIControlStateNormal];
    }
    //取消按钮选择颜色
    for (GYSelBtn* btn in mArrBtn) {
        //判断按钮是否是同一行
        if ((btn.tag > sender.tag && (btn.tag - sender.tag) < 100) || (btn.tag < sender.tag && (sender.tag - btn.tag) < 100)) {
            btn.selected = NO;
            if (btn.selected == NO) {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            break;
        }
    }
    //选择后更改json数组 选择按钮数据
    NSMutableArray* mArrTemp = [[NSMutableArray alloc] initWithArray:self.mArrjson];
    for (GYSelBtn* btnJson in self.mArrjson) {
        NSInteger i = 0;
        if (sender.row == btnJson.row) {
            [mArrTemp replaceObjectAtIndex:sender.row withObject:sender];
        }
        i++;
    }
    self.mArrjson
    = mArrTemp;
    for (GYSelBtn* btn in self.mArrjson) {
        if (btn.selected == NO) {
            break;
        }
        if (btn == self.mArrjson[self.mArrjson.count - 1]) {
            if (btn.selected == YES) {
                
                [GYGIFHUD show];
                self.isAddShopingCart = NO;
                [self getSKUNetData];
            }
        }
    }
}

- (void)btnClicked:(UIButton*)sender
{
    sender.selected = YES;
}


- (void)callShop:(UIButton*)sender
{
    NSString* phoneNumber = GoodsDetailMod.shopTel;
    if (phoneNumber == nil || [phoneNumber isKindOfClass:[NSNull class]]) {
        return;
    }
    
    [GYUtils callPhoneWithPhoneNumber:phoneNumber showInView:self.view];
}


- (void)showMore:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.dicountRow = 1;
    }
    else {
        self.dicountRow = 0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.imgArrow.transform = CGAffineTransformRotate(self.imgArrow.transform, DEGREES_TO_RADIANS(180));
    }];
    NSIndexSet* indexSet = [[NSIndexSet alloc] initWithIndex:1];
    [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}



//联系商家点击事件
- (IBAction)btnContactShop:(id)sender
{
    [self hideSKUView];
    kCheckLogined
    [self contactShopRequest];
}


#pragma mark 自定义方法

//弹出SKU界面
- (void)showSKUView
{
    [self setBtnStatus];
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         isShowSkuView = YES;
                         
                         
                         if (kIS_IPHONE_4_OR_LESS) {
                             vPopView.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100);
                         } else {
                             vPopView.frame = CGRectMake(0, 100, kScreenWidth, kScreenHeight - 100);
                         }
                         
                         self.blackgroundView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
                         self.navigationController.navigationBarHidden = YES;
                     }
                     completion:NULL];
    
 
}

- (void)hideSKUView {
    [vPopView endEditing:YES];
    for (GYSelBtn *Selbtn in self.mArrjson) {
        [Selbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        Selbtn.selected = NO;
    }//重新对按钮进行设置
    
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         isShowSkuView = NO;
                         self.navigationController.navigationBarHidden = NO;
                         
                         self.blackgroundView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
                         
                         
                     }
                     completion:NULL
     ];
}

-(void)setBtnStatus
{//弹出视图重新判断是否需要默认选中
    for (GYSelBtn *Selbtn in self.mArrjson) {
        [Selbtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        NSDictionary *responseDict = _responseDic;
        for (NSDictionary *dicTemp in responseDict[@"data"][@"propList"]) {
            ArrModel *arrModel = [[ArrModel alloc] init];
            arrModel.propId = [NSString stringWithFormat:@"%@", dicTemp[@"id"]];
            arrModel.propName = [NSString stringWithFormat:@"%@", dicTemp[@"name"]];
            for (NSDictionary *dic1 in dicTemp[@"subs"]) {
                ArrSubsModel *subsModel = [[ArrSubsModel alloc] init];
                subsModel.vid = [NSString stringWithFormat:@"%@", dic1[@"vid"]];
                subsModel.vName = [NSString stringWithFormat:@"%@", dic1[@"vname"]];
                [arrModel.arrSubs addObject:subsModel];
            }
            [detailmodel.arrPropList addObject:arrModel];
        }
        for (ArrModel* arrModel in detailmodel.arrPropList) {
                if(arrModel.arrSubs.count ==1 ) {
                    Selbtn.selected = YES;
                }
        }//重新对按钮进行设置
    }
}

- (void)pushVC:(id)vc animated:(BOOL)ani
{
    
    [self.navigationController pushViewController:vc animated:ani];
}

- (void)setTheButton
{
    //设置按钮
    [self.vBottomView addTopBorder];
    [self.vBottomViewPop addTopBorder];
    
    [self.btnBrowse setTitle:kLocalized(@"GYHE_SurroundVisit_BuyNow") forState:UIControlStateNormal];
    
    [self.btnContactShop setTitle:kLocalized(@"GYHE_SurroundVisit_ContactShop") forState:UIControlStateNormal];
    [self.btnAddToShopCar setTitle:kLocalized(@"GYHE_SurroundVisit_AddIntoShopCar") forState:UIControlStateNormal];
    
    [self.btnBrowsePop setTitle:kLocalized(@"GYHE_SurroundVisit_BuyNow") forState:UIControlStateNormal];
    
    [self.btnContactShopPop setTitle:kLocalized(@"GYHE_SurroundVisit_ContactShop") forState:UIControlStateNormal];
    [self.btnAddToShopCarPop setTitle:kLocalized(@"GYHE_SurroundVisit_AddIntoShopCar") forState:UIControlStateNormal];
    
    [self setBorderWithView:self.btnContactShop WithWidth:0 WithRadius:0 WithColor:kDefaultViewBorderColor WithBackgroundColor:[UIColor whiteColor] WithTitleColor:kCellItemTitleColor];
    [self setBorderWithView:self.btnBrowse WithWidth:0 WithRadius:0 WithColor:kNavigationBarColor WithBackgroundColor:kNavigationBarColor WithTitleColor:nil];
    [self setBorderWithView:self.btnAddToShopCar WithWidth:0 WithRadius:0.0 WithColor:[UIColor orangeColor] WithBackgroundColor:[UIColor orangeColor] WithTitleColor:nil];
    [self setBorderWithView:self.btnContactShopPop WithWidth:0 WithRadius:0.0 WithColor:kDefaultViewBorderColor WithBackgroundColor:[UIColor whiteColor] WithTitleColor:kCellItemTitleColor];
    
    [self setBorderWithView:self.btnBrowsePop WithWidth:0 WithRadius:0.0 WithColor:kNavigationBarColor WithBackgroundColor:kNavigationBarColor WithTitleColor:nil];
    [self setBorderWithView:self.btnAddToShopCarPop WithWidth:0 WithRadius:0.0 WithColor:[UIColor orangeColor] WithBackgroundColor:[UIColor orangeColor] WithTitleColor:nil];
    [self setBorderWithView:self.btnEnterShop WithWidth:0 WithRadius:0 WithColor:kDefaultViewBorderColor WithBackgroundColor:[UIColor whiteColor] WithTitleColor:kCellItemTitleColor];
    [self.btnAddToShopCar setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBrowse setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnAddToShopCarPop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnBrowsePop setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)addToCollectionRequest
{
    kCheckLogined if (header.btnAttention.isSelected)
    {
        [GYGIFHUD show];
        
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
        [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
        [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
        [dict setValue:globalData.loginModel.token forKey:@"key"];
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:CancelCollectionGoodsUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            
            [GYGIFHUD dismiss];
            
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_GoodsUnderFrame")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            //商铺已经关闭
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]) {
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    
                    header.btnAttention.selected = NO;
                    header.btnAttention.userInteractionEnabled = YES;
                    [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_CancelCollectionSuccess")];
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
        [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
        [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
        [dict setValue:GoodsDetailMod.serviceResourceNo forKey:@"serviceResourceNo"];
        [dict setValue:globalData.loginModel.token forKey:@"key"];
        
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:CollectionGoodsUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
            
            [GYGIFHUD dismiss];
            
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_GoodsUnderFrame")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            //商铺已经关闭
            if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]) {
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")];
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
            
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    
                    header.btnAttention.selected = YES;
                    header.btnAttention.userInteractionEnabled = NO;
                    [self.view makeToast:kLocalized(@"GYHE_SurroundVisit_CollectionSuccess")];
                }
                
            }else {
                [GYUtils parseNetWork:error resultBlock:nil];
            }
        }];
        [request start];
    }
}

- (void)contactShopRequest
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [dict setValue:GoodsDetailMod.companyResourceNo forKey:@"resourceNo"];
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetVShopShortlyInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_GoodsUnderFrame")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        //商铺已经关闭
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"] && [ResponseDic[@"data"] isKindOfClass:[NSDictionary class]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        GYHDChatViewController *chatViewController = [[GYHDChatViewController alloc] init];
                        
                        NSMutableDictionary *comDict = [NSMutableDictionary dictionaryWithDictionary:responseObject];
                        NSString *price;
                        if([GoodsDetailMod.lowPrice floatValue] == [GoodsDetailMod.price floatValue]) {
                            price = [NSString stringWithFormat:@"%.2f",[GoodsDetailMod.price doubleValue]] ;
                        }else {
                            price = [NSString stringWithFormat:kLocalized(@"GYHE_SurroundVisit_%0.2fQi"),[GoodsDetailMod.lowPrice doubleValue]];
                        }
                        NSString *pv;
                        if([GoodsDetailMod.lowPv floatValue] ==[GoodsDetailMod.goodsPv floatValue]) {
                            pv = [NSString stringWithFormat:@"%.2f",[GoodsDetailMod.goodsPv doubleValue]];
                        }else {
                            pv = [NSString stringWithFormat:kLocalized(@"GYHE_SurroundVisit_%0.2fQi"),[GoodsDetailMod.lowPv doubleValue]];
                        }
                        [comDict setValue:@{
                                            @"prod_id":kSaftToNSString(GoodsDetailMod.goodsId) ,
                                            @"prod_name":kSaftToNSString(GoodsDetailMod.itemName),
                                            @"prod_des":kSaftToNSString(GoodsDetailMod.introduces) ,
                                            @"prod_price":kSaftToNSString(price),
                                            @"prod_pv":kSaftToNSString(pv),
                                            @"imageNailsUrl":kSaftToNSString(GoodsDetailMod.shopUrl.firstObject[@"url"])
                                            } forKey:@"goods"];
                        [comDict setValue:@"" forKey:@"orders"];
                        
                        chatViewController.companyInformationDict = comDict;
                        
                        [self.navigationController pushViewController:chatViewController animated:YES];
                        
                    });
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    [request start];
}

- (void)loadDataFromNetwork
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    NSString* str = nil;
    
    if (globalData.selectedCityCoordinate) {
        str = globalData.selectedCityCoordinate;
    }
    else {
        str = [NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude];
    }
    NSCharacterSet* inset = [NSCharacterSet characterSetWithCharactersInString:@","];
    
    NSArray* arr = [str componentsSeparatedByCharactersInSet:inset];
    
    CLLocationCoordinate2D shopCoordinat;
    shopCoordinat.latitude = [arr[0] doubleValue];
    shopCoordinat.longitude = [arr[1] doubleValue];
    mp = BMKMapPointForCoordinate(shopCoordinat);
    
    [dict setValue:str forKey:@"landmark"];
    
    [dict setValue:_model.goodsId forKey:@"itemId"];
    [dict setValue:self.model.vShopId forKey:@"vShopId"];
    [dict setValue:self.model.shopId forKey:@"shopId"];
    if (globalData.loginModel.token == nil) {
        
        [dict setValue:@"" forKey:@"key"];
    }
    else {
        
        [dict setValue:globalData.loginModel.token forKey:@"key"];
    }
    
    DDLogDebug(@"%@", dict);
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_GoodsUnderFrame")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        //商铺已经关闭
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        // add by songjk
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
//            WS(weakSelf)
//            [GYUtils showMessage:kLocalized(@"Systemisbusypleaselater") confirm:^{
            [self.navigationController popViewControllerAnimated:YES];
//            }];
        } else {
            
            
            _responseDic = responseObject;
            
            
            NSDictionary *responseDict = responseObject;
            NSString *str = [NSString stringWithFormat:@"%@", [responseDict objectForKey:@"retCode"]];
            if ([str isEqualToString:@"200"]) {
                self.goodsDict = responseDict[@"data"];
                
                [self setMOdelWithDict:responseDict];
                GoodsDetailMod = [[GYSurrondGoodsDetailModel alloc] init];
                GoodsDetailMod.addr = responseDict[@"data"][@"addr"];
                GoodsDetailMod.shopId = kSaftToNSString(responseDict[@"data"] [@"shopId"]);
                GoodsDetailMod.beCash = kSaftToNSString(responseDict [@"data"][@"beCash"]);
                GoodsDetailMod.beReach = kSaftToNSString(responseDict [@"data"][@"beReach"]);
                GoodsDetailMod.beSell = kSaftToNSString(responseDict [@"data"][@"beSell"]);
                GoodsDetailMod.beTake = kSaftToNSString(responseDict [@"data"][@"beTake"]);
                GoodsDetailMod.beTicket = kSaftToNSString(responseDict [@"data"][@"beTicket"]);
                GoodsDetailMod.companyResourceNo = responseDict [@"data"][@"companyResourceNo"];
                GoodsDetailMod.evacount = responseDict[@"data"] [@"evacount"];
                GoodsDetailMod.goodsId = kSaftToNSString(responseDict[@"data"] [@"id"]);
                
                if (responseDict [@"data"][@"introduces"] == nil || [responseDict [@"data"][@"introduces"] isKindOfClass:[NSNull class]]) {
                    GoodsDetailMod.itemName = @"";
                } else {
                    GoodsDetailMod.introduces = responseDict [@"data"][@"introduces"];
                }
                GoodsDetailMod.itemName = responseDict [@"data"][@"itemName"];  //商品名称
                GoodsDetailMod.goodsPv = responseDict[@"data"][@"pv"];
                GoodsDetailMod.lat = responseDict[@"data"] [@"lat"];
                GoodsDetailMod.longitude = responseDict[@"data"] [@"longitude"];
                GoodsDetailMod.picDetails = responseDict[@"data"] [@"picDetails"];
                GoodsDetailMod.beFocus = responseDict [@"data"] [@"beFocus"];
                
                // add by songjk
                GoodsDetailMod.isApplyCard = [NSString stringWithFormat:@"%@", responseDict [@"data"] [@"isApplyCard"]];
                GoodsDetailMod.postageMsg = responseDict[@"data"][@"postageMsg"];
                GoodsDetailMod.postage = [NSString stringWithFormat:@"%@", responseDict [@"data"] [@"postage"]];
                
                if (responseDict[@"data"][@"city"] && [responseDict[@"data"][@"city"] length] > 0) {
                    GoodsDetailMod.city = responseDict [@"data"] [@"city"];
                } else {
                    GoodsDetailMod.city = @"";
                }
                if (responseDict[@"data"][@"area"] && [responseDict[@"data"][@"area"] length] > 0) {
                    GoodsDetailMod.area = responseDict [@"data"] [@"area"];
                } else {
                    GoodsDetailMod.area = @"";
                }
                if (GoodsDetailMod.beFocus.boolValue) {
                    
                    header.btnAttention.selected = YES;
                    header.btnAttention.userInteractionEnabled = NO;
                } else {
                    header.btnAttention.selected = NO;
                    header.btnAttention.userInteractionEnabled = YES;
                }
                shareitemUrl = responseDict[@"data"][@"itemUrl"];
                sharegoods = responseDict[@"data"][@"introduces"];
                GoodsDetailMod.shopName = responseDict[@"data"] [@"shopName"];  //商铺名称
                GoodsDetailMod.price = kSaftToNSString(responseDict [@"data"][@"price"]);
                GoodsDetailMod.rating = responseDict [@"data"][@"rating"];
                GoodsDetailMod.serviceResourceNo = responseDict[@"data"] [@"serviceResourceNo"];
                GoodsDetailMod.shopId = kSaftToNSString(responseDict[@"data"] [@"shopId"]);
                GoodsDetailMod.shopName = responseDict [@"data"][@"shopName"];
                if (responseDict[@"data"] [@"tel"] == nil || [responseDict[@"data"] [@"tel"] isKindOfClass:[NSNull class]]) {
                    GoodsDetailMod.itemName = @"";
                } else {
                    GoodsDetailMod.shopTel = responseDict[@"data"] [@"tel"];
                }
                GoodsDetailMod.propList = responseDict[@"data"][@"propList"];  //产品的SKU数组
                GoodsDetailMod.shopUrl = responseDict[@"data"] [@"picList"];  //图片数组
                GoodsDetailMod.vShopId = kSaftToNSString(responseDict[@"data"] [@"vShopId"]);
                GoodsDetailMod.vShopName = responseDict [@"data"][@"vShopName"];
                GoodsDetailMod.monthlySales = responseDict [@"data"][@"monthlySales"];   // add by songjk
                //组建jeson字符串
                GoodsDetailMod.saleCount = kSaftToNSString(responseDict [@"data"][@"salesCount"]);    // add by songjk
                detailmodel.goodsNum = @"1";
                detailmodel.title = responseDict[@"data"][@"itemName"];
                detailmodel.categoryId = [NSString stringWithFormat:@"%@", responseDict[@"data"][@"categoryId"]];
#warning 修改标记 删除stringvalue
                detailmodel.goodsID = responseDict[@"data"] [@"id"];
                detailmodel.pv = [NSString stringWithFormat:@"%@", responseDict[@"data"][@"pv"]];
                detailmodel.strPrice = [NSString stringWithFormat:@"%@", responseDict [@"data"][@"price"]];
                detailmodel.vShopId = [NSString stringWithFormat:@"%@", responseDict [@"data"][@"vShopId"]];
                detailmodel.serviceResourceNo = [NSString stringWithFormat:@"%@", responseDict [@"data"][@"serviceResourceNo"]];
                detailmodel.companyResourceNo = [NSString stringWithFormat:@"%@", responseDict [@"data"][@"companyResourceNo"]];
                // add by songjk
                detailmodel.strRuleID = [NSString stringWithFormat:@"%@", responseDict [@"data"][@"ruleId"]];
                detailmodel.isApplyCard = [NSString stringWithFormat:@"%@", responseDict [@"data"][@"isApplyCard"]];
                detailmodel.postageMsg = responseDict[@"data"][@"postageMsg"];
                detailmodel.postage = [NSString stringWithFormat:@"%@", responseDict [@"data"] [@"postage"]];
                detailmodel.couponDesc = kSaftToNSString(responseDict [@"data"] [@"couponDesc"]);    // 抵扣券信息
                detailmodel.price = kSaftToNSString(responseDict [@"data"] [@"price"]);    // 最高价格
                detailmodel.lowPv = kSaftToNSString(responseDict [@"data"] [@"lowPv"]);    // 最低积分
                detailmodel.lowPrice = kSaftToNSString(responseDict [@"data"] [@"lowPrice"]);    // 最低价格
                if (!responseDict[@"data"][@"dist"]) {
                    
                    CLLocationCoordinate2D shopCoordinate;
                    shopCoordinate.latitude = GoodsDetailMod.lat.doubleValue;
                    shopCoordinate.longitude = GoodsDetailMod.longitude.doubleValue;
                    BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(mp, mp2);
                    detailmodel.dist = [NSString stringWithFormat:@"%.02f", dis/1000];
                } else {
                    detailmodel.dist = kSaftToNSString(responseDict [@"data"] [@"dist"]);    // 距离
                }
                
                
                
                if (detailmodel.couponDesc.length > 0) {
                    [self.marrDiscount addObject:detailmodel.couponDesc];
                }
                for (NSDictionary *dicTemp in responseDict[@"data"][@"propList"]) {
                    ArrModel *arrModel = [[ArrModel alloc] init];
                    arrModel.propId = [NSString stringWithFormat:@"%@", dicTemp[@"id"]];
                    arrModel.propName = [NSString stringWithFormat:@"%@", dicTemp[@"name"]];
                    
                    for (NSDictionary *dic1 in dicTemp[@"subs"]) {
                        ArrSubsModel *subsModel = [[ArrSubsModel alloc] init];
                        subsModel.vid = [NSString stringWithFormat:@"%@", dic1[@"vid"]];
                        subsModel.vName = [NSString stringWithFormat:@"%@", dic1[@"vname"]];
                        [arrModel.arrSubs addObject:subsModel];
                    }
                    [detailmodel.arrPropList addObject:arrModel];
                }
                
                // add by songjk
                //获取参数数据
                for (NSDictionary *dictBase in responseDict[@"data"][@"basicParameter"]) {
                    ArrModel *arrModel = [[ArrModel alloc] init];
                    arrModel.key = [NSString stringWithFormat:@"%@", dictBase[@"key"]];
                    arrModel.value = [NSString stringWithFormat:@"%@", dictBase[@"value"]];
                    [detailmodel.arrBasicParameter addObject:arrModel];
                }
                GYEasyBuyModel *model = [[GYEasyBuyModel alloc] init];
                if (GoodsDetailMod.shopUrl.count > 0) {
                    model.strGoodPictureURL = GoodsDetailMod.shopUrl[0][@"url"];
                } else {
                    model.strGoodPictureURL = @" ";
                }
                model.strGoodName = GoodsDetailMod.itemName;
                model.strGoodPrice = GoodsDetailMod.price;
                model.strGoodId = detailmodel.goodsID;
                ShopModel *shopModel = [[ShopModel alloc] init];
                shopModel.strShopId = GoodsDetailMod.shopId;
                model.shopInfo = shopModel;
                model.numBroweTime = @([[NSDate date] timeIntervalSince1970]);    //用于显示排序
                [self saveBrowsingHistory:model];
                [self setBtn];
                [self getTbvHeight];
                GoodsDetailMod.bigPrice = detailmodel.price;
                GoodsDetailMod.lowPv = detailmodel.lowPv;
                GoodsDetailMod.lowPrice = detailmodel.lowPrice;
                [header setInfoForHeaderView:GoodsDetailMod];
                [tvShopDetail reloadData];
                [tvSkuView reloadData];
                [self setTopView];
                
            } else if ([str isEqualToString:@"507"]) { // add by songjk判读商品下架
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_GoodsUnderFrame") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                WS(weakSelf)
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_NetworkRequestErrors") confirm:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        }
        
    }];
    [request start];
}

- (void)setMOdelWithDict:(NSDictionary*)ResponseDic
{
    NSDictionary* tempDic = ResponseDic[@"data"];
    self.model.name = kSaftToNSString(tempDic[@"itemName"]);
    self.model.addr = kSaftToNSString(tempDic[@"addr"]);
    self.model.beCash = kSaftToNSString(tempDic[@"beCash"]);
    self.model.beReach = kSaftToNSString(tempDic[@"beReach"]);
    self.model.beSell = kSaftToNSString(tempDic[@"beSell"]);
    self.model.beTake = kSaftToNSString(tempDic[@"beTake"]);
    self.model.beTicket = kSaftToNSString(tempDic[@"beTicket"]);
    self.model.goodsId = kSaftToNSString(tempDic[@"id"]);
    NSNumber* lat = tempDic[@"lat"];
    self.model.shoplat = [NSString stringWithFormat:@"%f", [lat floatValue]];
    NSNumber* longitude = tempDic[@"longitude"];
    self.model.shoplongitude = [NSString stringWithFormat:@"%f", [longitude floatValue]];
    self.model.shopsName = kSaftToNSString(tempDic[@"name"]);
    NSNumber* price = tempDic[@"price"];
    self.model.price = [NSString stringWithFormat:@"%0.02f", [price doubleValue]];
    NSNumber* pv = tempDic[@"pv"];
    self.model.goodsPv = [NSString stringWithFormat:@"%.02f", [pv doubleValue]];
    self.model.shopId = kSaftToNSString(tempDic[@"shopId"]);
    
    self.model.moonthlySales = kSaftToNSString(tempDic[@"monthlySales"]);
    self.model.saleCount = kSaftToNSString(tempDic[@"salesCount"]);
    if ([kSaftToNSString(tempDic[@"tel"]) length] > 0) {
        self.model.shopTel = kSaftToNSString(tempDic[@"tel"]);
    }
    else {
        self.model.shopTel = @" ";
    }
    self.model.vShopId = kSaftToNSString(tempDic[@"vShopId"]);
    self.model.shopSection = kSaftToNSString(tempDic[@"area"]);
    
    self.model.shopDistance = [NSString stringWithFormat:@"%.01f", [[tempDic objectForKey:@"dist"] doubleValue]];
}

//保存浏览历史记录
- (void)saveBrowsingHistory:(GYEasyBuyModel*)model
{
    //    model.numBroweTime = @([[NSDate date] timeIntervalSince1970]);//用于显示排序
    NSString* key = kKeyForBrowsingHistory;
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    if (!(model.strGoodPictureURL.length > 0 || model.strGoodName.length > 0 || model.strGoodPrice.length > 0 || model.strGoodId.length > 0 || model.shopInfo.strShopId.length > 0)) {
        return;
    }
    NSDictionary* dicGoods = @{ @"goodsPictureUrl" : model.strGoodPictureURL,
                                @"goodsName" : model.strGoodName,
                                @"goodsPrice" : model.strGoodPrice,
                                @"goodsId" : model.strGoodId,
                                @"shopId" : self.model.vShopId,
                                @"numBroweTime" : model.numBroweTime };
    [dicBrowsing setObject:dicGoods forKey:model.strGoodId];
    
    //保存
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
}

- (void)getSKUNetData
{
    //创建 json数组
    NSMutableArray* mArray = [[NSMutableArray alloc] init];
    NSMutableArray* tempArr = [NSMutableArray array];
    for (GYSelBtn* btn in self.mArrjson) {
        [mArray addObject:btn.dic];
        [tempArr addObject:btn.dic[@"pVName"]];
        strRetParameterVl = [[strRetParameterVl stringByAppendingString:[NSString stringWithFormat:@",%@", btn.dic[@"pVId"]]] mutableCopy];
    }
    strRetParameterVl = [strRetParameterVl substringFromIndex:1];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:strRetParameterVl forKey:@"sku"];
    [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
    [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsSkuUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_GoodsUnderFrame")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        //商铺已经关闭
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        } else {
            NSDictionary *ResponseDic = responseObject;
            NSString *str = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
            if ([str isEqualToString:@"200"]) {
                self.skuDict = ResponseDic[@"data"];
                strRetParameterVl = [@"" mutableCopy];//重置 规格id。
                //返回正确数据，并进行解析
                detailmodel.strPicList = [NSString stringWithFormat:@"%@", ResponseDic[@"data"][@"picList"]];
                detailmodel.strPrice = [NSString stringWithFormat:@"%@", ResponseDic[@"data"][@"price"]];
                detailmodel.strPv = [NSString stringWithFormat:@"%@", ResponseDic[@"data"][@"pv"]];
                detailmodel.strSkuId = [NSString stringWithFormat:@"%@", ResponseDic[@"data"][@"skuId"]];
                detailmodel.goodsSkus = ResponseDic[@"data"][@"sku"];
                strPictureUrl = ResponseDic[@"data"][@"picList"][0][@"url"];
                [self setViewValues];
                if (self.isAddShopingCart) {
                    [self addToNetCard];
                }
            } else {
                
                
            }
        }
    }];
    [request start];
}

- (void)setViewValues
{
    lbTitle.text = [NSString stringWithFormat:@"%.2f", detailmodel.strPrice.doubleValue];
    [imgGoodsPic setImageWithURL:[NSURL URLWithString:strPictureUrl] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
}


- (void)setBtn
{
    NSInteger z = 1;
    for (ArrModel* arrModel in detailmodel.arrPropList) {
        CGFloat x = 0;
        CGFloat y = 0;
        UIView* btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 200)];
        
        NSInteger s = 0;
        for (ArrSubsModel* subsModel in arrModel.arrSubs) {
            GYSelBtn* btn = [GYSelBtn buttonWithType:UIButtonTypeCustom];
            
            UIEdgeInsets insets = UIEdgeInsetsMake(2, 2, 30, 30);
            UIImage* img1 = [UIImage imageNamed:@"gycommon_sku_unselected"];
            UIImage* img2 = [UIImage imageNamed:@"gycommon_sku_selected"];
            UIImage* unSelImg = [img1 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
            UIImage* selImg = [img2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
            [btn setBackgroundImage:unSelImg forState:UIControlStateNormal];
            [btn setBackgroundImage:selImg forState:UIControlStateSelected];
            
            btn.dic = [[NSMutableDictionary alloc] init];
            
            
            if(arrModel.arrSubs.count ==1 ) {
                btn.selected = YES;
            }
            
            
            btn.frame = CGRectMake(21 + x, 10 + y, 31 + subsModel.vName.length * 10, 31);
            
            if (x != 0 && btn.frame.origin.x + btn.frame.size.width > [UIScreen mainScreen].bounds.size.width) {
                x = 0;
                y = btn.frame.origin.y + btn.frame.size.height;
                btn.frame = CGRectMake(21 + x, 10 + y, 31 + subsModel.vName.length * 10, 31);
            }
            x = btn.frame.origin.x + btn.frame.size.width;
            [btn setTitle:subsModel.vName forState:UIControlStateNormal];
            [btn setTitle:subsModel.vName forState:UIControlStateHighlighted];
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            
            btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.backgroundColor = [UIColor whiteColor];
            btn.tag = z * 10000 + s;
            s++;
            
            btn.row = z - 1;
            [btn.dic setValue:arrModel.propId forKey:@"pId"];
            [btn.dic setValue:arrModel.propName forKey:@"pName"];
            [btn.dic setValue:subsModel.vid forKey:@"pVId"];
            [btn.dic setValue:subsModel.vName forKey:@"pVName"];
            self.btnStr = subsModel.vName;
            [mArrBtn addObject:btn];
            btnView.frame = CGRectMake(0, 34, [UIScreen mainScreen].bounds.size.width, btn.frame.origin.y + btn.frame.size.height);
            [btnView addSubview:btn];
            
            if (btn.row == self.mArrjson.count) {
                [self.mArrjson
                 addObject:btn];
            }
            
        }
        z++;
        [mArrBtnView addObject:btnView];
        
    }
    
    
}

- (void)setTopView
{
    lbGoodsName.text = GoodsDetailMod.itemName;
    lbGoodsName.textColor = kCellItemTitleColor;
    lbTitle.textColor = kNavigationBarColor;
    lbTitle.text = [NSString stringWithFormat:@"%.2f", GoodsDetailMod.price.doubleValue];
    NSDictionary* dict = GoodsDetailMod.shopUrl[0];
    NSString* str = kSaftToNSString(dict[@"url"]);
    [imgGoodsPic setImageWithURL:[NSURL URLWithString:str] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
}

//加入购物车
- (void)addToNetCard
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@", detailmodel.goodsNum] forKey:@"num"];
    [dict setValue:detailmodel.strPrice forKey:@"originalPrice"];
    [dict setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    [dict setValue:GoodsDetailMod.vShopName forKey:@"vShopName"];
    [dict setValue:GoodsDetailMod.shopId forKey:@"shopId"];
    [dict setValue:GoodsDetailMod.shopName forKey:@"shopName"];
    [dict setValue:GoodsDetailMod.goodsId forKey:@"itemId"];
    [dict setValue:detailmodel.strSkuId forKey:@"skuId"];
    [dict setValue:detailmodel.goodsSkus forKey:@"skus"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [dict setValue:@"2" forKey:@"sourceId"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetAddCartUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"507"]) {
            [GYUtils showMessage:kLocalized(@"HEGoodsUnderFrGYHE_SurroundVisit_GoodsUnderFrameame")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        //商铺已经关闭
        if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"855"]) {
            [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_ShopClocePleaseTryLater")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        } else {
            NSString *str = [NSString stringWithFormat:@"%@", responseObject[@"retCode"]];
            if ([str isEqualToString:@"200"]) {
                //返回正确数据，并进行解析
                [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_AddShoppingCartSuceed")];
            } else {
                if([kSaftToNSString(responseObject[@"retCode"]) isEqualToString:@"502"]) {
                    [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_MoreToMaxNum")];
                    return ;
                }
                [GYUtils showToast:kLocalized(@"GYHE_SurroundVisit_FaildAddedShoppingCart")];
                //返回数据不正确
            }
        }
    }];
    [request start];
}

- (void)buyNowAction
{
    kCheckLogined
    
    for (GYSelBtn* btn in self.mArrjson) {
        if (btn.selected == NO) {
            if (([btn.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OnePice")] || [btn.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OneTime")]) && self.mArrjson.count == 1) {
                btn.selected = YES;
                btn.hidden = YES;
                
                self.isAddShopingCart = NO;
                [self getSKUNetData];
            }
            else {
                
                if (isShowSkuView) {
                    
                    [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_PleaseSelectGoodsType")];
                }
            }
            
            if (btn.selected == NO || (btn.selected == YES && ([btn.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OnePice")] || [btn.dic[@"pVName"] isEqualToString:kLocalized(@"GYHE_SurroundVisit_OneTime")]) && self.mArrjson.count == 1)) {
                [self showSKUView];
                break;
            }
        }
        
        
        // add by songjk
        if ([detailmodel.goodsNum longLongValue] <= 0) {
            if (isShowSkuView) {
                [GYUtils showMessage:kLocalized(@"GYHE_SurroundVisit_PurchaseMinNumIsOne")];
            }
            else {
                [self showSKUView];
            }
            break;
        }
        if (btn == self.mArrjson[self.mArrjson.count - 1]) {
            
            if (btn.selected == YES) {
                if (detailmodel.strSkuId) {
                    [self hideSKUView];
                    if (self.navigationController.navigationBarHidden == YES) {
                        [self hideSKUView];
                    }
                    
                    UIViewController* vc = [[NSClassFromString(@"GYHESCConfirmOrderViewController") alloc] init];
                    [vc setValue:self.skuDict forKey:@"skuDict"];
                    [vc setValue:self.goodsDict forKey:@"goodsDict"];
                    [vc setValue:@"1" forKey:@"isRightAway"];
                    [vc setValue:detailmodel.goodsNum forKey:@"goodsNumber"];
                    [vc hidesBottomBarWhenPushed];
                    [self.navigationController pushViewController:vc animated:YES];
                }else {
                    [self showSKUView];
                    [self getSKUNetData];
                    break;
                }
            }
        }
    }
}

//获取tbvSel高度
- (void)getTbvHeight
{
    tbvSelHeight = 44;
    for (UIView* view in mArrBtnView) {
        tbvSelHeight = view.frame.size.height + tbvSelHeight + 44;
    }
}

- (void)setBorderWithView:(UIButton*)view WithWidth:(CGFloat)width WithRadius:(CGFloat)radius WithColor:(UIColor*)color WithBackgroundColor:(UIColor*)backgroundColor WithTitleColor:(UIColor*)titleColor
{
    [view setTitleColor:color forState:UIControlStateNormal];
    view.layer.borderWidth = width;
    view.layer.borderColor = color.CGColor;
    view.layer.cornerRadius = radius;
    if (titleColor) {
        [view setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    [view setBackgroundColor:backgroundColor];
}

- (void)backTop
{
    
    _backTopBtn.hidden = YES;
    
    [self removeGoodDetail];
}

- (UIView*)listSurppotWay
{
    UIView* backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    // add by songjk
    NSArray* arrData = [NSArray arrayWithObjects:
                        GoodsDetailMod.beReach,
                        GoodsDetailMod.beSell,
                        GoodsDetailMod.beCash,
                        GoodsDetailMod.beTake,
                        //                         GoodsDetailMod.beTicket,
                        nil];
    if (!arrData.count > 0) {
        return nil;
    }
    //特殊服务
    CGFloat xw = 20; ///首行x轴坐标
    CGFloat Yh = 10; //首行Y轴坐标
    CGFloat jux = 10; //x方向的间距
    CGFloat juy = 15; //Y方向的间距
    CGFloat w = (kScreenWidth - (xw * 2) - (jux * 3)) * 0.25; ///整个bgview 的宽度
    CGFloat h = 20; ///bgview的高度
    for (int i = 0; i < arrData.count; i++) {
        ///先循环5个图片
        UIView* bgView = [[UIView alloc] init];
        bgView.backgroundColor = [UIColor clearColor];
        CGRect vframe = CGRectMake(xw + (w + jux) * (i % 4), Yh + (h + juy) * (i / 4), w + 10, h);
        bgView.frame = vframe;
        ///添加小图标
        BOOL imagebg = [[NSString stringWithFormat:@"%@", arrData[i]] isEqual:@"1"] ? YES : NO;
        UIImageView* imag = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, h - 2, h - 2)];
        if (imagebg) {
            imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhe_good_detail%d", i + 1]];
        }
        else {
            imag.image = [UIImage imageNamed:[NSString stringWithFormat:@"gyhe_image_good_detail_unselected_%d", i + 1]];
        }
        [bgView addSubview:imag];
        //添加label
        UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(h + 2, 0, bgView.bounds.size.width - h, h)];
        lab.textColor = kCellItemTextColor;
        lab.backgroundColor = [UIColor clearColor];
        lab.text = [arrTitle objectAtIndex:i];
        lab.font = [UIFont systemFontOfSize:11.0f];
        [bgView addSubview:lab];
        [backGroundView addSubview:bgView];
    }
    CALayer* topBorder = [CALayer layer];
    topBorder.backgroundColor = [[UIColor colorWithPatternImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]] CGColor];
    topBorder.frame = CGRectMake(backGroundView.frame.origin.x + 16, 0, CGRectGetWidth(backGroundView.frame) - 32, 1.0f);
    [backGroundView.layer addSublayer:topBorder];
    return backGroundView;
}

- (void)btnCheck
{
    DDLogDebug(@"查看全部分店");
}

- (UIImage*)scaleToSize:(UIImage*)img size:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)showGoodDetails
{
    self.bloadDetail = YES;
    tvShopDetail.tableFooterView = self.wvDetail;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.wvDetail.scrollView.contentInset = UIEdgeInsetsMake(50, 0, -50, 0);
        tvShopDetail.contentOffset = CGPointMake(0, CGRectGetMaxY(self.wvDetail.frame));
        
    }];
}

- (void)removeGoodDetail
{
    self.bloadDetail = NO;
    [UIView animateWithDuration:0.3 animations:^{
        UIView *vFoot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        
        UILabel *lbShowMore = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        lbShowMore.text = kLocalized(@"GYHE_SurroundVisit_ContinuePullDisplayGraphicDetails");
        lbShowMore.backgroundColor = [UIColor clearColor];
        lbShowMore.textAlignment = NSTextAlignmentCenter;
        lbShowMore.textColor = kCellItemTitleColor;
        lbShowMore.font = [UIFont systemFontOfSize:14];
        [vFoot addSubview:lbShowMore];
        tvShopDetail.tableFooterView = vFoot;
        
    }];
}



- (void)goToMap
{
    GYBMKViewController* mapVC = [[GYBMKViewController alloc] init];
    mapVC.strShopId = GoodsDetailMod.shopId;
    CLLocationCoordinate2D coordinateShop;
    coordinateShop.latitude = [GoodsDetailMod.lat floatValue];
    coordinateShop.longitude = [GoodsDetailMod.longitude floatValue];
    mapVC.coordinateLocation = coordinateShop;
    mapVC.title = kLocalized(@"GYHE_SurroundVisit_MapShows");
    [self.navigationController pushViewController:mapVC animated:YES];
}

- (void)reloadTableView
{
    // modify by songjk
    [UIView animateWithDuration:0.3 animations:^{
        rotationTransform = CGAffineTransformRotate(imgvArrow.transform, DEGREES_TO_RADIANS(180));
        imgvArrow.transform = rotationTransform;
    } completion:^(BOOL finished) {
        if (isShow) {
            rows = 1;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow = !isShow;
        } else {
            rows = 0;
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:3];
            [tvShopDetail reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            isShow = !isShow;
        }
    }];
}




#pragma mark 懒加载
- (UIWebView*)wvDetail
{
    if (_wvDetail == nil) {
        CGFloat wbHeight = kScreenHeight - CGRectGetMaxY(self.navigationController.navigationBar.frame) - self.vBottomView.frame.size.height;
        _wvDetail = [[UIWebView alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, wbHeight)];
        _wvDetail.scrollView.delegate = self;
        _wvDetail.backgroundColor = [UIColor whiteColor];
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:GoodsDetailMod.picDetails]];
        
        // add by songjk
        _wvDetail.scalesPageToFit = YES;
        _wvDetail.delegate = self;
        [_wvDetail loadRequest:request];
    }
    return _wvDetail;
}
- (NSMutableArray*)marrDiscount
{
    if (!_marrDiscount) {
        _marrDiscount = [NSMutableArray array];
    }
    return _marrDiscount;
}

- (UIView*)blackgroundView
{
    if (_blackgroundView == nil) {
        _blackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _blackgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        UIView* touchView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - vPopView.frame.size.height)];
        touchView1.backgroundColor = [UIColor blackColor];
        touchView1.alpha = 0.4;
        [_blackgroundView addSubview:touchView1];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideSKUView)];
        [touchView1 addGestureRecognizer:tap];
    }
    
    return _blackgroundView;
}
- (GYAroundGoodsEvaluateDetailController*)EvaluateVC
{
    if (!_EvaluateVC) {
        _EvaluateVC = [[GYAroundGoodsEvaluateDetailController alloc] init];
        _EvaluateVC.title = kLocalized(@"GYHE_SurroundVisit_EvaluateionCommnet");
        _EvaluateVC.strGoodId = _model.goodsId;
        [self.view addSubview:_EvaluateVC.view];
    }
    return _EvaluateVC;
}

- (NSMutableArray*)buildPayoffJson
{
    NSMutableArray* mArrShop = [[NSMutableArray alloc] init];
    NSMutableDictionary* mDicShop = [[NSMutableDictionary alloc] init];
    NSMutableArray* mArrGoodsList = [[NSMutableArray alloc] init];
    NSMutableDictionary* mDicGoodsList = [[NSMutableDictionary alloc] init];
    double subTotal = [detailmodel.strPrice doubleValue] * [detailmodel.goodsNum longLongValue];
    double subPoints = [detailmodel.strPv doubleValue] * [detailmodel.goodsNum longLongValue];
    //－－－－－－－－－－－－－－－－－－－－goodsList－－－－－－－－－－－－－－－－－－－－－－－－－－
    [mDicGoodsList setObject:detailmodel.categoryId forKey:@"categoryId"];
    
    [mDicGoodsList setObject:detailmodel.goodsID forKey:@"itemId"];
    
    [mDicGoodsList setObject:detailmodel.title forKey:@"itemName"];
    
    [mDicGoodsList setObject:detailmodel.strPv forKey:@"point"];
    
    [mDicGoodsList setObject:detailmodel.strPrice forKey:@"price"];
    
    [mDicGoodsList setObject:detailmodel.goodsNum forKey:@"quantity"];
    
    [mDicGoodsList setObject:detailmodel.strSkuId forKey:@"skuId"];
    
    [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f", subPoints]
                      forKey:@"subPoints"];
    
    [mDicGoodsList setObject:[NSString stringWithFormat:@"%.2f", subTotal]
                      forKey:@"subTotal"];
    
    [mDicGoodsList setObject:detailmodel.vShopId forKey:@"vShopId"];
    
    [mDicGoodsList setObject:detailmodel.goodsSkus forKey:@"skus"];
    
    // add by songjk 添加ruleid 抵扣券规则
    [mDicGoodsList setValue:detailmodel.strRuleID forKey:@"ruleId"];
    // add by songjk 是否选择申请互生卡
    [mDicGoodsList setValue:detailmodel.isApplyCard forKey:@"isApplyCard"];
    
    [mArrGoodsList addObject:mDicGoodsList];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f", subTotal]
                forKey:@"actuallyAmount"];
    
    [mDicShop setValue:@"2" forKey:@"channelType"];
    
    [mDicShop setValue:detailmodel.companyResourceNo forKey:@"companyResourceNo"];
    
    [mDicShop setValue:mArrGoodsList forKey:@"orderDetailList"];
    
    [mDicShop setValue:detailmodel.serviceResourceNo forKey:@"serviceResourceNo"];
    
    [mDicShop setValue:GoodsDetailMod.shopId forKey:@"shopId"];
    
    [mDicShop setValue:GoodsDetailMod.shopName forKey:@"shopName"];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f", subTotal] forKey:@"totalAmount"];
    
    [mDicShop setValue:[NSString stringWithFormat:@"%.2f", subPoints] forKey:@"totalPoints"];
    
    [mDicShop setValue:GoodsDetailMod.vShopId forKey:@"vShopId"];
    
    [mDicShop setValue:GoodsDetailMod.vShopName forKey:@"vShopName"];
    [mArrShop addObject:mDicShop];
    
    return mArrShop;
}

// add by songjk 显示抵扣券信息
- (UIView*)vDiscount
{
    if (!_vDiscount) {
        CGFloat border = 2;
        UIImageView* imgQuan = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 20)];
        imgQuan.image = [UIImage imageNamed:@"gyhe_good_detail5.png"];
        UILabel* lbDiscountTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imgQuan.frame) + border, 5, 100, 15)];
        lbDiscountTitle.font = kGYOtherDescriptionFont;
        lbDiscountTitle.backgroundColor = [UIColor clearColor];
        lbDiscountTitle.textColor = kDetailBlackColor;
        lbDiscountTitle.text = kLocalized(@"GYHE_SurroundVisit_SendTicketGood");
        
        CGFloat btnWidth = 40;
        CGFloat btnHeight = 40;
        CGFloat btnX = kScreenWidth - btnWidth - 16;
        UIButton* btnArow = [UIButton buttonWithType:UIButtonTypeCustom];
        btnArow.frame = CGRectMake(btnX, 0, btnWidth, btnHeight);
        btnArow.backgroundColor = [UIColor clearColor];
        btnArow.selected = YES;
        
        [btnArow addTarget:self action:@selector(showMore:) forControlEvents:UIControlEventTouchUpInside];
        UIView* vDiscount = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, btnHeight)];
        vDiscount.backgroundColor = [UIColor whiteColor];
        
        UIImageView* imgArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hs_cell_btn_menu3"]];
        CGFloat arrwoW = 20;
        CGFloat arrowH = 10;
        CGFloat arrowX = btnX + (btnWidth - arrwoW) * 0.5;
        CGFloat arrowY = btnArow.frame.origin.y + (btnHeight - arrowH) * 0.5;
        imgArrow.frame = CGRectMake(arrowX, arrowY, arrwoW, arrowH);
        self.imgArrow = imgArrow;
        self.imgArrow.transform = CGAffineTransformRotate(self.imgArrow.transform, DEGREES_TO_RADIANS(180)); // 当只有一个抵扣券系信息的时候默认展开
        
        imgQuan.center = CGPointMake(imgQuan.center.x, vDiscount.center.y);
        btnArow.center = CGPointMake(btnArow.center.x, vDiscount.center.y);
        lbDiscountTitle.center = CGPointMake(lbDiscountTitle.center.x, vDiscount.center.y);
        [vDiscount addSubview:imgQuan];
        [vDiscount addSubview:btnArow];
        [vDiscount addSubview:lbDiscountTitle];
        [vDiscount addSubview:imgArrow];
        
        UIImageView* imgvLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_line_confirm_dialog_yellow"]];
        imgvLine.frame = CGRectMake(16, 0, kScreenWidth - 16 * 2, 1);
        [vDiscount addSubview:imgvLine];
        
        _vDiscount = vDiscount;
    }
    return _vDiscount;
}

- (UIView*)discountList
{
    return self.vDiscount;
}

- (UIView*)goodDetail
{
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    v.backgroundColor = [UIColor whiteColor];
    UIButton* btnGoodIntroduction = [UIButton buttonWithType:UIButtonTypeCustom];
    btnGoodIntroduction.frame = CGRectMake(kCellDefaultMarginToBounds, 0, 304, 40);
    [btnGoodIntroduction setTitle:kLocalized(@"GYHE_SurroundVisit_GoodIntroduction") forState:UIControlStateNormal];
    btnGoodIntroduction.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnGoodIntroduction.titleLabel.font = kCellTitleFont;
    btnGoodIntroduction.backgroundColor = [UIColor clearColor];
    [btnGoodIntroduction setTitleColor:kDetailBlackColor forState:UIControlStateNormal];
    [btnGoodIntroduction addTarget:self action:@selector(reloadTableView) forControlEvents:UIControlEventTouchUpInside];
    imgvArrow.frame = CGRectMake(kScreenWidth - kCellDefaultMarginToBounds - 20, 15, 18, 10);
    imgvArrow.userInteractionEnabled = NO;
    imgvArrow.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    imgvArrow.contentMode = UIViewContentModeScaleAspectFit;
    imgvArrow.transform = rotationTransform;
    imgvArrow.image = [UIImage imageNamed:@"gyhe_down_arrow.png"];
    [v addSubview:imgvArrow];
    
    [v addSubview:btnGoodIntroduction];
    [v addTopBorder];
    return v;
}




@end
