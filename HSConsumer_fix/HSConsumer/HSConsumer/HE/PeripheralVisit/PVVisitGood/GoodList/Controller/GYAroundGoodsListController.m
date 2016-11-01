//
//  GYAroundGoodsListController.m
//  HSConsumer
//
//  Created by Apple03 on 15/11/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundGoodsListController.h"
#import "GYEasyBuyModel.h"
#import "GYArroundGoodDetailViewController.h"
#import "DropDownWithChildListView.h"
#import "GYGoodCategoryModel.h"
#import "GYSortTypeModel.h"
#import "GYCitySelectViewController.h"
#import "GYCityInfo.h"
#import "GYAreaCodeModel.h"
#import "GYGIFHUD.h"
#import "GYAroundGoodsListCell.h"
#import "GYEasybuySearchMainController.h"
#import "GYAppDelegate.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#define pageCount 10
#define goodlbNameHeight 30
#define shoplbNameHeight 22
#define addresslbHeight 26
#define kGYHistory @"GYhistory"

// add by songjk 是否已经加载第一次进入是筛选项
static BOOL bRun = NO;

@interface GYAroundGoodsListController () <selectCity, UITableViewDataSource, UITableViewDelegate, DropDownWithChildChooseDataSource, DropDownWithChildChooseDelegate, deleteTableviewInSectionOne, GYAroundGoodsListCellDelegate>
@property (nonatomic, copy) NSString* hasCoupon;

// add songjk 是否进入无数据页面
@property (nonatomic, assign) BOOL isShowNoData;
@property (nonatomic, strong) NSArray* arrAround;
@property (nonatomic, strong) NSArray* arrAroundData;
@end

@implementation GYAroundGoodsListController {
    UITableView* tvEasyBuy;
    NSMutableArray* marrEasyBuySource;
    NSMutableArray* chooseArray;
    NSArray* arr;
    NSInteger sectionNumber;
    NSInteger indexNumber; // 记录第一级菜单位置
    UITableView* tempTv;
    CLLocationCoordinate2D currentLocation;
    NSMutableArray* marrCategoryLevelOne;
    NSMutableArray* marrDatasource;
    NSMutableArray* marrLevelTwoTitle;
    NSMutableArray* marrCategoryLevelTwo;
    NSString* strCity;

    NSMutableArray* marrSortType;
    NSMutableArray* marrSortTtile;
    NSInteger sortType;

    NSMutableArray* marrSortName;
    NSMutableArray* marrSortNameTtile;

    BMKMapPoint mp1;

    //    UIButton * btnRight;
    NSMutableArray* marrArea;
    NSMutableArray* marrAreaTitle;

    NSString* categoryIdString;
    NSString* areaString; // 商圈
    // add by songjk
    NSString* sectionString; // 城市里面的位置
    NSString* strProvince; // add by songjk 省
    NSString* specialService;
    NSMutableArray* marrSpecialService;
    // add by songjk
    NSMutableArray* marrFirstSpecialService;
    DropDownWithChildListView* dropDownView;

    int currentPage; //当前页码

    int totalCount; //总个数

    BOOL isUpFresh;

    BOOL isAppend;

    UIButton* _backTopBtn; //返回顶部按钮
    NSMutableArray* mTitleArray;

    //    BOOL isSelectArea;//YES选择为区   NO选择为距离
}

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSearchShopsData) name:@"NSSearchShopsDidRefreshDataNotification" object:nil];

    mTitleArray = [NSMutableArray array];
    bRun = NO;
    marrEasyBuySource = [NSMutableArray array];
    categoryIdString = self.modelCommins.uid;
    sectionString = @"";
    specialService = @"";
    if (self.strSpecialService.length > 0) {
        specialService = self.strSpecialService;
        // add by songjk
        marrFirstSpecialService = [NSMutableArray arrayWithArray:[specialService componentsSeparatedByString:@","]];
    }

    currentPage = 1;
    sortType = 1;
    areaString = @"";
    // songjk
    if (globalData.selectedCityName) {
        strCity = globalData.selectedCityName;
    }
    else {
        strCity = globalData.locationCity;
        strProvince = kLocalized(@"GYHE_SurroundVisit_GuangDong"); // add by songjk 默认是广东
    }

    marrSortTtile = [NSMutableArray array];
    marrDatasource = [NSMutableArray array];
    marrCategoryLevelOne = [NSMutableArray array];
    marrCategoryLevelTwo = [NSMutableArray array];
    marrLevelTwoTitle = [NSMutableArray array];
    marrSortName = [NSMutableArray array];
    marrSortNameTtile = [NSMutableArray array];
    marrArea = [NSMutableArray array];
    marrAreaTitle = [NSMutableArray array];
    marrSortType = [NSMutableArray array];
    marrSpecialService = [NSMutableArray array];

    /*
       btnRight =[UIButton buttonWithType:UIButtonTypeCustom];
       if (globalData.selectedCityName) {
        NSString* tempStrCity = globalData.selectedCityName;
        if ([tempStrCity hasSuffix: kLocalized(@"city")]) {
            tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length-1)];
        }
        [btnRight setTitle:tempStrCity forState:UIControlStateNormal];
       }
       else
        [btnRight setTitle:kLocalized(@"shenzhen")  forState:UIControlStateNormal];// modify by songjk 显示不带市
       btnRight.frame=CGRectMake(0, 0, 80, 40);
       [btnRight addTarget:self action:@selector(ToCityVC) forControlEvents:UIControlEventTouchUpInside];
       [btnRight setImage:[UIImage imageNamed:@"gyhe_down_tab.png"] forState:UIControlStateNormal];
       [btnRight setImageEdgeInsets:UIEdgeInsetsMake(16,62,15,5)];
       [btnRight setTitleEdgeInsets:UIEdgeInsetsMake(0, -btnRight.frame.size.width+32, 0, 5)];

       self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btnRight];
     */
    tvEasyBuy = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, kScreenHeight - 40 - 64)];
    tvEasyBuy.delegate = self;
    tvEasyBuy.dataSource = self;
    tvEasyBuy.showsHorizontalScrollIndicator = NO;
    tvEasyBuy.showsVerticalScrollIndicator = NO;
    [self.view addSubview:tvEasyBuy];
    [tvEasyBuy registerNib:[UINib nibWithNibName:@"GYFindShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];

    tvEasyBuy.tableFooterView = [[UIView alloc] init];

    if ([tvEasyBuy respondsToSelector:@selector(setSeparatorInset:)]) {

        [tvEasyBuy setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([tvEasyBuy respondsToSelector:@selector(setLayoutMargins:)]) {

        [tvEasyBuy setLayoutMargins:UIEdgeInsetsZero];
    }

    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    //    添加头部刷新
    //    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    //
    //        //        请求数据
    //        [self headerRereshing];
    //
    //    }];
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{

        //        请求数据
        [self headerRereshing];

    }];

    //单例 调用刷新图片

    tvEasyBuy.mj_header = header;

    //设置导航栏右边搜索按钮
    UIView* rBBI = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    UIButton* bt = [UIButton buttonWithType:UIButtonTypeCustom];
    [bt addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    bt.frame = rBBI.frame;
    UIImageView* images = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_search_white"]];
    images.frame = rBBI.frame;
    [rBBI addSubview:images];
    [rBBI addSubview:bt];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc] initWithCustomView:rBBI];
    self.navigationItem.rightBarButtonItem = bar;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reFreshLocation:) name:KChangeLocationNotice object:nil];

    self.arrAround = @[ kLocalized(@"GYHE_SurroundVisit_AllCitys"), kLocalized(@"GYHE_SurroundVisit_500Meters"), kLocalized(@"GYHE_SurroundVisit_Within1km"), kLocalized(@"GYHE_SurroundVisit_Within3km"), kLocalized(@"GYHE_SurroundVisit_Within5km"), kLocalized(@"GYHE_SurroundVisit_Within10km") ];
    self.arrAroundData = @[ @"", @"0.5", @"1", @"3", @"5", @"10", ];

    [GYGIFHUD show];
    [self loadTopDataFromNetwork];

    //      返回顶部按钮
    _backTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    GYAppDelegate* app = (GYAppDelegate*)[UIApplication sharedApplication].delegate;

    _backTopBtn.frame = CGRectMake(app.window.bounds.size.width - 35 / 2 - 40, app.window.bounds.size.height - 60 +5, 45, 45);

    [_backTopBtn setBackgroundImage:[UIImage imageNamed:@"gyhe_backtotop"] forState:0];

    [_backTopBtn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];

    _backTopBtn.hidden = YES;

    [app.window addSubview:_backTopBtn];
}

