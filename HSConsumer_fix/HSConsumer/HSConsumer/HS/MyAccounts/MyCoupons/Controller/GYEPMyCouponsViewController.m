//
//  GYEPMyOrderViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-23.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kPageSize 10

#import "GYEPMyCouponsViewController.h"

#import "CellForMyCouponsCell.h"
#import "ViewTipBkgView.h"
#import "DiscountModel.h"

#import "GYGIFHUD.h"
@interface GYEPMyCouponsViewController () <UITableViewDataSource, UITableViewDelegate> {
    ViewTipBkgView* viewTipBkg;
    NSArray* arrLabelTexts;
    int pageSize; //每次/每页获取多少行记录
    int pageNo; //下一页
}
@end

@implementation GYEPMyCouponsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _firstTipsErr = NO;
    _startPageNo = 1;

    pageSize = kPageSize;
    pageNo = _startPageNo;

    if (self.navigationController) //用于传下一界面
        self.nav = self.navigationController;

    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    viewTipBkg = [[ViewTipBkgView alloc] init];
    [viewTipBkg setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    // add by songjk
    if ([globalData.loginModel.isRealnameAuth isEqualToString:@"1"]) { //没有实名注册的
        [viewTipBkg.lbTip setText:kLocalized(@"GYHS_MyAccounts_real_name_register_successful_enjoy_5000_Deduction_securities")];
        viewTipBkg.hidden = NO;
        [self.view addSubview:viewTipBkg];
        self.tableView.hidden = YES;
        return;
    }
    if (self.couponsType == kCouponsTypeUnUse) {
        [viewTipBkg.lbTip setText:kLocalized(@"GYHS_MyAccounts_no_ar_send_ticket_good")];
    }
    else {
        [viewTipBkg.lbTip setText:kLocalized(@"GYHS_MyAccounts_no_already_use_ar_send_ticket_good")];
    }
    [self.view addSubview:viewTipBkg];
    //viewTipBkg.hidden = YES;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellForMyCouponsCell class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellForMyCouponsCellIdentifier];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;

    arrLabelTexts = @[ kLocalized(@"GYHS_MyAccounts_face_value"),
        kLocalized(@"GYHS_MyAccounts_can_use_amount"),
        kLocalized(@"GYHS_MyAccounts_already_use_amount"),
        kLocalized(@"GYHS_MyAccounts_valid_date") ];
    if (self.couponsType == kCouponsTypeUsed) {
        arrLabelTexts = @[ kLocalized(@"GYHS_MyAccounts_face_value"),
            kLocalized(@"GYHS_MyAccounts_use_amount"),
            kLocalized(@"GYHS_MyAccounts_use_time"),
            kLocalized(@"GYHS_MyAccounts_order_num") ];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];

    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{

        [self footerRereshing];

    }];

    self.tableView.mj_footer = footer;

    [self getMyOrderlistIsAppendResult:NO andShowHUD:YES];

    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{

        //        请求数据
        [self headerRereshing];

    }];

    //单例 调用刷新图片

    self.tableView.mj_header = header;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrResult.count == 0) {
        self.tableView.mj_footer.hidden = YES;
    }
    else {
        self.tableView.mj_footer.hidden = NO;
    }
    return [self.arrResult count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* cellid = kCellForMyCouponsCellIdentifier;
    CellForMyCouponsCell* cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:cellid forIndexPath:indexPath]; //使用此方法加载，必须先注册nib或class
    if (!cell) {
        cell = [[CellForMyCouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.lbRow1L.text = arrLabelTexts[0];
    cell.lbRow2L.text = arrLabelTexts[1];
    cell.lbRow3L.text = arrLabelTexts[2];
    cell.lbRow4L.text = arrLabelTexts[3];

    DiscountModel* model = self.arrResult[row];
    cell.lbRow0.text = model.couponName;
    cell.lbRow1R.text = [GYUtils formatCurrencyStyle:[model.faceValue doubleValue]];
    if (self.couponsType == kCouponsTypeUnUse) {
        cell.lbRow2R.text = model.surplusNum;
        cell.lbRow3R.text = model.usedNumber;
        NSDate* cdate = [NSDate dateWithTimeIntervalSince1970:[model.expEnd longLongValue] / 1000];
        NSString* exEndTime = [GYUtils dateToString:cdate dateFormat:@"yyyy-MM-dd"];
        if ([exEndTime hasPrefix:@"1970"]) {
            exEndTime = kLocalized(@"GYHS_MyAccounts_long_time");
        }
        cell.lbRow4R.text = exEndTime;
    }
    else if (self.couponsType == kCouponsTypeUsed) {
        cell.lbRow2R.text = model.surplusNum;
        NSDate* cdate = [NSDate dateWithTimeIntervalSince1970:[model.couponUseTime longLongValue] / 1000];
        cell.lbRow3R.text = [GYUtils dateToString:cdate];
        cell.lbRow4R.text = model.orderNo;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [CellForMyCouponsCell getHeight];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - pushVC
- (void)pushVC:(id)vc animated:(BOOL)ani
{
    if (self.nav) {

        [self.nav pushViewController:vc animated:ani];
    }
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{

    pageNo = _startPageNo;
    [self.tableView.mj_footer resetNoMoreData];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self getMyOrderlistIsAppendResult:NO andShowHUD:NO];
    });
}

- (void)getMyOrderlistIsAppendResult:(BOOL)append andShowHUD:(BOOL)isShow
{

    NSString* sUrl;
    [self.tableView reloadData];
    if (self.couponsType == kCouponsTypeUsed) {
        sUrl = EasyBuyGetUsedVoucherUrl; //已使用
    }
    else {
        sUrl = EasyBuyGetMyVoucherUrl; //未使用
    }
    NSMutableDictionary* allParas = [@{ @"key" : globalData.loginModel.token,
        @"count" : [@(pageSize) stringValue],
        @"currentPage" : [@(pageNo) stringValue] } mutableCopy];
    if (isShow) {

        [GYGIFHUD show];
    }
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:sUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (!append) {
            if (self.arrResult && self.arrResult.count > 0) {
                [self.arrResult removeAllObjects];
                self.arrResult = nil;
            }
            self.arrResult = [NSMutableArray array];
        }
        
        BOOL hasNext = NO;
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSDictionary *dic = responseObject;
        NSInteger totalPage = kSaftToNSInteger(dic[@"totalPage"]);
        NSMutableArray *marrValue = [NSMutableArray array];
        if (dic[@"data"] && [dic[@"data"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dicTmp in dic[@"data"]) {
                if (![dicTmp isKindOfClass:[NSDictionary class]]) {
                    continue;
                }
                DiscountModel *model = [[DiscountModel alloc] init];
                model.couponName = kSaftToNSString(dicTmp[@"couponName"]);
                model.faceValue = kSaftToNSString(dicTmp[@"faceValue"]);
                
                if (self.couponsType == kCouponsTypeUnUse) {
                    model.surplusNum = kSaftToNSString(dicTmp[@"surplusNumber"]);
                    model.usedNumber = kSaftToNSString(dicTmp[@"usedNumber"]);
                    model.expEnd = kSaftToNSString(dicTmp[@"expEnd"]);
                    
                } else if (self.couponsType == kCouponsTypeUsed) {
                    model.surplusNum = kSaftToNSString(dicTmp[@"number"]);
                    model.couponUseTime = kSaftToNSString(dicTmp[@"couponUseTime"]);
                    model.orderNo = kSaftToNSString(dicTmp[@"orderNo"]);
                }
                [marrValue addObject:model];
            }
            
            [self.arrResult addObjectsFromArray:marrValue];
            
        } else {
            [self.arrResult addObjectsFromArray:marrValue];
        }
        pageNo++;
        if (pageNo <= totalPage) {
            hasNext = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.firstTipsErr = YES;
            
            if ([self.arrResult isKindOfClass:[NSNull class]]) {
                self.arrResult = nil;
            }
            
            self.tableView.hidden = (self.arrResult && self.arrResult.count > 0 ? NO : YES);
            viewTipBkg.hidden = !self.tableView.hidden;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if (!hasNext) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
            }
            [GYGIFHUD dismiss];
        });

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
}

- (void)footerRereshing {
    [self getMyOrderlistIsAppendResult:YES andShowHUD:NO];
}

@end
