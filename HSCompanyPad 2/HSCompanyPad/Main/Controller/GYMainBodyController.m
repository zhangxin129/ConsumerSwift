//
//  GYMainBodyController.m
//  HSCompanyPad
//
//  Created by User on 16/7/26.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYMainBodyController.h"
#import "GYHSConsumePointMainVC.h"
#import "GYHSExchangeHSBMainVC.h"
#import "GYMainBtnCell.h"
#import "GYMainRightBtnCell.h"
#import "GYSettingMainViewController.h"


//临时添加 后面即删
#import "GYHECompanyAfterSalesDetailListVC.h"
#import "GYHSCompanyAccountVC.h"

#import "GYGIFHUD.h"
#import "GYHDMainViewController.h"
#import "GYHDMainViewController.h"
#import "GYHDNetWorkTool.h"
#import "GYHEGoodsManagerMainVC.h"
#import "GYHERetailOrdersMainVC.h"
#import "GYHETakeDishesViewController.h"
#import "GYHSConResManViewController.h"
#import "GYHSDownPayMainVC.h"
#import "GYHSHelpCenterViewController.h"
#import "GYHSMainViewController.h"
#import "GYHSStaffManagerViewController.h"
#import "GYHSStoreMainVC.h"
#import "GYLoginView.h"
#import "GYMainHeadController.h"

#import "AppDelegate.h"
#import "GYDBManager.h"
#import "GYMenuCell.h"
#import <GYKit/GYPhotoPickerService.h>
#import <GYKit/CALayer+Transition.h>
#import "GYLoginHttpTool.h"

#import "GYThemeManager.h"
#import "GYSetVC.h"
#import "GYHSmyhsHttpTool.h"
#import <MJExtension/MJExtension.h>
#define kbottomMargin 25
#define kscrolMargin 12

static NSString* GYMenuCellID = @"GYMenuCell";
typedef NS_ENUM(NSInteger, ktouchLocation) {
    ktouchLocationLeft,
    ktouchLocationRight,
    ktouchLocationMiddle

};

@interface GYMainBodyController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, GYLoginViewDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {

    GYMainHistoryModel* selectModel;
}

@property (nonatomic, strong) NSMutableArray* dataArray;
@property (nonatomic, strong) NSMutableArray* leftTitleArray;
@property (nonatomic, strong) NSArray* colorArray;
@property (nonatomic, strong) NSArray* rightTitleArray;
@property (nonatomic, strong) NSMutableArray* leftImagesArray;
@property (nonatomic, strong) NSArray* rightImagesArray;
@property (nonatomic, strong) NSMutableArray* leftVCArray; //左视图控制器数组
@property (nonatomic, strong) NSArray* rightVCArray; //右视图控制器数组
@property (nonatomic, strong) NSMutableArray* rightModelArray; //右视图模型数组
@property (nonatomic, strong) NSMutableArray* leftModelArray; //右视图模型数组
@property (nonatomic, strong) NSArray* historyArray; //历史数组
@property (nonatomic, weak) IBOutlet UICollectionView* leftCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView* rightCollectionView;
@property (nonatomic, strong) UIPageControl* pageControl;
@property (weak, nonatomic) IBOutlet UIScrollView* bodyScrollView;
@property (weak, nonatomic) IBOutlet UIView* leftBackView;
@property (weak, nonatomic) IBOutlet UIView* rightBackView;
@property (nonatomic, strong) UIView* maskView;
@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, strong) GYMainHeadController* headVC;
@property (nonatomic, strong) UITableView* menuTableView;
@property (nonatomic, strong) NSArray* rightColorArray;
#pragma mark - 长按手势相关
@property (nonatomic, strong) UIView* tempMoveCell; //截图View

@property (nonatomic, strong) NSIndexPath* originalIndexPath; //右视图长按对应的索引
@property (nonatomic, strong) NSIndexPath* endIndexPath; //左视图长按对应的索引
@property (nonatomic, weak) UIView *originalCell;

@end

@implementation GYMainBodyController

static NSString* GYMainBtnCellID = @"GYMainBtnCell";
static NSString* GYMainRightBtnCellID = @"GYMainRightBtnCell";