//视图消失时也应当关闭按钮
- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    [_backTopBtn removeFromSuperview];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}





#pragma mark DropDownWithChildChooseDelegate
//用于消除 多选项中选中的项目
- (void)mutableSelectRemoveObj:(NSIndexPath*)indexPath WithCurrentSectin:(NSInteger)sectionNumber
{
    if(marrSortType.count > indexPath.row) {
        GYSortTypeModel* sortTypeMod2 = marrSortType[indexPath.row];
        
        [marrSpecialService removeObject:sortTypeMod2.strSortType];
        
        [mTitleArray removeObject:sortTypeMod2.strTitle];
    }
    
}

//删除 tempTV的回调方法
- (void)deleteTableviewInSectionOne
{
    if (tempTv) {
        [tempTv removeFromSuperview];
        [self headerRereshing];
    }
}

//多选时用于 清除 多选项中得数据
- (void)btnTouch:(NSInteger)section
{
    if (section == 3) {
    }
    else {

        [marrSpecialService removeAllObjects];
    }
}
//点击 row 触发的回调方法
- (void)chooseAtSection:(NSInteger)section index:(NSInteger)index WithHasChild:(BOOL)has
{
    //section 就是btn的tag
    sectionNumber = section;
    indexNumber = index;
    if (marrCategoryLevelTwo.count > 0) {
        [marrCategoryLevelTwo removeAllObjects];
    }
    
    if (sectionNumber == 0 && index == 0) { //选取 附近
        sectionString = @""; // bill
        [self makeAroundDistanceChoose];
        return;
    }
    
    if (sectionNumber == 0) {
        
        if(marrArea.count > index) {
            GYCityInfo* cityModel = marrArea[index];
            sectionString = cityModel.strAreaName;
            [dropDownView setBtnText:sectionString section:0];
            
            [self getAreaCodeRequestWithCode:cityModel.strAreaCode];
        }
        
    }
    else if (sectionNumber == 2) {
        
        if(marrDatasource.count > index) {
            GYGoodCategoryModel* CategoryLevelOne = marrDatasource[index];
            categoryIdString = CategoryLevelOne.strCategoryId;
            [dropDownView setBtnText:CategoryLevelOne.strCategoryTitle section:2];
            [self getListDataWith:CategoryLevelOne.strCategoryId];
        }
        
    }
}



#pragma mark dropdownList DataSource
- (NSInteger)numberOfSections
{
    return [chooseArray count];
}

//返回的多选列表总共有多少项。
- (NSInteger)multipleChoiceCount
{
    NSInteger arrCount = [chooseArray count];
    if (arrCount > 0) {
        return [chooseArray[arrCount - 1] count];
    }
    return 0;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)section
{
    if (chooseArray.count > section) {
        NSArray* arry = chooseArray[section];
        return [arry count];
    }
    return 0;
}

