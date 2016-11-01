//
//  GYHDManagementViewController.m
//  HSCompanyPad
//
//  Created by shiang on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDManagementViewController.h"
#import "GYHDManagementCell.h"
#import "GYHDReplyCell.h"
#import "GYHDEditReplyView.h"
#import "GYHDNetWorkTool.h"
#import "GYHDCustomerServiceListCell.h"
#import "GYHDCustomerServiceListModel.h"
#import "GYGIFHUD.h"
#import "GYAlertView.h"
#import <GYKit/GYRefreshFooter.h>
#import <GYKit/GYRefreshHeader.h>
#import "GYCustomerSerViceDetailView.h"

@interface GYHDManagementViewController ()<UITableViewDataSource,UITableViewDelegate,GYHDReplyCellDelegate,GYHDEditReplyViewDelegate,UITextViewDelegate,GYCustomerSerViceDetailViewDelegate>
/**左边tableview*/
@property(nonatomic, strong)UITableView     *leftTableView;
/**左边表格数据源*/
@property(nonatomic, strong)NSMutableArray  *leftArray;
/**快捷回复tableview*/
@property(nonatomic, strong)UITableView     *replyTableView;
/**快捷回复表格数据源*/
@property(nonatomic, strong)NSMutableArray  *replyArray;
@property(nonatomic, strong)UIView *replyTableHeaderView;//快捷回复表头
@property(nonatomic, strong)UILabel      *noCustomerServiceListLabel;//无客服记录列表显示
@property(nonatomic,strong)UIView  *greetingView;//提示语界面

@property(nonatomic,strong)UITableView *customerServiceTableView;//客服模块列表
@property(nonatomic,strong)NSMutableArray *customerServiceArray;//客服列表数组
@property(nonatomic,strong)UIView *customerServiceTableHeaderView;
@property(nonatomic,strong)GYCustomerSerViceDetailView *customerSerViceDetailView;//客服列表详情
@property(nonatomic,strong)UITextView*welComeTextView;//欢迎输入框
@property(nonatomic,copy)NSString*welComeWords;//欢迎语
@property(nonatomic,strong)UITextView *endTextView;//结束语输入框
@property(nonatomic,copy)NSString*endWords;//结束语
@property(nonatomic,strong)UITextView*offLineTextView;//离线留言结束框
@property(nonatomic,copy)NSString*offLineWords;//离线留言
@property(nonatomic,strong)UILabel *endlessWelcomeLabel;//剩余欢迎语字
@property(nonatomic,strong)UILabel *endlessEndLabel;//剩余结束语字
@property(nonatomic,strong)UILabel *endlessLeaveLabel;//剩余离线留言字
@property(nonatomic,assign)NSInteger consumerServiceRecordPage;//客服记录请求当前页数
@end

@implementation GYHDManagementViewController

- (NSMutableArray *)leftArray {
    if (!_leftArray) {
        _leftArray = [NSMutableArray array];
        GYHDManagementModel *greetingModel = [[GYHDManagementModel alloc] init];
        greetingModel.imageString = @"gyhd_management_greeting_icon";
        greetingModel.titleString = kLocalized(@"GYHD_Greeting_Seting");
        greetingModel.isSelect=NO;
        GYHDManagementModel *replyModel = [[GYHDManagementModel alloc] init];
        replyModel.imageString = @"gyhd_reply_icon";
        replyModel.titleString = kLocalized(@"GYHD_Quick_Reply");
        replyModel.isSelect=NO;
        GYHDManagementModel *customerServiceModel = [[GYHDManagementModel alloc] init];
        customerServiceModel.imageString = @"gyhd_management_consumerServiceList_icon";
        customerServiceModel.titleString = kLocalized(@"GYHD_Customer_Service_Record");
        customerServiceModel.isSelect=NO;
        
        [_leftArray addObject:greetingModel];
        [_leftArray addObject:replyModel];
        [_leftArray addObject:customerServiceModel];
    }
    return _leftArray;
}

-(NSMutableArray *)customerServiceArray{
    
    if (!_customerServiceArray) {
        
        _customerServiceArray=[NSMutableArray array];
    }
    return _customerServiceArray;
}

