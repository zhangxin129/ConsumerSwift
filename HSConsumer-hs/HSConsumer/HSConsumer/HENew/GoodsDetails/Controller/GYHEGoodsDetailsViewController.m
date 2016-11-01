//
//  GYHEGoodsDetailsViewController.m
//
//  Created by lizp on 16/9/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsDetailsViewController.h"
#import "GYHEGoodsDetailsHeaderView.h"
#import "GYHEGoodsDetailsCell.h"
#import "GYHEGoodsDetailsFooterView.h"
#import "GYHEGoodsDetailsSelectCell.h"
#import "MJRefresh.h"
#import "GYHEGoodsDetailsProductionView.h"
#import "YYKit.h"
#import "GYHEGoodsWebView.h"
#import "GYHERefreshProductionHeader.h"
#import "GYHEAddShoppingCarViewController.h"
#import "GYHEShoppingCartListViewController.h"
#import "GYSocialDataService.h"
#import "GYHEGoodsDetailsModel.h"

@interface GYHEGoodsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,GYHEGoodsImageTextDetailsViewDelegate,GYHEAddShoppingCarViewControllerDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIButton *joinShopCarBtn;//加入购物车
@property (nonatomic,strong) UIButton *contactBtn;//联系
@property (nonatomic,strong) UIView *navView;//导航条背景
@property (nonatomic,strong) UIButton *navArrowBtn;//导航条返回
@property (nonatomic,strong) UILabel *navLabel;//导航条标题
@property (nonatomic,strong) UIButton *navShopCarBtn;//导航条购物车
@property (nonatomic,copy) NSString *didSelectGoodsName;//已选商品的属性

@property (nonatomic,strong) GYHEGoodsDetailsModel *model;
@property (nonatomic,assign) CGSize size;

@property (nonatomic,copy) NSString *itemId;//测试数据
@property (nonatomic,copy) NSString *virtualShopId;//测试数据

@property (nonatomic,assign) BOOL isJoinShopCar;//是否加入购物车
@property (nonatomic,strong) GYHEGoodsDetailsProductionView *productionView;//产品参数
@property (nonatomic,strong) GYHEGoodsWebView *webView;//网页
@property (nonatomic,assign) BOOL isDown;//是否 暂开产品参数详情
@property (nonatomic,assign) CGFloat oldOffset;//滑动的偏移量
@property (nonatomic,assign) BOOL isDownScroll;//是否下滑
@property (nonatomic,assign) BOOL isUnder;//在下半部分
@property (nonatomic,strong) GYHEAddShoppingCarViewController *addShoppingCarVC;//加入购物车
@property (nonatomic,weak) UIButton *collectBtn;//收藏按钮

@end

@implementation GYHEGoodsDetailsViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    [self loadNetWorkForGoodDetail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);
    
    self.navigationController.navigationBar.hidden = YES;

}

-(void)viewWillDisappear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = NO;

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate   
#pragma mark - scrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGFloat alpha = (self.tableView.contentOffset.y+self.scrollView.contentOffset.y)/460;
    self.navView.alpha = alpha + 0.3;
}


#pragma mark - GYHEGoodsImageTextDetailsViewDelegate  查看产品参数
-(void)checkProductionDetail {
    
    self.isDown = !self.isDown;
    if(self.isDown) {
        [self.scrollView bringSubviewToFront:self.productionView];
        self.productionView.overlayView.hidden = NO;
        self.productionView.productButton.selected = YES;
        self.webView.userInteractionEnabled = NO;
    }else {
        [self productionViewBack];
    }
}

#pragma mark - 收起产品参数详情
-(void)productionBack {
    
    [self productionViewBack];
    self.isDown = NO;
}

