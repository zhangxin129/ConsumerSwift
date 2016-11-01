//
//  GYWealCheckViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//我的互生-业务办理-积分福利查询

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "GYWealCheckViewController.h"
#import "DropDownListView.h"
#import "WealCheckCell.h"

#import "CheckModel.h"
#import "GYWealCheckDetailVC.h"
#import "GYAlertView.h"
#import "GYHSLoginManager.h"

@interface GYWealCheckViewController () <UITableViewDataSource,
    UITableViewDelegate, DropDownListViewDelegate> {
    IBOutlet UILabel* lbLabelSelectLeft; //显示左边选中的菜单
    IBOutlet UILabel* lbLabelSelectRight; //显示右边选中的菜单

    IBOutlet UIView* ivSelectorBackgroundView; //菜单背景
    IBOutlet UIView* ivMenuSeparator; //菜单分隔列

    IBOutlet UIButton* btnMenuLeft; //左边菜单箭头
    IBOutlet UIButton* btnMenuRight; //右边菜单箭头

    DropDownListView* selectorLeft; //左边弹出菜单
    DropDownListView* selectorRight; //右边弹出菜单

    IBOutlet UILabel* lbLabelNoResult; //无查询结果
    __weak IBOutlet UIView* noResultRemainView;
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, copy) NSString* leftType, *rightType; //左边和右边的状态值
@property (nonatomic, copy) NSString* curruntPage; //当前页

@end

@implementation GYWealCheckViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.arrQueryResult = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [ivSelectorBackgroundView addTopBorder];
    [ivSelectorBackgroundView addBottomBorder];

    CGRect lFrameLeft = lbLabelSelectLeft.frame;
    lFrameLeft.origin.x = ivSelectorBackgroundView.frame.origin.x;
    lFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorLeft.frame = lFrameLeft;

    CGRect rFrameLeft = lbLabelSelectRight.frame;
    rFrameLeft.origin.x = ivMenuSeparator.frame.origin.x;
    rFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorRight.frame = rFrameLeft;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = kLocalized(@"GYHS_BP_Weal_Check");
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    noResultRemainView.hidden = YES;

    lbLabelNoResult.text = kLocalized(@"GYHS_BP_No_Query_Results");
    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCorlorFromRGBA(160, 160, 160, 1)];

    [lbLabelSelectLeft setTextColor:kCellItemTitleColor];
    [lbLabelSelectRight setTextColor:kCellItemTitleColor];

    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];

    UIView* emptyFootView = [[UIView alloc] init];
    self.tableView.tableFooterView = emptyFootView;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    [self.tableView registerNib:[UINib nibWithNibName:@"WealCheckCell" bundle:nil] forCellReuseIdentifier:@"CELL"];

    //尾部刷新
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        if ([self.tableView.mj_footer isRefreshing]) {
            [self getPointWelfareCheckWithLeftType:self.leftType righType:self.rightType page:[NSString stringWithFormat:@"%ld",(self.curruntPage.integerValue + 1)]];
        }
    }];
    self.tableView.mj_footer = footer;

    //头部刷新
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        if ([self.tableView.mj_header isRefreshing]) {
            [self getPointWelfareCheckWithLeftType:self.leftType righType:self.rightType page:@"1"];
        }
    }];
    self.tableView.mj_header = header;

    //设置下拉菜单单击事件
    UITapGestureRecognizer* singleTapRecognizerLeft = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerLeft.numberOfTapsRequired = 1;
    [singleTapRecognizerLeft addTarget:self action:@selector(selectorLeftClick:)];
    lbLabelSelectLeft.userInteractionEnabled = YES;
    [lbLabelSelectLeft addGestureRecognizer:singleTapRecognizerLeft];

    UITapGestureRecognizer* singleTapRecognizerRight = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerRight.numberOfTapsRequired = 1;
    [singleTapRecognizerRight addTarget:self action:@selector(selectorRightClick:)];
    lbLabelSelectRight.userInteractionEnabled = YES;
    [lbLabelSelectRight addGestureRecognizer:singleTapRecognizerRight];

    //设置下拉菜单项
    if (!arrLeftDropMenu) { //用于测试
        arrLeftDropMenu = @[
            kLocalized(@"GYHS_BP_All"),
            kLocalized(@"GYHS_BP_Health_Benefits"),
            kLocalized(@"GYHS_BP_Accident_Harm_Security"),
            kLocalized(@"GYHS_BP_Apply_For_Death_Benefits")
        ];
    }
    if (!arrRightDropMenu) { //用于测试
        arrRightDropMenu = @[
            kLocalized(@"GYHS_BP_All"),
            kLocalized(@"GYHS_BP_To_Accept_The_Success"),
            kLocalized(@"GYHS_BP_To_Accept_The"),
            kLocalized(@"GYHS_BP_Rejected")
        ];
    }

    CGRect rFrameLeft = lbLabelSelectLeft.frame;
    rFrameLeft.origin.x = ivSelectorBackgroundView.frame.origin.x;
    rFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorLeft = [[DropDownListView alloc] initWithArray:arrLeftDropMenu parentView:self.view widthSenderFrame:rFrameLeft];
    //设置初始值
    selectorLeft.selectedIndex = 0;
    lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
    selectorLeft.isHideBackground = NO;
    selectorLeft.delegate = self;

    CGRect rFrameRight = lbLabelSelectRight.frame;
    rFrameRight.origin.x = CGRectGetMaxX(ivMenuSeparator.frame);
    rFrameRight.size.width = rFrameLeft.size.width;
    selectorRight = [[DropDownListView alloc] initWithArray:arrRightDropMenu parentView:self.view widthSenderFrame:rFrameRight];
    //设置初始值
    selectorRight.selectedIndex = 0;
    lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
    selectorRight.isHideBackground = NO;
    selectorRight.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.arrQueryResult.count > 0) {
    }
    else {
        self.leftType = @"";
        self.rightType = @"";
        [self queryWithLeftMenuType:self.leftType rightMenuType:self.rightType]; //全部 - 全部
    }
}

