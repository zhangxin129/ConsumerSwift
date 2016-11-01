//
//  GYAccountOperatingViewController.m
//  HSConsumer
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kKeyCellName @"keyName"
#define kKeyCellIcon @"keyIcon"
#define kKeyNextVcName @"keyNextVcName"

#import "GYBusinessProcessVC.h"
#import "CellTypeImagelabel.h"
#import "GYUnlockViewController.h"
#import "GYAgainViewController.h"
#import "GYBusinessDetailViewVC.h"
#import "GYHSHealthPlanViewController.h"
#import "GYHSScoreWealQueryViewController.h"
#import "GYSamplePictureModel.h"
#import "GYSamplePictureManager.h"

#import "GYHSBusinessFillCardViewController.h"
#import "GYHSReportLossViewController.h"

@interface GYBusinessProcessVC () <UITableViewDataSource, UITableViewDelegate> {

    NSMutableArray* arrPowers; //功能列表数组
}

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* imageDocListarr;
@end

@implementation GYBusinessProcessVC

- (NSMutableArray*)imageDocListarr
{ //获取图片示例列表
    if (!_imageDocListarr) {
        _imageDocListarr = [[NSMutableArray alloc] init];
    }
    return _imageDocListarr;
}
- (UITableView*)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 20 - 49) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = kDefaultVCBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;

        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    self.tableView.userInteractionEnabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryImageDocListUrlString];

    //控制器背景色
    [self.view setBackgroundColor:kDefaultVCBackgroundColor];

    //注册cell以复用
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CellTypeImagelabel class]) bundle:kDefaultBundle]
         forCellReuseIdentifier:kCellTypeImagelabelIdentifier];

    arrPowers = [NSMutableArray array];
    [arrPowers addObject:@[
        @{ kKeyCellIcon : @"hs_cell_img_points_card_report_loss",
            kKeyCellName : kLocalized(@"GYHS_BP_Report_Loss_Points_Card"),
            kKeyNextVcName : NSStringFromClass([GYHSReportLossViewController class]) //挂失
        },
        @{ kKeyCellIcon : @"hs_cell_img_points_card_unlock",
            kKeyCellName : kLocalized(@"GYHS_BP_Unlock_Points_Card"),
            kKeyNextVcName : NSStringFromClass([GYUnlockViewController class]) //解挂
        },
        @{ kKeyCellIcon : @"hs_cell_img_points_card_rehandle",
            kKeyCellName : kLocalized(@"GYHS_BP_Points_Card_Rehandle"),
            kKeyNextVcName : NSStringFromClass([GYAgainViewController class]) //补办
        },
        @{ kKeyCellIcon : @"hs_cell_img_progress_check",
            kKeyCellName : kLocalized(@"GYHS_BP_System_Log_Query"),
            kKeyNextVcName : NSStringFromClass([GYBusinessDetailViewVC class]) //业务查询
        }
    ]];

    [arrPowers addObject:@[ @{ kKeyCellIcon : @"hs_cell_img_medical",
        kKeyCellName : kLocalized(@"GYHS_BP_Health_Benefits"),
        kKeyNextVcName : NSStringFromClass([GYHSHealthPlanViewController class]) //医疗计划
    },
//        @{ kKeyCellIcon : @"hs_cell_img_security",
//            kKeyCellName : kLocalized(@"GYHS_BP_Accident_Harm_Security"),
//            kKeyNextVcName : NSStringFromClass([GYHSAccidentHarmViewController class]) //意外保障
//        },
        @{ kKeyCellIcon : @"hs_cell_img_welfare",
            kKeyCellName : kLocalized(@"GYHS_BP_Weal_Check"),
            kKeyNextVcName : NSStringFromClass([GYHSScoreWealQueryViewController class]) //积分福利查询
        } ]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return arrPowers.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrPowers[section] count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    CellTypeImagelabel* cell = [tableView dequeueReusableCellWithIdentifier:kCellTypeImagelabelIdentifier];
    if (!cell) {
        cell = [[CellTypeImagelabel alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellTypeImagelabelIdentifier];
    }

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    cell.lbCellLabel.text = [arrPowers[section][row] valueForKey:kKeyCellName];
    cell.ivCellImage.image = kLoadPng([arrPowers[section][row] valueForKey:kKeyCellIcon]);
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 75.0f;
    //  return kCellHeight;
}

//组头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return kDefaultMarginToBounds;
    }
    else {
        return 1.0f;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == arrPowers.count - 1) {
        return 30.0f;
    }
    else {
        return kDefaultMarginToBounds - 1.0f;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;

    NSString* className = [arrPowers[section][row] valueForKey:kKeyNextVcName];

    UIViewController* vc = nil;
    if ([className isEqualToString:NSStringFromClass([GYBusinessDetailViewVC class])]) {
        GYBusinessDetailViewVC* vcDetail = kLoadVcFromClassStringName(className);
        vc = vcDetail;
    }
    else {
        vc = kLoadVcFromClassStringName(className);
        vc.navigationItem.title = [arrPowers[section][row] valueForKey:kKeyCellName];
    }

    if (vc && _delegate && [_delegate respondsToSelector:@selector(pushVC:animated:)]) {
        vc.hidesBottomBarWhenPushed = YES;
        [_delegate pushVC:vc animated:YES];
    }
}

//获取图片示例列表（正常的数据）
- (void)queryImageDocListUrlString
{
    GYSamplePictureManager* manger = [GYSamplePictureManager shareInstance];
    [GYGIFHUD show];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kHSqueryImageDocListUrlString parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return ;
        }
        NSArray *array = responseObject[@"data"];
        if ([GYUtils checkArrayInvalid:array]) {
            return ;
        }
        for (NSDictionary *dic in array) {
            GYSamplePictureModel *model = [[GYSamplePictureModel alloc] initWithDictionary:dic error:nil];
            [manger insertIntoDB:model];
        }

    }];
    [request commonParams:[GYUtils netWorkCommonParams]];
    [request start];
    

}


@end
