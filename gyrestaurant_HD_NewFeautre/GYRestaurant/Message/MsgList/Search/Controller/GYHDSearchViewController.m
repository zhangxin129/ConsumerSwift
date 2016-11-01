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
#import "GYHDCustomerMessageCell.h"
#import "GYHDSearchCompanyListCell.h"
#import "GYHDSearchCompanyMessageCell.h"
#import "GYHDMsgShowPageController.h"
#import "GYMsgListContentController.h"
#import "GYHDCustomerViewController.h"
#import "GYHDStaffInfoViewController.h"
#import "GYHDSearchMessageListModel.h"
#import "GYHDSearchCustomerListModel.h"
#import "GYHDCustomerInfoViewController.h"
#import "GYHDSearchListViewController.H"
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
@property(nonatomic,strong)NSMutableArray*pushMessageArr;//推送消息
@property(nonatomic,strong)NSMutableArray*companyListArr;//企业操作员列表
@property(nonatomic,strong)NSMutableArray*allChatMessageArr;//聊天消息
@property(nonatomic,strong)NSMutableArray*allMessageArr;//所有消息
@property(nonatomic,strong)NSMutableArray*customerListArr;//客户咨询列表
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

-(NSMutableArray *)companyListArr{

    if (!_companyListArr) {
        _companyListArr = [NSMutableArray array];
    }
    return _companyListArr;

}
-(NSMutableArray *)allMessageArr{
    
    if (!_allMessageArr) {
        _allMessageArr = [NSMutableArray array];
    }
    return _allMessageArr;
    
}

-(NSMutableArray *)customerListArr{
    
    if (!_customerListArr) {
        _customerListArr = [NSMutableArray array];
    }
    return _customerListArr;
    
}
-(NSMutableArray *)allChatMessageArr{
    
    if (!_allChatMessageArr) {
        _allChatMessageArr = [NSMutableArray array];
    }
    return _allChatMessageArr;
    
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 120;
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
    [self.customerListArr removeAllObjects];
    [self.companyListArr removeAllObjects];
    [self.allMessageArr removeAllObjects];
    [self.allChatMessageArr removeAllObjects];
    [self.dataArray removeAllObjects];
    
    if (self.keyWordStr.length<=0) {
        
        [self.tableView reloadData];
        return;
    }
    
//    查询所有推送消息
    NSArray*pushMessageArr= [self loadPushMessageData];
    
    for (NSDictionary*dict in pushMessageArr) {
        
        GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
        model.kerWord=self.keyWordStr;
        [model initWithDict:dict]; 
        
            [self.pushMessageArr addObject:model];
        
            GYHDSearchMessageListModel*searchModel=[[GYHDSearchMessageListModel alloc]init];
            searchModel.msgType=@"9";
            
            if ([model.msgMainType isEqualToString:@"1"]) {
                
                searchModel.pullMsgType=@"1";
                searchModel.titleName=@"系统消息";
            }else if([model.msgMainType isEqualToString:@"2"]){
                
                searchModel.pullMsgType=@"2";
                searchModel.titleName=@"订单消息";
            }else if ([model.msgMainType isEqualToString:@"3"]){
            
                searchModel.pullMsgType=@"3";
                searchModel.titleName=@"服务消息";
            }
            searchModel.countrow=model.countrow;
            searchModel.keyWord=self.keyWordStr;
            
            [self.allMessageArr addObject:searchModel];
        
    }
    
//    查询所有聊天消息
    NSArray*chatMessageArr=[self loadAllChatMessage];
    
    for (NSDictionary*dict in chatMessageArr) {

        GYHDSearchCustomerMessageModel*model=[[GYHDSearchCustomerMessageModel alloc]init];
        
        model.kerWord=self.keyWordStr;
        
        [model initWithDict:dict];
        
        [self.allChatMessageArr addObject:model];
        
        GYHDSearchMessageListModel*searchModel=[[GYHDSearchMessageListModel alloc]init];
        
        searchModel.msgType=@"10";
        searchModel.titleName=model.msgNote;
        searchModel.iconUrl=model.msgIcon;
        searchModel.keyWord=self.keyWordStr;
        searchModel.countrow=model.countrow;
        searchModel.custId=model.msgCard;
        [self.allMessageArr addObject:searchModel];
    
    }
    
    if (self.allMessageArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"消息";
        model.searchReasultArr=self.allMessageArr;
        model.isShowAllContent=NO;
        [self.dataArray addObject:model];
        
    }
    
//    客户咨询
    NSArray*customerListDataArr=[self loadCustomerListData];
    
    for (NSDictionary*dict in customerListDataArr) {
        
        GYHDSearchCustomerListModel*model=[[GYHDSearchCustomerListModel alloc]init];
        
        model.keyWord=self.keyWordStr;
        
        [model initWithDict:dict];
        
        if ([model.name rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound || [model.hsCardNum containsString:self.keyWordStr]) {
            
            [self.customerListArr addObject:model];
        }
        
    }
    
    if (self.customerListArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"客户咨询";
        model.searchReasultArr=self.customerListArr;
        model.isShowAllContent=NO;
        [self.dataArray addObject:model];
    }

    NSArray*compabyListArr=[self loadCompanyListData];
    
    for (NSDictionary*dict in compabyListArr) {
        
        GYHDSearchCompanyListModel*model=[[GYHDSearchCompanyListModel alloc]init];
        model.kerWord=self.keyWordStr;
        [model initWithDict:dict];
        
        if (([model.operaName rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound) || ([model.userName rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound)) {
            
            [self.companyListArr addObject:model];
            
        }
        
    }
//    查询所有企业通讯录
    if (self.companyListArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=@"企业通讯录";
        model.searchReasultArr=self.companyListArr;
        model.isShowAllContent=NO;
        [self.dataArray addObject:model];
    }
    
    [self.tableView reloadData];
}

//获取离线消息数据源

-(NSArray*)loadPushMessageData{
    
    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectPushMssageByKeyStr:self.keyWordStr];
    
    return arr;
}

//获取聊天消息数据源
-(NSArray*)loadAllChatMessage{

    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectAllChatMessageByKeyString:self.keyWordStr];

    return arr;
}

//查询客户资料

-(NSArray*)loadCustomerListData{
    
    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectCustomerDeTail];
    
    return arr;

}