#pragma mark - liftcycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configUI];
    self.view.backgroundColor = kPurple00002B;
    [self addLongGestureWithRightCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageBtnPush) name:GYCommonMessageBtnClickNotification object:nil];
    //  DDLogInfo(@"color.array=%@",self.colorArray);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLeftMenu:) name:GYCommonHistoryBtnClickNotification object:nil];
    [kDefaultNotificationCenter addObserver:self selector:@selector(popRoot:) name:GYCommonPopRootNotification object:nil];
     //参与、停止积分活动、成员企业注销状态更新通知
    [kDefaultNotificationCenter addObserver:self selector:@selector(getCompanyStatu) name:GYPointAndMemberCancelStatusNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYCommonMessageBtnClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYCommonHistoryBtnClickNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYPointAndMemberCancelStatusNotification object:nil];

}
#pragma mark - lazy load

- (NSArray*)leftTitleArray
{
    if (!_leftTitleArray) {

        _leftTitleArray = [[NSMutableArray alloc] initWithArray:

                                                      @[
                                                         kLocalized(@"企业互生"),
                                                         kLocalized(@"消费积分"),
                                                         kLocalized(@"商城管理"),
                                                         kLocalized(@"应用商店"),
                                                         kLocalized(@"快速发布"),
                                                         kLocalized(@"商品售后"),
                                                         kLocalized(@"兑换互生币"),
                                                         kLocalized(@"商品管理"),
                                                         kLocalized(@"设置"),
                                                         kLocalized(@"账户管理"),
                                                         kLocalized(@"订单管理"),
                                                         kLocalized(@"会员管理"),
                                                         kLocalized(@"员工管理"),
                                                      ]];
    }
    return _leftTitleArray;
}

- (NSArray*)rightTitleArray
{
    if (!_rightTitleArray) {
        _rightTitleArray = @[ kLocalized(@"帮助中心"),
            kLocalized(@"点菜"),
            kLocalized(@"互商经营统计"),
            kLocalized(@"预付定金") ];
    }

    return _rightTitleArray;
}


- (NSArray*)leftImagesArray
{

    if (!_leftImagesArray) {

        _leftImagesArray = [[NSMutableArray alloc] initWithArray:@[ @"gymain_HSCompany",
            @"gymain_point",
            @"gymain_manage",
            @"gymain_store",
            @"gymain_publish",
            @"gymain_aftersale",
            @"gymain_exchangehsb",
            @"gymain_product_manage",
            @"gymain_set",
            @"gymain_account_manage",
            @"gymain_order_manage",
            @"gymain_customer_manage",
            @"gymain_employee_manage" ]];
    }
    return _leftImagesArray;
}

- (NSArray*)rightImagesArray
{

    if (!_rightImagesArray) {
        _rightImagesArray = @[ @"gymain_helpCenter", @"gymain_takeFoodOrder", @"gymain_hsSummary", @"gymain_hsbPayment" ];
    }
    return _rightImagesArray;
}

- (NSArray*)leftVCArray
{

    if (!_leftVCArray) {

        _leftVCArray = [[NSMutableArray alloc] initWithArray:@[ NSStringFromClass([GYHSMainViewController class]),
            NSStringFromClass([GYHSConsumePointMainVC class]), //消费积分
            NSStringFromClass([GYSetVC class]),
            NSStringFromClass([GYHSStoreMainVC class]), //互生应用商店
            NSStringFromClass([GYSetVC class]),
            NSStringFromClass([GYHECompanyAfterSalesDetailListVC class]), //商品售后
            NSStringFromClass([GYHSExchangeHSBMainVC class]), //兑换互生币
            NSStringFromClass([GYSetVC class]), //NSStringFromClass([GYHEGoodsManagerMainVC class]), //商品管理
            NSStringFromClass([GYSettingMainViewController class]), //设置
            NSStringFromClass([GYHSCompanyAccountVC class]), //，账户管理
            NSStringFromClass([GYSetVC class]), //NSStringFromClass([GYHERetailOrdersMainVC class]), //订单管理
            NSStringFromClass([GYHSConResManViewController class]),
            NSStringFromClass([GYHSStaffManagerViewController class]) ] //员工管理
        ];
    }

    return _leftVCArray;
}

- (NSArray*)rightVCArray
{

    if (!_rightVCArray) {

        _rightVCArray = @[
            NSStringFromClass([GYHSHelpCenterViewController class]), //帮助中心
            NSStringFromClass([GYSetVC class]), //NSStringFromClass([GYHETakeDishesViewController class]), //点菜
            NSStringFromClass([GYSetVC class]), // NSStringFromClass([GYHSDownPayMainVC class]), //互商经营统计
            NSStringFromClass([GYHSDownPayMainVC class]), //预付定金

        ];
    }

    return _rightVCArray;
}