- (NSString*)titleInSection:(NSInteger)section index:(NSInteger)index
{
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

- (void)didSelectedOneShow:(NSString*)title WithIndexPath:(NSIndexPath*)indexPath WithCurrentSection:(NSInteger)sectionNum
{

    switch (sectionNum) {
    case 1: {
        if(marrSortName.count > indexPath.row) {
            GYSortTypeModel* sortTypeMod1 = marrSortName[indexPath.row];
            sortType = sortTypeMod1.strSortType.integerValue;
            currentPage = 1;
            isUpFresh = YES;
            [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld", (long)sortType] WithSpecialService:specialService];
        }
        
    } break;
    case 3: {
        [mTitleArray addObject:title];

        if(marrSortType.count > indexPath.row) {
            GYSortTypeModel* sortTypeMod2 = marrSortType[indexPath.row];
            
            if ([sortTypeMod2.strTitle isEqualToString:kLocalized(@"GYHE_SurroundVisit_All")]) {
                sortTypeMod2.strSortType = @"";
            }
            [marrSpecialService addObject:sortTypeMod2.strSortType];
        }
        
    } break;
    default:
        break;
    }
}


#pragma mark GYAroundGoodsListCellDelegate
- (void)AroundGoodsListCellDidCallWithIndexPath:(NSIndexPath *)indexP {
    [self shopCallWithIndexPath:indexP];
}

#pragma mark 获取市的selectCity代理方法
- (void)getCity:(NSString*)CityTitle WithType:(int)type
{
    [marrAreaTitle removeAllObjects];
    NSString* tempStrCity = CityTitle;
    if ([tempStrCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
        tempStrCity = [tempStrCity substringToIndex:(tempStrCity.length - 1)];
    }
    
    // add by songjk 重置地区
    specialService = @"";
    sectionString = @"";
    areaString = @"";
    strCity = CityTitle;
    currentPage = 1;
    
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
            // add by songjk获取省
            [self getProvinceWithProviceCode:cityModel.strAreaParentCode];
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
    if (marrTempAreaTitle.count > 0) {
        marrArea = marrTempArea;
        marrAreaTitle = marrTempAreaTitle;
    }
    else {
        if ([CityTitle hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            [self getCity:tempStrCity WithType:0];
        }
    }
    //重新选择城市后，需要重新列出所对应的区，需要刷新 section 的数据源
    [self reloadDropViewDatasource];
    // modify by songjk 获得全部地区数据之后才去请求数据
    
    if (type == 1) {
        isAppend = YES;
        [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%zi", sortType] WithSpecialService:specialService];
    }
}

#pragma mark UIScrollViewDelegate

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
    
    
    return 110;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentiferForTemp = @"TempCell";
    if (tableView.tag == 100) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentiferForTemp];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentiferForTemp];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.textLabel.textColor = kCellItemTitleColor;
        }
        
        //section对应的数据源是不同的，需要分别取出
        switch (sectionNumber) {
            case 0: {
                if(marrCategoryLevelTwo.count > indexPath.row) {
                    GYAreaCodeModel* model = marrCategoryLevelTwo[indexPath.row];
                    cell.textLabel.text = model.locationName;
                }
                
                
            } break;
            case 2: {
                
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
    GYAroundGoodsListCell* GoodListCell = [GYAroundGoodsListCell cellWithTableView:tableView];
    if(marrEasyBuySource.count > indexPath.row) {
        SearchGoodModel* model = marrEasyBuySource[indexPath.row];
        GoodListCell.delegate = self;
        GoodListCell.indexPath = indexPath;
        [GoodListCell seCellWithModel:model];
    }
    return GoodListCell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == tempTv) {
        
        switch (sectionNumber) {
            case 0: {
                
                if(marrCategoryLevelTwo.count <= indexPath.row) {
                    return ;
                }
                GYAreaCodeModel* Areamodel = marrCategoryLevelTwo[indexPath.row];
                [dropDownView setBtnText:Areamodel.locationName section:0];
                
                isAppend = YES;
                areaString = [NSString stringWithFormat:@"%@", Areamodel.locationName];
                
                
                NSString* strSection = areaString;
                if ([Areamodel.areaId isEqualToString:@"-1"]) { // 全部的时候显示上一个分类标题
                    if(marrArea.count > indexNumber) {
                        GYCityInfo* cityModel = marrArea[indexNumber];
                        strSection = cityModel.strAreaName;
                        if (indexNumber == 0) {
                            strSection = kLocalized(@"GYHE_SurroundVisit_Near");
                        }
                    }
                    
                }
                currentPage = 1;
                [self loadListDataFromNetwork:categoryIdString WithAreaCode:Areamodel.locationName WithSortType:[NSString stringWithFormat:@"%ld", (long)sortType] WithSpecialService:specialService];
                if (_delegate && [_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                    
                    [_delegate chooseRowWith:strSection WithSection:sectionNumber WithTableView:tempTv];
                    
                }
                
            } break;
            case 2: {
                if(marrCategoryLevelTwo.count <= indexPath.row) {
                    return ;
                }
                GYGoodCategoryModel* categoryMod = marrCategoryLevelTwo[indexPath.row];
                categoryIdString = categoryMod.strCategoryId;
                currentPage = 1;
                // add by songjk // 全部的时候显示上一个分类标题
                NSString* name = categoryMod.strCategoryTitle;
                if (indexPath.row == 0 && marrDatasource.count > indexNumber) {
                    GYGoodCategoryModel* CategoryLevelOne = marrDatasource[indexNumber];
                    name = CategoryLevelOne.strCategoryTitle;
                }
                self.title = name;
                isAppend = YES;
                [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%ld", (long)sortType] WithSpecialService:specialService ];
                if (_delegate && [_delegate respondsToSelector:@selector(chooseRowWith:WithSection:WithTableView:)]) {
                    [_delegate chooseRowWith:name WithSection:sectionNumber WithTableView:tempTv];
                    
                }
                
            }
                break;
            default:
                break;
        }
        
        
    } else {
        
        GYArroundGoodDetailViewController *vcGoodDetail = [[GYArroundGoodDetailViewController alloc] initWithNibName:@"GYArroundGoodDetailViewController" bundle:nil];
        if(marrEasyBuySource.count > indexPath.row) {
            SearchGoodModel *model = marrEasyBuySource[indexPath.row];
            vcGoodDetail.model = model;
        }
        [self.navigationController pushViewController:vcGoodDetail animated:YES];
        
        
    }
    
    
}

//用于隐藏分割线
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}


#pragma mark 点击事件
//右边搜索点击事件
- (void)searchAction:(UIBarButtonItem*)sender
{
    
    GYEasybuySearchMainController* vcSearch = [[GYEasybuySearchMainController alloc] init];
    vcSearch.searchType = kGoods;
    vcSearch.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vcSearch animated:NO];
}

- (void)reFreshLocation:(NSNotification*)sender
{
    NSString* cityName = [sender object];
    [self getCity:cityName WithType:0];
}

//接受通知刷新
-(void)refreshSearchShopsData
{
    NSString* strSpecialService = [marrSpecialService componentsJoinedByString:@","];
    specialService = strSpecialService;
    
    currentPage = 1;
    isUpFresh = YES;
    
    if (mTitleArray && mTitleArray.count > 0) {
        NSString* textString = [mTitleArray lastObject];
        if (mTitleArray.count > 1) {
            textString = [textString stringByAppendingString:@"..."];
        }
        [dropDownView setBtnText:textString section:3];
    }
    else {
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
        [dropDownView setBtnTextColor:[UIColor blackColor] section:3];
    }
    
    [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%zi", sortType] WithSpecialService:strSpecialService];
}

- (void)ConfirmAction:(UIButton*)sender
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        
        NSString* strSpecialService = [marrSpecialService componentsJoinedByString:@","];
        specialService = strSpecialService;
        
        currentPage = 1;
        isUpFresh = YES;
        
        if (mTitleArray && mTitleArray.count > 0) {
            NSString* textString = [mTitleArray lastObject];
            if (mTitleArray.count > 1) {
                textString = [textString stringByAppendingString:@"..."];
            }
            [dropDownView setBtnText:textString section:3];
        }
        else {
            [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
            [dropDownView setBtnTextColor:[UIColor blackColor] section:3];
        }
        
        [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%zi", sortType] WithSpecialService:strSpecialService];
        [_delegate hidenBackgroundView];
    }
}



#pragma mark 自定义方法
//开始进入刷新状态
- (void)headerRereshing
{
    currentPage = 1;
    
    isUpFresh = YES;
    [tvEasyBuy.mj_footer resetNoMoreData];
    [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%zi", sortType] WithSpecialService:specialService];
}

- (void)footerRereshing
{
    // add by songjk
    isUpFresh = NO;
    [self loadListDataFromNetwork:categoryIdString WithAreaCode:areaString WithSortType:[NSString stringWithFormat:@"%zi", sortType] WithSpecialService:specialService];
}

//加载数据
- (void)loadListDataFromNetwork:(NSString*)categoryId WithAreaCode:(NSString*)areaCode WithSortType:(NSString*)sortTypeString WithSpecialService:(NSString*)specialServiceString
{
    NSString* distance = @"";
    NSString* areaInfo = areaCode;
    if ([areaCode isEqualToString:kLocalized(@"GYHE_SurroundVisit_All")] || [areaCode isEqualToString:kLocalized(@"GYHE_SurroundVisit_AllCity")]) {
        areaInfo = @"";
    }
    else {
        for (int i = 0; i < self.arrAround.count; i++) {
            NSString* str = self.arrAround[i];
            if ([str isEqualToString:areaCode]) {
                distance = self.arrAroundData[i];
                break;
            }
        }
    }
    
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    
    self.hasCoupon = @"0";
    // 消费抵扣全 传在hasCoupon
    NSString* strSpecialServiceType = specialServiceString;
    if (specialServiceString && specialServiceString.length > 0) {
        
        if ([specialServiceString rangeOfString:@"5"].location != NSNotFound) {
            self.hasCoupon = @"1";
            
            NSArray* arrService = [specialServiceString componentsSeparatedByString:@","];
            NSMutableArray* marrService = [NSMutableArray arrayWithArray:arrService];
            [marrService removeObject:@"5"];
            if (marrService.count > 0) {
                // modify by songjk 传入的id由数字改为名称
                NSMutableArray* marrName = [NSMutableArray array];
                NSString* strName = @"";
                for (int i = 0; i < marrService.count; i++) {
                    for (GYSortTypeModel* m in marrSortType) {
                        if(arrService.count > i) {
                            if ([m.strSortType isEqualToString:arrService[i]]) {
                                strName = m.strTitle;
                            }
                        }
                        
                    }
                    if (strName && strName.length > 0) {
                        [marrName addObject:strName];
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
            else {
                strSpecialServiceType = @"";
            }
        }
        else { // 不包含6
            NSArray* arrService = [specialServiceString componentsSeparatedByString:@","];
            if (arrService.count > 0) {
                // modify 传入的id由数字改为名称
                NSMutableArray* marrName = [NSMutableArray array];
                NSString* strName = @"";
                for (int i = 0; i < arrService.count; i++) {
                    
                    for (GYSortTypeModel* m in marrSortType) {
                        if(arrService.count > i) {
                            if ([m.strSortType isEqualToString:arrService[i]]) {
                                strName = m.strTitle;
                                [GYUtils getServiceNameWithServiceCode:arrService[i]];
                            }

                        }
                    }
                    
                    if (strName && strName.length > 0) {
                        [marrName addObject:strName];
                    }
                }
                strSpecialServiceType = [marrName componentsJoinedByString:@","];
            }
        }
    }
    // add by songjk uitf8编码 去掉后面市
    if ([strCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
        strCity = [strCity substringToIndex:strCity.length - 1];
    }
    if ([strCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_CityAndArea")]) {
        NSRange range = [strCity rangeOfString:kLocalized(@"GYHE_SurroundVisit_City")];
        if (range.location != NSNotFound) {
            strCity = [strCity substringToIndex:range.location];
        }
    }
 
    NSString* location;
    
    if (globalData.locationCoordinate.latitude) {
        
        location = [NSString stringWithFormat:@"%f,%f", globalData.locationCoordinate.latitude, globalData.locationCoordinate.longitude];
    }
    else {
        
        location = globalData.selectedCityCoordinate;
    }

    [dict setValue:strProvince forKey:@"province"];
    [dict setValue:strCity forKey:@"city"];
    [dict setValue:sectionString forKey:@"area"];
    if (distance.length > 0) {
        [dict setValue:distance forKey:@"distance"];
        [dict setValue:@"" forKey:@"section"];
    }
    else {
       
        [dict setValue:areaInfo forKey:@"section"];
        [dict setValue:@"" forKey:@"distance"];
    }
    [dict setValue:categoryId forKey:@"categoryId"];
    [dict setValue:self.hasCoupon forKey:@"hasCoupon"];
    [dict setValue:[NSString stringWithFormat:@"%d", pageCount] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%d", currentPage] forKey:@"currentPage"];
    [dict setValue:[NSString stringWithFormat:@"%@", sortTypeString] forKey:@"sortType"];
    [dict setValue:strSpecialServiceType forKey:@"specialService"];
    [dict setValue:location forKey:@"location"];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsTopicListUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
            if (!error) {
                if (![retCode isEqualToString:@"200"]) {
                    [marrEasyBuySource removeAllObjects];
                    [tvEasyBuy reloadData];
                }
                
                NSInteger totalCounts = kSaftToNSInteger(ResponseDic [@"rows"]);
                NSInteger totalPages = kSaftToNSInteger(ResponseDic [@"totalPage"]);
                if ([retCode isEqualToString:@"200"]) {
                   
                    //用来控制 从城市列表选择城市后需要删除数据源，重新刷新tableview
                    if (isAppend) {
                        isAppend = NO;
                        if (marrEasyBuySource.count > 0) {
                            [marrEasyBuySource removeAllObjects];
                        }
                    }
                    // modify by songjk 不用forin方法
                    NSArray *arrData = ResponseDic[@"data"];
                    if(arrData.count == 0) {
                        [marrEasyBuySource removeAllObjects];
                    }else if ([arrData isKindOfClass:[NSArray class]]) {
                        if (arrData.count > 0 && isUpFresh) {
                            [marrEasyBuySource removeAllObjects];
                        }
                        for (int i = 0; i < [arrData count]; i++) {
                            NSDictionary *tempDic = arrData[i];
                            SearchGoodModel *MOD = [[SearchGoodModel alloc] init];
                            // add by songjk 获得商品名称
                            MOD.name = kSaftToNSString(tempDic[@"itemName"]);
                            MOD.addr = kSaftToNSString(tempDic[@"addr"]);
                            
                            MOD.beCash = kSaftToNSString(tempDic[@"beCash"]);
                            MOD.beReach = kSaftToNSString(tempDic[@"beReach"]);
                            MOD.beSell = kSaftToNSString(tempDic[@"beSell"]);
                            MOD.beTake = kSaftToNSString(tempDic[@"beTake"]);
                            MOD.beTicket = kSaftToNSString(tempDic[@"beTicket"]);
                            MOD.moonthlySales = kSaftToNSString(tempDic[@"monthlySales"]);
                            MOD.companyName = kSaftToNSString(tempDic[@"companyName"]);
                            MOD.goodsId = kSaftToNSString(tempDic[@"id"]);
                            MOD.shoplat = kSaftToNSString(tempDic[@"lat"]);
                            MOD.shoplongitude = kSaftToNSString(tempDic[@"longitude"]);
                            MOD.shopsName = kSaftToNSString(tempDic[@"name"]);
                            //                        MOD.price=kSaftToNSString(tempDic[@"price"]);
                            NSNumber *price = tempDic[@"price"];
                            MOD.price = [NSString stringWithFormat:@"%0.02f", [price doubleValue]];
                            //                        MOD.goodsPv=kSaftToNSString(tempDic[@"pv"]);
                            NSNumber *pv = tempDic[@"pv"];
                            MOD.goodsPv = [NSString stringWithFormat:@"%.02f", [pv floatValue]];
                            MOD.shopId = kSaftToNSString(tempDic[@"shopId"]);
                            MOD.shopTel = kSaftToNSString(tempDic[@"tel"]);
                            MOD.shopUrl = kSaftToNSString(tempDic[@"url"]);
                            MOD.vShopId = kSaftToNSString(tempDic[@"vShopId"]);
                            MOD.shopSection = kSaftToNSString(tempDic[@"section"]);
                            // add by songjk
                            MOD.saleCount = kSaftToNSString(tempDic[@"salesCount"]);
                            
                            MOD.factoryName = kSaftToNSString(tempDic[@"factoryName"]);// 产地
                            if ([MOD.factoryName rangeOfString:@"null"].location != NSNotFound && MOD.factoryName.length <= 6) {
                                MOD.factoryName = @"";
                            }
                            // modify by songjk 地址距离改成取字段：dist 当如是距离最近的时候还是要计算
                            if ([sortTypeString isEqualToString:@"1"]) {
                                MOD.shopDistance = kSaftToNSString(tempDic[@"dist"]);
                            } else {
                                CLLocationCoordinate2D shopCoordinate;
                                shopCoordinate.latitude = MOD.shoplat.doubleValue;
                                shopCoordinate.longitude = MOD.shoplongitude.doubleValue;
                                BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                                CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                                MOD.shopDistance = [NSString stringWithFormat:@"%.02f", dis/1000];
                            }
                            [marrEasyBuySource addObject:MOD];
                        }
                    }
                  
                    [tvEasyBuy reloadData];
                    
               
                } else if ([retCode isEqualToString:@"201"]) {
                    if (marrEasyBuySource.count > 0) {
                        
                        [marrEasyBuySource removeAllObjects];
                        
                    }
                }
                [tvEasyBuy reloadData];
                
                GYRefreshFooter *footer = [GYRefreshFooter footerWithRefreshingBlock:^{
                    [self footerRereshing];
                }];
                
                tvEasyBuy.mj_footer = footer;
                
                // modify songjk 修改判断条件
                if (marrEasyBuySource.count == 0 && self.isShowNoData == NO) {
                    self.isShowNoData = YES;
                    tvEasyBuy.mj_footer.hidden = YES;
                    UIView *background = [[UIView alloc] initWithFrame:tvEasyBuy.frame];
                    UILabel *lbTips = [[UILabel alloc] init];
                    lbTips.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 + 60);
                    lbTips.numberOfLines = 2;
                    lbTips.textAlignment = NSTextAlignmentCenter;
                    lbTips.font = [UIFont systemFontOfSize:15.0];
                    lbTips.textColor = kCellItemTitleColor;
                    lbTips.backgroundColor = [UIColor clearColor];
                    lbTips.bounds = CGRectMake(0, 0, 270, 50);
                    lbTips.text = kLocalized(@"GYHE_SurroundVisit_NoSearchRelevantProductData");
                    UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
                    imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    [background addSubview:lbTips];
                    tvEasyBuy.backgroundView = background;
                } else if (self.isShowNoData && marrEasyBuySource.count > 0) { // add by songjk 去掉没有找到时的背景提示页面
                    self.isShowNoData = NO;
                    UIView *background = [[UIView alloc] initWithFrame:tvEasyBuy.frame];
                    background.backgroundColor = [UIColor whiteColor];
                    tvEasyBuy.backgroundView = background;
                }
                
                if (currentPage >= totalPages) {
                    
                    if (totalPages > 0) {
                        
                        tvEasyBuy.mj_footer.hidden = NO;
                    }else{
                        tvEasyBuy.mj_footer.hidden = YES;
                    }
                    
                    
                    [tvEasyBuy.mj_footer endRefreshingWithNoMoreData];
                    
                } else if (totalCounts > pageCount) {
                    currentPage += 1;
                }
                
            }
            
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
            if (isUpFresh) {
                [marrEasyBuySource removeAllObjects];
                [tvEasyBuy reloadData];
                
            }
        }
        if (isUpFresh) {
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            [tvEasyBuy.mj_header endRefreshing];
        }
        if (tvEasyBuy.mj_footer.isRefreshing) {
            [tvEasyBuy.mj_footer endRefreshing];
        }
        
    }];
    [request start];
}

//逛商铺  商区
- (void)getSectionAreaCode
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:@" " forKey:@"areaCode"];
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetLocationUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"]) {
                for (NSDictionary *tempDic in ResponseDic[@"data"]) {
                    
                    
                    SearchGoodModel *MOD = [[SearchGoodModel alloc] init];
                    MOD.addr = kSaftToNSString(tempDic[@"addr"]);
                    MOD.beCash = kSaftToNSString(tempDic[@"beCash"]);
                    MOD.beReach = kSaftToNSString(tempDic[@"beReach"]);
                    MOD.beSell = kSaftToNSString(tempDic[@"beSell"]);
                    MOD.beTake = kSaftToNSString(tempDic[@"beTake"]);
                    MOD.beTicket = kSaftToNSString(tempDic[@"beTicket"]);
                    MOD.goodsId = kSaftToNSString(tempDic[@"id"]);
                    MOD.shoplat = kSaftToNSString(tempDic[@"lat"]);
                    MOD.shoplongitude = kSaftToNSString(tempDic[@"longitude"]);
                    MOD.shopsName = kSaftToNSString(tempDic[@"name"]);
                    MOD.price = kSaftToNSString(tempDic[@"price"]);
                    MOD.goodsPv = kSaftToNSString(tempDic[@"pv"]);
                    MOD.shopId = kSaftToNSString(tempDic[@"shopId"]);
                    MOD.shopTel = kSaftToNSString(tempDic[@"tel"]);
                    MOD.shopUrl = kSaftToNSString(tempDic[@"url"]);
                    MOD.vShopId = kSaftToNSString(tempDic[@"vShopId"]);
                    MOD.shopSection = kSaftToNSString(tempDic[@"section"]);
                    
                    CLLocationCoordinate2D shopCoordinate;
                    shopCoordinate.latitude = MOD.shoplat.doubleValue;
                    shopCoordinate.longitude = MOD.shoplongitude.doubleValue;
                    BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                    MOD.shopDistance = [NSString stringWithFormat:@"%.02f", dis/1000];
                    [marrEasyBuySource addObject:MOD];
                    
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    [request start];
}

//逛 排序类型
- (void)getSortTypeCodeRequet
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:[globalData.retailDomain stringByAppendingString:@"/phapi/goods/sortType"] parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"]) {
                
            }
 
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        
    }];
    [request start];
}

- (void)addTopSelectView
{
    
    if (marrAreaTitle.count > 0 && marrCategoryLevelOne.count > 0 && marrSortNameTtile.count > 0 && marrSortTtile.count > 0) {
        
        chooseArray = [NSMutableArray arrayWithArray:@[
                                                       marrAreaTitle,
                                                       marrSortNameTtile,
                                                       marrCategoryLevelOne,
                                                       marrSortTtile
                                                       ]];
        dropDownView = [[DropDownWithChildListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40) dataSource:self delegate:self WithUseType:arroundGoodsListType WithOther:nil];
        
        dropDownView.mSuperView = self.view;
        dropDownView.deleteTableview = self;
        [dropDownView.BtnConfirm addTarget:self action:@selector(ConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
        dropDownView.has = YES;
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
        [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_Sort") section:1];
        _delegate = dropDownView;
        [self.view addSubview:dropDownView];
    }
}

//获取商品列表
- (void)loadDataFromNetwork:(NSString*)categoryID
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"" forKey:@"province"];
    [dict setValue:strCity forKey:@"city"];
    [dict setValue:@"" forKey:@"area"];
    [dict setValue:@"" forKey:@"section"];
    [dict setValue:categoryID forKey:@"categoryId"];
    [dict setValue:@"0" forKey:@"sortType"];
    [dict setValue:@"" forKey:@"specialService"];
    [dict setValue:@"" forKey:@"location"];
    [dict setValue:@"0" forKey:@"hasCoupon"];
    
    [GYGIFHUD show];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsTopicListUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        [GYGIFHUD dismiss];
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                
            if ([retCode isEqualToString:@"200"]) {
                NSArray *arrData = ResponseDic[@"data"];
                for (int i = 0; i < arrData.count; i++) {
                    NSDictionary *tempDic = arrData[i];
                    SearchGoodModel *MOD = [[SearchGoodModel alloc] init];
                    MOD.addr = kSaftToNSString(tempDic[@"addr"]);
                    MOD.beCash = kSaftToNSString(tempDic[@"beCash"]);
                    MOD.beReach = kSaftToNSString(tempDic[@"beReach"]);
                    MOD.beSell = kSaftToNSString(tempDic[@"beSell"]);
                    MOD.beTake = kSaftToNSString(tempDic[@"beTake"]);
                    MOD.beTicket = kSaftToNSString(tempDic[@"beTicket"]);
                    MOD.goodsId = kSaftToNSString(tempDic[@"id"]);
                    MOD.shoplat = kSaftToNSString(tempDic[@"lat"]);
                    MOD.shoplongitude = kSaftToNSString(tempDic[@"longitude"]);
                    MOD.shopsName = kSaftToNSString(tempDic[@"name"]);
                    MOD.price = kSaftToNSString(tempDic[@"price"]);
                    MOD.goodsPv = kSaftToNSString(tempDic[@"pv"]);
                    MOD.shopId = kSaftToNSString(tempDic[@"shopId"]);
                    MOD.shopTel = kSaftToNSString(tempDic[@"tel"]);
                    MOD.shopUrl = kSaftToNSString(tempDic[@"url"]);
                    MOD.vShopId = kSaftToNSString(tempDic[@"vShopId"]);
                    MOD.shopSection = kSaftToNSString(tempDic[@"section"]);
                    CLLocationCoordinate2D shopCoordinate;
                    shopCoordinate.latitude = MOD.shoplat.doubleValue;
                    shopCoordinate.longitude = MOD.shoplongitude.doubleValue;
                    BMKMapPoint mp2 = BMKMapPointForCoordinate(shopCoordinate);
                    CLLocationDistance dis = BMKMetersBetweenMapPoints(mp1, mp2);
                    MOD.shopDistance = [NSString stringWithFormat:@"%.02f", dis/1000];
                    [marrEasyBuySource addObject:MOD];
                    
                }
            }
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        
    }];
    [request start];
}

