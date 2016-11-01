//
//  GYHSTakeAwayDetailsController.m
//  HSConsumer
//
//  Created by kuser on 16/9/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSTakeAwayDetailsController.h"
#import "GYHSTakeAwayDetailSectionHeader.h"
#import "GYHSTakeAwayDetailSectionFooter.h"
#import "GYHSTakeAwayDetailsCell.h"
#import "GYHSTakeAwayTimeCell.h"
#import "GYHSTakeAwayAddressCell.h"
#import "GYHSTakeAwayDetailFooter.h"
#import "GYHSTakeAwayDetailAllModel.h"
#define kGYHSTakeAwayDetailsCellReuseId @"GYHSTakeAwayDetailsCell"
#define kGYHSTakeAwayTimeCellReuseId @"GYHSTakeAwayTimeCell"
#define kGYHSTakeAwayAddressCellReuseId @"GYHSTakeAwayAddressCell"

@interface GYHSTakeAwayDetailsController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) GYHSTakeAwayDetailAllModel* model;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* cellIds;
@property (nonatomic, strong) GYHSTakeAwayDetailSectionHeader* takeAwayDetailsSectionHeader;
@property (nonatomic, strong) GYHSTakeAwayDetailSectionFooter* takeAwayDetailsSectionFooter;
@property (nonatomic, strong) GYHSTakeAwayDetailFooter* takeAwayDetailFooter;

@end

@implementation GYHSTakeAwayDetailsController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.cellIds = @[ kGYHSTakeAwayTimeCellReuseId,
        kGYHSTakeAwayAddressCellReuseId,
        kGYHSTakeAwayDetailsCellReuseId ];
    [self.view addSubview:self.tableView];
    self.title = kLocalized(@"订单详情");
    self.view.backgroundColor = [UIColor whiteColor];
    self.takeAwayDetailsSectionHeader = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSTakeAwayDetailSectionHeader class]) owner:self options:nil] firstObject];
    [self.takeAwayDetailsSectionHeader setValue:self.model forKey:@"model"];
    [self.takeAwayDetailsSectionHeader setValue:self forKey:@"delegate"];
    self.takeAwayDetailsSectionFooter = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHSTakeAwayDetailSectionFooter class]) owner:self options:nil] firstObject];
    [self.takeAwayDetailsSectionFooter setValue:self.model forKey:@"model"];
    // 底部按钮
    GYHSTakeAwayDetailFooter* footer = [[GYHSTakeAwayDetailFooter alloc] initWithFrame:CGRectMake(0, kScreenHeight - 41 - 64 - 49, kScreenWidth, 41)];
    [self.view addSubview:footer];
    self.takeAwayDetailFooter = footer;
    [self.takeAwayDetailFooter setValue:self.model forKey:@"model"];
    [self.takeAwayDetailFooter setValue:self forKey:@"delegate"];
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 进入商铺
- (void)didSelectedIntoShopBtn:(GYHSTakeAwayDetailSectionHeader*)header
{
    NSLog(@"点击了商铺");
}

#pragma mark -联系客服
- (void)didSelectedContactBtn:(GYHSTakeAwayDetailSectionHeader*)header
{
    NSLog(@"点击了联系客服");
}

#pragma mark--售后申请
- (void)afterSaleBtn:(GYHSTakeAwayDetailFooter*)footer
{
    NSLog(@"申请售后");
}

#pragma mark--退款申请
- (void)requestBackPayBtn:(GYHSTakeAwayDetailFooter*)footer
{
    NSLog(@"退款申请");
}

#pragma mark--查看物流
- (void)lookLogisterBtn:(GYHSTakeAwayDetailFooter*)footer
{
    NSLog(@"查看物流");
}

#pragma mark--再订
- (void)buyAgainBtn:(GYHSTakeAwayDetailFooter*)footer
{
    NSLog(@"再订");
}

#pragma mark--请求网络数据
- (void)requestData
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"GYHSTakeAwayOrderAllModel" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    if (data) {
        //        self.dataArray = [NSMutableArray array];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSError* error = nil;
        NSDictionary* dict1 = dict[@"data"];
        self.model = [[GYHSTakeAwayDetailAllModel alloc] initWithDictionary:dict1 error:&error];
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
        GYHSTakeAwayTimeCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSTakeAwayTimeCellReuseId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (!cell) {
            cell = [[GYHSTakeAwayTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSTakeAwayTimeCellReuseId];
        }
        [cell setValue:_model forKey:@"model"];
        return cell;
    }
    else if (indexPath.section == 1) {
        GYHSTakeAwayAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:kGYHSTakeAwayAddressCellReuseId];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (!cell) {
            cell = [[GYHSTakeAwayAddressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSTakeAwayAddressCellReuseId];
        }
        [cell setValue:_model forKey:@"model"];
        return cell;
    }
    else {
        GYHSTakeAwayDetailsCell* cell2 = [tableView dequeueReusableCellWithIdentifier:kGYHSTakeAwayDetailsCellReuseId];
        [cell2 setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (!cell2) {
            cell2 = [[GYHSTakeAwayDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSTakeAwayDetailsCellReuseId];
        }
        [cell2 setValue:_model.items[indexPath.row] forKey:@"model"];
        return cell2;
    }
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 2) {
        [self.takeAwayDetailsSectionHeader setValue:self.model forKey:@"model"];
        return self.takeAwayDetailsSectionHeader;
    }
    return nil;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{

    if (section == 2) {
        [self.takeAwayDetailsSectionFooter setValue:self.model forKey:@"model"];
        return self.takeAwayDetailsSectionFooter;
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
