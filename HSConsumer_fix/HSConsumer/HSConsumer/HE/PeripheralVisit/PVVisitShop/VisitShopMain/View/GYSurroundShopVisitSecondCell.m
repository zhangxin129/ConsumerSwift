//
//  GYSurroundShopSecondCell.m
//  GYHSConsumer_SurroundVisit
//
//  Created by zhangqy on 16/3/18.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSurroundShopVisitSecondCell.h"
#import "GYSurroundVisitShopCollectionViewCell.h"
#import "GYSurroundVisitShopModel.h"
#define GYSurroundVisitShopCollectionViewCellReuseId @"GYSurroundVisitShopCollectionViewCell"

@interface GYSurroundShopVisitSecondCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, weak) NSArray* dataSource;
@end

@implementation GYSurroundShopVisitSecondCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        CGFloat height = 170;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width, height) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[GYSurroundVisitShopCollectionViewCell class] forCellWithReuseIdentifier:GYSurroundVisitShopCollectionViewCellReuseId];
        [self.contentView addSubview:_collectionView];
    }
    return self;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYSurroundVisitShopCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYSurroundVisitShopCollectionViewCellReuseId forIndexPath:indexPath];
    if(self.dataSource.count > indexPath.row) {
        GYSurroundVisitShopItemModel* model = _dataSource[indexPath.row];
        cell.imageURLString = model.picAddr;
        cell.titleString = model.categoryName;
    }
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat width = (320 - 50) / 4;
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat totalWidth = (320 - 50) / 4 * 4;
    CGFloat space = ([UIScreen mainScreen].bounds.size.width - totalWidth) / 5 - 1;
    return space;
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(surroundShopVisitSecondCell:didSelectItemAtIndexPath:categoryName:categoryId:)]) {
        
        if(self.dataSource.count > indexPath.row) {
            GYSurroundVisitShopItemModel* model = _dataSource[indexPath.row];
            [_delegate surroundShopVisitSecondCell:self didSelectItemAtIndexPath:indexPath categoryName:model.categoryName categoryId:model.id];
        }
        
    }
}

- (void)setSecondCategories:(NSArray*)secondCategories
{
    _dataSource = secondCategories;
    [_collectionView reloadData];
}

+ (CGFloat)height
{
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat height = width / 2 + 20;
    return height;
}

@end
