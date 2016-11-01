//
//  GYDeliveryStaffManagementViewController.m
//  GYRestaurant
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYDeliveryStaffManagementViewController.h"
#import "GYStaffMangerView.h"
#import "GYAddStaffViewController.h"
#import "GYStaffMangerViewCell.h"
#import "GYStaffMangerHeaderView.h"
#import "GYChangeStaffController.h"
#import "GYDeliverModel.h"
#import "GYSystemSettingViewModel.h"

@interface GYDeliveryStaffManagementViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,TabViewCellDelegate>

@property (nonatomic, strong)UITableView *staffTabView;
@property (nonatomic, strong)UISearchBar *searchBar;
@property (nonatomic, strong)UIButton *addStaffBtn;
@property (nonatomic, strong)GYStaffMangerView *staffMangerView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic, strong)GYStaffMangerViewCell *mangerCell;
@property (nonatomic, copy)NSString *idStr;
@property (nonatomic, copy)NSString *nameStr;
@property (nonatomic, strong)UILabel *noDataLable;

@end

@implementation GYDeliveryStaffManagementViewController

#pragma mark - 系统方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self httpRequestQueryDeliverList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    self.noDataLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 - 150, kScreenHeight/2 - 200, 150, 30)];
    self.noDataLable.text = @"数据为空！";
    self.noDataLable.textAlignment = NSTextAlignmentCenter;
    self.noDataLable.font = [UIFont systemFontOfSize:25];
    self.noDataLable.textColor = [UIColor lightGrayColor];
    self.noDataLable.hidden = YES;
    [self.view addSubview:self.noDataLable];
    
}
#pragma mark - 创建视图
-(void)createView{
    
    self.navigationItem.leftBarButtonItem = [Utils createBackButtonWithTitle:kLocalized(@"DeliveryStaffManagement") withTarget:self withAction:@selector(popBack)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    _searchBar.delegate = self;
    _searchBar.placeholder = kLocalized(@"PleaseEnterTheNamesOfTheDeliveryStaff");
    _searchBar.returnKeyType = UIReturnKeySearch;
    _searchBar.layer.masksToBounds = YES;
    _searchBar.layer.borderWidth = 1;
    _searchBar.layer.borderColor = kBlueFontColor.CGColor;
    
    UIBarButtonItem *bbiRight = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
    
    self.navigationItem.rightBarButtonItem = bbiRight;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 2)];
    lineView.backgroundColor=kRedFontColor;
    [self.view addSubview:lineView];
   
    UIView *boLineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-64-50, self.view.frame.size.width, 2)];
    boLineView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:boLineView];
   
    //创建tableView
    _staffMangerView =[[GYStaffMangerView alloc] initWithFrame:self.view.bounds];
    
    _staffMangerView.staffTabView.delegate = self;
    _staffMangerView.staffTabView.dataSource = self;
    
    //注册cell
    [_staffMangerView.staffTabView registerNib:[UINib nibWithNibName:@"GYStaffMangerViewCell" bundle:nil] forCellReuseIdentifier:@"staffCell"];
    
    [self.view addSubview:_staffMangerView];

    _addStaffBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _addStaffBtn.frame = CGRectMake(self.view.frame.size.width-150, self.view.frame.size.height - 64 - 2 - 39, 130, 30);
    [_addStaffBtn setTitle:kLocalized(@"IncreaseDeliveryStaff") forState:UIControlStateNormal];
    _addStaffBtn.backgroundColor = [UIColor colorWithRed:209/255.0 green:214/255.0 blue:214/255.0 alpha:1.0];
    [_addStaffBtn setTitleColor:[UIColor colorWithRed:62/255.0 green:85/255.0 blue:128/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_addStaffBtn.layer setMasksToBounds:YES];
    [_addStaffBtn.layer setCornerRadius:5.0];
    [_addStaffBtn.layer setBorderWidth:1.0];
    [_addStaffBtn.layer setBorderColor:[UIColor colorWithRed:180/255.0 green:182/255.0 blue:182/255.0 alpha:1.0].CGColor];
    [_addStaffBtn addTarget:self action:@selector(pushAddCtl) forControlEvents:UIControlEventTouchUpInside];
    
    _addStaffBtn.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    
    [self.view addSubview:_addStaffBtn];

    
}
#pragma mark - 懒加载
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

#pragma mark - 网络请求查询企业送餐员列表
/**
 *  查询企业送餐员列表
 */
