//
//  GYHDContactsViewController.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDContactsViewController.h"
#import "GYHDContactsGroupCell.h"
#import "GYHDContactsDetialView.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDNetWorkTool.h"
#import "GYHDOperGroupModel.h"
#import "GYHDOpereotrListModel.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import <GYKit/GYPinYinConvertTool.h>
@interface GYHDContactsViewController ()<UITableViewDataSource,UITableViewDelegate>
/**左边tableview*/
@property(nonatomic, strong)UITableView     *companyOpearListTableView;
/**左边表格数据源*/
@property(nonatomic, strong)NSMutableArray  *companyOpearListArray;
/**个人详情View*/
@property(nonatomic, strong)GYHDContactsDetialView *contactsDetialView;


@property(nonatomic,strong)NSIndexPath *selectIndexPath;
@end

@implementation GYHDContactsViewController
#pragma mark -懒加载视图
-(NSMutableArray *)companyOpearListArray{

    if (!_companyOpearListArray) {
        
        _companyOpearListArray=[NSMutableArray array];
    }
    return _companyOpearListArray;
}


-(UITableView *)companyOpearListTableView{

    if (!_companyOpearListTableView) {
        
       _companyOpearListTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _companyOpearListTableView.dataSource = self;
        _companyOpearListTableView.delegate = self;
        _companyOpearListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        更改索引的文字颜色:
        _companyOpearListTableView.sectionIndexColor = [UIColor colorWithRed:255/255.0 green:155/255.0 blue:50/255.0 alpha:1.0];
        _companyOpearListTableView.showsVerticalScrollIndicator=NO;
        _companyOpearListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _companyOpearListTableView.rowHeight = 90;
        [_companyOpearListTableView registerClass:[GYHDContactsGroupCell class] forCellReuseIdentifier:NSStringFromClass([GYHDContactsGroupCell class])];
        [self.view addSubview:_companyOpearListTableView];
        
        [_companyOpearListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(44);
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(325);
        }];
    }

    return _companyOpearListTableView;
}


-(GYHDContactsDetialView *)contactsDetialView{

    if (!_contactsDetialView) {
        
        if (_chatVc) {
            
            [_chatVc.view removeFromSuperview];
            _chatVc=nil;
            _chatVc.view=nil;
        }
        
        _contactsDetialView = [[GYHDContactsDetialView alloc] init];
        
        [self.view addSubview:_contactsDetialView];
        
        @weakify(self);
        
        [_contactsDetialView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(44);
            make.right.bottom.mas_equalTo(0);
            make.left.equalTo(self.companyOpearListTableView.mas_right);
        }];
        
        _contactsDetialView.block=^(NSString*custId){
         @strongify(self);
            
            [self sendMessageWithCustId:custId];
        
        };
        
    }
    return _contactsDetialView;
}

-(GYHDChatViewController *)chatVc{

    if (!_chatVc) {
        
        [_contactsDetialView removeFromSuperview];
        _contactsDetialView=nil;
        
        _chatVc=[[GYHDChatViewController alloc]initWithIsCompany:YES];
        [self addChildViewController:_chatVc];
        
        [self.view addSubview:_chatVc.view];
        @weakify(self);
        [_chatVc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.top.mas_equalTo(44);
            make.right.bottom.mas_equalTo(0);
            make.left.equalTo(self.companyOpearListTableView.mas_right);
            
        }];
        
    }
    return _chatVc;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self loadCompanyOperatorList];
    [self addRefreshView];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageListClick) name:GYHDHDMainChageTabBarIndexNotification object:nil];
}
#pragma mark - 通知移除
-(void)dealloc{

 [[NSNotificationCenter defaultCenter] removeObserver:self name:GYHDHDMainChageTabBarIndexNotification object:nil];
    
}
#pragma mark- 获取操作员列表数据
//获取本企业操作员列表
-(void)loadCompanyOperatorList{

    @weakify(self);
    //数据库中读取
    NSArray *DataBaseArray = [[GYHDDataBaseCenter sharedInstance] selectFriendList];
    
    if (DataBaseArray.count>0) {
        
        
        [self readCompanyListData:DataBaseArray];
        
        
    }else{
        
        //    网络获取
        [[GYHDNetWorkTool sharedInstance] postListOperByEntCustIdResult:^(NSArray *resultArry) {
            @strongify(self);
            [self readCompanyListData:resultArry];
            
        }];
    }

}
#pragma mark -刷新控件
-(void)addRefreshView{

    @weakify(self);
    
    GYRefreshHeader*header=[GYRefreshHeader headerWithRefreshingBlock:^{
        
        @strongify(self);
        //    网络获取
        [[GYHDNetWorkTool sharedInstance] postListOperByEntCustIdResult:^(NSArray *resultArry) {
            @strongify(self);
            [self readCompanyListData:resultArry];
            [self.companyOpearListTableView.mj_header endRefreshing];
        }];
        
    }];
    
    self.companyOpearListTableView.mj_header=header;

}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"GYHD_Contacts");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    DDLogInfo(@"Load Controller: %@", [self class]);
}

#pragma mark - event response
-(void)readCompanyListData:(NSArray*)resultArry{
    
    
    NSArray*companyListArr=[self loadCompanyOperatorListArr:resultArry];
    
    NSArray *companyListGoupArr= [self operListCompanyWithArray:companyListArr];
    
    self.companyOpearListArray=[companyListGoupArr mutableCopy];
    
    [self.companyOpearListTableView reloadData];
    
}

