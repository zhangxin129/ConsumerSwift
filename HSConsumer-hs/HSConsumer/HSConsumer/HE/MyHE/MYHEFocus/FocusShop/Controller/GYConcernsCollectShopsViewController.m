//
//  GYConcernsCollectShopsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYConcernsCollectShopsViewController.h"
#import "GYEasyBuyModel.h"
#import "GYShopDescribeController.h"
#import "GYHSLoginManager.h"
#import "GYGIFHUD.h"
#import "GYHSLoginViewController.h"
#import "GYHEShopCell.h"
#import "GYHEFocusShopModel.h"

#define kEachPageSizeStr 10

@interface GYConcernsCollectShopsViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, strong) UIView* viewTipBkg;
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, retain) UIImageView* iconImage;
@property (nonatomic, assign)BOOL isFirst;
@property (nonatomic,assign) NSInteger number;

@property (nonatomic, assign) int currentPageIndexStr;
@property (nonatomic, assign) int eachPageSizeStr;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) BOOL isUpFresh;

@end

@implementation GYConcernsCollectShopsViewController

-(NSMutableArray *)arrResult
{
    if (!_arrResult) {
        _arrResult = [NSMutableArray array];
    }
    return _arrResult;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (self.isFirst) {
        self.isFirst = NO;
    }else{
        [self getGoodsAndShopsNumberFavourite];
        [self headerRereshing];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBGTip];
    [self initView];
    [self getGoodsAndShopsNumberFavourite];
    [self getConcernsCollectShopListIsAppendResult:NO andShowHUD:YES];
    [self creatHeaderRefresh];
    [self footReresh];
}

- (void)createBGTip
{
    self.isFirst = YES;
    _currentPageIndexStr = 1;
    _viewTipBkg = [[UIView alloc]init];
    _viewTipBkg.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.5 - 29, 110, 58, 67)];
    self.iconImage.image = [UIImage imageNamed:@"img_no_result"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, kScreenWidth - 40, 67)];
    titleLabel.text = [NSString stringWithFormat:@"%@",kLocalized(@"GYHE_MyHE_YouHaveNoAttentionRecord")];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.numberOfLines = 2;
    [_viewTipBkg addSubview:titleLabel];
    [_viewTipBkg addSubview:self.iconImage];
    [self.view addSubview:_viewTipBkg];
    _viewTipBkg.hidden = YES;
}

- (void)initView
{
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 84) style:UITableViewStylePlain];
    tableView.backgroundColor = kDefaultVCBackgroundColor;
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopCell class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellShopCellIdentifier];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    CGRect hfFrame = self.tableView.bounds;
    hfFrame.size.height = kDefaultMarginToBounds;
    UIView* vHeader = [[UIView alloc] initWithFrame:hfFrame];
    [vHeader setBackgroundColor:self.view.backgroundColor];
    self.tableView.tableHeaderView = vHeader;
    hfFrame.size.height = 30;
    UIView* vFooter = [[UIView alloc] initWithFrame:hfFrame];
    [vFooter setBackgroundColor:kDefaultVCBackgroundColor];
    self.tableView.tableFooterView = vFooter;
}

-(void)getGoodsAndShopsNumberFavourite
{
    NSDictionary* allParas = @{ @"key" : globalData.loginModel.token };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetMyConcernNumberUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1302;
    [request start];
    
}

- (void)creatHeaderRefresh
{
    __weak __typeof(self) wself = self;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYConcernsCollectShopsViewController *sself = wself;
        [sself headerRereshing];
    }];
    self.tableView.mj_header = header;
}

- (void)footReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYConcernsCollectShopsViewController *sself = wself;
        [sself footerRereshing];
    }];
    self.tableView.mj_footer = footer;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    GYHEShopCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellShopCellIdentifier];
    if (!cell) {
        cell = [[GYHEShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellShopCellIdentifier];
    }
    ShopModel* shop = self.arrResult[row];
    cell.lbShopName.text = shop.strTitle;
    cell.lbShopScope.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_BusinessScope"), shop.strScope];
    cell.lbShopConcernTime.text = [NSString stringWithFormat:@"%@：%@", kLocalized(@"GYHE_MyHE_AboutTime"), shop.strConcernTime];
    NSString* imgUrl = shop.strShopPictureURL;
    [cell.ivShopImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80.f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ShopModel* shop = nil;
    if (self.arrResult.count > indexPath.row) {
        shop = self.arrResult[indexPath.row];
    }
    GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
    ShopModel* model = [[ShopModel alloc] init];
    model.strVshopId = shop.strShopId;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self pushVC:vc animated:YES];
}

