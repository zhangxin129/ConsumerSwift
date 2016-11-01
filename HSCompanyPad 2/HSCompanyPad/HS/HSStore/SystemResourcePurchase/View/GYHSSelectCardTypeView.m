//
//  GYHSSelectCardTypeView.m
//  HSCompanyPad
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSSelectCardTypeView.h"
#import "UILabel+Category.h"
#import "GYHSStaTypeCell.h"
#import "GYHSCardTypeModel.h"
#import "GYHSPerTypeCell.h"

static NSString *staTypeCellID = @"GYHSStaTypeCell";
static NSString *perTypeCellID = @"GYHSPerTypeCell";

#define kViewWidth self.frame.size.width
@interface GYHSSelectCardTypeView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *standardView;
@property (nonatomic, strong) UIView *personalView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *perTypeCollectionView;
@property (nonatomic, strong) GYHSCardTypeModel *selectModel;


@end
@implementation GYHSSelectCardTypeView
/**
 *  懒加载从控制器传过来的数据源
 */
- (void)setStaTypeArray:(NSMutableArray *)staTypeArray{
    _staTypeArray = staTypeArray;
    [_collectionView reloadData];
}

-(void)setPerTypeArray:(NSMutableArray *)perTypeArray{
    _perTypeArray = perTypeArray;
    if (perTypeArray.count == 0) {
        _personalView.hidden = YES;
    }else{
        _personalView.hidden = NO;
    }
    [_perTypeCollectionView reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    [self createStandardView];
    [self createPersonalView];

}
/**
 *  创建标准卡样的瀑布流视图
 */
- (void)createStandardView{
    _standardView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kViewWidth - 16, 230)];
    [self addSubview:_standardView];
    _standardView.layer.borderColor = kGrayCCCCCC.CGColor;
    _standardView.layer.borderWidth = 1.0f;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kGreenF4F4F4;
    [_standardView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_standardView.mas_top).offset(0);
        make.left.equalTo(_standardView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(_standardView.frame.size.width)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    UILabel *addLable = [[UILabel alloc] init];
    [addLable initWithText:kLocalized(@"GYHS_HSStore_SysResPurchase_StandardCardStyle") TextColor:kGray333333 Font:kFont42 TextAlignment:0];
    [headerView addSubview:addLable];
    [addLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(11);
        make.left.equalTo(headerView.mas_left).offset(16);
        make.width.equalTo(@(kDeviceProportion(100)));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kViewWidth, 230 - 45) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = kWhiteFFFFFF;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSStaTypeCell class]) bundle:nil] forCellWithReuseIdentifier:staTypeCellID];
    [self.standardView addSubview:_collectionView];


}
/**
 *  创建个性卡样的瀑布流视图
 */
- (void)createPersonalView{
    _personalView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_standardView.frame) + 16, kViewWidth - 16, 290)];
    [self addSubview:_personalView];
    _personalView.layer.borderColor = kGrayCCCCCC.CGColor;
    _personalView.layer.borderWidth = 1.0f;
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = kGreenF4F4F4;
    [_personalView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_personalView.mas_top).offset(0);
        make.left.equalTo(_personalView.mas_left).offset(0);
        make.width.equalTo(@(kDeviceProportion(_personalView.frame.size.width)));
        make.height.equalTo(@(kDeviceProportion(45)));
    }];
    
    UILabel *addLable = [[UILabel alloc] init];
    [addLable initWithText:kLocalized(@"GYHS_HSStore_SysResPurchase_PersonalityCardStyle") TextColor:kGray333333 Font:kFont42 TextAlignment:0];
    [headerView addSubview:addLable];
    [addLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(11);
        make.left.equalTo(headerView.mas_left).offset(16);
        make.width.equalTo(@(kDeviceProportion(100)));
        make.height.equalTo(@(kDeviceProportion(21)));
    }];
    
   
    UIButton *customizeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customizeButton setTitle:@"定制个性卡" forState:UIControlStateNormal];
    [customizeButton setTitleColor:kWhiteFFFFFF forState:UIControlStateNormal];
    [customizeButton setBackgroundColor:kBlue0A59C2];
    customizeButton.layer.cornerRadius = 6.0f;
    [customizeButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:customizeButton];
    [customizeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(6);
        make.right.equalTo(headerView.mas_right).offset(-16);
        make.width.equalTo(@(kDeviceProportion(120)));
        make.height.equalTo(@(kDeviceProportion(33)));
    }];

    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _perTypeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kViewWidth, 290 - 45) collectionViewLayout:flowLayout];
    _perTypeCollectionView.delegate = self;
    _perTypeCollectionView.dataSource = self;
    _perTypeCollectionView.backgroundColor = kWhiteFFFFFF;
    [_perTypeCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSPerTypeCell class]) bundle:nil] forCellWithReuseIdentifier:perTypeCellID];
    [self.personalView addSubview:_perTypeCollectionView];


}

- (void)nextAction{
    if ([self.delegate respondsToSelector:@selector(customizeButtonAction)]) {
        [self.delegate customizeButtonAction];
    }
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
    return collectionView == _collectionView ? _staTypeArray.count : _perTypeArray.count;
}

//每个UICollectionView展示的内容

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    if (collectionView == _collectionView) {
        GYHSStaTypeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:staTypeCellID forIndexPath:indexPath];
        cell.userInteractionEnabled = YES;
        cell.model = _staTypeArray[indexPath.item];
        return cell;
    }else{
        GYHSPerTypeCell *perCell = [collectionView dequeueReusableCellWithReuseIdentifier:perTypeCellID forIndexPath:indexPath];
        perCell.userInteractionEnabled = YES;
        perCell.model = _perTypeArray[indexPath.item];
        return perCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    for (GYHSCardTypeModel* model in self.staTypeArray) {
        model.isSelected = NO;
    }
    for (GYHSCardTypeModel* model in self.perTypeArray) {
        model.isSelected = NO;
    }
    
    GYHSCardTypeModel* model = collectionView == _collectionView ? self.staTypeArray[indexPath.item] : self.perTypeArray[indexPath.item];
    model.isSelected = YES;
    self.selectModel = model;
    if ([self.delegate respondsToSelector:@selector(transSlectModel:)]) {
        [self.delegate transSlectModel:self.selectModel];
    }
    [self.collectionView reloadData];
    [self.perTypeCollectionView reloadData];
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark -- UICollectionViewDelegate && UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    return  collectionView == _collectionView ? CGSizeMake (kDeviceProportion(150) , kDeviceProportion(150)) : CGSizeMake (kDeviceProportion(800) , kDeviceProportion(200));
}

//定义每个UICollectionView 的边距

- (UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    return collectionView == _collectionView ? UIEdgeInsetsMake ( 20 , 50 , 20 , 50 ) :UIEdgeInsetsMake ( 25 , 60 , 25 , 60 );
}

@end
