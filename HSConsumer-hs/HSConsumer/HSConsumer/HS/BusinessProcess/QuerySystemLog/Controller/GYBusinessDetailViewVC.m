//
//  GYBusinessDetailViewVC
//  HSConsumer
//
//  Created by apple on 14-10-29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

//明细查询类

#import "GYBusinessDetailViewVC.h"
#import "DropDownListView.h"
#import "CellViewDetailCell.h"
#import "CellDetailRow.h"
#import "GYPaymentConfirmViewController.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
#define kCellSubCellHeight 26.f

// 互生卡补办
#define kGYBusinessDetailViewVCMakeUpHSCard 3

// 互生卡解挂
#define HSCARD_LOSS_END @"1"
//互生卡补办
#define HSCARD_APPLY @"2"
//实名注册
#define REALNAME_REG @"3"
// 实名认证
#define REALNAME_AUTH @"4"
// 重要信息变更
#define MAININFO_CHANGE @"5"
// 互生卡挂失
#define HSCARD_LOSS @"6"

@interface GYBusinessDetailViewVC () <UITableViewDataSource,
    UITableViewDelegate, DropDownListViewDelegate> {
    GlobalData* data; //全局单例

    IBOutlet UILabel* lbLabelSelectLeft; //显示左边选中的菜单
    IBOutlet UILabel* lbLabelSelectRight; //显示右边选中的菜单
    IBOutlet UILabel* lbNoResultTip; //无查询结果
    IBOutlet UIView* viewTipBkg;

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
    NSInteger pageNo; //下一页
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* arrLeftDropMenu;
@property (nonatomic, strong) NSArray* arrRightDropMenu;
@property (nonatomic, strong) NSMutableArray* arrQueryResult;
@property (nonatomic, assign) int startPageNo; //从第几开始
@property (assign, nonatomic) CGFloat labelheight;
@end

@implementation GYBusinessDetailViewVC
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowBtnDetail = NO;
        _startPageNo = 1;
        _detailsCode = kDetailsCode_BusinessPro;
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
    self.title = kLocalized(@"GYHS_BP_System_Log_Query");

    //实例化单例
    data = globalData;

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    [lbNoResultTip setTextColor:kCellItemTextColor];
    [lbNoResultTip setText:kLocalized(@"GYHS_BP_Details_No_Result")];
    [GYUtils setFontSizeToFitWidthWithLabel:lbNoResultTip labelLines:1];
    viewTipBkg.hidden = YES;

    //设置菜单中分隔线颜色
    [ivMenuSeparator setBackgroundColor:kCorlorFromRGBA(221, 221, 221, 1)];

    [lbLabelSelectLeft setTextColor:kCellItemTitleColor];
    [lbLabelSelectRight setTextColor:kCellItemTitleColor];
    [GYUtils setFontSizeToFitWidthWithLabel:lbLabelSelectLeft labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lbLabelSelectRight labelLines:1];

    [btnMenuLeft addTarget:self action:@selector(selectorLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnMenuRight addTarget:self action:@selector(selectorRightClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.tableView registerClass:[CellViewDetailCell class] forCellReuseIdentifier:kCellViewDetailCellIdentifier];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];

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

    pageSize = 10;
    pageNo = _startPageNo;
    NSDictionary* configDic = [[GYHSLoginManager shareInstance] dicHsConfig];

    if (configDic) {
        NSString* dicKey = [@"conf_" stringByAppendingString:[@(self.detailsCode) stringValue]];
        dicConf = configDic[dicKey];
        DDLogInfo(@"%@ %@: %@", kLocalized(@"GYHS_BP_Detail_Configuration_Dictionary_Key:"), dicKey, [GYUtils dictionaryToString:dicConf]);
        self.arrLeftDropMenu = [self internationalizationWithArray:dicConf[@"list_left_menu"]];
        self.arrRightDropMenu = [self internationalizationWithArray:dicConf[@"list_rigth_menu"]];
        arrListProperty = dicConf[@"list_property"];
        pageSize = [dicConf[@"list_pageSize"] intValue];
        dicTransCodes = dicConf[@"trans_code_list"];
    }
    else {
        DDLogInfo(kLocalized(@"GYHS_BP_Query_Detail_List_Configuration_File_Not_Found"));
        [self.tableView setHidden:YES];
        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"未能找到查询明细列表的配置文件") confirm:^{
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

    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        [self footerRereshing];
    }];

    self.tableView.mj_footer = footer;
    [self queryBusinessStatus:NO];

    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        [self headerRereshing];
    }];

    //单例 调用刷新图片

    self.tableView.mj_header = header;
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    pageNo = _startPageNo;
    [self.tableView.mj_footer resetNoMoreData];
    [self footerRereshing];
}

