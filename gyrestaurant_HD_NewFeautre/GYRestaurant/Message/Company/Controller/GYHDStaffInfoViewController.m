//
//  GYHDStaffInfoViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDStaffInfoViewController.h"
#import "GYHDStaffInfoView.h"
#import "GYHDNavView.h"
#import "GYHDChatViewController.h"
@interface GYHDStaffInfoViewController ()<GYHDNavViewDelegate>
@property(nonatomic,strong)GYHDChatViewController*chatController;//聊天界面
@end

@implementation GYHDStaffInfoViewController
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden=YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.hidden=YES;
    [self setupNav];
    [self initUI];
}
#pragma mark- 懒加载聊天控制器
-(GYHDChatViewController *)chatController{
    
    if (!_chatController) {
        
        _chatController=[[GYHDChatViewController alloc]init];
        _chatController.isCustomer=NO;
        
    }
    return _chatController;
    
}

- (void)setupNav {
    
    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth ,64)];

    if (self.isCheckAllOperator) {
        
         [navView segmentViewLable:self.OperatorModel.searchUserInfo[@"operName"]];
        
    }else{
    
      [navView segmentViewLable:self.model.operName];
    }
  
    navView.delegate = self;
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth , 64));
    }];
}

- (void)initUI {
    GYHDStaffInfoView *staffInfoView = [[GYHDStaffInfoView alloc]initWithFrame:CGRectMake(0, 64, 350, kScreenHeight)];
    if (self.isCheckAllOperator) {
        
        staffInfoView.operatorModel=self.OperatorModel;
    }else{
        
      staffInfoView.model=self.model;
        
    }
  
    [self.view addSubview:staffInfoView];
    [staffInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(350, kScreenHeight));
    }];
    if (self.isFromSearch) {
        
        self.chatController.isFromSearch=YES;
        self.chatController.userName=self.userName;
        self.chatController.primaryId=self.primaryId;
    }
    [self.chatController.view setFrame:CGRectMake(350, 64, kScreenWidth-350, kScreenHeight-64)];
  
    if (self.isCheckAllOperator) {
        
        NSDictionary*dic=self.OperatorModel.searchUserInfo;
        
         self.chatController.messageCard=dic[@"custId"];
        
    }else{
    
       self.chatController.messageCard=self.model.custId;
    }
    
    [self addChildViewController:self.chatController];
    [self.view addSubview:self.chatController.view];
    
}

- (void)GYHDNavViewGoBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
