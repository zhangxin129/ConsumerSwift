//
//  GYHESellerServiceViewController.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHESellerServiceViewController.h"
#import "GYHEServiceCollectionViewCell.h"
#import "GYHETools.h"

#define kGYHEServiceCollectionViewCellIdentifier @"GYHEServiceCollectionViewCell"
@interface GYHESellerServiceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,GYHEServiceCollectionDelegate>
@property (nonatomic,strong)UICollectionView *sellerCollectonView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation GYHESellerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
-(void)initUI
{
    [self.view addSubview:self.sellerCollectonView];
    [self.sellerCollectonView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEServiceCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:kGYHEServiceCollectionViewCellIdentifier];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEServiceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYHEServiceCollectionViewCellIdentifier forIndexPath:indexPath];
    [cell.titleBtn setTitle:self.dataArray[indexPath.item] forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    cell.serviceDelegate = self;
    if (indexPath.item == self.dataArray.count-1) {
        [cell.titleBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_determine_background"] forState:UIControlStateNormal];
        [cell.titleBtn setTitleColor:kWhite forState:UIControlStateNormal];
    }else{
        [cell.titleBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_no_select_service"] forState:UIControlStateNormal];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    return CGSizeMake(kScreenWidth / 4, kScreenWidth / 8);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
#pragma mark -- GYHEServiceCollectionDelegate
-(void)serviceBtn:(UIButton *)btn indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.dataArray.count-1) {
        
    }else{
        if (!btn.selected) {
            btn.selected = !btn.selected;
            [btn setBackgroundImage:[UIImage imageNamed:@"gyhe_select_service"] forState:UIControlStateSelected];
            [btn setTitleColor:kSelectedRedBtn forState:UIControlStateSelected];
        }else{
            btn.selected = !btn.selected;
            [btn setBackgroundImage:[UIImage imageNamed:@"gyhe_no_select_service"] forState:UIControlStateNormal];
             [btn setTitleColor:kBlackBtn forState:UIControlStateNormal];
        }
        
    }
}
#pragma mark -- Lazy loading
- (UICollectionView*)sellerCollectonView
{
    if (_sellerCollectonView == nil) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _sellerCollectonView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 8, kScreenWidth, 60) collectionViewLayout:flowLayout];
        _sellerCollectonView.scrollEnabled = NO;
        _sellerCollectonView.backgroundColor = kDefaultVCBackgroundColor;
        _sellerCollectonView.delegate = self;
        _sellerCollectonView.dataSource = self;
    }
    return _sellerCollectonView;
}
-(NSMutableArray*)dataArray
{
    if (!_dataArray) {
        _dataArray =[[NSMutableArray alloc] initWithObjects:
                     @"抵扣卷",
                     @"免配送费",
                     @"0元起送",
                     @"确定", nil];
    }
    return _dataArray;
}
@end