#pragma mark -创建快捷回复头部视图
- (void)createReplyHeaderView {
    
    self.replyTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-CGRectGetMaxX(self.leftTableView.frame), 50)];
    
    UILabel *titleLabel  = [[UILabel alloc] init];
    titleLabel.font = [UIFont systemFontOfSize:16.0f];
    titleLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.replyTableHeaderView addSubview:titleLabel];
    
    UILabel *detailLabel  = [[UILabel alloc] init];
    detailLabel.font = [UIFont systemFontOfSize:16.0f];
    detailLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.replyTableHeaderView addSubview:detailLabel];
    
    UILabel *operatingLabel  = [[UILabel alloc] init];
    operatingLabel.font = [UIFont systemFontOfSize:16.0f];
    operatingLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.replyTableHeaderView addSubview:operatingLabel];
    
    UIButton *addButton = [[UIButton alloc] init];
    [self.replyTableHeaderView addSubview:addButton];
    
    titleLabel.text = kLocalized(@"GYHD_Title");
    detailLabel.text = kLocalized(@"GYHD_Reply_Content");
    operatingLabel.text = kLocalized(@"GYHD_Operation");
    [addButton setTitle:kLocalized(@"GYHD_Add") forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"gyhd_add_btn_normal"] forState:UIControlStateNormal];
    [addButton setBackgroundImage:[UIImage imageNamed:@"gyhd_add_btn_select"] forState:UIControlStateSelected];
    [addButton addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self);
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(38);
        make.centerY.equalTo(self.replyTableHeaderView);
    }];
    
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.replyTableHeaderView);
        make.left.mas_equalTo(150);
    }];
    
    [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-19);
        make.centerY.equalTo(self.replyTableHeaderView);
        make.size.mas_equalTo(CGSizeMake(52, 26));
    }];
    
    [operatingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.replyTableHeaderView);
        make.right.equalTo(addButton.mas_left).offset(-25);
    }];

}


#pragma mark-创建客服列表头部视图
- (void)createCustomerServiceHeaderView {

 self.customerServiceTableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-CGRectGetMaxX(self.leftTableView.frame), 50)];
    
    
    UILabel *sessionIDLabel  = [[UILabel alloc] init];
    sessionIDLabel.font = [UIFont systemFontOfSize:16.0f];
    sessionIDLabel.textAlignment=NSTextAlignmentLeft;
    sessionIDLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.customerServiceTableHeaderView addSubview:sessionIDLabel];
    
    UILabel *sessioStateLabel  = [[UILabel alloc] init];
    sessioStateLabel.font = [UIFont systemFontOfSize:16.0f];
    sessioStateLabel.textAlignment=NSTextAlignmentLeft;
    sessioStateLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.customerServiceTableHeaderView addSubview:sessioStateLabel];

    UILabel *customerServiceLabel  = [[UILabel alloc] init];
    customerServiceLabel.font = [UIFont systemFontOfSize:16.0f];
    customerServiceLabel.textAlignment=NSTextAlignmentLeft;
    customerServiceLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.customerServiceTableHeaderView addSubview:customerServiceLabel];
    
    UILabel *sessionTimeLabel = [[UILabel alloc] init];
    sessionTimeLabel.font = [UIFont systemFontOfSize:16.0f];
    sessionTimeLabel.textAlignment=NSTextAlignmentCenter;
    sessionTimeLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.customerServiceTableHeaderView addSubview:sessionTimeLabel];
    
    
    @weakify(self);
    [sessionIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(10);
        make.centerY.equalTo(self.customerServiceTableHeaderView);
        make.width.mas_equalTo(150);
    }];

    [sessioStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.customerServiceTableHeaderView);
        make.left.equalTo(sessionIDLabel.mas_right).offset(10);
        make.width.mas_equalTo(80);
    }];
    
    [customerServiceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.centerY.equalTo(self.customerServiceTableHeaderView);
        make.left.equalTo(sessioStateLabel.mas_right).offset(10);
        make.width.mas_equalTo(110);
    }];

    [sessionTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.customerServiceTableHeaderView);
        make.left.equalTo(customerServiceLabel.mas_right).offset(10);
    }];
    
    sessionIDLabel.text = kLocalized(@"GYHD_SessionId");
    sessioStateLabel.text = kLocalized(@"GYHD_SessionState");
    customerServiceLabel.text = kLocalized(@"GYHD_CustomerService");
   sessionTimeLabel.text=kLocalized(@"GYHD_SessionTime");
}

