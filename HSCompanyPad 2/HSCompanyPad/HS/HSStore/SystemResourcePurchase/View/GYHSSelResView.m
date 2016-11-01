//
//  GYHSSelResView.m
//
//  Created by apple on 16/8/18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSSelResView.h"
#import "GYHSSysResCell.h"

static NSString *sysResCellID = @"GYHSSysResCell";
#define kViewWidth self.frame.size.width
@interface GYHSSelResView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *tipsView;
@property (nonatomic, strong) UIView *mianView;
@property (nonatomic, strong) UIView *footerView;
@property (nonatomic, strong) UILabel *totalLable;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger selectedRow; //标记下一行能选中哪一行，只能顺序选择
@property (nonatomic, assign) NSInteger buyCardNumber;

@end
@implementation GYHSSelResView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}
/**
 *  接收从控制器传过来的数据模型
 */
-(void)setModel:(GYHSResSegmentModel *)model{
    _model = model;
    self.selectedRow = self.model.startBuyRes.integerValue - 2;
    [_collectionView reloadData];
}
- (void)setUI{
    [self setTipsUI];
    [self setMainUI];
    [self setFooterUI];
}
/**
 *  创建温馨提示的视图，通过属性文字来创建温馨提示
 */
- (void)setTipsUI{
    
    UIView *tipsView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kDeviceProportion(kViewWidth) , kDeviceProportion(130))];
    [self addSubview:tipsView];
    self.tipsView = tipsView;
    self.tipsView.layer.borderColor = kGrayCCCCCC.CGColor;
    self.tipsView.layer.borderWidth = 1.0f;

    UILabel *tipsLable = [[UILabel alloc] init];
    tipsLable.numberOfLines = 0;
    NSString *tipsStr = [NSString stringWithFormat:@"%@\n%@\n%@",kLocalized(@"GYHS_HSStore_PerCardCustomization_Tips"),kLocalized(@"GYHS_HSStore_SysResPurchase_TrustEnterpriseSystemsConsumerResourcesSegmentNumberCanBuyOnlyTheEntireSequence"),kLocalized(@"GYHS_HSStore_SysResPurchase_EachTrustEnterpriseSystemsConsumerResourcesPurchasePricedAt 20,000.00")];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle defaultParagraphStyle].mutableCopy;
    paragraphStyle.lineSpacing = 10;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:tipsStr attributes:@{NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kGray666666 ,NSParagraphStyleAttributeName:paragraphStyle}];
    NSRange range = [tipsStr rangeOfString:kLocalized(@"GYHS_HSStore_PerCardCustomization_Tips")];
    [text addAttributes:@{ NSFontAttributeName : kFont36, NSForegroundColorAttributeName : kRedE50012 } range:range];
    tipsLable.attributedText = text;
    [_tipsView addSubview:tipsLable];
    [tipsLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsView.mas_top).offset(30);
        make.left.equalTo(tipsView.mas_left).offset(80);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 80)));
        make.height.equalTo(@(kDeviceProportion(90)));
    }];
}
/**
 *  创建系统资源段的瀑布流
 */
- (void)setMainUI{
    UIView *mianView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tipsView.frame) + 16, kViewWidth, 290)];
    [self addSubview:mianView];
    self.mianView = mianView;
    self.mianView.layer.borderColor = kGrayCCCCCC.CGColor;
    self.mianView.layer.borderWidth = 1.0f;
    self.mianView.backgroundColor = kWhiteFFFFFF;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 290) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.backgroundColor = kWhiteFFFFFF;
    [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSSysResCell class]) bundle:nil] forCellWithReuseIdentifier:sysResCellID];
    [self.mianView addSubview:_collectionView];
}
/**
 *  创建统计总共申购的资源段
 */
- (void)setFooterUI{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mianView.frame) + 16, kViewWidth, 16)];
    [self addSubview:footerView];
    self.footerView = footerView;

    _totalLable = [[UILabel alloc] init];
    
    self.totalLable.text = [NSString stringWithFormat:@"%@%@%@%@%@", kLocalized(@"GYHS_HSStore_SysResPurchase_BuyResourceCardSumOne"), [@((self.buyCardNumber + 1) / GYPerSegmentHsCardCount) stringValue], kLocalized(@"GYHS_HSStore_SysResPurchase_BuyResourceCardSumTwo"), [@(self.buyCardNumber) stringValue], kLocalized(@"GYHS_HSStore_SysResPurchase_BuyResourceCardSumThree")];
    _totalLable.textColor = kGray333333;
    _totalLable.font = kFont32;
    _totalLable.textAlignment = NSTextAlignmentRight;
    [self.footerView addSubview:_totalLable];
    [_totalLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_footerView.mas_top).offset(0);
        make.right.equalTo(_footerView.mas_right).offset(- 16);
        make.width.equalTo(@(kDeviceProportion(kViewWidth - 16)));
        make.height.equalTo(@(kDeviceProportion(16)));
    }];


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
    return self.model.segment.count;
}

//每个UICollectionView展示的内容

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath

{
    GYHSSysResCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sysResCellID forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    cell.model = self.model.segment[indexPath.row];
    if (cell.model.buyStatus.boolValue) { //如果已经购买 则显示但不可点击
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GYSegmentModel* model = self.model.segment[indexPath.item];
    
    if (indexPath.item == self.selectedRow + 1 || indexPath.item == self.selectedRow) {
        
        model.selected = !model.isSelected;
        self.selectedRow = indexPath.item;
        if (!model.isSelected) { //如果当前非选中则选中行为之前的一行 否则选中行为当前行
            self.selectedRow = indexPath.item - 1;
        }
        [_collectionView reloadItemsAtIndexPaths:@[indexPath]];
        self.buyCardNumber = 0;
        int i = 0;
        for (GYSegmentModel* model in self.model.segment) {
            if (model.isSelected) {
                i++;
                self.buyCardNumber += model.cardCount.integerValue;
            }
        }
        self.model.product.buySegmentNumber = [@(i) stringValue];
        self.model.product.buyCardNumber = [@(self.buyCardNumber) stringValue];
        self.totalLable.text = [NSString stringWithFormat:@"%@%@%@%@%@", kLocalized(@"GYHS_HSStore_SysResPurchase_BuyResourceCardSumOne"), [@((self.buyCardNumber + 1) / GYPerSegmentHsCardCount) stringValue], kLocalized(@"GYHS_HSStore_SysResPurchase_BuyResourceCardSumTwo"), [@(self.buyCardNumber) stringValue], kLocalized(@"GYHS_HSStore_SysResPurchase_BuyResourceCardSumThree")];
    }
    else {
        [GYUtils showToast:kLocalized(@"GYHS_HSStore_SysResPurchase_PleaseSeclectCardByTerm")];
    }
    
    NSMutableArray* selectedArrM = @[].mutableCopy;
    for (GYSegmentModel* model in self.model.segment) {
        if (model.selected) {
            [selectedArrM addObject:model];
        }
    }
    [self.delegate transSelectModelArr:selectedArrM ProductModel:self.model.product];

}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
}
#pragma mark -- UICollectionViewDelegate && UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    return CGSizeMake (kDeviceProportion(395) , kDeviceProportion(16 + 20));
}

//定义每个UICollectionView 的边距

- (UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    return UIEdgeInsetsMake ( 35 , 0 , 35 , 0 );
}


@end