#pragma mark TableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(self.isJoinShopCar) {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0 && indexPath.row == 0) {
        GYHEGoodsDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEGoodsDetailsCellIdentifier];
        if(!cell) {
            cell = [[GYHEGoodsDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEGoodsDetailsCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.shareControl addTarget:self action:@selector(shareControlClick) forControlEvents:UIControlEventTouchUpInside];
        [cell.collectControl addTarget:self action:@selector(collectControlClick:) forControlEvents:UIControlEventTouchUpInside];
        self.collectBtn = cell.collectBtn;
        [cell.enterShopControl addTarget:self action:@selector(enterShopControlClick) forControlEvents:UIControlEventTouchUpInside];
        cell.model = self.model;

        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        GYHEGoodsDetailsSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEGoodsDetailsSelectCellIdentifier];
        if(!cell) {
            
            cell = [[GYHEGoodsDetailsSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHEGoodsDetailsSelectCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentLabel.text = self.didSelectGoodsName;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.section == 0 && indexPath.row == 0) {
        return self.size.height + 136;
    }else if (indexPath.section == 1 && indexPath.row == 0) {
        return 32;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if(section == 1 && self.isJoinShopCar) {
        
        return 10;
    }
    return 0;
}

#pragma mark - CustomDelegate
#pragma mark - 加入购物车 GYHEAddShoppingCarViewControllerDelegate
-(void)didSelectGoodsName:(NSString *)name {

    self.didSelectGoodsName = name;
    self.isJoinShopCar  = YES;
    [self.tableView reloadData];
}
#pragma mark - event response
#pragma mark -- 查询商品详情
-(void)loadNetWorkForGoodDetail {
    NSDictionary *alldic = @{@"itemId":kSaftToNSString(@"3070956000134144"),//3069468720563200
//                             @"virtualShopId":kSaftToNSString(@"2817073842619392")
                             };
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kgetDetailByIdUrl parameters:alldic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            [GYUtils showToast:kLocalized(@"查询失败")];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }else {
            
            GYHEGoodsDetailsModel *model = [[GYHEGoodsDetailsModel alloc] initWithDictionary:responseObject[@"data"] error:nil];
            self.model = model;
            [self loadData];
            self.tableView.tableHeaderView = [self addHeaderView];
            self.tableView.tableFooterView = [self addFooterView];
            [self.tableView reloadData];

        }
        
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

#pragma mark - 收藏
-(void)loadNetWorkForCollect {

    
    NSDictionary *dict = @{
                           @"userId":globalData.loginModel.custId,
                           @"itemId":self.itemId,// @"2817073842619392",
                           @"virtualShopId":self.virtualShopId,// @"2817073842619392",
                           @"resourceNo":globalData.loginModel.resNo,
                           @"isCard":globalData.loginModel.cardHolder == YES ? @"c" :@"nc"
                           };
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kSaveFavoriteItem parameters:dict requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            [GYUtils showToast:kLocalized(@"GYHE_Good_Collect_Success")];
            self.collectBtn.selected = YES;
        }
        
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
    
}

#pragma mark - 取消收藏
-(void)loadNetWorkForDeleteCollect {

    NSDictionary *parameters = @{
                                 @"userId":globalData.loginModel.custId,
                                 @"itemId":@"3069293398000640",
                                 @"vShopId":@"2817073842619392",
                                 @"hasCard":globalData.loginModel.cardHolder == YES ?  @"c" :@"nc"
                                 };

    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kDeleteFavoriteItems parameters:parameters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            [GYUtils showToast:kLocalized(@"GYHE_Good_Cancel_Collect_Success")];
            self.collectBtn.selected = NO;
        }
    }];
    [request setValue:globalData.loginModel.token forHTTPHeaderField:@"token"];
    [request start];
}

#pragma mark - 分享
-(void)shareControlClick {

     DDLogInfo(@"分享");
    //测试数据
    NSString *shareContent = @"分享内容111";//分享内容
    NSString* sharegoods = @"分享商品详情222"; ////分享商品详情
    NSString* itemName = @"商品名称"; //商品名称
    NSString* shareitemUrl = @"www.baidu.com"; ////分享商品链接
    NSString* title = @"商品标题444"; //商品标题
    
    GYSocialDataModel* model = [[GYSocialDataModel alloc] init];
    //创建分享参数
    NSInteger maxlength = 140;
    shareContent = [NSString stringWithFormat:@"%@%@%@", itemName, shareitemUrl, sharegoods];
    if (shareContent.length > maxlength) {
        shareContent = [shareContent substringToIndex:maxlength];
    }
    model.content = shareContent;
    model.title = title;
    model.toUrl = shareitemUrl;
    
    YYWebImageManager* manager = [YYWebImageManager sharedManager];
    //GoodsDetailMod.shopUrl[0][@"url"]]
    [manager requestImageWithURL:[NSURL URLWithString:@"https://dc.aadv.net/ectfs/v1/tfs/T15aDTB5Yg1R4cSCrK.png"] options:kNilOptions progress:nil transform:nil completion:^(UIImage* _Nullable image, NSURL* _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError* _Nullable error) {
        if (!error) {
            model.image = image;
        }
        [GYSocialDataService postWithSocialDataModel:model  presentedController:self];
        
    }];
}

