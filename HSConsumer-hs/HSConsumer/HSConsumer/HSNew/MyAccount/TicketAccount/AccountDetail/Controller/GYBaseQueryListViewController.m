//
//  GYBaseQueryListViewController.m
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//明细查询类

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kCellSubCellHeight 23.f

#import "GYBaseQueryListViewController.h"
#import "DropDownListView.h"
#import "CellViewDetailCell.h"
#import "CellDetailRow.h"

#import "GYInvestDividendsDetailsViewController.h"
#import "ViewTipBkgView.h"
#import "GYAlertView.h"
#import "GYHSTools.h"

@interface GYBaseQueryListViewController () <UITableViewDataSource,
    UITableViewDelegate, DropDownListViewDelegate> {
    GlobalData* data; //全局单例

    IBOutlet UILabel* lbLabelSelectLeft; //显示左边选中的菜单
    IBOutlet UILabel* lbLabelSelectRight; //显示右边选中的菜单
    ViewTipBkgView* viewTipBkg;

    IBOutlet UIView* ivSelectorBackgroundView; //菜单背景
    IBOutlet UIView* ivMenuSeparator; //菜单分隔列

    IBOutlet UIButton* btnMenuLeft; //左边菜单箭头
    IBOutlet UIButton* btnMenuRight; //右边菜单箭头

    DropDownListView* selectorLeft; //左边弹出菜单
    DropDownListView* selectorRight; //右边弹出菜单

    NSDictionary* dicConf; //取得明细的配置文件对应模块
    NSDictionary* dicTransCodes; //交易类型字典
    NSArray* arrListProperty; //取得列表的属性文件

    int pageSize; //每次/每页获取多少行记录
    //    BOOL isHasNext; //有下一页
    int pageNo; //下一页
    //    NSDictionary *jsonDataDic;//测试的本地数据
        
        
    __weak IBOutlet UILabel *titleLab;
    
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;
/**
 *  tableView的Y值
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* tableViewYLayout;
@property (nonatomic, strong) NSArray* arrLeftDropMenu;
@property (nonatomic, strong) NSArray* arrRightDropMenu;
@property (nonatomic, strong) NSMutableArray* arrQueryResult;

@end

@implementation GYBaseQueryListViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowBtnDetail = YES;
        _startPageNo = 1;
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [ivSelectorBackgroundView addTopBorderWithBorderWidth:0.5 andBorderColor:kCellLineGary];
    [ivSelectorBackgroundView addBottomBorderWithBorderWidth:0.5 andBorderColor:kCellLineGary];
    [ivSelectorBackgroundView setBottomBorderInset:YES];

    CGRect lFrameLeft = lbLabelSelectLeft.frame;
    lFrameLeft.origin.x = ivSelectorBackgroundView.frame.origin.x;
    lFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorLeft.frame = lFrameLeft;

    CGRect rFrameLeft = lbLabelSelectRight.frame;
    rFrameLeft.origin.x = ivMenuSeparator.frame.origin.x;
    rFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorRight.frame = rFrameLeft;
    
    lbLabelSelectLeft.font = kAlterDetailCellFont;
    lbLabelSelectRight.font = kAlterDetailCellFont;
    titleLab.text = _titleStr;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!_isShowBtnDetail) {
        lbLabelSelectLeft.hidden = YES;
        lbLabelSelectRight.hidden = YES;
        ivSelectorBackgroundView.hidden = YES;
        ivMenuSeparator.hidden = YES;
        btnMenuLeft.hidden = YES;
        btnMenuRight.hidden = YES;

        self.tableViewYLayout.constant = 0;
    }

    //实例化单例
    data = globalData;

    //控制器背景色
    [self.view setBackgroundColor:[UIColor whiteColor]];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:self.tableView.frame];
    viewTipBkg.center = CGPointMake(self.tableView.center.x, viewTipBkg.center.y+44);
    [viewTipBkg.lbTip setText:kLocalized(@"GYHS_Common_Storry_No_Record")];
    viewTipBkg.lbTip.textColor = UIColorFromRGB(0x8C8C8C);
    viewTipBkg.lbTip.font = kAlterDetailCellFont;
    [self.view addSubview:viewTipBkg];
    viewTipBkg.hidden = YES;
    titleLab.font = kAlterTitleFont;
    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCellLineGary];

    [lbLabelSelectLeft setTextColor:kCellTitleBlack];
    [lbLabelSelectRight setTextColor:kCellTitleBlack];
    [GYUtils setFontSizeToFitWidthWithLabel:lbLabelSelectLeft labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lbLabelSelectRight labelLines:1];

    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView registerClass:[CellViewDetailCell class] forCellReuseIdentifier:kCellViewDetailCellIdentifier];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];
    self.tableView.separatorColor = kCellLineGary;

    //设置下拉菜单单击事件
    UITapGestureRecognizer* singleTapRecognizerLeft = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerLeft.numberOfTapsRequired = 1;
    [singleTapRecognizerLeft addTarget:self action:@selector(selectorLeftClick:)];
    lbLabelSelectLeft.userInteractionEnabled = YES;
    //modify by zhangqy
    [lbLabelSelectLeft addGestureRecognizer:singleTapRecognizerLeft];

    UITapGestureRecognizer* singleTapRecognizerRight = [[UITapGestureRecognizer alloc] init];
    singleTapRecognizerRight.numberOfTapsRequired = 1;
    [singleTapRecognizerRight addTarget:self action:@selector(selectorRightClick:)];
    lbLabelSelectRight.userInteractionEnabled = YES;

    // add by songjk 当只有选择只有一个的时候不提供下拉
    //    if (self.arrRightParas.count <=1)
    //    {
    //        lbLabelSelectRight.userInteractionEnabled = NO;
    //        btnMenuRight.hidden=YES;
    //    }
    //    if (self.arrLeftParas.count<=1) {
    //        lbLabelSelectLeft.userInteractionEnabled = NO;
    //        btnMenuLeft.hidden=YES;
    //    }
    //modify by zhangqy
    [lbLabelSelectRight addGestureRecognizer:singleTapRecognizerRight];

    pageSize = 10;
    pageNo = _startPageNo;

    NSDictionary* configDic = [[GYHSLoginManager shareInstance] dicHsConfig];

    if (configDic) {
        NSString* dicKey = [@"conf_" stringByAppendingString:[@(self.detailsCode) stringValue]];
        dicConf = configDic[dicKey];
        DDLogInfo(@"明细的配置字典dicConf(key:%@): %@", dicKey, [GYUtils dictionaryToString:dicConf]);
        self.arrLeftDropMenu = [self internationalizationWithArray:dicConf[@"list_left_menu"]];
        self.arrRightDropMenu = [self internationalizationWithArray:dicConf[@"list_rigth_menu"]];
        arrListProperty = dicConf[@"list_property"];
        pageSize = [dicConf[@"list_pageSize"] intValue];
        dicTransCodes = dicConf[@"trans_code_list"];
    }
    else {
        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Common_Failed_Find_Query_Detail_List_Configuration_File") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        return;
    }

    if (!self.arrLeftParas || !self.arrRightParas) { //左 右下拉菜单 必须项
        DDLogInfo(@"Params init error.");
        [self.tableView setHidden:YES];

        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_Common_Parameter_Error") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        return;
    }

    CGRect rFrameLeft = lbLabelSelectLeft.frame;
    rFrameLeft.origin.x = ivSelectorBackgroundView.frame.origin.x;
    rFrameLeft.size.width = ivMenuSeparator.frame.origin.x;
    selectorLeft = [[DropDownListView alloc] initWithArray:arrLeftDropMenu parentView:self.view widthSenderFrame:rFrameLeft];
    //设置初始值
    selectorLeft.selectedIndex = 0;
    lbLabelSelectLeft.text = arrLeftDropMenu[selectorLeft.selectedIndex];
    if(_noLeftDownBtnText) {
        lbLabelSelectLeft.text = _noLeftDownBtnText;
        lbLabelSelectLeft.userInteractionEnabled = NO;
        btnMenuLeft.hidden = YES;
    }
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
    if (!self.arrQueryResult)
        self.arrQueryResult = [NSMutableArray array];

    self.tableView.tableFooterView = [[UIView alloc] init];

    //    添加尾部刷新

    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        
        [self footerRereshing];

    }];

    self.tableView.mj_footer = footer;

    [self get_act_trade_list_isAppendResult_new:NO andShowHUD:YES];

    //    添加头部刷新

    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        
        //        请求数据
        [self headerRereshing];

    }];

    //单例 调用刷新图片

    self.tableView.mj_header = header;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    if([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
    pageNo = _startPageNo;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self get_act_trade_list_isAppendResult_new:NO andShowHUD:NO];
}

- (void)footerRereshing
{
    if([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    [self get_act_trade_list_isAppendResult_new:YES andShowHUD:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 查询动作

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    //测试
    //    [self queryWithLeftMenuIndex:0 rightMenuIndex:0];
}

- (void)queryWithLeftMenuIndex:(NSInteger)lIndex rightMenuIndex:(NSInteger)rIndex
{
    DDLogDebug(@"【明细查询】 条件【%@】【%@】 正在查询，请稍后...", self.arrLeftDropMenu[lIndex], self.arrRightDropMenu[rIndex]);

    pageNo = _startPageNo;
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self get_act_trade_list_isAppendResult_new:NO andShowHUD:YES];
}

//根据账户类型返回查询接口的参数
- (NSArray*)get_cmd_para_and_list_key
{
    NSArray* p_k = @[ @"", @"" ];

    switch (self.detailsCode) {
    case kDetailsCode_Point:
        p_k = @[ @"get_integral_act_trade_list", @"integralTradeList" ];

        break;

    case kDetailsCode_Cash:
        p_k = @[ @"get_cash_act_trade_list", @"cashTradeList" ];
        break;

    case kDetailsCode_HSDToCash:
        p_k = @[ @"get_hsb_transfer_cash_trade_list", @"hsbTransferCashTradeList" ];
        break;

    case kDetailsCode_HSDToCon:
        p_k = @[ @"get_hsb_transfer_consume_trade_list", @"hsbTransferConsumeTradeList" ];
        break;

    case kDetailsCode_InvestPoint:
        p_k = @[ @"get_invest_act_trade_list", @"investTradeList" ];
        break;

    case kDetailsCode_InvestDividends:
        p_k = @[ @"get_invest_dividends_list", @"data" ];
        break;
    case kDetailsCode_foods:
        p_k = @[ @"get_food_details_list", @"data" ];
        break;
    default:
        break;
    }
    return p_k;
}

//获取acctype
- (NSString*)getAccTypeString
{
    NSString* accTypeStr = nil;
    switch (self.detailsCode) {
    case kDetailsCode_Point:
        accTypeStr = kAccTypePointAccoutDetail; //积分账户明细
        break;
    case kDetailsCode_Cash:
        accTypeStr = kAccTypeCashAccoutDetail;
        break;
    case kDetailsCode_HSDToCash:
        accTypeStr = kAccTypeCashQueryDetail;
        break;
    case kDetailsCode_HSDToCon:
        accTypeStr = kAccTypeDirectionalCashQueryDetail;
        break;
    case kDetailsCode_InvestPoint: //投资账户-积分投资明细
        accTypeStr = kAccTypeInvestAccoutDetail;
        break;
    default:
        break;
    }
    return accTypeStr;
}

- (NSString*)getDateFlagString
{
    NSString* dateStr = nil;
    if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_Common_Today")]) {
        dateStr = @"today";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_Common_In_The_LatestWeek")]) {
        dateStr = @"week";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_Common_Last_Month")]) {
        dateStr = @"month";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_Common_Last_One_Year")]) {
        //投资分红明细
        dateStr = @"oneYear";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_Common_The_Past_Three_Years")]) {

        //投资分红明细
        dateStr = @"threeYear";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_Common_The_Past_Five_Years")]) {

        //投资分红明细
        dateStr = @"fiveYear";
    }
    return dateStr;
}


//语言国际化处理
-(NSArray *)internationalizationWithArray:(NSArray *)array {
    
    if(array == nil || [GYUtils checkArrayInvalid:array]) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *str in array) {
        NSString *string = [[str componentsSeparatedByString:@","] firstObject];
        [result addObject:kLocalized(string)];
    }
    
    return result;
}

#pragma mark - 接口重构  by zxm 20151230
- (void)get_act_trade_list_isAppendResult_new:(BOOL)append andShowHUD:(BOOL)isShow
{
    kCheckLoginedToRoot
    NSMutableDictionary* allParas = [NSMutableDictionary dictionary];
    NSString* urlString = @"";
    //投资账户-投资分红明细查询接口单独分开
    if (self.detailsCode == kDetailsCode_InvestDividends) {

        urlString = kInvestAccountInvestDividendsListDetailUrlString;
        [allParas setValue:kSaftToNSString(globalData.loginModel.custId) forKey:@"custId"];
        [allParas setValue:[self getDateFlagString] forKey:@"dateFlag"];
        [allParas setValue:[NSString stringWithFormat:@"%d", pageNo] forKey:@"curPage"];

        [GYGIFHUD show];
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:urlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            [self setDataWithDictionary:responseObject error:error isAppend:append];
        }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
    }
    else {

        urlString = kBaseQueryListDetailUrlString;

        NSString* accTypeStr = [self getAccTypeString];
        NSString* dateStr = [self getDateFlagString];
        if (accTypeStr == nil) { //业务办理查询和餐饮明细暂未添加
            return;
        }
        NSDictionary* allFixParas = @{ @"businessType" : self.arrLeftParas[selectorLeft.selectedIndex],
            @"accType" : kSaftToNSString(accTypeStr),
            @"dateFlag" : kSaftToNSString(dateStr),
            @"currentPage" : [NSString stringWithFormat:@"%d", pageNo],
            @"pageSize" : [NSString stringWithFormat:@"%d", pageSize] };
        allParas = [NSMutableDictionary dictionaryWithDictionary:allFixParas];
        [allParas setValue:kSaftToNSString(data.loginModel.custId) forKey:@"custId"];

        [GYGIFHUD show];
        GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:urlString parameters:allParas requestMethod:GYNetRequestMethodPOST requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
            [GYGIFHUD dismiss];
            [self setDataWithDictionary:responseObject error:error isAppend:append];
        }];
        [request commonParams:[GYUtils netWorkCommonParams]];
        [request start];
        
        
    }
    
}

#pragma mark - 明细查询网络请求返回数据
- (void)setDataWithDictionary:(NSDictionary*)responseObject error:(NSError*)error isAppend:(BOOL)isAppend
{

    if (!isAppend) {
        if (self.arrQueryResult && self.arrQueryResult.count > 0) {
            [self.arrQueryResult removeAllObjects];
            self.arrQueryResult = nil;
        }
        self.arrQueryResult = [NSMutableArray array];
    }
    BOOL hasNext = NO;
    if (error) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [GYUtils parseNetWork:error resultBlock:nil];
        
        return ;
    }
    NSDictionary* dic = responseObject;
    if (![dic[@"data"] isKindOfClass:[NSNull class]] && dic[@"data"] && [dic[@"data"] count]) {
        
        int totalPage = (int)kSaftToNSInteger(dic[@"totalPage"]); //用于判断是否有下一页
        pageNo = (int)kSaftToNSInteger(dic[@"currentPageIndex"]);
        NSArray* arrRes = dic[@"data"];
        
        if (self.detailsCode == kDetailsCode_InvestDividends) {
            if (![dic[@"data"][@"result"] isKindOfClass:[NSNull class]] && dic[@"data"][@"result"] && [dic[@"data"][@"result"] count]) {
                arrRes = dic[@"data"][@"result"];
                self.dividendYear = arrRes[0][@"dividendYear"];
                self.dividendNo = arrRes[0][@"dividendNo"];
            }
        }
        
        NSString* transString = @"";
        NSString* detailsType = @"0";
        for (NSDictionary* dicArrRes in arrRes) {
            
            NSMutableArray* arrSubTmp = [NSMutableArray array];
            for (NSArray* keys in arrListProperty) {
                NSString* flag = kSaftToNSString(keys[2]);
                NSString* title = kLocalized(kSaftToNSString(keys[1]));
                if ([flag isEqualToString:@"0"] || [flag isEqualToString:@"1"]) { //直接取返回的key
                    
                    NSString* value = kSaftToNSString(dicArrRes[keys[0]]);
                    if ([kSaftToNSString(keys[0]) isEqualToString:@"amount"]) {
                        
                        if ([dicArrRes[@"businessType"] isEqualToNumber:@2]) {
                            //支出
                            value = [NSString stringWithFormat:@"%@", kSaftToNSString(dicArrRes[keys[0]])];
                        }
                        else {
                            //收入
                            value = [NSString stringWithFormat:@"%@", kSaftToNSString(dicArrRes[keys[0]])];
                        }
                    }
                    else if ([kSaftToNSString(keys[0]) isEqualToString:@"accBalanceNew"]) {
                        value = [GYUtils formatCurrencyStyle:[value doubleValue] ];
                        
                    }
                    
                    [arrSubTmp addObject:@{ @"title" : title,
                                            @"value" : value }];
                }
                else if ([flag isEqualToString:@"25"]) {
                    NSString* str;
                    NSString* value = dicArrRes[@"amount"];
                    if ([dicArrRes[@"businessType"] isEqualToNumber:@2]) {
                        //支出
                        str = kLocalized(@"GYHS_Common_Spending");
                    }
                    else {
                        //收入
                        str = kLocalized(@"GYHS_Common_Income");
                    }
                    value = [GYUtils formatCurrencyStyle:[value doubleValue]];
                    [arrSubTmp addObject:@{ @"title" : str,
                                            @"value" : value }];
                }
                else if ([flag isEqualToString:@"2"]) { //交易类型,根据返回的transCode取对应的中文
                    //默认为特殊取PS系统,eg:20
                    NSArray* transCode = [dicTransCodes[kSaftToNSString(dicArrRes[@"transSys"])] componentsSeparatedByString:@","];
                    
                    if ([dicArrRes[@"transSys"] isEqualToString:@"PS"]) { //PS系统交易代码
                        //取PS系统代码,eg:20
                        transCode = [dicTransCodes[kSaftToNSString(dicArrRes[@"transTypePs"])] componentsSeparatedByString:@","];
                    }
                    else {
                        
                        //取交易代码表eg:A11300
                        transCode = [dicTransCodes[kSaftToNSString(dicArrRes[keys[0]])] componentsSeparatedByString:@","];
                    }
                    
                    NSString* strValue = kLocalized(transCode[0]);
                    
                    detailsType = @"";
                    transString = @"";
                    if (transCode.count > 1) {
                        detailsType = transCode[1];
                    }
                    
                    if (!strValue) { //显示未知类型
                        DDLogInfo(@"明细列表数据，未知交易类型代码为:%@", kSaftToNSString(dicArrRes[keys[0]]));
                        
                        strValue = [dicTransCodes[@"UNKNOW_TYPE"] componentsSeparatedByString:@","][0];
                    }
                    else {
                        transString = strValue;
                    }
                    
                    [arrSubTmp addObject:@{ @"title" : title,
                                            @"value" : strValue }];
                }
            }
            [self.arrQueryResult addObject:@{ @"subRes" : arrSubTmp,
                                              @"trade_sn" : kSaftToNSString(dicArrRes[dicConf[@"trade_sn_key"]]),
                                              @"transString" : transString,
                                              @"detailsType" : detailsType,
                                              @"dicItem" : dicArrRes }];
        }
        
        if (pageNo < totalPage) {
            hasNext = YES;
            pageNo++;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.arrQueryResult isKindOfClass:[NSNull class]]) {
            self.arrQueryResult = nil;
        }
        self.tableView.hidden = (self.arrQueryResult && self.arrQueryResult.count > 0 ? NO : YES);
        viewTipBkg.hidden = !self.tableView.hidden;

        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (!hasNext) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
        }
    });
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
//- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
//{
//    return self.arrQueryResult.count;
//}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
//    return 1;
    return self.arrQueryResult.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger section = indexPath.row;
    static NSString* cellid = kCellViewDetailCellIdentifier;
    CellViewDetailCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath]; //使用此方法加载，必须先注册nib或class
    if (!cell) {
        cell = [[CellViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        
    }
    cell.type = @"1";
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (dicConf) { //高亮配置
        cell.rowValueHighlightedProperty = dicConf[@"list_value_highlighted_property"];
        cell.rowTitleHighlightedProperty = dicConf[@"list_title_highlighted_property"];
    }
    if(self.arrQueryResult.count > section) {
        cell.arrDataSource = self.arrQueryResult[section][@"subRes"];
    }
    

    NSInteger subRows = cell.arrDataSource.count;
    cell.cellSubCellRowHeight = kCellSubCellHeight;
    [cell.tableView setUserInteractionEnabled:NO];
    if (self.isShowBtnDetail) {
        cell.tableView.frame = CGRectMake(0, 5, kScreenWidth - 20, kCellSubCellHeight * (subRows + 1));

        [cell.labelShowDetails setFont:kAlterOtherCellFont];
        cell.labelShowDetails.frame = CGRectMake(0,
            kCellSubCellHeight * subRows + 4,
            kScreenWidth - 20,
            kCellSubCellHeight);
    }
    else {
        cell.tableView.frame = CGRectMake(0, 5, kScreenWidth - 20, kCellSubCellHeight * subRows);
        if (cell.labelShowDetails.superview) {
            [cell.labelShowDetails removeFromSuperview];
            cell.labelShowDetails = nil;
        }
    }
    [cell.tableView reloadData]; //表格嵌套，复用须 reloaddata，否则无法更新数据
    return cell;
}
//- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 0;
//    }
//    return 15;
//}
-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.backgroundColor = [UIColor whiteColor];
}
//按index递增排序
- (NSMutableArray*)sortByIndex:(NSMutableArray*)arr
{
    NSMutableArray* arrDataSource = arr;
    NSSortDescriptor* sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        int obj1Idx = [obj1 intValue];
        int obj2Idx = [obj2 intValue];
        return obj1Idx < obj2Idx ? NSOrderedAscending : NSOrderedDescending;
    }];

    [arrDataSource sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    return arrDataSource;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(self.arrQueryResult.count > indexPath.section) {
        CGFloat h = kCellSubCellHeight * ([self.arrQueryResult[indexPath.section][@"subRes"] count] + (self.isShowBtnDetail ? 1 : 0)) + 10;
        return h;

    }
    return 0;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    //    if (!self.isShowBtnDetail)return;//没有详情
    //
    //    NSInteger section = indexPath.section;
    //    NSString *trade_sn = arrQueryResult[row][@"trade_sn"];//kSaftToNSString(dicArrRes[dicConf[@"trade_sn_key"]]);
    //
    //    if (self.detailsCode == kDetailsCode_InvestDividends) //投资分红明细
    //    {
    //        GYInvestDividendsDetailsViewController *details = [[GYInvestDividendsDetailsViewController alloc] init];
    //        details.dividendYear=self.dividendYear;
    //
    //        details.dicConf = dicConf[@"details_property"][@"sub_list"];
    //        details.strTradeSn = trade_sn;
    //        details.navigationItem.title = kLocalized(@"HS_InvestmentShareOutBonusDetails");
    //        details.isShowBtnDetail = NO;
    //        [self.navigationController pushViewController:details animated:YES];
    //
    //    }else
    //    {
    //        GYDetailsNextViewController *details = [[GYDetailsNextViewController alloc] init];
    //        details.dicDetailsProperty = dicConf[@"details_property"][[@"details_key_value_type_" stringByAppendingString:arrQueryResult[row][@"detailsType"]]];
    //
    //        details.dicItem = arrQueryResult[row][@"dicItem"];
    //        details.detailsCode = self.detailsCode;
    //        details.dicTransCodes = dicTransCodes;
    //        details.dicCurrencyCodes = dicConf[@"currency_code_list"];
    //        details.strTradeSn = trade_sn;
    //
    //        details.strTransString = kSaftToNSString(arrQueryResult[row][@"transString"]);
    //        details.navigationItem.title = [details.strTransString stringByAppendingString:kLocalized(@"details")];
    //        [self.navigationController pushViewController:details animated:YES];
    //    }
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
        [self queryWithLeftMenuIndex:selectorLeft.selectedIndex rightMenuIndex:selectorRight.selectedIndex];
    }
}

+ (NSString*)getDateRangeFromTodayWithDays:(NSInteger)daysAgo
{
    NSString* dateFormat = @"yyyy-MM-dd";
    if (daysAgo < 0) { //全部
        return [NSString stringWithFormat:@"%@~%@", @"0000-00-00", [GYUtils dateToString:[NSDate date] dateFormat:dateFormat]];
    }

    NSDate* today = [NSDate date];
    NSString* strToday = [GYUtils dateToString:today dateFormat:dateFormat];
    if (daysAgo == 0) { //今天
        return [NSString stringWithFormat:@"%@~%@", strToday, strToday];
    }

    //以下按天数
    NSDate* oldDays = [NSDate dateWithTimeIntervalSinceNow:-24.0f * 60 * 60 * daysAgo];
    NSString* strOldDays = [GYUtils dateToString:oldDays dateFormat:dateFormat];
    return [NSString stringWithFormat:@"%@~%@", strOldDays, strToday];

    
}


@end