- (void)footerRereshing
{
    if (selectorLeft.selectedIndex == kGYBusinessDetailViewVCMakeUpHSCard) {
        [self makeupHSCard:NO];
    }
    else {
        [self queryBusinessStatus:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - 查询动作

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)queryWithLeftMenuIndex:(NSInteger)lIndex rightMenuIndex:(NSInteger)rIndex
{
    DDLogDebug(@"%@【%@】【%@】%@ ", kLocalized(@"GYHS_BP_Detailed_Query_Conditions"), self.arrLeftDropMenu[lIndex], self.arrRightDropMenu[rIndex], kLocalized(@"GYHS_BP_Being_Queried_Please_Later"));
    pageNo = _startPageNo;
    [self.tableView.mj_footer resetNoMoreData];
    [self footerRereshing];
}

//互生卡补办查询
- (void)makeupHSCard:(BOOL)append
{
    [self.arrQueryResult removeAllObjects];
    [self.tableView reloadData];

    NSString* dateStr = [self getDateFlagString];
    NSDictionary* allParas = @{ @"custId" : data.loginModel.custId,
        @"typeFlag" : [self getLeftParams],
        @"dateFlag" : dateStr,
        @"pageSize" : [@(pageSize) stringValue],
        @"curPage" : [@(pageNo) stringValue] };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kperBusinessStatusUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (!append) {
            if (self.arrQueryResult && self.arrQueryResult.count > 0) {
                [self.arrQueryResult removeAllObjects];
                self.arrQueryResult = nil;
            }
            self.arrQueryResult = [NSMutableArray array];
        }
        BOOL hasNext = NO;
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            [self showNoDatePage];
            return ;
        }
        NSDictionary *dic = responseObject;
        dic = dic[@"data"];
        NSInteger totalPage = kSaftToNSInteger(dic[@"totalPage"]);//用于判断是否有下一页
        pageNo = kSaftToNSInteger(dic[@"pageNo"]);
        
        NSArray *arrRes = dic[@"result"];
        if ([GYUtils checkArrayInvalid:arrRes]) {
            DDLogDebug(@"the arrRes:%@ is invalid.", arrRes);
            [self showNoDatePage];
            return;
        }
        
        for (NSDictionary *dicArrRes in arrRes) {
            NSMutableArray *arrSubTmp = [NSMutableArray array];
            NSString *detailsType = @"0";//0 没有push,1 继续支付
            
            for (NSArray *keys in arrListProperty) {
                NSString *flag = kSaftToNSString(keys[2]);
//                NSString *title = kSaftToNSString(keys[1]);
                NSString *title = kLocalized(kSaftToNSString(keys[1]));

                //订单号
                if ([flag isEqualToString:@"29"]) {//直接取返回的key
                    
                    [arrSubTmp addObject:@{@"title":title,
                                           @"value": kSaftToNSString(dicArrRes[keys[0]])
                                           }];
                    
                } else if ([flag isEqualToString:@"100"]) {//备注
                    CGSize size = [GYUtils sizeForString:kSaftToNSString(dicArrRes[keys[0]]) font:[UIFont systemFontOfSize:14.0] width:kScreenWidth - 70];
                    
                    [arrSubTmp addObject:@{@"title":title,
                                           @"value": kSaftToNSString(dicArrRes[keys[0]]),
                                           @"realHeight" : [NSNumber numberWithFloat:26 > (size.height+40) ? 26 : (size.height+40)]}];
                } else if ([flag isEqualToString:@"21"]) {//时间
                    title = arrLeftDropMenu[selectorLeft.selectedIndex];
                    
                    NSString* date = [GYUtils separatedStringByFlag:dicArrRes[keys[0]] flag:@" "];
                    [arrSubTmp addObject:@{@"title":title,
                                           @"value": date}];
                    
                    
                } else if ([flag isEqualToString:@"22"]) {//业务受理结果
                    NSInteger state = kSaftToDouble(dicArrRes[keys[0]]);
                    //订单状态('1-待付款', '2-待配货', '3-已完成', '4-已过期', '5-已关闭', '6-待确认'，’7-已撤单‘)
                    NSString *strVelue = @"";
                    switch (state) {
                        case 1:
                        {
                            strVelue = kLocalized(@"GYHS_BP_Wait_Pay");
                        }
                            break;
                            
                        case 2:
                        {
                            strVelue = kLocalized(@"GYHS_BP_In_Configuration");
                        }
                            break;
                            
                        case 3:
                        {
                            strVelue = kLocalized(@"GYHS_BP_Finished");
                        }
                            break;
                            
                        case 4:
                        {
                            strVelue = kLocalized(@"GYHS_BP_Expired");
                        }
                            break;
                            
                        case 5:
                        {
                            strVelue = kLocalized(@"GYHS_BP_Already_Shut");
                        }
                            break;
                            
                        case 6:
                        {
                            strVelue = kLocalized(@"GYHS_BP_Wait_Confirm");
                        }
                            break;
                        case 7:
                        {
                            strVelue = kLocalized(@"GYHS_BP_Already_Cancel_Lations");
                        }
                            break;
                            
                        default:
                            break;
                    }
                    [arrSubTmp addObject:@{@"title":title,
                                           @"value": strVelue}];
                    if (state == 1) {
                        detailsType = @"1";
                        [arrSubTmp addObject:@{@"title":kLocalized(@"GYHS_BP_Current_Operation"),
                                               @"value": kLocalized(@"GYHS_BP_Continue_Pay")}];
                    }
                    
                }
            }
         
            [self.arrQueryResult addObject:@{@"subRes":arrSubTmp,
                                             @"trade_sn": kSaftToNSString(dicArrRes[dicConf[@"trade_sn_key"]]),
                                             @"detailsType": detailsType,
                                             @"dicItem":dicArrRes,
                                             @"cellHeight":[NSNumber numberWithFloat:[self realheight:arrSubTmp]]}];
            
        }
        
        if (pageNo < totalPage) {
            hasNext = YES;
            pageNo++;
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
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}
- (CGFloat)realheight:(NSMutableArray*)arr
{
    int height = 0;
    for (int i = 0; i < arr.count; i++) {
        int myInt = [arr[i][@"realHeight"] intValue];
        height += myInt;
    }
    return height;
}
- (NSString*)getDateFlagString
{
    NSString* dateStr = @"month";

    if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_Today")]) {
        dateStr = @"today";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_In_Latest_Week")]) {
        dateStr = @"week";
    }
    else if ([self.arrRightDropMenu[selectorRight.selectedIndex] isEqualToString:kLocalized(@"GYHS_BP_Last_Month")]) {
        dateStr = @"month";
    }

    return dateStr;
}

- (NSString*)getLeftParams
{
    // 实名注册
    if (selectorLeft.selectedIndex == 0) {
        return REALNAME_REG;
    }
    // 实名认证
    else if (selectorLeft.selectedIndex == 1) {
        return REALNAME_AUTH;
    }
    // 重要信息变更
    else if (selectorLeft.selectedIndex == 2) {
        return MAININFO_CHANGE;
    }
    // 互生卡补办
    else if (selectorLeft.selectedIndex == kGYBusinessDetailViewVCMakeUpHSCard) {
        return HSCARD_APPLY;
    }
    // 互生卡挂失
    else if (selectorLeft.selectedIndex == 4) {
        return HSCARD_LOSS;
    }
    // 互生卡解挂
    else {
        return HSCARD_LOSS_END;
    }
}

- (void)queryBusinessStatus:(BOOL)append
{
    [self.arrQueryResult removeAllObjects];
    [self.tableView reloadData];
    NSString* queryType = [self getLeftParams];
    NSString* dateStr = [self getDateFlagString];
    NSDictionary* allParas = @{ @"custId" : kSaftToNSString(data.loginModel.custId),
        @"typeFlag" : queryType,
        @"dateFlag" : dateStr,
        @"curPage" : @1,
        @"pageSize" : @10 };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kperBusinessStatusUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        if (!append) {
            if (self.arrQueryResult && self.arrQueryResult.count > 0) {
                [self.arrQueryResult removeAllObjects];
                self.arrQueryResult = nil;
            }
            self.arrQueryResult = [NSMutableArray array];
        }
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [self showNoDatePage];
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;

        }
        NSDictionary *serverDic = responseObject[@"data"];
        if ([GYUtils checkDictionaryInvalid:serverDic]) {
            DDLogDebug(@"The serverDic:%@ is invalid.", serverDic);
            [self showNoDatePage];
            return;
        }
        
        if ([HSCARD_LOSS isEqualToString:queryType] || [HSCARD_LOSS_END isEqualToString:queryType]) {
            NSArray *serverArr =responseObject[@"data"][@"result"];
            for (NSDictionary *dict in serverArr) {
                NSMutableArray *tmpAry = [NSMutableArray array];
                
                for (NSArray *keys in arrListProperty) {
                    [self parseHSCardLost:tmpAry serverDic:dict keys:keys];
                    
                }
                
                [self.arrQueryResult addObject:@{@"subRes":tmpAry}];
            }
            
        }
        // 实名认证、重要信息变更
        else if ([REALNAME_AUTH isEqualToString:queryType] ||
                 [MAININFO_CHANGE isEqualToString:queryType]) {
            
            NSArray *resultAry = [serverDic valueForKey:@"result"];
            for (NSDictionary *indexDic in resultAry) {
                NSMutableArray *tmpAry = [NSMutableArray array];
                
                for (NSArray *keys in arrListProperty) {
                    [self parseRealNameAndMainInfoChange:tmpAry serverDic:indexDic keys:keys];
                }
                
                [self.arrQueryResult addObject:@{@"subRes":tmpAry}];
            }
        }
        if ([HSCARD_APPLY isEqualToString:queryType]) {
            // 补卡后续移过来
        }
        
        // 实名注册
        else if ([REALNAME_REG isEqualToString:queryType]) {
            NSMutableArray *tmpAry = [NSMutableArray array];
            
            for (NSArray *keys in arrListProperty) {
                [self parseRealNameReg:tmpAry serverDic:serverDic keys:keys];
            }
            
            [self.arrQueryResult addObject:@{@"subRes":tmpAry}];
        }
        
        BOOL hasNext = NO;
        NSInteger totalPage = kSaftToNSInteger(responseObject[@"totalPage"]);
        if (pageNo < totalPage) {
            hasNext = YES;
            pageNo++;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tableView.hidden = (self.arrQueryResult && self.arrQueryResult.count > 0 ? NO : YES);
            viewTipBkg.hidden = !self.tableView.hidden;
            
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (!hasNext) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
            }
        });

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)parseHSCardLost:(NSMutableArray*)resultAry
              serverDic:(NSDictionary*)serverDic
                   keys:(NSArray*)keys
{

    NSString* flag = kSaftToNSString(keys[2]);
    NSString* title = kLocalized(kSaftToNSString(keys[1]));
    //直接取返回的key
    if ([flag isEqualToString:@"29"]) {
        [resultAry addObject:@{ @"title" : title,
            @"value" : kSaftToNSString(serverDic[@"logId"]) }];
    }
    //显示条件名
    else if ([flag isEqualToString:@"20"]) {
        title = arrLeftDropMenu[selectorLeft.selectedIndex];
        NSString* date = [GYUtils separatedStringByFlag:serverDic[@"createDate"] flag:@" "];

        [resultAry addObject:@{ @"title" : title,
            @"value" : date }];
    }
    //显示受理结果
    else if ([flag isEqualToString:@"2"]) {

        NSString* strValue = kLocalized(@"GYHS_BP_Transfer_Successfully");

        [resultAry addObject:@{ @"title" : title,
            @"value" : strValue }];
    }
}

