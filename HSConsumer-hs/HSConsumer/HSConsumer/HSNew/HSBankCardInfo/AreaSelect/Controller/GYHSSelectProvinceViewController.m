//
//  GYHSSelectProvinceViewController.m
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSelectProvinceViewController.h"
#import "GYHSSelectAreaCell.h"
#import "YYKit.h"
#import "GYHSAddressCountryModel.h"
#import "GYHSProvinceModel.h"
#import "GYHSSelectCityViewController.h"
#import "GYHSTools.h"

@interface GYHSSelectProvinceViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSSelectCityViewControllerDelegate>

@property (nonatomic,strong) UIView *overlay;
@property (nonatomic,strong) UIButton *dismissBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation GYHSSelectProvinceViewController

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

#pragma mark - SystemDelegate   
-(void)cityDismiss {
    
    [self dismiss];
}
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
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.detailLabel.hidden = YES;
        GYHSProvinceModel *model = self.dataArray[indexPath.row];
        cell.titleLabel.text = model.provinceName;
        cell.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    GYHSSelectAreaCell *cell = [tableView cellForRowAtIndexPath:path];
    
    GYHSProvinceModel *model = self.dataArray[indexPath.row];
    cell.detailLabel.text = [NSString stringWithFormat:@"%@%@",self.didSelectArea,model.provinceName];
    
    GYHSSelectCityViewController *cityVC = [[GYHSSelectCityViewController alloc] init];
    cityVC.dismissDelegate = self;
    cityVC.delegate = self.countryVC;
    cityVC.areaId = model.countryNo;
    cityVC.didSelectArea = [NSString stringWithFormat:@"%@%@",self.didSelectArea,model.provinceName];
    cityVC.provinceNo = model.provinceNo;
    //不需要再加透明度
    cityVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    cityVC.view.frame = [UIScreen mainScreen].bounds;
    [self addChildViewController:cityVC];
    [self.view addSubview:cityVC.view];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:cityVC.view];
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
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(provinceDismiss)]) {
        [self.delegate provinceDismiss];
    }
}


-(void)loadProvinceList {

    NSArray* localAry = [self loadLocalPrivinceData];
    if ([localAry count] <= 0) {
        [self queryProvinceData];
    }
    else {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:localAry];
        [self.tableView reloadData];
    }
}



- (void)queryProvinceData
{
    NSDictionary* paramsDic = @{ @"countryNo" : self.areaId };
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:kUrlQueryProvince parameters:paramsDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        NSArray* serverAry = responseObject[@"data"];
        if ([GYUtils checkArrayInvalid:serverAry]) {
            [GYUtils showMessage:kLocalized(@"GYHS_Banding_Return_Data_Parsing_Error") confirm:nil];
            return;
        }
        
        NSMutableArray* resultAry = [NSMutableArray array];
        for (NSDictionary* indexDic in serverAry) {
            if ([GYUtils checkDictionaryInvalid:indexDic]) {
                continue;
            }
            
            GYHSProvinceModel* model = [[GYHSProvinceModel alloc] initWithDictionary:indexDic error:nil];
            [resultAry addObject:model];
        }
        
        if ([resultAry count] > 0) {
            [self savePrivinceData:resultAry];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:resultAry];
            [self.tableView reloadData];
        }
    }];
    [request start];
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self addOverlayView];
    [self loadProvinceList];
    
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


- (NSArray*)loadLocalPrivinceData
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:[self privinceDataKey]];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([GYUtils checkArrayInvalid:array]) {
        array = [NSArray array];
    }
    
    return array;
}

- (NSString*)privinceDataKey
{
    return [NSString stringWithFormat:@"GYHSSelectProvinceViewData%@", self.areaId];
}

- (void)savePrivinceData:(NSArray*)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:data forKey:[self privinceDataKey]];
        [userDefault synchronize];
    });
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

@end
