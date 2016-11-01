//
//  GYHEVisitMainViewController.m
//
//  Created by lizp on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEVisitMainViewController.h"
#import "CalendarMonthCollectionViewLayout.h"
#import "GYHEVisitMainCell.h"
#import "GYHEVisitMainFooterView.h"
#import "GYHEVisitTakeOutControl.h"
#import "YYKit.h"
#import "GYHEUtil.h"
#import "GYLocationManager.h"
#import "GYHEGoodsDetailsViewController.h"
#import "GYFullScreenPopView.h"
#import "GYHETakeawayListViewController.h"
#import "GYDynamicMenuView.h"
#import "GYHEDynamicMenuViewController.h"
#import "GYIGWelfareController.h"
#import "GYHSBExplainController.h"
#import "GYHSCardExplainController.h"
#import "GYHEShoppingCartListViewController.h"
#import "GYHEVisitListViewController.h"
#import "GYHEVisitSurroundSearchVC.h"


@interface GYHEVisitMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GYHEVisitMainFooterViewDelegate, GYFullScreenPopDelegate, GYDynamicMenuViewDelegate>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* titleArr; // 标题数组  测试
@property (nonatomic, strong) NSArray* imageArr; //图片  测试
@property (nonatomic, strong) UILabel* cityLabel; //定位城市
@property (nonatomic, strong) NSArray* childsArrays; //城市地址

@end

@implementation GYHEVisitMainViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfb7d00);
}