//逛商品  排序
- (void)getSortTypeData
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:SortTypeUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            NSDictionary *ResponseDic = responseObject;
            
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
                
            if ([retCode isEqualToString:@"200"]) {
                
                for (NSDictionary *dict in ResponseDic[@"data"]) {
                    GYSortTypeModel *sortTypeMod = [[GYSortTypeModel alloc] init];
                    sortTypeMod.strSortType = [NSString stringWithFormat:@"%@", dict[@"sortType"]];
                    sortTypeMod.strTitle = [NSString stringWithFormat:@"%@", dict[@"title"]];
                    [marrSortTtile addObject:sortTypeMod.strTitle];//注意两个数据的关系，取值是别混淆
                    
                    [marrSortType addObject:sortTypeMod];//排序类型
                    
                }
                
            }
 
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        
        [self getSortNameData];
    }];
    [request start];
}

//逛商品 排序的名称
- (void)getSortNameData
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GoodsSortNameUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        NSDictionary *ResponseDic = responseObject;
            
        if (!error) {
            
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"]) {
                // mofiby by songjk
                NSArray *arryData = ResponseDic[@"data"];
                if ([arryData isKindOfClass:[NSArray class]]) {
                    for (int i = 0; i < arryData.count; i++) {
                        NSDictionary *dict = arryData[i];
                        GYSortTypeModel *sortNameMod = [[GYSortTypeModel alloc] init];
                        sortNameMod.strSortType = [NSString stringWithFormat:@"%@", dict[@"sortType"]];
                        sortNameMod.strTitle = [NSString stringWithFormat:@"%@", dict[@"title"]];
                        [marrSortNameTtile addObject:sortNameMod.strTitle];
                        [marrSortName addObject:sortNameMod]; //特殊服务
                        if (i == 0) {
                            sortType = sortNameMod.strSortType.integerValue;
                        }
                    }
                }
            
            }
            
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        
        [self setupLocationInfo];
        
    }];
    [request start];
}


