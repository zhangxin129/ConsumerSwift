//
//  GYHDContactsViewController.m
//  HSConsumer
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDContactsViewController.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDContactsGroupModel.h"
#import "GYHDContactsListModel.h"
#import "GYPinYinConvertTool.h"
#import "GYHDContactsTableViewCell.h"
#import "GYHDContactsHeadCell.h"
#import "GYHDChatViewController.h"
#import "GYHDFriendApplicationViewController.h"
#import "GYHDNewFriendsViewController.h"
#import "GYHDMarkViewController.h"
#import "GYHDFocusCompanyViewController.h"
#import "GYHDSeachMessageViewController.h"
#import "GYHDFriendDetailViewController.h"
@interface GYHDContactsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* listTabelView;
@property(nonatomic,strong)UITableView* headTabelView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation GYHDContactsViewController


-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
        [self loadContactsListData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    [self setupNav];
    if (!globalData.loginModel.cardHolder) {
        UIImageView *tipsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_no_contants"]];
        [self.view addSubview:tipsImageView];
        
        UILabel *tips1 = [[UILabel alloc] init];
        tips1.numberOfLines = 0;
        tips1.textAlignment = NSTextAlignmentCenter;
        tips1.textColor = [UIColor grayColor];
        tips1.text = @"持互生卡用户可使用此功能 , \n请使用互生卡号登录.";
        [self.view addSubview:tips1];
        WS(weakSelf);
        [tipsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.view);
//            make.top.equalTo(tipsImageView.mas_bottom).offset(10);
            make.bottom.equalTo(tips1.mas_top).offset(-10);
        }];
        [tips1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.equalTo(weakSelf.view);

        }];

        return;
    }
    
    [self setupUI];
    



    
}
- (void)loadContactsListData {
    
    WS(weakSelf);
    NSArray *friendListArray =  [[GYHDMessageCenter sharedInstance] getFriendListRequetResult:^(NSArray *resultArry) {
        NSMutableArray*arr=[NSMutableArray array];
        for (NSDictionary *dict in resultArry) {
            GYHDContactsListModel*model1=[[GYHDContactsListModel alloc]init];
            model1.iconUrl= dict[@"Friend_Icon"];;
            model1.name= dict[@"Friend_Name"];
            model1.content= dict[@"Friend_Sign"];
            model1.custid =  dict[@"Friend_CustID"];
            [arr addObject:model1];
        }
        weakSelf.dataArray=[weakSelf contactsListWithArray:arr];
        
        [weakSelf.listTabelView reloadData];
    }];
    NSMutableArray*arr=[NSMutableArray array];
    for (NSDictionary *dict in friendListArray) {
        GYHDContactsListModel*model1=[[GYHDContactsListModel alloc]init];
        model1.iconUrl= dict[@"Friend_Icon"];;
        model1.name= dict[@"Friend_Name"];
        model1.content= dict[@"Friend_Sign"];
        model1.custid =  dict[@"Friend_CustID"];
        [arr addObject:model1];
    }
    weakSelf.dataArray=[weakSelf contactsListWithArray:arr];
    
    [weakSelf.listTabelView reloadData];
}

#pragma mark - 导航栏设置
-(void)setupNav{

    self.title=[GYUtils localizedStringWithKey:@"GYHD_Contacts"];
    
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame=CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBtn setImage:[UIImage imageNamed:@"gyhd_back_icon"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    if (!globalData.loginModel.cardHolder) {
        return ;
    }
    UIButton*addFriendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    addFriendBtn.frame=CGRectMake(0, 0, 32, 32);
    
    [addFriendBtn addTarget:self action:@selector(addFriendClick) forControlEvents:UIControlEventTouchUpInside];
    
    [addFriendBtn setBackgroundImage:[UIImage imageNamed:@"gyhd_contants_addfriend_icon"] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:addFriendBtn];

    
}

#pragma mark - 页面设置
-(void)setupUI{

        //搜索按钮

    UIButton*searchBtn=[[UIButton alloc]init];
    [searchBtn setImage:[UIImage imageNamed:@"gyhd_search_icon"] forState:UIControlStateNormal];
    [searchBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 16;
    [searchBtn setTitleColor:[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1] forState:UIControlStateNormal];
    searchBtn.backgroundColor=[UIColor whiteColor];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(32);
        
    }];
    
    self.headTabelView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 198) style:UITableViewStylePlain];
    
    self.headTabelView.rowHeight=66;
    
    self.headTabelView.scrollEnabled=NO;
    
    self.headTabelView.delegate=self;
    
    self.headTabelView.dataSource=self;
    
    [self.headTabelView registerClass:[GYHDContactsHeadCell class] forCellReuseIdentifier:@"GYHDContactsHeadCell"];
    
    self.listTabelView=[[UITableView alloc]init];
    
    self.listTabelView.rowHeight=66;
    
    self.listTabelView.delegate=self;
    
    self.listTabelView.dataSource=self;
    
    self.listTabelView.tableHeaderView=self.headTabelView;
    self.listTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.listTabelView registerClass:[GYHDContactsTableViewCell class] forCellReuseIdentifier:@"GYHDContactsTableViewCell"];
    
    [self.view addSubview:self.listTabelView];
    
    [self.listTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(searchBtn.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-54);
    }];
    
}
#pragma mark -获取通讯录数据


