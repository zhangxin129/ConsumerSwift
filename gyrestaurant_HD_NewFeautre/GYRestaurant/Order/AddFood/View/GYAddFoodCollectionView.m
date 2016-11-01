//
//  GYAddFoodCollectionView.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddFoodCollectionView.h"
#import "GYAddFoodCell.h"
#import "GYSyncShopFoodsModel.h"
#import "GYFoodSpecModel.h"
#import "GYTakeOrderTool.h"
@interface GYAddFoodCollectionView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, weak) GYAddFoodCell *cell;
@property (nonatomic, weak) UIView *vPop;
@property (nonatomic, strong) NSMutableArray *arrBtn;
@property (nonatomic, weak) UIView *vback;
@property (nonatomic, strong) GYSyncShopFoodsModel *model;
@property (nonatomic, copy) NSString *identify;
@property (nonatomic, weak) UILabel *lbShowPrice;
@property (nonatomic, weak) UILabel *lbShowAuction;
@property (nonatomic, weak) UIButton *firstButton;
@end
@implementation GYAddFoodCollectionView


#pragma mark - 系统方法
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        
    }
    return self;
}


#pragma mark - 自定义方法
- (void)setup
{
    //先实例化一个层
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //创建一屏的视图大小
    UICollectionView *addFoodCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:layout];
    addFoodCollectionView.delegate = self;
    addFoodCollectionView.dataSource = self;
    addFoodCollectionView.backgroundColor = [UIColor clearColor];
    [addFoodCollectionView registerClass:[GYAddFoodCell class] forCellWithReuseIdentifier :_CELL ];
    [self addSubview:addFoodCollectionView];
    self.addFoodCollectionView = addFoodCollectionView;
}

#pragma mark - UICollectionViewDataSource

//定义展示的Section的个数

- (NSInteger)numberOfSectionsInCollectionView:( UICollectionView *)collectionView

{
    return 1 ;
}


//定义展示的UICollectionViewCell的个数

- (NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section

{
    return self.mdataSource.count;
}

//每个UICollectionView展示的内容

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYSyncShopFoodsModel *model = self.mdataSource[indexPath.row];
    GYAddFoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
    cell.model = model;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小

- (CGSize)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath

{
    return CGSizeMake ( (kScreenWidth - 80) / 5 , (kScreenHeight - 64 - 30 - 40 - 20) / 2 );
}

//定义每个UICollectionView 的边距

- (UIEdgeInsets)collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section

{
    return UIEdgeInsetsMake ( 20 , 20 , 0 , 20 );
}



#pragma mark - UICollectionViewDelegate

//UICollectionView被选中时调用的方法

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    
    
    GYSyncShopFoodsModel *model = self.mdataSource[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(GYAddFoodCollectionViewCellDidClick)]   ){
        [self.delegate GYAddFoodCollectionViewCellDidClick];
    }
    
    if (model.foodSpec.count > 0){
        [self popView:model];
        return;
    }
    
    [self getChangCountWith:model];

 
}



