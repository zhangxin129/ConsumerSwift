//
//  GYHDCompanyDetailsView.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCompanyDetailsView.h"
#import "GYHDCompanyDetailsCell.h"
#import "GYHDStaffInfoViewController.h"
#import "GYHDSaleListGrounpModel.h"
#import "GYHDSaleListModel.h"
#import "GYHDOpereotrListModel.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDOperGroupModel.h"
#import "GYHDCompanyDetailCollectionReusableView.h"
#import "GYRefreshHeader.h"
#import "GYHDNetWorkTool.h"
#import "GYPinYinConvertTool.h"
#define kGYHDCompanyDetailCollectionReusableViewReuseId @"GYHDCompanyDetailCollectionReusableView"
@interface GYHDCompanyDetailsView()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@end

@implementation GYHDCompanyDetailsView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        _dataSource=[NSMutableArray array];
        _operatorListArr=[NSMutableArray array];
        [self setup];
    }
    return self;
}

- (void)setup {
    @weakify(self);
    //先实例化一个层
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    //设置头部高度
//   layout.headerReferenceSize = CGSizeMake(100, 30);
    
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //创建一屏的视图大小
    self.newsCollectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    self.newsCollectionView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.newsCollectionView registerClass:[GYHDCompanyDetailsCell class] forCellWithReuseIdentifier :@"companyDetailsCell"];
    
    [self.newsCollectionView registerClass:[GYHDCompanyDetailCollectionReusableView  class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGYHDCompanyDetailCollectionReusableViewReuseId];
    
     self.newsCollectionView.delegate = self;
     self.newsCollectionView.dataSource = self;
    [self addSubview: self.newsCollectionView];
    
    [self.newsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(self.bounds.size.width, self.bounds.size.height));
    }];
    
//    添加下拉刷新
    GYRefreshHeader*header=[GYRefreshHeader headerWithRefreshingBlock:^{
        
         [self loadCompanyOperatorRelationList];
        
        [self.newsCollectionView.mj_header endRefreshing];
    }];
    
    self.newsCollectionView.mj_header=header;
    
}
//获取本企业营业点列表
-(void)loadCompanyOperatorRelationList{
//    //数据库中读取
//    NSArray *DataBaseArray = [[GYHDDataBaseCenter sharedInstance] selectFriendList];
//    DDLogCInfo(@"data==%@",DataBaseArray);
//    
//    if (DataBaseArray.count>0) {
//        
//        [self readCompanyListData:DataBaseArray];
//        
//    }
    //    网络获取
    [[GYHDNetWorkTool sharedInstance] postListOperByEntCustIdResult:^(NSArray *resultArry) {
        
        [self readCompanyListData:resultArry];
        
    }];
    
    
}