#pragma mark - 收藏
-(void)collectControlClick:(UIControl *)sender {

     DDLogInfo(@"收藏");
    if (self.collectBtn.selected) {
        //取消收藏接口
        [self loadNetWorkForDeleteCollect];
    }else {
        //收藏接口
        [self loadNetWorkForCollect];
    }
    
}

#pragma mark - 进入店铺
-(void)enterShopControlClick {

    DDLogInfo(@"进入店铺");
}

#pragma mark - 联系商家
-(void)contactBtnClick {

    DDLogInfo(@"联系商家");
}

#pragma mark - 加入购物车
-(void)joinShopCarBtnClick {

    DDLogInfo(@"加入购物车");
    
    //只有一直规格 直接接入购物车
//    if (self.model.skus) {
//        
//    }else {
        if (self.addShoppingCarVC == nil) {
            self.addShoppingCarVC = [[GYHEAddShoppingCarViewController alloc] init];
            self.addShoppingCarVC.delegate = self;
            self.addShoppingCarVC.model = self.model;
            self.addShoppingCarVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -49);
            self.addShoppingCarVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
            [self addChildViewController:self.addShoppingCarVC];
            
        }
        self.addShoppingCarVC.view.hidden = NO;
        [self.view addSubview:self.addShoppingCarVC.view];
//    }
    
}

#pragma mark - 加入购物车网络请求
-(void)loadNetWorkForAddItemsToCart {
    
    NSDictionary *dic = @{};
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kAddItemsToCartUrl parameters:dic requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];

    
}

#pragma mark - 导航条返回
-(void)arrowBtnClick {

    DDLogInfo(@"导航条返回");
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 导航条购物车
-(void)shopCarBtnClick {

    DDLogInfo(@"导航条购物车");
    GYHEShoppingCartListViewController *carListVC = [[GYHEShoppingCartListViewController alloc] init];
    [self.navigationController pushViewController:carListVC animated:YES];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setUp];
}

-(void)setUp {
    
    [self addScrollView];
}

