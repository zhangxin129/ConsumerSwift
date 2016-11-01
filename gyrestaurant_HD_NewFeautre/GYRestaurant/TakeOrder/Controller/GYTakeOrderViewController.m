//
//  GYTakeOrderViewController.m
//  GYRestaurant
//
//  Created by kuser on 15/10/9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYTakeOrderViewController.h"
#import "GYTakeOrderListModel.h"
#import "GYFoodCategoryListViewModel.h"
#import "GYFoodActeGoryListView.h"
#import "GYSyncShopFoodsCell.h"
#import "GYSyncShopFoodsCollectionView.h"
#import "GYSinglePointViewController.h"
#import "GYSystemSettingViewModel.h"
#import "NSString+YYAdd.h"
#import "GYTakeOrderTool.h"
#import "GYPinYinConvertTool.h"

@interface GYTakeOrderViewController ()<GYFoodActeGoryListViewDelegate,UITextFieldDelegate,UISearchBarDelegate>
@property (nonatomic, strong) GYSyncShopFoodsCell *cell;
@property (nonatomic, strong) GYFoodActeGoryListView *vOrderList;
@property (nonatomic, strong) GYSyncShopFoodsCollectionView *collectionView;
@property (nonatomic, weak) UITextField *searchTF;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *arrData;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) UILabel *noResultLable;
@end

@implementation GYTakeOrderViewController

#pragma mark - 系统方法
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
   //默认选中全部
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self GYFoodActeGoryListViewRowAtIndexPath:index];
    self.noResultLable = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 75, kScreenHeight/2 - 150, 150, 30)];
    self.noResultLable.text = kLocalized(@"NoDataDishes");
    self.noResultLable.font = [UIFont systemFontOfSize:25];
    self.noResultLable.textColor = [UIColor lightGrayColor];
    self.noResultLable.textAlignment = NSTextAlignmentLeft;
    self.noResultLable.hidden = YES;
    [self.view addSubview:self.noResultLable];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!globalData.pop) {
     [self httpTakeOrderGetShopsSyncShopFoods];
     [self httpTakeOrderGetFoodCategoryList];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:GYSinglePointCellDeleteNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:GYTakeOrderSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:GYSyncShopFoodsCellNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:GYFoodActeGoryListHeaderClickNotification object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
#pragma mark - 创建视图

/**
 *  初始化视图
 */
- (void)initUI
{
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"Menu") withTarget:self withAction:@selector(popBack)];
    
    UIImageView *imgViewLine = [[UIImageView alloc]init];
    imgViewLine.image = [UIImage imageNamed:@"redline.png"];
    [self.view addSubview:imgViewLine];
    [imgViewLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0);
        make.width.equalTo(@(kScreenWidth));
        make.height.equalTo(@(2));
    }];

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 40)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = kLocalized(@"Pleaseenteraproductnameorphoneticcode");
    self.searchBar.returnKeyType = UIReturnKeySearch;
    self.searchBar.layer.masksToBounds = YES;
    self.searchBar.layer.borderWidth = 1;
    self.searchBar.layer.borderColor = kBlueFontColor.CGColor;
    [self.view addSubview:self.searchBar];
    
    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    self.navigationItem.rightBarButtonItem = bbiRight;

    [self initView];

    [self initCollectionView];
    
}
/**
 *  初始化左侧菜品视图
 */
- (void)initView
{
    self.vOrderList = [[GYFoodActeGoryListView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth * 0.15 , kScreenHeight - 64 - 2)];
    self.vOrderList.delegate = self;
    [self.view addSubview:self.vOrderList];
    [self.vOrderList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(2);
        make.width.equalTo(@(kScreenWidth *0.15));
        make.height.equalTo(@(kScreenHeight - 64));
    }];
}


/**
 *  初始化右侧collectionView
 */
- (void)initCollectionView
{
    //先实例化一个层
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建一屏的视图大小
    self.collectionView = [[GYSyncShopFoodsCollectionView alloc]initWithFrame:CGRectMake(kScreenWidth * 0.15, 2, kScreenWidth - kScreenWidth * 0.15,kScreenHeight - 66 - 30) collectionViewLayout:layout];
    [self.collectionView registerClass:[GYSyncShopFoodsCell class] forCellWithReuseIdentifier :_CELL ];
    [self.view addSubview:self.collectionView];
    self.collectionView.mdataSource = nil;
    //    self.collectionView.alwaysBounceVertical = YES;
    
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(2);
        make.left.equalTo(self.view.mas_left).offset(kScreenWidth *0.15);
        make.width.equalTo(@(kScreenWidth - kScreenWidth *0.15));
        make.height.equalTo(@(kScreenHeight - 66 - 30));
    }];
}