- (void)ToCityVC
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        [_delegate hidenBackgroundView];
    }
    
    GYCitySelectViewController* vcCitySelection = [[GYCitySelectViewController alloc] initWithNibName:@"GYCitySelectViewController" bundle:nil];
    
    vcCitySelection.delegate = self;
    [self.navigationController pushViewController:vcCitySelection animated:YES];
}


// add by songjk 获取省
- (void)getProvinceWithProviceCode:(NSString*)provinceCode
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"stateLists" ofType:@"txt"];
    
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    for (NSDictionary* tempDic in dict[@"data"]) {
        GYCityInfo* cityModel = [[GYCityInfo alloc] init];
        cityModel.strAreaName = tempDic[@"areaName"];
        cityModel.strAreaCode = tempDic[@"areaCode"];
        cityModel.strAreaType = tempDic[@"areaType"];
        cityModel.strAreaParentCode = tempDic[@"parentCode"];
        cityModel.strAreaSortOrder = tempDic[@"sortOrder"];
        if ([cityModel.strAreaCode isEqualToString:provinceCode]) {
            strProvince = cityModel.strAreaName;
        }
    }
}

- (void)reloadDropViewDatasource
{
    chooseArray = [NSMutableArray arrayWithArray:@[
                                                   marrAreaTitle,
                                                   marrSortNameTtile,
                                                   marrCategoryLevelOne,
                                                   marrSortTtile
                                                   ]];
    [dropDownView reloadDatasoureArray:chooseArray];
    [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_SellerService") section:3];
    [dropDownView setBtnText:kLocalized(@"GYHE_SurroundVisit_Sort") section:1];
}

- (void)loadTopDataFromNetwork
{
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetGoodsMainInterfaceUrl parameters:nil requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        NSArray *arryData = responseObject[@"data"];
        if (responseObject) {
            for (int i = 0; i < arryData.count; i++) {
                NSDictionary *dict = arryData[i];
                GYGoodCategoryModel *model1 = [[GYGoodCategoryModel alloc] init];
                model1.strCategoryTitle = [dict objectForKey:@"categoryName"];
                model1.strCategoryId = [dict objectForKey:@"id"];
                [marrDatasource addObject:model1];    //放所有一级分类的
                
                [marrCategoryLevelOne addObject:model1.strCategoryTitle];     //放一级分类的类名。
            }
            [self getSortTypeData];
        }
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    [request start];
}

- (void)getListDataWith:(NSString*)ID
{
    NSDictionary* dict = @{ @"categoryId" : ID };
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetChildCategoryByParentIdUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        if(responseObject) {
            NSArray *arryData = responseObject[@"data"];
            for (int i = 0; i < arryData.count; i++) {
                NSDictionary *dict = arryData[i];
                GYGoodCategoryModel *model = [[GYGoodCategoryModel alloc] init];
                model.strCategoryTitle = [dict objectForKey:@"categoryName"];
                model.strCategoryId = [dict objectForKey:@"id"];
                [marrCategoryLevelTwo addObject:model];
                if(i == 0) {
                    categoryIdString = [dict objectForKey:@"id"];
                }
            }
            for (GYGoodCategoryModel *model in marrCategoryLevelTwo) {
                
                [marrLevelTwoTitle addObject:model.strCategoryTitle];
                
            }
            [self addTempTableView];
            
        }
        if(error) {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
    }];
    [request start];
}