#pragma mark- 创建提示语视图

-(void)createGreetingView{

    self.greetingView=[[UIView alloc]init];
    
    self.greetingView.backgroundColor=kDefaultVCBackgroundColor;
    self.greetingView.hidden=YES;
    [self.view addSubview:self.greetingView];
    
    UILabel*welcomeWordLabel=[[UILabel alloc]init];
    
    welcomeWordLabel.backgroundColor=[UIColor clearColor];
    
    welcomeWordLabel.text=kLocalized(@"GYHD_Welcome_Word");
    welcomeWordLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.greetingView addSubview:welcomeWordLabel];
    
    self.welComeTextView=[[UITextView alloc]init];
    self.welComeTextView.delegate=self;
    self.welComeTextView.backgroundColor=[UIColor whiteColor];
    self.welComeTextView.font=[UIFont systemFontOfSize:16.0];
    self.welComeTextView.textContainerInset = UIEdgeInsetsMake(0,20, 0, 0);
    [self.greetingView addSubview:self.welComeTextView];

    UILabel*endWordLabel=[[UILabel alloc]init];
    
    endWordLabel.backgroundColor=[UIColor clearColor];
    
    endWordLabel.text=kLocalized(@"GYHD_End_Word");
    endWordLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.greetingView addSubview:endWordLabel];
    
    self.endTextView=[[UITextView alloc]init];
    self.endTextView.delegate=self;
    self.endTextView.backgroundColor=[UIColor whiteColor];
    self.endTextView.font=[UIFont systemFontOfSize:16.0];
     self.endTextView.textContainerInset = UIEdgeInsetsMake(0,20, 0, 0);
    [self.greetingView addSubview:self.endTextView];
    
    
    UILabel*kefuOfflineLabel=[[UILabel alloc]init];
    
    kefuOfflineLabel.backgroundColor=[UIColor clearColor];
    
    kefuOfflineLabel.text=kLocalized(@"GYHD_CustomerService_OffLine_Tip");
    kefuOfflineLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.greetingView addSubview:kefuOfflineLabel];
    
    [self.greetingView addSubview:endWordLabel];
    
    self.offLineTextView=[[UITextView alloc]init];
    self.offLineTextView.delegate=self;
    self.offLineTextView.backgroundColor=[UIColor whiteColor];
    self.offLineTextView.font=[UIFont systemFontOfSize:16.0];
     self.offLineTextView.textContainerInset = UIEdgeInsetsMake(0,20, 0, 0);
    [self.greetingView addSubview:self.offLineTextView];

    self.endlessWelcomeLabel=[[UILabel alloc]init];
    self.endlessWelcomeLabel.backgroundColor=[UIColor clearColor];
    self.endlessWelcomeLabel.font=[UIFont systemFontOfSize:12.0];
    self.endlessWelcomeLabel.textAlignment=NSTextAlignmentRight;
    self.endlessWelcomeLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.greetingView addSubview:self.endlessWelcomeLabel];
    
    self.endlessEndLabel=[[UILabel alloc]init];
    self.endlessEndLabel.backgroundColor=[UIColor clearColor];
    self.endlessEndLabel.font=[UIFont systemFontOfSize:12.0];
    self.endlessEndLabel.textAlignment=NSTextAlignmentRight;
    self.endlessEndLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.greetingView addSubview:self.endlessEndLabel];
    
    self.endlessLeaveLabel=[[UILabel alloc]init];
    self.endlessLeaveLabel.backgroundColor=[UIColor clearColor];
    self.endlessLeaveLabel.font=[UIFont systemFontOfSize:12.0];
    self.endlessLeaveLabel.textAlignment=NSTextAlignmentRight;
    self.endlessLeaveLabel.textColor = [UIColor colorWithHex:0x999999];
    [self.greetingView addSubview:self.endlessLeaveLabel];
   @weakify(self);
    
    [self.greetingView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        @strongify(self);
        make.left.equalTo(self.leftTableView.mas_right).offset(20);
        make.top.mas_equalTo(44);
        make.right.mas_equalTo(-20);
        make.bottom.mas_equalTo(0);
    }];
    
    [welcomeWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(40);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    [self.welComeTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(welcomeWordLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [endWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         @strongify(self);
        make.top.equalTo(self.welComeTextView.mas_bottom).offset(8);
        make.left.equalTo(welcomeWordLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    
    [self.endTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endWordLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    [kefuOfflineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.endTextView.mas_bottom).offset(8);
        make.left.equalTo(welcomeWordLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];

    [self.offLineTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(kefuOfflineLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(100);
    }];
    
    UIButton*saveBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    saveBtn.layer.cornerRadius=6;
    saveBtn.layer.masksToBounds=YES;
    saveBtn.backgroundColor=[UIColor colorWithRed:61/255.0 green:143/255.0 blue:250/255.0 alpha:1.0];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveGreeting) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:kLocalized(@"GYHD_Save") forState:UIControlStateNormal];
    
    [self.greetingView addSubview:saveBtn];
    
    UIButton*cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.layer.cornerRadius=6;
    cancelBtn.layer.masksToBounds=YES;
    [cancelBtn setTitle:kLocalized(@"GYHD_Cancel") forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSettingGreeting) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor=[UIColor colorWithRed:182/255.0 green:184/255.0 blue:204/255.0 alpha:1.0];
    [self.greetingView addSubview:cancelBtn];
    
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.offLineTextView.mas_bottom).offset(10);
        make.left.equalTo(self.offLineTextView.mas_centerX).offset(-120);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.offLineTextView.mas_bottom).offset(10);
        make.left.equalTo(self.offLineTextView.mas_centerX).offset(20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    [self.endlessWelcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.welComeTextView.mas_bottom);
        make.right.equalTo(self.welComeTextView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(110, 20));
    }];
    
    [self.endlessEndLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.endTextView.mas_bottom);
        make.right.equalTo(self.endTextView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(110, 20));
    }];
    
    [self.endlessLeaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.equalTo(self.offLineTextView.mas_bottom);
        make.right.equalTo(self.offLineTextView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(110, 20));
    }];

}

