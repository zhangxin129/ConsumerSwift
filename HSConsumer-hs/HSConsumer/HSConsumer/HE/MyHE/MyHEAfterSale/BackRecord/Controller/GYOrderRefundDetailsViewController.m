//
//  GYOrderRefundDetailsViewController.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kCellDatetimeHeight 40.f
#import "Masonry.h"
#import "GYOrderRefundDetailsViewController.h"
#import "ViewForRefundDetailsLeft.h"
#import "ViewForRefundDetailsRight.h"
#import "GYGIFHUD.h"
#import "NSString+YYAdd.h"
#import "UIView+Extension.h"
#import "GYComplaintViewController.h"

@interface GYOrderRefundDetailsViewController () <UITableViewDelegate, UITableViewDataSource, ViewForRefundDetailsRightDelegate, GYNetRequestDelegate>

@property (weak, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* arrResult;
@property (assign, nonatomic) BOOL isCardUser;
@property (strong, nonatomic) GYHSUserData* user;
@property (nonatomic, copy) NSString* refId;
@property (nonatomic, weak) ViewForRefundDetailsLeft* instrouction;
@property (nonatomic, weak) ViewForRefundDetailsRight* detailsRight;
@property (nonatomic, copy) NSString* appealStatus;

@end

@implementation GYOrderRefundDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
    [self getDetails];
}

