//
//  GYHSStoreMainVC.m
//
//  Created by apple on 16/8/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
/**
 *  互生Store的主界面，可以进去申购工具、系统资源申购、个性卡定制服务、工具申购查询界面
 */
#import "GYHSStoreMainVC.h"
#import "GYHEGoodsmanagerMainCollectionViewCell.h"
#import "GYHSPurchaseToolsVC.h"
#import "GYHSSysResPurchaseVC.h"
#import "GYHSPersonalityCardListVC.h"
#import "GYHSToolsQueryVC.h"

static NSString* idCell = @"goodsmanagerMainCollectionViewCell";

@interface GYHSStoreMainVC ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* titleNameArray;
@property (nonatomic, strong) NSArray* imageNameArray;

@end

@implementation GYHSStoreMainVC
/**
 *  懒加载瀑布流
 */
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
/**
 *  懒加载子界面的名称
 */
- (NSArray*)titleNameArray
{
    if (!_titleNameArray) {
        if (globalData.companyType == kCompanyType_Trustcom) {
           _titleNameArray = @[ kLocalized(@"GYHS_HSStore_PurchaseTools_ToolPurchase"), kLocalized(@"GYHS_HSStore_SysResPurchase_SystemResourcePurchase"), kLocalized(@"GYHS_HSStore_PerCardCustomization_PersonalizedCardCustomization"), kLocalized(@"GYHS_HSStore_Main_QueryToolPurchase") ];
        }else if (globalData.companyType == kCompanyType_Membercom){
        _titleNameArray = @[kLocalized(@"GYHS_HSStore_PurchaseTools_ToolPurchase"),kLocalized(@"GYHS_HSStore_Main_QueryToolPurchase") ];
        }
       
    }
    return _titleNameArray;
}
/**
 *  懒加载子界面图片
 */
- (NSArray*)imageNameArray
{
    if (!_imageNameArray) {
         if (globalData.companyType == kCompanyType_Trustcom) {
             _imageNameArray = @[ @"gyhs_PurchaseTools_icon", @"gyhs_SystemResourcePurchase_icon", @"gyhs_PersonalizedCardCustomization_icon", @"gyhs_PurchaseToolsQuery_icon"];
         }else if (globalData.companyType == kCompanyType_Membercom){
          _imageNameArray = @[@"gyhs_PurchaseTools_icon",@"gyhs_PurchaseToolsQuery_icon"];
         }
        
    }
    return _imageNameArray;
}

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_HSStore_Main_HSStore");
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
// #pragma mark TableView Delegate
// #pragma mark - CustomDelegate
// #pragma mark - event response

#pragma mark - private methods
- (void)initView
{
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
    [self.view addSubview:self.collectionView];
}

/**
 *  UICollectionView的代理方法
 */
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
    return CGSizeMake((kScreenWidth - kDeviceProportion(10 * 2)) / 4.0, kDeviceProportion(254.0f));
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
/**
 *  进去各子界面的入口
 */
// #pragma mark - CustomDelegate
#pragma mark - event response
- (void)touchCellIndexPath:(NSIndexPath*)indexPath
{
    if (globalData.companyType == kCompanyType_Trustcom) {
        switch (indexPath.row) {
            case 0: {
                //申购工具
                GYHSPurchaseToolsVC *purchaseToolsVC = [[GYHSPurchaseToolsVC alloc] init];
                [self.navigationController pushViewController:purchaseToolsVC animated:YES];
            } break;
                
            case 1: {
                //系统资源申购
                GYHSSysResPurchaseVC *sysResPurchaseVC = [[GYHSSysResPurchaseVC alloc] init];
                [self.navigationController pushViewController:sysResPurchaseVC animated:YES];
            } break;
                
            case 2: {
                //个性卡定制服务
                GYHSPersonalityCardListVC *personalityCardListVC = [[GYHSPersonalityCardListVC alloc] init];
                [self.navigationController pushViewController:personalityCardListVC animated:YES];
            } break;
            case 3: {
                //工具申购查询
                GYHSToolsQueryVC *queryVC=[GYHSToolsQueryVC new];
                
                [self.navigationController pushViewController:queryVC animated:YES];
            } break;
                
            default:
                break;
        }
    }else if (globalData.companyType == kCompanyType_Membercom){
        switch (indexPath.row) {
            case 0: {
                //申购工具
                GYHSPurchaseToolsVC *purchaseToolsVC = [[GYHSPurchaseToolsVC alloc] init];
                [self.navigationController pushViewController:purchaseToolsVC animated:YES];
            } break;

            case 1:{
                //工具申购查询
                GYHSToolsQueryVC *queryVC=[GYHSToolsQueryVC new];
                
                [self.navigationController pushViewController:queryVC animated:YES];
            
            }break;
            default:
            break;
        }
    
    }
}

@end