//可编辑
- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath
{
    return YES;
}

//删除
- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self concernShopRequest:indexPath];
        //数据请求成功后，再删除tableView的数据
    }
}

#pragma mark - 删除服务器上的收藏数据
- (void)concernShopRequest:(NSIndexPath*)indexPath
{
    kCheckLogined
        NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    ShopModel* model = nil;
    if (self.arrResult.count > indexPath.row) {
        model = self.arrResult[indexPath.row];
    }
    [dict setValue:[NSString stringWithFormat:@"%@", model.strShopId] forKey:@"vShopId"];
    [dict setValue:model.strShopId forKey:@"shopId"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:CancelConcernShopUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1301;
    [request start];
}

- (NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kLocalized(@"GYHE_MyHE_Cancel");
}

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav) {
        [self.nav pushViewController:vc animated:ani];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _isUpFresh = YES;
    _currentPageIndexStr = 1;
    [self getConcernsCollectShopListIsAppendResult:NO andShowHUD:NO];
}

- (void)footerRereshing
{
    _isUpFresh = NO;
    if (_currentPageIndexStr <= _totalPage) {
        _currentPageIndexStr += 1;
    [self getConcernsCollectShopListIsAppendResult:NO andShowHUD:NO];
    }
}

- (void)getConcernsCollectShopListIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:globalData.loginModel.token forKey:@"key"];
    [allParas setValue:[NSString stringWithFormat:@"%d", kEachPageSizeStr] forKey:@"eachPageSizeStr"];
    [allParas setValue:[NSString stringWithFormat:@"%d", _currentPageIndexStr] forKey:@"currentPageIndexStr"];
    if (isShow) {
        [GYGIFHUD show];
    }
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetMyConcernShopUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1300;
    [request start];
}
#pragma mark - _concernGoodsRequest Delegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if (request.tag == 1300) {
        [GYGIFHUD dismiss];
        [self requestConcernShops:responseObject];
    }
    if (request.tag == 1301) {
        [GYGIFHUD dismiss];
        [self requestDelegateShops:responseObject];
    }
    if (request.tag == 1302) {
        [self requestCountShopAndShop:responseObject];
    }
}

- (void)requestConcernShops:(NSDictionary*)responseObject
{
    NSDictionary* dic = responseObject;
    NSArray* arrItems = dic[@"data"];
    _totalPage = [responseObject[@"totalPage"] intValue];
    ShopModel* model = nil;
    if (_isUpFresh) {
        [self.arrResult removeAllObjects];
    }
    for (NSDictionary* dicItem in arrItems) {
        model = [[ShopModel alloc] init];
        model.strShopName = kSaftToNSString(dicItem[@"shopName"]);
        model.strShopId = kSaftToNSString(dicItem[@"id"]);
        model.strShopPictureURL = kSaftToNSString(dicItem[@"url"]);
        model.strScope = kSaftToNSString(dicItem[@"scope"]);
        model.strConcernTime = kSaftToNSString(dicItem[@"createTime"]);
        model.strTitle = kSaftToNSString(dicItem[@"title"]);
        [self.arrResult addObject:model];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.arrResult isKindOfClass:[NSNull class]]) {
            self.arrResult = nil;
        }
        self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
        _viewTipBkg.hidden = !self.tableView.hidden;
        NSString *title = kLocalized(@"GYHE_MyHE_Shop");
        if (!self.tableView.hidden) {
            title = [NSString stringWithFormat:@"%@(%ld)", kLocalized(@"GYHE_MyHE_Shop"), _number];
        }
        if (self.btnMenu) {
            [self.btnMenu setTitle:title forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        if (_currentPageIndexStr <= _totalPage) {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData]; //必须要放在reload后面
        }
    });
}

- (void)requestDelegateShops:(NSDictionary*)responseObject
{
    if (self.arrResult.count > 0) {
        [self.arrResult removeAllObjects];
    }
    [self getGoodsAndShopsNumberFavourite];
    [GYUtils showToast:kLocalized(@"GYHE_MyHE_CancelFocusShopSuccess")];
    [self headerRereshing];
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)requestCountShopAndShop:(NSDictionary*)responseObject
{
    _number = kSaftToNSInteger(responseObject[@"data"][@"favoriteShopCount"]);
}

@end
