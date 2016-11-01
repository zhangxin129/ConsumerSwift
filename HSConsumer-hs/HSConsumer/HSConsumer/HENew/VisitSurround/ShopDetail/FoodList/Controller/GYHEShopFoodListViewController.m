//
//  GYHEShopFoodListViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodListViewController.h"
#import "GYHETools.h"
#import "Masonry.h"
#import "GYHEShopFoodListCell.h"
#import "GYHEShopFoodListModel.h"
#import "GYShopFoodDetailViewController.h"
#import "GYShopFoodDetailView.h"
#import "GYHEShopFoodCartView.h"
#import "GYHEShopFoodOrderViewController.h"
#import "GYHEShopFoodListKindOfTypeCell.h"
#import "GYHEShopDetailViewController.h"
#import "GYHEShopDetailGoodListModel.h"

#define kGYHEShopFoodListCell @"GYHEShopFoodListCell"
#define kGYHEShopFoodListKindOfTypeCell @"GYHEShopFoodListKindOfTypeCell"
#define kGYHEShopMainCell @"UITableViewCell"

#define kPageKey @"currentPage"
#define kPageKeyIntValue [kSaftToNSString([self.dataDict valueForKey:kPageKey]) intValue]
#define kDataDictKey [NSString stringWithFormat:@"%ld",_selectIndex]

@interface GYHEShopFoodListViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,GYHEShopFoodsListFooterViewDelegate>

@property (nonatomic ,strong)UITableView *tabView;
@property (nonatomic, copy)NSString * vShopId;
@property (nonatomic, copy)NSString * categoryId;
@property (nonatomic, copy)NSString * currentPageIndex;
@property (nonatomic, copy)NSString * keyword;
@property (nonatomic ,assign)NSInteger selectIndex;//主菜单选中行

@property (nonatomic ,strong)UITableView *mainTabView;
@property (nonatomic ,strong)GYShopFoodDetailView *popView;

@property (nonatomic ,strong)NSMutableDictionary *dataDict;
@property (nonatomic ,strong)NSMutableArray *titleArr;



@end

@implementation GYHEShopFoodListViewController

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kCellLineGary;
    [self setUI];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_popView dismissView];
    
}

#pragma mark - GYHEShopFoodsListFooterViewDelegate
- (void)showCart:(GYHEShopFoodsListFooterView *)footerView {
    GYHEShopFoodCartView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEShopFoodCartView class]) owner:self options:0][0];
    view.foodCartClearBlock = ^ {
        [_footerView updateType:GYUnSelectedFoodFooterType];
//        [self.cartFoodsDict removeAllObjects];
//        self.countArr = nil;
        [self.tabView reloadData];
    };
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for(NSString *key in self.cartFoodsDict.allKeys) {
//        [arr addObject:self.cartFoodsDict[key]];
//    }
//    view.arr = arr;
    
    [view addToParentVC:self.parentViewController];
}

