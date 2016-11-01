//
//  GYHDMainViewController.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDMainViewController.h"
#import "GYHDMainModel.h"
#import "GYHDMainCell.h"
#import "GYHDContactsViewController.h"
#import "GYHDCustomerViewController.h"
#import "GYHDMessageViewController.h"
#import "GYHDManagementViewController.h"
#import "GYHDSearchViewController.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "GYHDMessageCenter.h"


@interface GYHDMainViewController()<UITableViewDataSource,UITableViewDelegate,GYHDMessageViewControllerDelegate>

@property(nonatomic, strong)UITableView *mainTaleView;
@property(nonatomic, strong)NSArray     *mainArray;
@property(nonatomic, weak)GYHDMainModel *selectModel;
/**消息控制器*/
@property(nonatomic,strong)GYHDMessageViewController *messageViewController;
/**客服控制器*/
@property(nonatomic,strong)GYHDCustomerViewController *customerViewController;
/**通讯录控制器*/
@property(nonatomic,strong)GYHDContactsViewController *contactsViewController;
/**搜索控制器*/
@property(nonatomic,strong)GYHDSearchViewController *searchViewController;
/**管理控制器*/
@property(nonatomic,strong)GYHDManagementViewController *managementViewController;
/**连接状态Label*/
@property(nonatomic, strong) UIButton *linkTitleButton;
@end

@implementation GYHDMainViewController

#pragma mark -懒加载视图控制器
-(UITableView *)mainTaleView{

    if (!_mainTaleView) {
        
        _mainTaleView = [[UITableView alloc] init];
        _mainTaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTaleView.dataSource = self;
        _mainTaleView.delegate = self;
        _mainTaleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_mainTaleView registerClass:[GYHDMainCell class] forCellReuseIdentifier:NSStringFromClass([GYHDMainCell class])];
        [self.view addSubview:_mainTaleView];
        [_mainTaleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(100);
        }];
        
    }
    return _mainTaleView;
}

-(GYHDMessageViewController *)messageViewController{

    if (!_messageViewController) {
        
       _messageViewController = [[GYHDMessageViewController alloc] init];
        [self addChildViewController:_messageViewController];
        _messageViewController.delegate=self;
        [self.view addSubview:_messageViewController.view];
        @weakify(self);
        [_messageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.bottom.right.mas_equalTo(0);
            make.left.equalTo(self.mainTaleView.mas_right);
        }];
        
    }
    
    return _messageViewController;
}
//    消息列表跳转到客服模块与通讯录模块 所以客服与通讯录必须进来就得加载数据 不执行懒加载

//-(GYHDCustomerViewController *)customerViewController{
//    
//    if (!_customerViewController) {
//        
//       _customerViewController = [[GYHDCustomerViewController alloc] init];
//        [self addChildViewController:_customerViewController];
//        [self.view addSubview:_customerViewController.view];
//        @weakify(self);
//        [_customerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//             @strongify(self);
//            make.top.left.bottom.right.equalTo(self.messageViewController.view);
//        }];
//
//    }
//
//    return _customerViewController;
//}
//
//-(GYHDContactsViewController *)contactsViewController{
//
//    if (!_contactsViewController) {
//        _contactsViewController = [[GYHDContactsViewController alloc] init];
//        [self addChildViewController:_contactsViewController];
//        [self.view addSubview:_contactsViewController.view];
//        @weakify(self);
//        [_contactsViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            @strongify(self);
//            make.top.left.bottom.right.equalTo(self.messageViewController.view);
//        }];
//        
//        
//    }
//    return _contactsViewController;
//}

//-(GYHDSearchViewController *)searchViewController{
//
//    if (!_searchViewController) {
//        
//        _searchViewController = [[GYHDSearchViewController alloc] init];
//        [self addChildViewController:_searchViewController];
//        [self.view addSubview:_searchViewController.view];
//        @weakify(self);
//        
//        [_searchViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//            make.top.left.bottom.right.equalTo(self.messageViewController.view);
//        }];
//        
//    }
//
//    return _searchViewController;
//}