-(NSArray*)loadCompanyOperatorListArr:(NSArray*)CompanyOperatorListArr{
    
    //    获取全部操作员列表方法
    NSMutableArray*listArr=[NSMutableArray array];
    
    for (NSDictionary*dict in CompanyOperatorListArr) {
        
        GYHDOpereotrListModel*model=[[GYHDOpereotrListModel alloc]init];
        
        model.saleAndOperatorRelationList=dict[@"saleAndOperatorRelationList"];
        model.searchUserInfo=dict[@"searchUserInfo"];
        if ([dict[@"roleName"] isEqualToString:@"null"] || dict[@"roleName"]==nil){
            
            model.roleName=@"";
            
        }else{
            
            model.roleName=dict[@"roleName"];
            
        }
        //        取得操作员是否有未读消息 显示在通讯录
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:dict[@"searchUserInfo"][@"custId"]];
        model.isSelect=NO;
        
        if ([dict[@"searchUserInfo"][@"custId"] isEqualToString:globalData.loginModel.custId]) {
            
        }else{
            
            [listArr addObject:model];
        }
        
    }

    return listArr;
    
}

/**企业所有操作员好友按字母分组*/
- (NSMutableArray *)operListCompanyWithArray:(NSArray *)array {
    NSArray *ABCArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil];
    NSMutableArray *operGroupArray = [NSMutableArray array];
    for (NSString *key in ABCArray) {
        GYHDOperGroupModel *operGroupModel = [[GYHDOperGroupModel alloc]init];
        for (GYHDOpereotrListModel *operModel in array) {
            
            //1. 转字母
            NSString * tempStr = operModel.searchUserInfo[@"operName"];
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if ([GYPinYinConvertTool isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
            }
            //2. 获取首字母
            NSString *firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            //3. 加入数组
            if([firstLetter isEqualToString:key]) {
                operGroupModel.operGroupTitle = key;
                [operGroupModel.operGroupArray addObject:operModel];
            }
        }
        if (operGroupModel.operGroupTitle && operGroupModel.operGroupArray.count > 0) {
            [operGroupArray addObject:operGroupModel];
        }
    }
    return  operGroupArray;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.companyOpearListArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    GYHDOperGroupModel*model=self.companyOpearListArray[section];
    
    return model.operGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        GYHDContactsGroupCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDContactsGroupCell class])];
    
        GYHDOperGroupModel*model=self.companyOpearListArray[indexPath.section];
    
        GYHDOpereotrListModel*listModel=model.operGroupArray[indexPath.row];
        baseCell.selectionStyle=UITableViewCellSelectionStyleNone;
        baseCell.model = listModel;
    
    return baseCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    GYHDOperGroupModel*model=self.companyOpearListArray[section];
    
    return model.operGroupTitle;
    
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    NSMutableArray*titleArr=[NSMutableArray array];
    
    for ( GYHDOperGroupModel*model in self.companyOpearListArray) {
        
        [titleArr addObject:model.operGroupTitle];
    }
    
    return titleArr;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    GYHDOperGroupModel*model=self.companyOpearListArray[indexPath.section];
    
    GYHDOpereotrListModel*listModel=model.operGroupArray[indexPath.row];
    
    
    for (GYHDOperGroupModel *model in self.companyOpearListArray) {
        
        for (GYHDOpereotrListModel*tempModel in model.operGroupArray) {
            
            tempModel.isSelect=NO;
            
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:kSaftToNSString(listModel.searchUserInfo[@"custId"]) forKey:@"CompanyMsgCard"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomerMsgCard"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    listModel.isSelect=YES;
    self.contactsDetialView.model=listModel;
    [self.companyOpearListTableView reloadData];
    
}

#pragma mark - 发送消息按钮
-(void)sendMessageWithCustId:(NSString*)custId{

    DDLogInfo(@"用户CustID:%@",custId);
    
    [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:custId];
    [[GYHDMessageCenter sharedInstance] postDataBaseChangeNotification];
    self.chatVc.custId=custId;

}

#pragma mark -监听消息列表和搜索结果跳转 直接显示聊天页面不显示个人详情
-(void)messageListClick{

    NSString*msgCard=[[NSUserDefaults standardUserDefaults]objectForKey:@"CompanyMsgCard"];
    
    GYHDOpereotrListModel*listModel;
//    
//    for (GYHDOperGroupModel *model in self.companyOpearListArray) {
//        
//        for (GYHDOpereotrListModel*tempModel in model.operGroupArray) {
//            
//            tempModel.isSelect=NO;
//            if (msgCard!=nil && [tempModel.searchUserInfo[@"custId"] isEqualToString:msgCard]) {
//                
//                listModel=tempModel;
//                
//            }
//            
//        }
//    }
//    
//    listModel.isSelect=YES;
//    self.contactsDetialView.model=listModel;
//    [self.companyOpearListTableView reloadData];
//    self.chatVc.custId=msgCard;
    
    NSInteger row = 0;
    NSInteger section = 0;
    for (int i = 0; i< self.companyOpearListArray.count; i++) {
        
        GYHDOperGroupModel *model=self.companyOpearListArray[i];
        
        for (int j = 0 ; j < model.operGroupArray.count; j++) {
            
            GYHDOpereotrListModel*tempModel = model.operGroupArray[j];
            
            tempModel.isSelect=NO;
            
            if (msgCard!=nil && [tempModel.searchUserInfo[@"custId"] isEqualToString:msgCard]) {
                
                listModel=tempModel;
                
                section = i;
                
                row = j;
            }
        }
        
    }
    
    listModel.isSelect=YES;
    self.contactsDetialView.model=listModel;
    [self.companyOpearListTableView reloadData];
    self.chatVc.custId=msgCard;
    
    [self.companyOpearListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
}
@end