-(void)httpRequestQueryDeliverList{
    if (!kGetNSUser(@"shopId")) {

        return;
    }
    
    GYSystemSettingViewModel *viewModel=[[GYSystemSettingViewModel alloc] init];
    NSDictionary *params = @{@"vShopId":globalData.loginModel.vshopId,@"name":@"",@"shopId":kGetNSUser(@"shopId")};
        [self modelRequestNetwork:viewModel :^(id resultDic) {
            [self.dataArr removeAllObjects];
            for (GYDeliverModel *model in resultDic) {
                if (![model.status isEqualToString:kLocalized(@"Delete")]) {
                    [self.dataArr addObject:model];
                }
            }
            if (self.dataArr.count == 0) {
                self.noDataLable.hidden = NO;
                self.staffMangerView.staffTabView.hidden = YES;
            }else{
                self.noDataLable.hidden = YES;
                self.staffMangerView.staffTabView.hidden = NO;
                [self.staffMangerView.staffTabView reloadData];
            }
        
        } isIndicator:YES];
        [viewModel getQueryDeliverListWthKey:globalData.loginModel.token andParams:params];
    
}
/**
 *  搜索送餐员
 */
-(void)httpRequestSearch{
    if (!kGetNSUser(@"shopId")) {
        
        return;
    }
    @weakify(self);
    GYSystemSettingViewModel *viewModel=[[GYSystemSettingViewModel alloc] init];
    NSDictionary *params = @{@"vShopId":globalData.loginModel.vshopId,@"shopId":kGetNSUser(@"shopId"),@"name":_nameStr};
    
    [self modelRequestNetwork:viewModel :^(id resultDic) {
        @strongify(self);
        NSArray *arr = resultDic;
        if (arr.count == 0) {
            self.staffMangerView.staffTabView.hidden = YES;
            self.noDataLable.hidden = NO;
        }else{
            self.noDataLable.hidden = YES;
            self.staffMangerView.staffTabView.hidden = NO;
            _dataArr = resultDic;
            [self.staffMangerView.staffTabView reloadData];
        }
    } isIndicator:YES];
    [viewModel getQueryDeliverListWthKey:globalData.loginModel.token andParams:params];
    
}

#pragma mark - 点击触发操作

- (void)clickAction:(UIView *)sender{
    switch (sender.tag) {
        case 101:
        {
            
        }
            break;
            
        default:
            break;
    }
    
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)pushAddCtl{

    GYAddStaffViewController *addCtl = [[GYAddStaffViewController alloc] init];
    [self.navigationController pushViewController:addCtl animated:YES];

}
#pragma mark - UISearchBar的代理方法
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    _nameStr = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self httpRequestSearch];
}

#pragma mark - TabViewCell的代理方法
/**
 *  删除送餐员
 */
-(void)deleteBtn:(GYDeliverModel *)model{

    GYAlertView *alertView=[[GYAlertView alloc] initWithTitle:kLocalized(@"AreYouSureToDeleteIt") contentText:nil leftButtonTitle:kLocalized(@"Cancel") rightButtonTitle:kLocalized(@"Determine")];
    
    alertView.rightBlock=^(){
        
        GYSystemSettingViewModel *viewModel=[[GYSystemSettingViewModel alloc] init];
        
        [self modelRequestNetwork:viewModel :^(id resultDic) {
            [self notifyWithText:kLocalized(@"DeleteSuccessful")];
             [self httpRequestQueryDeliverList];
        } isIndicator:YES];
        
        [viewModel deleteDeliverWithKey:globalData.loginModel.token andId:model.idNum andVShopId:globalData.loginModel.vshopId];
        
    };
        [alertView show];
    
}
/**
 *  修改送餐员
 */
-(void)changeBtnAction:(GYDeliverModel *)model{

    GYChangeStaffController *changeCtl = [[GYChangeStaffController alloc]init];
    
    changeCtl.deliverNameStr = model.name;
    changeCtl.sexStr = model.sex;
    changeCtl.phoneNumStr = model.phone;
    changeCtl.statusStr = model.status;
    changeCtl.remarkStr = model.remark;
    changeCtl.picUrlStr = model.picUrl;
    changeCtl.shopNameStr = model.shopName;
    changeCtl.idStr = model.idNum;
    changeCtl.shopID = model.shopId;
    
    [self.navigationController pushViewController:changeCtl animated:YES];

}

#pragma mark - UITableViewDataSource && UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    GYStaffMangerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staffCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.model = _dataArr[indexPath.row];
    
    if([cell.model.status isEqualToString:kLocalized(@"Disabled")]){
//        cell.selected = YES ;
//        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor colorWithWhite:.5 alpha:.5];
    }else{
        cell.backgroundColor = [UIColor clearColor];
    
    }
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
        GYStaffMangerHeaderView *headerView=[[GYStaffMangerHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        headerView.backgroundColor=[UIColor colorWithRed:232/255.0 green:234/255.0 blue:235/255.0 alpha:1.0];
        return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section{
    return 50;
}

@end