- (void)parseRealNameAndMainInfoChange:(NSMutableArray*)resultAry
                             serverDic:(NSDictionary*)serverDic
                                  keys:(NSArray*)keys
{
    NSString* flag = kSaftToNSString(keys[2]);
    NSString* title = kLocalized(kSaftToNSString(keys[1]));

    //显示条件名
    if ([flag isEqualToString:@"35"]) {
        title = arrLeftDropMenu[selectorLeft.selectedIndex];
        NSString* date = [GYUtils separatedStringByFlag:serverDic[keys[0]] flag:@" "];

        [resultAry addObject:@{ @"title" : title,
            @"value" : date }];
    }
    else if ([flag isEqualToString:@"36"]) {
        [resultAry addObject:@{ @"title" : title,
            @"value" : kSaftToNSString(serverDic[keys[0]]) }];
    }
    else if ([flag isEqualToString:@"37"]) {
        // bsResult 状态：0：待审批 1：待复核(审批通过) 2：复核通过 3：审批驳回 4：复核驳回
        NSInteger state = kSaftToNSInteger(serverDic[keys[0]]);
        NSString* strValue = kLocalized(@"GYHS_BP_Pending");
        if (state == 0) {
            strValue = kLocalized(@"GYHS_BP_Pending");
        }
        else if (state == 1) {
            strValue = kLocalized(@"GYHS_BP_To_Review");
        }
        else if (state == 2) {
            strValue = kLocalized(@"GYHS_BP_Review_By");
        }
        else if (state == 3) {
            strValue = kLocalized(@"GYHS_BP_Approval_Dismiss");
        }
        else if (state == 4) {
            strValue = kLocalized(@"GYHS_BP_Review_Rejected");
        }

        [resultAry addObject:@{ @"title" : title,
            @"value" : strValue }];
    }
    else if ([flag isEqualToString:@"38"]) {
        NSString* value = kSaftToNSString(serverDic[keys[0]]);
        [resultAry addObject:@{ @"title" : title,
            @"value" : value }];
    }
}

