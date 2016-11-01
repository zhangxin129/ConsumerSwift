//
//  GYAddedMenuViewController.m
//  GYRestaurant
//
//  Created by apple on 15/10/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddedMenuViewController.h"
#import "GYAddFoodShowCell.h"
#import "GYAddFoodShowCellPro.h"
#import "GYFoodSpecModel.h"
#import "GYOrderInDetailViewController.h"
#import "GYPicUrlModel.h"
#import "GYFoodSpecModel.h"
#import "GYAddFoodViewModel.h"
#import "GYSyncShopFoodsModel.h"
#import "NSObject+HXAddtions.h"
#import "GYTakeOrderTool.h"
@interface GYAddedMenuViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tbvAddMenu;
@property (nonatomic, weak) GYAddFoodShowCell *cell;
@property (nonatomic, weak) UILabel *lbShowPrice;
@property (nonatomic, weak) UILabel *lbShowNumber;
@property (nonatomic, weak) UILabel *lbShowTotalPrice;
@property (nonatomic, weak) UILabel *lbShowPV;
@property (nonatomic, strong) NSMutableArray *arrBtn;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation GYAddedMenuViewController


#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initDeal];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(takeCount) name:GYAddFoodChangeNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    globalData.pop = YES;
    
}

#pragma mark -  数据源
/**
 *  初始化界面的订单相关参数
 */
- (void)initDeal
{
    
    NSMutableArray *arr = [NSMutableArray array];
    for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
        if (model.foodSpec.count > 0) {
            
            for (GYFoodSpecModel *m in model.foodSpec) {
                if ([model.selected[m.identify] intValue] > 0) {
                    m.pName = model.foodName;
                    m.picUrl = model.picUrl;
                    [arr addObject:m];
                }
            }
            
        }else if(model.foodSpec.count == 0) {
            
            if ([model.selected[model.foodId] intValue] > 0) {
                [arr addObject:model];
                
            }
        }
    }
    
    self.dataSource = arr;
    [self takeCount];
    
}

- (void)takeCount
{
    
    int totalNum = 0;
    float totalFoodPv = 0;
    float totalFoodPrice = 0;
    NSMutableArray *arr = [NSMutableArray array];
    for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
        if (model.selected.count > 0) {
            [arr addObject:model];
        }
    }
    for (GYSyncShopFoodsModel *model in arr) {
        totalNum = [GYTakeOrderTool getTakeListNum];
        
        if (model.foodSpec.count > 0) {
            for (GYFoodSpecModel *m in model.foodSpec ) {
                if ([model.selected[m.identify] intValue] > 0) {
                    totalFoodPrice += [model.selected[m.identify] intValue] * m.price.floatValue;
                    totalFoodPv += [model.selected[m.identify] intValue] * m.auction.floatValue;
                }
            }
        }else{
            if ([model.selected[model.foodId] intValue] > 0) {
                totalFoodPrice += [model.selected[model.foodId] intValue] * model.foodPrice.floatValue;
                totalFoodPv += [model.selected[model.foodId] intValue] * model.foodPv.floatValue;;
            }}
    }
    
    totalFoodPrice = roundf(totalFoodPrice *10);
    totalFoodPrice = totalFoodPrice*.1;
    self.lbShowTotalPrice.text = [NSString stringWithFormat:@"%.2f",totalFoodPrice];
    self.lbShowPV.text = [NSString stringWithFormat:@"%.2f",totalFoodPv];
    self.lbShowNumber.text = [NSString stringWithFormat:@"%d",totalNum];
}

