//
//  GYQueryViewController.m
//  GYCompany
//
//  Created by apple on 15/9/30.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYQueryViewController.h"

#import "GYQueryView.h"
#import "GYOrderCell.h"
#import "GYListCell.h"
#import "GYUserCell.h"
#import "GYOrderHeaderView.h"
#import "GYListHeaderView.h"
#import "GYUserHeaderView.h"
#import "GYSubmitOrderModel.h"
#import "GYQueryViewModel.h"
#import "GYQueryOrderModel.h"
#import "GYSyncShopFoodsModel.h"
#import "GYSystemSettingViewModel.h"
#import "GYTakeOrderListModel.h"
#import "GYOrderInDetailViewController.h"
#import "GYOrderListModel.h"
#import "GYOutDetailViewController.h"
#import "GYUserInfoModel.h"
#import "GYFoodSpecModel.h"
#import "FoodListInModel.h"
#import "GYOutConfirmViewController.h"
#import "GYOrderTakeOutDetailViewController.h"
#import "GYOutPaidViewController.h"
#import "GYOutCancelViewController.h"
#import "NSString+YYAdd.h"
#import "GYencryption.h"
#import "GYSystemSettingViewModel.h"

@interface GYQueryViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>

@property (nonatomic, strong)GYQueryView *queryView;
@property (nonatomic, strong)NSArray *orderDataArr;//订单数据源
@property (nonatomic, strong)NSArray *foodsDataArr;//菜品数据源
@property (nonatomic, strong)NSMutableArray *userDataArray;//用户数据源
@property (nonatomic, strong)GYQueryOrderModel *queryModel;
@property (nonatomic, strong)NSMutableArray *nameDataArr;
@property (nonatomic, strong)GYUserInfoModel *infoModel;
@property (nonatomic, strong)FoodListInModel *foodModel;
@property (nonatomic, strong)NSMutableArray *foodMarr;
@property (nonatomic, strong) UILabel *noDataLabel;
@property (nonatomic, copy) NSString *roleString;

@end

@implementation GYQueryViewController
#pragma mark -懒加载
-(NSArray *)orderDataArr{
    
    if (!_orderDataArr) {
        _orderDataArr=[[NSArray alloc] init];
    }
    return _orderDataArr;
}

- (NSMutableArray *)foodMarr{
    if (!_foodMarr) {
        _foodMarr = [[NSMutableArray alloc] init];
    }
    return _foodMarr;
}
-(NSArray *)foodsDataArr{
    if (!_foodsDataArr) {
        _foodsDataArr=[[NSArray alloc] init];
    }
    return _foodsDataArr;
}

#pragma mark - 系统方法

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self httpRequestQueryOrder];
    self.navigationController.navigationBarHidden = YES;
    [self httpFoodList];
    [self getfoodsInfo];
    [self httpGetSyncShopFoods];
    [self httpGetFoodCategoryList];
}


-  (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.navigationBarHidden = NO;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    self.noDataLabel = [[UILabel alloc]init];
    self.noDataLabel.frame =  CGRectMake(kScreenWidth/2 - 40, kScreenHeight * 0.5 - 50 , 80, 30);
    self.noDataLabel.text = kLocalized(@"DataIsEmpty");
    self.noDataLabel.backgroundColor = [UIColor clearColor];
    self.noDataLabel.font = [UIFont systemFontOfSize:20.0];
    self.noDataLabel.textColor = [UIColor lightGrayColor];
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    self.noDataLabel.hidden = YES;
    [self.view addSubview:self.noDataLabel];
    [self createView];
    
    self.queryView.selectedIndex = 1;
    [self httpRequestQueryOrder];
    [self.queryView.meunuTableView reloadData];
}

#pragma mark-创建视图

