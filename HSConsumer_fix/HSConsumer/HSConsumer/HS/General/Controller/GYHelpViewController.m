//
//  GYHelpViewController.m
//  HSConsumer
//
//  Created by 00 on 14-12-5.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHelpViewController.h"
#import "GYGeneralTableViewCell.h"

@interface GYHelpViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSArray* arrDataL; //标题数组
    NSArray* arrDataR; //内容数组
}

@property (nonatomic, strong) UITableView* tbvHelp;

@end

@implementation GYHelpViewController

#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrDataL = [NSArray arrayWithObjects:
                kLocalized(@"GYHS_General_PlatformHotline"),
                kLocalized(@"GYHS_General_PlatformEmail"),
                kLocalized(@"GYHS_General_PlatformAddress"),
                kLocalized(@"GYHS_General_AccountName"),
                kLocalized(@"GYHS_General_OpenAnAccountbank"),
                kLocalized(@"GYHS_General_Account"),
                nil];
    
    arrDataR = [NSArray arrayWithObjects:
                @"0755-83344111",
                @"cs@hsxt.com", // 之前是es
                kLocalized(@"GYHS_General_ShenzhenFutianDistrictFuZhongRoadProspectingInstituteBuilding7"),
                kLocalized(@"GYHS_General_ShenzhenINTERGROWTHTechnologyCOLTD"),
                kLocalized(@"GYHS_General_TheBankOfChinaShenzhenZhongxingBranch"),
                @"7640 6170 4406",
                nil];
    [self initUI];
}


//#pragma mark - SystemDelegate

#pragma mark TableView Delegate
//设置Section 个数 组头高度 组尾高度 组头背景图 组尾背景图
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 16.0;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 16.0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 16)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    //设置下边框
    [view addBottomBorder];
    return view;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    view.backgroundColor = kDefaultVCBackgroundColor;
    //设置上边框
    [view addTopBorder];
    return view;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GYGeneralTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    //重设置自定义cell 控件位置、字体大小、字体颜色
    cell.iconImageView.hidden = YES;
    cell.imgRightArrow.hidden = YES;
    cell.lbVersions.frame = CGRectMake(116, 1, 179, 42);
    cell.lbVersions.numberOfLines = 0;
    cell.lbVersions.textAlignment = NSTextAlignmentLeft;
    cell.lbVersions.font = [UIFont systemFontOfSize:14];
    cell.lbTitle.textColor = kCellItemTitleColor;
    cell.lbVersions.textColor = kCellItemTextColor;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        if (arrDataL.count > indexPath.row) {
            cell.lbTitle.text = arrDataL[indexPath.row];
        }
        if (arrDataR.count > indexPath.row) {
            cell.lbVersions.text = arrDataR[indexPath.row];
        }
    }
    else {
        cell.lbVersions.frame = CGRectMake(96, 1, 189, 42);
        if (arrDataL.count > indexPath.row + 3) {
            cell.lbTitle.text = arrDataL[indexPath.row+3];
        }
        if (arrDataR.count > indexPath.row + 3) {
            cell.lbVersions.text = arrDataR[indexPath.row+3];
        }   
    }
    return cell;
}

//#pragma mark - CustomDelegate
//#pragma mark - event response

#pragma mark - private methods
- (void)initUI
{
    //注册自定义cell
    [self.tbvHelp registerNib:[UINib nibWithNibName:@"GYGeneralTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:self.tbvHelp];
}

#pragma mark - getters and setters
- (UITableView*)tbvHelp
{
    if (_tbvHelp == nil) {
        _tbvHelp = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        _tbvHelp.delegate = self;
        _tbvHelp.dataSource = self;
        _tbvHelp.scrollEnabled = NO;
    }
    return _tbvHelp;
}

@end
