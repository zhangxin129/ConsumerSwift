//
//  GYHEShopDetailViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/9/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopDetailViewController.h"
#import "Masonry.h"
#import "GYHEShopHeaderView.h"
#import "GYHETools.h"
#import "GYHEShopSelectedView.h"
#import "GYHEShopDetailMainCell.h"
#import "GYHEShopGoodListViewController.h"
#import "GYHEShopServerListViewController.h"
#import "GYHEShopFoodListViewController.h"
#import "GYHEShopDetailFirstCell.h"
#import "GYHEShopDetailShowInfotCell1.h"
#import "GYHEShopDetailShowInfotCell2.h"
#import "GYHEShopDetailShowInfotCell3.h"
#import "GYHEShopDetailShowInfotCell4.h"
#import "GYHEShopDetailShowInfotCell5.h"
#import "GYHEShopDetailModel.h"
#import "GYHEShopDetailBusinessImgView.h"
#import "GYHEVisitSurroundSearchVC.h"
#define kGYHEShopDetailMainCell @"GYHEShopDetailMainCell"
#define kGYHEShopDetailFirstCell @"GYHEShopDetailFirstCell"
#define kGYHEShopDetailShowInfotCell1 @"GYHEShopDetailShowInfotCell1"
#define kGYHEShopDetailShowInfotCell2 @"GYHEShopDetailShowInfotCell2"
#define kGYHEShopDetailShowInfotCell3 @"GYHEShopDetailShowInfotCell3"
#define kGYHEShopDetailShowInfotCell4 @"GYHEShopDetailShowInfotCell4"
#define kGYHEShopDetailShowInfotCell5 @"GYHEShopDetailShowInfotCell5"

#define kHeaderImgH kScreenWidth / 720 * 490
#define kHeaderImgW kScreenWidth
#define kCellH kScreenHeight - 64 - 40 - 49
#define ktabHeaderH 40
#define ktabHeaderW kScreenWidth
#define kFirstCellHeight 50

@interface GYHEShopDetailViewController ()<UITableViewDataSource,UITableViewDelegate,GYHEShopSelectedViewDelegate,UIScrollViewDelegate,GYHEShopDetailMainCellDelegate,GYHEShopDetailFirstCellDelegate>

@property (nonatomic ,strong)UITableView *tabView;
@property (nonatomic ,strong)GYHEShopSelectedView *sectionHeader;
//距离，电话，商家服务，外卖服务，工商信息展开高度
@property (nonatomic , assign)CGFloat infoCellHeight;

//商品，外卖，服务选中
@property (nonatomic , assign)NSInteger selectedIndex;

@property (nonatomic ,strong)GYHEShopDetailModel *model;
//距离，电话，商家服务，外卖服务，工商信息选中
@property (nonatomic , assign)NSInteger index;
//工商资质
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)GYHEShopDetailBusinessImgView *businessImgV;
//图片头部
@property (nonatomic ,strong)GYHEShopHeaderView *header;


@end

@implementation GYHEShopDetailViewController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _infoCellHeight = 0;
    _index = 1;
    [self setNav];
    [self setUI];
    [self getShopInformation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfb7d00);
}

