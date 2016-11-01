//
//  GYAddFoodViewController.m
//  GYRestaurant
//
//  Created by apple on 15/10/28.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAddFoodViewController.h"
#import "GYAddedMenuViewController.h"
#import "GYNavBarView.h"
#import "GYAddFoodView.h"
#import "GYAddFoodCollectionView.h"
#import "GYAddFoodCell.h"
#import "GYFoodCategoryListViewModel.h"
#import "NSString+YYAdd.h"
#import "GYSystemSettingViewModel.h"
#import "GYTakeOrderListModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYAddFoodViewModel.h"
#import "GYFoodSpecModel.h"
#import "GYTakeOrderTool.h"
#import "GYPinYinConvertTool.h"
@interface GYAddFoodViewController ()<GYNavBarViewDelegate,GYAddFoodViewDelegate,GYAddFoodCollectionViewDelegate>
@property (nonatomic, weak) GYAddFoodView *vAddFoodViewLeft;
@property (nonatomic, weak) GYAddFoodCollectionView *vAddFoodViewRight;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, weak) GYNavBarView *navBarView;
@property (nonatomic, weak) UILabel *lbNoData;
@end

@implementation GYAddFoodViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    
    [self.vAddFoodViewLeft.btnHeader setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"AddMenu"), @"(%d)"),self.num] forState:UIControlStateNormal];
    [self.vAddFoodViewLeft.btnFooter setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"AddMenu"), @"(%d)"),0] forState:UIControlStateNormal];
    
    [self.vAddFoodViewLeft.btnFooter setTitle:[NSString stringWithFormat:kLocalizedAddParams(kLocalized(@"AddMenu"), @"(%d)"),0] forState:UIControlStateNormal];
    
    [self httpTakeOrderGetShopsSyncShopFoods];
    [self httpTakeOrderGetFoodCategoryList];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self GYAddFoodViewRowAtIndexPath:index];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:GYAddFoodChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:GYAddFoodCollecionViewChangeNotification object:nil];
    
//     self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"AddMenu") withTarget:self withAction:@selector(popBack)];
    
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYAddFoodCollecionViewChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYAddFoodChangeNotification object:nil];
}

-  (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
    globalData.pop = YES;
  
}

#pragma mark - 创建视图
/**
 *  初始化界面
 */
- (void)initUI
{
    //创建navBarView
    GYNavBarView *navBarView =[[GYNavBarView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
    navBarView.lbShowOrderNumber.text = self.orderId;
    navBarView.lbShowOrderPrice.text = self.totalAmount;
    navBarView.delegate = self;
    [self.view addSubview:navBarView];
    self.navBarView = navBarView;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 1)];
    lineView.backgroundColor=kRedFontColor;
    [self.view addSubview:lineView];
    
    //创建vAddFoodView
    GYAddFoodView *vAddFoodViewLeft = [[GYAddFoodView alloc]initWithFrame:CGRectMake(0, 65, 180, kScreenHeight - 65)];
    vAddFoodViewLeft.delegate = self;
    [self.view addSubview:vAddFoodViewLeft];
    self.vAddFoodViewLeft = vAddFoodViewLeft;
    
    GYAddFoodCollectionView *vAddFoodViewRight = [[GYAddFoodCollectionView alloc]initWithFrame:CGRectMake(180, 65, kScreenWidth - 180,kScreenHeight - 66 - 30)];
    [self.view addSubview:vAddFoodViewRight];
    self.vAddFoodViewRight = vAddFoodViewRight;
    vAddFoodViewRight.delegate = self;


}

- (void)GYAddFoodCollectionViewCellDidClick
{
    
   self.navBarView.lbShowOrderPrice.text = self.totalAmount ;


}


#pragma mark - GYAddFoodViewDelegate
- (void)GYAddFoodViewPushVC:(UIButton *)btn sumCount:(int)sumCount
{
    if (sumCount > 0) {
        GYAddedMenuViewController *amVC = [[GYAddedMenuViewController alloc]init];
        amVC.orderId = self.orderId;
        amVC.userId = self.userId;
        [self.navigationController pushViewController:amVC animated:YES];
    }else{
        [self customAlertView:kLocalized(@"Pleaseselectdishes")];
    }
    
}

- (void)GYAddFoodViewRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.index = indexPath;
    [self refresh];

}

#pragma mark - GYNavBarViewDelegate

- (void)GYNavBarViewAddFood:(UIButton *)button dishNum:(int)disnNum
{
    if (disnNum > 0) {
        [self httpAddFoodOrderAddOrderDetail:button];
    }else{
       
         [self notifyWithText:kLocalizedAddParams(kLocalized(@"Pleaseselectdishes"), @"！")];
    }
    
   
}

/**加菜成功时返回*/
- (void)needPop{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
//    [self popoverPresentationController];
}

#pragma mark - 搜索
- (void)GYNavBarViewAddsearchFoodAAA:(NSString *)searchTFText
{
    if (searchTFText != nil && searchTFText.length > 0) {
        self.arrData = [NSMutableArray array];
        for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
            NSString *pinHeaderStr = [GYPinYinConvertTool chineseConvertToPinYinHead:model.foodName];
            if ([model.foodName containsString:searchTFText] || [pinHeaderStr rangeOfString:searchTFText options:NSCaseInsensitiveSearch].location !=NSNotFound || [model.code isEqualToString:searchTFText]) {
                [self.arrData addObject:model];
            }
            
            if (self.arrData.count > 0) {
                self.vAddFoodViewRight.mdataSource = self.arrData;
                [self.vAddFoodViewRight.addFoodCollectionView reloadData];
            }else{
                self.vAddFoodViewRight.mdataSource = self.arrData;
                [self.vAddFoodViewRight.addFoodCollectionView reloadData];
            }
        }
    }else{
        self.vAddFoodViewRight.mdataSource = [NSMutableArray arrayWithArray:globalData.takeOrderA];
        [self.vAddFoodViewRight.addFoodCollectionView reloadData];
    }
}