- (void)dealloc
{
    NSLog(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate
#pragma mark UICollectionView Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{

    return 1;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{

    return 6;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{

    GYHEVisitMainCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYHEVisitMainCellIdentifier forIndexPath:indexPath];
    cell.typeImageView.image = [UIImage imageNamed:self.imageArr[indexPath.row]];
    cell.titlelabel.text = self.titleArr[indexPath.row];
    return cell;
}

- (UICollectionReusableView*)collectionView:(UICollectionView*)collectionView viewForSupplementaryElementOfKind:(NSString*)kind atIndexPath:(NSIndexPath*)indexPath
{

    UICollectionReusableView* reusableview = nil;

    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {

        GYHEVisitMainFooterView* footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kGYHEVisitMainFooterViewIdentifier forIndexPath:indexPath];
        footerView.delegate = self;
        NSArray* imageArr = @[ @"he_up_ads", @"he_down_ads", @"he_down_ads_2" ];
        footerView.imageArr = imageArr;

        reusableview = footerView;
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{

    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{

    return CGSizeMake(kScreenWidth, 244);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake(50, 84);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return (kScreenWidth - 50 * 3) / 4.0;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{

    switch (indexPath.row) {
    case 0: //附近
    {
        GYHEVisitListViewController* vc = [[GYHEVisitListViewController alloc] init];
        vc.childsQu = _childsArrays;
        [self.navigationController pushViewController:vc animated:YES];
    } break;

    case 1: //餐饮
    {
        GYHEVisitListViewController* vc = [[GYHEVisitListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } break;

    case 2: //生活服务
    {
        GYHEVisitListViewController* vc = [[GYHEVisitListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } break;

    case 3: //休闲娱乐
    {
        GYHEVisitListViewController* vc = [[GYHEVisitListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } break;

    case 4: //旅游酒店
    {
        GYHEVisitListViewController* vc = [[GYHEVisitListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } break;

    case 5: //房产
    {
        GYHEVisitListViewController* vc = [[GYHEVisitListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } break;

    default:
        break;
    }
}

#pragma mark - CustomDelegate
#pragma mark - GYHEVisitMainFooterViewDelegate
//外卖频道
- (void)takeOutClick
{

    DDLogInfo(@"外卖频道点击");
    GYHEGoodsDetailsViewController* vc = [[GYHEGoodsDetailsViewController alloc] init];

    [self.navigationController pushViewController:vc animated:YES];
}

//外卖频道 下面按钮选择
- (void)takeOutControl:(GYHEVisitTakeOutControl*)control
{

    if (control.type == TakeOutControlTypeSurround) { //周边
        GYHETakeawayListViewController* vc = [[GYHETakeawayListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (control.type == TakeOutControlTypeTakeOut) { //外卖（送货）
        GYHETakeawayListViewController* vc = [[GYHETakeawayListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (control.type == TakeOutControlTypeVisitService) { //上门服务
        GYHETakeawayListViewController* vc = [[GYHETakeawayListViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }

}

//选择图片 index为图片的下标 下标从0开始
- (void)selectImageIndex:(NSInteger)index
{

    DDLogInfo(@"选择第 %ld 张图片", index);
    if (index == 0) {
        GYIGWelfareController* vc = [[GYIGWelfareController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 1) {
        GYHSBExplainController* vc = [[GYHSBExplainController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (index == 2) {
        GYHSCardExplainController* vc = [[GYHSCardExplainController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - event response

#pragma mark - 导航条购物车点击
- (void)shopCardBtnClick
{
    kCheckLoginedToRoot

        DDLogInfo(@"购物车点击");
    GYHEShoppingCartListViewController* vc = [[GYHEShoppingCartListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 城市定位选择
- (void)cityLocation
{

    DDLogInfo(@"城市定位选择");
    //获取定位城市

    GYFullScreenPopView* view = [[GYFullScreenPopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.delegate = self;
    [view show];
}

#pragma mark-- GYFullScreenPopDelegate
-(void)fullcityName:(NSString *)cityName nsAray:(NSMutableArray *)array
{
    self.cityLabel.text = cityName;
    _childsArrays = array;
}

#pragma mark - private methods
- (void)initView
{
    //    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);

    [self settingNavigation];
    [self.view addSubview:self.collectionView];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(kScreenWidth - 40, (kScreenHeight - 64 - 49) / 2, 40, 40);
    [btn setImage:[UIImage imageNamed:@"gyhe_dynamic_menu"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(dynamicMenubtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark-- 动态菜单弹出视图
- (void)dynamicMenubtnClick:(UIButton*)btn
{
    GYDynamicMenuView* view = [[GYDynamicMenuView alloc] initWithBtn:btn];
    view.menuViewDelegate = self;
    [view show];
}
#pragma mark--GYDynamicMenuViewDelegate 动态菜单点击
- (void)imageIndex:(NSInteger)index
{
    kCheckLoginedToRoot
    GYHEDynamicMenuViewController* menuVC = [[GYHEDynamicMenuViewController alloc] init];
    menuVC.entranceType = GYEntranceVisitSurroundType;
    if (index == 0) {
        menuVC.dynamicMenuType = GYVisitRecordType; //光顾纪录
    }
    else if (index == 1) {
        menuVC.dynamicMenuType = GYFocuStoreType; //关注店铺
    }
    else if (index == 2) {
        menuVC.dynamicMenuType = GYCollectionGoodsType; //收藏商品
    }
    else {
        menuVC.dynamicMenuType = GYBrowseRecordsType; //浏览记录
    }
    [self.navigationController pushViewController:menuVC animated:YES];
}
//弹出手动切换城市
- (void)alterSelectCity
{

    [GYHEUtil showLocationServiceInfo:^{

    }];
}

- (void)setLocation
{

    WS(weakSelf)
        [[GYLocationManager sharedInstance] reverseAdress:^(NSString* cityName, NSString* address) {
       
        if(cityName) {
            weakSelf.cityLabel.text = cityName;
        }else {
            [weakSelf alterSelectCity];
        }
        }];
}

- (void)settingNavigation
{

    //定位城市
    UIControl* cityControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 70, 25)];
    cityControl.backgroundColor = [UIColor clearColor];
    [cityControl addTarget:self action:@selector(cityLocation) forControlEvents:UIControlEventTouchUpInside];

    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 59, 25)];
    self.cityLabel.font = [UIFont systemFontOfSize:14];
    self.cityLabel.textColor = UIColorFromRGB(0xffffff);
    self.cityLabel.textAlignment = NSTextAlignmentLeft;
    [cityControl addSubview:self.cityLabel];
    //箭头
    UIImageView* arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.cityLabel.right, 8, 11, 11)];
    arrowImageView.image = [UIImage imageNamed:@"gyhe_main_downArrow"];
    arrowImageView.backgroundColor = [UIColor clearColor];
    [cityControl addSubview:arrowImageView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cityControl];

    //搜索框
    UIView* titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth , 25)];
    titleView.backgroundColor = UIColorFromRGB(0xfc9733);
    titleView.layer.cornerRadius = 3;
    //搜索图片
    UIImageView* searchImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    searchImageView.backgroundColor = UIColorFromRGB(0xfc9733);
    searchImageView.image = [UIImage imageNamed:@"gyhe_food_search"];
    [titleView addSubview:searchImageView];

    UITextField* searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(searchImageView.right + 5, 0, titleView.width - searchImageView.right - 5, 25)];
    searchTextField.placeholder = kLocalized(@"GYHE_Main_Search");
    searchTextField.backgroundColor = [UIColor clearColor];
    searchTextField.font = [UIFont systemFontOfSize:12];
    [searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [titleView addSubview:searchTextField];
    self.navigationItem.titleView = titleView;
    //此处添加一个跳转
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSearchTheWord)];
    searchTextField.userInteractionEnabled = YES;
    [searchTextField addGestureRecognizer:tap];

    //购物车
    UIButton* shopCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCardBtn.frame = CGRectMake(0, 0, 24, 24);
    [shopCardBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_main_shopCar"] forState:UIControlStateNormal];
    [shopCardBtn addTarget:self action:@selector(shopCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnItem = [[UIBarButtonItem alloc] initWithCustomView:shopCardBtn];
    self.navigationItem.rightBarButtonItem = btnItem;

    [self setLocation];
}

- (void)doSearchTheWord
{
    GYHEVisitSurroundSearchVC* vc = [[GYHEVisitSurroundSearchVC alloc] init];
    vc.contentTabelType = kShopsType;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - getters and setters
- (UICollectionView*)collectionView
{

    if (!_collectionView) {

        UICollectionViewFlowLayout* layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(0, (kScreenWidth - 50 * 3) / 4.0, 15, (kScreenWidth - 50 * 3) / 4.0);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = kDefaultVCBackgroundColor;
        [_collectionView registerClass:[GYHEVisitMainCell class] forCellWithReuseIdentifier:kGYHEVisitMainCellIdentifier];
        [_collectionView registerClass:[GYHEVisitMainFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kGYHEVisitMainFooterViewIdentifier];
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSArray*)titleArr
{

    if (!_titleArr) {
        _titleArr = @[ kLocalized(@"GYHE_Main_Near"), kLocalized(@"GYHE_Main_Food"), kLocalized(@"GYHE_Main_Life_Service"), kLocalized(@"GYHE_Main_Have_Fun"), kLocalized(@"GYHE_Main_Tourist_Hotel"), kLocalized(@"GYHE_Main_House") ];
    }
    return _titleArr;
}

-(NSArray *)imageArr {

    if(!_imageArr) {
        _imageArr  = @[@"gyhe_main_near",@"gyhe_main_have_food",@"gyhe_main_life",@"gyhe_main_enjoy",@"gyhe_main_travel",@"gyhe_main_home"];
    }
    return _imageArr ;
}

@end
