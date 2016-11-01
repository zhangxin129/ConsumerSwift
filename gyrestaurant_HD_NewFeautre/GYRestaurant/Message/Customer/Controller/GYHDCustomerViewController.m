//
//  GYHDCustomerViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCustomerViewController.h"
//#import "GYHDCustomerListView.h"
#import "GYHDChatViewController.h"
#import "GYHDCustomerModel.h"
#import "GYHDMessageCenter.h"
#import "GYHDDataBaseCenter.h"
@interface GYHDCustomerViewController ()
@property(nonatomic,strong)GYHDChatViewController*chatController;//聊天界面
@property(nonatomic,strong)NSMutableArray*messageDataSouce;//消息数组
@property(nonatomic,assign)NSInteger customerIndex;//记录选中聊天列表
@end

@implementation GYHDCustomerViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _customerMessageDatas=[NSMutableArray array];
        _messageDataSouce=[NSMutableArray array];
    }
    return self;
}
//获取之前点击的消费者信息进入并显示
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    NSString*customerIndex=[[NSUserDefaults standardUserDefaults] objectForKey:@"customerIndex"];
    
    if (customerIndex!=nil && self.messageDataSouce.count>0) {
        
        for (GYHDCustomerModel*model in self.messageDataSouce) {
            
            if ([model.Friend_CustID isEqualToString:customerIndex]) {
                
                self.chatController.model=model;
                
                self.chatController.messageCard=model.Friend_CustID;
                
                self.chatController.view.hidden=NO;
                
                [self.customerListView.tableView reloadData];
            }
            
        }
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
        [self.chatController.view setFrame:CGRectMake(350, 0, kScreenWidth-350, kScreenHeight)];
        [self addChildViewController:self.chatController];
        self.chatController.view.hidden=YES;
        [self.view addSubview:self.chatController.view];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchPop:) name:@"popCustomerMessage" object:nil];
   
}

-(GYHDChatViewController *)chatController{

    if (!_chatController) {
        
        _chatController=[[GYHDChatViewController alloc]init];
        
        _chatController.isCustomer=YES;
        
    }
    return _chatController;
    
}

- (void)initUI {
    
    for (UIView*view in self.view.subviews) {
        
        if ([view isKindOfClass:[self.customerListView class]]) {
            
            [view removeFromSuperview];
            
        }
    }
    
    GYHDCustomerListView *customerListView = [[GYHDCustomerListView alloc]initWithFrame:CGRectMake(0 , 0, 350, kScreenHeight - 20)];
    customerListView.delegate=self;
    customerListView.dele=self.chatController;
    [self.view addSubview:customerListView];
    self.customerListView=customerListView;
    customerListView.dataSource=self.messageDataSouce;
    
}
#pragma mark - 传入消费者数据源
-(void)setCustomerMessageDatas:(NSMutableArray *)customerMessageDatas{

    _customerMessageDatas=customerMessageDatas;
    
    for (NSDictionary*dic in customerMessageDatas) {
        
        GYHDCustomerModel*model=[[GYHDCustomerModel alloc]init];
        
        [model initModelWithDic:dic];
        
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:model.MSG_Card];
//        if (model.messageUnreadCount.integerValue>0) {
//            
//            [self.mainView showCustomerLabel];
//        }
        model.isSelect=NO;
        [self.messageDataSouce addObject:model];
    }

        [self initUI];

}

-(void)searchPop:(NSNotification*)noti{
    
    NSDictionary *dic=noti.object;
    if ([dic[@"name"]isEqualToString:@""]||[dic[@"primaryId"] isEqualToString:@""]) {
        self.chatController.messageCard=dic[@"msgCard"];
        return;
    }
    self.chatController.userName=dic[@"name"];
    self.chatController.primaryId=dic[@"primaryId"];
    self.chatController.isFromSearch=YES;
    self.chatController.messageCard=dic[@"msgCard"];
    [self.chatController.chatArrayM removeAllObjects];
    [self.chatController loadChat];
}

-(void)dealloc{

[[NSNotificationCenter defaultCenter]removeObserver:self name:@"popCustomerMessage" object:nil];
}
@end
