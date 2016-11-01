//
//  GYHEAddShoppingCarViewController.m
//
//  Created by lizp on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEAddShoppingCarViewController.h"
#import "YYKit.h"
#import "GYHEAddShoppingCarFooterView.h"
#import "GYHEAddShoppingCarCell.h"
#import "IQKeyboardManager.h"
#import "GYHEAddShoppingCarHeaderView.h"
#import "YYKit.h"


@interface GYHEAddShoppingCarViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (nonatomic,strong) UIButton *confirmBtn;//确定按钮
@property (nonatomic,strong) UIControl *overlayControl;//背景Control
@property (nonatomic,strong) UIImageView *headerImageView;//商品图片
@property (nonatomic,strong) UILabel *hsbLabel;//互生币金额
@property (nonatomic,strong) UILabel *pvLabel;//积分
@property (nonatomic,strong) UILabel *attributeLabel;//选择商品的属性
@property (nonatomic,strong) UIButton *dismissBtn;//叉叉按钮
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIView *headerView;//头部
@property (nonatomic,strong) GYHEAddShoppingCarFooterView *footer;//cell 尾部
@property (nonatomic,strong) UIImageView *hsbImageView;//互生币图片
@property (nonatomic,strong) NSMutableArray *selectIndexPath;//选择cell的集合
@property (nonatomic,strong) NSMutableArray *sectionMarr;//返回的商品属性有多少类
@property (nonatomic,strong) NSMutableArray *skuDataSource;//sku数据源
@property (nonatomic,strong) NSMutableArray *sizeMarr;//计算 内容的高度和宽度

@end

@implementation GYHEAddShoppingCarViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

#pragma mark - SystemDelegate  
#pragma mark - UITextFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField {

    if([textField.text integerValue] < 1) {
        self.footer.reduceBtn.selected = NO;
        self.footer.numberextField.text = @"1";
        [GYUtils showToast:kLocalized(@"GYHE_Good_Number_Beyond_Scope")];
    }else {
        self.footer.reduceBtn.selected = YES;
    }
}
// #pragma mark TableView Delegate

#pragma mark - UICollectionView Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return self.sectionMarr.count;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return [self.skuDataSource[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    GYHEAddShoppingCarCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:kGYHEAddShoppingCarCellIdentifier forIndexPath:indexPath];
    [cell.titleBtn setTitle:[NSString stringWithFormat:@"%@",self.skuDataSource[indexPath.section][indexPath.row]] forState:UIControlStateNormal];
    [cell.titleBtn sizeToFit];
    cell.titleBtn.titleLabel.numberOfLines = 0;
    cell.titleBtn.frame = CGRectMake(0, 0, [self.sizeMarr[indexPath.section][indexPath.row][@"width"] floatValue], [self.sizeMarr[indexPath.section][indexPath.row][@"height"] floatValue]);
    [cell.titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];

    if ([self.selectIndexPath containsObject:indexPath]) {
        cell.titleBtn.selected = YES;
    }else {
        cell.titleBtn.selected = NO;
    }
    return cell;
}


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    UICollectionReusableView *reusableView = nil;
    
    if([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GYHEAddShoppingCarHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGYHEAddShoppingCarHeaderViewIdentifier forIndexPath:indexPath];
        header.titleLabel.text = self.sectionMarr[indexPath.section];
        reusableView = header;
    }
    
    if([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == self.sectionMarr.count -1) {
        self.footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kGYHEAddShoppingCarFooterViewIdentifier forIndexPath:indexPath];
        self.footer.numberextField.delegate = self;
        [self.footer.addBtn addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
        [self.footer.reduceBtn addTarget:self action:@selector(reduceNumber) forControlEvents:UIControlEventTouchUpInside];
        
        reusableView = self.footer;
    }
    return reusableView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //选中状态处理
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    GYHEAddShoppingCarCell *addCell = (GYHEAddShoppingCarCell *)cell;
    addCell.titleBtn.selected = !addCell.titleBtn.selected;
    NSMutableArray *selectedArr = [[NSMutableArray alloc] init];
    if (addCell.titleBtn.selected == NO) {
        if ([self.selectIndexPath containsObject:indexPath]) {
            [self.selectIndexPath removeObject:indexPath];
        }
        
    }
    for (NSIndexPath *index in self.selectIndexPath) {
        [selectedArr addObject:[NSString stringWithFormat:@"%lu",index.section]];
    }
    
    if ([selectedArr containsObject:[NSString stringWithFormat:@"%lu",indexPath.section]]  ) {
        if (addCell.titleBtn.selected == YES) {
            for (NSInteger i = 0; i< self.selectIndexPath.count; i++) {
                if ([self.selectIndexPath[i] section] == indexPath.section && [self.selectIndexPath[i] row] != indexPath.row) {
                    cell = [collectionView cellForItemAtIndexPath:self.selectIndexPath[i]];
                    addCell = (GYHEAddShoppingCarCell *)cell;
                    addCell.titleBtn.selected = NO;
                    [self.selectIndexPath replaceObjectAtIndex:i withObject:indexPath];
                }
            }
        }
        
    }else {
        if (addCell.titleBtn.selected == YES) {
            [self.selectIndexPath addObject:indexPath];
        }
        
    }
    

    
    DDLogInfo(@"%@",self.selectIndexPath);

    //显示已选商品的属性
    NSString *attStr;
    if (self.selectIndexPath.count != self.sectionMarr.count) {

        attStr = kLocalized(@"GYHE_Good_Select");
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        for (NSIndexPath *index in self.selectIndexPath) {
            [sectionArr addObject:[NSString stringWithFormat:@"%lu",index.section]];
        }
        for (NSInteger i = 0; i< self.sectionMarr.count; i++) {
            if (![sectionArr containsObject:[NSString stringWithFormat:@"%lu",i]]) {
                attStr = [NSString stringWithFormat:@"%@ %@",attStr,self.sectionMarr[i]];
            }
        }
        
    }
    else {

        attStr = kLocalized(@"GYHE_Good_Did_Select");
        NSMutableArray *titleArr = [[NSMutableArray alloc] init];
        for (NSIndexPath *index in self.selectIndexPath) {

            if (index.section < titleArr.count) {
                [titleArr insertObject:self.skuDataSource[index.section][index.row] atIndex:index.section];
            }else {
                [titleArr addObject:self.skuDataSource[index.section][index.row]];
            }
        }
        
        for (NSInteger i = 0; i<titleArr.count; i++) {
            attStr = [NSString stringWithFormat:@"%@ \"%@\"",attStr,titleArr[i]];
        }
    }
    self.attributeLabel.text = attStr;
    CGSize size = [GYUtils sizeForString:self.attributeLabel.text font:self.attributeLabel.font width:self.headerView.width - self.hsbImageView.frame.origin.x  -10];
    self.attributeLabel.frame = CGRectMake(self.attributeLabel.origin.x, self.attributeLabel.origin.y, size.width, size.height);
}