-(GYCustomerSerViceDetailView *)customerSerViceDetailView{

    if (!_customerSerViceDetailView) {
        
        _customerSerViceDetailView=[[GYCustomerSerViceDetailView alloc]init];
        
        _customerSerViceDetailView.delegate=self;
        
        _customerSerViceDetailView.managementVc=self;
        
        [self.view addSubview:_customerSerViceDetailView];
        
        @weakify(self);
        
        [_customerSerViceDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            
            make.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(44);
            make.left.equalTo(self.leftTableView.mas_right).offset(0);
            
            
        }];
        
    }

    return _customerSerViceDetailView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.leftTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.leftTableView.rowHeight = UITableViewAutomaticDimension;
    self.leftTableView.estimatedRowHeight = 240;
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.leftTableView registerClass:[GYHDManagementCell class] forCellReuseIdentifier:NSStringFromClass([GYHDManagementCell class])];
    [self.view addSubview:self.leftTableView];
    
    [self createReplyHeaderView];
    
    [self createCustomerServiceHeaderView];
    
    [self createGreetingView];
    
    self.replyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.replyTableView.dataSource = self;
    self.replyTableView.delegate = self;
    self.replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.replyTableView.tableHeaderView=self.replyTableHeaderView;
    self.replyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.replyTableView.hidden=YES;
    self.replyTableView.backgroundColor=kDefaultVCBackgroundColor;
    [self.replyTableView registerClass:[GYHDReplyCell class] forCellReuseIdentifier:NSStringFromClass([GYHDReplyCell class])];
    [self.view addSubview:self.replyTableView];
    
    self.customerServiceTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.customerServiceTableView.dataSource = self;
    self.customerServiceTableView.delegate = self;
    self.customerServiceTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.customerServiceTableView.tableHeaderView=self.customerServiceTableHeaderView;
    self.customerServiceTableView.backgroundColor=kDefaultVCBackgroundColor;
    self.customerServiceTableView.hidden=YES;
    [self.customerServiceTableView registerClass:[GYHDCustomerServiceListCell class] forCellReuseIdentifier:NSStringFromClass([GYHDCustomerServiceListCell class])];
    
    @weakify(self);
    
    GYRefreshHeader*header=[GYRefreshHeader headerWithRefreshingBlock:^{
        
            @strongify(self);
            self.consumerServiceRecordPage=1;
            [self loadCustomerServiceData];
        
            [self.customerServiceTableView.mj_header endRefreshing];
    }];
    
    self.customerServiceTableView.mj_header=header;
    
    GYRefreshFooter*footer=[GYRefreshFooter footerWithRefreshingBlock:^{
        
        @strongify(self);
        self.consumerServiceRecordPage++;
        
        [self loadCustomerServiceData];
        [self.customerServiceTableView.mj_footer endRefreshing];
        
    }];
    
    self.customerServiceTableView.mj_footer=footer;
    
    [self.view addSubview:self.customerServiceTableView];
    
    self.noCustomerServiceListLabel=[[UILabel alloc]init];
    
    self.noCustomerServiceListLabel.text=kLocalized(@"GYHD_Customer_Service_No_Record");
    
    self.noCustomerServiceListLabel.textAlignment=NSTextAlignmentCenter;
    
    self.noCustomerServiceListLabel.font=[UIFont systemFontOfSize:20.0];
    
    self.noCustomerServiceListLabel.hidden=YES;
    
    [self.view addSubview:self.noCustomerServiceListLabel];
    
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
        make.width.mas_equalTo(325);
    }];
    
    [self.replyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(44);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    
    [self.customerServiceTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.mas_equalTo(-20);
         make.top.mas_equalTo(44);
        make.left.equalTo(self.leftTableView.mas_right).offset(20);
    }];
    
    [self.noCustomerServiceListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.right.bottom.mas_equalTo(-20);
        make.top.mas_equalTo(44);
        make.left.equalTo(self.leftTableView.mas_right).offset(20);
    }];
  
}