- (NSMutableArray*)leftModelArray
{

    if (!_leftModelArray) {
        _leftModelArray = [NSMutableArray new];

        for (int i = 0; i < self.leftTitleArray.count; i++) {
            GYMainHistoryModel* model = [GYMainHistoryModel new];
            model.name = self.leftTitleArray[i];
            model.iconName = self.leftImagesArray[i];
            model.className = self.leftVCArray[i];
            model.colorHexString = self.colorArray[i];
            [_leftModelArray addObject:model];
        }
    }

    return _leftModelArray;
}

- (NSMutableArray*)rightModelArray
{

    if (!_rightModelArray) {
        _rightModelArray = [NSMutableArray new];

        for (int i = 0; i < self.rightTitleArray.count; i++) {
            GYMainHistoryModel* model = [GYMainHistoryModel new];
            model.name = self.rightTitleArray[i];
            model.iconName = self.rightImagesArray[i];
            model.className = self.rightVCArray[i];
            model.colorHexString = self.rightColorArray[i];
            [_rightModelArray addObject:model];
        }
    }

    return _rightModelArray;
}

- (NSArray*)colorArray
{

    if (!_colorArray) {
        if ([GYThemeManager isThemed]) {
            _colorArray = [GYThemeManager loadThemeColor];
            return _colorArray;
        }

        _colorArray = @[ @"#2D89EF",
            @"#653FBF",
            @"#0959C1",
            @"#F1BB00",
            @"#2D89EF",
            @"#F1BB00",
            @"#00A500",
            @"#2D89EF",
            @"#00A500",
            @"#0959C1",
            @"#2D89EF",
            @"#DB312D",
            @"#FF7F00" ];
    }

    return _colorArray;
}

- (NSArray*)rightColorArray
{
    if (!_rightColorArray) {
        if ([GYThemeManager isThemed]) {
            _colorArray = [GYThemeManager loadThemeColor];
            return _colorArray;
        }
        _rightColorArray = @[ @"#2D89EF",
            @"#653FBF",
            @"#0959C1",
            @"#00A500",
        ];
    }

    return _rightColorArray;
}

- (UITableView*)menuTableView
{

    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceProportion(210), kScreenHeight) style:UITableViewStylePlain];
        UIView* view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_menuTableView setTableFooterView:view];
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        [_menuTableView registerNib:[UINib nibWithNibName:NSStringFromClass(GYMenuCell.class) bundle:nil] forCellReuseIdentifier:GYMenuCellID];
    }

    return _menuTableView;
}

#pragma mark - method

- (void)configUI
{
    self.view.backgroundColor = kPurple00002B;

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(selectPage:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.pageControl];

    self.bodyScrollView.backgroundColor = [UIColor clearColor];
    self.bodyScrollView.pagingEnabled = YES;
    self.bodyScrollView.showsHorizontalScrollIndicator = NO;
    self.bodyScrollView.contentSize = CGSizeMake(kScreenWidth * 2, 0);
    [self.bodyScrollView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
    }];

    @weakify(self);
    [self.leftBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self.bodyScrollView).mas_equalTo(kscrolMargin);
        make.width.mas_equalTo(self.bodyScrollView.width - 2 *kscrolMargin);
        make.top.height.equalTo(self.bodyScrollView);
    }];
    
    [self.rightBackView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self.leftBackView.mas_right).offset(2 *kscrolMargin);
        make.width.mas_equalTo(self.bodyScrollView.width - 2 *kscrolMargin);
        make.top.height.equalTo(self.bodyScrollView);
    }];
    
    self.bodyScrollView.scrollEnabled = YES;
    self.bodyScrollView.delegate = self;
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-20);
    }];

    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];

    self.leftCollectionView.scrollEnabled = NO;
    self.rightCollectionView.scrollEnabled = NO;
    self.leftCollectionView.collectionViewLayout = layout;
    [self.leftCollectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.equalTo(self.leftBackView).mas_equalTo(0);
        make.bottom.mas_equalTo(-kbottomMargin);

    }];

    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.right.top.equalTo(self.rightBackView);
        make.bottom.mas_equalTo(-kbottomMargin);
    }];

    [self.leftCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass(GYMainBtnCell.class) bundle:nil] forCellWithReuseIdentifier:GYMainBtnCellID];
    self.leftCollectionView.delegate = self;
    self.leftCollectionView.dataSource = self;

    [self.rightCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass(GYMainBtnCell.class) bundle:nil] forCellWithReuseIdentifier:GYMainBtnCellID];

    self.rightCollectionView.collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    self.rightCollectionView.delegate = self;
    self.rightCollectionView.dataSource = self;
}