//-(GYHDManagementViewController *)managementViewController{
//
//    if (!_managementViewController) {
//   
//        _managementViewController = [[GYHDManagementViewController alloc] init];
//        [self addChildViewController:_managementViewController];
//        [self.view addSubview:_managementViewController.view];
//           @weakify(self);
//        [_managementViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//            make.top.left.bottom.right.equalTo(self.messageViewController.view);
//        }];
//
//        
//    }
//    return _managementViewController;
//}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
//    用来清掉沙盒存储的企业和消费者custid，主要为接收通知时的未读显示判定作逻辑处理
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomerMsgCard"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyMsgCard"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GYHDMainModel *messageModel = [[GYHDMainModel alloc] init];
    messageModel.select = YES;
    messageModel.topImageString = @"gyhd_message_btn_normal";
    messageModel.topSelectImageString = @"gyhd_message_btn_select";
    messageModel.bottomTitleString = kLocalized(@"GYHD_Message");
    self.title=kLocalized(@"GYHD_Message");
    self.selectModel = messageModel;
    
    GYHDMainModel *customerModel = [[GYHDMainModel alloc] init];
    customerModel.topImageString = @"gyhd_Customer_normal";
    customerModel.topSelectImageString = @"gyhd_Customer_select";
    customerModel.bottomTitleString = kLocalized(@"GYHD_CustomerService");
    
    GYHDMainModel *contactsModel = [[GYHDMainModel alloc] init];
    contactsModel.topImageString = @"gyhd_Contacts_normal";
    contactsModel.topSelectImageString = @"gyhd_Contacts_select";
    contactsModel.bottomTitleString = kLocalized(@"GYHD_Contacts");

    GYHDMainModel *searchModel = [[GYHDMainModel alloc] init];
    searchModel.topImageString = @"gyhd_Search_btn_normal";
    searchModel.topSelectImageString = @"gyhd_Search_btn_select";
    searchModel.bottomTitleString = kLocalized(@"GYHD_Search");

    GYHDMainModel *managementModel = [[GYHDMainModel alloc] init];
    managementModel.topImageString = @"gyhd_management_btn_normal";
    managementModel.topSelectImageString = @"gyhd_management_btn_select";
    managementModel.bottomTitleString = kLocalized(@"GYHD_Manage");
    
    NSMutableArray *modelArray = [NSMutableArray array];
    
    NSMutableArray*roleArray=[NSMutableArray array];
    
    for (Role*role in globalData.loginModel.roles) {
        
        [roleArray addObject:role.roleId];
        
    }
    //  判断是否是成员企业或者托管企业系统管理员
    if ([roleArray containsObject:@"201"]|| [roleArray containsObject:@"301"]) {
        
         [modelArray addObjectsFromArray:@[messageModel,customerModel,contactsModel,searchModel,managementModel]];
        
    }else{
        
        [modelArray addObjectsFromArray:@[messageModel,customerModel,contactsModel,searchModel]];
    
    }
    
    _mainArray = modelArray;
    
    [self.mainTaleView reloadData];
    
    //    消息列表跳转到客服模块与通讯录模块 所以客服与通讯录必须进来就得加载数据 不执行懒加载
    
    self.customerViewController = [[GYHDCustomerViewController alloc] init];
    [self addChildViewController:self.customerViewController];
    [self.view addSubview:self.customerViewController.view];
    self.customerViewController.view.hidden=YES;
    @weakify(self);
    [self.customerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.bottom.right.equalTo(self.messageViewController.view);
    }];
    
    self.contactsViewController = [[GYHDContactsViewController alloc] init];
    [self addChildViewController: self.contactsViewController ];
    [self.view addSubview: self.contactsViewController .view];
    self.contactsViewController.view.hidden=YES;
    [ self.contactsViewController .view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.bottom.right.equalTo(self.messageViewController.view);
    }];
    
    self.searchViewController = [[GYHDSearchViewController alloc] init];
    [self addChildViewController:_searchViewController];
     self.searchViewController.view.hidden=YES;
    [self.view addSubview:_searchViewController.view];

    [self.searchViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.bottom.right.equalTo(self.messageViewController.view);
    }];

    self.managementViewController = [[GYHDManagementViewController alloc] init];
    self.managementViewController.view.hidden=YES;
    [self addChildViewController:_managementViewController];
    [self.view addSubview:_managementViewController.view];
    [self.managementViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.left.bottom.right.equalTo(self.messageViewController.view);
    }];

    self.linkTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkTitleButton.titleLabel.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    [self.linkTitleButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.linkTitleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.linkTitleButton setImage:[UIImage imageNamed:@"gyhd_chat_failue_btn_normal"] forState:UIControlStateNormal];
    self.linkTitleButton.imageEdgeInsets=UIEdgeInsetsMake(0, -30, 0, 0);
    [self.linkTitleButton setTitle:kLocalized(@"GYHD_Network_Connection_Failed_Please_Check_The_Network") forState:UIControlStateNormal];
    
    [self.linkTitleButton setBackgroundColor:[UIColor colorWithRed:253/255.0f green:239/255.0f blue:219/255.0f alpha:1]];
    self.linkTitleButton.frame = CGRectMake(0, 44, kScreenWidth, 30);
    [self.view addSubview:self.linkTitleButton];
    self.linkTitleButton.hidden=YES;
    
    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.enableAutoToolbar = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageListClick:) name:GYHDHDMainChageTabBarIndexNotification object:nil];
    
     [[GYHDMessageCenter sharedInstance] addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:nil];
    
    [self checkLinkTileButtonState];
}