//数据处理
-(void)loadData {
    
    //导航条店铺名称
    self.navLabel.text = self.model.vshopName;
    //产品参数处理
    self.productionView.model = self.model;
    //图文详情url
    self.webView.model = self.model;
    
    //商品名称图文处理
    NSString *str = [NSString stringWithFormat:@"%@ ",self.model.name];//留一个空格给图片
    //商品名称图文属性
    NSMutableAttributedString *nameStr = [[NSMutableAttributedString alloc] initWithString:str];
    [nameStr setFont:[UIFont systemFontOfSize:14] range:NSMakeRange(0, str.length)];
    [nameStr setColor:UIColorFromRGB(0x403000) range:NSMakeRange(0, str.length)];
    if (self.model.supportService.hasSerTakeout) {
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.image = [UIImage imageNamed:@"gy_he_mai_icon"];
        attach.bounds = CGRectMake(0, -3, 16, 16);
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attach];
        [nameStr appendAttributedString:string];
    }
    self.model.nameStr  = nameStr;
    
    CGRect rect = [nameStr boundingRectWithSize:CGSizeMake(kScreenWidth -24, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    self.size = rect.size;

}

-(void)addScrollView {
    
    [self.view addSubview:self.scrollView];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:self.tableView];
    
    //产品参数
     self.productionView = [[GYHEGoodsDetailsProductionView alloc] initWithFrame:CGRectMake(0, kScreenHeight -49, kScreenWidth, kScreenHeight -49)];
    self.productionView.delegate = self;
    [self.scrollView addSubview:self.productionView];
    
    //设置导航条
    [self settingNavigation];
    
    //加载网页
     self.webView= [[GYHEGoodsWebView alloc] initWithFrame:CGRectMake(0, kScreenHeight -49 +32, kScreenWidth, kScreenHeight -49 -32 -64)];
    [self.scrollView addSubview:self.webView];
    
    WS(weakSelf)
       GYHERefreshProductionHeader *header  = [GYHERefreshProductionHeader headerWithRefreshingBlock:^{
        [weakSelf.webView.tableView.mj_header endRefreshing];
        [weakSelf.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }];
    self.webView.tableView.mj_header = header;
    
    
    
    //加入购物车和联系商家的背景view
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 52, kScreenHeight -163, 42, 114)];
    backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:backgroundView];
    [self.view bringSubviewToFront:backgroundView];
    //联系商家
    self.contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.contactBtn.backgroundColor = [UIColor clearColor];
    self.contactBtn.frame = CGRectMake(0, 0, 42, 42);
    [self.contactBtn setImage:[UIImage imageNamed:@"gyhe_goods_contact"] forState:UIControlStateNormal];
    [backgroundView addSubview:self.contactBtn];
    [self.contactBtn addTarget:self action:@selector(contactBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //加入购物车
    self.joinShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.joinShopCarBtn.frame = CGRectMake(0, self.contactBtn.bottom + 15, 42, 42);
    self.joinShopCarBtn.backgroundColor = [UIColor clearColor];
    [self.joinShopCarBtn setImage:[UIImage imageNamed:@"gyhe_goods_join_shop_car"] forState:UIControlStateNormal];
    [backgroundView addSubview:self.joinShopCarBtn];
    [self.joinShopCarBtn addTarget:self action:@selector(joinShopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];

}


-(void)productionViewBack {

    self.productionView.overlayView.hidden = YES;
    [self.scrollView bringSubviewToFront:self.webView];
    self.webView.userInteractionEnabled = YES;
    self.productionView.productButton.selected = NO;
}

//设置导航条
-(void)settingNavigation {

    self.navigationController.navigationBar.hidden  = YES;
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    self.navView.backgroundColor = UIColorFromRGB(0xffffff);
    self.navView.alpha = 0.3;
    [self.view addSubview:self.navView];

    //箭头
    self.navArrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navArrowBtn.frame = CGRectMake(10, 30, 24, 24);
    self.navArrowBtn.backgroundColor = [UIColor clearColor];
    [self.navArrowBtn setImage:[UIImage imageNamed:@"gyhe_goods_left_arrow"] forState:UIControlStateNormal];
    [self.view addSubview:self.navArrowBtn];
    [self.navArrowBtn addTarget:self action:@selector(arrowBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //标题
    self.navLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.navArrowBtn.right + 3, 20, kScreenWidth - self.navArrowBtn.right - 3 -36, 44)];
    self.navLabel.font = [UIFont systemFontOfSize:17];
    self.navLabel.textColor = UIColorFromRGB(0x000000);
    self.navLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.navLabel];
    
    
    //购物车
    self.navShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.navShopCarBtn.frame = CGRectMake(kScreenWidth - 36, 30, 24, 24);
    self.navShopCarBtn.backgroundColor = [UIColor clearColor];
    [self.navShopCarBtn setImage:[UIImage imageNamed:@"gyhe_goods_shop_car"] forState:UIControlStateNormal];
    [self.view addSubview:self.navShopCarBtn];
    [self.navShopCarBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    

}

//头部
-(UIView *)addHeaderView {

    GYHEGoodsDetailsHeaderView *headerView = [[GYHEGoodsDetailsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,320 )];
    headerView.userInteractionEnabled = YES;
    
    NSMutableArray *picMarr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in self.model.pics) {
        [picMarr addObject:dic[@"sourceSize"]];
    }
    headerView.imageArr = picMarr;
    return headerView;
}

//尾部
-(UIView *)addFooterView {

    GYHEGoodsDetailsFooterView *footerView = [[GYHEGoodsDetailsFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 68)];
    return footerView;
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        [_tableView registerClass:[GYHEGoodsDetailsCell class] forCellReuseIdentifier:kGYHEGoodsDetailsCellIdentifier];
        [_tableView registerClass:[GYHEGoodsDetailsSelectCell class] forCellReuseIdentifier:kGYHEGoodsDetailsSelectCellIdentifier];
        _tableView.tableHeaderView = [self addHeaderView];
        _tableView.tableFooterView = [self addFooterView];

         WS(weakSelf)
         MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingBlock:^{
            self.isUnder = YES;
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.scrollView setContentOffset:CGPointMake(0, kScreenHeight -49 - 64) animated:YES];
        }];
        footer.stateLabel.hidden = YES;
        _tableView.mj_footer = footer;
        [self.scrollView addSubview:_tableView];
    }
    return _tableView;
}

-(UIScrollView *)scrollView {

    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,2*( kScreenHeight - 49))];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end