#pragma mark - 拉取快捷回复接口
- (void)loadReplyData {
    @weakify(self);
    
    NSArray *arry = [[GYHDDataBaseCenter sharedInstance] selectAllQuickReply];
    NSMutableArray *riArray = [NSMutableArray array];
    for (NSDictionary *replyDict in arry) {
        GYHDReplyModel *model = [[GYHDReplyModel alloc] init];
        model.titleString =  replyDict[GYHDDataBaseCenterQuickReplyTitle];
        model.createTimeString = replyDict[GYHDDataBaseCenterQuickReplyCreateTimeStr];
        model.updateTimeString =  replyDict[GYHDDataBaseCenterQuickReplyUpdateTimeStr];
        model.contentString =  replyDict[GYHDDataBaseCenterQuickReplyContent];
        model.messageID =  replyDict[GYHDDataBaseCenterQuickReplyMsgId];
        model.isDefault =  replyDict[GYHDDataBaseCenterQuickReplyIsDefault];
        model.entCustID =  replyDict[GYHDDataBaseCenterQuickReplyCustId];
        [riArray addObject:model];
    }
    self.replyArray = riArray;
    [self.replyTableView reloadData];
    
    [[GYHDNetWorkTool sharedInstance] queryQuickReplyMsgByCustIdWithDict:nil RequetResult:^(NSArray *resultArry) {
        @strongify(self);
        DDLogInfo(@"%@",resultArry);
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *replyDict in resultArry) {
            GYHDReplyModel *model = [[GYHDReplyModel alloc] init];
            model.titleString =  replyDict[GYHDDataBaseCenterQuickReplyTitle];
            model.createTimeString = replyDict[GYHDDataBaseCenterQuickReplyCreateTimeStr];
            model.updateTimeString =  replyDict[GYHDDataBaseCenterQuickReplyUpdateTimeStr];
            model.contentString =  replyDict[GYHDDataBaseCenterQuickReplyContent];
            model.messageID =  replyDict[GYHDDataBaseCenterQuickReplyMsgId];
            model.isDefault =  replyDict[GYHDDataBaseCenterQuickReplyIsDefault];
            model.entCustID =  replyDict[GYHDDataBaseCenterQuickReplyCustId];
            [array addObject:model];
        }
        self.replyArray = array;
        [self.replyTableView reloadData];
    }];
}

#pragma mark -拉取提示语接口
-(void)loadGreetingData{

    [[GYHDNetWorkTool sharedInstance] queryCompanyGreetingRequetResult:^(NSArray *resultArry) {
        
        if (resultArry.count>0) {
            
            NSDictionary*dict=[resultArry firstObject];
            
            self.welComeTextView.text=dict[@"wellcomeWord"];
            self.endTextView.text=dict[@"peroration"];
            self.offLineTextView.text=dict[@"offlineTip"];
        }
        
        
    }];
    
}