- (void)GYNavBarViewpopBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mrk -- 网络请求
/**
 *  请求菜品分类列表
 */
-(void)httpTakeOrderGetFoodCategoryList
{
    GYSystemSettingViewModel *list = [[GYSystemSettingViewModel alloc]init];
    NSArray *arr = (NSArray *)[list readFromPath:@"getFoodCategoryList"];
    
    if (arr.count > 0 ) {
        
        self.vAddFoodViewLeft.dataSource = arr;
        
        
    }else {
        
        [self modelRequestNetwork:list :^(id resultDic) {
            
            self.vAddFoodViewLeft.dataSource = (NSArray *)resultDic;
            
        }  isIndicator:YES];
        
      
        
        [list getFoodCategoryList];
    }
}
/**
 *  请求菜品列表
 */
- (void)httpTakeOrderGetShopsSyncShopFoods
{
    GYSystemSettingViewModel *fclist = [[GYSystemSettingViewModel alloc]init];
    
    NSMutableArray *arr = (NSMutableArray *)[fclist readFromPath:@"foodsList"];
    NSMutableArray *takeOrderM = [NSMutableArray array];
    if (arr.count > 0) {
        self.vAddFoodViewRight.mdataSource = arr;
        
        NSMutableArray *takeOrderM = [NSMutableArray array];
        for (GYSyncShopFoodsModel *model in arr) {
            model.selected = [NSMutableDictionary dictionary];
            [takeOrderM addObject:model];
        }
        
        globalData.takeOrderA = takeOrderM;
        [self.vAddFoodViewRight.addFoodCollectionView reloadData];
        self.lbNoData.hidden = YES;
        
    }else if (arr.count == 0){
        [self modelRequestNetwork:fclist :^(id resultDic) {
            
            self.vAddFoodViewRight.mdataSource = (NSMutableArray *)resultDic;
            
            for (GYSyncShopFoodsModel *model in  self.vAddFoodViewRight.mdataSource) {
                model.selected = [NSMutableDictionary dictionary];
                [takeOrderM addObject:model];
            }
            
            globalData.takeOrderA = takeOrderM;
     
            [self.vAddFoodViewRight.addFoodCollectionView reloadData];
            if (takeOrderM.count == 0) {
                
                UILabel *lbNoData = [[UILabel alloc]init];
                lbNoData.text = kLocalized(@"NoRelatedData");
                lbNoData.backgroundColor = [UIColor clearColor];
                lbNoData.font = [UIFont systemFontOfSize:20.0];
                lbNoData.textColor = [UIColor darkGrayColor];
                lbNoData.textAlignment = NSTextAlignmentCenter;
                [self.view addSubview:lbNoData];
                lbNoData.frame =  CGRectMake(kScreenWidth * 0.5 - 50, kScreenHeight * 0.4 , 200, 30);
                [self.view bringSubviewToFront:lbNoData];
                self.lbNoData = lbNoData;
            }
          
        } isIndicator:YES];
        
        [fclist getSyncShopFoods];

    }
    
   
}

/**
 *  加菜请求
 */

- (void)httpAddFoodOrderAddOrderDetail:(UIButton *)button
{
    
    GYAddFoodViewModel *viewModel = [[GYAddFoodViewModel alloc]init];
    __block BOOL show = NO;
    [button controlTimeOut];
    [self modelRequestNetwork:viewModel :^(id resultDic) {
        
            if ([resultDic[@"retCode"] isEqualToNumber:@200]) {
                [GYTakeOrderTool reloadTabkeOrderList];
                if (!show) {
                    show = YES;
                    [self notifyWithText:kLocalized(@"AddDishesSuccess!")];
                    [self performSelector:@selector(needPop) withObject:nil afterDelay:1.5];
                }
            }else if ([resultDic[@"retCode"] isEqualToNumber:@779]){
            [self notifyWithText:kLocalized(@"OrderCheckout, YouCanNotModifyTheOrder!")];
            
            }else{
                [self customAlertView:kLocalized(@"AddDishesFailure!")];
            
            }
       } isIndicator:YES];
    
    [viewModel requestAddFoodWithOrderId:self.orderId userId:self.userId];
}
#pragma mark - 数据源
- (void)refresh
{
    NSMutableArray *dataS = [NSMutableArray array];
    NSMutableArray *arrM = globalData.takeOrderA;
    GYTakeOrderListModel * tolModel = self.vAddFoodViewLeft.dataSource[self.index.row];
    
    if ([tolModel.itemCustomCategoryName isEqualToString:kLocalized(@"All")]) {
        self.vAddFoodViewRight.mdataSource = arrM;
        return;
    }
    for (GYSyncShopFoodsModel *model in arrM) {
        
        if ([tolModel.itemFoodIdList containsObject:model.foodId]) {
            [dataS addObject:model];
        }
    }
    self.vAddFoodViewRight.mdataSource = nil;
    self.vAddFoodViewRight.mdataSource = dataS;
    
    if (self.vAddFoodViewRight.mdataSource.count == 0) {
        self.lbNoData.hidden = NO;
    }else {
        self.lbNoData.hidden = YES;
    }
    
}


@end
