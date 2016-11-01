//
//  GYHDApplicantListViewController.m
//  HSConsumer
//
//  Created by shiang on 16/4/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDApplicantListViewController.h"
#import "GYHDApplicantListCell.h"
#import "GYHDApplicantListModel.h"
#import "GYHDMessageCenter.h"
#import "GYHDApplicantDetailViewController.h"
#import "GYHDFriendDetailViewController.h"

@interface GYHDApplicantListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView* applicantListTableView;
@property (nonatomic, strong) NSMutableArray* applicantArray;
@end

@implementation GYHDApplicantListViewController

- (NSMutableArray*)applicantArray
{
    if (!_applicantArray) {
        _applicantArray = [NSMutableArray array];
    }
    return _applicantArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITableView* applicantListTableView = [[UITableView alloc] init];
    applicantListTableView.dataSource = self;
    applicantListTableView.delegate = self;
    [applicantListTableView registerClass:[GYHDApplicantListCell class] forCellReuseIdentifier:@"GYHDApplicantListCellID"];
    applicantListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:applicantListTableView];
    _applicantListTableView = applicantListTableView;
    [applicantListTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableDictionary* selectDict = [NSMutableDictionary dictionary];
    selectDict[GYHDDataBaseCenterPushMessageCode] = @(GYHDProtobufMessage04101);
    NSArray* array = [[GYHDMessageCenter sharedInstance] selectInfoWithDict:selectDict TableName:GYHDDataBaseCenterPushMessageTableName];
    NSMutableArray* applicantArray = [NSMutableArray array];
    for (NSDictionary* dict in array) {
        GYHDApplicantListModel* model = [[GYHDApplicantListModel alloc] initWithDict:dict];
        [applicantArray addObject:model];
    }
    self.applicantArray = applicantArray;

    [self.applicantListTableView reloadData];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.applicantArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDApplicantListModel* model = self.applicantArray[indexPath.row];
    GYHDApplicantListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDApplicantListCellID"];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    GYHDApplicantListModel* model = self.applicantArray[indexPath.row];
    switch (model.applicantUserStatus) {
        case 0:
        {
            GYHDApplicantDetailViewController* detailViewController = [[GYHDApplicantDetailViewController alloc] init];
            detailViewController.model = model;
            
            [self.navigationController pushViewController:detailViewController animated:YES];
            break;
        }
        case 200:
        case 501:
        {
            GYHDFriendDetailViewController* friendDetailViewController = [[GYHDFriendDetailViewController alloc] init];
            // 区别于持卡人与非持卡人 add zhangx
            if ([model.applicantID containsString:@"nc_"]) {
                friendDetailViewController.FriendCustID = [model.applicantID substringFromIndex:3];
            }else{
                
                friendDetailViewController.FriendCustID = [model.applicantID substringFromIndex:2];
            }
            [self.navigationController pushViewController:friendDetailViewController animated:YES];
            break;
        }
        case 810:
        case 811:
        {

            break;
        }
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 66.0f;
}

@end