- (void)payNow:(GYHEShopFoodsListFooterView *)footerView {
    GYHEShopFoodOrderViewController *vc = [[GYHEShopFoodOrderViewController alloc] init];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //子视图到顶了，父视图开始滑动
    if(self.tabView.contentOffset.y < 0) {
        self.tabView.scrollEnabled = NO;
        for(UITableView *tabV in self.parentViewController.view.subviews) {
            if([tabV isKindOfClass:[UITableView class]]) {
                tabV.scrollEnabled = YES;
            }
        }
        
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == _mainTabView) {
        return self.titleArr.count;
    }else {
        NSArray *arr = [self.dataDict valueForKey:kDataDictKey];
        return arr.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == _mainTabView) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopMainCell forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.titleArr.count > indexPath.row) {
            GYHEShopFoodMainCatesListModel *model = self.titleArr[indexPath.row];
            cell.textLabel.textColor = model.isSelected ? UIColorFromRGB(0xff5000): UIColorFromRGB(0x999999);
            cell.textLabel.text = model.name;
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        return cell;
    }else {
        NSArray *arr = [self.dataDict valueForKey:kDataDictKey];
        if(arr.count > indexPath.row) {
            GYHEShopDetailGoodListModel *mod = arr[indexPath.row];
            //多规格
            if(mod.skus.count > 1) {
                
                GYHEShopFoodListKindOfTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodListKindOfTypeCell forIndexPath:indexPath];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                return cell;

            }else {//单规格或没规格，skus至少一个对象
                GYHEShopFoodListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodListCell forIndexPath:indexPath];
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
                if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
                    [cell setLayoutMargins:UIEdgeInsetsZero];
                }
                //单规格个数改变
                WS(weakSelf);
                cell.changeCountBlock = ^(NSString* num) {
                    NSArray *arr = [weakSelf.dataDict valueForKey:kDataDictKey];
                    if(arr.count > indexPath.row) {
                        GYHEShopDetailGoodListModel *mod = arr[indexPath.row];
                        //单规格或没规格
                        if(mod.skus.count == 1) {
                            GYHEShopDetailGoodSkuModel *sonModel = mod.skus.firstObject;
                            sonModel.count = [num integerValue];
                        }
                        
                    }
                    [self updataCart];
                };
                return cell;
            }
            
        }
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(tableView == _mainTabView) {
        if(self.titleArr.count > indexPath.row && self.titleArr.count > _selectIndex) {
            GYHEShopFoodMainCatesListModel *mod = self.titleArr[_selectIndex];
            mod.isSelected = NO;
            
            GYHEShopFoodMainCatesListModel *model = self.titleArr[indexPath.row];
            model.isSelected = YES;
            
            
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section],[NSIndexPath indexPathForRow:_selectIndex inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
            _selectIndex = indexPath.row;

        }
    }else {
        [self showDetailWithIndex:0];
    }
}

