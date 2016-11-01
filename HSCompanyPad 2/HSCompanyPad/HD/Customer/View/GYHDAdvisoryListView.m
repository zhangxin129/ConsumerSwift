//
//  GYHDAdvisoryListView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/9.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDAdvisoryListView.h"
#import "GYHDAdvisoryListCell.h"
#import <YYKit/UIImageView+YYWebImage.h>
#import "GYHDAdvisoryCustormerCell.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDSDK.h"
#import "GYHDCustomerServiceOnLineModel.h"
#import "GYHDNetWorkTool.h"
#import "GYHDMessageCenter.h"
@interface GYHDAdvisoryListView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UITableView *listTableView;
@property(nonatomic, strong)NSMutableArray *historyListArray;
@property(nonatomic, strong)UITableView *customerServiceListTableView;
@property(nonatomic, strong)NSMutableArray *customerServiceListArray;
@property(nonatomic, strong)UIView      *headerView;
@property(nonatomic, strong)UILabel     *goodsInfoLabel;
@property(nonatomic, strong)UIImageView *goodsImageView;
@property(nonatomic, strong)UILabel     *goodsNameLabel;
@property(nonatomic, strong)UILabel     *AdvisoryListLabel;
@property(nonatomic, assign)BOOL       isShowAdvisoryList;//是否显示
@property(nonatomic, strong)UILabel      *goodsDescribtionLabel;
@property(nonatomic, strong)UILabel      *noCustomerServiceListLabel;//无客服记录列表显示
@property(nonatomic,strong)UIView  *goodsView;//关联商品
@property(nonatomic,strong)UIView  *orderView;//关联订单
@property(nonatomic,strong)UILabel *orderInfoLabel;
/**订单编号名字*/
@property(nonatomic, strong)UILabel *orderNumberTitleLabel;
/**订单编号内容*/
@property(nonatomic, strong)UILabel *orderNumberDetailLabel;

/**订单类型名字*/
@property(nonatomic, strong)UILabel *orderTypeTitleLabel;
/**订单类型内容*/
@property(nonatomic, strong)UILabel *orderTypeDetailLabel;

/**订单时间名字*/
@property(nonatomic, strong)UILabel *orderTimeTitleLabel;
/**订单时间内容*/
@property(nonatomic, strong)UILabel *orderTimeDetailLabel;

/**订单信息名字*/
@property(nonatomic, strong)UILabel *orderMessageTitleLabel;
/**订单信息内容*/
@property(nonatomic, strong)UILabel *orderMessageDetailLabel;
/**订单金额*/
@property(nonatomic, strong)UIButton *orderPriceButton;
/**订单积分*/
@property(nonatomic, strong)UIButton *orderPVButton;

/**订单状态名字*/
@property(nonatomic, strong)UILabel *orderStateTitleLabel;
/**订单状态内容*/
@property(nonatomic, strong)UILabel *orderStateDetailLabel;

@property(nonatomic, copy)NSString*selectKefuId;//选择的客服id
@property(nonatomic, copy)NSString*selectKefuName;//选择的客服名字

@end

@implementation GYHDAdvisoryListView

-(NSMutableArray *)historyListArray{

    if (!_historyListArray) {
        
        _historyListArray=[NSMutableArray array];
    }
    
    return _historyListArray;
}

-(NSMutableArray *)customerServiceListArray{

    if (!_customerServiceListArray) {
        
        _customerServiceListArray=[NSMutableArray array];
    }
    return _customerServiceListArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupHeaderView];
        [self setupAuto];
        self.isShowAdvisoryList=NO;
    }
    return self;
}

