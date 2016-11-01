//
//  GYHeTakeDishesCollectionView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHeTakeDishesCollectionView.h"
#import "GYHETakeDishesCollectionViewCell.h"
#import "GYHESysModel.h"

@interface GYHeTakeDishesCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end
@implementation GYHeTakeDishesCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.dataSource = self;
        self.collectionViewLayout = layout;
        self.showsVerticalScrollIndicator = NO;
        self.bounces = NO;
    }
    return  self;
}

#pragma mark --UICollectionViewDataSource

//定义展示的Section的个数

- (NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView

{
    return 1 ;
}


//定义展示的UICollectionViewCell的个数

- (NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section

{
    return 35;
}

//每个UICollectionView展示的内容

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    GYHETakeDishesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"takeDishesCollectionViewCell" forIndexPath:indexPath];
    return cell;
}



#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self getChangCount:indexPath.item indexPath:indexPath];
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    return CGSizeMake ( (kScreenWidth - 64 - 60) / 5 , (kScreenHeight - 240) / 7 );
}

//定义每个UICollectionView 的边距

- (UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    return UIEdgeInsetsMake ( 20 , 5 , 20 , 5 );
}

- (void)getChangCount:(NSInteger)index indexPath:(NSIndexPath *)indexPath{
    
    GYHETakeDishesCollectionViewCell *cell = [self dequeueReusableCellWithReuseIdentifier:@"takeDishesCollectionViewCell" forIndexPath:indexPath];
    
    NSInteger maxFood = 3;
        NSInteger num = 0;
        num += 1;
        if (num == maxFood + 1) {
            num = 0;
        }
    cell.num = num;
}

@end
