//
//  GYHDSelectMarkViewController.m
//  HSConsumer
//
//  Created by wangbiao on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSelectMarkViewController.h"
#import "GYHDSelectMarkFlowLayout.h"
#import "GYHDSelectMarkCell.h"
#import "GYHDChooseMarkCell.h"
#import "GYHDSelectMarkModel.h"
#import "GYHDMessageCenter.h"

@interface GYHDSelectMarkViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
/**选中 顶部*/
@property(nonatomic,strong)UICollectionView *selectCollectionView;
/**选择 底部*/
@property(nonatomic,strong)UICollectionView *chooseCollectionView;
/**选择数组*/
@property(nonatomic, strong)NSMutableArray *chooseDataArray;
/**选中数组*/
@property(nonatomic, strong)NSMutableArray *selectDataArray;
@end

@implementation GYHDSelectMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GYHDSelectMarkFlowLayout  *flowLayout= [[GYHDSelectMarkFlowLayout alloc] init];
    self.selectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.selectCollectionView.dataSource = self;
    self.selectCollectionView.delegate = self;

    [self.selectCollectionView registerClass:[GYHDSelectMarkCell class] forCellWithReuseIdentifier:NSStringFromClass([GYHDSelectMarkCell class])];
    [self.view addSubview:self.selectCollectionView];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"所有标签";
    titleLabel.backgroundColor = [UIColor randomColor];
    [self.view addSubview:titleLabel];
    
    self.chooseCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.chooseCollectionView.dataSource = self;
    self.chooseCollectionView.delegate = self;
    [self.selectCollectionView registerClass:[GYHDChooseMarkCell class] forCellWithReuseIdentifier:NSStringFromClass([GYHDChooseMarkCell class])];
    [self.view addSubview:self.chooseCollectionView];
    WS(weakSelf);
    [self.selectCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.selectCollectionView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self.chooseCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(titleLabel.mas_bottom);
    }];
    [self loadData];
}

- (void)loadData {
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if ([self.chooseCollectionView isEqual:collectionView]) {
        count = self.chooseDataArray.count;
    }else if ([self.chooseCollectionView isEqual:collectionView]) {
        count = self.selectDataArray.count;
    }
    return 2;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    if ([self.chooseCollectionView isEqual:collectionView]) {
        GYHDChooseMarkCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GYHDChooseMarkCell class]) forIndexPath:indexPath];
        cell = baseCell;
    }else if ([self.selectCollectionView isEqual:collectionView]) {
        GYHDSelectMarkCell *baseCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GYHDSelectMarkCell class]) forIndexPath:indexPath];
        cell = baseCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 50);
}
@end
