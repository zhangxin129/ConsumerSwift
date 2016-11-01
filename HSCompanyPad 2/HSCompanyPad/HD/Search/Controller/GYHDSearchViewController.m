//
//  GYHDSearchViewController.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDSearchViewController.h"
#import "GYHDPopMoreView.h"
//#import "GYHDSearchListCell.h"
#import "GYHDSearchPushMessageModel.h"
#import "GYHDSearchMessageListModel.h"
#import "GYHDSearchCustomerListModel.h"
#import "GYHDSearchCustomerMessageModel.h"
#import "GYHDSearchModel.h"
#import "GYHDSearchCompanyListModel.h"
#import "GYHDCustomerMessageCell.h"
#import "GYHDSearchCompanyListCell.h"
#import "GYHDSearchCompanyMessageCell.h"
#import "GYHDSearchCompanyMessageModel.h"
#import "GYHDSearchMessageListCell.h"
#import "GYHDMsgShowPageController.h"
#import "GYMsgListContentController.h"

#define kGYHDCustomerMessageCell @"GYHDCustomerMessageCell"
#define kGYHDSearchCompanyListCell @"GYHDSearchCompanyListCell"
#define kGYHDSearchCompanyMessageCell @"GYHDSearchCompanyMessageCell"
@interface GYHDSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
/**左边tableview*/
@property(nonatomic, strong)UITableView     *leftTableView;
/**左边表格数据源*/
@property(nonatomic, strong)NSMutableArray  *leftArray;
/**右边tableview*/
@property(nonatomic, strong)UITableView     *rightTableView;
/**右边表格数据源*/
@property(nonatomic, strong)NSMutableArray  *rightArray;

@property(nonatomic, strong)UIView          *leftHeaderView;

@property(nonatomic, strong)UITextField     *field;
@property(nonatomic, strong)UIButton        *overButton;
@property(nonatomic,copy)NSString*keyWordStr;//搜索字段
@property(nonatomic,strong)NSMutableArray*pushMessageArr;//推送消息
@property(nonatomic,strong)NSMutableArray*companyListArr;//企业操作员列表
@property(nonatomic,strong)NSMutableArray*allChatMessageArr;//聊天消息
@property(nonatomic,strong)NSMutableArray*allMessageArr;//所有消息
@property(nonatomic,strong)NSMutableArray*customerListArr;//客户咨询列表
@property(nonatomic,copy)NSString*selectStr;//搜索结果显示类别
@property(nonatomic,copy)NSString*msgType;//区分聊天消息和推送消息

@end

@implementation GYHDSearchViewController
#pragma mark -搜索框
- (void)createLeftHeaderView {
    self.leftHeaderView = [[UIView alloc] init];
    self.leftHeaderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.leftHeaderView];
    self.overButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ self.overButton setTitle:kLocalized(@"GYHD_All") forState:UIControlStateNormal];
    [ self.overButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ self.overButton setImage:[UIImage imageNamed:@"gyhd_search_unselect_icon"] forState:UIControlStateNormal];
    [ self.overButton setImageEdgeInsets:UIEdgeInsetsMake(0, 60, 0, 0)];
    [ self.overButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    self.overButton.frame = CGRectMake(0, 0, 80, 60);
    self.overButton.titleLabel.font=[UIFont systemFontOfSize:16.0];
    [ self.overButton addTarget:self action:@selector(overBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.field = [[UITextField alloc] init];
    self.field.backgroundColor = [UIColor colorWithHex:0xf5f5f5];
    self.field.borderStyle = UITextBorderStyleNone;
    self.field.layer.masksToBounds = YES;
    self.field.returnKeyType=UIReturnKeySearch;
    [self.field addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingChanged];
    self.field.delegate=self;
    self.field.placeholder=kLocalized(@"GYHD_Please_Enter_The_Key_Words");
    self.field.layer.cornerRadius = 15.0f;
    self.field.leftView =  self.overButton;
    self.field.leftViewMode = UITextFieldViewModeAlways;
    [self.leftHeaderView addSubview:self.field];
    
    [self.leftHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(44);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(325);
        make.height.mas_equalTo(60);
    }];
    @weakify(self);
    [self.field mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.center.equalTo(self.leftHeaderView);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(30);
    }];
    
}
#pragma mark - 搜索条件选择
- (void)overBtnClick:(UIButton *)btn {
    GYHDPopMoreView *popView = [[GYHDPopMoreView alloc] init];
    popView.moreSelectArray = @[kLocalized(@"GYHD_All"),kLocalized(@"GYHD_Message"),kLocalized(@"GYHD_CustomerService"),kLocalized(@"GYHD_Contacts")];
    [popView showBottomTo:btn];
    @weakify(self);
    popView.block = ^(NSString *selectString) {
        DDLogInfo(@"%@",selectString);
        @strongify(self);
        [ self.overButton setTitle:selectString forState:UIControlStateNormal];
        [ self.overButton setTitleColor:[UIColor colorWithHex:0x3e8ffa] forState:UIControlStateNormal];
        [ self.overButton setImage:[UIImage imageNamed:@"gyhd_search_select_icon"] forState:UIControlStateNormal];
        
        self.selectStr=selectString;
        
        [self searchByKeyWords:self.keyWordStr];
    };
}