- (void)setupHeaderView {
    self.headerView = [[UIView alloc] init];
    [self addSubview:self.headerView];
//    关联商品
    self.goodsView = [[UIView alloc] init];
    [self.headerView addSubview:self.goodsView];
    
//    关联订单
    self.orderView = [[UIView alloc] init];
    [self.headerView addSubview:self.orderView];
    
    self.goodsInfoLabel  = [[UILabel alloc] init];
    self.goodsInfoLabel.font = [UIFont systemFontOfSize:16.0f];
    self.goodsInfoLabel.textColor = [UIColor colorWithHex:0x333333];
    self.goodsInfoLabel.text = kLocalized(@"GYHD_Commodity_Information");
    [self.goodsView addSubview:self.goodsInfoLabel];
    
    self.goodsImageView = [[UIImageView alloc] init];
    [self.goodsView addSubview:self.goodsImageView];
    
    self.goodsNameLabel = [[UILabel alloc] init];\
    self.goodsNameLabel.numberOfLines = 2;
    self.goodsNameLabel.font = [UIFont systemFontOfSize:14.0f];
    self.goodsNameLabel.textColor = [UIColor colorWithHex:0x3e8ffa];
    [self.goodsView addSubview:self.goodsNameLabel];
    
    self.goodsDescribtionLabel = [[UILabel alloc] init];
    self.goodsDescribtionLabel.font = [UIFont systemFontOfSize:12.0f];
    self.goodsDescribtionLabel.numberOfLines = 2;
    self.goodsDescribtionLabel.textColor = [UIColor colorWithHex:0xa9a9a9];
    [self.goodsView addSubview:self.goodsDescribtionLabel];
    
   self.orderInfoLabel  = [[UILabel alloc] init];
     self.orderInfoLabel.font = [UIFont systemFontOfSize:16.0f];
     self.orderInfoLabel.textColor = [UIColor colorWithHex:0x333333];
     self.orderInfoLabel.text = kLocalized(@"GYHD_Order_Information");
    [self.orderView addSubview: self.orderInfoLabel];
    
    /**订单编号名字*/
    self.orderNumberTitleLabel = [[UILabel alloc] init];
    self.orderNumberTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderNumberTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.orderView addSubview: self.orderNumberTitleLabel];
    /**订单编号内容*/
    self.orderNumberDetailLabel = [[UILabel alloc] init];
    self.orderNumberDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderNumberDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [self.orderView addSubview: self.orderNumberDetailLabel];;
    
    /**订单类型名字*/
    self.orderTypeTitleLabel = [[UILabel alloc] init];
    self.orderTypeTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderTypeTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.orderView addSubview: self.orderTypeTitleLabel];;
    
    /**订单类型内容*/
    self.orderTypeDetailLabel = [[UILabel alloc] init];
    self.orderTypeDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderTypeDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [self.orderView addSubview: self.orderTypeDetailLabel];
    
    /**订单时间名字*/
    self.orderTimeTitleLabel = [[UILabel alloc] init];
    self.orderTimeTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderTimeTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.orderView addSubview: self.orderTimeTitleLabel];
    /**订单时间内容*/
    self.orderTimeDetailLabel  = [[UILabel alloc] init];
    self.orderTimeDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderTimeDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [self.orderView addSubview: self.orderTimeDetailLabel];
    
    /**订单信息名字*/
    self.orderMessageTitleLabel = [[UILabel alloc] init];
    self.orderMessageTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderMessageTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.orderView addSubview: self.orderMessageTitleLabel];
    
    /**订单状态名字*/
    self.orderStateTitleLabel  = [[UILabel alloc] init];
    self.orderStateTitleLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderStateTitleLabel.textColor = [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1];
    [self.orderView addSubview: self.orderStateTitleLabel];
    /**订单状态内容*/
    self.orderStateDetailLabel = [[UILabel alloc] init];
    self.orderStateDetailLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    self.orderStateDetailLabel.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1];
    [self.orderView addSubview: self.orderStateDetailLabel];
    
    self.orderNumberTitleLabel.text = kLocalized(@"GYHD_OrderNumber_Chat");
    self.orderTypeTitleLabel.text = kLocalized(@"GYHD_OrderType_Chat");
    self.orderTimeTitleLabel.text =  kLocalized(@"GYHD_OrderTime_Chat");
    self.orderMessageTitleLabel.text =  kLocalized(@"GYHD_PayInfo_Chat");
    self.orderStateTitleLabel.text = kLocalized(@"GYHD_OrderState_Chat");
    
    self.orderPriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderPriceButton setTitleColor:[UIColor colorWithRed:255.0f/255.0f green:60/255.0f blue:40/255.0f alpha:1] forState:UIControlStateNormal];
    [self.orderPriceButton setImage:[UIImage imageNamed:@"yghd_huSheng_monery_icon"] forState:UIControlStateNormal];
    [self.orderView addSubview:self.orderPriceButton];
    
    self.orderPVButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderPVButton setTitleColor:[UIColor colorWithRed:0 green:169/255.0f blue:249/255.0f alpha:1] forState:UIControlStateNormal];
    [self.orderPVButton setImage:[UIImage imageNamed:@"gyhd_husheng_integral_icon"] forState:UIControlStateNormal];
    [self.orderView addSubview:self.orderPVButton];
    
    
    self.AdvisoryListLabel = [[UILabel alloc] init];
    self.AdvisoryListLabel.font = [UIFont systemFontOfSize:16.0f];
     self.AdvisoryListLabel.text = kLocalized(@"GYHD_Customer_Service_Record");
    self.AdvisoryListLabel.textColor = [UIColor colorWithHex:0x333333];
    [self.headerView addSubview:self.AdvisoryListLabel];
    
    self.listTableView = [[UITableView alloc] init];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.listTableView registerClass:[GYHDAdvisoryListCell class] forCellReuseIdentifier:NSStringFromClass([GYHDAdvisoryListCell class])];
    self.listTableView.rowHeight = UITableViewAutomaticDimension;
    self.listTableView.estimatedRowHeight = 240;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.listTableView];
    
    
    self.noCustomerServiceListLabel=[[UILabel alloc]init];
    
    self.noCustomerServiceListLabel.text= kLocalized(@"GYHD_Customer_Service_No_Record");
    
    self.noCustomerServiceListLabel.textAlignment=NSTextAlignmentCenter;
    
    self.noCustomerServiceListLabel.font=[UIFont systemFontOfSize:20.0];
    
    self.noCustomerServiceListLabel.hidden=YES;
    
    [self addSubview:self.noCustomerServiceListLabel];
    
    
    self.customerServiceListTableView = [[UITableView alloc] init];
    self.customerServiceListTableView.dataSource = self;
    self.customerServiceListTableView.delegate = self;
    self.customerServiceListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.customerServiceListTableView registerClass:[GYHDAdvisoryCustormerCell class] forCellReuseIdentifier:NSStringFromClass([GYHDAdvisoryCustormerCell class])];
    self.customerServiceListTableView.rowHeight = UITableViewAutomaticDimension;
    self.customerServiceListTableView.estimatedRowHeight = 240;
    self.customerServiceListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.customerServiceListTableView.hidden=YES;
    [self addSubview:self.customerServiceListTableView];