#pragma mark - GYHEShopDetailFirstCellDelegate
- (void)firstCell:(GYHEShopDetailFirstCell *)cell didSelectAtIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    _infoCellHeight = 50;
    _index = index + 1;
    [_tabView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)hiddenFirstCell:(GYHEShopDetailFirstCell *)cell {
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    _infoCellHeight = 0;
    [_tabView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - GYHEShopSelectedViewDelegate
//头部滑动，tabView侧滑
- (void)shopSelectedView:(GYHEShopSelectedView *)shopSelectedView selectIndex:(NSInteger)index {
    _selectedIndex = index;
    GYHEShopDetailMainCell *cell = [_tabView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.selectIndex = index;
    if(index == 1) {
        [self setFooter];
    }else {
        [self hiddenFooter];
    }
}
#pragma mark - GYHEShopDetailMainCellDelegate
//tabview侧滑头部一起滑动
- (void)scrollViewDidScrolled:(GYHEShopDetailMainCell *)cell withIndex:(NSInteger)index{
    _selectedIndex = index;
    _sectionHeader.selectIndex = index;
    if(index == 1) {
        [self setFooter];
    }else {
        [self hiddenFooter];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.tabView.contentOffset.y > kHeaderImgH + kFirstCellHeight + _infoCellHeight) {
        [self currentScrollType:GYScrollTypeSonTabView];
    }else {
        [self currentScrollType:GYScrollTypeFatherTabView];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 2;
    }
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            GYHEShopDetailFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailFirstCell];
            if(_model) {
                [cell.distanceBtn1 setTitle:[NSString stringWithFormat:@"<%@km",kSaftToNSString(_model.dist)] forState:UIControlStateNormal];
            }
            cell.delegate = self;
            return cell;
        }else {
            BOOL hidden;
            if(_infoCellHeight == 0) {
                hidden = YES;
            }else {
                hidden = NO;
            }
            if(_index == 1) {
                GYHEShopDetailShowInfotCell1 *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailShowInfotCell1 forIndexPath:indexPath];
                if(_model) {
                    cell.addrLab.text = _model.addr;
                }
                cell.hidden = hidden;
                return cell;
            } else if (_index == 2) {

                GYHEShopDetailShowInfotCell2 *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailShowInfotCell2 forIndexPath:indexPath];
                if(_model) {
                    cell.telLab.text = _model.contactWay;
//                    NSArray *arr = [NSJSONSerialization JSONObjectWithData: options:NSJSONReadingAllowFragments error:nil];
//                    cell.openTimeLab.text = [NSString stringWithFormat:@"%@:%@-%@:%@",arr.firstObject[@"timeList0"],arr.firstObject[@"timeList1"],arr.firstObject[@"timeList2"],arr.firstObject[@"timeList3"]];
                }
                cell.hidden = hidden;
                return cell;
            }else if (_index == 3) {
                GYHEShopDetailShowInfotCell3 *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailShowInfotCell3 forIndexPath:indexPath];
                if(_model) {
                    
                }
                cell.hidden = hidden;
                return cell;
            }else if (_index == 4) {
                GYHEShopDetailShowInfotCell4 *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailShowInfotCell4 forIndexPath:indexPath];
                if(_model) {
                    
                }
                cell.hidden = hidden;
                return cell;
            }else {
                GYHEShopDetailShowInfotCell5 *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailShowInfotCell5 forIndexPath:indexPath];
                if(_model) {
                    
                }
                cell.hidden = hidden;
                return cell;
            }
            return nil;
        }

    }else {
        GYHEShopDetailMainCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopDetailMainCell forIndexPath:indexPath];
        
        cell.subVCsStr = @[NSStringFromClass([GYHEShopGoodListViewController class]),NSStringFromClass([GYHEShopFoodListViewController class]),NSStringFromClass([GYHEShopServerListViewController class])];
        cell.delegate = self;
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            return 50;
        }
        return _infoCellHeight;
    }
    return kCellH;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return 0;
    }
    return ktabHeaderH;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return [[UIView alloc] init];
    }else {
        GYHEShopSelectedView *view = [[GYHEShopSelectedView alloc] initWithFrame:CGRectMake(0, 0, ktabHeaderW, ktabHeaderH)];
        view.delegate = self;
        view.dataArr = @[kLocalized(@"商品零售"),kLocalized(@"外卖送货"),kLocalized(@"信息服务")];
        view.selectIndex = 0;
        [self currentScrollType:GYScrollTypeFatherTabView];
        _sectionHeader = view;
        return view;

    }
}

#pragma mark - 点击事件
- (void)colloct:(UIButton *)btn {
    kCheckLogined
    if(!btn.selected) {
        [self requestCollectShop:btn];
    }else {
        [self requestUnCollectionShop:btn];
    }
    
}

- (void)share:(UIButton *)btn {
    
}

- (void)search:(UIButton *)btn {
}

