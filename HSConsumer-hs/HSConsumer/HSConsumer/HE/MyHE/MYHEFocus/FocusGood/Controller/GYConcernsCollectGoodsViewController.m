//
//  GYConcernsCollectGoodsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import "GYConcernsCollectGoodsViewController.h"
#import "GYHEGoodsNameWithPriceCell.h"
#import "GYEasybuyGoodsInfoViewController.h"
#import "GYGIFHUD.h"
#import "GYHEFocusGoodModel.h"

#define kEachPageSizeStr 10

@interface GYConcernsCollectGoodsViewController () <UITableViewDataSource, UITableViewDelegate, GYNetRequestDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, retain) UIImageView* iconImage;
@property (nonatomic, strong) UIView* viewTipBkg;
@property (nonatomic,assign) NSInteger number;
@property (nonatomic, strong)NSMutableArray *array;

@property (nonatomic, assign) int currentPageIndexStr;
@property (nonatomic, assign) int eachPageSizeStr;
@property (nonatomic, assign) int totalPage;
@property (nonatomic, assign) BOOL isUpFresh;

@end

@implementation GYConcernsCollectGoodsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createBGTip];
    [self initView];
    [self getGoodsAndShopsNumberFavourite];
    [self getConcernsCollectGoodsListIsAppendResult:NO andShowHUD:YES];
    [self creatHeaderRefresh];
    [self footReresh];
}


-(NSMutableArray *)arrResult
{
    if (!_arrResult) {
        _arrResult = [NSMutableArray array];
    }
    return _arrResult;
}

-(NSMutableArray *)array
{
    if (!_array) {
        _array = [NSMutableArray array];
    }
    return _array;
}

- (void)createBGTip
{
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
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEGoodsNameWithPriceCell class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellGoodsNameAndPriceCellIdentifier];
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

- (void)creatHeaderRefresh
{
    __weak __typeof(self) wself = self;
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        __strong GYConcernsCollectGoodsViewController *sself = wself;
        [sself headerRereshing];
    }];
    //单例 调用刷新图片
    self.tableView.mj_header = header;
}

- (void)footReresh
{
    __weak __typeof(self) wself = self;
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        __strong GYConcernsCollectGoodsViewController *sself = wself;
        [sself footerRereshing];
    }];
    self.tableView.mj_footer = footer;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _isUpFresh = YES;
    _currentPageIndexStr = 1;
    [self getConcernsCollectGoodsListIsAppendResult:NO andShowHUD:NO];
}

- (void)footerRereshing
{
    _isUpFresh = NO;
    if (_currentPageIndexStr <= _totalPage) {
        _currentPageIndexStr += 1;
        [self getConcernsCollectGoodsListIsAppendResult:NO andShowHUD:YES];
    }
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrResult count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEGoodsNameWithPriceCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    if (!cell) {
        cell = [[GYHEGoodsNameWithPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellGoodsNameAndPriceCellIdentifier];
    }
    
    if (self.arrResult.count > indexPath.row) {
        cell.model = self.arrResult[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 80.f;
}

#pragma mark - tableviewDelegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYEasybuyGoodsInfoViewController* vcGoodDetail = kLoadVcFromClassStringName(NSStringFromClass([GYEasybuyGoodsInfoViewController class]));
    GYHEFocusGoodModel *model = nil;
    if (self.arrResult.count > indexPath.row) {
        model = self.arrResult[indexPath.row];
    }
    vcGoodDetail.itemId = model.id;
    vcGoodDetail.vShopId = model.vShopId;
    [self pushVC:vcGoodDetail animated:YES];
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
        [self requestToCancelCollect:indexPath];
        //数据请求成功后，再删除tableView的数据
    }
}

#pragma mark -  删除服务器上的收藏数据
- (void)requestToCancelCollect:(NSIndexPath*)indexPath
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    GYHEFocusGoodModel* model = nil;
    if (self.arrResult.count > indexPath.row) {
        model = self.arrResult[indexPath.row];
    }
    [dict setValue:model.id forKey:@"itemId"];
    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyCancelCollectionGoodsUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1201;
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

-(void)getGoodsAndShopsNumberFavourite
{
    NSDictionary* allParas = @{ @"key" : globalData.loginModel.token };
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetMyConcernNumberUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1202;
    [request start];
    
}
- (void)getConcernsCollectGoodsListIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{
    
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    [allParas setValue:globalData.loginModel.token forKey:@"key"];
       [allParas setValue:[NSString stringWithFormat:@"%d", kEachPageSizeStr] forKey:@"eachPageSizeStr"];
    [allParas setValue:[NSString stringWithFormat:@"%d", _currentPageIndexStr] forKey:@"currentPageIndexStr"];
 
    if (isShow) {
        [GYGIFHUD show];
    }
    GYNetRequest* request = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetMyConcernGoodsUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON];
    request.tag = 1200;
    [request start];
}

#pragma mark - _concernGoodsRequest Delegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    if (request.tag == 1200) {
        [GYGIFHUD dismiss];
        [self requestConcernGoods:responseObject];
    }
    if (request.tag == 1201) {
        [GYGIFHUD dismiss];
        [self requestDelegateGoods:responseObject];
    }
    if (request.tag == 1202) {
        [self requestCountShopAndShop:responseObject];
    }
}

- (void)requestConcernGoods:(NSDictionary*)responseObject
{
    _totalPage = [responseObject[@"totalPage"] intValue];
    if (_isUpFresh) {
        [self.arrResult removeAllObjects];
    }
    if (_currentPageIndexStr > 1) {
        
        self.array = [GYHEFocusGoodModel modelArrayWithResponseObject:responseObject error:nil].mutableCopy;
        [self.arrResult addObjectsFromArray:self.array];
        
    }else{
          self.arrResult = [GYHEFocusGoodModel modelArrayWithResponseObject:responseObject error:nil].mutableCopy;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.arrResult isKindOfClass:[NSNull class]]) {
            self.arrResult = nil;
        }
        self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
        _viewTipBkg.hidden = !self.tableView.hidden;
        NSString *title = kLocalized(@"GYHE_MyHE_Goods");
        if (!self.tableView.hidden) {
            title = [NSString stringWithFormat:@"%@(%ld)", kLocalized(@"GYHE_MyHE_Goods"),_number];
        }
        if (self.btnMenu) {
            [self.btnMenu setTitle:title forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        if (_currentPageIndexStr <= _totalPage) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        else {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    });
}

- (void)requestDelegateGoods:(NSDictionary*)responseObject
{
    if (self.arrResult.count > 0) {
        [self.arrResult removeAllObjects];
    }
    [self getGoodsAndShopsNumberFavourite];
    [GYUtils showToast:kLocalized(@"GYHE_MyHE_CancelAttentionSuccess")];
    [self headerRereshing];
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}

- (void)requestCountShopAndShop:(NSDictionary*)responseObject
{
    _number = kSaftToNSInteger(responseObject[@"data"][@"favoriteItemCount"]);
}

@end