#pragma mark - 暂时屏蔽咨询转移
    self.migrateAdvisoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.migrateAdvisoryButton setTitle:@"咨询转移" forState:UIControlStateNormal];
//    [self.migrateAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_move_btn_normal"] forState:UIControlStateNormal];
//    [self.migrateAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_move_btn_highlighted"] forState:UIControlStateHighlighted];
//    [self.migrateAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_move_btn_select"] forState:UIControlStateSelected];
//    [self.migrateAdvisoryButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.migrateAdvisoryButton];
    
    self.endAdvisoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_normal"] forState:UIControlStateNormal];
    [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_highlighted"] forState:UIControlStateHighlighted];
    [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_select"] forState:UIControlStateSelected];
    [self.endAdvisoryButton setTitle:kLocalized(@"GYHD_End_Session") forState:UIControlStateNormal];
    [self.endAdvisoryButton addTarget:self action:@selector(endSessionClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.endAdvisoryButton];

}

- (void)setupAuto {
    
    @weakify(self);
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.left.right.mas_equalTo(0);

    }];
    
    [self.goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
    }];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-65);
    }];
    
    [self.noCustomerServiceListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-65);
    }];
    
    [self.customerServiceListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(40);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(-65);
    }];


    [self.goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(40);
    }];

    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.goodsInfoLabel.mas_bottom).offset(10);
        make.left.equalTo(self.goodsInfoLabel);
        make.size.mas_equalTo(CGSizeMake(77, 77));
    }];

    [self.goodsNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.goodsImageView);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.mas_equalTo(-30);
    }];

        [self.goodsDescribtionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(5);
             make.left.equalTo(self.goodsImageView.mas_right).offset(10);
            make.right.mas_equalTo(-30);
        }];
    
    [self.orderInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(40);
    }];
    
    [self.orderNumberTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.orderInfoLabel.mas_left);
        make.top.equalTo(self.orderInfoLabel.mas_bottom).offset(5);
    }];
    
    [self.orderNumberDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.orderNumberTitleLabel);
        make.height.equalTo(self.orderNumberTitleLabel);
        make.left.equalTo(self.orderNumberTitleLabel.mas_right).offset(8);
    }];
    
    [self.orderTimeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.orderNumberTitleLabel);
        make.top.equalTo(self.orderNumberDetailLabel.mas_bottom).offset(5);
    }];
    
    [self.orderTimeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.orderNumberDetailLabel);
        make.height.equalTo(self.orderNumberDetailLabel);
        make.top.equalTo(self.orderNumberDetailLabel.mas_bottom).offset(5);
    }];

    
    [self.orderTypeTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.orderNumberTitleLabel);
        make.top.equalTo(self.orderTimeTitleLabel.mas_bottom).offset(5);
    }];
    
    [self.orderTypeDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.orderNumberDetailLabel);
        make.height.equalTo(self.orderNumberDetailLabel);
        make.top.equalTo(self.orderTimeDetailLabel.mas_bottom).offset(5);
    }];
    
    [self.orderStateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        
        make.left.mas_equalTo(self.orderNumberTitleLabel);
        
        make.top.equalTo(self.orderTypeTitleLabel.mas_bottom).offset(5);
    }];
    
    [self.orderStateDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.orderNumberDetailLabel);
        make.height.equalTo(self.orderNumberTitleLabel);
        make.top.equalTo(self.orderTypeDetailLabel.mas_bottom).offset(5);
    }];
    
    [self.orderMessageTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.mas_equalTo(self.orderNumberTitleLabel);
        make.top.equalTo(self.orderStateTitleLabel.mas_bottom).offset(5);
    }];
    
    [self.orderPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.orderNumberDetailLabel);
        make.top.equalTo(self.orderStateDetailLabel.mas_bottom).offset(5);
        make.height.equalTo(self.orderMessageTitleLabel);
    }];
    
    [self.orderPVButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self.orderNumberDetailLabel);
        make.top.equalTo(self.orderPriceButton.mas_bottom).offset(5);
        make.height.equalTo(self.orderMessageTitleLabel);
    }];

    [self.AdvisoryListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.left.mas_equalTo(40);
        make.bottom.mas_equalTo(-14);
    }];
    [self.migrateAdvisoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(-15);
        make.left.mas_equalTo(55);
        make.width.equalTo(self.endAdvisoryButton);
        make.height.mas_equalTo(33);
        make.right.equalTo(self.endAdvisoryButton.mas_left).offset(-30);
    }];
    [self.endAdvisoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-15);
        make.right.mas_equalTo(-45);
        make.width.equalTo(self.migrateAdvisoryButton);
        make.height.mas_equalTo(33);
        make.left.equalTo(self.migrateAdvisoryButton.mas_right).offset(30);
    }];
}