-(void)createView{
    
    
    //创建tableView
    _queryView =[[GYQueryView alloc] initWithFrame:self.view.bounds];
    
    _queryView.meunuTableView.delegate = self;
    _queryView.meunuTableView.dataSource = self;
    
    [self.view addSubview:self.queryView];
    
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, 2)];
    lineView.backgroundColor=kRedFontColor;
    [self.view addSubview:lineView];
    
    
    //注册cell
    [_queryView.meunuTableView registerNib:[UINib nibWithNibName:@"GYOrderCell" bundle:nil] forCellReuseIdentifier:@"cell0"];
    [_queryView.meunuTableView registerNib:[UINib nibWithNibName:@"GYListCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
    [_queryView.meunuTableView registerNib:[UINib nibWithNibName:@"GYUserCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
    
    
    
    //设置点击事件的block
    __weak typeof(self)weakSelf = self;
    _queryView.sendBlock = ^(id sender){
        
        [weakSelf clickAction:sender];
        
    };
    
    _queryView.selectBlock=^(id btn){
        
        [weakSelf btnAction:btn];
        
    };
    
    
}


#pragma mark - 网络请求
/**
 *  查询订单
 */
-(void)httpRequestQueryOrder{
    @weakify(self);
    GYQueryViewModel *viewModel=[[GYQueryViewModel alloc] init];
    NSString *shopId = kGetNSUser(@"shopId");
    if (shopId.length == 0) {
        [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
        return;
    }
    NSDictionary *params = @{@"curPageNo":@"1",
                             //                             @"orderStatusStr":@"10,9,8,7,6,5,4,3,2,1,11,-3,99,-1",
                             @"orderType":@"",
                             @"rows":@"1000",
                             @"shopId":shopId,
                             @"dateStatus":@"1"
                             };
    
    [self modelRequestNetwork:viewModel :^(id resultDic) {
        @strongify(self);
        _orderDataArr=resultDic;
        
        self.noDataLabel.hidden = (self.orderDataArr.count == 0? NO:YES);
        self.queryView.meunuTableView.hidden = !self.noDataLabel.hidden;
        self.queryView.meunuTableView.hidden = NO;
       // self.noDataLabel.hidden = YES;
        [self.queryView.meunuTableView reloadData];
    } isIndicator:YES];
    [viewModel getQueryOrderWithParams:params];
    
}

/**
 *  订单搜索
 */
-(void)httpRequestquery{
    @weakify(self);
    _queryView.searchBlock=^(NSString *orderTypeStr,NSString *searchStr,NSString *dateStr){
        @strongify(self);
        GYQueryViewModel *viewModel=[[GYQueryViewModel alloc] init];
        NSString *shopId = kGetNSUser(@"shopId");
        if (shopId.length == 0) {
            [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
            return;
        }
        NSDictionary *params = @{@"curPageNo":@"1",
                                 @"orderStatusStr":@"10,9,8,7,6,5,4,3,2,1,11,-3,99",
                                 @"dateStatus":dateStr,
                                 @"orderType":orderTypeStr,
                                 @"rows":@"1000",
                                 @"shopId":shopId,
                                 @"resNo":kSaftToNSString(searchStr)
                                 };
        
        [self modelRequestNetwork:viewModel :^(id resultDic) {
            @strongify(self);
            DDLogCInfo(@"queryOrder==========%@",resultDic);
            _orderDataArr=resultDic;
            self.noDataLabel.hidden = (self.orderDataArr.count == 0? NO:YES);
            self.queryView.meunuTableView.hidden = !self.noDataLabel.hidden;
            
            [self.queryView.meunuTableView reloadData];
        } isIndicator:YES];
        
        [viewModel getQueryOrderWithParams:params];
        
    };
    
}
/**
 *  用户信息查询
 */
-(void)httpRequestgetEmployeeAccountList{
    @weakify(self);
    [_userDataArray removeAllObjects];
    NSString *shopId = kGetNSUser(@"shopId");
    if (shopId.length == 0) {
        [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
        return;
    }

    GYQueryViewModel *viewModel=[[GYQueryViewModel alloc] init];
   
    [self modelRequestNetwork:viewModel :^(id resultDic) {
       @strongify(self);
        _userDataArray = resultDic;
        self.noDataLabel.hidden = (self.userDataArray.count == 0? NO:YES);
        self.queryView.meunuTableView.hidden = !self.noDataLabel.hidden;
        self.queryView.meunuTableView.hidden = NO;
        [self.queryView.meunuTableView reloadData];
    } isIndicator:YES];
    [viewModel getEmployeeAccountListWithKey:globalData.loginModel.token andShopId:shopId andEnterpriseResourceNo:globalData.loginModel.entResNo roleId:@"" name:@"" phone:@""];
    _roleString = @"";
}
#pragma mark-点击用户查询按钮发送请求
-(void)httpUserQuery{
    @weakify(self);
    _queryView.userSearchBlock=^(NSString *actorStr,NSString *nameStr,NSString *searchStr){
        @strongify(self);
        _roleString = actorStr;
        GYQueryViewModel *viewModel=[[GYQueryViewModel alloc] init];
        NSString *shopId = kGetNSUser(@"shopId");
        if (shopId.length == 0) {
            [self notifyWithText:kLocalized(@"PleaseSelectTheBusiness")];
           return;
        }
        [self modelRequestNetwork:viewModel :^(id resultDic) {
            @strongify(self);
            _userDataArray = resultDic;
 
                self.noDataLabel.hidden = (self.userDataArray.count == 0? NO:YES);
                self.queryView.meunuTableView.hidden = !self.noDataLabel.hidden;
            
                [self.queryView.meunuTableView reloadData];
        } isIndicator:YES];

        [viewModel getEmployeeAccountListWithKey:globalData.loginModel.token andShopId:shopId andEnterpriseResourceNo:globalData.loginModel.entResNo roleId:actorStr name:nameStr phone:searchStr];
    };
}
/**
 *  查询菜品
 */
- (void)httpFoodList
{
    @weakify(self);
    _foodsDataArr = nil;
    self.queryView.foodsearchBlock=^(NSString *searchStr, NSString *categoryName)
    {
        @strongify(self);
        GYTakeOrderListModel *cateGoryModel =nil;
        if ([searchStr isEqualToString:@""]) {
            GYSystemSettingViewModel *list = [[GYSystemSettingViewModel alloc]init];
            NSArray *arr = (NSArray *)[list readFromPath:@"getFoodCategoryList"];
            
            for (GYTakeOrderListModel *listM in arr) {
                if ([listM.itemCustomCategoryName isEqualToString:categoryName]) {
                    cateGoryModel = listM;
                }
            }
            
            NSArray *arrList  = (NSArray *)[list readFromPath:@"foodsList"];
            NSMutableArray *arrM = [NSMutableArray array];
            
            if ([categoryName isEqualToString:kLocalized(@"All")]) {
                _foodsDataArr = arrList;
                [self.queryView.meunuTableView reloadData];
                return ;
            }else {
                for (GYSyncShopFoodsModel *model1 in arrList) {
                    if ([cateGoryModel.itemFoodIdList containsObject:model1.foodId]) {
                        [arrM addObject:model1];
                    }
                }
                _foodsDataArr = arrM;
                [self.queryView.meunuTableView reloadData];
                return;
            }
        }
        
        else{
            GYSystemSettingViewModel *list = [[GYSystemSettingViewModel alloc]init];
            NSArray *arr = (NSArray *)[list readFromPath:@"getFoodCategoryList"];
            for (GYTakeOrderListModel *listM in arr) {
                if ([listM.itemCustomCategoryName isEqualToString:categoryName]) {
                    cateGoryModel = listM;
                }
            }
            
            NSArray *arrList  = (NSArray *)[list readFromPath:@"foodsList"];
            NSMutableArray *arrM = [NSMutableArray array];
            for (GYSyncShopFoodsModel *foodModel in arrList) {
                if ([foodModel.foodName containsString:searchStr]) {
                    [arrM addObject:foodModel];
                }
            }
            NSMutableArray *finalArrM = [[NSMutableArray alloc]init];
            
            if ([categoryName isEqualToString:kLocalized(@"All")]) {
                _foodsDataArr = arrM;
            }
            else {
                for (GYSyncShopFoodsModel *foodModel in arrM) {
                    for (NSString *itemFoodId in cateGoryModel.itemFoodIdList) {
                        if ([foodModel.foodId isEqualToString:itemFoodId]) {
                            [finalArrM addObject:foodModel];
                        }
                    }
                    
                }
                _foodsDataArr = finalArrM;
            }
            
            
            if (! self.foodsDataArr.count) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:kLocalized(@"prompt") message:kLocalized(@"DataIsEmpty") delegate:self cancelButtonTitle:nil otherButtonTitles:kLocalized(@"Determine"), nil];
                [alertView show];
                
            }
           
            self.queryView.meunuTableView.hidden = NO;
            self.noDataLabel.hidden = YES;
            [self.queryView.meunuTableView reloadData];
            return;
        }
    };
}


#pragma mark-点击按钮的触发事件

-(void)clickAction:(UIButton *)sender{
    
    switch (sender.tag) {
            
            //订单按钮
        case 10:{
            
            self.queryView.selectedIndex = 1;
            [self httpRequestQueryOrder];
            [self httpGetFoodCategoryList];
            [self.queryView.meunuTableView reloadData];
            
        }
            break;
            //菜品按钮
        case 11:{
            
            self.queryView.selectedIndex = 2;
            if (_foodsDataArr.count > 0) {
                self.noDataLabel.hidden = YES;
                self.queryView.meunuTableView.hidden = NO;
                [self.queryView.meunuTableView reloadData];
            }
            [self httpGetSyncShopFoods];
            [self getfoodsInfo];
            [self.queryView.meunuTableView reloadData];
            
        }
            break;
            //用户按钮
        case 102:{
            self.queryView.selectedIndex = 3;
            [self httpRequestgetEmployeeAccountList];
            [self.queryView.meunuTableView reloadData];
            
            
        }
            
            break;
        default:
            break;
    }
}
-(void)btnAction:(UIButton *)btn{
    
    switch (btn.tag) {
        case 1000:
        case 1001:
        case 1005:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1002:{
            //            [self httpRequestQueryOrder];
            //            [self.queryView.meunuTableView reloadData];
        }
            break;
        case 1003:{
            //            [self httpRequestInsideOrder];
            //            [self.queryView.meunuTableView reloadData];
        }
            break;
        case 1004:{
            //            [self httpRequestOutsideOrder];
            //            [self.queryView.meunuTableView reloadData];
        }
            break;
        case 500:{
            
            [self httpRequestquery];
            [_queryView.meunuTableView reloadData];
            
        }
            break;
        case 600:{
            _foodsDataArr = nil;
            [self.queryView.meunuTableView reloadData];
            [self httpFoodList];
            
        }
            break;
            
        case 700:{
            _userDataArray = nil;
            [self httpUserQuery];
            [_queryView.meunuTableView reloadData];
        }
            break;
        default:
            break;
    }
}

/**
 *  获取菜品信息
 */

- (void)getfoodsInfo{
    
    GYQueryViewModel *model = [[GYQueryViewModel alloc]init];
    _foodsDataArr = (NSArray *)[model readFromPath:@"foodsList"];
    if (_foodsDataArr.count == 0) {
        self.noDataLabel.hidden = NO;
    }else if (_foodsDataArr.count > 0){
        self.noDataLabel.hidden = YES;
    
    }
}
- (void)httpGetSyncShopFoods
{
    GYSystemSettingViewModel *setting = [[GYSystemSettingViewModel alloc]init];
    
    [self modelRequestNetwork:setting :^(id resultDic) {

    } isIndicator:YES];
    [setting getSyncShopFoods];
    
}
- (void)httpGetFoodCategoryList
{
    GYSystemSettingViewModel *setting = [[GYSystemSettingViewModel alloc]init];
    
    
    [self modelRequestNetwork:setting :^(id resultDic) {
        
    }isIndicator:YES];
    [setting getFoodCategoryList];
    
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.queryView.selectedIndex == 1) {
        return self.orderDataArr.count;
    }else if(self.queryView.selectedIndex == 2){
        return self.foodsDataArr.count ;
        
    }else{
        return _userDataArray.count ;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.queryView.selectedIndex == 1) {
        
        GYOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
       [cell fillCellWithModel:_orderDataArr[indexPath.row]];
        
        return cell;
    }else if(self.queryView.selectedIndex == 2){
        
        GYListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell fillCellWithModel:_foodsDataArr[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else{
        
        GYUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        _infoModel = _userDataArray[indexPath.row];
        if ([_roleString isEqualToString:@""]) {
            cell.numLable.text = _infoModel.userID;
            cell.nameLable.text = _infoModel.name;
            cell.phoneLable.text = _infoModel.telNumber;
            cell.actorLable.text = _infoModel.roleID;
            cell.stateLable.text = kLocalized(@"Active");

        }else if ([_roleString isEqualToString:@"301"] || [_roleString isEqualToString:@"201"]){
            cell.numLable.text = _infoModel.userID;
            cell.nameLable.text = _infoModel.name;
            cell.phoneLable.text = _infoModel.telNumber;
            cell.actorLable.text = kLocalized(@"SystemAdministrator");
            cell.stateLable.text = kLocalized(@"Active");
        }else if ([_roleString isEqualToString:@"302"] || [_roleString isEqualToString:@"202"]){
            cell.numLable.text = _infoModel.userID;
            cell.nameLable.text = _infoModel.name;
            cell.phoneLable.text = _infoModel.telNumber;
            cell.actorLable.text = kLocalized(@"BusinessPointAdministrator");
            cell.stateLable.text = kLocalized(@"Active");
        }else if ([_roleString isEqualToString:@"303"] || [_roleString isEqualToString:@"203"]){
            cell.numLable.text = _infoModel.userID;
            cell.nameLable.text = _infoModel.name;
            cell.phoneLable.text = _infoModel.telNumber;
            cell.actorLable.text = kLocalized(@"Cashier");
            cell.stateLable.text = kLocalized(@"Active");
        }else if ([_roleString isEqualToString:@"304"] || [_roleString isEqualToString:@"204"]){
            cell.numLable.text = _infoModel.userID;
            cell.nameLable.text = _infoModel.name;
            cell.phoneLable.text = _infoModel.telNumber;
            cell.actorLable.text = kLocalized(@"Waiter");
            cell.stateLable.text = kLocalized(@"Active");
        }else if ([_roleString isEqualToString:@"305"] || [_roleString isEqualToString:@"205"]){
            cell.numLable.text = _infoModel.userID;
            cell.nameLable.text = _infoModel.name;
            cell.phoneLable.text = _infoModel.telNumber;
            cell.actorLable.text = kLocalized(@"DeliveryStaff");
            cell.stateLable.text = kLocalized(@"Active");
        }
        
        return cell;
    }
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.queryView.selectedIndex == 1) {
        GYOrderHeaderView *orderHeaderView=[[GYOrderHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        orderHeaderView.backgroundColor=[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
        return orderHeaderView;
    }else if((self.queryView.selectedIndex == 2)){
        GYListHeaderView *listHeaderView=[[GYListHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        listHeaderView.backgroundColor=[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
        return listHeaderView;
    } else{
        
        GYUserHeaderView *userHeaderView=[[GYUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        userHeaderView.backgroundColor=[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
        return userHeaderView;
        
        
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.queryView.selectedIndex == 1) {
        
        GYOrderListModel *listModel = _orderDataArr[indexPath.row];
        
        if ([listModel.orderType isEqualToString:kLocalized(@"In-storeDining")] || [listModel.orderType isEqualToString:kLocalized(@"StoresFromMentioning")]) {
            if ([listModel.orderStatus isEqualToString:kLocalized(@"CancelUnconfirmed")]) {
                GYOutCancelViewController *detailVC = [[GYOutCancelViewController alloc] init];
                detailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailVC.status = listModel.orderStatus;
                [self pushViewController:detailVC animated:YES];
            }else{
                GYOrderInDetailViewController *detailCtl = [[GYOrderInDetailViewController alloc] init];
                detailCtl.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailCtl.status = listModel.orderStatus;
                [self pushViewController:detailCtl animated:YES];
            }
            
        }else if ([listModel.orderType isEqualToString:kLocalized(@"DeliveryToHome")]){
            
            if ([listModel.orderStatus isEqualToString:kLocalized(@"ToBeConfirmed")]) {
                GYOutConfirmViewController *detailVC = [[GYOutConfirmViewController alloc] init];
                detailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailVC.status = listModel.orderStatus;
                [self pushViewController:detailVC animated:YES];
            }else if ([listModel.orderStatus isEqualToString:kLocalized(@"PendingDelivery")]){
                GYOrderTakeOutDetailViewController *detailVC = [[GYOrderTakeOutDetailViewController alloc] init];
                detailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailVC.status = listModel.orderStatus;
                [self pushViewController:detailVC animated:YES];
                
            }else if ([listModel.orderStatus isEqualToString:kLocalized(@"Deliveries")]){
                
                GYOutPaidViewController *detailVC = [[GYOutPaidViewController alloc] init];
                detailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailVC.status = listModel.orderStatus;
                [self pushViewController:detailVC animated:YES];
                
            }else if ([listModel.orderStatus isEqualToString:kLocalized(@"TransactionComplete")] || [listModel.orderStatus isEqualToString:kLocalized(@"Cancelled")]){
                
                GYOutDetailViewController *detailVC = [[GYOutDetailViewController alloc] init];
                detailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailVC.status = listModel.orderStatus;
                [self pushViewController:detailVC animated:YES];
                
            }else if ([listModel.orderStatus isEqualToString:kLocalized(@"CancelUnconfirmed")]){
                GYOutCancelViewController *detailVC = [[GYOutCancelViewController alloc] init];
                detailVC.infoDic = @{@"userId":listModel.userId,@"orderId":listModel.orderId};
                detailVC.status = listModel.orderStatus;
                [self pushViewController:detailVC animated:YES];
            }
        }
    }
}
@end