#pragma mark -拉取客服记录
-(void)loadCustomerServiceData{
    

    [[GYHDNetWorkTool sharedInstance] queryCustomerServiceRecordListPage:self.consumerServiceRecordPage RequetResult:^(NSArray *resultArry) {
        
        

        if (resultArry!=nil) {
            
            if (self.consumerServiceRecordPage==1) {
                
                [self.customerServiceArray removeAllObjects];
            }
            
            for (NSDictionary *dic in resultArry) {
                
                GYHDCustomerServiceListModel*model=[[GYHDCustomerServiceListModel alloc]init];
                
                [model initWithDict:dic];
                
                [self.customerServiceArray addObject:model];
            }
            
            if (self.customerServiceArray>0) {
                
                self.noCustomerServiceListLabel.hidden=YES;
                self.customerServiceTableView.hidden=NO;
                [self.customerServiceTableView reloadData];
                
            }else{
            
                self.noCustomerServiceListLabel.hidden=NO;
                self.customerServiceTableView.hidden=YES;
            }
            
        }
    
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    NSInteger count = 0;
    
    if ([tableView isEqual:self.leftTableView]) {
        
        count = self.leftArray.count;

    }else if([tableView isEqual:self.replyTableView]) {
        
        count = self.replyArray.count;
    }else if ([tableView isEqual:self.customerServiceTableView]){
    
        count=self.customerServiceArray.count;

    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.leftTableView]) {
        GYHDManagementCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDManagementCell class])];
        baseCell.model = self.leftArray[indexPath.row];
        cell = baseCell;
    }else if([tableView isEqual:self.replyTableView]) {
        GYHDReplyCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDReplyCell class])];
        baseCell.delegate = self;
        baseCell.model = self.replyArray[indexPath.row];
        cell = baseCell;
    }else if ([tableView isEqual:self.customerServiceTableView]){
    
        GYHDCustomerServiceListCell *baseCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDCustomerServiceListCell class])];
        if (self.customerServiceArray.count>0) {
            baseCell.selectionStyle=UITableViewCellSelectionStyleNone;
             baseCell.model=self.customerServiceArray[indexPath.row];
        }
       
        cell = baseCell;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([tableView isEqual:self.leftTableView]) {
        
        GYHDManagementModel*model=self.leftArray[indexPath.row];
        
        for (GYHDManagementModel*tempModel in self.leftArray) {
            
            tempModel.isSelect=NO;
        }
        model.isSelect=YES;
        
        [self.leftTableView reloadData];
        
        if (indexPath.row==0) {
//            提示语
            self.greetingView.hidden=NO;
            self.replyTableView.hidden=YES;
            self.noCustomerServiceListLabel.hidden=YES;
            self.customerServiceTableView.hidden=YES;
            self.customerSerViceDetailView.hidden=YES;
            [self loadGreetingData];
            
            
        }else if (indexPath.row==1){
//            快捷回复
            self.greetingView.hidden=YES;
            self.replyTableView.hidden=NO;
            self.noCustomerServiceListLabel.hidden=YES;
            self.customerServiceTableView.hidden=YES;
            self.customerSerViceDetailView.hidden=YES;
            [self loadReplyData];
            
        
        }else if (indexPath.row==2){
            
//            客服记录
            self.greetingView.hidden=YES;
            self.replyTableView.hidden=YES;
            self.customerSerViceDetailView.hidden=YES;
            self.customerServiceTableView.hidden=NO;
            self.consumerServiceRecordPage=1;
            [self loadCustomerServiceData];
            
        }
        
    }else if([tableView isEqual:self.replyTableView]) {
        
        
    }else if ([tableView isEqual:self.customerServiceTableView]){
        
        GYHDCustomerServiceListModel *model=self.customerServiceArray[indexPath.row];
        self.customerSerViceDetailView.sessionId=model.sessionId;
        self.customerSerViceDetailView.hidden=NO;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGFloat customerServiceHeight;
    CGFloat sessionTimeHeight;
    
    if (tableView==self.customerServiceTableView) {
        
        GYHDCustomerServiceListModel*model=self.customerServiceArray[indexPath.row];
//        NSString*customerServiceStr=@"熬枯受淡\r\n爱上暗示健康";
        NSString*customerServiceStr=model.customerServiceListStr;
        customerServiceHeight=[GYHDUtils heightForString:customerServiceStr fontSize:14.0 andWidth:100];
//        NSString*sessonTimeStr=@"2016-09-06 08:12:35   2016-09-06 08:12:35";
        NSString*sessonTimeStr=model.sessionTimeListStr;
        sessionTimeHeight=[GYHDUtils heightForString:sessonTimeStr fontSize:14.0 andWidth:250];
        
        if (customerServiceHeight>sessionTimeHeight) {
            
            return customerServiceHeight+30;
            
        }else{
        
            return sessionTimeHeight+30;
        }
    }
    if (tableView==self.replyTableView) {
        
         return 120;
        
    }else{
    
        return 88;
    }
}
- (void)btnClick {
    
    [self editButonClickWithCell:nil model:nil];
    
}

