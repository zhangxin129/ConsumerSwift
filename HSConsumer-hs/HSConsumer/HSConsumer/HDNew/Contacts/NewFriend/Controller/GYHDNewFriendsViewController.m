//
//  GYHDNewFriendsViewController.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDNewFriendsViewController.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDContactsListModel.h"
#import "GYHDNewFriendsCell.h"
#import "GYHDFriendDetailViewController.h"
#import "GYHDApplicantDetailViewController.h"
#import "GYHDSearchUserViewController.h"
@interface GYHDNewFriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* listTabelView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation GYHDNewFriendsViewController

-(NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
//@property(nonatomic,copy)NSString*iconUrl;//头像
//@property(nonatomic,copy)NSString*name;//姓名
//@property(nonatomic,copy)NSString*content;//内容
//@property(nonatomic,copy)NSString*custid;
//@property(nonatomic,copy)NSString* addState;//添加好友的状态 1:已添加 2：接受

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:19],
       
       NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
    selectDict[GYHDDataBaseCenterPushMessageCode] = @(GYHDProtobufMessage04101);
    NSArray* array = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName];
    NSMutableArray* applicantArray = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        GYHDContactsListModel* model = [[GYHDContactsListModel alloc] init];
            NSMutableDictionary* bodyDict = [GYUtils stringToDictionary:dict[GYHDDataBaseCenterPushMessageBody]].mutableCopy;
        model.iconUrl = bodyDict[@"msg_icon"];
        model.name =  bodyDict[@"msg_note"];
        model.content =  bodyDict[@"reqInfo"];
        model.addState = bodyDict[@"status"];
        model.custid = dict[GYHDDataBaseCenterPushMessageFromID];
        [applicantArray addObject:model];
    }
    self.dataArray = applicantArray;
    
    [self.listTabelView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
     [self setupNav];
    
     [self setupUI];
    
//    [self loadNewFriendsData];
    
}
#pragma mark - 导航栏设置
-(void)setupNav{
    
    self.title=[GYUtils localizedStringWithKey:@"GYHD_newFriend"];
    
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame=CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBtn setImage:[UIImage imageNamed:@"gyhd_back_icon"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
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
    [searchBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_searchHusheng"] forState:UIControlStateNormal];
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
    
    self.listTabelView=[[UITableView alloc]init];
    
    self.listTabelView.rowHeight=66;
    
    self.listTabelView.delegate=self;
    
    self.listTabelView.dataSource=self;
    
    self.listTabelView.backgroundColor=[UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    
    [self.listTabelView registerClass:[GYHDNewFriendsCell class] forCellReuseIdentifier:@"GYHDNewFriendsCell"];
    self.listTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.listTabelView];
    
    [self.listTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(searchBtn.mas_bottom).offset(5);
        make.bottom.mas_equalTo(-54);
    }];
    
}


#pragma mark- 加载新朋友数据
-(void)loadNewFriendsData{

    for (int i =0; i<5; i++) {
        
        GYHDContactsListModel*model=[[GYHDContactsListModel alloc]init];
        
        model.name=@"安迪";
        model.content=@"哈喽大家好";
        model.addState=[NSString stringWithFormat:@"%d",arc4random()%2+1];
        [self.dataArray addObject:model];
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GYHDNewFriendsCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDNewFriendsCell"];
    GYHDContactsListModel*model=self.dataArray[indexPath.row];
    [cell refreshUIWith:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    
    GYHDContactsListModel*model=self.dataArray[indexPath.row];
    if ([model.addState isEqualToString:@"1"]) {        // 已经添加
        GYHDFriendDetailViewController *vc = [[GYHDFriendDetailViewController alloc] init];
        if (model.custid.length> 15) {
            if ([model.custid rangeOfString:@"nc"].location != NSNotFound)  {
                vc.FriendCustID = [model.custid substringWithRange:NSMakeRange(5, 11)];
            }else {
                vc.FriendCustID = [model.custid substringWithRange:NSMakeRange(4, 11)];
            }
          
        }

        [self.navigationController pushViewController:vc animated:YES];
    }else {  // 为添加
        GYHDApplicantDetailViewController *vc = [[GYHDApplicantDetailViewController alloc] init];
//        vc.model.applicantNikeNameString = model.name;
//        vc.model.applicantHeadImageUrlString = model.iconUrl;
//        vc.model.applicantCont = model.content;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        GYHDApplicantListModel *listModel = [[GYHDApplicantListModel alloc] init];
        dict[@"msg_icon"] = model.iconUrl;
        dict[@"msg_note"] = model.name;
        dict[@"fromId"] = model.custid;
        dict[@"req_info"] = model.content;
        listModel.applicantBody = [GYUtils dictionaryToString:dict];
        listModel.applicantID = model.custid;
        vc.model = listModel;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    GYHDContactsListModel*model=self.dataArray[indexPath.row];
  
    NSMutableDictionary *deleteDict = [NSMutableDictionary dictionary];
    deleteDict[GYHDDataBaseCenterPushMessagePlantFromID] = model.custid;
    
    [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:deleteDict TableName:GYHDDataBaseCenterPushMessageTableName];
    [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:@{GYHDDataBaseCenterMessageFromID:model.custid} TableName:GYHDDataBaseCenterMessageTableName];
    [[GYHDMessageCenter sharedInstance] deleteInfoWithDict:@{GYHDDataBaseCenterMessageToID:model.custid} TableName:GYHDDataBaseCenterMessageTableName];
    [self.dataArray removeObjectAtIndex:indexPath.row];
    [self.listTabelView reloadData];
    NSLog(@"删除");

}

//修改左滑删除按钮的title

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}


#pragma mark -添加好友或企业到通讯录
-(void)addFriendClick{
    
    GYHDSearchFriendViewController*vc=[[GYHDSearchFriendViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)searchBtnClick{
    
    DDLogInfo(@"搜索本地新朋友");
    GYHDSearchUserViewController* seachMessageViewController = [[GYHDSearchUserViewController alloc] init];
    [self.navigationController pushViewController:seachMessageViewController animated:YES];
    
}

-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end

