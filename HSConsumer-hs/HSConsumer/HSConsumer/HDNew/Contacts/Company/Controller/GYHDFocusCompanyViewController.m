//
//  GYHDFocusCompanyViewController.m
//  HSConsumer
//
//  Created by shiang on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDFocusCompanyViewController.h"
#import "GYHDFocusCompanyCell.h"
#import "GYHDFocusCompanyGroupModel.h"
#import "GYHDMessageCenter.h"
#import "GYPinYinConvertTool.h"
#import "GYShopAboutViewController.h"
#import "GYHDPopMessageTopView.h"
#import "GYHDPopView.h"
#import "GYSocialDataService.h"
#import "YYWebImageManager.h"
#import "GYHDSearchFriendViewController.h"
#import "GYHDSeachMessageViewController.h"
#import "GYHDChatViewController.h"


@interface GYHDFocusCompanyViewController () <UITableViewDataSource, UITableViewDelegate>
/**关注数组*/
@property (nonatomic, strong) NSArray* focusCompanyArray;
/**关注View*/
@property (nonatomic, weak) UITableView* focusCompanyTableView;
/**
 *  提示
 */
@property (nonatomic, weak) UILabel* zeroMessageLabel;
@end

@implementation GYHDFocusCompanyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [GYUtils localizedStringWithKey:@"GYHD_Company"];
    self.view.backgroundColor = [UIColor colorWithRed:234 / 255.0f green:235 / 255.0f blue:236 / 255.0f alpha:1];
    UIButton*searchBtn=[[UIButton alloc]init];
    [searchBtn setImage:[UIImage imageNamed:@"gyhd_search_icon"] forState:UIControlStateNormal];
    [searchBtn setTitle:[GYUtils localizedStringWithKey:@"GYHD_search"] forState:UIControlStateNormal];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 16;
    [searchBtn setTitleColor:[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1] forState:UIControlStateNormal];
    searchBtn.backgroundColor=[UIColor whiteColor];
    searchBtn.titleLabel.font=[UIFont systemFontOfSize:14.0];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(32);
        
    }];
    UITableView* focusCompanyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    focusCompanyTableView.delegate = self;
    focusCompanyTableView.dataSource = self;
    focusCompanyTableView.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    focusCompanyTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    focusCompanyTableView.sectionIndexColor = [UIColor blackColor];
    focusCompanyTableView.sectionHeaderHeight = 18.0f;
    [focusCompanyTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [focusCompanyTableView registerClass:[GYHDFocusCompanyCell class] forCellReuseIdentifier:@"GYHDFocusCompanyCellID"];
    UILongPressGestureRecognizer* longtap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longtap:)];
    [focusCompanyTableView addGestureRecognizer:longtap];
    [self.view addSubview:focusCompanyTableView];
    _focusCompanyTableView = focusCompanyTableView;

    [focusCompanyTableView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.equalTo(searchBtn.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-44);
    }];
    UILabel* zeroMessageLabel = [[UILabel alloc] init];
    zeroMessageLabel.font = [UIFont systemFontOfSize:KFontSizePX(32)];
    zeroMessageLabel.textColor = [UIColor grayColor];
    zeroMessageLabel.text = [GYUtils localizedStringWithKey:@"GYHD_zero_company"];
    [self.view addSubview:zeroMessageLabel];
    _zeroMessageLabel = zeroMessageLabel;
    WS(weakSelf);
    [zeroMessageLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.center.equalTo(weakSelf.view);
    }];
    
    UIButton*addCompanyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    addCompanyBtn.frame=CGRectMake(0, 0, 32, 32);
    
    [addCompanyBtn addTarget:self action:@selector(addCompanyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [addCompanyBtn setBackgroundImage:[UIImage imageNamed:@"gyhd_contants_addfriend_icon"] forState:UIControlStateNormal];
    
//    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:addCompanyBtn];

}
- (void)addCompanyBtnClick {
    GYHDSearchFriendViewController *vc=[[GYHDSearchFriendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData
{
    if (globalData.isLogined) {
        
    
    WS(weakSelf);
    NSArray* DBArray = [[GYHDMessageCenter sharedInstance] EasyBuyGetMyConcernShopUrlRequetResult:^(NSArray* resultArry) {
        if (!resultArry) return;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.focusCompanyArray = [weakSelf companyPinYinGroupWithArray:resultArry];
            [weakSelf.focusCompanyTableView reloadData];
        });
    }];
    weakSelf.focusCompanyArray = [weakSelf companyPinYinGroupWithArray:DBArray];
    [weakSelf.focusCompanyTableView reloadData];
    }
}

/**好友按字母分组*/
- (NSMutableArray*)companyPinYinGroupWithArray:(NSArray*)array
{
    NSArray* ABCArray = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#", nil];
    NSMutableArray* friendGroupArray = [NSMutableArray array];
    for (NSString* key in ABCArray) {
        GYHDFocusCompanyGroupModel* companyGroupModel = [[GYHDFocusCompanyGroupModel alloc] init];

        for (NSDictionary* dict in array) {

            //1. 转字母
            NSString* tempStr = dict[@"Friend_Name"];
            if (tempStr) {
                tempStr = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (!tempStr || tempStr.length == 0) {
                tempStr = @"未设置名称";
            }
            if ([GYUtils isIncludeChineseInString:tempStr]) {
                tempStr = [GYPinYinConvertTool chineseConvertToPinYinHead:tempStr];
            }
            //2. 获取首字母
            NSString* firstLetter;
            if (tempStr.length >= 1) {
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }
            if (![ABCArray containsObject:firstLetter]) {
                tempStr = [@"#" stringByAppendingString:tempStr];
                firstLetter = [[tempStr substringToIndex:1] uppercaseString];
            }

            //3. 加入数组
            if ([firstLetter isEqualToString:key]) {

                companyGroupModel.focusCompanyGroupTitle = key;
                GYHDFocusCompanyModel* companyModel = [[GYHDFocusCompanyModel alloc] initWithDictionary:dict];
                [companyGroupModel.focusCompanyGroupArray addObject:companyModel];
            }
        }
        if (companyGroupModel.focusCompanyGroupTitle && companyGroupModel.focusCompanyGroupArray.count > 0) {
            [friendGroupArray addObject:companyGroupModel];
        }
    }
    if (friendGroupArray.count > 0) {
        self.zeroMessageLabel.hidden = YES;
    }
    else {
        self.zeroMessageLabel.hidden = NO;
    }
    return friendGroupArray;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.focusCompanyArray.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GYHDFocusCompanyGroupModel* groupModel = self.focusCompanyArray[section];
    return groupModel.focusCompanyGroupArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYHDFocusCompanyCell* cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDFocusCompanyCellID"];
    GYHDFocusCompanyGroupModel* groupModel = self.focusCompanyArray[indexPath.section];
    GYHDFocusCompanyModel* model = groupModel.focusCompanyGroupArray[indexPath.row];
    cell.model = model;
    return cell;
}

//- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
//{
//    GYHDFocusCompanyGroupModel* groupModel = self.focusCompanyArray[section];
//    return groupModel.focusCompanyGroupTitle;
//}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 18)];
     GYHDFocusCompanyGroupModel* groupModel = self.focusCompanyArray[section];
    label.textColor = [UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    label.backgroundColor = [UIColor colorWithRed:235.0 / 255.0f green:235.0 / 255.0f blue:235.0 / 255.0f alpha:1.0f];
    label.font = [UIFont systemFontOfSize:KFontSizePX(24)];
    label.text =  [NSString stringWithFormat:@"  %@",groupModel.focusCompanyGroupTitle];
    return label;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 66.0f;
}

- (nullable NSArray<NSString*>*)sectionIndexTitlesForTableView:(UITableView*)tableView
{
    NSMutableArray* titleArray = [NSMutableArray array];
    for (GYHDFocusCompanyGroupModel* groupModel in self.focusCompanyArray) {
        [titleArray addObject:groupModel.focusCompanyGroupTitle];
    }
    return titleArray;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYHDFocusCompanyGroupModel* groupModel = self.focusCompanyArray[indexPath.section];
    GYHDFocusCompanyModel* model = groupModel.focusCompanyGroupArray[indexPath.row];
//    GYShopAboutViewController* vc = [[GYShopAboutViewController alloc] init];
//    vc.strVshopId = model.focusCompanyVshopID;
    GYHDChatViewController *vc = [[GYHDChatViewController alloc] init];
    vc.messageCard =model.focusCompanyCustID;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)longtap:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan)
        return;
    CGPoint location = [longPress locationInView:self.focusCompanyTableView];
    NSIndexPath* indexPath = [self.focusCompanyTableView indexPathForRowAtPoint:location];
    if (!indexPath)
        return;
    GYHDFocusCompanyGroupModel* groupModel = self.focusCompanyArray[indexPath.section];
    GYHDFocusCompanyModel* model = groupModel.focusCompanyGroupArray[indexPath.row];
    NSArray* messageArray = @[ model.focusCompanyName, [GYUtils localizedStringWithKey:@"GYHD_Company_share_it"], [GYUtils localizedStringWithKey:@"GYHD_Company_share_cancle"] ];
    GYHDPopMessageTopView* messageTopView = [[GYHDPopMessageTopView alloc] initWithMessageArray:messageArray];
    [messageTopView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.size.mas_equalTo(CGSizeMake(270.0f, 138.0f));
    }];
    GYHDPopView* popView = [[GYHDPopView alloc] initWithChlidView:messageTopView];
    [popView showToView:self.navigationController.view];
    WS(weakSelf)
    messageTopView.block = ^(NSString* string) {
        if ([string isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Company_share_it"]]) {
            @try {
                [weakSelf shareWithMode:model];
            }
            @catch (NSException *exception) {
       
            }
            @finally {
                [popView disMiss];
            }

        } else if ([string isEqualToString:[GYUtils localizedStringWithKey:@"GYHD_Company_share_cancle"]]) {
            [weakSelf unsubscribeWithMode:model];
        }

        [popView disMiss];
    };
}

- (void)unsubscribeWithMode:(GYHDFocusCompanyModel*)model
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%@", model.focusCompanyVshopID] forKey:@"vShopId"];
    [dict setValue:@"" forKey:@"shopId"];
    [dict setValue:globalData.loginModel.token forKey:@"key"];
    WS(weakSelf);
    [[GYHDMessageCenter sharedInstance] CancelConcernShopUrlWithDict:dict RequetResult:^(NSDictionary* resultDict) {
        [weakSelf loadData];
    }];
}

- (void)shareWithMode:(GYHDFocusCompanyModel*)model
{

    
    
    GYSocialDataModel *tempModel = [[GYSocialDataModel alloc]init];
    NSString* shopString = model.focusCompanyUrlString;
    tempModel.toUrl = shopString;
    NSString* shareContent = [NSString stringWithFormat:@"%@  %@", shopString, model.focusCompanyName];
    
    
    tempModel.content = shareContent;
    tempModel.title = [GYUtils localizedStringWithKey:@"GYHD_Company_share"];
    
    YYWebImageManager *manager = [YYWebImageManager sharedManager ];
 
    
    [manager requestImageWithURL:[NSURL URLWithString:model.focusCompanyIcon] options:kNilOptions progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (!error) {
            tempModel.image = image;
        }
        [GYSocialDataService postWithSocialDataModel:tempModel  presentedController:self];
        
    }];
    
    
 }

- (void)searchBtnClick {
    NSLog(@"搜索企业");
    GYHDSeachMessageViewController* seachMessageViewController = [[GYHDSeachMessageViewController alloc] init];
    [self.navigationController pushViewController:seachMessageViewController animated:YES];
}

@end
