//
//  GYBrowsingHistoryViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYBrowsingHistoryViewController.h"
#import "GYEasyBuyModel.h"
#import "EasyPurchaseData.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYEasybuyMainViewController.h"
#import "ViewTipBkgView.h"
#import "GYHEMyHEHistoryCell.h"

#define kGYHEMyHEHistoryCellId @"GYHEMyHEHistoryCell"

@interface GYBrowsingHistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) ViewTipBkgView* viewTipBkg;
@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* arrResult;

@end

@implementation GYBrowsingHistoryViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBGTip];
    [self initView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //只有返回首页才隐藏NavigationBarHidden
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound) { //返回
        if ([self.navigationController.topViewController isKindOfClass:[GYEasybuyMainViewController class]]) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)createBGTip
{
    _viewTipBkg = [GYUtils loadVcFromClassStringName:NSStringFromClass([ViewTipBkgView class])];
    [_viewTipBkg setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [_viewTipBkg.lbTip setText:kLocalized(@"GYHE_MyHE_YouHaveNoGoodsBrowsing")];
    [self.view addSubview:_viewTipBkg];
    _viewTipBkg.hidden = YES;
}

- (void)initView
{

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    //初始化设置tableView
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -16, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:tableView];

    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //注册cell以复用
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEMyHEHistoryCell class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kGYHEMyHEHistoryCellId];
    [self loadBrowsingHistory];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 78.f;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrResult.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEMyHEHistoryCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHEMyHEHistoryCellId];
    if (!cell) {
        cell = [[GYHEMyHEHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEMyHEHistoryCellId];
    }
    GYEasyBuyModel* eb = nil;
    if (self.arrResult.count > indexPath.row) {
        eb = self.arrResult[indexPath.row];
    }
    cell.titleLabel.text = eb.strGoodName;
    cell.priceLabel.text = [GYUtils formatCurrencyStyle:[eb.strGoodPrice doubleValue]];
    [cell.picImageView setImageWithURL:[NSURL URLWithString:eb.strGoodPictureURL] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) { //删除
        
        [GYUtils showMessge:kLocalized(@"GYHE_MyHE_WetherDelete") confirm:^{
            if (self.arrResult.count > indexPath.row) {
                [self deleteBrowsingHistory:self.arrResult[indexPath.row]];
                [self.arrResult removeObjectAtIndex:indexPath.row];
            }
            if (self.arrResult.count == 0) {
                [self loadBrowsingHistory];
            } else {
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        } cancleBlock:^{
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }];
    }
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kLocalized(@"GYHE_MyHE_Delete");
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYEasybuyGoodsInfoViewController* vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYEasybuyGoodsInfoViewController class]));
    GYEasyBuyModel* model = nil;
    if (self.arrResult.count > 0) {
        model = self.arrResult[indexPath.row];
    }
    vcGoodDetail.itemId = model.strGoodId;
    vcGoodDetail.vShopId = model.shopInfo.strShopId;
    [self.navigationController pushViewController:vcGoodDetail animated:YES];
}

- (void)loadBrowsingHistory
{
    NSString* key = kKeyForBrowsingHistory;
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSDictionary* dicBrowsing = [userDefault objectForKey:key];
    if (!dicBrowsing) {
        _viewTipBkg.hidden = NO;
        [self.tableView setHidden:YES];
        return;
    }
    self.arrResult = [[NSMutableArray alloc] init];
    for (NSString* key in [dicBrowsing allKeys]) {
        NSDictionary* dic = dicBrowsing[key];
        GYEasyBuyModel* model = [[GYEasyBuyModel alloc] init];
        model.strGoodPictureURL = dic[@"goodsPictureUrl"];
        model.strGoodName = dic[@"goodsName"];
        model.strGoodPrice = dic[@"goodsPrice"];
        model.strGoodId = dic[@"goodsId"];
        model.strGoodPictureURL = dic[@"goodsPictureUrl"];
        model.numBroweTime = dic[@"numBroweTime"];
        ShopModel* shopModel = [[ShopModel alloc] init];
        shopModel.strShopId = dic[@"shopId"];
        model.shopInfo = shopModel;
        [self.arrResult addObject:model];
    }
    if ([self.arrResult isKindOfClass:[NSNull class]]) {
        self.arrResult = nil;
    }
    self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
    _viewTipBkg.hidden = !self.tableView.hidden;
    NSArray* sortedArray = [self.arrResult sortedArrayUsingComparator:^NSComparisonResult(GYEasyBuyModel* p1, GYEasyBuyModel* p2) { //倒序
        return [p2.numBroweTime compare:p1.numBroweTime];
    }];
    self.arrResult = [sortedArray mutableCopy];
    [self.tableView reloadData];
}

- (void)deleteBrowsingHistory:(GYEasyBuyModel*)model
{
    NSString* key = kKeyForBrowsingHistory;
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary* dicBrowsing = [NSMutableDictionary dictionaryWithDictionary:[userDefault objectForKey:key]];
    [dicBrowsing removeObjectForKey:model.strGoodId];
    //保存
    [userDefault setObject:dicBrowsing forKey:key];
    [userDefault synchronize];
}

@end