//当一次进入 获取深圳的商区
- (void)getAreaCode
{
    [marrAreaTitle removeAllObjects];
    [marrArea removeAllObjects];
    //这里是第一次进来加载的情况下 显示定位失败 显示 深圳市的区
    NSString* path = [[NSBundle mainBundle] pathForResource:@"districtlist" ofType:@"txt"];
    
    NSData* jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary* dict1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    for (NSDictionary* tempDic in dict1[@"data"]) {
        GYCityInfo* cityModel = [[GYCityInfo alloc] init];
        cityModel.strAreaName = tempDic[@"areaName"];
        cityModel.strAreaCode = tempDic[@"areaCode"];
        
        cityModel.strAreaParentCode = kSaftToNSString(tempDic[@"parentCode"]);
        cityModel.strAreaSortOrder = kSaftToNSString(tempDic[@"sortOrder"]);
        if ([cityModel.strAreaParentCode isEqualToString:@"4403"]) {
            [marrAreaTitle addObject:cityModel.strAreaName];
            [marrArea addObject:cityModel];
        }
    }
    // add by songjk
    if (marrAreaTitle.count > 0) {
        //        sectionString = marrAreaTitle[0];
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
            strCity = title;
            [self getCity:data.locationCity WithType:0];
        }
    }
    else {
        [GYGIFHUD dismiss];
        currentLocation = data.locationCoordinate;
        mp1 = BMKMapPointForCoordinate(currentLocation);
        strCity = data.selectedCityName;
        NSString* tempCity = strCity;
        if ([tempCity hasSuffix:kLocalized(@"GYHE_SurroundVisit_City")]) {
            tempCity = [tempCity substringToIndex:(tempCity.length - 1)];
        }
        
        [self getCity:strCity WithType:0];
        strCity = tempCity;
        //        [btnRight setTitle:tempCity forState:UIControlStateNormal];
    }
    [self addTopSelectView];
    [self loadFirstSelectedChoose];
}

