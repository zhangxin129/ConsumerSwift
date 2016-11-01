//
//  GYHEGoodsManagerMainVC.m
//
//  Created by apple on 16/8/5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEGoodsManagerMainVC.h"
#import "GYHEGoodsmanagerMainCollectionViewCell.h"
#import "GYHEGoodsQueryViewController.h"

static NSString* idCell = @"goodsmanagerMainCollectionViewCell";

@interface GYHEGoodsManagerMainVC () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* titleNameArray;
@property (nonatomic, strong) NSArray* imageNameArray;

@end

@implementation GYHEGoodsManagerMainVC

#pragma mark - lazy load
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayOut = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) collectionViewLayout:flowLayOut];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEGoodsmanagerMainCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:idCell];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (NSArray*)titleNameArray
{
    if (!_titleNameArray) {
        _titleNameArray = @[ @"快速发布", @"商品发布", @"餐饮菜品发布", @"零售分类管理", @"餐饮分类管理", @"运费模板设置", @"抵扣券设置", @"餐饮菜单管理", @"商品查询" ];
    }
    return _titleNameArray;
}

- (NSArray*)imageNameArray
{
    if (!_imageNameArray) {
        _imageNameArray = @[ @"gyhe_quickRelease_icon", @"gyhe_productRelease_icon", @"gyhe_dineMenu_icon", @"gyhe_retailCategory_icon", @"gyhe_restaurantCategory_icon", @"gyhe_template_icon", @"gyhe_coupons_icon", @"gyhe_restaurantMenu_icon", @"gyhe_goodsQuery_icon" ];
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

// #pragma mark - SystemDelegate

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleNameArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEGoodsmanagerMainCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:idCell forIndexPath:indexPath];
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
    return CGSizeMake((kScreenWidth - kDeviceProportion(10 * 2)) / 5, kDeviceProportion(254.0f));
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
            //快速发布
        } break;
            
        case 1: {
            //商品发布
        } break;
            
        case 2: {
            //餐饮菜品发布
        } break;
            
        case 3: {
            //零售分类管理
        } break;
            
        case 4: {
            //餐饮分类管理
        } break;
            
        case 5: {
            //运费模板设置
        } break;
            
        case 6: {
            //抵扣券设置
        } break;
            
        case 7: {
            //餐饮菜单管理
        } break;
        case 8: {
            //商品查询
            GYHEGoodsQueryViewController *goodsQueryVC = [[GYHEGoodsQueryViewController alloc] init];
            [self.navigationController pushViewController:goodsQueryVC animated:self];
        } break;
        default:
            break;
    }
}

// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"商品管理");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self.view addSubview:self.collectionView];
}

#pragma mark - event

#pragma mark - request

@end
