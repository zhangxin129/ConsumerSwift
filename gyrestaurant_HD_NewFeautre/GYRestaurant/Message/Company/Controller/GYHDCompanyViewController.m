//
//  GYHDCompanyViewController.m
//  HSEnterprise
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCompanyViewController.h"
#import "GYHDCompanyListView.h"
#import "GYHDCompanyDetailsView.h"
#import "GYHDSaleListModel.h"
#import "GYHDOpereotrListModel.h"
#import  "GYPinYinConvertTool.h"
#import "GYHDOperGroupModel.h"
@interface GYHDCompanyViewController ()<GYHDCompanyListViewDelegate>

@end

@implementation GYHDCompanyViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _OperatorRelationListArr=[NSMutableArray array];
        _companyOperatorListArr=[NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    判断进入是查看操作员列表页面还是进入营业点列表页面
     NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
    
    if ([indexstr integerValue] == -1){
        
        _companyDetailsView.dataSource=[self.companyOperatorListArr mutableCopy];
        
        _companyDetailsView.isCheckList=YES;
        
        [_companyDetailsView.newsCollectionView reloadData];
    }else{
        
        if (self.OperatorRelationListArr.count>0 && indexstr!=nil && self.OperatorRelationListArr.count>[indexstr integerValue]) {
            
            GYHDSaleListGrounpModel*model=self.OperatorRelationListArr[[indexstr integerValue]];
            //    营业点列表分组排序

            _companyDetailsView.dataSource=model.operatorListArr;
            
            _companyDetailsView.isCheckList=NO;
            
            [_companyDetailsView.newsCollectionView reloadData];
        }
    }
     [_companyDetailsView.newsCollectionView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self initUI];
}

-(void)setOperatorRelationListArr:(NSMutableArray *)OperatorRelationListArr{

    _OperatorRelationListArr=OperatorRelationListArr;

    _companyListView.dataSource= [_OperatorRelationListArr mutableCopy];
    _companyListView.companyOperatorArr=self.companyOperatorListArr;
    
    [_companyListView.tableView reloadData];
}
- (void)initUI {
    
    _companyListView = [[GYHDCompanyListView alloc]initWithFrame:CGRectMake(0 , 0, 250, kScreenHeight - 20)];
    
     _companyListView.delegate=self;
    [self.view addSubview:_companyListView];
    
    _companyDetailsView = [[GYHDCompanyDetailsView alloc]initWithFrame:CGRectMake(250 , 0, kScreenWidth - 250, kScreenHeight - 64)];
    _companyDetailsView.deledate=self;
    [self.view addSubview:_companyDetailsView];
    
}
#pragma mark - 操作员列表代理方法
-(void)refreshSaleListViewWithModel:(GYHDSaleListGrounpModel*)model{
//    营业点列表分组排序
    
    _companyDetailsView.dataSource=model.operatorListArr;
    
    _companyDetailsView.isCheckList=NO;
    
    [_companyDetailsView.newsCollectionView reloadData];
    
}
#pragma mark - 操作员列表代理方法
-(void)refreshSaleListViewWithArry:(NSArray *)arry{
    
    _companyDetailsView.dataSource=[arry mutableCopy];
    
    _companyDetailsView.isCheckList=YES;
    
    [_companyDetailsView.newsCollectionView reloadData];
    
}

/**好友按字母分组*/
- (NSMutableArray *)saleNetWorkOperListCompanyWithArray:(NSArray *)array {
    NSArray *ABCArray = [NSArray arrayWithObjects: @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",@"#", nil];
    NSMutableArray *operGroupArray = [NSMutableArray array];
    for (NSString *key in ABCArray) {
        GYHDOperGroupModel *operGroupModel = [[GYHDOperGroupModel alloc]init];
        for (GYHDOpereotrListModel *operModel in array) {
            
            //1. 转字母
            NSString * tempStr = operModel.searchUserInfo[@"operName"];
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if ([GYPinYinConvertTool isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
            }
            //2. 获取首字母
            NSString *firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            //3. 加入数组
            if([firstLetter isEqualToString:key]) {
                operGroupModel.operGroupTitle = key;
                [operGroupModel.operGroupArray addObject:operModel];
            }
        }
        if (operGroupModel.operGroupTitle && operGroupModel.operGroupArray.count > 0) {
            [operGroupArray addObject:operGroupModel];
        }
    }
    return  operGroupArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