-(void)readCompanyListData:(NSArray*)resultArry{
    
    
    NSArray*reasutlArr=[self loadOperatorRelationListArr:resultArry];
    
    NSArray*listArr=[self loadCompanyOperatorListArr:resultArry];
    
    NSMutableArray *tempArr= [self operListCompanyWithArray:listArr];
    
    if (self.isCheckList) {
        
        self.dataSource=[tempArr mutableCopy];
        
        [self.newsCollectionView reloadData];
        
    }else{
    
        //    判断进入是查看操作员列表页面还是进入营业点列表页面
            NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
                  if (reasutlArr.count>0 && indexstr!=nil && reasutlArr.count>[indexstr integerValue]) {
                
                GYHDSaleListGrounpModel*model=reasutlArr[[indexstr integerValue]];
                
                self.dataSource=model.operatorListArr;
                
                [self.newsCollectionView reloadData];
                
            }
    }
    
}
-(NSArray*)loadOperatorRelationListArr:(NSArray*)operatorRelationListArr{
    
    
    //   数据重组 获取营业点列表 及相对应的操作员列表
    /*
     1.因为数据复杂性，先获取所有营业点列表名称
     2.以营业点列表名称去依次遍历操作员列表数据
     3.把匹配的操作员添加到当前营业点列表
     */
    NSMutableArray *arr=[NSMutableArray array];
    
    for (NSDictionary*dic in operatorRelationListArr) {
        NSArray*arr1=dic[@"saleAndOperatorRelationList"];
        
        if (arr1.count>0) {
            
            [arr addObject:dic];
            
        }
    }
//    DDLogCInfo(@"arr=%@",arr);
    
    NSMutableArray*salelistArr=[NSMutableArray array];
    
    for (NSDictionary*dic in arr) {
        
        NSArray*arr2= dic[@"saleAndOperatorRelationList"];
        
        for (NSDictionary*dict in arr2) {
            
            if ([salelistArr containsObject:dict[@"sale_networkName"]]) {
                
            }else{
                
                if ([dict[@"sale_networkName"]isEqualToString:@""]){
                    
                }else{
                    
                    [salelistArr addObject:dict[@"sale_networkName"]];
                }
                
            }
            
        }
        
    }
    NSMutableArray*reasutlArr=[NSMutableArray array];
    
    for (NSString*str in salelistArr) {
        
        GYHDSaleListGrounpModel*model=[[GYHDSaleListGrounpModel alloc]init];
        model.OperatorRelationName =str;
        
        for (NSDictionary*dic in arr) {
            
            NSArray*arry=dic[@"saleAndOperatorRelationList"];
            
            for (NSDictionary*tempDic in arry) {
                
                if ([str isEqualToString:tempDic[@"sale_networkName"]]) {
                    
                    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
                    
                    [dict addEntriesFromDictionary:tempDic];
                    
                    [dict addEntriesFromDictionary:dic[@"searchUserInfo"]];
                    if ([dict[@"roleName"] isEqualToString:@"null"] || dict[@"roleName"]==nil){
                        
                        [dict setObject:@""forKey:@"roleName"];
                    }else{
                        [dict setObject:dic[@"roleName"] forKey:@"roleName"];
                    }
                    
                    GYHDSaleListModel*listModel=[[GYHDSaleListModel alloc]initWithDic:dict];
                    if ([listModel.custId isEqualToString:globalData.loginModel.custId]) {
                        
                    }else{
                        
                        [model.operatorListArr addObject:listModel];
                    }
                                        listModel.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:listModel.custId];
                    
                }
                
            }
        }
        [reasutlArr addObject:model];
        
    }
    
    return reasutlArr;
}
-(NSArray*)loadCompanyOperatorListArr:(NSArray*)CompanyOperatorListArr{
    
    //    获取全部操作员列表方法
    NSMutableArray*listArr=[NSMutableArray array];
    
    for (NSDictionary*dict in CompanyOperatorListArr) {
        
        GYHDOpereotrListModel*model=[[GYHDOpereotrListModel alloc]init];
        
        model.saleAndOperatorRelationList=dict[@"saleAndOperatorRelationList"];
        model.searchUserInfo=dict[@"searchUserInfo"];
        if ([dict[@"roleName"] isEqualToString:@"null"] || dict[@"roleName"]==nil){
            
            model.roleName=@"";
            
        }else{
            
            model.roleName=dict[@"roleName"];
            
        }
        //        取得操作员是否有未读消息 显示在通讯录
        model.messageUnreadCount=[[GYHDDataBaseCenter sharedInstance] UnreadMessageCountWithCard:dict[@"searchUserInfo"][@"custId"]];
        
        if ([dict[@"searchUserInfo"][@"custId"] isEqualToString:globalData.loginModel.custId]) {
            
        }else{
            
            [listArr addObject:model];
        }
        
    }
    
    
    return listArr;
    
    
}
/**好友按字母分组*/
- (NSMutableArray *)operListCompanyWithArray:(NSArray *)array {
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

#pragma mark --UICollectionViewDataSource


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    if (self.isCheckList) {
        
        return self.dataSource.count;
    }
    return 1;

}
//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:( UICollectionView *)collectionView numberOfItemsInSection:(NSInteger )section {
    
    if (self.isCheckList && self.dataSource.count>0) {
        
        for (id object in self.dataSource) {
            
            if (![object isKindOfClass:[GYHDOperGroupModel class]]) {
                
                return 0;
            }
        }
        
        GYHDOperGroupModel *groupModel =  self.dataSource[section];
        
        return groupModel.operGroupArray.count;
    }
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"companyDetailsCell";
    
    GYHDCompanyDetailsCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (self.isCheckList) {
//        点击所有操作员列表
        GYHDOperGroupModel *groupModel =  self.dataSource[indexPath.section];
        
        GYHDOpereotrListModel*model=groupModel.operGroupArray[indexPath.row];
        
        [cell initUIWithOperatorModel:model];
        
    }else{
//    点击营业点列表
        GYHDSaleListModel*model=self.dataSource[indexPath.row];
        
        [cell initUIWithModel:model];
        
    }
   
    return cell;
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isCheckList) {
        
        GYHDStaffInfoViewController*vc=[[GYHDStaffInfoViewController alloc]init];
        
        GYHDOperGroupModel *groupModel =  self.dataSource[indexPath.section];
        
        GYHDOpereotrListModel*model=groupModel.operGroupArray[indexPath.row];
        
        vc.isCheckAllOperator=YES;
        vc.OperatorModel=model;
        [self.deledate.navigationController pushViewController:vc animated:YES];
//        清除未读消息
        [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:model.searchUserInfo[@"custId"]];
        
        model.messageUnreadCount=@"";
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"clearUnreadMessage" object:nil];
        
    }else{
    
        GYHDStaffInfoViewController*vc=[[GYHDStaffInfoViewController alloc]init];
        GYHDSaleListModel*model=self.dataSource[indexPath.row];
        vc.model=model;
        [self.deledate.navigationController pushViewController:vc animated:YES];
        self.isCheckList=NO;
    [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:model.custId];
        
    model.messageUnreadCount=@"";
        
        
    }
    
    [self.newsCollectionView reloadData];
}




-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    
        GYHDCompanyDetailCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kGYHDCompanyDetailCollectionReusableViewReuseId forIndexPath:indexPath];
    
    if (self.isCheckList) {
        
        GYHDOperGroupModel *groupModel =  self.dataSource[indexPath.section];

        
        view.titleLabel.text=groupModel.operGroupTitle;
        
    }
    
        return view;

}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (self.isCheckList) {
        
           return CGSizeMake(100, 30);
    }
 
    return CGSizeMake(0, 0);
}
#pragma mark --UICollectionViewDelegateFlowLayout
//每一个cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake((self.bounds.size.width) / 2, 132);
    
}
//设置每组的cell的边界
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake (0 , 0 , 0 , 0);
}


@end