- (void)back:(UIButton *)btn {
    [self removeFooter];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showBusinessImg {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.6;
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBusinessImgV)];
    [view addGestureRecognizer:tap];
    _backView = view;
    GYHEShopDetailBusinessImgView *businessImgV = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEShopDetailBusinessImgView class]) owner:self options:0][0];
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:businessImgV];
    [businessImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(kScreenWidth - 50);
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.equalTo(businessImgV.mas_width).multipliedBy(950.0 / 620.0);
//        make.height.mas_equalTo(420);
    }];
    businessImgV.layer.cornerRadius = 12;
    businessImgV.clipsToBounds = YES;
    [businessImgV.businessImgv setImageWithURL:[NSURL URLWithString:_model.licenseImg] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"]];
    businessImgV.introduceLab.text = _model.intrduction;
    businessImgV.titleLabel.text = kLocalized(@"工商资质");
    _businessImgV = businessImgV;
}

- (void)dismissBusinessImgV {
    [_backView removeFromSuperview];
    [_businessImgV removeFromSuperview];
}

#pragma mark - 自定义方法
//导航栏
- (void)setNav {
    
    UIButton* colloctBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0, 0, 23, 30);
    colloctBtn.frame = frame;
    [colloctBtn setImage:kLoadPng(@"gyhe_shop_detail_collect_unSelect") forState:UIControlStateNormal];
    [colloctBtn setImage:kLoadPng(@"gyhe_shop_detail_collect_Select") forState:UIControlStateSelected];
    [colloctBtn setTitle:@"" forState:UIControlStateNormal];
    [colloctBtn addTarget:self action:@selector(colloct:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting1 = [[UIBarButtonItem alloc] initWithCustomView:colloctBtn];
    
    UIButton* shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect sframe = CGRectMake(0, 0, 23, 30);
    shareBtn.frame = sframe;
    [shareBtn setImage:kLoadPng(@"gyhe_shop_detail_share") forState:UIControlStateNormal];
    [shareBtn setTitle:@"" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting2 = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    
    self.navigationItem.rightBarButtonItems = @[ btnSetting2, btnSetting1 ];

    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"gy_he_back_arrow"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 30, 40);
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* btnSetting3 = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIBarButtonItem* btnSetting4 = [[UIBarButtonItem alloc] initWithCustomView:[self setTitleView]];
    self.navigationItem.leftBarButtonItems = @[ btnSetting3,btnSetting4];
    
}
//显示餐饮尾部
- (void)setFooter {
    for(GYHEShopFoodListViewController *vc in self.childViewControllers) {
        if([vc isKindOfClass:[GYHEShopFoodListViewController class]]) {
            vc.footerView.hidden = NO;
        }
        
    }
}
//隐藏餐饮尾部
- (void)hiddenFooter {
    for(GYHEShopFoodListViewController *vc in self.childViewControllers) {
        if([vc isKindOfClass:[GYHEShopFoodListViewController class]]) {
            vc.footerView.hidden = YES;
        }
        
    }
}
//移除餐饮尾部
- (void)removeFooter {
    for(GYHEShopFoodListViewController *vc in self.childViewControllers) {
        if([vc isKindOfClass:[GYHEShopFoodListViewController class]]) {
            [vc.footerView removeFromSuperview];
            vc.footerView = nil;
        }
        
    }
}
//导航栏头部
- (UIView *)setTitleView {
    UIView* vTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 180, 25)];
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 180, 25)];
    imgV.image = [UIImage imageNamed:@"gyhe_shop_detail_search"];
    [vTitleView addSubview:imgV];
    
    UIImageView* rightBtnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 15, 15)];
    rightBtnImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightBtnImageView.image = [UIImage imageNamed:@"gycommon_nav_search"];
    [vTitleView addSubview:rightBtnImageView];
    
    UITextField* tfInputSearchText = [[UITextField alloc] initWithFrame:CGRectMake(25, 0, 180 - 25, 25)];
    tfInputSearchText.contentMode = UIViewContentModeScaleToFill;
    tfInputSearchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfInputSearchText.enablesReturnKeyAutomatically = YES;
    tfInputSearchText.textColor = [UIColor whiteColor];
    tfInputSearchText.backgroundColor = [UIColor clearColor];
    tfInputSearchText.font = [UIFont systemFontOfSize:12];
    tfInputSearchText.placeholder = kLocalized(@"搜索店铺内商品/服务");
    [tfInputSearchText addTarget:self action:@selector(search:) forControlEvents:UIControlEventEditingChanged];
    [vTitleView addSubview:tfInputSearchText];
    
    UIButton* searchBtn = [[UIButton alloc] initWithFrame:tfInputSearchText.frame];
    searchBtn.backgroundColor = [UIColor clearColor];
    [tfInputSearchText addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(gotoSearchView:) forControlEvents:UIControlEventTouchUpInside];
    
    return vTitleView;
}
//前往搜索界面
-(void)gotoSearchView:(UIButton*)sender{
    
    GYHEVisitSurroundSearchVC* vc = [[GYHEVisitSurroundSearchVC alloc] init];
    vc.contentTabelType = kGoodsType;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)setUI {
    _tabView = [[UITableView alloc] init];
    _tabView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 );
    _tabView.delegate = self;
    _tabView.dataSource = self;
    
    _tabView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tabView];

    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailMainCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailMainCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailFirstCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailFirstCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailShowInfotCell1 class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailShowInfotCell1];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailShowInfotCell2 class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailShowInfotCell2];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailShowInfotCell3 class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailShowInfotCell3];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailShowInfotCell4 class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailShowInfotCell4];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopDetailShowInfotCell5 class]) bundle:nil] forCellReuseIdentifier:kGYHEShopDetailShowInfotCell5];
    
    _header = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEShopHeaderView class]) owner:self options:0].firstObject;
    [_header.shopBusinessImgBtn addTarget:self action:@selector(showBusinessImg) forControlEvents:UIControlEventTouchUpInside];
    _header.bounds = CGRectMake(0 ,0 ,kHeaderImgW, kHeaderImgH);
    _tabView.tableHeaderView = _header;

    
}

