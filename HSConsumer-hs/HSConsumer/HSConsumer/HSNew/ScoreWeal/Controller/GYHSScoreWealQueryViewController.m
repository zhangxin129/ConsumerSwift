//
//  GYHSScoreWealQueryViewController.m
//
//  Created by lizp on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScoreWealQueryViewController.h"
#import "YYKit.h"
#import "GYHSScoreWealMenuView.h"
#import "GYHSScoreWealNoDataView.h"
#import "GYHSScoreWealQueryViewCell.h"
#import "CheckModel.h"
#import "MJRefresh.h"
#import "GYHSScoreWealQueryDetailViewController.h"
#import "GYHSTools.h"

@interface GYHSScoreWealQueryViewController ()<GYHSScoreWealMenuViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *overlay;//背景
@property (nonatomic,strong) UIButton *dismissBtn;//取消叉叉
@property (nonatomic,strong) GYHSScoreWealMenuView *menu;//菜单栏
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) GYHSScoreWealNoDataView *noDataView;//无数据
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
@property (nonatomic,strong) NSArray *leftType;//左边菜单栏 类型
@property (nonatomic,strong) NSArray *rightType;//右边菜单栏 类型
@property (nonatomic,assign) NSInteger page;//第几页
@property (nonatomic,assign) NSInteger leftIndex;//左边菜单栏下标
@property (nonatomic,assign) NSInteger rightIndex;//右边菜单栏下标
@property (nonatomic,assign) BOOL isDown;//是否下拉
@property (nonatomic, assign) NSInteger totalPage;   //总共页数


@end

@implementation GYHSScoreWealQueryViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);


}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate   
#pragma mark TableView Delegate    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    GYHSScoreWealQueryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSScoreWealQueryViewCellIdentifier];
    if(!cell) {
        cell = [[GYHSScoreWealQueryViewCell alloc] initWithFrame:CGRectMake(0, 0, self.overlay.width, 146)];
    }
    
    CheckModel *model = self.dataSource[indexPath.row];
    [cell refreshOrder:model.applyNo time:model.applyDate type:model.applyType result:model.status account:model.amount];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckModel* model = nil;
    if (self.dataSource.count > indexPath.row) {
        model = self.dataSource[indexPath.row];
    }
    
    GYHSScoreWealQueryDetailViewController *detailVC = [[GYHSScoreWealQueryDetailViewController alloc] init];
    detailVC.applyId = model.applyNo;
    detailVC.navTitle = [NSString stringWithFormat:@"%@%@", model.applyType, kLocalized(@"GYHS_BP_Detail")];
    detailVC.view.frame = self.view.frame;
    detailVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [self addChildViewController:detailVC];
    [self.view addSubview:detailVC.view];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 146;
}

#pragma mark - CustomDelegate
#pragma mark - GYHSScoreWealMenuViewDelegate
-(void)selectLeftIndex:(NSInteger)leftIndex rightIndex:(NSInteger)rightIndex {

    self.isDown = YES;
    self.page = 1;
    self.leftIndex = leftIndex;
    self.rightIndex = rightIndex;
    [self reloadNetworkForScoreWealList];
}
#pragma mark - event response
//取消叉叉
-(void)dismiss {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

//网络请求列表
-(void)reloadNetworkForScoreWealList {
    kCheckLoginedToRoot
    NSDictionary* allFixParas = @{
                                  @"welfareType" : kSaftToNSString(self.leftType[self.leftIndex]),
                                  @"approvalStatus" : kSaftToNSString(self.rightType[self.rightIndex]),
                                  @"curPage" : [NSString stringWithFormat:@"%lu",self.page],
                                  @"pageSize" : @"10"
                                  };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
    [allParas setValue:globalData.loginModel.custId forKey:@"custId"];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kPointWelfareCheckUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }else {
            _totalPage = [responseObject[@"totalPage"] intValue];
            if(self.isDown == YES) {
                [self.dataSource removeAllObjects];
            }
            NSDictionary *dicData = responseObject[@"data"];
            if ([dicData isKindOfClass:[NSNull class]] ) {
                
                [self addNoDataView];
                [self.tableView removeFromSuperview];
                self.tableView = nil;
                return ;
            }
            for (NSDictionary *dic in responseObject[@"data"]) {
                
                CheckModel *model = [[CheckModel alloc] init];
                model.applyDate = kSaftToNSString(dic[@"applyDate"]);
                model.applyNo = kSaftToNSString(dic[@"applyWelfareNo"]);
                
                NSString *dicLeftType = kSaftToNSString(dic[@"welfareType"]);
                if ([dicLeftType isEqualToString:kPointWelfareCheckHealthBenefitsType]) {
                    
                    model.applyType = kLocalized(@"GYHS_BP_Health_Benefits");
                    model.detailType = [kPointWelfareCheckHealthBenefitsType integerValue];
                    
                } else if ([dicLeftType isEqualToString:kPointWelfareCheckAccidentHarmSecurityType]) {
                    
                    model.applyType = kLocalized(@"GYHS_BP_Accident_Harm_Security");
                    model.detailType = [kPointWelfareCheckAccidentHarmSecurityType integerValue];
                    
                } else {
                    
                    model.applyType = kLocalized(@"GYHS_BP_Apply_For_Death_Benefits");
                    model.detailType = [kPointWelfareCheckSubstituteApplyDieSecurityType integerValue];
                }
                
                NSString *dicRightType = kSaftToNSString(dic[@"approvalStatus"]);
                if ([dicRightType isEqualToString:kPointWelfareCheckAcceptSuccessType]) {
                    
                    model.status = kLocalized(@"GYHS_BP_To_Accept_The_Success");
                } else if ([dicRightType isEqualToString:kPointWelfareCheckAcceptWaitType]) {
                    
                    model.status = kLocalized(@"GYHS_BP_To_Accept_The");
                } else {
                    model.status = kLocalized(@"GYHS_BP_Rejected");
                }
                
                model.amount = kSaftToNSString(dic[@"approvalAmount"]);
                [self.dataSource addObject:model];
            }
            
            if(self.dataSource.count) {
                [self.noDataView removeFromSuperview];
                [self.tableView reloadData];
            }else {
                [self.tableView removeFromSuperview];
                self.tableView = nil;
                [self addNoDataView];
            }
            if (_page < _totalPage) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            else {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    self.page = 1;
    self.leftIndex = 0;
    self.rightIndex = 0;
    self.isDown = YES;
    
    [self addOverlayView];
}

//背景
-(void)addOverlayView {
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth -20, kScreenHeight - 64-49 - 60)];
    self.overlay.layer.cornerRadius = 12;
    self.overlay.clipsToBounds = YES;
    self.overlay.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.overlay];
    
    //叉叉按钮
    self.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissBtn.frame = CGRectMake(kScreenWidth/2 -20, self.overlay.bottom +20, 40, 40);
    
    [self.dismissBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissBtn];
    
    
    [self setUp];
}