#pragma mark - 查询动作

- (void)queryWithLeftMenuType:(NSString*)leftType rightMenuType:(NSString*)rightType
{

    [self.arrQueryResult removeAllObjects];
    [self getPointWelfareCheckWithLeftType:leftType righType:rightType page:@"1"];
}

#pragma mark - 单击下拉菜单

- (void)selectorLeftClick:(UITapGestureRecognizer*)tap
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先关闭另一边下拉菜单
    if (selectorRight.isShow) {
        [selectorRight hideExtendedChooseView];
        btnMenuRight.transform = transform;
    }

    if (selectorLeft.isShow) {
        [selectorLeft hideExtendedChooseView];
    }
    else {
        [selectorLeft showChooseListView];
        transform = CGAffineTransformRotate(btnMenuLeft.transform, DEGREES_TO_RADIANS(180));
    }

    [UIView animateWithDuration:0.3 animations:^{
        btnMenuLeft.transform = transform;
    }];
}

- (void)selectorRightClick:(UITapGestureRecognizer*)tap
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    //先关闭另一边下拉菜单
    if (selectorLeft.isShow) {
        [selectorLeft hideExtendedChooseView];
        btnMenuLeft.transform = transform;
    }

    if (selectorRight.isShow) {
        [selectorRight hideExtendedChooseView];
    }
    else {
        [selectorRight showChooseListView];
        transform = CGAffineTransformRotate(btnMenuRight.transform, DEGREES_TO_RADIANS(180));
    }

    [UIView animateWithDuration:0.3 animations:^{
        btnMenuRight.transform = transform;
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQueryResult.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 130;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    WealCheckCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    CheckModel* model = nil;
    if (arrQueryResult.count > indexPath.row) {
        model = arrQueryResult[indexPath.row];
    }

    cell.row1R.text = model.applyNo;
    cell.row2R.text = model.applyDate;
    cell.row3R.text = model.applyType;

    cell.row4R.text = model.status;
    if (![model.status isEqualToString:kLocalized(@"GYHS_BP_Rejected")]) {
        //cell.row5R.text = [GYUtils formatCurrencyStyle:model.amount.doubleValue];
        cell.row5R.text = model.amount;
    }

    [cell.row5R setTintColor:[UIColor redColor]];

    cell.orderLb.text = kLocalized(@"GYHS_BP_Apply_Order_Number");
    cell.timeLb.text = kLocalized(@"GYHS_BP_Apply_For_Time");
    cell.typeLb.text = kLocalized(@"GYHS_BP_Apply_For_Welfare_Category");
    cell.resultLb.text = kLocalized(@"GYHS_BP_Review_The_Results");
    cell.amountLb.text = kLocalized(@"GYHS_BP_Approval_Amount");
    cell.queryDetailsLabel.text = kLocalized(@"GYHS_BP_Show_Detail");
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CheckModel* model = nil;
    if (self.arrQueryResult.count > indexPath.row) {
        model = self.arrQueryResult[indexPath.row];
    }
    GYWealCheckDetailVC* vc = [[GYWealCheckDetailVC alloc] init];

    vc.applyId = model.applyNo;

    vc.navigationItem.title = [NSString stringWithFormat:@"%@%@", model.applyType, kLocalized(@"GYHS_BP_Detail")];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - DropDownListViewDelegate

- (void)menuDidSelectIsChange:(BOOL)isChange withObject:(id)sender
{

    if (sender == selectorLeft) {
        if (isChange) { //只有选择不同的条件才执行操作
            lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
        }
        [self selectorLeftClick:nil];
    }
    else if (sender == selectorRight) {
        if (isChange) { //只有选择不同的条件才执行操作
            lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
        }
        [self selectorRightClick:nil];
    }

    if (isChange) {
        NSString* leftType = @""; //空字符为全部 -- 全部
        if ([arrLeftDropMenu[selectorLeft.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_Health_Benefits")]) {

            leftType = kPointWelfareCheckHealthBenefitsType;
        }
        else if ([arrLeftDropMenu[selectorLeft.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_Accident_Harm_Security")]) {

            leftType = kPointWelfareCheckAccidentHarmSecurityType;
        }
        else if ([arrLeftDropMenu[selectorLeft.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_Apply_For_Death_Benefits")]) {
            leftType = kPointWelfareCheckSubstituteApplyDieSecurityType;
        }

        NSString* rightType = @""; //空字符为全部 -- 全部
        if ([arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_To_Accept_The_Success")]) {

            rightType = kPointWelfareCheckAcceptSuccessType;
        }
        else if ([arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_To_Accept_The")]) {

            rightType = kPointWelfareCheckAcceptWaitType;
        }
        else if ([arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_Rejected")]) {

            rightType = kPointWelfareCheckAcceptRefuseType;
        }
        self.leftType = leftType;
        self.rightType = rightType;
        [self queryWithLeftMenuType:kSaftToNSString(leftType) rightMenuType:kSaftToNSString(rightType)];
    }
}

#pragma mark - 接口重构 by zxm 201600105
- (void)getPointWelfareCheckWithLeftType:(NSString*)leftType righType:(NSString*)righType page:(NSString*)page
{

    NSDictionary* allFixParas = @{
        @"welfareType" : kSaftToNSString(leftType),
        @"approvalStatus" : kSaftToNSString(righType),
        @"curPage" : page,
        @"pageSize" : @"10"
    };
    NSMutableDictionary* allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];

    [allParas setValue:globalData.loginModel.custId forKey:@"custId"];

    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kPointWelfareCheckUrlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dicData = responseObject[@"data"];
        if ([dicData isKindOfClass:[NSNull class]]) {
            
            self.tableView.hidden = YES;
            [self.arrQueryResult removeAllObjects];
            [self.tableView reloadData];
            noResultRemainView.hidden = NO;
            return;
        }
        
        self.curruntPage = page;
        if (page.integerValue == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            [self.arrQueryResult removeAllObjects];
        }
        
        NSMutableArray *tempArr = [[NSMutableArray alloc] init];
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
            [tempArr addObject:model];
        }
        [self.arrQueryResult addObjectsFromArray:tempArr];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        if (self.arrQueryResult.count > 0) {
            
            self.tableView.hidden = NO;
            [self.tableView reloadData];
            noResultRemainView.hidden = YES;
            
            if (tempArr.count == 0 ) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } else {
            self.tableView.hidden = YES;
            [self.arrQueryResult removeAllObjects];
            [self.tableView reloadData];
            noResultRemainView.hidden = NO;
        }
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

@end