#pragma mark -网上商城信息
- (void)getShopInformation
{
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:_vShopId forKey:@"vShopId"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kGetSalerVirtualShopsUrl parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            return;
        }
        _model = [GYHEShopDetailModel modelArrayWithResponseObject:responseObject error:nil].firstObject;
        [self refreshUI];

    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

- (void)requestCollectShop:(UIButton *)btn {
    kCheckLogined
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:_vShopId forKey:@"virtualShopId"];
    [paramters setValue:@"" forKey:@"shopName"];
    [paramters setValue:globalData.loginModel.cardHolder ? @"c" : @"nc" forKey:@"isCard"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kCollectShopNewUrl parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            [GYUtils showMessage:kLocalized(@"添加商城关注失败或当前商城已关注！")];
            return;
        }
        btn.selected = YES;
        [GYUtils showMessage:responseObject[@"msg"]];
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];
}

- (void)requestUnCollectionShop:(UIButton *)btn {
    kCheckLogined
    NSMutableDictionary * paramters = [[NSMutableDictionary alloc]init];
    [paramters setValue:_vShopId forKey:@"virtualShopId"];
    [paramters setValue:globalData.loginModel.cardHolder ? @"c" : @"nc" forKey:@"isCard"];
    GYNetRequest * request = [[GYNetRequest alloc]initWithBlock:kDeleteCollectShopNewUrl parameters:paramters requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerJSON respondBlock:^(NSDictionary *responseObject, NSError *error) {
        if (error) {
            [GYUtils parseNetWork:error resultBlock:nil];
            
            return;
        }
        btn.selected = NO;
        [GYUtils showMessage:responseObject[@"msg"]];
    }];
    [request commonParams:[GYUtils netWorkHECommonParams]];
    [request start];

}

- (void)refreshUI {
    _header.model = _model;
    [_tabView reloadData];
    if(self.childViewControllers.count > 1) {
        GYHEShopFoodListViewController *vc =  self.childViewControllers[1];
        vc.customCateInfo = _model.customCateInfo;
    }
    
}

//滑动子视图还是父视图
- (void)currentScrollType:(GYScrollType)type {
    self.tabView.scrollEnabled = type == GYScrollTypeFatherTabView ? YES : NO;
    for(UIViewController *vc in self.childViewControllers) {
        for(UITableView *tabV in vc.view.subviews) {
            if([tabV isKindOfClass:[UITableView class]]) {
                tabV.scrollEnabled = type == GYScrollTypeFatherTabView ? NO : YES;
            }
        }
    }
}
#pragma mark - setter


@end