#pragma mark - UISearchBar的代理方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *searchStr = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.arrData = [NSMutableArray array];
        if (searchStr != nil && searchStr.length > 0) {
            
            for (GYSyncShopFoodsModel *model in globalData.takeOrderA) {
                NSString *pinHeaderStr = [GYPinYinConvertTool chineseConvertToPinYinHead:model.foodName];
                if ([model.foodName containsString:searchStr] || [pinHeaderStr rangeOfString:searchStr options:NSCaseInsensitiveSearch].location !=NSNotFound || [model.code isEqualToString:searchStr]){
                    [self.arrData addObject:model];
                    
                }
            }
            if (self.arrData.count == 0) {
                
                self.collectionView.hidden = YES;
                self.noResultLable.hidden = NO;
            }
            
            if (self.arrData.count > 0) {
                self.collectionView.hidden = NO;
                self.noResultLable.hidden = YES;
                self.collectionView.mdataSource = self.arrData;
                [self.collectionView reloadData];
            }
            
        }else{
            
            self.collectionView.mdataSource = [NSMutableArray arrayWithArray:globalData.takeOrderA];
            [self.collectionView reloadData];
            
        }
        
   
}

/**
 *  返回上一层控制器
 */
- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 网络请求
/**
 *  请求菜品分类列表
 */
- (void)httpTakeOrderGetFoodCategoryList
{
    
    GYSystemSettingViewModel *list = [[GYSystemSettingViewModel alloc]init];
    NSArray *arr = (NSArray *)[list readFromPath:@"getFoodCategoryList"];
   
    if (arr.count > 0 ) {
        
        self.vOrderList.mdataSource = arr;
        
    }else {
    
        [self modelRequestNetwork:list :^(id resultDic) {
            
            self.vOrderList.mdataSource = (NSArray *)resultDic;
          
        } isIndicator:YES];
        
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
        
        NSMutableArray *takeOrderM = [NSMutableArray array];
        for (GYSyncShopFoodsModel *model in arr) {
            model.selected = [NSMutableDictionary dictionary];
            [takeOrderM addObject:model];
        }
        globalData.takeOrderA = takeOrderM;
          self.collectionView.mdataSource = takeOrderM;
   
        self.noResultLable.hidden = YES;
        
    }else if(arr.count == 0){
    [self modelRequestNetwork:fclist :^(id resultDic) {
        
        for (GYSyncShopFoodsModel *model in resultDic) {
            model.selected = [NSMutableDictionary dictionary];
            [takeOrderM addObject:model];
            
        }
          self.collectionView.mdataSource = (NSMutableArray *)takeOrderM;
        globalData.takeOrderA = takeOrderM;
        if (takeOrderM.count == 0) {

            self.noResultLable.hidden = NO;
        }

    } isIndicator:YES];
    
    [fclist getSyncShopFoods];
        
        
    }
    
}

#pragma mark - 自定义方法
- (void)GYFoodActeGoryListViewPushVC:(UIButton *)btn sumCount:(int)sumCount
{
    if (sumCount > 0) {
        GYSinglePointViewController *spVC = [[GYSinglePointViewController alloc]init];
        
        [self.navigationController pushViewController:spVC animated:YES];
    }else{
       // [self customAlertView:kLocalized(@"Pleaseselectdishes")];
        [self notifyWithText:kLocalized(@"YouHaveNotTakeDishes!")];
    }
    
}

- (void)GYFoodActeGoryListViewRowAtIndexPath:(NSIndexPath *)indexPath
{

    self.collectionView.hidden = NO;
    self.noResultLable.hidden = YES;
    self.index = indexPath;
    self.collectionView.mdataSource = globalData.takeOrderA;
    [self.collectionView reloadData];
    [self refresh];
}

#pragma mark - 数据源
- (void)refresh
{
    NSMutableArray *dataS = [NSMutableArray array];
    NSMutableArray *arrM = globalData.takeOrderA;
    GYTakeOrderListModel * tolModel = self.vOrderList.mdataSource[self.index.row];

    if ([tolModel.itemCustomCategoryName isEqualToString:kLocalized(@"All")]) {
        self.searchTF.text = nil;
        self.collectionView.mdataSource = arrM;
        return;
    }
    for (GYSyncShopFoodsModel *model in arrM) {
        self.searchTF.text = nil;
        if ([tolModel.itemFoodIdList containsObject:model.foodId]) {
            [dataS addObject:model];
        }
    }
    self.collectionView.mdataSource = nil;
    self.collectionView.mdataSource = dataS;
    
    if (self.collectionView.mdataSource.count == 0) {
        
        self.noResultLable.hidden = NO;
       
    }else{
        
        self.noResultLable.hidden = YES;
        
    }
    
}



@end