#pragma mark -数据源懒加载相关
-(UITableView *)leftTableView{
    
    if (!_leftTableView) {
        
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _leftTableView.rowHeight = 66;
        [_leftTableView registerClass:[GYHDCustomerMessageCell class] forCellReuseIdentifier:kGYHDCustomerMessageCell];
        [_leftTableView registerClass:[GYHDSearchCompanyListCell class] forCellReuseIdentifier:kGYHDSearchCompanyListCell];
        [_leftTableView registerClass:[GYHDSearchCompanyMessageCell class] forCellReuseIdentifier:kGYHDSearchCompanyMessageCell];
        [self.view addSubview:_leftTableView];
        
        @weakify(self);
        
        [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.leftHeaderView.mas_bottom);
            make.left.bottom.mas_equalTo(0);
            make.width.mas_equalTo(325);
        }];
        
    }
    
    return _leftTableView;
}

-(UITableView *)rightTableView{
    
    if (!_rightTableView) {
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        _rightTableView.backgroundColor=kDefaultVCBackgroundColor;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _rightTableView.rowHeight = 86;
     
        [_rightTableView registerClass:[GYHDSearchMessageListCell class] forCellReuseIdentifier:@"GYHDSearchMessageListCell"];
        [self.view addSubview:_rightTableView];
        @weakify(self);
        [_rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.mas_equalTo(44);
            make.bottom.mas_equalTo(0);
            make.right.mas_equalTo(-20);
            make.left.equalTo(self.leftTableView.mas_right).offset(20);
        }];
        
    }
    return _rightTableView;
}


-(NSMutableArray *)leftArray{
    
    if (!_leftArray) {
        
        _leftArray=[NSMutableArray array];
    }
    return _leftArray;
}


-(NSMutableArray *)rightArray{
    
    if (!_rightArray) {
        
        _rightArray=[NSMutableArray array];
    }
    return _rightArray;
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
#pragma mark -
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createLeftHeaderView];
    
    self.rightTableView.hidden = YES;
    
    self.selectStr = kLocalized(@"GYHD_All");
}

//键盘搜索事件
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    [self.field resignFirstResponder];//关闭键盘
    if (aTextfield.text.length>0) {
        
        self.keyWordStr=aTextfield.text;
        
        [self searchByKeyWords:self.keyWordStr];
    }
    
    
    return YES;
}

- (void)search:(UITextField *)textField {
    
    self.keyWordStr=textField.text;
    [self searchByKeyWords:self.keyWordStr];
    
}

