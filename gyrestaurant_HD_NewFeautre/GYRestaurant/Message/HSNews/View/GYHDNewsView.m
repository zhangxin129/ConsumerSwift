//
//  GYHDNewsView.m
//  HSEnterprise
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDNewsView.h"
#import "GYHDNewsCell.h"
@interface GYHDNewsView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@end

@implementation GYHDNewsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {

    //先实例化一个层
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建一屏的视图大小
    UICollectionView *newsCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    newsCollectionView.backgroundColor = [UIColor whiteColor];
    [newsCollectionView registerClass:[GYHDNewsCell class] forCellWithReuseIdentifier :@"newsCell"];
    newsCollectionView.delegate = self;
    newsCollectionView.dataSource = self;
    [self addSubview:newsCollectionView];
    @weakify(self);
    [newsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    }];
    
}

#pragma mark --UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
    return 10 ;
}

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"newsCell";
    GYHDNewsCell *cell = (GYHDNewsCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    return cell;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.bounds.size.width) / 2, 200);
    
}

@end
