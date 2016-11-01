//
//  GYHSSelectCountryViewController.m
//
//  Created by lizp on 16/9/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSSelectCountryViewController.h"
#import "GYHSSelectAreaCell.h"
#import "YYKit.h"
#import "GYHSAddressCountryModel.h"
#import "GYHSSelectProvinceViewController.h"
#import "GYHSSelectCityViewController.h"
#import "GYHSTools.h"

@interface GYHSSelectCountryViewController ()<UITableViewDataSource,UITableViewDelegate,GYHSSelectCityViewControllerDelegate,GYHSSelectProvinceViewControllerDelegate>

@property (nonatomic,strong) UIView *overlay;
@property (nonatomic,strong) UIButton *dismissBtn;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation GYHSSelectCountryViewController

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
#pragma mark - GYHSSelectProvinceViewControllerDelegate
-(void)provinceDismiss {
    [self dismiss];
}


#pragma mark - GYHSSelectCityViewControllerDelegate
-(void)didSelectCity:(GYHSCityAddressModel *)model {

    for (UIViewController *VC in self.childViewControllers) {
        [VC.view removeFromSuperview];
        [VC removeFromParentViewController];
    }
    
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(selectArea:)]) {
        [self.delegate selectArea:model];
    }
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
        cell.userInteractionEnabled = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else {
        cell.detailLabel.hidden = YES;
        GYHSAddressCountryModel *model = self.dataArray[indexPath.row];
        cell.titleLabel.text = model.countryName;
        cell.userInteractionEnabled = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    GYHSSelectAreaCell *cell = [tableView cellForRowAtIndexPath:path];
   
     GYHSAddressCountryModel *model = self.dataArray[indexPath.row];
    cell.detailLabel.text = model.countryName;

    
    GYHSSelectProvinceViewController *provinceVC = [[GYHSSelectProvinceViewController alloc] init];
    provinceVC.delegate = self;
    provinceVC.countryVC = self;
    provinceVC.areaId = model.countryNo;
    provinceVC.didSelectArea = model.countryName;
    //不需要再加透明度
    provinceVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    provinceVC.view.frame = [UIScreen mainScreen].bounds;
    [self addChildViewController:provinceVC];
    [self.view addSubview:provinceVC.view];
    UIWindow* window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:provinceVC.view];

    
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
}


//加载数据
-(void)loadCountryList {
    
    NSArray* localAry = [self loadLocalCountryData];
    if ([localAry count] <= 0) {
        [self queryCountryData];
    }
    else {
        NSArray* userAry = [self queryUserCountry:localAry];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:userAry];
        [self.tableView reloadData];
    }
    
}

//从模型里面取
- (NSArray*)loadLocalCountryData
{
    NSData* data = [[NSUserDefaults standardUserDefaults] objectForKey:@"GYHSSelectCountryData"];
    NSArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([GYUtils checkArrayInvalid:array]) {
        array = [NSArray array];
    }
    
    return array;
}

//请求网络
- (void)queryCountryData
{
    
    NSString* url = kUrlQueryCountry;
    NSDictionary* paramsDic = @{};
    
    GYNetRequest* request = [[GYNetRequest alloc] initWithBlock:url parameters:paramsDic requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
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
            
            GYHSAddressCountryModel* model = [[GYHSAddressCountryModel alloc] initWithDictionary:indexDic error:nil];
            [resultAry addObject:model];
        }
        
        if ([resultAry count] > 0) {
            NSArray* userAry = [self queryUserCountry:resultAry];
            [self saveCountryData:resultAry];
            
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:userAry];
            [self.tableView reloadData];
        }
    }];
    [request start];
}

//只加载用户注册的国家
- (NSMutableArray*)queryUserCountry:(NSArray*)array
{
    GYHSLocalInfoModel* userModel = [[GYHSLoginManager shareInstance] localInfoModel];
    
    NSMutableArray* resultArray = [NSMutableArray array];
    if ([GYUtils checkStringInvalid:userModel.countryNo]) {
        DDLogDebug(@"The userModel is nil.");
        return resultArray;
    }
    
    for (GYHSAddressCountryModel* indexModel in array) {
        if ([indexModel.countryNo isEqualToString:userModel.countryNo]) {
            [resultArray addObject:indexModel];
        }
    }
    
    return resultArray;
}


//保存模型
- (void)saveCountryData:(NSArray*)array
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSUserDefaults *userDefault =[NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [userDefault setObject:data forKey:@"GYHSSelectCountryData"];
        [userDefault synchronize];
    });
}

#pragma mark - private methods 
- (void)initView
{
    self.title = kLocalized(@"");
    self.view.backgroundColor = kDefaultVCBackgroundColor;
    NSLog(@"Load Controller: %@", [self class]);
    
    [self addOverlayView];
    [self loadCountryList];
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
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.overlay.frame.size.width, 86)];
    headerView.backgroundColor  = kDefaultVCBackgroundColor;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.overlay.bounds.size.width, 46)];
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.font = KSelectAreaCellFont;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = UIColorFromRGB(0x000000);
    titleLabel.text = kLocalized(@"GYHS_Banding_Navigation_SelectBanCardArea");
    [headerView addSubview:titleLabel];
    
    UILabel *allAreaLabel = [[UILabel alloc]  initWithFrame:CGRectMake(13, titleLabel.bottom, self.overlay.bounds.size.width, 40)];
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

@end
