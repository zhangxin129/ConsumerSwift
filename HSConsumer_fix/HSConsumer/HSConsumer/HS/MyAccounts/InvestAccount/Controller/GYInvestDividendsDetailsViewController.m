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
#define kCellSubCellHeight 18.f

#import "GYInvestDividendsDetailsViewController.h"
#import "CellViewDetailCell.h"
#import "CellDetailRow.h"

@interface GYInvestDividendsDetailsViewController () <UITableViewDataSource,
    UITableViewDelegate> {
    GlobalData* data; //全局单例

    IBOutlet UIView* viewHBkg;
    IBOutlet UILabel* lblHrow0;
    IBOutlet UILabel* lbHrow0;
    IBOutlet UILabel* lblHrow1;
    IBOutlet UILabel* lbHrow1;
    IBOutlet UILabel* lblHrow2;
    IBOutlet UILabel* lbHrow2;
    IBOutlet UILabel* lblHrow3;
    IBOutlet UILabel* lbHrow3;

    //    NSDictionary *dicConf;          //取得明细的配置文件对应模块
    NSDictionary* dicTransCodes; //交易类型字典
    NSArray* arrListProperty; //取得列表的属性文件
}

@property (strong, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSArray* arrLeftDropMenu;
@property (nonatomic, strong) NSArray* arrRightDropMenu;
@property (nonatomic, strong) NSMutableArray* arrQueryResult;

@end

@implementation GYInvestDividendsDetailsViewController
@synthesize arrLeftDropMenu, arrRightDropMenu, arrQueryResult, dicConf;

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isShowBtnDetail = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //实例化单例
    data = globalData;
    [viewHBkg addTopBorderAndBottomBorder];
    [viewHBkg setBackgroundColor:kCorlorFromRGBA(255, 252, 211, 1)];
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    [lblHrow0 setTextColor:kCellItemTitleColor];
    [lblHrow1 setTextColor:kCellItemTitleColor];
    [lblHrow2 setTextColor:kCellItemTitleColor];
    [lblHrow3 setTextColor:kCellItemTitleColor];

    [lbHrow0 setTextColor:kValueRedCorlor];
    [lbHrow1 setTextColor:kValueRedCorlor];
    [lbHrow2 setTextColor:kValueRedCorlor];
    [lbHrow3 setTextColor:kValueRedCorlor];

    [lblHrow0 setText:kLocalized(@"GYHS_MyAccounts_dividend_details_invest_integral_total")];
    [lblHrow1 setText:kLocalized(@"GYHS_MyAccounts_dividend_details_invest_dividends_total")];
    [lblHrow2 setText:kLocalized(@"GYHS_MyAccounts_dividend_details_invest_dividend_cycle")];
    [lblHrow3 setText:kLocalized(@"GYHS_MyAccounts_dividend_details_invest_radio")];

    [GYUtils setFontSizeToFitWidthWithLabel:lblHrow0 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lblHrow1 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lblHrow2 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lblHrow3 labelLines:1];

    [GYUtils setFontSizeToFitWidthWithLabel:lbHrow0 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lbHrow1 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lbHrow2 labelLines:1];
    [GYUtils setFontSizeToFitWidthWithLabel:lbHrow3 labelLines:1];

    //设置菜单中分隔线颜色

    [self.tableView registerClass:[CellViewDetailCell class] forCellReuseIdentifier:kCellViewDetailCellIdentifier];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 16, 0, 16)];

    //    [self.tableView setBackgroundView:nil];
    //    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //    self.tableView.hidden = YES;

    if (dicConf) {
        //        NSString* dicKey = [@"conf_" stringByAppendingString:[@(self.detailsCode) stringValue]];
        //        NSDictionary *configDic = [[GYHSLoginManager shareInstance] dicHsConfig];
        //        dicConf = configDic[dicKey];
        //        DDLogInfo(@"明细的配置字典dicConf(key:%@): %@", dicKey, [GYUtils dictionaryToString:dicConf]);

//        self.arrLeftDropMenu = dicConf[@"list_left_menu"];
//        self.arrRightDropMenu = dicConf[@"list_rigth_menu"];
        
        self.arrLeftDropMenu = [self internationalizationWithArray:dicConf[@"list_left_menu"]];
        self.arrRightDropMenu = [self internationalizationWithArray:dicConf[@"list_rigth_menu"]];
        arrListProperty = dicConf[@"list_property"];
        dicTransCodes = dicConf[@"trans_code_list"];
    }
    else {
        [self.tableView setHidden:YES];

        WS(weakSelf)
            [GYUtils showMessage:kLocalized(@"GYHS_MyAccounts_could_find_detail_list_setFile") confirm:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        return;
    }

    if (!self.arrQueryResult)
        self.arrQueryResult = [NSMutableArray array];

    [self get_invest_dividends_detail];
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

#warning 孙秋明注释 此控制器是否有用  张鑫与曾小明交接
- (void)get_invest_dividends_detail
{

    NSDictionary* allParas = @{ @"hsResNo" : kSaftToNSString(globalData.loginModel.resNo),
        @"dividendYear" : kSaftToNSString(self.dividendYear),
        @"curPage" : @"1",
    };

    [GYGIFHUD show];
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kInvestAccountInvestDividendsDetailUrlString parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary* responseObject, NSError* error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject;
        dic = dic[@"data"];
        lbHrow0.text = [GYUtils formatCurrencyStyle:kSaftToDouble(dic[@"dividInfo"][@"accumulativeInvestCount"])];
        lbHrow1.text = [GYUtils formatCurrencyStyle:kSaftToDouble(dic[@"dividInfo"][@"totalDividend"])];
        lbHrow2.text = kSaftToNSString(dic[@"dividInfo"][@"dividendYear"]);
        double radio = kSaftToDouble(dic[@"dividInfo"][@"yearDividendRate"]) * 100;
        lbHrow3.text = [NSString stringWithFormat:@"%d%%", (int)radio];
        
        //                  self.arrQueryResult = dic[@"data"];
        
        NSMutableArray *arrRes = [NSMutableArray array];
        arrRes = dic[@"dividList"][@"result"];
        for (NSDictionary *dicArrRes in arrRes) {
            NSMutableArray *arrSubTmp = [NSMutableArray array];
            for (NSArray *keys in arrListProperty) {
                NSString *flag = kSaftToNSString(keys[2]);
                NSString *title = kSaftToNSString(keys[1]);
                if ([flag isEqualToString:@"0"]) {//直接取返回的key
                    [arrSubTmp addObject:@{@"title":title,
                                           @"value":kSaftToNSString(dicArrRes[keys[0]])}];
                    
                } else if ([flag isEqualToString:@"25"]) {
                    
                    [arrSubTmp addObject:@{@"title":title, }];
                    
                }
                
            }
            if (arrSubTmp.count > 0) {
                [self.arrQueryResult addObject:@{@"subRes":arrSubTmp}];
            }
        }
        
        CGRect noMoreFrame = [self.tableView bounds];
        noMoreFrame.size.height = 34.f;
        UILabel *lbShowInfo = [[UILabel alloc] initWithFrame:noMoreFrame];
        [lbShowInfo setBackgroundColor:self.view.backgroundColor];
        [lbShowInfo setFont:[UIFont systemFontOfSize:12.f]];
        [lbShowInfo setText:@"没有更多了..."];
        [lbShowInfo setTextColor:kCellItemTextColor];
        [lbShowInfo setTextAlignment:NSTextAlignmentCenter];
        self.tableView.tableFooterView = lbShowInfo;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.arrQueryResult isKindOfClass:[NSNull class]]) {
                self.arrQueryResult = nil;
            }
            
            self.tableView.hidden = (self.arrQueryResult && self.arrQueryResult.count > 0 ? NO : YES);
            [self.tableView reloadData];
            
            [GYGIFHUD dismiss];
        });
    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
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

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrQueryResult.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* cellid = kCellViewDetailCellIdentifier;
    CellViewDetailCell* cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath]; //使用此方法加载，必须先注册nib或class
    if (!cell) {
        cell = [[CellViewDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        //        DDLogDebug(@"init load detail:%d", (int)row);
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];

    //    NSMutableArray *sortArr = [self sortByIndex:self.arrQueryResult[row]];
    //    cell.arrDataSource = sortArr;
    if (dicConf) { //高亮配置
        cell.rowValueHighlightedProperty = dicConf[@"list_value_highlighted_property"];
        cell.rowTitleHighlightedProperty = dicConf[@"list_title_highlighted_property"];
    }
    cell.arrDataSource = self.arrQueryResult[row][@"subRes"];

    NSInteger subRows = cell.arrDataSource.count;
    cell.cellSubCellRowHeight = kCellSubCellHeight;
    [cell.tableView setUserInteractionEnabled:NO];
    if (self.isShowBtnDetail) {
        cell.tableView.frame = CGRectMake(0, 5, kScreenWidth, kCellSubCellHeight * (subRows + 1));
        //        [cell.btnButton setUserInteractionEnabled:NO];
        [cell.labelShowDetails setFont:[UIFont systemFontOfSize:13]];
        cell.labelShowDetails.frame = CGRectMake(0,
            kCellSubCellHeight * subRows + 4,
            kScreenWidth,
            kCellSubCellHeight);
    }
    else {
        cell.tableView.frame = CGRectMake(0, 5, kScreenWidth, kCellSubCellHeight * subRows);
        if (cell.labelShowDetails.superview) {
            [cell.labelShowDetails removeFromSuperview];
            cell.labelShowDetails = nil;
        }
    }

    [cell.tableView reloadData]; //表格嵌套，复用须 reloaddata，否则无法更新数据

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CGFloat h = kCellSubCellHeight * ([self.arrQueryResult[indexPath.row][@"subRes"] count] + (self.isShowBtnDetail ? 1 : 0)) + 10;
    return h;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