//绘制UI
-(void)setUp {
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.overlay.bounds.size.width, 40)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = kScoreWealQueryFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x000000);
    titleLabel.text = kLocalized(@"GYHS_Weal_Query");
    [self.overlay addSubview:titleLabel];
    
    NSArray *leftTitle = @[kLocalized(@"GYHS_BP_All"),
                           kLocalized(@"GYHS_BP_Health_Benefits"),
                           kLocalized(@"GYHS_BP_Accident_Harm_Security"),
                           kLocalized(@"GYHS_BP_Apply_For_Death_Benefits")
                           ];
    NSArray *rightTitle = @[kLocalized(@"GYHS_BP_All"),
                            kLocalized(@"GYHS_BP_To_Accept_The_Success"),
                            kLocalized(@"GYHS_BP_To_Accept_The"),
                            kLocalized(@"GYHS_BP_Rejected")
                            ];
    
    self.menu = [[GYHSScoreWealMenuView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.overlay.width, 41) LeftTitle:leftTitle rightTitle:rightTitle];
    self.menu.delegate = self;
    [self.overlay addSubview:self.menu];
    
    
    
    
    [self reloadNetworkForScoreWealList];
    
}

//无数据时加载
-(void)addNoDataView {
    if (self.noDataView == nil) {
        self.noDataView = [[GYHSScoreWealNoDataView alloc] initWithFrame:CGRectMake(self.overlay.left, self.menu.bottom, self.overlay.width, self.overlay.height -self.menu.bottom)];
    }
    [self.overlay addSubview:self.noDataView];
}

#pragma mark - getters and setters  
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.menu.bottom, self.overlay.width, self.overlay.height -self.menu.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        WS(weakSelf)
        _tableView.mj_header = [GYRefreshHeader headerWithRefreshingBlock:^{
            _isDown = YES;
            _page = 1;
            [weakSelf reloadNetworkForScoreWealList];
        }];
        
        _tableView.mj_footer = [GYRefreshFooter footerWithRefreshingBlock:^{
            _isDown = NO;
            _page ++;
            [weakSelf reloadNetworkForScoreWealList];
        }];
        [_overlay addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource {

    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSArray *)leftType {

    if(!_leftType) {
        _leftType = @[@"",
                      kPointWelfareCheckHealthBenefitsType,
                      kPointWelfareCheckAccidentHarmSecurityType,
                      kPointWelfareCheckSubstituteApplyDieSecurityType
                      ];
    }
    return _leftType;
}

-(NSArray *)rightType {

    if(!_rightType) {
        _rightType = @[@"",
                       kPointWelfareCheckAcceptSuccessType,
                       kPointWelfareCheckAcceptWaitType,
                       kPointWelfareCheckAcceptRefuseType
                      ];
    }
    return _rightType;
}

@end