#pragma mark - 自定义方法
- (void)getFoodInfo {
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    //商品零售1  信息服务2  外卖送货3
    [paramters setValue:@"3" forKey:@"type"];
    [paramters setValue:_keyword forKey:@"keyword"];
    [paramters setValue:_vShopId forKey:@"vshopId"];
    if(self.titleArr.count > _selectIndex) {
        GYHEShopFoodMainCatesListModel *selectModel = self.titleArr[_selectIndex];
        [paramters setValue:selectModel.id forKey:@"categoryId"];
    }
    [paramters setValue:@"" forKey:@"supportServices"];
    [paramters setValue:@"" forKey:@"city"];
    [paramters setValue:@"" forKey:@"sortType"];
    [paramters setValue:_currentPageIndex forKey:@"currentPageIndex"];
    [paramters setValue:@"10" forKey:@"pageSize"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kGetShopDetailListUrl parameters:paramters requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for(NSDictionary *dict in responseObject[@"data"]) {
            GYHEShopDetailGoodListModel *mod = [[GYHEShopDetailGoodListModel alloc] initWithDictionary:dict error:nil];
            [arr addObject:mod];
        }
        //如果选中主菜单行，显示的子列表有加载过几页
        if([self.dataDict valueForKey:kDataDictKey]) {
            //页数加一
            NSString *currPage = [NSString stringWithFormat:@"%d",kPageKeyIntValue + 1] ;
            [self.dataDict setValue:currPage forKey:kPageKey];
            //数据源拼接
            NSMutableArray *muArr = [self.dataDict valueForKey:kDataDictKey];
            [muArr addObjectsFromArray:arr];
            [self.dataDict setValue:muArr forKey:kDataDictKey];
        }else {
            [self.dataDict setValue:@"1" forKey:kPageKey];
            [self.dataDict setValue:arr forKey:kDataDictKey];

        }        
        [_tabView reloadData];

    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}


- (void)showDetailWithIndex:(NSInteger)index {
    GYShopFoodDetailViewController *vc = [[GYShopFoodDetailViewController alloc] init];
    _popView = [[GYShopFoodDetailView alloc] init];
    [_popView createViewWithVC:vc];
}
//更新购物车角标
- (void)updataCart {
    NSInteger totalCount = 0;
    for(NSString *key in self.dataDict.allKeys) {
        NSArray *arr = [self.dataDict valueForKey:key];
        for(GYHEShopDetailGoodListModel *mod in arr) {
            for(GYHEShopDetailGoodSkuModel *sonModel in mod.skus){
                totalCount += sonModel.count;
            }
        }
    }
    if(totalCount > 0) {
        [_footerView updateType:GYSelectedFoodFooterType];
        
        self.footerView.countLab.text = [NSString stringWithFormat:@"%ld",totalCount];
    }else {
        [_footerView updateType:GYUnSelectedFoodFooterType];
    }
}

- (void)setUI {
    _mainTabView = [[UITableView alloc] init];
    _mainTabView.delegate = self;
    _mainTabView.dataSource = self;
    _mainTabView.rowHeight = 51;
    _mainTabView.tableFooterView = [[UIView alloc] init];
    _mainTabView.separatorColor = kCellLineGary;
    _mainTabView.contentInset = UIEdgeInsetsMake(0, 0, 42 + 49, 0);
    _mainTabView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    if([_mainTabView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_mainTabView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view addSubview:_mainTabView];
    [_mainTabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(77);
        
    }];
    [_mainTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:kGYHEShopMainCell];
    
    
    _tabView = [[UITableView alloc] init];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.rowHeight = 80;
    _tabView.tableFooterView = [[UIView alloc] init];
    _tabView.contentInset = UIEdgeInsetsMake(0, 0, 42 + 49, 0);
    _tabView.separatorColor = kCellLineGary;
    
    [self.view addSubview:_tabView];
    [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.left.equalTo(_mainTabView.mas_right).with.offset(0.5);
        
    }];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodListCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodListCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodListKindOfTypeCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodListKindOfTypeCell];
    [self setFooter];
}
- (void)setFooter {
    UIViewController *vc = self.parentViewController;
    [vc.view addSubview:self.footerView];
    [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-49);
        make.height.mas_equalTo(50);
    }];
    self.footerView.hidden = YES;
}

#pragma mark - setter,getter
- (NSMutableDictionary *)dataDict {
    if(!_dataDict) {
        _dataDict = [[NSMutableDictionary alloc] init];
    }
    return _dataDict;
}

- (NSMutableArray *)titleArr {
    if(!_titleArr) {
        _titleArr = [[NSMutableArray alloc] init];
    }
    return _titleArr;
}

- (GYHEShopFoodsListFooterView *)footerView {
    if(!_footerView) {
        _footerView =
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEShopFoodsListFooterView class]) owner:self options:0][0];
        [_footerView updateType:GYUnSelectedFoodFooterType];
        _footerView.delegate = self;
        _footerView.freeShippingPrice = 2;
    }
    return _footerView;
}

- (void)setCustomCateInfo:(NSDictionary *)customCateInfo {
    
    if(customCateInfo) {
        _customCateInfo = customCateInfo;
        NSDictionary *dict = [_customCateInfo valueForKey:@"512"];
        NSArray * cates = dict[@"cates"];
        
        for(int i = 0;i < cates.count; i ++) {
            NSDictionary *dic = cates[i];
            GYHEShopFoodMainCatesListModel *model = [[GYHEShopFoodMainCatesListModel alloc] initWithDictionary:dic error:nil];
            if(i == 0) {
                model.isSelected = YES;
            }
            [self.titleArr addObject:model];
        }
        GYHEShopDetailViewController *vc = (GYHEShopDetailViewController *)self.parentViewController;
        _vShopId = vc.vShopId;
        _currentPageIndex = @"1";
        _keyword = @"";
        _selectIndex = 0;
        [self getFoodInfo];
    }
}

@end