- (void)selectPage:(UIPageControl*)control
{
    if (control.currentPage == 0) {
        [self.bodyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [self.bodyScrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
    }
}



#pragma mark notification
- (void)messageBtnPush
{
    //消息按钮点击

    if (!globalData.isLogined) {
        GYLoginView* loginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYLoginView class]) owner:self options:nil][0];
        loginView.delegate = self;
        [loginView show];
        return ;
    }

    UIViewController* lastVC = [self.navigationController viewControllers].lastObject;

    if ([lastVC isKindOfClass:[GYMainBodyController class]]) {
        GYHDMainViewController* hdMainViewController = [[GYHDMainViewController alloc] init];
        [self.navigationController pushViewController:hdMainViewController animated:YES];
    }
}

#pragma mark - 获取企业资格状态
- (void)getCompanyStatu
{
    [GYHSmyhsHttpTool GetEntStatus:^(id responsObject) {
        globalData.companyStatus = [companyStatuModel mj_objectWithKeyValues:responsObject];
        
    } failure:nil];
}

//通知头部控制器刷新
- (void)postCheckLogin
{

    [[NSNotificationCenter defaultCenter] postNotificationName:GYCommonLoginSuccessNotification object:nil];
}

- (void)postCheckMessageUreadCount{

    [[NSNotificationCenter defaultCenter] postNotificationName:GYHDPushMessageChageNotification object:nil];

}
#pragma mark - NSNotification Menu
- (void)showLeftMenu:(NSNotification*)note
{
    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    UIViewController* rootVC = delegate.window.rootViewController;

    UIView* maskView = [[UIView alloc] initWithFrame:rootVC.view.bounds];

    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7f];

    [rootVC.view addSubview:maskView];

    [maskView addSubview:self.menuTableView];

    [self.menuTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(kDeviceProportion(210));
        make.height.equalTo(maskView.mas_height);
    }];

    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu:)];
    tap.delegate = self;
    [maskView addGestureRecognizer:tap];

    self.historyArray = [[GYDBManager sharedInstance] selectHistoryModels];

    [self.menuTableView reloadData];
}

#pragma mark - NSNotification popRoot

- (void)popRoot:(NSNotificationCenter*)note
{

    self.navigationController.navigationBarHidden = YES;

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dismissMenu:(UITapGestureRecognizer*)menuTap
{

    UIView* tapView = menuTap.view;

    [tapView removeFromSuperview];
}

- (void)pushModelVC:(GYMainHistoryModel*)model
{
    //传递事件
    if (model.className) {
        NSString* className = model.className;
        Class class = NSClassFromString(className);
        UIViewController* nextVC = [[class alloc] init];
        [self.navigationController pushViewController:nextVC animated:YES];
    }
    if (self.menuTableView.superview) {
        [self.menuTableView.superview removeFromSuperview];
    }
}

- (void)closeHistoryTable
{

    if (self.menuTableView.superview) {
        [self.menuTableView.superview removeFromSuperview];
    }
}

#pragma mark - DB method-根据索引保存消息模型到数据库
#pragma mark - DB Method-初始化浏览历史数据库
- (void)createHistoryDB
{
    [[GYDBManager sharedInstance] createHistoryTable];
}

- (void)saveLeftHistoryModelByIndex:(NSInteger)index Single:(BOOL)flag
{

    if (flag) {
        GYMainHistoryModel* model = self.leftModelArray[index];
        NSString* imageName = [NSString stringWithFormat:@"%@_small", model.iconName];
        model.iconName = imageName;
        model.time = [NSDate date];
        [[GYDBManager sharedInstance] saveHistoryModel:model];
    }
}
- (void)saveRightHistoryModelByIndex:(NSInteger)index
{

    NSString* iconName = self.rightImagesArray[index];
    NSString* name = self.rightTitleArray[index];
    NSString* className = self.rightVCArray[index];
    GYMainHistoryModel* model = [GYMainHistoryModel new];
    model.name = name;
    model.className = className;
    model.iconName = iconName;
    model.time = [NSDate date];
    [[GYDBManager sharedInstance] saveHistoryModel:model];
}

#pragma mark - collectionView delegate
//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:self.leftCollectionView]) {
        return 13;
    }
    return 4;
}