#pragma mark - 通知移除
- (void)dealloc {
    IQKeyboardManager* manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.enableAutoToolbar = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GYHDHDMainChageTabBarIndexNotification object:nil];
    [[GYHDMessageCenter sharedInstance] removeObserver:self forKeyPath:@"state"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mainArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHDMainCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDMainCell class])];
    cell.model = self.mainArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHDMainModel *model =  self.mainArray[indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CustomerMsgCard"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyMsgCard"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![model isEqual:self.selectModel]) {
        if ([model.bottomTitleString isEqualToString:kLocalized(@"GYHD_Message")]) {
            
            self.messageViewController.view.hidden=NO;
            self.customerViewController.view.hidden=YES;
             self.contactsViewController.view.hidden=YES;
             self.searchViewController.view.hidden=YES;
            self.managementViewController.view.hidden=YES;
            self.title=kLocalized(@"GYHD_Message");
        }else if ([model.bottomTitleString isEqualToString:kLocalized(@"GYHD_CustomerService")]){
        
            self.messageViewController.view.hidden=YES;
            self.customerViewController.view.hidden=NO;
            self.contactsViewController.view.hidden=YES;
            self.searchViewController.view.hidden=YES;
            self.managementViewController.view.hidden=YES;
            self.customerViewController.chatViewController.view.hidden=YES;
            self.title=kLocalized(@"GYHD_CustomerService");
        }else if ([model.bottomTitleString isEqualToString:kLocalized(@"GYHD_Contacts")]){
            
            self.messageViewController.view.hidden=YES;
            self.customerViewController.view.hidden=YES;
            self.contactsViewController.view.hidden=NO;
            self.searchViewController.view.hidden=YES;
            self.managementViewController.view.hidden=YES;
             self.contactsViewController.chatVc.view.hidden=YES;
            self.title=kLocalized(@"GYHD_Contacts");
        }else if ([model.bottomTitleString isEqualToString:kLocalized(@"GYHD_Search")]){
            self.messageViewController.view.hidden=YES;
            self.customerViewController.view.hidden=YES;
            self.contactsViewController.view.hidden=YES;
            self.searchViewController.view.hidden=NO;
            self.managementViewController.view.hidden=YES;
            self.title=kLocalized(@"GYHD_Search");
        }else if ([model.bottomTitleString isEqualToString:kLocalized(@"GYHD_Manage")]){
        
            self.messageViewController.view.hidden=YES;
            self.customerViewController.view.hidden=YES;
            self.contactsViewController.view.hidden=YES;
            self.searchViewController.view.hidden=YES;
            self.managementViewController.view.hidden=NO;
            self.title=kLocalized(@"GYHD_Manage");
        }
        model.select = YES;
        self.selectModel.select = NO;
        self.selectModel = model;
        [self.mainTaleView reloadData];
    }
}