#pragma mark - 创建视图
- (void)initUI
{
    UIButton *gybtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gybtn.frame = CGRectMake(0, 0, 150, 140);
    [gybtn setImage:[UIImage imageNamed:@"40back"] forState:UIControlStateNormal];
    [gybtn setImage:[UIImage imageNamed:@"40back+"] forState:UIControlStateHighlighted];
    [gybtn setTitle:kLocalized(@"AddedMenu") forState:UIControlStateNormal];
    [gybtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [gybtn addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
    gybtn.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 120);
    gybtn.titleLabel.font = [UIFont systemFontOfSize:kBackFont];
     UIBarButtonItem *bbiTitle = [[UIBarButtonItem alloc] initWithCustomView:gybtn];
    
    UILabel *lbOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(136, 20, 80, 44)];
    lbOrderNumber.font = [UIFont systemFontOfSize:20.0];
    lbOrderNumber.text = kLocalized(@"ordernumber");
    lbOrderNumber.textColor = [UIColor lightGrayColor];
    lbOrderNumber.textAlignment = NSTextAlignmentRight;
    UIBarButtonItem *blbOrderNumber = [[UIBarButtonItem alloc] initWithCustomView:lbOrderNumber];
    
    UILabel *lbShowOrderNumber = [[UILabel alloc] initWithFrame:CGRectMake(216, 20, 310, 44)];
    lbShowOrderNumber.font = [UIFont systemFontOfSize:20.0];
    lbShowOrderNumber.text = self.orderId;
    lbShowOrderNumber.textColor = [UIColor lightGrayColor];
    lbShowOrderNumber.textAlignment = NSTextAlignmentLeft;
    UIBarButtonItem *blbShowOrderNumber = [[UIBarButtonItem alloc] initWithCustomView:lbShowOrderNumber];
    
    self.navigationItem.leftBarButtonItems = @[bbiTitle,blbOrderNumber,blbShowOrderNumber];
    [self initTableView];
    [self bottomView];
}

#pragma mark - 初始化bottomView

- (void)bottomView
{
    UIView *vBottom = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(self.tbvAddMenu.frame), kScreenWidth, 80)];
    [self.view addSubview:vBottom];
    
    UIButton *btnPlaceOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPlaceOrder.frame = CGRectMake(kScreenWidth / 2 - 60, 20, 120, 40);
    [btnPlaceOrder setTitle:kLocalized(@"ConfirmAddDish") forState:UIControlStateNormal];
    btnPlaceOrder.titleLabel.font = [UIFont systemFontOfSize:25.0];
    [btnPlaceOrder setBackgroundImage:[UIImage imageNamed:@"placeOrder.png"] forState:UIControlStateNormal];
    [btnPlaceOrder addTarget:self action:@selector(confirmOrder:) forControlEvents:UIControlEventTouchUpInside];
    [vBottom addSubview:btnPlaceOrder];
    
    UILabel *lbNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btnPlaceOrder.frame) + 20, 20, 50, 40)];
    lbNumber.textAlignment = NSTextAlignmentCenter;
    lbNumber.font = [UIFont systemFontOfSize:20.0];
    lbNumber.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    lbNumber.text = kLocalizedAddParams(kLocalized(@"Quantity"), @":");
    [vBottom addSubview:lbNumber];
    
    UILabel *lbShowNumber = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbNumber.frame), 20, 40, 40)];
    lbShowNumber.textAlignment = NSTextAlignmentLeft;
    lbShowNumber.font = [UIFont systemFontOfSize:20.0];
    lbShowNumber.textColor = kRedFontColor;
    
    [vBottom addSubview:lbShowNumber];
    self.lbShowNumber = lbShowNumber;
    
    UILabel *lbTotal = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbShowNumber.frame), 20, 60, 40)];
    lbTotal.textAlignment = NSTextAlignmentCenter;
    lbTotal.font = [UIFont systemFontOfSize:20.0];
    lbTotal.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    lbTotal.text = kLocalized(@"lumpsum");
    [vBottom addSubview:lbTotal];
    
    
    UIImageView *imgPrice = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lbTotal.frame), 30, 20, 20)];
    imgPrice.image = [UIImage imageNamed:@"currency.png"];
    [vBottom addSubview:imgPrice];
    
    UILabel *lbShowTotalPrice = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imgPrice.frame), 20, 80, 40)];
    lbShowTotalPrice.textAlignment = NSTextAlignmentLeft;
    lbShowTotalPrice.font = [UIFont systemFontOfSize:20.0];
    lbShowTotalPrice.textColor = kRedFontColor;
    [vBottom addSubview:lbShowTotalPrice];
    self.lbShowTotalPrice = lbShowTotalPrice;
    
    UILabel *lbPV = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 190, 20, 60, 40)];
    lbPV.textAlignment = NSTextAlignmentCenter;
    lbPV.font = [UIFont systemFontOfSize:20.0];
    lbPV.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
    lbPV.text = kLocalizedAddParams(kLocalized(@"Integration"), @":");
    [vBottom addSubview:lbPV];
    
    UIImageView *imgPV = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth - 130, 30, 30, 20)];
    imgPV.image = [UIImage imageNamed:@"PV.png"];
    [vBottom addSubview:imgPV];
    
    UILabel *lbShowPV = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 20, 100, 40)];
    lbShowPV.textAlignment = NSTextAlignmentLeft;
    lbShowPV.font = [UIFont systemFontOfSize:20.0];
    lbShowPV.textColor = kBlueFontColor;
    [vBottom addSubview:lbShowPV];
    self.lbShowPV = lbShowPV;
    
}