//咨询转移
- (void)btnClick:(UIButton *)btn {
    
    if (!self.isShowAdvisoryList) {
        self.headerView.hidden=YES;
        self.listTableView.hidden=YES;
        self.customerServiceListTableView.hidden=NO;
        self.isShowAdvisoryList=YES;
        [self.endAdvisoryButton setTitle:kLocalized(@"GYHD_Cancel_Transfer") forState:UIControlStateNormal];
        [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_move_btn_normal"] forState:UIControlStateNormal];
        [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_move_btn_highlighted"] forState:UIControlStateHighlighted];
        [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_move_btn_select"] forState:UIControlStateSelected];
        
        [self loadCustomerServiceListData];
        
    }else{
        

        @weakify(self);
        [GYAlertView alertWithTitle:kLocalized(@"GYHD_Tip") Message:[NSString stringWithFormat:@"%@%@",kLocalized(@"GYHD_Switch_Session_To"),self.selectKefuName ] topColor:TopColorBlue comfirmBlock:^{
            @strongify(self);
            
            //        进行客户转移动作
            self.headerView.hidden=NO;
            self.listTableView.hidden=NO;
            self.customerServiceListTableView.hidden=YES;
            self.isShowAdvisoryList=NO;
            [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_normal"] forState:UIControlStateNormal];
            [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_highlighted"] forState:UIControlStateHighlighted];
            [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_select"] forState:UIControlStateSelected];
            [self.endAdvisoryButton setTitle:kLocalized(@"GYHD_End_Session") forState:UIControlStateNormal];
            
               [[GYHDSDK sharedInstance] swicthP2CReqWithConsumerid:self.model.Friend_ID consumername:self.model.Friend_Name newkefuid:self.selectKefuId newkefuname:self.selectKefuName oldkefuid:[NSString stringWithFormat:@"p_e_%@",globalData.loginModel.custId] oldkefuname:globalData.loginModel.operName sessionid:self.model.sessionId consumerhead:self.model.Friend_Icon companyname:globalData.loginModel.vshopName companylogo:globalData.loginModel.vshopLogo];
            
                if (self.delegate && [self.delegate respondsToSelector:@selector(closeAdvisoryListView)]) {
                
                [self.delegate closeAdvisoryListView];
                    
                }
        }];
    }
} 
//结束咨询或取消转移
-(void)endSessionClick{

    if (self.isShowAdvisoryList && [self.endAdvisoryButton.currentTitle isEqualToString:kLocalized(@"GYHD_Cancel_Transfer")]) {
//        返回客户记录界面
        self.headerView.hidden=NO;
        self.listTableView.hidden=NO;
        self.customerServiceListTableView.hidden=YES;
        self.isShowAdvisoryList=NO;
        [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_normal"] forState:UIControlStateNormal];
        [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_highlighted"] forState:UIControlStateHighlighted];
        [self.endAdvisoryButton setBackgroundImage:[UIImage imageNamed:@"gyhd_advisory_end_btn_select"] forState:UIControlStateSelected];
        [self.endAdvisoryButton setTitle:kLocalized(@"GYHD_End_Session") forState:UIControlStateNormal];
    }else if(!self.isShowAdvisoryList && [self.endAdvisoryButton.currentTitle isEqualToString:kLocalized(@"GYHD_End_Session")]){
           @weakify(self);
        [GYAlertView alertWithTitle:kLocalized(@"GYHD_Tip") Message:[NSString stringWithFormat:@"将结束%@的咨询吗",self.model.Friend_Name ] topColor:TopColorRed comfirmBlock:^{
            @strongify(self);
            //    触发结束咨询动作
            
            [[GYHDSDK sharedInstance] closePersonToCompanySessionWithUserid:[NSString stringWithFormat:@"p_e_%@",globalData.loginModel.custId] entid:globalData.loginModel.entCustId sessionid:self.model.sessionId kefuid:[NSString stringWithFormat:@"p_e_%@",globalData.loginModel.custId] consumerid:self.model.Friend_ID consumername:self.model.Friend_Name consumerhead:self.model.Friend_Icon companyname:globalData.loginModel.vshopName companylogo:globalData.loginModel.vshopLogo];
            
                if (self.delegate && [self.delegate respondsToSelector:@selector(closeAdvisoryListView)]) {
                
                [self.delegate closeAdvisoryListView];
                
            }
            
        }];
    }
    
}

-(void)setModel:(GYHDCustomerModel *)model{

    _model=model;
//    通过id获取最后一条咨询商品或订单消息以及获取客服历史记录
    
  NSDictionary*dict= [[GYHDDataBaseCenter sharedInstance] selectLastGoodsAndOrderMessageWithCustid:model.Friend_CustID];
    
    NSData*jsData=[dict[@"MSG_Body"] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary*bodyDict=[NSJSONSerialization JSONObjectWithData:jsData options:NSJSONReadingMutableContainers error:nil];
    
    if ([bodyDict[@"msg_code"] isEqualToString:@"15"]) {
//        商品消息
        [self.goodsImageView setImageWithURL:[NSURL URLWithString:bodyDict[@"imageNailsUrl"]] options:kNilOptions];
        self.goodsNameLabel.text =bodyDict[@"prod_name"];
        self.goodsDescribtionLabel.text=bodyDict[@"prod_des"];
        
        self.goodsView.hidden=NO;
        self.orderView.hidden=YES;
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(150);
        }];
        
    }else if([bodyDict[@"msg_code"] isEqualToString:@"16"]){
    
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(240);
        }];
        
        self.orderNumberDetailLabel.text = bodyDict[@"order_no"];
        self.orderTypeDetailLabel.text = bodyDict[@"order_type"];
        self.orderTimeDetailLabel.text = bodyDict[@"order_time"];
        [self.orderPriceButton setTitle: [NSString stringWithFormat:@" %@",bodyDict[@"order_price"]] forState:UIControlStateNormal];
        [self.orderPVButton setTitle:[NSString stringWithFormat:@" %@",bodyDict[@"order_pv"]]  forState:UIControlStateNormal];
        self.orderStateDetailLabel.text =kSaftToNSString(bodyDict[@"order_state"]) ;
//    订单消息
        self.goodsView.hidden=YES;
        self.orderView.hidden=NO;
        
    }else{
        
        [self.headerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
            make.height.mas_equalTo(40);
        }];
        self.goodsView.hidden=YES;
        self.orderView.hidden=YES;
        
    }
    
//    获取客服列表记录
    [self.historyListArray removeAllObjects];
    
    [self loadCustomerServiceHistoryData];
    
}



#pragma mark- 获取客服历史记录列表
-(void)loadCustomerServiceHistoryData{

    NSString*customerId=[self.model.Friend_ID substringFromIndex:2];
    [[GYHDNetWorkTool sharedInstance] queryCustomerServiceRecordListByCustomerId:customerId RequetResult:^(NSArray *resultArry) {
        
        if (resultArry.count>0) {
            
            
            for (NSDictionary*dict in resultArry) {
                
                GYHDAdvisoryListModel*model=[[GYHDAdvisoryListModel alloc]init];
                
                model.nameString = dict[@"csOperNickName"];
                model.timeString = dict[@"creatTimeFormatStr"];
                model.sessionId  = dict[@"sessionId"];
                [self.historyListArray addObject:model];
                
            }
            self.listTableView.hidden=NO;
            self.noCustomerServiceListLabel.hidden=YES;
             [self.listTableView reloadData];
            
        }else{
        
            self.listTableView.hidden=YES;
            self.noCustomerServiceListLabel.hidden=NO;
            
        }

    }];
    
}


#pragma mark - 获取在线客服列表数据
-(void)loadCustomerServiceListData{
    
    [self.customerServiceListArray removeAllObjects];
    
    [[GYHDNetWorkTool sharedInstance] queryOnlineCustomerServiceListWithEntResNo:globalData.loginModel.entResNo RequetResult:^(NSArray *resultArry) {
        
        for (NSDictionary*dict in resultArry) {
            
            GYHDCustomerServiceOnLineModel*model=[[GYHDCustomerServiceOnLineModel alloc]init];
            
            [model initWithDict:dict];
            
            [self.customerServiceListArray addObject:model];
        }
        
        [self.customerServiceListTableView reloadData];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count;
    if (tableView==self.customerServiceListTableView) {
        
        count=self.customerServiceListArray.count;
    }else{
        
        count=self.historyListArray.count;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==self.customerServiceListTableView) {
        
        GYHDAdvisoryCustormerCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDAdvisoryCustormerCell class])];
        GYHDCustomerServiceOnLineModel*model=self.customerServiceListArray[indexPath.row];
        cell.model=model;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
    }else{
    
        GYHDAdvisoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDAdvisoryListCell class])];
        if (self.historyListArray.count>0) {
            
            GYHDAdvisoryListModel*model=self.historyListArray[indexPath.row];
            cell.model=model;
            
            return cell;
        }else{
        
            return nil;
        }
      
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView==self.customerServiceListTableView) {
        
        GYHDCustomerServiceOnLineModel*model=self.customerServiceListArray[indexPath.row];
        
        self.selectKefuId=model.kefuId;
        self.selectKefuName=model.name;
        
        for (GYHDCustomerServiceOnLineModel*tempModel in self.customerServiceListArray) {
            
            tempModel.isSelect=NO;
            
        }
        model.isSelect=YES;
        
        [self.customerServiceListTableView reloadData];
        
    }else{
    
         GYHDAdvisoryListModel*model=self.historyListArray[indexPath.row];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(showCustomerServiceListDetailViewWithModel:)]) {
            
            [self.delegate showCustomerServiceListDetailViewWithModel:model];
        }
        
    }

}
@end