//每个UICollectionView展示的内容
- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{

    GYMainBtnCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYMainBtnCellID forIndexPath:indexPath];

    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(GYMainBtnCell.class) owner:self options:nil][0];
    }

    if ([collectionView isEqual:self.leftCollectionView]) {
        cell.model = self.leftModelArray[indexPath.row];
    }
    else {

        cell.model = self.rightModelArray[indexPath.row];
    }

    return cell;
}


- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if (!globalData.isLogined) {
        GYLoginView* loginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYLoginView class]) owner:self options:nil][0];
        ;
        loginView.delegate = self;
        [loginView show];
        return;
    }

    if ([collectionView isEqual:self.leftCollectionView]) {
        [self saveLeftHistoryModelByIndex:indexPath.row Single:YES];
    }
    else {

        [self saveRightHistoryModelByIndex:indexPath.row];
    }

    GYMainBtnCell* cell = (GYMainBtnCell*)[collectionView cellForItemAtIndexPath:indexPath];

    UIViewController* vc = [[NSClassFromString(cell.model.className) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
   
    return UIEdgeInsetsMake( 0, 0, 0, 0 );
}


- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{

    if ([collectionView isEqual:self.leftCollectionView]) {

        if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 11 || indexPath.row == 12) {
            return CGSizeMake((collectionView.frame.size.width - 44) / 6.0, (collectionView.frame.size.height - 16) / 3.0);
        }

        return CGSizeMake((collectionView.frame.size.width - 16) / 3.0, (collectionView.frame.size.height - 16) / 3.0);
    }

    else {
        return CGSizeMake((collectionView.frame.size.width - 24) / 4 , (collectionView.frame.size.height - 16) / 3.0);
    }
}


//列间距
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return 8;
}
//行间距
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 8;
}



- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeZero;
}



- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    return CGSizeZero;
}



#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.historyArray.count;
}



- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYMenuCell* cell = [tableView dequeueReusableCellWithIdentifier:GYMenuCellID];

    if (self.historyArray.count > 0) {
        GYMainHistoryModel* model = self.historyArray[indexPath.row];
        [cell loadModel:model];
    }
    return cell;
}



- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    CGFloat height = 60;

    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, height)];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 210 - height, height)];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.text = kLocalized(@"   最近操作");

    [headView addSubview:titleLabel];

    UIButton* dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [dismissBtn setFrame:CGRectMake(210 - height, 0, height, height)];
    [dismissBtn setImage:kLoadPng(@"btn_close") forState:UIControlStateNormal];

    [dismissBtn addTarget:self action:@selector(closeHistoryTable) forControlEvents:UIControlEventTouchUpInside];

    [headView addSubview:dismissBtn];

    return headView;
}


- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    return 75;
}


- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    return 60;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYMainHistoryModel* model = self.historyArray[indexPath.row];

    [self pushModelVC:model];
}


#pragma mark -UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{

    CGPoint point = scrollView.contentOffset;
    self.pageControl.currentPage = point.x + 100 / kScreenWidth;
}


#pragma mark - loginView Delegate
- (void)loginView:(GYLoginView*)loginView resNo:(NSString*)resNo userName:(NSString*)username password:(NSString*)password
{

    [GYLoginHttpTool loginWithResNo:resNo userName:username password:password success:^(id responsObject) {
        
        if (kHTTPSuccessResponse(responsObject)) {
            [loginView dismiss];
            globalData.isLogined = YES;
            [self createHistoryDB];
            [self postCheckLogin];
            
            // 登录成功后调用互信数据库查询未读
            [self postCheckMessageUreadCount];

        }
        
        //msg:登录验证失败，您今天还剩19次尝试机会
        else if ([responsObject[GYNetWorkCodeKey]isEqualToNumber:@160108]) {
            [loginView showWrongLabel];
        }

    } failure:^{

    }];
}

#pragma mark 

//加上长按手势
- (void)addLongGestureWithRightCollectionView
{
    
    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(rightLongPressed:)];
    longPress.minimumPressDuration = 0.5;
    longPress.delegate = self;
    [self.view addGestureRecognizer:longPress];
}


