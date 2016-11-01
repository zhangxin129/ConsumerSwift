//
//  GYEPMyHEViewController.m
//  company
//
//  Created by apple on 14-12-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kKeyPowerName @"keyName"
#define kKeyPowerIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYEPMyHEViewController.h"
#import "CellTypeImagelabel.h"
#import "EasyPurchaseData.h"
#import "GYEasybuyMainViewController.h"
#import "GYEPSaleAfterViewController.h" //售后
#import "GYEPMyAllOrdersViewController.h" //全部订单
#import "GYGetGoodViewController.h" //收货地址
#import "GYEasybuyEvaluationViewController.h"
#import "UIButton+YYWebImage.h"
#import "GYBrowsingHistoryViewController.h"
#import "GYConcernsCollectViewController.h"
#import "GYMyHsHeader.h"
#import "UIButton+GYExtension.h"
#import "GYGIFHUD.h"
#import "GYRestaurantOrderViewController.h"
//#import "GYNoneOrderViewController.h"
#import "GYAddAddressSroViewController.h"
#import "GYEPMyOrderViewController.h"
#import "GYHDUserInfoViewController.h"
#import "GYMainEvaluationGoodsViewController.h"
#import "UIButton+YYWebImage.h"

@interface GYEPMyHEViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray* arrPowers; //功能列表数组
@property (nonatomic, strong) GYMyHsHeader* userInfoHeader;
@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic, assign) BOOL isFirst;

@end

@implementation GYEPMyHEViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createTableView];
    [self createHeaderView];
    [self createDataArray];
}

- (void)createTableView
{
    self.isFirst = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 170, kScreenWidth, kScreenHeight - 170) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"CellTypeImagelabel" bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellTypeImagelabelIdentifier];
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)createHeaderView
{
    _userInfoHeader = [[[NSBundle mainBundle] loadNibNamed:@"GYMyHsHeader" owner:self options:nil] firstObject];
    CGRect frame = _userInfoHeader.frame;
    frame.size.width = kScreenWidth;
    _userInfoHeader.frame = frame;
    [_userInfoHeader.btnBackToRoot addTarget:self action:@selector(btnBackToRootClick) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPersonSet)];
    _userInfoHeader.headerImgView.userInteractionEnabled = YES;
    [_userInfoHeader.headerImgView addGestureRecognizer:tap];
    [self.view addSubview:_userInfoHeader];
}

- (void)createDataArray
{
    NSArray* arr1 = @[ @"" ]; //占位
    arr1 = @[ @{ kKeyPowerIcon : @"gyhe_food_purchase_order",
        kKeyPowerName : kLocalized(@"GYHE_MyHE_PurchaseOrders"),
        kKeyNextVcName : NSStringFromClass([GYEPMyAllOrdersViewController class]) //购物订单
    },
        @{ kKeyPowerIcon : @"gyhe_food_restaurant_orders",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_RestaurantOrders"),
            kKeyNextVcName : NSStringFromClass([GYRestaurantOrderViewController class]) //餐厅订单
        },
        @{ kKeyPowerIcon : @"gyhe_food_delivery_orders",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_DeliveryOrders"),
            kKeyNextVcName : NSStringFromClass([GYRestaurantOrderViewController class]) //外卖订单
        },
    ];
    NSArray* arr5 = @[
        @{ kKeyPowerIcon : @"gyhe_myhe_my_evaluate",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_MyEvaluate"),
            kKeyNextVcName : NSStringFromClass([GYMainEvaluationGoodsViewController class]) //待评价
        },
        @{ kKeyPowerIcon : @"gyhe_myhe_my_after_sales_service",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_AfterSales"),
            kKeyNextVcName : NSStringFromClass([GYEPSaleAfterViewController class]) //售后服务
        },
        @{ kKeyPowerIcon : @"gyhe_cell_food_address",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_AddressManager"),
            kKeyNextVcName : NSStringFromClass([GYGetGoodViewController class]) //送餐地址
        },
    ];
    NSArray* arr6 = @[
        @{ kKeyPowerIcon : @"gyhe_myhe_browsing_history",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_BrowsingHistory"),
            kKeyNextVcName : NSStringFromClass([GYBrowsingHistoryViewController class]) //浏览历史
        },
        @{ kKeyPowerIcon : @"gyhe_myhe_concerns_collect",
            kKeyPowerName : kLocalized(@"GYHE_MyHE_MyConcerns"),
            kKeyNextVcName : NSStringFromClass([GYConcernsCollectViewController class]) //我的关注
        }
    ];
    _arrPowers = @[ arr1, arr5, arr6 ];
}

- (void)btnBackToRootClick
{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2] animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    if (self.isFirst) {
        self.isFirst = NO;
    }
    else {
        [_userInfoHeader removeFromSuperview];
        [self createHeaderView];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return _arrPowers.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section

{
    return [_arrPowers[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CellTypeImagelabel* cell = [tableView dequeueReusableCellWithIdentifier:kCellTypeImagelabelIdentifier];
    cell.ivCellImage.image = [UIImage imageNamed:[_arrPowers[indexPath.section][indexPath.row] valueForKey:kKeyPowerIcon]];
    cell.lbCellLabel.text = [_arrPowers[indexPath.section][indexPath.row] valueForKey:kKeyPowerName];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75.0f;
    //    return kCellHeight;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section >= 1) {
        UIViewController* vc = kLoadVcFromClassStringName([_arrPowers[section][row] valueForKey:kKeyNextVcName]);
        vc.navigationItem.title = [_arrPowers[section][row] valueForKey:kKeyPowerName];
        [self pushVC:vc animated:YES];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GYEPMyAllOrdersViewController* vc = [[GYEPMyAllOrdersViewController alloc] init];
            vc.navigationItem.title = [_arrPowers[section][row] valueForKey:kKeyPowerName];
            [self pushVC:vc animated:YES];
        }
        else if (indexPath.row == 1) {
            GYRestaurantOrderViewController* order = [[GYRestaurantOrderViewController alloc] init];
            order.strTyp = @"1";
            [self pushVC:order animated:YES];
        }
        else if (indexPath.row == 2) {
            GYRestaurantOrderViewController* order = [[GYRestaurantOrderViewController alloc] init];
            order.strTyp = @"2";
            [self pushVC:order animated:YES];
        }
    }
}

//弹出新窗口
- (void)pushVC:(id)sender animated:(BOOL)ani
{
    if (!sender)
        return;
    if ([sender isKindOfClass:[GYGetGoodViewController class]]) {
        GYGetGoodViewController* vc = (GYGetGoodViewController*)sender;
        vc.isFood = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else {
        [self.navigationController pushViewController:sender animated:ani];
    }
}

- (void)toPersonSet
{
    GYHDUserInfoViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYHDUserInfoViewController class]));
    vc.custID = globalData.loginModel.custId;
    [self pushVC:vc animated:YES];
}

@end
