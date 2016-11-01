//
//  GYSettingViewController.m
//
//  Created by apple on 16/8/1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYSettingMainViewController.h"
#import "GYSettingMainCollectionViewCell.h"
#import "GYSettingFoodSetViewController.h"
#import "GYSettingPointRateSetViewController.h"
#import "GYSettingSafeSetMainVC.h"
#import "GYSettingSystemSetViewController.h"
#import "GYNetwork.h"
static NSString* idCell = @"settingMainCollectionViewCell";

@interface GYSettingMainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView* myCollectionView;
@property (nonatomic, strong) NSArray* titleNameArray;
@property (nonatomic, strong) NSArray* imageNameArray;
@end

@implementation GYSettingMainViewController

#pragma mark - lazy load
- (UICollectionView*)myCollectionView
{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout* flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) collectionViewLayout:flowLayOut];
        [_myCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYSettingMainCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:idCell];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _myCollectionView;
}

- (NSArray*)titleNameArray
{
    if (!_titleNameArray) {
        _titleNameArray = @[ kLocalized(@"GYSetting_Integration_Set"), kLocalized(@"GYSetting_Saft_Set"), kLocalized(@"GYSetting_System_Set") ];//@"云台连接", @"餐饮设置"
    }
    return _titleNameArray;
}

- (NSArray*)imageNameArray
{
    if (!_imageNameArray) {
        _imageNameArray = @[ @"gyset_icon_rate",  @"gyset_icon_soft", @"gyset_icon_system"  ];//@"gyset_icon_clouds"@"gyset_icon_food",
    }
    return _imageNameArray;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DDLogInfo(@"Show Controller: %@", [self class]);
}

- (void)dealloc
{
    DDLogInfo(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleNameArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYSettingMainCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:idCell forIndexPath:indexPath];
    cell.titleName = self.titleNameArray[indexPath.item];
    cell.image = [UIImage imageNamed:self.imageNameArray[indexPath.item]];
    @weakify(self);
    cell.imageViewBlock = ^{
        @strongify(self);
        [self touchCellIndexPath:indexPath];
    };
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake((kScreenWidth - kDeviceProportion(10 * 2)) / 3.0, kDeviceProportion(254.0f));
}
- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(kDeviceProportion(59), kDeviceProportion(10), 0, kDeviceProportion(10));
}
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

// #pragma mark - CustomDelegate
#pragma mark - event response
- (void)touchCellIndexPath:(NSIndexPath*)indexPath
{
    switch (indexPath.row) {
        case 0: {
            //积分比例
            GYSettingPointRateSetViewController* vc = [[GYSettingPointRateSetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
            
//        case 1: {
//            //餐饮设置
//            GYSettingFoodSetViewController* vc = [[GYSettingFoodSetViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        } break;
            
        case 1: {
            //安全设置
            GYSettingSafeSetMainVC* vc = [[GYSettingSafeSetMainVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
            
        case 2: {
            //系统设置
            GYSettingSystemSetViewController* vc = [[GYSettingSystemSetViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } break;
            
            
        default:
            break;
    }
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYSetting_Set");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    
    [self.view addSubview:self.myCollectionView];
}

#pragma mark - event

#pragma mark - request

@end