- (void)initTableView
{
    UITableView *tbvAddMenu = [[UITableView alloc]initWithFrame:CGRectMake(0, 2,kScreenWidth, kScreenHeight - 80 - 66) style:UITableViewStylePlain];
    tbvAddMenu.delegate = self;
    tbvAddMenu.dataSource = self;
    tbvAddMenu.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [tbvAddMenu registerNib:[UINib nibWithNibName:@"GYAddFoodShowCell" bundle:nil] forCellReuseIdentifier:@"GYAddFoodShowCell"];
//    [tbvAddMenu registerNib:[UINib nibWithNibName:@"GYAddFoodShowCell_Pro" bundle:nil] forCellReuseIdentifier:@"GYAddFoodShowCell_Pro"];
    [self.view addSubview:tbvAddMenu];
    self.tbvAddMenu = tbvAddMenu;
    
}
#pragma mark - pop方法
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**加菜成功时返回*/
- (void)needPop{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    [self popoverPresentationController];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"%ld",indexPath.row];
    GYAddFoodShowCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        
        if (kScreenWidth == 1366) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYAddFoodShowCellPro class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
            [cell setValue:CellIdentifier forKey:@"reuseIdentifier"];
        }else{
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYAddFoodShowCell class])
                                                  owner:self
                                                options:nil] objectAtIndex:0];
            [cell setValue:CellIdentifier forKey:@"reuseIdentifier"];
        }
        
    }
   
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sfModel = self.dataSource[indexPath.row];
    return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *vHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    vHeader.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0];
    
    NSArray *arrLab = @[kLocalized(@"DishesName"),kLocalized(@"Specification"),kLocalized(@"UnitPrice"),kLocalized(@"Integration"),kLocalized(@"Quantity"),kLocalized(@"Operating")];
    
    for (int i = 0; i < 6 ; i ++) {
        UILabel *lb = [[UILabel alloc]init];
        
        lb.tag = i;
        
        lb.frame = CGRectMake(i * (kScreenWidth / 6 - 10) + 80, 0, kScreenWidth / 6 - 10, 50);
        if (i == 0) {
            lb.frame = CGRectMake(30, 0, kScreenWidth / 6 - 10, 50);
        }
        lb.text = [NSString stringWithFormat:@"%@",arrLab[i]];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.font = [UIFont systemFontOfSize:20.0];
        lb.textColor = [UIColor colorWithRed:95.0/255.0 green:93.0/255.0 blue:93.0/255.0 alpha:1.0];
        [vHeader addSubview:lb];
    }
    
    return vHeader;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

#pragma mark  - 按钮的触发事件
- (void) confirmOrder:(UIButton *)button
{
    if ([self.lbShowNumber.text intValue] == 0) {
        [self notifyWithText:kLocalized(@"YourTotalNumberOfFoodToEatToZero, AddTheNumberOfDishes")];
        return;
    }
    [self.view endEditing:YES];
    [self httpAddFoodOrderAddOrderDetail:button];
    
}

#pragma mark - 网络请求
/**
 *  加菜网络请求
 */
- (void)httpAddFoodOrderAddOrderDetail:(UIButton *) button
{
    
    GYAddFoodViewModel *viewModel = [[GYAddFoodViewModel alloc]init];
    __block BOOL show = NO;
    [button controlTimeOut];
    [self modelRequestNetwork:viewModel :^(id resultDic) {
       if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
            if (!show) {
                show = YES;
                [self notifyWithText:kLocalized(@"AddDishesSuccess!")];
                [self performSelector:@selector(needPop) withObject:nil afterDelay:1.5];
            }
    }else if ([resultDic[@"retCode"] isEqualToNumber:@799]){
       [self notifyWithText:kLocalized(@"OrderCheckout, YouCanNotModifyTheOrder!")];
    }else{
    
     [self notifyWithText:kLocalized(@"AddDishesFailure!")];
    
    }
    } isIndicator:YES];

    [viewModel requestAddFoodWithOrderId:self.orderId userId:self.userId];
    
}


@end