- (void)parseRealNameReg:(NSMutableArray*)resultAry
               serverDic:(NSDictionary*)serverDic
                    keys:(NSArray*)keys
{

    NSString* flag = kSaftToNSString(keys[2]);
    NSString* title = kLocalized(kSaftToNSString(keys[1]));

    //显示条件名
    if ([flag isEqualToString:@"30"]) {
        title = arrLeftDropMenu[selectorLeft.selectedIndex];

        NSString* date = [GYUtils separatedStringByFlag:serverDic[keys[0]] flag:@" "];
        [resultAry addObject:@{ @"title" : title,
            @"value" : date }];
    }
    else if ([flag isEqualToString:@"31"]) {
        [resultAry addObject:@{ @"title" : title,
            @"value" : kSaftToNSString(serverDic[keys[0]]) }];
    }
    else if ([flag isEqualToString:@"32"]) {
        // regStatus 状态：实名状态 1：未实名注册、2：已实名注册（有名字和身份证）、3:已实名认证
        NSInteger state = kSaftToNSInteger(serverDic[keys[0]]);
        NSString* strValue = kLocalized(@"GYHS_BP_Has_Real-name_Registration");
        if (state == 1) {
            strValue = kLocalized(@"GYHS_BP_Not_Real-name_Registration");
        }
        else {
            strValue = kLocalized(@"GYHS_BP_Has_Real-name_Registration");
        }

        [resultAry addObject:@{ @"title" : title,
            @"value" : strValue }];
    }
}

