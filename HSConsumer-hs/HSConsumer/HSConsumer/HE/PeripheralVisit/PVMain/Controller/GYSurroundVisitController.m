//
//  GYSurroundVisitController.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/17.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundVisitController.h"
#import "GYSurroundVisitShopController.h"
#import "GYSurroundGoodsViewController.h"
#import "GYEasybuySearchMainController.h"
#import "Masonry.h"
#import "GYAlertView.h"
#import "GYAroundLocationChooseController.h"
#import "GYLocationManager.h"
#import "GYHEUtil.h"

@interface GYSurroundVisitController () <UIScrollViewDelegate, GYAroundLocationChooseControllerDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UISegmentedControl* segmentedControl;
@property (nonatomic, strong) UILabel* leftBarLab;
@property (nonatomic, assign) BOOL isPageShow;

@end

@implementation GYSurroundVisitController

#pragma mark 生命周期
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    globalData.isOnNet = YES;
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.isPageShow = YES;

    // 没有手动选择城市，定位没有开启
    if ([GYUtils checkStringInvalid:globalData.selectedCityName] && ![[GYLocationManager sharedInstance] checkLocationStatus]) {
        [self alterSelectCity];
    }
    else {
        // 当城市为空时启动定位
        if ([GYUtils checkStringInvalid:globalData.selectedCityName]) {
            [[GYHSLoginManager shareInstance] getLocationInfo];
        }
        else {
            NSString* tempStrCity = globalData.selectedCityName;
            if ([tempStrCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
                tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length - 1)];
            }

            self.leftBarLab.text = tempStrCity;
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isPageShow = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupScrollView];
    [self setupNavBar];

    self.isPageShow = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setLocation) name:kGYHSLoginManagerCityAddressNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 获取市的代理方法 GYAroundLocationChooseControllerDelegate
- (void)getCity:(NSString*)CityTitle WithType:(int)type
{
    NSString* tempStrCity = CityTitle;
    if ([tempStrCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
        tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length - 1)];
    }

    _leftBarLab.text = tempStrCity;
}

#pragma mark 自定义方法
//弹出手动切换城市
- (void)alterSelectCity
{
    if (!self.isPageShow) {
        DDLogDebug(@"The page is not show, state:%d", self.isPageShow);
        return;
    }

    WS(weakSelf)
        [GYHEUtil showLocationServiceInfo:^{
        GYAroundLocationChooseController *vc = [[GYAroundLocationChooseController alloc] init];
        vc.isLocation = NO;
        vc.title = kLocalized(@"GYHE_SurroundVisit_SelectAddress");
        vc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
}
//获取定位城市
- (void)setLocation
{
    //定位失败
    if ([GYUtils checkStringInvalid:globalData.locationCity]) {
        [self alterSelectCity];
        return;
    }
    NSString* tempStrCity = kSaftToNSString(globalData.locationCity);

    if ([tempStrCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
        tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length - 1)];
    }

    self.leftBarLab.text = tempStrCity;
}

- (void)setupNavBar
{
    NSArray* items = @[ kLocalized(@"GYHE_SurroundVisit_LookOverShops"), kLocalized(@"GYHE_SurroundVisit_LookOverGoods") ];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    _segmentedControl.frame = CGRectMake(0, 0, kScreenWidth / 16.0 * 7.0, 24);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth / 2.0 - 20 - CGRectGetWidth(_segmentedControl.frame) / 2.0, 30)];
    view.backgroundColor = [UIColor clearColor];
    UILabel* lab = [[UILabel alloc] init];
    lab.font = [UIFont systemFontOfSize:18];
    lab.textColor = [UIColor whiteColor];
    //    lab.text = kLocalized(@"深圳");
    lab.textAlignment = NSTextAlignmentLeft;
    _leftBarLab = lab;
    [view addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.centerY.equalTo(view);
        make.right.lessThanOrEqualTo(view.mas_right).with.offset(-17);
    }];

    UIButton* btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, CGRectGetWidth(view.frame), 30);
    [btn addTarget:self action:@selector(leftBtnLocation) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];

    UIImageView* imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"gyhe_down_tab"];
    [view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(lab.mas_right).with.offset(8);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(10);
        make.centerY.equalTo(lab);
    }];

    UIBarButtonItem* leftBtn = [[UIBarButtonItem alloc] initWithCustomView:view];

    self.navigationItem.leftBarButtonItem = leftBtn;

    UIImageView* rightBtnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightBtnImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightBtnImageView.image = [UIImage imageNamed:@"gycommon_nav_search"];
    rightBtnImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightBtnClicked)];
    [rightBtnImageView addGestureRecognizer:tap];
    UIBarButtonItem* rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBtnImageView];

    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)leftBtnLocation
{

    //    if (!globalData.cityModels || !globalData.areaModels || !globalData.locationModels) {
    //        return;
    //    }
    GYAroundLocationChooseController* vcCitySelection = [[GYAroundLocationChooseController alloc] init];

    vcCitySelection.delegate = self;

    vcCitySelection.hidesBottomBarWhenPushed = YES;
    NSString* cityString = globalData.locationCity;
    if (!cityString) {
        cityString = kLocalized(@"GYHE_SurroundVisit_ShenZhen");
    }
    vcCitySelection.navigationItem.title = cityString;
    vcCitySelection.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcCitySelection animated:YES];
}

- (void)rightBtnClicked
{
    GYEasybuySearchMainController* vcSearch = [[GYEasybuySearchMainController alloc] init];
    vcSearch.searchType = kGoods;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:NO];
}

- (void)segmentedControlValueChanged:(UISegmentedControl*)sender
{
    NSInteger index = sender.selectedSegmentIndex;
    if (index == 0) {
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }
    else if (index == 1) {
        [_scrollView scrollRectToVisible:CGRectMake(kScreenWidth, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }
}

- (void)setupScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49)];
    _scrollView.contentSize = CGSizeMake(kScreenWidth * 2, kScreenHeight - 64 - 49);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;

    GYSurroundVisitShopController* shopVC = [[GYSurroundVisitShopController alloc] init];
    shopVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 49);
    [_scrollView addSubview:shopVC.view];
    [self addChildViewController:shopVC];

    GYSurroundGoodsViewController* goodVC = [[GYSurroundGoodsViewController alloc] init];
    goodVC.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight - 64 - 49);
    [_scrollView addSubview:goodVC.view];
    [self addChildViewController:goodVC];

    [self.view addSubview:_scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGPoint point = scrollView.contentOffset;
    CGFloat offsetX = point.x;
    NSInteger index = (offsetX + kScreenWidth * 0.5) / kScreenWidth;
    _segmentedControl.selectedSegmentIndex = index;
}

@end