// add by songjk 第一次加载选中的项目
- (void)loadFirstSelectedChoose
{
    if (marrFirstSpecialService.count > 0 && !bRun) {
        [dropDownView sectionBtnTouch:dropDownView->sectionBtn];
        dropDownView->currentExtendSection = 3;
        for (int i = 0; i < marrFirstSpecialService.count; i++) {
            [dropDownView tableView:dropDownView.mTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:[marrFirstSpecialService[i] integerValue] - 1 inSection:0]];
        }
        [self loadFirstData];
    }
    else if (marrFirstSpecialService.count == 0 && !bRun) { // add by songjk 如果定位失败则直接请求
        [tvEasyBuy.mj_header beginRefreshing];
    }
    bRun = YES;
}

- (void)loadFirstData
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(hidenBackgroundView)]) {
        NSString* strSpecialService = [marrSpecialService componentsJoinedByString:@","];
        specialService = strSpecialService;
        currentPage = 1;
        isUpFresh = YES;
        [tvEasyBuy.mj_header beginRefreshing];
        [_delegate hidenBackgroundView];
    }
}

- (void)getAreaCodeRequestWithCode:(NSString*)code
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    [dict setValue:code forKey:@"areaCode"];
    
    GYNetRequest *request = [[GYNetRequest alloc] initWithBlock:GetLocationUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        NSDictionary *ResponseDic = responseObject;
            
        if (!error) {
            
            NSString *retCode = [NSString stringWithFormat:@"%@", ResponseDic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"]) {
                
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
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }

    }];
    [request start];
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
        CGFloat maxHeight = kScreenHeight - 64 - 40;
        CGFloat height = 40 * marrCategoryLevelTwo.count;
        height = height < maxHeight ? height : maxHeight;
        tempTv.frame = CGRectMake(140, 40, self.view.frame.size.width - width, height);
        //        tempTv.frame =CGRectMake(140, 40, self.view.frame.size.width-width, (kScreenHeight-64-40)*0.8);
        
        [self.view addSubview:tempTv];
    }
    
    [tempTv reloadData];
}


- (void)shopCallWithIndexPath:(NSIndexPath*)indexPath
{
    if(marrEasyBuySource.count > indexPath.row) {
        SearchGoodModel* model = marrEasyBuySource[indexPath.row];
        NSString* phoneNo = model.shopTel;
        if (!phoneNo || phoneNo.length == 0) {
            return;
        }
        [GYUtils callPhoneWithPhoneNumber:phoneNo showInView:self.view];
    }
    
}

- (void)makeAroundDistanceChoose
{
    NSMutableArray* marr = [NSMutableArray array];
    for (int i = 0; i < self.arrAround.count; i++) {
        
        GYAreaCodeModel* model = [[GYAreaCodeModel alloc] init];
        model.areaName = self.arrAround[i];
        model.locationName = self.arrAround[i];
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



- (void)backTop
{
    _backTopBtn.hidden = YES;
    
    tvEasyBuy.contentOffset = CGPointMake(0, 0);
}



@end