- (void)showNoDatePage
{
    self.tableView.hidden = YES;
    viewTipBkg.hidden = NO;
}

//语言国际化处理
- (NSArray*)internationalizationWithArray:(NSArray*)array
{

    if (array == nil || [GYUtils checkArrayInvalid:array]) {
        return nil;
    }
    NSMutableArray* result = [NSMutableArray array];
    for (NSString* str in array) {
        NSString* string = [[str componentsSeparatedByString:@","] firstObject];
        [result addObject:kLocalized(string)];
    }

    return result;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQueryResult.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* cellid = kCellViewDetailCellIdentifier;
    CellViewDetailCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath];
    if (!cell) {
        cell = [[CellViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.type = @"0";
    cell.accessoryType = UITableViewCellAccessoryNone;

    if (dicConf) {
        cell.rowValueHighlightedProperty = dicConf[@"list_value_highlighted_property"];
        cell.rowTitleHighlightedProperty = dicConf[@"list_title_highlighted_property"];
    }
    cell.arrDataSource = self.arrQueryResult[row][@"subRes"];
    NSInteger subRows = cell.arrDataSource.count;
    cell.cellSubCellRowHeight = kCellSubCellHeight;
    [cell.tableView setUserInteractionEnabled:NO];
    if (self.isShowBtnDetail) {
        CGFloat h;
        if (self.arrQueryResult[row][@"cellHeight"]) {
            h = [self.arrQueryResult[row][@"cellHeight"] integerValue] + kCellSubCellHeight * subRows;
        }
        else {
            h = kCellSubCellHeight * (subRows + 1);
        }
        cell.tableView.frame = CGRectMake(0, 5, kScreenWidth, h);
        [cell.labelShowDetails setFont:[UIFont systemFontOfSize:13]];
        cell.labelShowDetails.frame = CGRectMake(0,
            kCellSubCellHeight * subRows + 4,
            kScreenWidth,
            kCellSubCellHeight);
    }
    else {
        CGFloat h;
        if (self.arrQueryResult[row][@"cellHeight"]) {
            h = [self.arrQueryResult[row][@"cellHeight"] integerValue] + kCellSubCellHeight * (subRows - 1);
        }
        else {
            h = kCellSubCellHeight * (subRows);
        }
        cell.tableView.frame = CGRectMake(0, 5, kScreenWidth, h);
        if (cell.labelShowDetails.superview) {
            [cell.labelShowDetails removeFromSuperview];
            cell.labelShowDetails = nil;
        }
    }

    //表格嵌套，复用须 reloaddata，否则无法更新数据
    [cell.tableView reloadData];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (selectorLeft.selectedIndex == kGYBusinessDetailViewVCMakeUpHSCard) {
        return kCellSubCellHeight * ([self.arrQueryResult[indexPath.row][@"subRes"] count] - 1 + (self.isShowBtnDetail ? 1 : 0)) + 10 + [self.arrQueryResult[indexPath.row][@"cellHeight"] integerValue];
    }
    else {
        return kCellSubCellHeight * ([self.arrQueryResult[indexPath.row][@"subRes"] count] + (self.isShowBtnDetail ? 1 : 0)) + 8;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    if ([arrQueryResult[row][@"detailsType"] isEqualToString:@"1"]) {
        GYPaymentConfirmViewController* vc = [[GYPaymentConfirmViewController alloc] init];
        vc.paymentMode = GYPaymentModeWithReApplyCard;
        NSDictionary* dic = arrQueryResult[row][@"dicItem"];
        vc.orderNO = kSaftToNSString(dic[@"orderNo"]);
        vc.orderMoney = kSaftToNSString(dic[@"orderCashAmount"]);
        vc.realMoney = kSaftToNSString(dic[@"orderCashAmount"]);
        vc.navigationItem.title = @"支付";
        [self.navigationController pushViewController:vc animated:YES];
    }
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
        if (isChange) {//只有选择不同的条件才执行操作
            lbLabelSelectRight.text = arrRightDropMenu[selectorRight.selectedIndex];
        }
        [self selectorRightClick:nil];
    }
    if (isChange) {
        [self queryWithLeftMenuIndex:selectorLeft.selectedIndex rightMenuIndex:selectorRight.selectedIndex];
    }
}

- (NSString *)getDateRangeFromTodayWithDays:(NSInteger)daysAgo {
    NSString *dateFormat = @"yyyy-MM-dd";
    if (daysAgo < 0) {//全部
        return [NSString stringWithFormat:@"%@~%@", @"0000-00-00", [GYUtils dateToString:[NSDate date] dateFormat:dateFormat]];
    }

    NSDate *today = [NSDate date];
    NSString *strToday = [GYUtils dateToString:today dateFormat:dateFormat];
    if (daysAgo == 0) {//今天
        return [NSString stringWithFormat:@"%@~%@", strToday, strToday];
    }

    //以下按天数
    NSDate *oldDays = [NSDate dateWithTimeIntervalSinceNow:-24.0f * 60 * 60 * daysAgo];
    NSString *strOldDays = [GYUtils dateToString:oldDays dateFormat:dateFormat];
    return [NSString stringWithFormat:@"%@~%@", strOldDays, strToday];
}

@end