#pragma mark -tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView==self.headTabelView) {
        
        return 1;
    }
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView==self.headTabelView) {
        
        return 3;
    }
    
    GYHDContactsGroupModel*model=self.dataArray[section];
    
    return model.listArray.count;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.headTabelView) {
        
        GYHDContactsHeadCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDContactsHeadCell"];
        if (indexPath.row==0) {
            
            cell.iconImgView.image=[UIImage imageNamed:@"gyhd_contants_newfriends_icon"];
            cell.titleLabel.text=[GYUtils localizedStringWithKey:@"GYHD_newFriend"];
            
        }else if (indexPath.row==1){
            
            cell.iconImgView.image=[UIImage imageNamed:@"gyhd_contants_mark_icon"];
            cell.titleLabel.text=[GYUtils localizedStringWithKey:@"GYHD_Mark"];
            
        }else{
        
            cell.iconImgView.image=[UIImage imageNamed:@"gyhd_contants_company_icon"];
            cell.titleLabel.text=[GYUtils localizedStringWithKey:@"GYHD_Company"];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
    
        GYHDContactsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDContactsTableViewCell"];
        
        GYHDContactsGroupModel*model=self.dataArray[indexPath.section];
        
        GYHDContactsListModel*listModel=model.listArray[indexPath.row];
        
        [cell refreshUIWith:listModel];
//        头像点击事件
        cell.block=^(GYHDContactsListModel*blockModel){
        
            [self enterPersonInfo:blockModel];
        };
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView==self.listTabelView) {
        
        GYHDContactsGroupModel*model=self.dataArray[section];
        
        return model.title;
    }
    return nil;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView==self.listTabelView) {
        
        NSMutableArray*titleArr=[NSMutableArray array];
        
        for ( GYHDContactsGroupModel*model in self.dataArray) {
            
            [titleArr addObject:model.title];
        }
        return titleArr;
    }
    return nil;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView==self.listTabelView) {
        
         GYHDContactsGroupModel*model=self.dataArray[indexPath.section];
        
        GYHDContactsListModel*listModel=model.listArray[indexPath.row];
        
        GYHDChatViewController*vc=[[GYHDChatViewController alloc]init];
        vc.messageCard=listModel.custid;
        self.tabBarController.tabBar.hidden = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
    
        if (indexPath.row==0) {
//        新的朋友
            GYHDNewFriendsViewController*vc=[[GYHDNewFriendsViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if (indexPath.row==1){
//        标签
            GYHDMarkViewController*vc=[[GYHDMarkViewController alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            GYHDFocusCompanyViewController *vc = [[GYHDFocusCompanyViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];           
//       企业
            
        }
    }
}

-(void)searchBtnClick{

    DDLogInfo(@"搜索本地通讯录好友");
    GYHDSeachMessageViewController* seachMessageViewController = [[GYHDSeachMessageViewController alloc] init];
    [self.navigationController pushViewController:seachMessageViewController animated:YES];

}
#pragma mark -添加好友或企业到通讯录
-(void)addFriendClick{

    GYHDSearchFriendViewController*vc=[[GYHDSearchFriendViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark-点击头像进入
-(void)enterPersonInfo:(GYHDContactsListModel*)model{

    DDLogInfo(@"头像点击");
    GYHDFriendDetailViewController *vc = [[GYHDFriendDetailViewController alloc] init];
    vc.FriendCustID=model.custid;
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)backClick{

    [self.navigationController popViewControllerAnimated:YES];

}

- (NSMutableArray *)contactsListWithArray:(NSArray *)array {
    NSArray *ABCArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil];
    NSMutableArray *groupArray = [NSMutableArray array];
    for (NSString *key in ABCArray) {
        GYHDContactsGroupModel *groupModel = [[GYHDContactsGroupModel alloc]init];
        for (GYHDContactsListModel *listModel in array) {
            
            //1. 转字母
            NSString * tempStr =listModel.name;
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
                groupModel.title = key;
                [groupModel.listArray addObject:listModel];
            }
        }
        if (groupModel.title && groupModel.listArray.count > 0) {
            [groupArray addObject:groupModel];
        }
    }
    return  groupArray;
}

@end