#pragma mark -GYHDMessageViewControllerDelegate
//红点提示
-(void)showMsgTip{

    GYHDMainModel *model =  self.mainArray[0];

    model.msgTip=YES;
    
    [self.mainTaleView reloadData];
}
//红点隐藏
-(void)hidenMsgTip{
    
    GYHDMainModel *model =  self.mainArray[0];
    
    model.msgTip=NO;
    
    [self.mainTaleView reloadData];

}
#pragma mark -监听消息列表和搜索列表发出的跳转通知
-(void)messageListClick:(NSNotification*)noti{

    NSDictionary *dict=noti.object;
    
    NSInteger index =[dict[@"index"]integerValue];
    
    switch (index) {
        case 1:{
        
            self.messageViewController.view.hidden=YES;
            self.customerViewController.view.hidden=NO;
            self.contactsViewController.view.hidden=YES;
            self.searchViewController.view.hidden=YES;
            self.managementViewController.view.hidden=YES;
            
            GYHDMainModel *model =  self.mainArray[1];
            model.select = YES;
            self.selectModel.select = NO;
            self.selectModel = model;
            [self.mainTaleView reloadData];
        }
        break;
        case 2:{
            
            self.messageViewController.view.hidden=YES;
            self.customerViewController.view.hidden=YES;
            self.contactsViewController.view.hidden=NO;
            self.searchViewController.view.hidden=YES;
            self.managementViewController.view.hidden=YES;
            GYHDMainModel *model =  self.mainArray[2];
            model.select = YES;
            self.selectModel.select = NO;
            self.selectModel = model;
            [self.mainTaleView reloadData];
        }break;
        default:
            break;
    }
    
}

#pragma mark - 监听互信登录连接状态
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary<NSString*, id>*)change context:(void*)context
{
    if ([keyPath isEqualToString:@"state"]) {
       
        [self checkLinkTileButtonState];
    }
}

-(void)checkLinkTileButtonState{

    dispatch_async(dispatch_get_main_queue(), ^{
        
        switch ([GYHDMessageCenter sharedInstance].state) {
                
            case   GYHDMessageLoginStateAuthenticateSucced://登录验证成功
            {
                self.linkTitleButton.hidden = YES;
                
//                [UIView animateWithDuration:1.0 animations:^{
                
                    @weakify(self);
                    [self.mainTaleView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(0);
                        make.left.bottom.mas_equalTo(0);
                        make.width.mas_equalTo(100);
                    }];
                    
                    [self.messageViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
                        @strongify(self);
                        make.top.bottom.right.mas_equalTo(0);
                        make.left.equalTo(self.mainTaleView.mas_right);
                    }];
 
                    
//                }];

                break;
            }
            case   GYHDMessageLoginStateAuthenticateFailure:
            case   GYHDMessageLoginStateConnetToServerFailure:
            case   GYHDMessageLoginStateUnknowError:
            case   GYHDMessageLoginStateConnetToServerSucced:
            case   GYHDMessageLoginStateConnetToServerTimeout:
            {
                self.linkTitleButton.hidden = NO;
                
//                [UIView animateWithDuration:1.0 animations:^{
                
                    @weakify(self);
                    [self.mainTaleView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(30);
                        make.left.bottom.mas_equalTo(0);
                        make.width.mas_equalTo(100);
                    }];
                    
                    [self.messageViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
                        @strongify(self);
                        make.top.mas_equalTo(30);
                        make.bottom.right.mas_equalTo(0);
                        make.left.equalTo(self.mainTaleView.mas_right);
                    }];
                    
//                }];
              
                
                break;
            }
                
            case GYHDMessageLoginStateOtherLogin:
            {
                
                [self.linkTitleButton setTitle:kLocalized(@"GYHD_Your_Account_Number_On_Other_Terminals_Please_Visit_www.hsxt.net_Modify_The_Login_Password") forState:UIControlStateNormal];
                self.linkTitleButton.hidden= NO;
//                [UIView animateWithDuration:1.0 animations:^{
                
                    @weakify(self);
                    [self.mainTaleView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(30);
                        make.left.bottom.mas_equalTo(0);
                        make.width.mas_equalTo(100);
                    }];
                    
                    [self.messageViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
                        @strongify(self);
                        make.top.mas_equalTo(30);
                        make.bottom.right.mas_equalTo(0);
                        make.left.equalTo(self.mainTaleView.mas_right);
                    }];
                    
//                }];
                
                break;
            }
            default:
                break;
        }
    });
}
@end

