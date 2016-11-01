//
//  GYHENearLocationViewController.m
//  GYHEPullDown
//
//  Created by kuser on 16/9/23.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYHENearLocationViewController.h"
#import "GYFullScreenPopView.h"
#import "GYHENearModel.h"
#import "GYHENearMainCell.h"
#import "GYHENearTwoCell.h"
#import "GYHEShopQuModel.h"
#import "GYHEAreaLocationModel.h"

extern NSString * const GYUpdateMenuTitleNote;

@interface GYHENearLocationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *oneTableView;
@property (nonatomic,strong)UITableView *twoTableView;
@property (nonatomic,strong) NSMutableArray *oneArray;
@property (nonatomic,strong) NSMutableArray *twoArray;
@property (nonatomic,strong) NSDictionary *dataDictionary;
@property (nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation GYHENearLocationViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setDataArray];
    [self requestData];
    [self.view addSubview:self.oneTableView];
    [self.view addSubview:self.twoTableView];
}

-(void)setDataArray
{
    for (NSInteger j = 0;j < self.dataArray.count; j++){
        GYHEChildsModel *model =self.dataArray[j];
        [self.oneArray addObject:model];
    }
    [self.oneTableView reloadData];
}

-(void)requestData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"20161006" forKey:@"version"];
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:kgetMobileLocationFileUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            DDLogDebug(@"URL:%@, ErrorCode:%ld ErrorMsg:%@", request.URLString, (long)[error code], [error localizedDescription]);
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        _dataDictionary = responseObject[@"data"];
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}


#pragma mark - <UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.oneTableView) {
        return self.oneArray.count;
    } else {
        return self.twoArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.oneTableView) {
        GYHENearMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHENearMainCell"];
        self.oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHENearModel *model = self.oneArray[indexPath.row];
        cell.areaLabel.text = model.areaName;
        if (self.indexPath) {
            if (indexPath.row == 0) {
                cell.lineView.hidden = NO;
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
        }
        if (indexPath.row == self.indexPath.row) {
            cell.lineView.hidden = NO;
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            cell.lineView.hidden = YES;
            cell.contentView.backgroundColor = kBackgroundGrayColor;
        }
        return cell;
    }else{
        GYHENearTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHENearTwoCell"];
        self.twoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHEShopQuModel *model = self.twoArray[indexPath.row];
        cell.shopQuLabel.text = model.locationName;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.oneTableView) {
        [self.twoArray removeAllObjects];
        GYHENearMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHENearMainCell"];
        cell.lineView.hidden = NO;
        self.oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHENearModel *model = self.oneArray[indexPath.row];
        cell.areaLabel.text = model.areaName;
        //商圈的地方加入全部在第一个
        GYHEShopQuModel *modelAll = [[GYHEShopQuModel alloc]init];
        modelAll.areaCode = @"111";
        modelAll.id = @"222";
        modelAll.landmark = @"333";
        modelAll.locationName = @"全部";
        [self.twoArray addObject:modelAll];
        if ([[_dataDictionary allKeys] containsObject:model.areaCode]){
            NSArray *array = [_dataDictionary valueForKey:model.areaCode];
            for (NSInteger j = 0;j < array.count; j++){
                NSDictionary *dic = array[j];
                GYHEShopQuModel *model = [[GYHEShopQuModel alloc]initWithDictionary:dic error:nil];
                [self.twoArray addObject:model];
            }
        }
        self.indexPath = indexPath;
        [self.oneTableView reloadData];
        [self.twoTableView reloadData];
    }else{
        GYHENearTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHENearTwoCell"];
        self.oneTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        GYHEShopQuModel *model = self.twoArray[indexPath.row];
        cell.shopQuLabel.text = model.locationName;
        // 更新菜单标题
        [[NSNotificationCenter defaultCenter] postNotificationName:GYUpdateMenuTitleNote object:self userInfo:@{@"title":cell.shopQuLabel.text}];
    }
}

#pragma mark －－ Lazy loading
-(NSMutableArray*)oneArray
{
    if (!_oneArray) {
        _oneArray = [[NSMutableArray alloc] init];
    }
    return _oneArray;
}

-(NSMutableArray*)twoArray
{
    if (!_twoArray) {
        _twoArray = [[NSMutableArray alloc] init];
    }
    return _twoArray;
}

-(UITableView*)oneTableView
{
    if (!_oneTableView) {
        _oneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, kScreenHeight- 49 - 64 - 40)];
        _oneTableView.rowHeight = 40;
        _oneTableView.delegate = self;
        _oneTableView.dataSource = self;
        _oneTableView.backgroundColor = kBackgroundGrayColor;
        [self.oneTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHENearMainCell class]) bundle:nil] forCellReuseIdentifier:@"GYHENearMainCell"];
    }
    return _oneTableView;
}

-(UITableView*)twoTableView
{
    if (!_twoTableView) {
        _twoTableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.5, 0, kScreenWidth *0.5, kScreenHeight- 49 - 64 - 40)];
        _twoTableView.rowHeight = 40;
        _twoTableView.delegate = self;
        _twoTableView.dataSource = self;
        self.twoTableView.rowHeight = 40;
        [self.twoTableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHENearTwoCell class]) bundle:nil] forCellReuseIdentifier:@"GYHENearTwoCell"];
    }
    return _twoTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
