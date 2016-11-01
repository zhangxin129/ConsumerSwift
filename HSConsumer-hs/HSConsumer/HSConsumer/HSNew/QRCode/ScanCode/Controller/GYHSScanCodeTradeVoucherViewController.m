
//
//  GYHSScanCodeTradeVoucherViewController.m
//  HSConsumer
//
//  Created by admin on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScanCodeTradeVoucherViewController.h"
#import "GYHSTradeVoucherTitleTableViewCell.h"
#import "GYHSTradeVoucherNumberTableViewCell.h"
#import "GYHSScanCodeInfoTableViewCell.h"
#import "GYHSVoucherModel.h"

#define kTitleCell @"tradeVoucherTitleTableViewCell"
#define kNumberCell @"tradeVoucherNumberTableViewCell"
#define kInfoCell @"scanCodeInfoTableViewCell"

@interface GYHSScanCodeTradeVoucherViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tabView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *valueArray;

@end

@implementation GYHSScanCodeTradeVoucherViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tabView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        if ([self.codeClass isEqualToString:@"01030"] || [self.codeClass isEqualToString:@"01031"]) {
            if (globalData.loginModel.cardHolder) {
                return 1;
            } else {
                return 0;
            }
        } else if ([self.codeClass isEqualToString:@"01034"]) {
            return 1;
        } else {
            if (globalData.loginModel.cardHolder) {
                return 2;
            } else {
                return 1;
            }
        }
    }
    return section + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        GYHSTradeVoucherTitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:kTitleCell forIndexPath:indexPath];
        if ([self.codeClass isEqualToString:@"01034"]) {
            titleCell.titleLabel.text = kLocalized(@"预付定金凭证");
        } else if ([self.codeClass isEqualToString:@"01030"] || [self.codeClass isEqualToString:@"01031"]) {
            titleCell.titleLabel.text = kLocalized(@"积分凭证");
        } else {
            titleCell.titleLabel.text = kLocalized(@"交易凭证");
        }
        titleCell.dateLabel.text = self.model.date;//kLocalized(@"2016-9-27 20:50:30");
        return titleCell;
    } else if (indexPath.section == 1) {
        GYHSTradeVoucherNumberTableViewCell *numberCell = [tableView dequeueReusableCellWithIdentifier:kNumberCell forIndexPath:indexPath];
        if (indexPath.row == 0) {
            if ([self.codeClass isEqualToString:@"01030"] || [self.codeClass isEqualToString:@"01031"]) {
                if (globalData.loginModel.cardHolder) {
                    numberCell.iconImageView.image = [UIImage imageNamed:@"gycommon_pv"];
                    numberCell.titleLabel.text = kLocalized(@"积分");
                    numberCell.numberLabel.textColor = kCorlorFromRGBA(240, 62, 52, 1);
                    numberCell.numberLabel.text = [NSString stringWithFormat:@"+%@",[GYUtils formatCurrencyStyle:[self.model.pvNum doubleValue]]];//@"+1000.00";
                }
            } else {
                numberCell.iconImageView.image = [UIImage imageNamed:@"gycommon_hscoin"];
                numberCell.titleLabel.text = kLocalized(@"支付互生币");
                numberCell.numberLabel.textColor = kCorlorFromRGBA(0, 138, 35, 1);
                numberCell.numberLabel.text = [NSString stringWithFormat:@"-%@",[GYUtils formatCurrencyStyle:[self.model.hsbAmount doubleValue]]];//@"-2000000.00";
            }

        } else if (indexPath.row == 1) {
            numberCell.iconImageView.image = [UIImage imageNamed:@"gycommon_pv"];
            numberCell.titleLabel.text = kLocalized(@"积分");
            numberCell.numberLabel.textColor = kCorlorFromRGBA(240, 62, 52, 1);
            numberCell.numberLabel.text = [NSString stringWithFormat:@"+%@",[GYUtils formatCurrencyStyle:[self.model.pvNum doubleValue]]];//@"+1000.00";
        }
        return numberCell;
    } else {
        GYHSScanCodeInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:kInfoCell forIndexPath:indexPath];
        infoCell.titleLabel.text = self.titleArray[indexPath.row];
        if (indexPath.row == 1) {
            infoCell.contentTextField.text = [GYUtils formatCurrencyStyle:[self.valueArray[indexPath.row] doubleValue]];
        } else {
            infoCell.contentTextField.text = self.valueArray[indexPath.row];
        }
        infoCell.userInteractionEnabled = NO;
        return infoCell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 74.0f;
    } else if (indexPath.section == 1) {
        return 50.0f;
    } else {
        return 44.0f;
    }
}

#pragma mark - lazyLoad
- (UITableView *)tabView {
    if (!_tabView) {
        _tabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
        _tabView.delegate = self;
        _tabView.dataSource = self;
        _tabView.sectionHeaderHeight = 0.001f;
        _tabView.sectionFooterHeight = 0.001f;
        _tabView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.1)];
        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSTradeVoucherTitleTableViewCell class]) bundle:nil] forCellReuseIdentifier:kTitleCell];
        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSTradeVoucherNumberTableViewCell class]) bundle:nil] forCellReuseIdentifier:kNumberCell];
        [_tabView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHSScanCodeInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:kInfoCell];
    }
    return _tabView;
}

//扫码付---01029（自己设的）
//积分码---消费积分消息	01030
//积分码---网上订单支付	01031
//支付码---消费积分     01032
//支付码---网上订单支付	01033
//支付码---互生币预付定金	01034
- (NSArray *)titleArray {
    if (!_titleArray) {
        
        if ([self.codeClass isEqualToString:@"01030"]) {
            _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"订单金额"),kLocalized(@"订单号")];
        } else if ([self.codeClass isEqualToString:@"01031"]) {
            _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"消费金额"),kLocalized(@"交易流水")];
        } else if ([self.codeClass isEqualToString:@"01032"]) {
            if (globalData.loginModel.cardHolder) {
                _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"消费金额"),kLocalized(@"交易流水")];
            } else {
                _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"订单金额"),kLocalized(@"订单号")];
            }
        } else if ([self.codeClass isEqualToString:@"01033"]) {
            if (globalData.loginModel.cardHolder) {
                _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"订单金额"),kLocalized(@"订单号")];
            } else {
                _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"消费金额"),kLocalized(@"交易流水")];
            }
        } else if ([self.codeClass isEqualToString:@"01034"]) {
            _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"预付定金"),kLocalized(@"交易流水")];
        } else {
            _titleArray = @[kLocalized(@"消费商家"),kLocalized(@"消费金额"),kLocalized(@"交易流水")];
        }
        
    }
    return _titleArray;
}

- (NSArray *)valueArray {
    if (!_valueArray) {
        _valueArray = @[self.model.shopName,self.model.AmountNum,self.model.orderNum];
    }
    return _valueArray;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
