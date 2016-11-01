//
//  GYHDMarkViewController.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDMarkViewController.h"
#import "GYHDMessageCenter.h"
#import "GYHDContactsMarkListModel.h"
#import "GYHDContactsMarkCell.h"
#import "GYHDNewMarkViewController.h"
@interface GYHDMarkViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* listTabelView;
@property(nonatomic,strong)NSMutableArray*dataArray;
@end

@implementation GYHDMarkViewController

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
    [self loadMarksData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
       [self setupNav];
    
        [self setupUI];

}

#pragma mark - 导航栏设置
-(void)setupNav{
    
    self.title=[GYUtils localizedStringWithKey:@"GYHD_Mark"];
    
    UIButton*backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame=CGRectMake(0, 0, 44, 44);
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [backBtn setImage:[UIImage imageNamed:@"gyhd_back_icon"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

#pragma mark - 页面设置
-(void)setupUI{
    
    UIView*headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 88)];
    headView.backgroundColor=[UIColor whiteColor];
    
    UIButton*newMarkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    newMarkBtn.frame=CGRectMake(12, 22, 300, 44);
    
    [newMarkBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_NewCreateMark"] forState:UIControlStateNormal];
    [newMarkBtn setTitleColor:[UIColor colorWithHexString:@"#ef4136"] forState:UIControlStateNormal];
    [newMarkBtn addTarget:self action:@selector(newMarkClick) forControlEvents:UIControlEventTouchUpInside];
    [newMarkBtn setImageEdgeInsets:UIEdgeInsetsMake(0,-210, 0, 0)];
    [newMarkBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -190, 0, 0)];
    [newMarkBtn setImage:[UIImage imageNamed:@"gyhd_contants_addmember_icon"] forState:UIControlStateNormal];
    
    [headView addSubview:newMarkBtn];

    self.listTabelView=[[UITableView alloc]init];
    
    self.listTabelView.rowHeight=88;
    
    self.listTabelView.delegate=self;
    
    self.listTabelView.dataSource=self;
    
    self.listTabelView .tableHeaderView=headView;
    
    self.listTabelView.backgroundColor=[UIColor whiteColor];
    
    [self.listTabelView registerClass:[GYHDContactsMarkCell class] forCellReuseIdentifier:@"GYHDContactsMarkCell"];
    
    [self.view addSubview:self.listTabelView];
    
    [self.listTabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(-54);
    }];
    
}

#pragma mark - 加载标签数据
-(void)loadMarksData{

    WS(weakSelf);

    NSArray *dbArray =  [[GYHDMessageCenter sharedInstance] getFriendTeamRequetResult:^(NSArray *resultArry) {
        NSLog(@"%@",resultArry);
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in resultArry) {
            GYHDContactsMarkListModel*model=[[GYHDContactsMarkListModel alloc]init];
            model.title= dict[@"teamName"];
            model.teamID = dict[@"teamId"];
            NSArray *teamArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:dict[@"teamId"]];
            for (NSDictionary *teamDict in teamArray) {
                 [model.markListArray addObject:teamDict[GYHDDataBaseCenterFriendName]];
                [model.markListCustIDArray addObject:teamDict[GYHDDataBaseCenterFriendFriendID]];
            }
            [array addObject:model];

        }
        weakSelf.dataArray = array;
        [weakSelf.listTabelView reloadData];
    }];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict1 in dbArray) {
        NSDictionary *dict = [GYUtils stringToDictionary:dict1[@"Tream_detal"]];
        GYHDContactsMarkListModel*model=[[GYHDContactsMarkListModel alloc]init];
        model.teamID = dict[@"teamId"];
        model.title= dict[@"teamName"];
        NSArray *teamArray = [[GYHDMessageCenter sharedInstance] selectFriendWithTeamID:dict[@"teamId"]];
        for (NSDictionary *teamDict in teamArray) {
            [model.markListArray addObject:teamDict[GYHDDataBaseCenterFriendName]];
            [model.markListCustIDArray addObject:teamDict[GYHDDataBaseCenterFriendFriendID]];
        }
        [array addObject:model];

    }
    weakSelf.dataArray = array;
    [weakSelf.listTabelView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GYHDContactsMarkCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDContactsMarkCell"];
    GYHDContactsMarkListModel*model=self.dataArray[indexPath.row];
    [cell refreshUIWith:model];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleDelete;
}

//根据不同的editingstyle执行数据删除操作（点击左滑删除按钮的执行的方法）

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    NSLog(@"删除");
    GYHDContactsMarkListModel*model=self.dataArray[indexPath.row];
    WS(weakSelf);
    [[GYHDMessageCenter sharedInstance] deleteFriendTeamID:model.teamID RequetResult:^(NSDictionary *resultDict) {
        NSLog(@"%@",resultDict);
        [weakSelf.dataArray removeObject:model];
        [weakSelf.listTabelView reloadData];
    }];
}

//修改左滑删除按钮的title

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHDContactsMarkListModel*model=self.dataArray[indexPath.row];
    NSLog(@"选中, %@",model.title);
    GYHDNewMarkViewController*vc=[[GYHDNewMarkViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - 新建标签
-(void)newMarkClick{

    GYHDNewMarkViewController*vc=[[GYHDNewMarkViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)backClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
