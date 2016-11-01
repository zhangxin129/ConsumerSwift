//
//  GYHSSelectCityViewController.m
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSelectCityViewController.h"
#import "GYHSSelectAreaCell.h"
#import "YYKit.h"
#import "GYHSAddressSelectCityDataController.h"
#import "GYHSCityAddressModel.h"
#import "GYHSTools.h"

@interface GYHSSelectCityViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIView *overlay;
@property (nonatomic,strong) UIButton *dismissBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) GYHSAddressSelectCityDataController* selectCityDC;


@end

@implementation GYHSSelectCityViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"Show Controller: %@", [self class]);

}

- (void)dealloc {
    NSLog(@"Dealloc Controller: %@", [self class]);
}

// #pragma mark - SystemDelegate   
#pragma mark TableView Delegate    
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 1;
    }else {
        
        return self.dataArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHSSelectAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHSSelectAreaCellIdentifier];
    if(!cell) {
        
        cell = [[GYHSSelectAreaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kGYHSSelectAreaCellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0) {
        cell.detailLabel.hidden = NO;
        cell.titleLabel.text = kLocalized(@"GYHS_Banding_Universally_PositioningSelect");
        cell.detailLabel.text = self.didSelectArea;
        cell.userInteractionEnabled = NO;
    }else {
        cell.detailLabel.hidden = YES;
        GYHSCityAddressModel *model = self.dataArray[indexPath.row];
        cell.titleLabel.text = model.cityName;
        cell.userInteractionEnabled = YES;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    GYHSSelectAreaCell *cell = [tableView cellForRowAtIndexPath:path];
    
    GYHSCityAddressModel *model = self.dataArray[indexPath.row];
    cell.detailLabel.text = model.cityFullName;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectCity:)]) {
    
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        [self.delegate didSelectCity:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}
// #pragma mark - CustomDelegate
#pragma mark - event response  
//取消叉叉
-(void)dismiss {
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if(self.dismissDelegate && [self.dismissDelegate respondsToSelector:@selector(cityDismiss)]) {
        [self.dismissDelegate cityDismiss];
    }
}

-(void)loadCityList {

    WS(weakSelf)
    [self.selectCityDC queyrCitys:self.areaId privinceNo:self.provinceNo resultBlock:^(NSArray* citysArray) {
        if ([citysArray count] > 0) {
            [weakSelf.dataArray removeAllObjects];
            [weakSelf.dataArray addObjectsFromArray:citysArray];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - private methods
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    
    [self addOverlayView];
    [self loadCityList];
}

//背景
-(void)addOverlayView {
    
    self.overlay = [[UIView alloc] initWithFrame:CGRectMake(10, 64, kScreenWidth -20, kScreenHeight - 64-49 - 50)];
    self.overlay.layer.cornerRadius = 12;
    self.overlay.clipsToBounds = YES;
    self.overlay.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.overlay];
    
    //叉叉按钮
    self.dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dismissBtn.frame = CGRectMake(kScreenWidth/2 -20, self.overlay.bottom +20, 40, 40);
    [self.dismissBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_account_delete_view"] forState:UIControlStateNormal];
    [self.dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dismissBtn];
    
}

//头部
-(UIView *)addHeaderView {
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overlay.bounds.size.width, 86)];
    headerView.backgroundColor  = kDefaultVCBackgroundColor;

    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.overlay.bounds.size.width, 46)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = KSelectAreaCellFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x000000);
    titleLabel.text = kLocalized(@"GYHS_Banding_Navigation_SelectBanCardArea");
    [headerView addSubview:titleLabel];
    
    UILabel *allAreaLabel = [[UILabel alloc]  initWithFrame:CGRectMake(13, titleLabel.bottom, self.overlay.bounds.size.width, 40)];
    allAreaLabel.backgroundColor = kDefaultVCBackgroundColor;
    allAreaLabel.text = kLocalized(@"GYHS_Address_Universally_AllAreas");
    allAreaLabel.textColor = UIColorFromRGB(0x666666);
    allAreaLabel.textAlignment = NSTextAlignmentLeft;
    allAreaLabel.font = KSelectAreaCellFont;
    [headerView addSubview:allAreaLabel];
    
    
    return headerView;
    
}

#pragma mark - getters and setters  
-(UITableView *)tableView {
    
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.overlay.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[GYHSSelectAreaCell class] forCellReuseIdentifier:kGYHSSelectAreaCellIdentifier];
        _tableView.tableHeaderView = [self addHeaderView];
        [self.overlay addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray {
    
    if(!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (GYHSAddressSelectCityDataController*)selectCityDC
{
    if (_selectCityDC == nil) {
        _selectCityDC = [[GYHSAddressSelectCityDataController alloc] init];
    }
    
    return _selectCityDC;
}

@end
