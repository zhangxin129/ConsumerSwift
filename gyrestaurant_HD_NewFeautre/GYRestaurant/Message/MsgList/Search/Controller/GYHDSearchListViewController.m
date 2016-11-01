//
//  GYHDSearchListViewController.m
//  GYRestaurant
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchListViewController.h"
#import "GYHDNavView.h"
#import "GYHDSearchMessageListCell.h"
#import "GYHDMessageCenter.h"
#import "GYHDSearchCompanyMessageModel.h"
#import "GYHDStaffInfoViewController.h"
#import "GYHDSearchPushMessageModel.h"
#import "GYHDMsgShowPageController.h"
#import "GYMsgListContentController.h"
@interface GYHDSearchListViewController ()<UITableViewDelegate,UITableViewDataSource,GYHDNavViewDelegate>
@property(nonatomic,strong)UITableView*msgTableView;
@property(nonatomic,strong)NSMutableArray*msgListArr;
@end

@implementation GYHDSearchListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    self.msgTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.msgTableView.delegate=self;
    self.msgTableView.dataSource=self;
    [self.msgTableView registerClass:[GYHDSearchMessageListCell class] forCellReuseIdentifier:@"GYHDSearchMessageListCell"];
    [self.view addSubview:self.msgTableView];
    if ([self.msgType isEqualToString:@"10"]) {
        
        [self loadMessageListData];
    }else{
    
        [self loadPushMessageListData];
    }
    
}
-(NSMutableArray *)msgListArr{
    if (!_msgListArr) {
        
        _msgListArr=[NSMutableArray array];
    }
    return _msgListArr;
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBar.hidden=YES;
    
}
-(void)setupNav{

    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth , 64)];
    navView.delegate = self;
    [navView segmentViewLable:kLocalized(@"消息列表")];
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , 64));
    }];

}
- (void)GYHDNavViewGoBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadMessageListData{

  NSArray*messageArr=  [[GYHDMessageCenter sharedInstance] selectAllChatMessageBYCustId:self.custId];
    
    for (NSDictionary*dict in messageArr) {
        
        GYHDSearchCompanyMessageModel*model=[[GYHDSearchCompanyMessageModel alloc]init];
        model.msgIcon=self.iconUrl;
        model.kerWord=self.keyWord;
        model.msgNote=self.name;
        [model initWithDict:dict];
        
        if ([model.content rangeOfString:self.keyWord options:NSCaseInsensitiveSearch].location!=NSNotFound) {
            
            [self.msgListArr addObject:model];
            
        }
        
    }
    [self.msgTableView reloadData];
}

-(void)loadPushMessageListData{

NSArray*pushMessageArr= [[GYHDMessageCenter sharedInstance]selectPushMssage];
    
    if ([self.pushType isEqualToString:@"1"]) {
//        系统消息
        for (NSDictionary*dict in pushMessageArr) {
            
            GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
            model.kerWord=self.keyWord;
            [model initWithDict:dict];
            
            if ([model.content rangeOfString:self.keyWord options:NSCaseInsensitiveSearch].location!=NSNotFound && [model.msgMainType isEqualToString:@"1"]) {
                
                [self.msgListArr addObject:model];
                
            }
        }
        
    }else if ([self.pushType isEqualToString:@"2"]){
//    订单消息
        for (NSDictionary*dict in pushMessageArr) {
            
            GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
            model.kerWord=self.keyWord;
            [model initWithDict:dict];
            
            if ([model.content rangeOfString:self.keyWord options:NSCaseInsensitiveSearch].location!=NSNotFound && [model.msgMainType isEqualToString:@"2"]) {
                
                [self.msgListArr addObject:model];
            }
        }

    }else{
//    服务消息
        for (NSDictionary*dict in pushMessageArr) {
            
            GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
            model.kerWord=self.keyWord;
            [model initWithDict:dict];
            
            if ([model.content rangeOfString:self.keyWord options:NSCaseInsensitiveSearch].location!=NSNotFound && [model.msgMainType isEqualToString:@"3"]) {
                
                [self.msgListArr addObject:model];
            }
        }
    }
    [self.msgTableView reloadData];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.msgListArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    GYHDSearchMessageListCell*cell=[tableView dequeueReusableCellWithIdentifier:@"GYHDSearchMessageListCell"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if ([self.msgType isEqualToString:@"10"]) {
        
        GYHDSearchCompanyMessageModel*model=self.msgListArr[indexPath.row];
        
        [cell refreshWithGYHDSearchCompanyMessageModel:model];
    }else{
        
        GYHDSearchPushMessageModel*model=self.msgListArr[indexPath.row];
        
        [cell refreshWithGYHDSearchPushMessageModel:model];
    }

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.msgType isEqualToString:@"10"]) {
        
        GYHDSearchCompanyMessageModel*model=self.msgListArr[indexPath.row];
        
        if ([model.UserState isEqualToString:@"c"]) {
            
            [[NSUserDefaults standardUserDefaults] setObject:model.msgCard forKey:@"customerIndex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"navindex"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSMutableDictionary*dic=[NSMutableDictionary dictionary];
            [dic setObject:model.msgID forKey:@"primaryId"];
            [dic setObject:self.name forKey:@"name"];
            [dic setObject:model.msgCard forKey:@"msgCard"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"popCustomerMessage" object:dic];
            
            [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
            
        }else{
            
            GYHDStaffInfoViewController*vc=[[GYHDStaffInfoViewController alloc]init];
            GYHDOpereotrListModel *tempModel=[[GYHDOpereotrListModel alloc]init];
            
            tempModel.saleAndOperatorRelationList=model.saleAndOperatorRelationList;
            
            tempModel.searchUserInfo=model.searchUserInfo;
            
            tempModel.roleName=model.roleName;
            
            vc.OperatorModel=tempModel;
            vc.isCheckAllOperator=YES;
            vc.isFromSearch=YES;
            vc.userName=self.name;
            vc.primaryId=model.msgID;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
    }else{
    
        GYHDSearchPushMessageModel*model=self.msgListArr[indexPath.row];

            if (model.pageUrl && model.pageUrl.length>0) {
        
                GYHDMsgShowPageController*vc=[[GYHDMsgShowPageController alloc]init];
                vc.pageUrl=model.pageUrl;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
        
                GYMsgListContentController*vc=[[GYMsgListContentController alloc]init];
                GYOrderMessageListModel*contentModel=[[GYOrderMessageListModel alloc]init];
        
                contentModel.messageListContent=model.content;
                vc.model=contentModel;
    
                [self.navigationController pushViewController:vc animated:YES];
            }
     }
}
@end
