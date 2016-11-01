
//
//  GYSearchShopsViewController.m
//  HSConsumer
//
//  Created by apple on 15/11/17.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSearchShopsViewController.h"
#import "GYAroundLocationChooseController.h"
#import "GYEasyBuyModel.h"

//商品栏目分类model
#import "GYGoodCategoryModel.h"
//逛商品的cell
#import "GYFindShopTableViewCell.h"
#import "DropDownWithChildListView.h"
#import "GYCitySelectViewController.h"
#import "GYSortTypeModel.h"
#import "GYCityInfo.h"
#import "GYAreaCodeModel.h"

#import "GYGIFHUD.h"
#import "GYShowShopsCell.h"
#import "GYShopDescribeController.h"
#import "FDMainViewController.h"
#import "FDTakeawayMainViewController.h"
#import "GYAppDelegate.h"
#import "GYEasybuySearchMainController.h"

#define pageCount 8
@interface GYSearchShopsViewController () <selectCity, UITableViewDataSource, UITableViewDelegate, GYAroundLocationChooseControllerDelegate> {
    UITableView* tvEasyBuy;
    NSMutableArray* marrEasyBuySource;
    NSMutableArray* chooseArray;
    NSArray* arr;
    NSMutableArray* marrSortType;
    NSMutableArray* marrSortTtile;
    NSInteger sectionNum;
    NSInteger indexNumber; // add by songjk 选中的第一个分类
    UITableView* tempTv;

    NSMutableArray* marrDatasource;
    NSMutableArray* marrLevelTwoTitle;
    NSMutableArray* marrCategoryLevelOne;
    NSMutableArray* marrCategoryLevelTwo;
    NSMutableArray* marrSeveceSType; //卖家服务排序
    NSMutableArray* marrSeveceTitle; //卖家服务字段

    NSInteger useType;
    NSString* cityString; //城市
    NSString* areaString; //区
    NSString* sectionString; //商圈
    CLLocationCoordinate2D currentLocation;
    NSString* categoryIdString;
    NSInteger sortType;
    BMKMapPoint mp1;
    NSString* titleName;

    NSMutableArray* marrArea;
    NSMutableArray* marrAreaTitle;

    DropDownWithChildListView* dropDownView;

    NSInteger currentPage; //当前页码

    NSInteger totalCount; //总个数

    BOOL isUpFresh; //是否是上拉刷新

    NSInteger totalPage; //总共多少页

    BOOL isAdd;

    NSString* strLevelOneCategory;

    NSMutableArray* supportService; //特殊服务数组
    NSString* specialService; //特殊服务
    NSString* _distance; //传入附近参数
    NSString* _hasCoupon; //传入消费抵扣券

    UIButton* _backTopBtn; //返回顶部按钮

    BOOL isSelectArea; //YES选择为区   NO选择为距离
}
@end

@implementation GYSearchShopsViewController
#pragma mark - 系统方法
- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchShopsData) name:@"NSSearchShopsDidRefreshDataNotification" object:nil];
    [self setNav];
    self.view.backgroundColor = [UIColor whiteColor];
    useType = 1;
    if (self.strSortType.length > 0) {

        sortType = [self.strSortType integerValue];
        _hasCoupon = @"";
   
    }
    else {

        sortType = 1;
    }
    if (self.modelTitle.length > 0) {

        titleName = self.modelTitle;
    }
    else {

        titleName = kLocalized(@"GYHE_SurroundVisit_All");
    }

    // songjk
    if (globalData.selectedCityName) {
        cityString = globalData.selectedCityName;
    }
    else {
        cityString = globalData.locationCity;
    }
    sectionString = @"";
    areaString = @"";
    specialService = @"";
    _distance = @"";
    _hasCoupon = @"";
    currentPage = 1;

    marrEasyBuySource = [NSMutableArray array];
    marrDatasource = [NSMutableArray array];
    marrCategoryLevelOne = [NSMutableArray array];
    marrCategoryLevelTwo = [NSMutableArray array];
    marrLevelTwoTitle = [NSMutableArray array];
    marrSortType = [NSMutableArray array];
    marrSortTtile = [NSMutableArray array];
    marrAreaTitle = [NSMutableArray array];
    marrArea = [NSMutableArray array];
    marrSeveceSType = [NSMutableArray array];
    marrSeveceTitle = [NSMutableArray array];
    supportService = [NSMutableArray array];
    categoryIdString = self.modelID;

    tvEasyBuy = [[UITableView alloc] initWithFrame:CGRectMake(0, 34, self.view.frame.size.width, self.view.frame.size.height - 104) style:UITableViewStylePlain];
    tvEasyBuy.showsHorizontalScrollIndicator = NO;
    tvEasyBuy.showsVerticalScrollIndicator = NO;
    tvEasyBuy.delegate = self;

    tvEasyBuy.dataSource = self;

    [self.view addSubview:tvEasyBuy];

    [tvEasyBuy registerNib:[UINib nibWithNibName:NSStringFromClass([GYShowShopsCell class]) bundle:nil] forCellReuseIdentifier:@"cellID"];

    tvEasyBuy.tableFooterView = [[UIView alloc] init];
    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {
        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
    }
    //    添加头部刷新
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        //        请求数据
        [self headerRereshing];
    }];

    //单例 调用刷新图片

    tvEasyBuy.mj_header = header;

    if (globalData.isOnNet) {
        [GYGIFHUD show];
        [self loadTopDataFromNetwork];
    }
    else {

        [self showNoNetworkView];
    }

    //      返回顶部按钮
    _backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    GYAppDelegate* app = (GYAppDelegate*)[UIApplication sharedApplication].delegate;

    _backTopBtn.frame = CGRectMake(app.window.bounds.size.width - 35 / 2 - 40, app.window.bounds.size.height - 60 , 45, 45);

    [_backTopBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_backtotop"] forState:0];

    [_backTopBtn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];

    _backTopBtn.hidden = YES;

    [app.window addSubview:_backTopBtn];
}

- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];

    //用于接收重新定位发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateByLocation) name:kGYHSLoginManagerCityAddressNotification object:nil];
}

/*
 修改主界面返回时tabBar不显示问题 add by zhangx
 */
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_backTopBtn removeFromSuperview];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 获取市的selectCity代理方法
- (void)getCity:(NSString*)CityTitle WithType:(int)type
{
    [marrAreaTitle removeAllObjects];
    // add by songjk 传入空值退出
    if (!CityTitle || CityTitle.length == 0) {
        return;
    }
    // modify 下面用到
    NSString* tempCityStr;
    if (CityTitle.length > 0) {
        tempCityStr = CityTitle; // add by songjk 没有包含市的时候取原值
        if ([CityTitle hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            tempCityStr = [CityTitle substringToIndex:CityTitle.length - 1];
        }

        [self reloadDropViewDatasource];
    }
    // add by songjk 重置地区
    sectionString = @"";
    areaString = @"";

    cityString = CityTitle;
    currentPage = 1;

    if (type == 1) {
        isAdd = YES;
        
        areaString = @"";
        [tvEasyBuy.mj_header beginRefreshing];
    }
    //将文字转化为areaCode
    NSString* cityAreaCode;
    NSString* path = [[NSBundle mainBundle] pathForResource:@"cityLists" ofType:@"txt"];
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* tempDic in dict1[@"data"]) {

        GYCityInfo* cityModel = [[GYCityInfo alloc] init];
        cityModel.strAreaName = tempDic[@"areaName"];
        cityModel.strAreaCode = tempDic[@"areaCode"];
        cityModel.strAreaType = tempDic[@"areaType"];
        cityModel.strAreaParentCode = kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder = kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaName isEqualToString:CityTitle]) {
            cityAreaCode = cityModel.strAreaCode;
        }
        else {
            // add by songjk 当后缀没有市的时候执行
            if ([cityModel.strAreaName isEqualToString:tempCityStr]) {
                cityAreaCode = cityModel.strAreaCode;
            }
        }
    }
    //通过市的code 遍历出市下面的区
    NSString* path1 = [[NSBundle mainBundle] pathForResource:@"districtlist" ofType:@"txt"];
    NSData* jsonData1 = [NSData dataWithContentsOfFile:path1];
    NSDictionary* dict2 = [NSJSONSerialization JSONObjectWithData:jsonData1 options:NSJSONReadingMutableContainers error:nil];

    NSMutableArray* marrTempAreaTitle = [NSMutableArray array];
    NSMutableArray* marrTempArea = [NSMutableArray array];

    for (NSDictionary* tempDic in dict2[@"data"]) {
        GYCityInfo* cityModel = [[GYCityInfo alloc] init];
        cityModel.strAreaName = tempDic[@"areaName"];
        cityModel.strAreaCode = tempDic[@"areaCode"];
        cityModel.strAreaType = tempDic[@"areaType"];
        cityModel.strAreaParentCode = kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder = kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaParentCode isEqualToString:cityAreaCode]) {
            [marrTempAreaTitle addObject:cityModel.strAreaName];
            [marrTempArea addObject:cityModel];
        }
    }

    marrArea = marrTempArea;
    marrAreaTitle = marrTempAreaTitle;
    if (marrTempAreaTitle.count == 0) {
        if ([CityTitle hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            [self getCity:tempCityStr WithType:0];
        }
    }
    //重新选择城市后，需要重新列出所对应的区，需要刷新 section 的数据源
    [self reloadDropViewDatasource];
}

#pragma mark DropDownWithChildChooseDelegate
//用于消除 多选项中选中的项目
- (void)mutableSelectRemoveObj:(NSIndexPath*)indexPath WithCurrentSectin:(NSInteger)sectionNumber
{
    DDLogDebug(@"mutableSelectRemoveObj sectionNumber = %ld", sectionNumber);
    if(marrSeveceSType.count > indexPath.row) {
        GYSortTypeModel* sortTypeMod2 = marrSeveceSType[indexPath.row];
        
        [supportService removeObject:sortTypeMod2.strTitle];
    }
    
}

- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has
{
    NSMutableArray* tempArray = [marrEasyBuySource mutableCopy];
    sectionNum = section;
    indexNumber = index;
    if (marrCategoryLevelTwo.count > 0) {
        [marrCategoryLevelTwo removeAllObjects];
    }
    if (marrEasyBuySource.count > 0) {
        [marrEasyBuySource removeAllObjects];
    }
    if (sectionNum == 0 && index == 0) {
        [self makeAroundDistanceChoose];

        currentPage = 1;
        sectionString = @"";
        areaString = @"";
        [tvEasyBuy.mj_header beginRefreshing];
        
        return;
    }
    if (sectionNum == 0) {

        if(marrArea.count > index) {
            GYCityInfo* cityModel = marrArea[index];
            areaString = cityModel.strAreaName;
            [dropDownView setBtnText:areaString section:0];
            [dropDownView setBtnTextColor:[UIColor redColor] section:0];
            
            [self getAreaCodeRequestWithCode:cityModel.strAreaCode];
            
            if (index) {
                isSelectArea = YES;
            }

        }
    }
    else if (sectionNum == 1) {
        
        if(marrDatasource.count <= index) {
            return ;
        }
        GYGoodCategoryModel* CategoryLevelOne = marrDatasource[index];
        categoryIdString = CategoryLevelOne.strCategoryId;
        
        DDLogDebug(@"%@-------categoryid", CategoryLevelOne.strCategoryId);

        if ([CategoryLevelOne.strCategoryId isEqualToString:@"1004"]) {
            [marrEasyBuySource addObjectsFromArray:tempArray];
            FDMainViewController* vc = [[FDMainViewController alloc] init];

            [self.navigationController pushViewController:vc animated:YES];

            if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {

                [_delegate hidenBackgroundView];
            }
        }
        else if ([CategoryLevelOne.strCategoryId isEqualToString:@"1005"]) {
            [marrEasyBuySource addObjectsFromArray:tempArray];

            FDTakeawayMainViewController* vc = [[FDTakeawayMainViewController alloc] init];

            [self.navigationController pushViewController:vc animated:YES];

            if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {

                [_delegate hidenBackgroundView];
            }
        }

        strLevelOneCategory = CategoryLevelOne.strCategoryId;
        marrCategoryLevelTwo = [NSMutableArray arrayWithArray:CategoryLevelOne.marrSubCategory];
        for (GYGoodCategoryModel* model in marrCategoryLevelTwo) {
            [marrLevelTwoTitle addObject:model.strCategoryTitle];
        }
    }
    [self addTempTableView];
}


#pragma mark DropDownWithChildChooseDataSource
- (NSInteger)numberOfSections
{
    return [chooseArray count];
}

//返回的多选列表总共有多少项。
- (NSInteger)multipleChoiceCount
{
    NSInteger arrCount = [chooseArray count];
    return [chooseArray[arrCount - 1] count];
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (section >= 0) {

        // modify by songjk arry改成对应的section
        NSArray* arry = chooseArray[section];
        if (arry.count > 0) {
            return [arry count];
        }
    }
    return 1;
}

- (NSString*)titleInSection:(NSInteger)section index:(NSInteger)index
{
    // modify by songjk arry改成对应的section
    if (section == 0 && index == 0) {
        return kLocalized(@"GYHE_SurroundVisit_Near");
    }
    if (chooseArray.count > section) {
        NSArray* arry = chooseArray[section];
        if (arry.count > index) {
            return arry[index];
        }
    }
    return @"";
}

- (NSInteger)defaultShowSection:(NSInteger)section
{
    return 0;
}

//用于选择sorttype回调
- (void)didSelectedOneShow:(NSString*)title WithIndexPath:(NSIndexPath*)indexPath WithCurrentSection:(NSInteger)sectionNumber
{
    DDLogDebug(@"didSelectedOneShow----title = %@ sectionNum = %zi", title, sectionNumber);
    
    currentPage = 1;
    if (marrEasyBuySource.count > 0) {
        [marrEasyBuySource removeAllObjects];
    }
    
    if (sectionNumber == 2) {
        
        if(marrSortType.count > indexPath.row) {
            GYSortTypeModel* sortTypeMod = marrSortType[indexPath.row];
            sortType = sortTypeMod.strSortType.integerValue;
            
            [tvEasyBuy.mj_header beginRefreshing];

        }
        
    }
    if (sectionNumber == 3) {
        
        if(marrSeveceSType.count > indexPath.row) {
            GYSortTypeModel* sortTypeMod2 = marrSeveceSType[indexPath.row];
            
            if ([sortTypeMod2.strTitle isEqualToString:kLocalized(@"GYHE_SurroundVisit_SellerService")]) {
                
                sortTypeMod2.strTitle = @"";
            }
            
            [supportService addObject:sortTypeMod2.strTitle];
        }
        
    }
}


#pragma mark tableView代理
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        return marrCategoryLevelTwo.count;
    }
    return marrEasyBuySource.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView.tag == 100) {
        return 40;
    }
    return 90;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cellID";
    static NSString* cellIdentiferForTemp = @"TempCell";
    if (tableView.tag == 100) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForTemp];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentiferForTemp];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.textColor = kCellItemTitleColor;
        //section对应的数据源是不同的，需要分别取出
        switch (sectionNum) {
        case 0: {
            if(marrCategoryLevelTwo.count > indexPath.row) {
                GYAreaCodeModel* model = marrCategoryLevelTwo[indexPath.row];
                cell.textLabel.text = model.locationName;
            }
            
            if (marrCategoryLevelTwo.count <= 0) {
                cell.textLabel.text = kLocalized(@"GYHE_SurroundVisit_AllCity");
            }
        } break;
        case 1: {
            if(marrCategoryLevelTwo.count > indexPath.row) {
                GYGoodCategoryModel* categoryMod = marrCategoryLevelTwo[indexPath.row];
                cell.textLabel.text = categoryMod.strCategoryTitle;
            }
            
            
        } break;
        default:
            break;
        }
        if(indexPath.row == 0) {
            cell.textLabel.textColor = [UIColor redColor];
        }else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }

    GYShowShopsCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (marrEasyBuySource.count > 0) {

        ShopModel* model = marrEasyBuySource[indexPath.row];
        cell.shopCallImageView.userInteractionEnabled = YES;

        [cell refreshUIWith:model];

        cell.telBtn.tag = indexPath.row + 1234;

        [cell.telBtn addTarget:self action:@selector(phoneNumberCall:) forControlEvents:UIControlEventTouchUpInside];
    }

    return cell;
}

