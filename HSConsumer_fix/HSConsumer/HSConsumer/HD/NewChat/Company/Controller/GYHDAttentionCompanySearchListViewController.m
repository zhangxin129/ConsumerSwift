//
//  GYHDAttentionCompanySearchListViewController.m
//  HSConsumer
//
//  Created by shiang on 16/4/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAttentionCompanySearchListViewController.h"
#import "GYHDAttentionCompanySearchListModel.h"
#import "GYHDAttentionCompanySearchListCell.h"

#import "GYHDMessageCenter.h"
#import "GYShopDescribeController.h"
#import "GYEasyBuyModel.h"

@interface GYHDAttentionCompanySearchListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView* searchTableView;
@property (nonatomic, strong) NSArray* searchArry;
/**当前页面*/
@property (nonatomic, assign) NSInteger currentPage;
/**
 *  提示
 */
@property (nonatomic, weak) UILabel* zeroMessageLabel;
@end

@implementation GYHDAttentionCompanySearchListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_user_attentionCompany"];
    UITableView* searchTableView = [[UITableView alloc] init];
    searchTableView.dataSource = self;
    searchTableView.delegate = self;
    searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [searchTableView registerClass:[GYHDAttentionCompanySearchListCell class] forCellReuseIdentifier:@"UITableViewCellID"];
    [self.view addSubview:searchTableView];
    _searchTableView = searchTableView;
    [searchTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    _currentPage = 1;

    if (_searchCity) {
        [self setupRefreshWithSearchCity];
    }
    else {
        [self setupRefreshWithSearchString];
    }
    UILabel* zeroMessageLabel = [[UILabel alloc] init];
    zeroMessageLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    zeroMessageLabel.textColor = [UIColor grayColor];
    zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_resut"];
    [self.view addSubview:zeroMessageLabel];
    _zeroMessageLabel = zeroMessageLabel;
    WS(weakSelf);
    [zeroMessageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];
}
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    //    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)setupRefreshWithSearchCity
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        [[GYHDMessageCenter sharedInstance] searchCompanyWithcity:weakSelf.searchCity currentPage:[NSString stringWithFormat:@"%ld", (long)_currentPage++] RequetResult:^(NSDictionary *resultDict) {
    
            NSArray *reArray = resultDict[@"data"];
            if ([resultDict[@"retCode"] integerValue] == 200 && reArray.count > 0) {
                NSMutableArray *searchArry = [NSMutableArray array];
                for (NSDictionary *dict in reArray) {
                    GYHDAttentionCompanySearchListModel *model = [[GYHDAttentionCompanySearchListModel alloc] initWithDictionary:dict];
                    [searchArry addObject:model];
                }
                NSMutableArray *fristArray = [NSMutableArray arrayWithArray:self.searchArry];
                [fristArray addObjectsFromArray:searchArry];
                weakSelf.searchArry = fristArray;


                [weakSelf.searchTableView reloadData];

            }
            if (!weakSelf.searchArry.count) {
                weakSelf.searchTableView.mj_footer.hidden = YES;
                weakSelf.zeroMessageLabel.hidden = NO;
            }else {
                weakSelf.zeroMessageLabel.hidden = YES;
            }
            [weakSelf.searchTableView.mj_footer endRefreshing];
        }];

    }];

    self.searchTableView.mj_footer = footer;
    [self.searchTableView.mj_footer beginRefreshing];
}

/**下拉刷新*/
- (void)setupRefreshWithSearchString
{
    WS(weakSelf);
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        [[GYHDMessageCenter sharedInstance] searchCompanyWithString:weakSelf.searchString currentPage:[NSString stringWithFormat:@"%ld", (long)_currentPage++] RequetResult:^(NSDictionary *resultDict) {

            
            NSArray *reArray = resultDict[@"data"];
            if ([resultDict[@"retCode"] integerValue] == 200 && reArray.count > 0) {
                NSMutableArray *searchArry = [NSMutableArray array];
                for (NSDictionary *dict in reArray) {
                    GYHDAttentionCompanySearchListModel *model = [[GYHDAttentionCompanySearchListModel alloc] initWithDictionary:dict];
                    [searchArry addObject:model];
                }
                NSMutableArray *fristArray = [NSMutableArray arrayWithArray:self.searchArry];
                [fristArray addObjectsFromArray:searchArry];
                weakSelf.searchArry = fristArray;
                [weakSelf.searchTableView reloadData];

            }
            if (!weakSelf.searchArry.count) {
                weakSelf.searchTableView.mj_footer.hidden = YES;
                weakSelf.zeroMessageLabel.hidden = NO;
            }else {
                weakSelf.zeroMessageLabel.hidden = YES;
            }
            [weakSelf.searchTableView.mj_footer endRefreshing];
        }];

    }];

    self.searchTableView.mj_footer = footer;
    [self.searchTableView.mj_footer beginRefreshing];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArry.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDAttentionCompanySearchListModel* model = self.searchArry[indexPath.row];
    GYHDAttentionCompanySearchListCell* cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellID"];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 66.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDAttentionCompanySearchListModel* companyModel = self.searchArry[indexPath.row];
    GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];
    ShopModel* model = [[ShopModel alloc] init];
    model.strShopId = companyModel.companyShopID;
    model.strVshopId = companyModel.companyVshopID;
    vc.shopModel = model;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [super viewWillAppear:YES];
//    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//    NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
    
    
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    //    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
    //    attDict[NSForegroundColorAttributeName] = [UIColor redColor];
    //    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
    //    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [backButton setImage:[UIImage imageNamed:@"gyhd_nav_leftView_back"] forState:UIControlStateNormal];
    //    backButton.frame = CGRectMake(0, 0, 80, 40);
    //    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -60, 0, 0);
    //    [backButton addTarget:self action:@selector(ignoreClick) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
}
//- (void)ignoreClick {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = kNavBackgroundColor;
//    NSMutableDictionary *attDict = [NSMutableDictionary dictionary];
//    attDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:attDict];
//}

@end