#pragma mark -  关键字搜索
-(void)searchByKeyWords:(NSString*)keyWords{
    
    NSMutableArray *tempArr=[NSMutableArray array];
    
    //过滤字符串前后的空格
    self.keyWordStr = [self.keyWordStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //过滤中间空格
    self.keyWordStr = [self.keyWordStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    DDLogInfo(@"keyWord=%@",self.keyWordStr);
    
    
    [self.pushMessageArr removeAllObjects];
    [self.customerListArr removeAllObjects];
    [self.companyListArr removeAllObjects];
    [self.allMessageArr removeAllObjects];
    [self.allChatMessageArr removeAllObjects];
    [self.leftArray removeAllObjects];
    
    if (self.keyWordStr.length<=0) {
        
        [self.leftTableView reloadData];
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
            searchModel.titleName=kLocalized(@"GYHD_SystemMessage_Message");
        }else if([model.msgMainType isEqualToString:@"2"]){
            
            searchModel.pullMsgType=@"2";
            searchModel.titleName=kLocalized(@"GYHD_OrderMessage_Message");
        }else if ([model.msgMainType isEqualToString:@"3"]){
            
            searchModel.pullMsgType=@"3";
            searchModel.titleName=kLocalized(@"GYHD_ServerMessage_Message");
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
        searchModel.friendUserType=model.friendUserType;
        [self.allMessageArr addObject:searchModel];
        
    }
    
    if (self.allMessageArr.count>0) {
        
        GYHDSearchModel *model=[[GYHDSearchModel alloc]init];
        model.groupName=kLocalized(@"GYHD_Message");
        model.searchReasultArr=self.allMessageArr;
        model.isShowAllContent=NO;
        [tempArr addObject:model];
        
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
        model.groupName=kLocalized(@"GYHD_Customer");
        model.searchReasultArr=self.customerListArr;
        model.isShowAllContent=NO;
        [tempArr addObject:model];
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
        model.groupName=kLocalized(@"GYHD_Contacts");
        model.searchReasultArr=self.companyListArr;
        model.isShowAllContent=NO;
        [tempArr addObject:model];
        
    }
    
    [self showSearchReasultWithSelectSting:tempArr];
    
}

#pragma mark -搜索结果按选项显示
-(void)showSearchReasultWithSelectSting:(NSArray*)tempArr{
    
    
    if ([self.selectStr isEqualToString:kLocalized(@"GYHD_All")]) {
        
        [self.leftArray addObjectsFromArray:tempArr];
        
    }else if ([self.selectStr isEqualToString:kLocalized(@"GYHD_Message")]){
        
        for (GYHDSearchModel*model in tempArr) {
            
            if ([model.groupName isEqualToString:kLocalized(@"GYHD_Message")]) {
                
                [self.leftArray addObject:model];
            }
            
        }
        
    }else if ([self.selectStr isEqualToString:kLocalized(@"GYHD_CustomerService")]){
        
        for (GYHDSearchModel*model in tempArr) {
            
            if ([model.groupName isEqualToString:kLocalized(@"GYHD_Customer")]) {
                
                [self.leftArray addObject:model];
            }
            
        }
        
    }else if ([self.selectStr isEqualToString:kLocalized(@"GYHD_Contacts")]){
        
        for (GYHDSearchModel*model in tempArr) {
            
            if ([model.groupName isEqualToString:kLocalized(@"GYHD_Contacts")]) {
                
                [self.leftArray addObject:model];
            }
            
        }
        
    }
    
    [self.leftTableView reloadData];
}
#pragma mark - 各项搜索数据
//获取推送消息数据源
-(NSArray*)loadPushMessageData{
    
    NSArray* arr=[[GYHDDataBaseCenter sharedInstance] selectPushMssageByKeyStr:self.keyWordStr];
    
    return arr;
}

//获取聊天消息数据源
-(NSArray*)loadAllChatMessage{
    
    NSArray* arr=[[GYHDDataBaseCenter sharedInstance] selectAllChatMessageByKeyString:self.keyWordStr];
    
    return arr;
}

//查询客户资料

-(NSArray*)loadCustomerListData{
    
    NSArray* arr=[[GYHDDataBaseCenter sharedInstance] selectCustomerDeTail];
    
    return arr;
    
}


//获取企业通讯录数据源

-(NSArray*)loadCompanyListData{
    
    NSArray* arr=[[GYHDDataBaseCenter sharedInstance] selectCompanyList];
    
    
    return arr;
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = 0;
    if ([tableView isEqual:self.leftTableView]) {
        
        count = self.leftArray.count;
        
    }else if ([tableView isEqual:self.rightTableView]) {
        
        return 1;
    }
    return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger count = 0;
    if ([tableView isEqual:self.leftTableView]) {
        
        GYHDSearchModel*model=self.leftArray[section];
        
        if (model.searchReasultArr.count>5 && !model.isShowAllContent) {
            
            return 5;
            
        }else{
            
            count=model.searchReasultArr.count;
            
        }
        
    }else if([tableView isEqual:self.rightTableView]) {
        
        return self.rightArray.count;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:self.leftTableView]) {
        GYHDSearchModel*model=self.leftArray[indexPath.section];
        if ([model.groupName isEqualToString:kLocalized(@"GYHD_Message")]) {
            GYHDSearchMessageListModel*searchModel=model.searchReasultArr[indexPath.row];
            GYHDSearchCompanyMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDSearchCompanyMessageCell];
            
            [cell refreshWithModel:searchModel];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if ([model.groupName isEqualToString:kLocalized(@"GYHD_Customer")]) {
            GYHDSearchCustomerListModel*customerModel=model.searchReasultArr[indexPath.row];
            
            GYHDCustomerMessageCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDCustomerMessageCell];
            
            [cell refreshWithModel:customerModel];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        if ([model.groupName isEqualToString:kLocalized(@"GYHD_Contacts")]) {
            GYHDSearchCompanyListModel*listModel=model.searchReasultArr[indexPath.row];
            
            GYHDSearchCompanyListCell*cell=[tableView dequeueReusableCellWithIdentifier:kGYHDSearchCompanyListCell];
            
            [cell refreshWithModel:listModel];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if([tableView isEqual:self.rightTableView]) {
        
        GYHDSearchMessageListCell *baseCell = [tableView dequeueReusableCellWithIdentifier:@"GYHDSearchMessageListCell"];
        baseCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        if ([self.msgType isEqualToString:@"10"]) {
            
            GYHDSearchCompanyMessageModel*model=self.rightArray[indexPath.row];
            
            [baseCell refreshWithGYHDSearchCompanyMessageModel:model];
            
        }else{
            
            GYHDSearchPushMessageModel*model=self.rightArray[indexPath.row];
            
            [baseCell refreshWithGYHDSearchPushMessageModel:model];
        }
        return baseCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView ==self.leftTableView) {
        
        GYHDSearchModel*model=self.leftArray[indexPath.section];
        
        if ([model.groupName isEqualToString:kLocalized(@"GYHD_Message")]) {
            
            for (GYHDSearchMessageListModel*messageModel in model.searchReasultArr) {
                
                messageModel.isSelect=NO;
                
            }
            
            GYHDSearchMessageListModel*tempModel=model.searchReasultArr[indexPath.row];
            
            tempModel.isSelect=YES;
            
            [self.leftTableView reloadData];
            
            if ([tempModel.msgType integerValue]==GYHDMessageTpyePush) {
                
//                点击推送消息
                [self.rightArray removeAllObjects];
                
                NSArray*pushMessageArr= [[GYHDDataBaseCenter sharedInstance]selectPushMssage];
                if ([tempModel.pullMsgType isEqualToString:@"1"]) {
                    //        系统消息
                    for (NSDictionary*dict in pushMessageArr) {
                        
                        GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
                        model.kerWord=self.keyWordStr;
                        [model initWithDict:dict];
                        
                        if ([model.content rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound && [model.msgMainType isEqualToString:@"1"]) {
                            
                            [self.rightArray addObject:model];
                            
                        }
                    }
                    
                }else if ([tempModel.pullMsgType isEqualToString:@"2"]){
                    //    订单消息
                    for (NSDictionary*dict in pushMessageArr) {
                        
                        GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
                        model.kerWord=self.keyWordStr;
                        [model initWithDict:dict];
                        
                        if ([model.content rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound && [model.msgMainType isEqualToString:@"2"]) {
                            
                            [self.rightArray addObject:model];
                        }
                    }
                    
                }else{
                    //    服务消息
                    for (NSDictionary*dict in pushMessageArr) {
                        
                        GYHDSearchPushMessageModel*model=[[GYHDSearchPushMessageModel alloc]init];
                        model.kerWord=self.keyWordStr;
                        [model initWithDict:dict];
                        
                        if ([model.content rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound && [model.msgMainType isEqualToString:@"3"]) {
                            
                            [self.rightArray addObject:model];
                        }
                    }
                }
                self.msgType=@"9";
                self.rightTableView.hidden=NO;
                [self.rightTableView reloadData];

            }else{
//             点击聊天消息
                [self.rightArray removeAllObjects];
                NSArray*messageArr=  [[GYHDDataBaseCenter sharedInstance] selectAllChatMessageBYCustId:tempModel.custId];
                
                for (NSDictionary*dict in messageArr) {
                    
                    GYHDSearchCompanyMessageModel*model=[[GYHDSearchCompanyMessageModel alloc]init];
                    model.msgIcon=tempModel.iconUrl;
                    model.kerWord=self.keyWordStr;
                    model.msgNote=tempModel.titleName;
                    model.friendUserType=tempModel.friendUserType;
                    [model initWithDict:dict];
                    
                    if ([model.content rangeOfString:self.keyWordStr options:NSCaseInsensitiveSearch].location!=NSNotFound) {
                        
                        [self.rightArray addObject:model];
                        
                    }
                    
                }
                self.msgType=@"10";
                self.rightTableView.hidden=NO;
                [self.rightTableView reloadData];

            }
        }
        
        if ([model.groupName isEqualToString:kLocalized(@"GYHD_Customer")]) {
            
            GYHDSearchCustomerListModel*customerModel=model.searchReasultArr[indexPath.row];
            //                    客服咨询
            [[NSUserDefaults standardUserDefaults] setObject:customerModel.custId forKey:@"CustomerMsgCard"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSMutableDictionary*dict=[NSMutableDictionary dictionary];
            dict[@"index"]=@"1";
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GYHDHDMainChageTabBarIndexNotification object:dict];
                
            });
        }
        
        if ([model.groupName isEqualToString:kLocalized(@"GYHD_Contacts")]) {
            
            GYHDSearchCompanyListModel*listModel=model.searchReasultArr[indexPath.row];
            //                  企业操作员
            [[NSUserDefaults standardUserDefaults] setObject:listModel.custId forKey:@"CompanyMsgCard"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSMutableDictionary*dict=[NSMutableDictionary dictionary];
            dict[@"index"]=@"2";
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:GYHDHDMainChageTabBarIndexNotification object:dict];
                
            });
        }
        
    }else{
        
        if ([self.msgType isEqualToString:@"10"]) {
            
            GYHDSearchCompanyMessageModel*model=self.rightArray[indexPath.row];
            
            if (![model.UserState isEqualToString:@"e"]) {
                
                //                    客服咨询
                [[NSUserDefaults standardUserDefaults] setObject:model.msgCard forKey:@"CustomerMsgCard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSMutableDictionary*dict=[NSMutableDictionary dictionary];
                dict[@"index"]=@"1";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:GYHDHDMainChageTabBarIndexNotification object:dict];
                    
                });
                
            }else{
                //                  企业操作员
                
                [[NSUserDefaults standardUserDefaults] setObject:model.msgCard forKey:@"CompanyMsgCard"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSMutableDictionary*dict=[NSMutableDictionary dictionary];
                dict[@"index"]=@"2";
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:GYHDHDMainChageTabBarIndexNotification object:dict];
                    
                });
            }
            
        }else{
            
            GYHDSearchPushMessageModel*pushModel=self.rightArray[indexPath.row];
            
            if (pushModel.isShowPage) {
                
                GYHDMsgShowPageController*vc=[[GYHDMsgShowPageController alloc]init];
                vc.pageUrl=pushModel.pageUrl;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                GYMsgListContentController*vc=[[GYMsgListContentController alloc]init];
                GYOrderMessageListModel*model=[[GYOrderMessageListModel alloc]init];
                model.messageListContent=pushModel.content;
                vc.model=model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (tableView==self.leftTableView) {
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 325, 30)];
        
        headView.backgroundColor = kDefaultVCBackgroundColor;
        headView.tag=100+section;
        UILabel *lbShow = [[UILabel alloc]initWithFrame:CGRectMake(10,5, 200, 20)];
        lbShow.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
        lbShow.font = [UIFont systemFontOfSize:14.0];
        GYHDSearchModel*model=self.leftArray[section];
        lbShow.text=model.groupName;
        
        UILabel*checkMoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(325-260, 5, 250, 20)];
        
        checkMoreLabel.font=[UIFont systemFontOfSize:14.0];
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
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    CGFloat headHeight;
    if (tableView==self.leftTableView) {
        
        headHeight=30;
        
    }
    return headHeight;
}

#pragma mark -点击查看更多
-(void)headerCheckMore:(UITapGestureRecognizer*)tap{
    
    NSInteger index =tap.view.tag-100;
    
    GYHDSearchModel*model=self.leftArray[index];
    
    model.isShowAllContent=!model.isShowAllContent;
    
    [self.leftTableView reloadData];
}

@end