//用于隐藏分割线
- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didSelectedOneShow:(NSString*)title WithIndexPath:(NSIndexPath*)indexPath
{
    currentPage = 1;
    if (marrEasyBuySource.count > 0) {
        [marrEasyBuySource removeAllObjects];
    }
    if(marrSortType.count > indexPath.row) {
        GYSortTypeModel* sortTypeMod = marrSortType[indexPath.row];
        sortType = sortTypeMod.strSortType.integerValue;
        // modify by songjk
        [tvEasyBuy.mj_header beginRefreshing];
    }
    

}


// 选中上面分类的二级菜单
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == tempTv) {

        switch (sectionNum) {
        case 0: {

            GYAreaCodeModel* Areamodel = marrCategoryLevelTwo[indexPath.row];
            // add by songjk
            sectionString = Areamodel.locationName;

            [dropDownView setBtnText:sectionString section:0];

            NSString* strSection = sectionString;
            if (marrArea && marrArea.count > indexNumber) {

                GYCityInfo* cityModel = marrArea[indexNumber];
                areaString = cityModel.strAreaName; // 当选择二级选项的时候才更改记录地区
                if ([Areamodel.areaId isEqualToString:@"-1"]) { // 全部的时候显示上一个分类标题

                    GYCityInfo* cityModel = marrArea[indexNumber];
                    strSection = cityModel.strAreaName;
                    if (indexNumber == 0) {

                        strSection = kLocalized(@"GYHE_SurroundVisit_AllCity");
                        _distance = @"";
                        areaString = @"";
                        sectionString = @"";
                    }
                    _distance = @"";
                }
            }
            if (_delegate && [_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                isAdd = YES;
                currentPage = 1;
                if (indexPath.row == 0) {
                    // modify by songjk
                    if (isSelectArea) {
                        [dropDownView setBtnText:areaString section:0];
                        isSelectArea = NO;
                    }
                    [tvEasyBuy.mj_header beginRefreshing];

                }
                else {
                    //                        self.title=Areamodel.locationName; by songjk 不修改页面名称

                    if ([sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_500Meters")] ||
                        [sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within1km")] ||
                        [sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within3km")] ||
                        [sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within5km")] ||
                        [sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within10km")]) {

                        DDLogDebug(@"%@", sectionString);
                        if ([sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_500Meters")]) {

                            _distance = @"0.5";
                        }
                        else if ([sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within1km")]) {

                            _distance = @"1";
                        }
                        else if ([sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within3km")]) {

                            _distance = @"3";
                        }
                        else if ([sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within5km")]) {

                            _distance = @"5";
                        }
                        else if ([sectionString isEqualToString:kLocalized(@"GYHE_SurroundVisit_Within10km")]) {

                            _distance = @"10";
                        }

                        sectionString = @"";
                        areaString = @"";
                    }
                    else {

                        _distance = @"";
                    }
                    if (isSelectArea) {
                        [dropDownView setBtnText:sectionString section:0];
                        isSelectArea = NO;
                    }
                    [tvEasyBuy.mj_header beginRefreshing];

                }

                [_delegate chooseRowWith:strSection WithSection:sectionNum WithTableView:tempTv];
            }
        } break;
        case 1: {
            if (marrEasyBuySource.count > 0) {
                [marrEasyBuySource removeAllObjects];
            }
            if(marrCategoryLevelTwo.count <= indexPath.row) {
                return ;
            }
            currentPage = 1;
            GYGoodCategoryModel* categoryMod = marrCategoryLevelTwo[indexPath.row];
            // add by songjk // 全部的时候显示上一个分类标题
            NSString* name = categoryMod.strCategoryTitle;

            if ([categoryMod.strCategoryId isEqualToString:@"-1"]) {
                if(marrDatasource.count > indexNumber) {
                    GYGoodCategoryModel* CategoryLevelOne = marrDatasource[indexNumber];
                    name = CategoryLevelOne.strCategoryTitle;
                }
                
            }
            if (indexPath.row == 0) {
                categoryIdString = strLevelOneCategory;
            }
            else {
                categoryIdString = categoryMod.strCategoryId;
            }
            // modify by songjk
            [tvEasyBuy.mj_header beginRefreshing];
            
            if (_delegate && [_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                //self.title=name;
                self.title = kLocalized(@"GYHE_SurroundVisit_LookOverShops");
                [_delegate chooseRowWith:name WithSection:sectionNum WithTableView:tempTv];
            }
        } break;
        default:
            break;
        }
    }
    else {
        if (marrEasyBuySource.count > indexPath.row) {
            ShopModel* model = marrEasyBuySource[indexPath.row];

            GYShopDescribeController* vc = [[GYShopDescribeController alloc] init];

            vc.currentMp1 = mp1;
            vc.shopModel = model;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

    CGFloat offHeight = scrollView.contentOffset.y;

    if (scrollView == tvEasyBuy) {

        if (offHeight > kScreenHeight / 2) {
            _backTopBtn.hidden = NO;
        }
        else {

            _backTopBtn.hidden = YES;
        }

    }

}


#pragma mark 点击事件

//搜索商铺
- (void)searchAction {
    
    GYEasybuySearchMainController *vcSearch = [[GYEasybuySearchMainController alloc] init];
    vcSearch.searchType = kGoods;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:NO];
}

//打电话
- (void)phoneNumberCall:(UIButton *)sender {
    NSInteger index = sender.tag-1234;
    
    if(marrEasyBuySource.count > index) {
        ShopModel *model = marrEasyBuySource[index];
        
        if (model.strShopTel.length > 0) {
            [GYUtils callPhoneWithPhoneNumber:model.strShopTel showInView:self.view];
        }
    }
    
    
}


-(void)refreshSearchShopsData
{
        NSString* strSpecialService = [supportService componentsJoinedByString:@","];
        specialService = strSpecialService;
        currentPage = 1;
        if (supportService && supportService.count > 0) {
            NSString* textString = [supportService lastObject];
            if (supportService.count > 1) {
                textString = [textString stringByAppendingString:@"..."];
            }
            [dropDownView setBtnText:textString section:3];
        }
        else {
            [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
            [dropDownView setBtnTextColor:[UIColor blackColor] section:3];
        }
        if (sortType == 5) {

            [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SendTicketGood") section:3];
        }
    [tvEasyBuy.mj_header beginRefreshing];
}


- (void)ConfirmAction:(UIButton*)sender
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        
        NSString* strSpecialService = [supportService componentsJoinedByString:@","];
        
        //        strSpecialService=strSpecialService;
        specialService = strSpecialService;
        currentPage = 1;
        
        if (supportService && supportService.count > 0) {
            NSString* textString = [supportService lastObject];
            if (supportService.count > 1) {
                textString = [textString stringByAppendingString:@"..."];
            }
            [dropDownView setBtnText:textString section:3];
        }
        else {
            [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
            [dropDownView setBtnTextColor:[UIColor blackColor] section:3];
        }
        if (sortType == 5) {
            
            [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SendTicketGood") section:3];
        }
        
        [_delegate hidenBackgroundView];
    }
    [tvEasyBuy.mj_header beginRefreshing];
}


#pragma mark 自定义方法
// 获取商铺列表
- (void)loadListDataFromNetwork:(NSString*)categoryId WithSectionCode:(NSString*)sectionTitle WithSortType:(NSString*)sortTypeString Witharea:(NSString*)areaTitle
{
    // add by songjk
    if ([sectionTitle isEqualToString:kLocalized(@"GYHE_SurroundVisit_All")]) {
        sectionTitle = @"";
        
        //        areaTitle=@"";
    }
    
    NSString* tempSpecialService = nil;
    if (specialService && specialService.length > 0) {
        
        if ([specialService rangeOfString:kLocalized(@"GYHE_SurroundVisit_SendTicketGood")].location != NSNotFound) {
            
            _hasCoupon = @"1";
            
            NSArray* newArr = [specialService componentsSeparatedByString:@","];
            
            NSMutableArray* tempArr = [NSMutableArray arrayWithArray:newArr];
            
            [tempArr removeObject:kLocalized(@"GYHE_SurroundVisit_SendTicketGood")];
            
            //specialService = [tempArr componentsJoinedByString:@","];
            tempSpecialService = [tempArr componentsJoinedByString:@","];
        }
        else {
            tempSpecialService = specialService;
            _hasCoupon = @"";
        }
    }
    else {
        
        _hasCoupon = @"";
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:cityString forKey:@"city"];
    [dict setValue:areaTitle forKey:@"area"];
    [dict setValue:sectionTitle forKey:@"section"];
    [dict setValue:[NSString stringWithFormat:@"%zi", pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%zi", currentPage] forKey:@"currentPage"];
    [dict setValue:categoryId forKey:@"categoryId"];
    [dict setValue:[NSString stringWithFormat:@"%@", sortTypeString] forKey:@"sortType"];
    if (globalData.selectedCityCoordinate) {
        [dict setValue:globalData.selectedCityCoordinate forKey:@"location"];
    }
    else {
        
        [dict setValue:[NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude] forKey:@"location"];
    }
    
    [dict setValue:kSaftToNSString(tempSpecialService) forKey:@"supportService"];
    [dict setValue:_distance forKey:@"distance"];
    
    [dict setValue:_hasCoupon forKey:@"hasCoupon"];
    
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetTopicListUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        [GYGIFHUD dismiss];
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    //    添加尾部刷新
                    
                    GYRefreshFooter *footer = [GYRefreshFooter footerWithRefreshingBlock:^{
                        
                        [self footerRereshing];
                        
                    }];
                    
                    
                    
                    tvEasyBuy.mj_footer = footer;
                    
                    totalCount = [ResponseDic [@"rows"] integerValue];
                    tvEasyBuy.backgroundView.hidden = YES;
                    totalPage = [ResponseDic [@"totalPage"] integerValue];
                    
                    //用来控制 从城市列表选择城市后需要删除数据源，重新刷新tableview
                    if (isAdd) {
                        isAdd = NO;
                        if (marrEasyBuySource.count > 0) {
                            [marrEasyBuySource removeAllObjects];
                        }
                    }
                    NSMutableArray *dataSource = [NSMutableArray array];
                    for (NSDictionary *tempDic in ResponseDic[@"data"]) {
                        ShopModel *model = [[ShopModel alloc] init];
                        model.strShopId = kSaftToNSString(tempDic[@"id"]);// 之前是id
                        model.strVshopId = kSaftToNSString(tempDic[@"vShopId"]);
                        model.strShopAddress = tempDic[@"addr"];
                        model.strLongitude = tempDic[@"longitude"];
                        model.strLat = tempDic[@"lat"];
                        model.strShopName = tempDic[@"name"];
                        model.strShopTel = tempDic[@"tel"];
                        model.strShopPictureURL = tempDic[@"url"];
                        model.strRate = kSaftToNSString(tempDic[@"rate"]);
                        model.strCompanyName = [NSString stringWithFormat:@"%@", tempDic[@"companyName"]];
                        model.strResno = kSaftToNSString(tempDic[@"resno"]);
                        
                        model.beCash = kSaftToNSString([tempDic[@"beCash"] stringValue]);
                        model.beReach = kSaftToNSString([tempDic[@"beReach"] stringValue]);
                        model.beSell = kSaftToNSString([tempDic[@"beSell"] stringValue]);
                        model.beTake = kSaftToNSString([tempDic[@"beTake"] stringValue]);
                        model.beQuan = kSaftToNSString([tempDic[@"beQuan"] stringValue]);
                        model.pointsProportion = kSaftToNSString(tempDic[@"pointsProportion"]);
                        
                        model.section = tempDic[@"section"];
                        
                        model.categoryNames = tempDic[@"categoryNames"];
                        
                        // modify by songjk 地址距离改成取字段：dist
                        if ([[tempDic allKeys] containsObject:@"dist"]) {
                            model.shopDistance = kSaftToNSString(tempDic[@"dist"]);
                        } else {
                            CLLocationCoordinate2D shopCoordinate;
                            shopCoordinate.latitude = model.strLat.doubleValue;
                            shopCoordinate.longitude = model.strLongitude.doubleValue;
                            BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                            mp1 = BMKMapPointForCoordinate(globalData.locationCoordinate);
                            CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                            model.shopDistance = [NSString stringWithFormat:@"%.02f", dis/1000];
                        }
                        if (isUpFresh) {
                            [dataSource addObject:model];
                        } else {
                            [marrEasyBuySource addObject:model];
                        }
                    }
                    if (isUpFresh) {
                        marrEasyBuySource = dataSource;
                    }
                    
                    [tvEasyBuy reloadData];
                    currentPage += 1;
                    if (currentPage <= totalPage) {
                        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                        [tvEasyBuy.mj_header endRefreshing];
                        [tvEasyBuy.mj_footer endRefreshing];
                    } else {
                        [tvEasyBuy.mj_header endRefreshing];
                        [tvEasyBuy.mj_footer endRefreshing];
                        [tvEasyBuy.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
                    }
                    
                    if ([ResponseDic[@"data"] isKindOfClass:([NSArray class])] && ![ResponseDic[@"data"]  count] > 0) {
                        tvEasyBuy.mj_footer.hidden = YES;
                        
                        UIView *background = [[UIView alloc] initWithFrame:tvEasyBuy.frame];
                        UILabel *lbTips = [[UILabel alloc] init];
                        lbTips.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 + 60 );
                        lbTips.textColor = kCellItemTitleColor;
                        lbTips.textAlignment = NSTextAlignmentCenter;
                        lbTips.font = [UIFont systemFontOfSize:14.0];
                        lbTips.backgroundColor = [UIColor clearColor];
                        lbTips.bounds = CGRectMake(15, 0, kScreenWidth - 30, 40);
                        lbTips.text = kLocalized(@"GYHE_SurroundVisit_SorryNoShopsData");
                        
                        UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                        imgvNoResult.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 );
                        imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                        [background addSubview:imgvNoResult];
                        
                        [background addSubview:lbTips];
                        tvEasyBuy.backgroundView = background;
                    }
                    
                } else if ([retCode isEqualToString:@"201"]) {
                    if (marrEasyBuySource.count > 0) {
                        [marrEasyBuySource removeAllObjects];
                    }
                    [tvEasyBuy reloadData];
                    [tvEasyBuy.mj_header endRefreshing];
                    tvEasyBuy.mj_footer.hidden = YES;
                    
                    UIView *background = [[UIView alloc] initWithFrame:tvEasyBuy.frame];
                    UILabel *lbTips = [[UILabel alloc] init];
                    lbTips.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 + 60);
                    lbTips.textColor = kCellItemTitleColor;
                    lbTips.textAlignment = NSTextAlignmentCenter;
                    lbTips.font = [UIFont systemFontOfSize:14.0];
                    lbTips.backgroundColor = [UIColor clearColor];
                    lbTips.bounds = CGRectMake(15, 0, kScreenWidth - 30, 40);
                    lbTips.text = kLocalized(@"GYHE_SurroundVisit_SorryNoShopsData");
                    
                    UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
                    imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    [background addSubview:lbTips];
                    tvEasyBuy.backgroundView = background;
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    [request start];
}

- (void)addTopSelectView
{
    if (marrSortTtile.count > 0 && marrCategoryLevelOne.count > 0 && marrSortTtile.count > 0 && marrSeveceTitle.count > 0) {
        chooseArray = [NSMutableArray arrayWithArray:@[
                                                       marrAreaTitle,
                                                       marrCategoryLevelOne,
                                                       marrSortTtile,
                                                       
                                                       marrSeveceTitle
                                                       ]];
        
        dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) dataSource:self delegate:self WithUseType:surroundGoodsType WithOther:[NSNumber numberWithBool:self.FromBottomType]];
        
        //传到弹出视图是否为抵扣卷页面入口
        dropDownView.typeNumber = sortType;
        
        dropDownView.mSuperView = self.view;
        dropDownView.deleteTableview = self;
        dropDownView.dropDownDataSource = self;
        [dropDownView.BtnConfirm addTarget:self action:@selector(ConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        dropDownView.fromSurroundShopBottom = self.FromBottomType;
        dropDownView.has = YES;
        _delegate = dropDownView;
        [self.view addSubview:dropDownView];
        
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_Near") section:0];
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_Sort") section:2];
        [dropDownView setBtnText:[titleName isEqualToString:kLocalized(@"GYHE_SurroundVisit_Near")] ? kLocalized(@"GYHE_SurroundVisit_Category") : titleName section:1];
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
    }
    if (sortType == 5) {
        
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SendTicketGood") section:3];
    }
}

- (void)reloadDropViewDatasource
{
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   marrAreaTitle,
                                                   marrCategoryLevelOne,
                                                   marrSortTtile,
                                                   
                                                   marrSeveceTitle
                                                   ]];
    
    [dropDownView reloadDatasoureArray:chooseArray];
    
    [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_Near") section:0];
    [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_Sort") section:2];
    [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
    
    if (sortType == 5) {
        
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SendTicketGood") section:3];
    }
}

// add by songjk 获取位置信息
- (void)setupLocationInfo
{
    GlobalData* data = globalData;
    if (data.selectedCityName == nil) {
        [GYGIFHUD dismiss];
        currentLocation = data.locationCoordinate;
        mp1 = BMKMapPointForCoordinate(currentLocation);
        
        NSString* title = data.locationCity;
        if (title.length > 0) {
            if ([title hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
                title = [title substringToIndex:title.length - 1];
            }
            
            if ([data.locationCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_CityAndArea")]) {
                NSRange range = [data.locationCity rangeOfString:kLocalized(@"GYHE_SurroundVisit_City")];
                if (range.location != NSNotFound) {
                    title = [data.locationCity substringToIndex:range.location];
                }
            }
            cityString = title;
        }
        [self getCity:data.locationCity WithType:0];
        
        [tvEasyBuy.mj_header beginRefreshing];
    }
    else {
        currentLocation = data.locationCoordinate;
        mp1 = BMKMapPointForCoordinate(currentLocation);
        [marrAreaTitle removeAllObjects];
        cityString = data.selectedCityName;
        [self getCity:data.selectedCityName WithType:0];
        NSString* title = cityString;
        if ([cityString hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            title = [cityString substringToIndex:cityString.length - 1];
        }
        
        [tvEasyBuy.mj_header beginRefreshing];
    }
}

//顶端的横条显示内容
- (void)loadTopDataFromNetwork
{
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:ShopColumnClassifyUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            if (!error) {
                
                NSString *str = [NSString stringWithFormat:@"%@", [ResponseDic objectForKey:@"retCode"]];
                if ([str isEqualToString:@"200"]) {
                    NSArray *arrtest = [ResponseDic objectForKey:@"data"];
                    for (NSDictionary *Dic1 in arrtest) {
                        GYGoodCategoryModel *model1 = [[GYGoodCategoryModel alloc] init];
                        model1.strCategoryTitle = [Dic1 objectForKey:@"name"];
                        model1.strCategoryId = [Dic1 objectForKey:@"id"];
                        for (NSDictionary *Dic2 in [Dic1 objectForKey:@"categories"]) {
                            GYGoodCategoryModel *model2 = [[GYGoodCategoryModel alloc] init];
                            model2.strCategoryTitle = [Dic2 objectForKey:@"name"];
                            model2.strCategoryId = [Dic2 objectForKey:@"id"];
                            [model1.marrSubCategory addObject:model2];
                        }
                        [marrDatasource addObject:model1];
                        [marrCategoryLevelOne addObject:model1.strCategoryTitle];
                    }
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        // songjk 应该是先去SortTyp
        //        [self getAreaCode];
        [self getSortTypeSeveceData];
    }];
    [request start];
}

- (void)getAreaCodeRequestWithCode:(NSString*)code
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:code forKey:@"areaCode"];
    
    [GYGIFHUD show];
    
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetLocationUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    [marrCategoryLevelTwo removeAllObjects];
                    for (NSDictionary *tempDict in ResponseDic[@"data"]) {
                        GYAreaCodeModel *model = [[GYAreaCodeModel alloc] init];
                        model.areaId = kSaftToNSString(tempDict[@"areaId"]);
                        model.areaName = kSaftToNSString(tempDict[@"areaName"]);
                        model.idString = kSaftToNSString(tempDict[@"id"]);
                        model.locationName = kSaftToNSString(tempDict[@"locationName"]);
                        model.sortOreder = kSaftToNSString(tempDict[@"sortOrder"]);
                        [marrCategoryLevelTwo addObject:model];
                    }
                    
                    
                    [self addTempTableView];
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    request.cacheTimeInSeconds = 3600;
    [request start];
}

//  卖家服务
- (void)getSortTypeSeveceData
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:SortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            if (!error) {
                
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                
                if ([retCode isEqualToString:@"200"]) {
                    
                    for (NSDictionary *dict in ResponseDic[@"data"]) {
                        GYSortTypeModel *sortTypeMod = [[GYSortTypeModel alloc] init];
                        sortTypeMod.strSortType = [NSString stringWithFormat:@"%@", dict[@"sortType"]];
                        sortTypeMod.strTitle = [NSString stringWithFormat:@"%@", dict[@"title"]];
                        [marrSeveceTitle addObject:sortTypeMod.strTitle];//注意两个数据的关系，取值是别混淆
                        
                        [marrSeveceSType addObject:sortTypeMod];//排序类型
                        
                    }
                    
                }
                
            }
            
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        [self getSortTypeData];
    }];
    [request start];
}

//逛商铺  排序
- (void)getSortTypeData
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:ShopSortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            if (!error) {
                NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                if ([retCode isEqualToString:@"200"]) {
                    for (NSDictionary *dict in ResponseDic[@"data"]) {
                        GYSortTypeModel *sortTypeMod = [[GYSortTypeModel alloc] init];
                        sortTypeMod.strSortType = [NSString stringWithFormat:@"%@", dict[@"sortType"]];
                        sortTypeMod.strTitle = [NSString stringWithFormat:@"%@", dict[@"title"]];
                        [marrSortTtile addObject:sortTypeMod.strTitle];
                        [marrSortType addObject:sortTypeMod];
                    }
                    [self addTopSelectView];
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        [self setupLocationInfo];
    }];
    [request start];
}


//开始进入刷新状态
- (void)headerRereshing
{
    currentPage = 1;
    isUpFresh = YES;
    
    [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%zi", sortType] Witharea:areaString];
}

- (void)footerRereshing
{
    isUpFresh = NO;
    if (currentPage <= totalPage) {
        // modify by songjk
        [self loadListDataFromNetwork:categoryIdString WithSectionCode:sectionString WithSortType:[NSString stringWithFormat:@"%zi", sortType] Witharea:areaString];
    }
}

- (void)ToCityVC
{
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        [_delegate hidenBackgroundView];
    }
    GYCitySelectViewController* vcCitySelection = [[GYCitySelectViewController alloc] initWithNibName:NSStringFromClass([GYCitySelectViewController class]) bundle:nil];
    
    vcCitySelection.delegate = self;
    //
    vcCitySelection.navigationItem.title = cityString;
    
    [self.navigationController pushViewController:vcCitySelection animated:YES];
}

//设置导航栏
- (void)setNav
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = kLocalized(@"GYHE_SurroundVisit_LookOverShops");
    
    UIButton* butn = [UIButton buttonWithType:UIButtonTypeCustom];
    butn.frame = CGRectMake(0, 0, 20, 25);
    [butn setImageEdgeInsets:UIEdgeInsetsMake(2, 3, 0, 3)];
    [butn setImage:[UIImage imageNamed:@"gyhe_shoping_gps"] forState:UIControlStateNormal];
    [butn addTarget:self action:@selector(GPSAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rBBIFirst = [[UIBarButtonItem alloc] initWithCustomView:butn];
    
    UIButton* lebutn = [UIButton buttonWithType:UIButtonTypeCustom];
    lebutn.frame = CGRectMake(0, 0, 20, 20);
    [butn setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    [lebutn setImage:[UIImage imageNamed:@"gyhe_search_white"] forState:UIControlStateNormal];
    [lebutn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rBBISecond = [[UIBarButtonItem alloc] initWithCustomView:lebutn];
    
    self.navigationItem.rightBarButtonItems = @[ rBBISecond, rBBIFirst ];
}


- (void)updateByLocation
{
    
    cityString = globalData.selectedCityName;
    
    [self getCity:cityString WithType:1];
}

- (void)reloadNetworkData
{
    [super reloadNetworkData];
    if (globalData.isOnNet) {
        [self loadTopDataFromNetwork];
        [self dismissNoNetworkView];
    }
}

- (void)addTempTableView
{
    
    CGFloat width = self.view.frame.size.width / [chooseArray count];
    if (marrCategoryLevelTwo.count > 0) {
        
        if (tempTv == nil) {
            tempTv = [[UITableView alloc] init];
            tempTv.tag = 100;
            tempTv.delegate = self;
            tempTv.dataSource = self;
        }
        if ([tempTv respondsToSelector:@selector(setSeparatorInset:)]) {
            [tempTv setSeparatorInset:UIEdgeInsetsZero];
        }
        
        CGFloat maxHeight = kScreenHeight - 64 - 40;
        CGFloat height = 40 * marrCategoryLevelTwo.count;
        height = height < maxHeight ? height : maxHeight;
        if (useType == 1) {
            tempTv.frame = CGRectMake(140, 40, self.view.frame.size.width - width, height);
        }
        else {
            tempTv.frame = CGRectMake(140, 40, self.view.frame.size.width - width, height);
        }
        tempTv.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:tempTv];
    }
    [tempTv reloadData];
}

- (void)deleteTableviewInSectionOne
{
    if (tempTv) {
        [tempTv removeFromSuperview];
        [self headerRereshing];
    }
    
}

//添加附近
- (void)makeAroundDistanceChoose
{
    NSArray* arrAround = @[ kLocalized(@"GYHE_SurroundVisit_AllCitys"), kLocalized(@"GYHE_SurroundVisit_500Meters"), kLocalized(@"GYHE_SurroundVisit_Within1km"), kLocalized(@"GYHE_SurroundVisit_Within3km"), kLocalized(@"GYHE_SurroundVisit_Within5km"), kLocalized(@"GYHE_SurroundVisit_Within10km") ];
    NSMutableArray* marr = [NSMutableArray array];
    for (int i = 0; i < arrAround.count; i++) {
        
        GYAreaCodeModel* model = [[GYAreaCodeModel alloc] init];
        model.areaName = arrAround[i];
        model.locationName = arrAround[i];
        if (i == 0) {
            model.areaId = @"-1";
        }
        else {
            model.areaId = @"000";
        }
        [marr addObject:model];
    }
    marrCategoryLevelTwo = [marr mutableCopy];
    [self addTempTableView];
}

//GPS定位
- (void)GPSAction {
    
    GYAroundLocationChooseController *vcSearch = [[GYAroundLocationChooseController alloc] init];
    
    vcSearch.delegate = self;
    
    vcSearch.block = ^(){
        
        
        [self headerRereshing];
        
    };
    [self.navigationController pushViewController:vcSearch animated:YES];
    
}


- (void)backTop
{
    
    _backTopBtn.hidden = YES;
    
    tvEasyBuy.contentOffset = CGPointMake(0, 0);
}


#pragma mark 懒加载


- (NSMutableDictionary*)mdictArea
{
    if (!_mdictArea) {
        _mdictArea = [NSMutableDictionary dictionary];
    }
    return _mdictArea;
}


@end
