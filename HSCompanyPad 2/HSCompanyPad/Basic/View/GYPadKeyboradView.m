//
//  GYPadKeyboradView.m
//  test
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangbb. All rights reserved.
//

#import "GYPadKeyboradView.h"
#import "GYPadKeyBoardCollectionViewCell.h"


static NSString* idCell = @"cell";

@interface GYPadKeyboradView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray* dataSouceArray;
@property (nonatomic, strong) UICollectionView* collection;

@end

@implementation GYPadKeyboradView

- (NSArray*)dataSouceArray
{
    if (!_dataSouceArray) {
        _dataSouceArray = @[ @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"x", @"0", @"." ];
    }
    return _dataSouceArray;
}

- (UICollectionView*)collection
{
    if (!_collection) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.backgroundColor = [UIColor whiteColor];
        [_collection registerNib:[UINib nibWithNibName:NSStringFromClass([GYPadKeyBoardCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:idCell];
    }
    return _collection;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor cyanColor];
        [self setUp];
    }
    return self;
}

-(void)dealloc {
    NSLog(@"键盘GYPadKeyboradView ---------- dealloc");
}

- (void)setUp
{
    [self addSubview:self.collection];
    [self.collection mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.right.bottom.equalTo(self);
    }];
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kDeviceProportion(5.0);
}

- (CGFloat)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return  kDeviceProportion(5.0);
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath
{
    
    return CGSizeMake((self.bounds.size.width - kDeviceProportion(30)) / 3.0, (self.bounds.size.height - kDeviceProportion(38)) / 4.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 13, 10);
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSouceArray.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    GYPadKeyBoardCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:idCell forIndexPath:indexPath];
    if (indexPath.item == 9) {
        cell.imageView.image = [UIImage imageNamed:@"gyhs_keyBoardDelete"];
        cell.imageView.highlightedImage = [UIImage imageNamed:@"gyhs_keyBoardDelete_high"];
    } else {
        cell.textLabel.text = self.dataSouceArray[indexPath.item];
        cell.imageView.image = [UIImage imageNamed:@"gyhs_keyBoardBackground"];
        cell.imageView.highlightedImage = [UIImage imageNamed:@"gyhs_keyBoardBackground_high"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.item != 9) {
        if ([self.delegate respondsToSelector:@selector(padKeyBoardViewDidClickNumberWithString:)]) {
            [_delegate padKeyBoardViewDidClickNumberWithString:self.dataSouceArray[indexPath.row]];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(padKeyBoardViewDidClickDelete)]) {
            [_delegate padKeyBoardViewDidClickDelete];
        }
    }
}

@end