//获取企业通讯录数据源

-(NSArray*)loadCompanyListData{

    NSArray* arr=[[GYHDMessageCenter sharedInstance] selectCompanyList];
    
    
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
    if ([model.groupName isEqualToString:@"消息"]) {
        GYHDSearchMessageListModel*searchModel=model.searchReasultArr[indexPath.row];
        GYHDSearchCompanyMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDSearchCompanyMessageCell];
        
        [cell refreshWithModel:searchModel];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([model.groupName isEqualToString:@"客户咨询"]) {
        GYHDSearchCustomerListModel*customerModel=model.searchReasultArr[indexPath.row];
        
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
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    GYHDSearchModel*model=self.dataArray[indexPath.section];
    if ([model.groupName isEqualToString:@"消息"]) {
        
        GYHDSearchMessageListModel*tempModel=model.searchReasultArr[indexPath.row];
        
        GYHDSearchListViewController*vc=[[GYHDSearchListViewController alloc]init];
        vc.iconUrl=tempModel.iconUrl;
        vc.name=tempModel.titleName;
        vc.msgType=tempModel.msgType;
        vc.custId=tempModel.custId;
        vc.keyWord=tempModel.keyWord;
        vc.pushType=tempModel.pullMsgType;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    if ([model.groupName isEqualToString:@"客户咨询"]) {
        
        GYHDSearchCustomerListModel*customerModel=model.searchReasultArr[indexPath.row];
        GYHDCustomerInfoViewController*vc=[[GYHDCustomerInfoViewController alloc]init];
        GYHDCustomerModel*model=[[GYHDCustomerModel alloc]init];
        
        model.Friend_CustID=customerModel.custId;
        vc.isClickSelf=NO;
        vc.model=model;
        
        [self.navigationController pushViewController:vc animated:YES];
        
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
        
        if (section==0) {
            
            checkMoreLabel.text=[NSString stringWithFormat:@"查看更多%@的消息>",self.keyWordStr];
            
        }else{
        
          checkMoreLabel.text=[NSString stringWithFormat:@"查看更多%@>",model.groupName];
        }
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