#pragma mark -- GYHDReplyCellDelegate
- (void)editButonClickWithCell:(GYHDReplyCell *)cell model:(GYHDReplyModel *)model {

    GYHDEditReplyView *editView = [[GYHDEditReplyView alloc] initWithModel:model];
    editView.delegate = self;
    [self.view addSubview:editView];
    @weakify(self);
    [editView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.left.bottom.right.equalTo(self.replyTableView);
    }];
}

#pragma mark - 删除快捷回复

- (void)deleteButonClickWithCell:(GYHDReplyCell *)cell model:(GYHDReplyModel *)model {
    [self.replyArray removeObject:model];
    [self.replyTableView reloadData];
    NSDictionary *deleteDict = @{@"msgId":model.messageID};
    @weakify(self);
    [[GYHDNetWorkTool sharedInstance] deleteQuickReplyMsgByMsgIdWithDict:deleteDict RequetResult:^(NSDictionary *resultDict) {
//        DDLogInfo(@"%@",resultDict);
        @strongify(self);
        if ([resultDict[GYNetWorkCodeKey] integerValue]  == 200) {
            [self loadReplyData];
            [self.view makeToast:kLocalized(@"GYHD_Delete_Success") duration:1.0 position:nil];
        }else{
        
        [self.view makeToast:kLocalized(@"GYHD_Delete_Failed") duration:1.0 position:nil];
        }
    }];
}

#pragma mark - 保存快捷回复
- (void)GYHDEditReplyViewDidSave:(GYHDReplyModel *)model {
    
    if (model.titleString.length<=0) {
        
        [self.view makeToast:kLocalized(@"GYHD_Quick_Reply_Title_No_Empty") duration:1.0 position:nil];
        
        return;
    }
    
    if (model.contentString.length<=0) {
        
        [self.view makeToast:kLocalized(@"GYHD_Quick_Reply_Content_No_Empty") duration:1.0 position:nil];
        return;
    }
    
    NSMutableDictionary *addDict = [NSMutableDictionary dictionary];
    addDict[@"custId"] = globalData.loginModel.entCustId;
    addDict[@"title"] = model.titleString;
    addDict[@"content"] = model.contentString;
    [self.replyArray addObject:model];
    [self.replyTableView reloadData];
    @weakify(self);
    [[GYHDNetWorkTool sharedInstance] addQuickReplyMsgWithDict:addDict RequetResult:^(NSDictionary *resultDict) {
        DDLogInfo(@"%@",resultDict);
        @strongify(self);
        if ([resultDict[GYNetWorkCodeKey] integerValue]  == 200) {
            
            [self.view makeToast:kLocalized(@"GYHD_Save_Success") duration:1.0 position:nil];
            [self loadReplyData];
        }else{
        
            [self.view makeToast:kLocalized(@"GYHD_Save_Failed") duration:1.0 position:nil];
        }
    }];
}