-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {

    if(section == self.sectionMarr.count - 1) {
        return CGSizeMake(kScreenWidth, 60);
    }
    return CGSizeMake(0, 0);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {

    return CGSizeMake(kScreenWidth, 29);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([self.sizeMarr[indexPath.section][indexPath.row][@"width"] floatValue] , [self.sizeMarr[indexPath.section][indexPath.row][@"height"] floatValue]);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

// #pragma mark - CustomDelegate
#pragma mark - event response 
#pragma mark - 消失
-(void)dismiss {
    
    DDLogInfo(@"dismiss");
    [self.view removeFromSuperview];
}

#pragma mark - 点击确定
-(void)confirmBtnClick {
    
    DDLogInfo(@"确定");
    DDLogInfo(@"数量%lu",[self.footer.numberextField.text integerValue]);
    if (self.selectIndexPath.count != self.sectionMarr.count) {
        
        NSMutableArray *sectionArr = [[NSMutableArray alloc] init];
        for (NSIndexPath *index in self.selectIndexPath) {
            [sectionArr addObject:[NSString stringWithFormat:@"%lu",index.section]];
        }
        for (NSInteger i = 0; i< self.sectionMarr.count; i++) {
            if (![sectionArr containsObject:[NSString stringWithFormat:@"%lu",i]]) {
                [GYUtils showToast:[NSString stringWithFormat:@"%@%@",kLocalized(@"GYHE_Good_Please_Choose"),self.sectionMarr[i]]];
                break;
            }
        }
        
    }else {
    
        if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectGoodsName:)]) {
            self.view.hidden = YES;
            [self.delegate didSelectGoodsName:self.attributeLabel.text];
        }
    }
    
}

#pragma mark - 增加购物数量
-(void)addNumber {
    
    DDLogInfo(@"增加购物数量");
    self.footer.reduceBtn.selected = YES;
    NSInteger number = [self.footer.numberextField.text integerValue] + 1;
    self.footer.numberextField.text = [NSString stringWithFormat:@"%lu",number];
    
}

