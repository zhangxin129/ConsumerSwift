//
//  GYHEShopFoodOrderViewController.m
//  HSConsumer
//
//  Created by xiongyn on 16/10/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopFoodOrderViewController.h"
#import "Masonry.h"
#import "GYHETools.h"
#import "GYHEShopFoodOrderCell.h"
#import "GYHEShopFoodOrderBottomView.h"
#import "GYHEShopFoodOrderFooterCell.h"
#import "GYHEShopFoodOrderPayTypeCell.h"
#import "GYHEShopFoodOrderSendTimeCell.h"
#import "GYHEHeadViewThirdCell.h"
#import "GYHEHeadViewFourthCell.h"
#import "GYHEShopFoodOrderHSCardCell.h"

#define kGYHEShopFoodOrderCell @"GYHEShopFoodOrderCell"
#define kGYHEHeadViewThirdCell @"GYHEHeadViewThirdCell"
#define kGYHEHeadViewFourthCell @"GYHEHeadViewFourthCell"
#define kGYHEShopFoodOrderSendTimeCell @"GYHEShopFoodOrderSendTimeCell"
#define kGYHEShopFoodOrderPayTypeCell @"GYHEShopFoodOrderPayTypeCell"
#define kGYHEShopFoodOrderHSCardCell @"GYHEShopFoodOrderHSCardCell"
#define kGYHEShopFoodOrderFooterCell @"GYHEShopFoodOrderFooterCell"

@interface GYHEShopFoodOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tabView;
@property (nonatomic , assign) BOOL hasAddress;
@property (nonatomic , assign) BOOL canApplyHsCard;

@end

@implementation GYHEShopFoodOrderViewController

#pragma mark - cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    _hasAddress = NO;
    _canApplyHsCard = YES;
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xfb7d00);
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return self.dataArr.count;

    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        
        GYHEHeadViewThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewThirdCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.lineView.hidden = YES;
        if(_hasAddress) {
            cell.hidden = YES;
        }else {
            cell.hidden = NO;
        }
        return cell;
    }else if(indexPath.row == 1) {
    
        GYHEHeadViewFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEHeadViewFourthCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        cell.lineView.hidden = YES;
        if(_hasAddress) {
            cell.hidden = NO;
        }else {
            cell.hidden = YES;
        }
        
        return cell;
    
    }else if(indexPath.row == 2) {
        GYHEShopFoodOrderSendTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodOrderSendTimeCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        return cell;
    }else if(indexPath.row == 3) {
        GYHEShopFoodOrderPayTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodOrderPayTypeCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        return cell;
    }else if(indexPath.row == 4) {
        
        GYHEShopFoodOrderHSCardCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodOrderHSCardCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if(_canApplyHsCard) {
            cell.hidden = NO;
        }else {
            cell.hidden = YES;
        }
        return cell;
        
    }else if(indexPath.row == 8) {
        GYHEShopFoodOrderFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodOrderFooterCell forIndexPath:indexPath];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }

        return cell;
    }
    GYHEShopFoodOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:kGYHEShopFoodOrderCell forIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(_hasAddress) {
        if(indexPath.row == 0) {
            return 0;
        }else if (indexPath.row == 1) {
            return 95;
        }
    }else {
        if(indexPath.row == 0) {
            return 50;
        }else if (indexPath.row == 1) {
            return 0;
        }
    }
    
    if(indexPath.row == 4) {
        if(_canApplyHsCard) {
            return 50;
        }else {
            return 0;
        }
    }
    
    if(indexPath.row == 8) {
        return 95;
    }
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        _hasAddress = YES;
        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)setUI {
    self.title = kLocalized(@"提交订单");
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tabView = [[UITableView alloc] init];
    _tabView.delegate = self;
    _tabView.dataSource = self;
    _tabView.tableFooterView = [[UIView alloc] init];
    _tabView.separatorColor = kCellLineGary;
    [self.view addSubview:_tabView];
    [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kScreenHeight - 64 - 42 - 46);

    }];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodOrderCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodOrderCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewThirdCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewThirdCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEHeadViewFourthCell class]) bundle:nil] forCellReuseIdentifier:kGYHEHeadViewFourthCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodOrderPayTypeCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodOrderPayTypeCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodOrderSendTimeCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodOrderSendTimeCell];
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodOrderHSCardCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodOrderHSCardCell];
    
    [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEShopFoodOrderFooterCell class]) bundle:nil] forCellReuseIdentifier:kGYHEShopFoodOrderFooterCell];
    
    UIView *view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 10)];
    UIImageView * imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_servicelist_roseline"]];
    imgv.frame = CGRectMake(0, 8, kScreenWidth, 2);
    [view addSubview:imgv];
    _tabView.tableHeaderView = view;
    
    
    GYHEShopFoodOrderBottomView *bottom = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYHEShopFoodOrderBottomView class]) owner:self options:0][0];

    [self.view addSubview:bottom];
    [bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_tabView.mas_bottom);
        make.height.mas_equalTo(42);
    }];
}


@end
