//
//  GYHDSearchViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDSearchViewController.h"
#import "GYHDSearchModel.h"
#import "NSString+YYAdd.h"
#import "GYHDNavView.h"
#import "GYHDMessageCenter.h"
#import "GYHDSearchPushMessageModel.h"
#import "GYHDSearchCustomerMessageModel.h"
#import "GYHDSearchCompanyListModel.h"
#import "GYHDSearchCustomerMessageModel.h"
#import "GYHDSearchPushMessageCell.h"
#import "GYHDCustomerMessageCell.h"
#import "GYHDSearchCompanyListCell.h"
#import "GYHDSearchCompanyMessageCell.h"
#import "GYHDMsgShowPageController.h"
#import "GYMsgListContentController.h"
#import "GYHDCustomerViewController.h"
#import "GYHDStaffInfoViewController.h"
#define kGYHDSearchPushMessageCell @"GYHDSearchPushMessageCell"
#define kGYHDCustomerMessageCell @"GYHDCustomerMessageCell"
#define kGYHDSearchCompanyListCell @"GYHDSearchCompanyListCell"
#define kGYHDSearchCompanyMessageCell @"GYHDSearchCompanyMessageCell"
@interface GYHDSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,GYHDNavViewDelegate>
/**
 *数据源数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, weak) UITableView *tableView;
@property(nonatomic,copy)NSString*keyWordStr;//搜索字段
@property(nonatomic,strong)NSMutableArray*pushMessageArr;
@property(nonatomic,strong)NSMutableArray*customerMessageArr;
@property(nonatomic,strong)NSMutableArray*companyListArr;
@property(nonatomic,strong)NSMutableArray*companyMessageArr;
@end

@implementation GYHDSearchViewController
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)pushMessageArr{

    if (!_pushMessageArr) {
        _pushMessageArr = [NSMutableArray array];
    }
    return _pushMessageArr;
}

-(NSMutableArray *)customerMessageArr{

    if (!_customerMessageArr) {
        _customerMessageArr = [NSMutableArray array];
    }
    return _customerMessageArr;

}

-(NSMutableArray *)companyListArr{

    if (!_companyListArr) {
        _companyListArr = [NSMutableArray array];
    }
    return _companyListArr;

}

-(NSMutableArray *)companyMessageArr{

    if (!_companyMessageArr) {
        _companyMessageArr = [NSMutableArray array];
    }
    return _companyMessageArr;

}
- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 120;
        [tableView registerClass:[GYHDSearchPushMessageCell class] forCellReuseIdentifier:kGYHDSearchPushMessageCell];
        [tableView registerClass:[GYHDCustomerMessageCell class] forCellReuseIdentifier:kGYHDCustomerMessageCell];
        [tableView registerClass:[GYHDSearchCompanyListCell class] forCellReuseIdentifier:kGYHDSearchCompanyListCell];
        [tableView registerClass:[GYHDSearchCompanyMessageCell class] forCellReuseIdentifier:kGYHDSearchCompanyMessageCell];
        tableView.tableFooterView=[[UIView alloc]init];
        [self.view addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
}

- (void)setupNav {
    
    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 64)];
    navView.delegate = self;
    [navView searchTextFiled:@"hd_nav_right_search" :kLocalized(@"搜索")];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , 64));
    }];
}

- (void)GYHDNavViewGoBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)GYHDNavViewSearch:(UITextField *)textField {
    
    self.keyWordStr=textField.text;
    
    //过滤字符串前后的空格
    self.keyWordStr = [self.keyWordStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    self.keyWordStr = [self.keyWordStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"keyWord=%@",self.keyWordStr);
    
    [self.pushMessageArr removeAllObjects];
    [self.customerMessageArr removeAllObjects];
    [self.companyListArr removeAllObjects];
    [self.companyMessageArr removeAllObjects];
    [self.dataArray removeAllObjects];
    
    NSArray*pushMessageArr= [self loadPushMessageData];
    
    for (NSDictionary*dict in pushMessageArr) {
        
        GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
        model.kerWord=self.keyWordStr;
        [model initWithDict:dict];
        
        if ([model.content containsString:self.keyWordStr] || [model.titleName containsString:self.keyWordStr]) {
            
            [self.pushMessageArr addObject:model];
            
        }
        
    }
 
    if (self.pushMessageArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"消息列表";
        model.searchReasultArr=self.pushMessageArr;
        model.isShowAllContent=NO;
        [self.dataArray addObject:model];
        
    }
    
    NSArray*customerMessageArr=[self loadCustomerMessageData];
    
    for (NSDictionary*dict in customerMessageArr) {
        
        GYHDSearchCustomerMessageModel*model=[[GYHDSearchCustomerMessageModel alloc]init];
        model.kerWord=self.keyWordStr;
        [model initWithDict:dict];
        
        if ([model.content containsString:self.keyWordStr]) {
            
            [self.customerMessageArr addObject:model];
        }
        
    }
    
    if (self.customerMessageArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"客户咨询";
        model.searchReasultArr=self.customerMessageArr;
         model.isShowAllContent=NO;
        [self.dataArray addObject:model];
    }
    
    NSArray*compabyListArr=[self loadCompanyListData];
    
    for (NSDictionary*dict in compabyListArr) {
        
        GYHDSearchCompanyListModel*model=[[GYHDSearchCompanyListModel alloc]init];
        model.kerWord=self.keyWordStr;
        [model initWithDict:dict];
        
        if ([model.operaName containsString:self.keyWordStr]) {
            
            [self.companyListArr addObject:model];
            
        }
        
    }
    
    if (self.companyListArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"企业通讯录";
        model.searchReasultArr=self.companyListArr;
        model.isShowAllContent=NO;
        [self.dataArray addObject:model];
    }
    
    NSArray*companyMessageArr=[self loadCompanyMssageData];
    
    for (NSDictionary*dict in companyMessageArr) {
        
        GYHDSearchCompanyMessageModel*model=[[GYHDSearchCompanyMessageModel alloc]init];
        model.kerWord=self.keyWordStr;
        [model initWithDict:dict];
        
        if ([model.content containsString:self.keyWordStr]) {
            
            [self.companyMessageArr addObject:model];
        }
        
    }
    
    if (self.companyMessageArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"企业通讯录消息";
        model.searchReasultArr=self.companyMessageArr;
        model.isShowAllContent=NO;
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}

//获取离线消息数据源

-(NSArray*)loadPushMessageData{
    
    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectPushMssage];
    
    return arr;
}

//获取客户咨询消息数据源

-(NSArray*)loadCustomerMessageData{
    
    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectCustomerMessage];
    
    return arr;
}

//获取企业通讯录数据源

-(NSArray*)loadCompanyListData{

    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectCompanyList];
    
    
    return arr;
}

//获取企业聊天消息数据源

-(NSArray*)loadCompanyMssageData{

    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectCompanyMessage];
    
    
    return arr;
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    GYHDSearchModel*model=self.dataArray[section];
    
    if (model.searchReasultArr.count>5 && !model.isShowAllContent) {
        
        return 5;
    }
    
    return model.searchReasultArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHDSearchModel*model=self.dataArray[indexPath.section];
    if ([model.groupName isEqualToString:@"消息列表"]) {
        GYHDSearchPushMessageModel*pushModel=model.searchReasultArr[indexPath.row];
        GYHDSearchPushMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDSearchPushMessageCell];
        
        [cell refreshWithModel:pushModel];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([model.groupName isEqualToString:@"客户咨询"]) {
        GYHDSearchCustomerMessageModel*customerModel=model.searchReasultArr[indexPath.row];
        
        GYHDCustomerMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDCustomerMessageCell];
        
        [cell refreshWithModel:customerModel];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([model.groupName isEqualToString:@"企业通讯录"]) {
        GYHDSearchCompanyListModel*listModel=model.searchReasultArr[indexPath.row];
        
        GYHDSearchCompanyListCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDSearchCompanyListCell];
        
        [cell refreshWithModel:listModel];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([model.groupName isEqualToString:@"企业通讯录消息"]) {
        GYHDSearchCompanyMessageModel*companyModel=model.searchReasultArr[indexPath.row];
        
        GYHDSearchCompanyMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDSearchCompanyMessageCell];
        
        [cell refreshWithModel:companyModel];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GYHDSearchModel*model=self.dataArray[indexPath.section];
    
    if ([model.groupName isEqualToString:@"消息列表"]) {
        
        GYHDSearchPushMessageModel*tempModel=model.searchReasultArr[indexPath.row];
        if (tempModel.pageUrl && tempModel.pageUrl>0) {
            
            GYHDMsgShowPageController*vc=[[GYHDMsgShowPageController alloc]init];
            vc.pageUrl=tempModel.pageUrl;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
        
            GYMsgListContentController*vc=[[GYMsgListContentController alloc]init];
            GYOrderMessageListModel*contentModel=[[GYOrderMessageListModel alloc]init];
            
            contentModel.messageListContent=tempModel.content;
            vc.model=contentModel;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if ([model.groupName isEqualToString:@"客户咨询"]) {
        GYHDSearchCustomerMessageModel*customerModel=model.searchReasultArr[indexPath.row];
        
        [[NSUserDefaults standardUserDefaults] setObject:customerModel.msgCard forKey:@"customerIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"navindex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"popCustomerMessage" object:nil];
        
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        
    }
    
    if ([model.groupName isEqualToString:@"企业通讯录"]) {
        GYHDSearchCompanyListModel*listModel=model.searchReasultArr[indexPath.row];
        
        GYHDStaffInfoViewController*vc=[[GYHDStaffInfoViewController alloc]init];
        GYHDOpereotrListModel *tempModel=[[GYHDOpereotrListModel alloc]init];
        
        tempModel.saleAndOperatorRelationList=listModel.saleAndOperatorRelationList;
        
        tempModel.searchUserInfo=listModel.searchUserInfo;
        
        tempModel.roleName=listModel.roleName;
        
        vc.OperatorModel=tempModel;
        vc.isCheckAllOperator=YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    if ([model.groupName isEqualToString:@"企业通讯录消息"]) {
        GYHDSearchCompanyMessageModel*companyModel=model.searchReasultArr[indexPath.row];
        
        
        GYHDStaffInfoViewController*vc=[[GYHDStaffInfoViewController alloc]init];
        GYHDOpereotrListModel *tempModel=[[GYHDOpereotrListModel alloc]init];
        
        tempModel.saleAndOperatorRelationList=companyModel.saleAndOperatorRelationList;
        
        tempModel.searchUserInfo=companyModel.searchUserInfo;
        
        tempModel.roleName=companyModel.roleName;
        
        vc.OperatorModel=tempModel;
        vc.isCheckAllOperator=YES;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }

}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    headView.backgroundColor = kDefaultVCBackgroundColor;
    headView.tag=100+section;
    UILabel *lbShow = [[UILabel alloc]initWithFrame:CGRectMake(40,20, 200, 20)];
    lbShow.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    lbShow.font = [UIFont systemFontOfSize:20.0];
    GYHDSearchModel*model=self.dataArray[section];
    lbShow.text=model.groupName;
    
    UILabel*checkMoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-290, 20, 250, 20)];
    
    checkMoreLabel.font=[UIFont systemFontOfSize:18.0];
    if (model.searchReasultArr.count>5) {
        
        checkMoreLabel.text=[NSString stringWithFormat:@"查看更多%@>",model.groupName];
    }
    
    checkMoreLabel.textColor=[UIColor colorWithRed:0 green:143/255.0 blue:215/255.0 alpha:1.0 ];
    checkMoreLabel.textAlignment=NSTextAlignmentRight;
    [headView addSubview:checkMoreLabel];
    [headView addSubview:lbShow];
    UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerCheckMore:)];
    
    [headView addGestureRecognizer:tap];

    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 60;
}

-(void)headerCheckMore:(UITapGestureRecognizer*)tap{

    NSInteger index =tap.view.tag-100;
    
    GYHDSearchModel*model=self.dataArray[index];
    
    model.isShowAllContent=!model.isShowAllContent;
    
    [self.tableView reloadData];
}
@end