#pragma mark - 减少购物数量
-(void)reduceNumber {

    DDLogInfo(@"减少购物数量");
    if( [self.footer.numberextField.text integerValue] > 1) {
        self.footer.numberextField.text = [NSString stringWithFormat:@"%lu",[self.footer.numberextField.text integerValue]-1];
        if ([self.footer.numberextField.text integerValue] > 1) {
            self.footer.reduceBtn.selected = YES;
        }else {
            self.footer.reduceBtn.selected = NO;
        }
    }else {
        self.footer.reduceBtn.selected = NO;
    }
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

//加载数据
-(void)loadData {
 
    NSMutableArray *skuMarr = [[NSMutableArray alloc] init];// 所有 sku的pName 和 pVName (字典)
    self.sectionMarr = [[NSMutableArray alloc] init];//商品属性 （即段落名称）
    for (SkuModel *model in self.model.skus) {
        
        for (SkuNameModel *nameModel in model.sku) {
            NSDictionary *dic = @{@"pName":kSaftToNSString(nameModel.pName),
                                  @"pVName":kSaftToNSString(nameModel.pVName)
                                  };
            if (![self.sectionMarr containsObject:kSaftToNSString(nameModel.pName)]) {
                [self.sectionMarr addObject:kSaftToNSString(nameModel.pName)];
            }
            [skuMarr addObject:dic];

        }
    }
 

    self.skuDataSource = [[NSMutableArray alloc] init];//sku数据源
    for (NSInteger i = 0; i< self.sectionMarr.count; i++) {
    
        NSMutableArray *marr = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in skuMarr) {
            if ([self.sectionMarr[i] isEqualToString:kSaftToNSString(dic[@"pName"])] ) {
                if (![marr containsObject:kSaftToNSString(dic[@"pVName"])]) {
                    [marr addObject:kSaftToNSString(dic[@"pVName"])];
                }
                
            }
        }
        //当某段的商品属性只有一个时  默认选中
        if (marr.count == 1) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.selectIndexPath addObject:indexPath];
        }
        [self.skuDataSource addObject:marr];
    }
    
    [self setUp];
    
    //下面为计算 显示内容的高度和宽度
    CGSize size ;
    CGFloat width;
    CGFloat height;
    self.sizeMarr = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.skuDataSource.count; i++) {
        
        NSMutableArray *sizeMarr  = [[NSMutableArray alloc] init];
        for (NSString *str in self.skuDataSource[i]) {
            size = [GYUtils sizeForString:str font:[UIFont systemFontOfSize:12] width:kScreenWidth -20 ];
            if (size.width < 30) {
                width = 50;
            }else {
                width = size.width +20;
                if (width > kScreenWidth -20 ) {
                    width = kScreenWidth -20;
                }
            }
            
            if (size.height < 20) {
                height = 20;
            }else {
                height = size.height;
            }
            height += 10;
            
            NSDictionary *dic = @{@"width":@(width),
                                  @"height":@(height)
                                  };
            [sizeMarr addObject:dic];
        }
        [self.sizeMarr addObject:sizeMarr];
    }
    [self.collectionView reloadData];
    
}

-(void)setUp {
    
    
    //背景控制
    self.overlayControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 -46)];
    [self.overlayControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.overlayControl];
    
    [self addHeaderView];
    [self.overlayControl addSubview:self.collectionView];
    
    //确定
    self.confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirmBtn.frame = CGRectMake(0, kScreenHeight -49 -46, self.view.width, 46);
    self.confirmBtn.backgroundColor = UIColorFromRGB(0xfb7d00);
    [self.confirmBtn setTitle:kLocalized(@"加入购物车") forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.confirmBtn];
}

