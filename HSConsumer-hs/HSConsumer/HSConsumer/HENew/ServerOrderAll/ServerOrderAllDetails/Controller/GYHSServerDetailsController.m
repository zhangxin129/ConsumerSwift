//
//  GYHSServerDetailsController.m
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSServerDetailsController.h"
#import "GYHSServerDetailSectionHeader.h"
#import "GYHSServerDetailSectionFooter.h"
#import "GYHSServerDetailsCell.h"
#import "GYHSServerTimeCell.h"
#import "GYHSServerAddressCell.h"
#import "GYHSServerDetailFooter.h"
#import "GYHSServerDetailAllModel.h"

#define kGYHSServerDetailsCellReuseId @"GYHSServerDetailsCell"
#define kGYHSServerTimeCellReuseId @"GYHSServerTimeCell"
#define kGYHSServerAddressCellReuseId @"GYHSServerAddressCell"

@interface GYHSServerDetailsController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GYHSServerDetailSectionHeader* serverDetailsSectionHeader;
@property (nonatomic, strong) GYHSServerDetailSectionFooter* serverDetailsSectionFooter;
@property (nonatomic, strong) GYHSServerDetailFooter* serverDetailFooter;
@property (nonatomic, strong) GYHSServerDetailAllModel* model;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* cellIds;

@end

@implementation GYHSServerDetailsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cellIds = @[ kGYHSServerTimeCellReuseId,
        kGYHSServerAddressCellReuseId,
        kGYHSServerDetailsCellReuseId ];
    [self.view addSubview:self.tableView];
    self.title = kLocalized(@"订单详情");
    self.view.backgroundColor = [UIColor whiteColor];
    self.serverDetailsSectionHeader = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSServerDetailSectionHeader class]) owner:self options:nil] firstObject];
    [self.serverDetailsSectionHeader setValue:self.model forKey:@"model"];
    [self.serverDetailsSectionHeader setValue:self forKey:@"delegate"];
    self.serverDetailsSectionFooter = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSServerDetailSectionFooter class]) owner:self options:nil] firstObject];
    [self.serverDetailsSectionFooter setValue:self.model forKey:@"model"];
    // 底部按钮
    GYHSServerDetailFooter* footer = [[GYHSServerDetailFooter alloc] initWithFrame:CGRectMake(0, kScreenHeight - 41 - 64 - 49, kScreenWidth, 41)];
    [self.view addSubview:footer];
    self.serverDetailFooter = footer;
    [self.serverDetailFooter setValue:self.model forKey:@"model"];
    [self.serverDetailFooter setValue:self forKey:@"delegate"];
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 进入商铺
- (void)didSelectedIntoShopBtn:(GYHSServerDetailSectionHeader*)header
{
    NSLog(@"点击了商铺");
}
#pragma mark -联系客服
- (void)didSelectedContactBtn:(GYHSServerDetailSectionHeader*)header
{
    NSLog(@"点击了联系客服");
}
#pragma mark--售后申请
- (void)afterSaleBtn:(GYHSServerDetailFooter*)footer
{
    NSLog(@"申请售后");
}

#pragma mark--退款申请
- (void)requestBackPayBtn:(GYHSServerDetailFooter*)footer
{
    NSLog(@"退款申请");
}

#pragma mark--查看物流
- (void)lookLogisterBtn:(GYHSServerDetailFooter*)footer
{
    NSLog(@"查看物流");
}

#pragma mark--再订
- (void)buyAgainBtn:(GYHSServerDetailFooter*)footer
{
    NSLog(@"再订");
}

#pragma mark--请求网络数据
- (void)requestData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"GYHSServerDetailAllModel" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        //        self.dataArray = [NSMutableArray array];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSError* error = nil;
        NSDictionary* dict1 = dict[@"data"];
        self.model = [[GYHSServerDetailAllModel alloc] initWithDictionary:dict1 error:&error];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{

    return self.cellIds.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 2) {

        return [self.model items].count;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.section == 0) {

        GYHSServerTimeCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSServerTimeCellReuseId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (!cell) {
            cell = [[GYHSServerTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSServerTimeCellReuseId];
        }
        [cell setValue:_model forKey:@"model"];
        return cell;
    }
    else if (indexPath.section == 1) {

        GYHSServerAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSServerAddressCellReuseId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (!cell) {
            cell = [[GYHSServerAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSServerAddressCellReuseId];
        }
        [cell setValue:_model forKey:@"model"];
        return cell;
    }
    else {

        GYHSServerDetailsCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSServerDetailsCellReuseId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (!cell) {
            cell = [[GYHSServerDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSServerDetailsCellReuseId];
        }
        [cell setValue:_model.items[indexPath.row] forKey:@"model"];
        return cell;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 2) {
        [self.serverDetailsSectionHeader setValue:self.model forKey:@"model"];
        return self.serverDetailsSectionHeader;
    }
    return nil;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    if (section == 2) {
        [self.serverDetailsSectionFooter setValue:self.model forKey:@"model"];
        return self.serverDetailsSectionFooter;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 2) {
        return 48;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{

    if (section == 2) {
        return 100;
    }
    else {
        return 0.1;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{

    NSInteger number = indexPath.section;
    switch (number) {
    case 0:
        return 70;
    case 1:
        return 118;
    case 2:
        return 50;
    default:
        return 40;
    }
}

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 49 - 41) style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] init];
        for (NSString* cellId in self.cellIds) {
            [_tableView registerNib:[UINib nibWithNibName:cellId bundle:nil] forCellReuseIdentifier:cellId];
        }
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

@end