- (void)setTableView
{
    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = kDefaultVCBackgroundColor;
    //初始化设置tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView.tableHeaderView setHidden:YES];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.arrResult = [NSMutableArray array];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrResult.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    static NSString* cellID = @"cell";
    NSString* userNickName = self.arrResult[row][0];
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    UIView* view = nil;
    UILabel* lbNickName = nil;
    CGRect rect = cell.bounds;
    CGFloat labelH = kCellDatetimeHeight;
    CGFloat fontSize = 12.f;
    switch (row) {
    case 0: {
        ViewForRefundDetailsLeft* v = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewForRefundDetailsLeft class]) owner:self options:nil] objectAtIndex:0];
        rect = cell.bounds;
        self.instrouction = v;
        v.frame = rect;
        rect.origin.y = labelH + 10;
        NSString* str = self.arrResult[indexPath.row][6];
        NSString* strNumber = self.arrResult[row][2];
        if ([strNumber isEqualToString:@"3"]) {
            rect.size.height = 35 + kCellDatetimeHeight + [str heightForFont:[UIFont systemFontOfSize:13] width:90];
        }
        else {
            rect.size.height = 75 + kCellDatetimeHeight + [str heightForFont:[UIFont systemFontOfSize:13] width:90];
        }
        [v setValues:self.arrResult[row]];
        view = v;
        CGFloat width = cell.frame.size.width * 2 / 3;
        CGFloat height = rect.size.height;
        [cell.contentView addSubview:v];
        [v mas_makeConstraints:^(MASConstraintMaker* make) {
                make.left.equalTo(cell.contentView).with.offset(10);
                make.top.equalTo(cell.contentView).with.offset(50);
                make.width.mas_equalTo(@(width-10));
                make.height.mas_equalTo(@(height));
        }];
        lbNickName = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 160, labelH)];
        [lbNickName setTextAlignment:NSTextAlignmentLeft];
        [lbNickName setFont:[UIFont systemFontOfSize:fontSize]];
        [lbNickName setText:[NSString stringWithFormat:kLocalized(@"GYHE_MyHE_Buyser:%@"), userNickName]];
        [lbNickName setTintColor:[UIColor lightGrayColor]];
    } break;
    default: {
        NSArray* subviewArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewForRefundDetailsRight class]) owner:self options:nil];
        ViewForRefundDetailsRight* v = [subviewArray objectAtIndex:0];
        self.detailsRight = v;
        v.delegate = self;
        rect = v.frame;
        rect.origin.x = cell.frame.size.width - rect.size.width;
        rect.origin.y = labelH + 10;
        v.frame = rect;
        CGFloat width = cell.frame.size.width * 2 / 3;
        [cell.contentView addSubview:v];
        [v setValues:self.arrResult[row]];
        if (row == 1) {
            NSString* str = self.arrResult[row][3];
            if ([str isEqualToString:@"1"]) { //拒绝
                if ([self.appealStatus isEqualToString:@"1"]) {
                    v.complaintBtn.hidden = YES;
                }
                else {
                    v.complaintBtn.hidden = NO;
                }
                [v mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.right.equalTo(cell.contentView).with.offset(-10);
                    make.top.equalTo(cell.contentView).with.offset(50);
                    make.width.mas_equalTo(@(width - 10));
                    make.height.mas_equalTo(@(95));
                }];
            }
            else { //同意
                [v mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.right.equalTo(cell.contentView).with.offset(-10);
                    make.top.equalTo(cell.contentView).with.offset(50);
                    make.width.mas_equalTo(@(width - 10));
                    make.height.mas_equalTo(@(70));
                }];
            }
        }
        else if (row == 2) {
            NSString* str = self.arrResult[row][2];
            if ([str isEqualToString:@"3"]) { //换货
                [v mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.right.equalTo(cell.contentView).with.offset(-10);
                    make.top.equalTo(cell.contentView).with.offset(50);
                    make.width.mas_equalTo(@(width - 10));
                    make.height.mas_equalTo(@(75));
                }];
            }
            else { //非换货
                [v mas_makeConstraints:^(MASConstraintMaker* make) {
                    make.right.equalTo(cell.contentView).with.offset(-10);
                    make.top.equalTo(cell.contentView).with.offset(50);
                    make.width.mas_equalTo(@(width - 10));
                    make.height.mas_equalTo(@(115));
                }];
            }
        }
        if (row == 1) {
            [v setShowTypeIsResult:NO];
        }
        else if (row == 2) {
            [v setShowTypeIsResult:YES];
        }
        view = v;
        rect = cell.bounds;
        rect.size.height = labelH;
        rect.size.width = 180.f;
        rect.origin.x = kScreenWidth - rect.size.width - 20.0f;
        rect.origin.y += 20;
        lbNickName = [[UILabel alloc] initWithFrame:rect];
        [lbNickName setTextAlignment:NSTextAlignmentRight];
        [lbNickName setFont:[UIFont systemFontOfSize:fontSize]];
        [lbNickName setText:userNickName];
    } break;
    }
    [cell.contentView addSubview:view];
    rect = cell.bounds;
    rect.size.height = labelH;
    UILabel* dataTime = [[UILabel alloc] initWithFrame:rect];
    dataTime.centerX = kScreenWidth * 0.5;
    [dataTime setTextAlignment:NSTextAlignmentCenter];
    [dataTime setText:self.arrResult[row][1]];
    [dataTime setFont:[UIFont systemFontOfSize:fontSize]];
    [dataTime setBackgroundColor:kClearColor]; //ios6
    [lbNickName setBackgroundColor:kClearColor];
    [cell.contentView addSubview:dataTime];
    [cell.contentView addSubview:lbNickName];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:kDefaultVCBackgroundColor];
    [dataTime setTextColor:[UIColor lightGrayColor]];
    [lbNickName setTextColor:[UIColor lightGrayColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    if (row == 0) {
        NSString* str = self.arrResult[indexPath.row][6];
        NSString* strNumber = self.arrResult[row][2];
        CGFloat height;
        if ([strNumber isEqualToString:@"3"]) {
            height = 10 + self.instrouction.instructionReasonLab.frame.origin.y + kCellDatetimeHeight + [str heightForFont:[UIFont systemFontOfSize:13] width:90];
        }
        else {
            height = 60 + self.instrouction.instructionReasonLab.frame.origin.y + kCellDatetimeHeight + [str heightForFont:[UIFont systemFontOfSize:13] width:90];
        }
        //兼容4、4s适配
        if (kScreenHeight < 481 && [[UIDevice currentDevice].systemVersion doubleValue] < 8.0) {
            return height + 60;
        }
        else {
            return height;
        }
    }
    else if (row == 1) {
        return 85 + kCellDatetimeHeight;
    }
    else if (row == 2) {
        return 109 + kCellDatetimeHeight + 30; //30用于让最后一个cell离底边保持高度
    }
    return 140 + kCellDatetimeHeight;
}

#pragma - get details
- (void)getDetails
{
    if (!_orderID)
        return;
    GlobalData* data = globalData;
    self.isCardUser = data.loginModel.cardHolder;
    self.user = data.user;
    NSDictionary* allParas = @{ @"key" : data.loginModel.token,
        @"refId" : _orderID };
    [GYGIFHUD show];
    GYNetRequest* requst = [[GYNetRequest alloc] initWithDelegate:self URLString:EasyBuyGetRefundInfoUrl parameters:allParas requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP];
    [requst start];
}

#pragma mark - GYNetRequestDelegate
- (void)netRequest:(GYNetRequest*)request didSuccessWithData:(NSDictionary*)responseObject
{
    [GYGIFHUD dismiss];
    NSDictionary* dic = responseObject;
    if (kSaftToNSInteger(dic[@"retCode"]) == kEasyPurchaseRequestSucceedCode) { //返回成功数据
        dic = dic[@"data"];
        NSArray* arr0 = @[ kSaftToNSString(dic[@"nickName"]), //顺序不可变
            [kSaftToNSString(dic[@"createTime"]) substringToIndex:16], //顺序不可变
            kSaftToNSString(dic[@"refundType"]),
            kSaftToNSString(dic[@"goodsStatus"]),
            kSaftToNSString(dic[@"price"]),
            kSaftToNSString(dic[@"point"]),
            kSaftToNSString(dic[@"reasonDesc"]) ];
        self.refId = kSaftToNSString(dic[@"refundId"]);
        [self.arrResult addObject:arr0];
        if (dic[@"confirmResult"] && kSaftToNSInteger(dic[@"confirmResult"]) != 0) {
            NSString* confirmDateString = @""; //截图确认时间的前16位，防止传回时间为空
            if ([kSaftToNSString(dic[@"confirmDate"]) isEqualToString:@""]) {
                confirmDateString = @"";
            }
            else {
                confirmDateString = [kSaftToNSString(dic[@"confirmDate"]) substringToIndex:16];
            }
            NSArray* arr1 = @[ kSaftToNSString(dic[@"refunder"]), //顺序不可变
                confirmDateString, //顺序不可变
                kSaftToNSString(dic[@"refundType"]),
                kSaftToNSString(dic[@"confirmResult"]), //商家确认结果，1 不退款，其它退款
                kSaftToNSString(dic[@"confirmDesc"]) ];
            [self.arrResult addObject:arr1];
        }
        if ([kSaftToNSString(dic[@"refundResult"]) isEqualToString:@"6"] ||
            [kSaftToNSString(dic[@"refundResult"]) isEqualToString:@"7"]) {
            NSString* refundDateString = @"";
            if ([kSaftToNSString(dic[@"confirmDate"]) isEqualToString:@""]) {
                refundDateString = @"";
            }
            else {
                refundDateString = [kSaftToNSString(dic[@"confirmDate"]) substringToIndex:16];
            }
            NSArray* arr2 = @[ kSaftToNSString(dic[@"refunder"]), //顺序不可变 index:0
                refundDateString, //顺序不可变 index:1
                kSaftToNSString(dic[@"refundType"]), //index:2
                kSaftToNSString(dic[@"refundResult"]), //商家确认结果，1 不退款，其它退款 //index:3
                kSaftToNSString(dic[@"price"]), //index:4
                kSaftToNSString(dic[@"point"]), //index:5
                kSaftToNSString(dic[@"refundDesc"]), //index:6
                kSaftToNSString(dic[@"refundId"]) //index:7
            ];
            [self.arrResult addObject:arr2];
        }
        self.appealStatus = dic[@"appealStatus"];
        [self.tableView reloadData];
    }
    else { //返回失败数据
        [GYUtils showMessage:kLocalized(@"GYHE_MyHE_QueryRefundDetailFail")];
    }
}

#pragma mark - failDelegate
-(void)netRequest:(GYNetRequest *)request didFailureWithError:(NSError *)error {
    
    [GYGIFHUD dismiss];
    [GYUtils parseNetWork:error resultBlock:nil];
}


#pragma mark ViewForRefundDetailsRightDelegate
- (void)complaintBtnClickDelegate
{
    GYComplaintViewController* vc = [[GYComplaintViewController alloc] init];
    vc.title = kLocalized(@"GYHE_MyHE_Complaint");
    vc.orderId = self.myOrderId;
    vc.refId = self.refId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