#pragma mark - 添加头部
-(void)addHeaderView {

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 120, kScreenWidth, 125)];
    self.headerView.layer.borderWidth = 1;
    self.headerView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.headerView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.overlayControl addSubview:self.headerView];
    
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(12, self.headerView.top -20, 110, 110)];
    borderView.backgroundColor = UIColorFromRGB(0xffffff);
    borderView.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    borderView.layer.borderWidth = 1;
    [self.overlayControl addSubview:borderView];
    
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 106, 106)];
    [borderView addSubview:self.headerImageView];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:kSaftToNSString(self.model.pics[0][@"sourceSize"])] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    
    //互生币图片
    self.hsbImageView = [[UIImageView alloc]  initWithFrame:CGRectMake(132, 25, 16, 16)];
    self.hsbImageView.image = [UIImage imageNamed:@"gy_he_coin_icon"];
    [self.headerView addSubview:self.hsbImageView];
    
    //互生币文字
    self.hsbLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.hsbImageView.right + 6, self.hsbImageView.frame.origin.y, self.headerView.width - self.hsbImageView.right - 6 , 16)];
    self.hsbLabel.textAlignment = NSTextAlignmentLeft;
    self.hsbLabel.textColor = UIColorFromRGB(0xff5000);
    self.hsbLabel.font =  [UIFont systemFontOfSize:16];
    [self.headerView addSubview:self.hsbLabel];
    
    
    self.hsbLabel.text = [GYUtils formatCurrencyStyle:[self.model.price doubleValue]];
    
    //积分图片
    UIImageView *pvImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.hsbImageView.frame.origin.x, self.hsbImageView.bottom + 5, 16, 16)];
    pvImageView.image = [UIImage imageNamed:@"gy_he_pv_icon"];
    [self.headerView addSubview:pvImageView];
    
    //积分文字
    self.pvLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.hsbLabel.frame.origin.x, pvImageView.frame.origin.y, self.hsbLabel.width, 16)];
    self.pvLabel.textColor = UIColorFromRGB(0x1d7dd6);
    self.pvLabel.textAlignment = NSTextAlignmentLeft;
    self.pvLabel.font = [UIFont systemFontOfSize:16];
    [self.headerView addSubview:self.pvLabel];
    
    
    self.pvLabel.text = [GYUtils formatCurrencyStyle:[self.model.pv doubleValue]];
    
    //商品属性
    self.attributeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.hsbImageView.frame.origin.x, pvImageView.bottom + 5, self.headerView.width - self.hsbImageView.frame.origin.x  -10, self.headerView.height -pvImageView.bottom - 5 )];
    self.attributeLabel.font = [UIFont systemFontOfSize:14];
    self.attributeLabel.numberOfLines = 0;
    self.attributeLabel.textColor = UIColorFromRGB(0x00101e);
    self.attributeLabel.textAlignment = NSTextAlignmentLeft;
    [self.headerView addSubview:self.attributeLabel];
    
    NSString *attStr = kLocalized(@"GYHE_Good_Select");
    NSInteger flag = 0;//标记  如果flag = self.sectionDataSource.count 则每一段商品属性都已默认选中
    for (NSInteger i = 0; i<self.sectionMarr.count; i++) {
        
        //此处是为了 当某一段的商品属性只有一个属性时，让其默认选择状态
        BOOL isExist = NO;
        if (self.selectIndexPath.count != 0) {
            for (NSIndexPath *index in self.selectIndexPath) {
                if (index.section == i) {
                    isExist = YES;
                    flag ++;
                }
            }
        }
        
        if (isExist) {
            continue;
        }
        
        attStr = [NSString stringWithFormat:@"%@ %@",attStr,self.sectionMarr[i]];
    }
    
    if (flag == self.sectionMarr.count) {
        NSString *selectStr = kLocalized(@"GYHE_Good_Did_Select");
        for (NSInteger i = 0; i<self.sectionMarr.count; i++) {
            selectStr = [NSString stringWithFormat:@"%@ \"%@\"",selectStr,self.skuDataSource[i][0]];
        }
        self.attributeLabel.text = selectStr;
    }else {
        self.attributeLabel.text = attStr;
    }
    
    [self.attributeLabel sizeToFit];
    
    //叉叉按钮
    self.dismissBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissBtn.frame = CGRectMake(self.headerView.width - 5 -24, 5, 24, 24);
    [self.dismissBtn setImage:[UIImage imageNamed:@"gyhe_shop_car_dismiss"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.dismissBtn];
    
}

#pragma mark - getters and setters  
-(UICollectionView *)collectionView {

    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(15, 10, 10, 10);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 245, kScreenWidth, kScreenHeight- 245 -49 -46 ) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColorFromRGB(0xffffff);
        [_collectionView registerClass:[GYHEAddShoppingCarHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGYHEAddShoppingCarHeaderViewIdentifier];
        [_collectionView registerClass:[GYHEAddShoppingCarFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kGYHEAddShoppingCarFooterViewIdentifier];
        [_collectionView registerClass:[GYHEAddShoppingCarCell class] forCellWithReuseIdentifier:kGYHEAddShoppingCarCellIdentifier];
    }
    return _collectionView;
}

-(NSMutableArray *)selectIndexPath {

    if(!_selectIndexPath) {
        _selectIndexPath = [[NSMutableArray alloc] init];
    }
    return _selectIndexPath;
}

-(void)setModel:(GYHEGoodsDetailsModel *)model {

    _model = model;
    [self loadData];

}

@end