- (void)rightLongPressed:(UILongPressGestureRecognizer*)longPressGesture
{
    if (!globalData.isLogined) {
        return;
    }
    
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan: {
            
            CGPoint tapPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
            _originalIndexPath = [self.rightCollectionView indexPathForItemAtPoint:tapPoint];
            
            if (!_originalIndexPath) {
                return;
            }
            //拿到选中模型
            selectModel = self.rightModelArray[_originalIndexPath.row];
            GYMainRightBtnCell* cell = (GYMainRightBtnCell*)[self.rightCollectionView cellForItemAtIndexPath:_originalIndexPath];
            //截图
            _tempMoveCell = [cell snapshotViewAfterScreenUpdates:NO];
            //转换坐标系相对位置
            CGRect rect = [self.rightCollectionView convertRect:cell.frame toView:self.view];
            _tempMoveCell.frame = rect;
            [self.view addSubview:_tempMoveCell];
            [_tempMoveCell.layer bouceAnimation];
            [self shakeAllCell];
            self.originalCell = cell;
            //隐藏选中单元格cell
            cell.hidden = YES;
            
        } break;
        case UIGestureRecognizerStateChanged: {
            
            CGPoint tempPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
            [_tempMoveCell setCenter:tempPoint];
            if (tempPoint.x < 90) {
                //开始滑动
                if (self.bodyScrollView.contentOffset.x != 0) {
                    
                    [self.bodyScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                    
                    self.bodyScrollView.scrollEnabled = NO;
                }
            }
            
        } break;
        case UIGestureRecognizerStateEnded: {
            
           
            if (self.bodyScrollView.contentOffset.x > kScreenWidth - 100) {
                 [_tempMoveCell removeFromSuperview];
                self.originalCell.hidden = NO;
                self.bodyScrollView.scrollEnabled = YES;
                [self removeShakeAllCell];
                return;
            }
            CGPoint tapPoint = [longPressGesture locationOfTouch:0 inView:longPressGesture.view];
        
                _endIndexPath = [self.leftCollectionView indexPathForItemAtPoint:tapPoint];
         
            
            
            if (!_endIndexPath) {
                self.originalCell.hidden = NO;
                  self.bodyScrollView.scrollEnabled = YES;
              [_tempMoveCell removeFromSuperview];
                return;
            }
            GYMainBtnCell* selectCell = (GYMainBtnCell *)[self.leftCollectionView cellForItemAtIndexPath:_endIndexPath];
                if (selectModel) {
                    GYMainHistoryModel *tempModel = selectCell.model;
                    [self.leftModelArray replaceObjectAtIndex:_endIndexPath.row withObject:selectModel];
                    [self.rightModelArray replaceObjectAtIndex:_originalIndexPath.row withObject:tempModel];
        
                }
            
            [_tempMoveCell removeFromSuperview];
            [self.rightCollectionView reloadData];
            [self.leftCollectionView reloadData];
            self.originalCell.hidden = NO;
            self.bodyScrollView.scrollEnabled = YES;
              [self removeShakeAllCell];
            
        } break;
        default:
            break;
    }
}


#pragma mark - UIGestureRecognizer Delegate 拦截点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch
{
    
    //拦截表格点击方法
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    //左边不接收长按手势事件,浏览历史列表出现时例外
    if (self.bodyScrollView.contentOffset.x == 0) {
        //如果历史菜单出来，还是需要可以点击滴
        if (_menuTableView.superview) {
            return YES;
        }
        
        return NO;
    }
    DDLogInfo(@"当前长按视图:%@", NSStringFromClass([touch.view class]));
    
    return YES;
}

- (void)shakeAllCell
{
    
#define angelToRandian(x) ((x) / 180.0 * M_PI)
    
    CAKeyframeAnimation* anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"transform.rotation";
    anim.values = @[ @(angelToRandian(-4)), @(angelToRandian(4)), @(angelToRandian(-4)) ];
    anim.repeatCount = MAXFLOAT;
    anim.duration = 0.2;
    NSArray* cells = [self.rightCollectionView visibleCells];
    for (UICollectionViewCell* cell in cells) {
        /**如果加了shake动画就不用再加了*/
        if (![cell.layer animationForKey:@"shake"]) {
            [cell.layer addAnimation:anim forKey:@"shake"];
        }
    }
    if (![_tempMoveCell.layer animationForKey:@"shake"]) {
        [_tempMoveCell.layer addAnimation:anim forKey:@"shake"];
    }
}

- (void)removeShakeAllCell
{
    NSArray* cells = [self.rightCollectionView visibleCells];
    for (UICollectionViewCell* cell in cells) {
                   [cell.layer removeAllAnimations];
    }

}



@end
