//
//  GYHEMoreMenusViewController.m
//  HSConsumer
//
//  Created by kuser on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEMoreMenusViewController.h"
#import "GYHEMoreMenusCell.h"

#define GYHEMoreMenusCellReuseId @"GYHEMoreMenusCellReuseId"

@interface GYHEMoreMenusViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, GYNetRequestDelegate>

@property (strong, nonatomic) UICollectionView* collectionView;
@property (strong, nonatomic) NSArray* dataSource;

@end

@implementation GYHEMoreMenusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
     self.view.backgroundColor = kDefaultVCBackgroundColor;
    [self.view addSubview:self.collectionView];
     _dataSource = @[@"抵扣券",@"xxx",@"免费配送",@"0元起送",@"确定"];
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYHEMoreMenusCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYHEMoreMenusCellReuseId forIndexPath:indexPath];
    
    [cell.titleBtn setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
    
    if (indexPath.row == self.dataSource.count - 1) {
        [cell.titleBtn setBackgroundColor:kCorlorFromHexcode(0xff5000)];
        [cell.titleBtn setTitleColor:kCorlorFromHexcode(0xffffff) forState:UIControlStateNormal];
    }
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - 懒加载
- (UICollectionView*)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(6, 6, kScreenWidth - 12, kScreenHeight - 64) collectionViewLayout:layout];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((kScreenWidth -12 - 12 * 3) * 0.25, 30);
        _collectionView.backgroundColor = kDefaultVCBackgroundColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEMoreMenusCell class]) bundle:nil] forCellWithReuseIdentifier:GYHEMoreMenusCellReuseId];
    }
    return _collectionView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