#pragma mark - 编辑更新快捷回复
- (void)GYHDEditReplyViewDidUpdate:(GYHDReplyModel *)model {
    if (model.titleString.length<=0) {
        
        [self.view makeToast:kLocalized(@"GYHD_Quick_Reply_Title_No_Empty") duration:1.0 position:nil];
        
        return;
    }
    
    if (model.contentString.length<=0) {
        
        [self.view makeToast:kLocalized(@"GYHD_Quick_Reply_Content_No_Empty") duration:1.0 position:nil];
        return;
    }
    
    [self.replyTableView reloadData];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"msgId"] = model.messageID;
    dict[@"title"] = model.titleString;
    dict[@"content"] = model.contentString;
    dict[@"isDefault"] = model.isDefault;
    @weakify(self);
    [[GYHDNetWorkTool sharedInstance] updateQuickReplyMsgWithDict:dict RequetResult:^(NSDictionary *resultDict) {
        DDLogInfo(@"%@",resultDict);
        @strongify(self);
        if ([resultDict[GYNetWorkCodeKey] integerValue]  == 200) {
            [self loadReplyData];
            [self.view makeToast:kLocalized(@"GYHD_Save_Success") duration:1.0 position:nil];
        }else{
              [self.view makeToast:kLocalized(@"GYHD_Save_Failed") duration:1.0 position:nil];
        }
    }];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    
    if (textView==self.welComeTextView) {
        
        NSInteger length=100-textView.text.length;
        
        self.endlessWelcomeLabel.text=[NSString stringWithFormat:@"还可以输入%ld个字",length];
        
        if (range.location>=100) {
            
            return  NO;
            
        } else {
            
            return YES;
        }
        
    }else if (textView==self.endTextView){
        
        NSInteger length=100-textView.text.length;
        
        self.endlessEndLabel.text=[NSString stringWithFormat:@"还可以输入%ld个字",length];
        if (range.location>=100){
            
            return  NO;
            
        } else {
            
            return YES;
        }
        
    }else if (textView==self.offLineTextView){
        
        NSInteger length=60-textView.text.length;
        self.endlessLeaveLabel.text=[NSString stringWithFormat:@"还可以输入%ld个字",length];
        
        if (range.location>=50){
            
            return  NO;
            
        } else {
            
            return YES;
        }
        
    }
    return YES;
}

/**
 * 修改企业提示语
 */
- (void)setCompanyGreeting{

    [GYGIFHUD show];
    
    NSString *urlString = [NSString stringWithFormat:@"%@/hsim-bservice/message/greetingsMsgSetting",globalData.loginModel.hdbizDomain];
    NSMutableDictionary * insideDict =[NSMutableDictionary dictionary];
    insideDict[@"operator"] = globalData.loginModel.custId;
    insideDict[@"wellcomeWord"] = self.welComeTextView.text;
    insideDict[@"entCustId"] = globalData.loginModel.entCustId;
    insideDict[@"peroration"] = self.endTextView.text;
    insideDict[@"offlineTip"] = self.offLineTextView.text;
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    sendDict[GYNetWorkDataKey] = insideDict;
    sendDict[@"channelType"] =GYChannelType;
    sendDict[@"custId"] = globalData.loginModel.custId;
    sendDict[@"loginToken"] = globalData.loginModel.token;
    sendDict[@"entResNo"] = globalData.loginModel.entResNo;
    
    [GYNetwork POST:urlString parameter:sendDict success:^(id returnValue) {
        if ([returnValue[GYNetWorkCodeKey]integerValue]==200) {
            
             [GYGIFHUD dismiss];
            [self.view makeToast:kLocalized(@"GYHD_Save_Success") duration:1.0 position:nil];
            
        }else{
            
             [GYGIFHUD dismiss];
            [self.view makeToast:kLocalized(@"GYHD_Save_Failed") duration:1.0 position:nil];
            
        }
        
    } failure:^(NSError *error) {
        [GYGIFHUD dismiss];
        DDLogCInfo(@"error==%@",error);
        [self.view makeToast:kLocalized(@"GYHD_Save_Failed") duration:1.0 position:nil];
 
    }];
    
}
#pragma mark- 存储提示语
-(void)saveGreeting{

    
    [self setCompanyGreeting];

}
#pragma mark - 取消设置提示语
-(void)cancelSettingGreeting{

    @weakify(self);
    [GYAlertView alertWithTitle:kLocalized(@"GYHD_Tip") Message:kLocalized(@"GYHD_Are_You_Sure_Cancel_The_Prompt_Modification") topColor:TopColorRed comfirmBlock:^{
        @strongify(self);
    
        [self loadGreetingData];
        
    }];

}

-(void)hidenGYCustomerSerViceDetailView{

    self.customerSerViceDetailView.hidden=YES;
    
    
}

@end