#pragma mark - popView
- (void)popView:(GYSyncShopFoodsModel *)model
{
    
    self.model = model;
    UIWindow *win = [UIApplication sharedApplication].keyWindow;
    
    UIView *vback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    vback.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    
    [win addSubview:vback];
    self.vback = vback;
    
    UIView *vPop = [[UIView alloc]init];
    vPop.frame = CGRectMake((self.vback.frame.size.width - 500) / 2, (self.vback.frame.size.height - 200) / 2, 500, 200);
    vPop.backgroundColor = [UIColor whiteColor];
    [self.vback addSubview:vPop];
    self.vPop = vPop;
    
    UILabel *lbFoodName = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, vPop.frame.size.width, 40)];
    
    lbFoodName.text = [NSString stringWithFormat:@"    %@",model.foodName];
    lbFoodName.textAlignment = NSTextAlignmentLeft;
    lbFoodName.textColor = [UIColor darkGrayColor];
    lbFoodName.font = [UIFont systemFontOfSize:20.0];
    lbFoodName.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0];
    lbFoodName.textColor = [UIColor darkGrayColor];
    [vPop addSubview:lbFoodName];
    
    UIButton *btnRemove = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRemove.frame = CGRectMake(vPop.frame.size.width - 40 , 0, 40, 40);
    [btnRemove setBackgroundImage:[UIImage imageNamed:@"remove.png"] forState:UIControlStateNormal];
    [btnRemove addTarget:self action:@selector(removeClick) forControlEvents:UIControlEventTouchUpInside];
    [vPop addSubview:btnRemove];
    
    UILabel *lbSpecifications = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 100, 40)];
    lbSpecifications.text = kLocalized(@"Specification");
    lbSpecifications.textColor = [UIColor darkGrayColor];
    lbSpecifications.textAlignment = NSTextAlignmentCenter;
    lbSpecifications.font = [UIFont systemFontOfSize:25.0];
    [vPop addSubview:lbSpecifications];
    self.arrBtn = [NSMutableArray array];
    
    NSArray *arrSpecifications = model.foodSpec;
    
    GYFoodSpecModel *fsModel = nil;
    
    for (int i = 0 ; i < arrSpecifications.count ; i ++) {
        
        fsModel = arrSpecifications[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(100 + 100 * i, 60, 100, 40);
        btn.tag = i + 100;
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:25.0];
        [btn setTitle:[NSString stringWithFormat:@"%@",fsModel.pVName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addFoodchooseSpecifications:) forControlEvents:UIControlEventTouchUpInside];
        [self.arrBtn addObject:btn];
        [vPop addSubview:btn];
        if (i == 0) {
            self.firstButton = btn;
        }
    }

    UIImageView *imgPrice = [[UIImageView alloc]initWithFrame:CGRectMake(25, 130, 25, 25)];
    imgPrice.image = [UIImage imageNamed:@"currency"];
    [vPop addSubview:imgPrice];
    
    UILabel *lbShowPrice = [[UILabel alloc]initWithFrame:CGRectMake(55, 120, 70, 40)];
    lbShowPrice.text = [NSString stringWithFormat:@"%@",fsModel.price];
    lbShowPrice.textColor = kRedFontColor;
    lbShowPrice.textAlignment = NSTextAlignmentCenter;
    lbShowPrice.font = [UIFont systemFontOfSize:20.0];
    [vPop addSubview:lbShowPrice];
    self.lbShowPrice = lbShowPrice;
    
    
    UIImageView *imgAuction = [[UIImageView alloc]initWithFrame:CGRectMake(170, 130, 35, 20)];
    imgAuction.image = [UIImage imageNamed:@"PV"];
    [vPop addSubview:imgAuction];
    
    UILabel *lbShowAuction = [[UILabel alloc]initWithFrame:CGRectMake(200, 120, 70, 40)];
    lbShowAuction.textColor = kBlueFontColor;
    lbShowAuction.textAlignment = NSTextAlignmentCenter;
    lbShowAuction.font = [UIFont systemFontOfSize:20.0];
    [vPop addSubview:lbShowAuction];
    self.lbShowAuction = lbShowAuction;
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(335, 160, 30, 30);
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"plus"] forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(addFoodAAAAA) forControlEvents:UIControlEventTouchUpInside];
    [vPop addSubview:btnAdd];
    [self addFoodchooseSpecifications:self.firstButton];
}

-(void)setMdataSource:(NSArray *)mdataSource
{
    _mdataSource = mdataSource;
  
    [self.addFoodCollectionView reloadData];
}

- (void) addFoodchooseSpecifications:(UIButton *)btn
{
    int index = (int)btn.tag;
    
    
    GYFoodSpecModel *model = self.model.foodSpec[index - 100];
    self.identify = model.identify;
    self.lbShowPrice.text = [NSString stringWithFormat:@"%.2f",model.price.floatValue];
    self.lbShowAuction.text = [NSString stringWithFormat:@"%.2f",model.auction.floatValue];
    for (UIButton *tempBtn in self.arrBtn) {
        if (tempBtn.tag == index) {
            [btn.layer setMasksToBounds:YES];
            [btn.layer setBorderWidth:1.0];
            [btn.layer setBorderColor:kRedFontColor.CGColor];
        }else{
            [tempBtn.layer setBorderWidth:0];
        }
    }
    
}



- (void)addFoodAAAAA
{
 
    int maxFood = [(NSString *)kGetNSUser(@"maxFood")   intValue];
    if (self.model.selected[self.identify]) {
        int num = [self.model.selected[self.identify] intValue];
        num += 1;
        if (num == maxFood + 1) {
            num = 0;
        }
        self.model.selected[self.identify] = @(num);
    }else{
        [self.model.selected addEntriesFromDictionary:@{self.identify:@1}];
        
    }
    
    [GYTakeOrderTool saveModelWithModel:self.model];
        [[NSNotificationCenter defaultCenter]postNotificationName:GYAddFoodCollecionViewChangeNotification object:nil];
 
}

- (void) removeClick
{
    
    [self.vback removeFromSuperview];
    [self.vPop removeFromSuperview];
    
}
- (void)getChangCountWith:(GYSyncShopFoodsModel *)model
{
    
    //如果大于最大的数量就置0
    NSInteger maxFood = [(NSString *)kGetNSUser(@"maxFood")   intValue];
    
    
    if (model.selected[model.foodId]) {
        NSInteger num = [model.selected[model.foodId] integerValue];
        num += 1;
        if (num  == maxFood + 1) {
            num = 0;
        }
        model.selected[model.foodId] = @(num);
    }else{
        [model.selected addEntriesFromDictionary:@{model.foodId:@1}];
        
    }
    
    [GYTakeOrderTool saveModelWithModel:model];
    //通知 左上角按钮 右下角按钮 还有点菜主界面
    [[NSNotificationCenter defaultCenter] postNotificationName:GYAddFoodCollecionViewChangeNotification object:nil userInfo:nil];

}


@end
