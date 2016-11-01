//
//  GYHEAlTakeDishesViewController.m
//  HSCompanyPad
//
//  Created by apple on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHEAlTakeDishesViewController.h"
#import "UILabel+Category.h"
#import "GYHEAlTakeDishesTableViewCell.h"


@interface GYHEAlTakeDishesViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *numLable;
@property (nonatomic, strong) UILabel *totalAccountLable;
@property (nonatomic, strong) UILabel *pointLable;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GYHEAlTakeDishesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createHeadUI];
    [self createFooterUI];
    [self createTableViewUI];
}
- (void)createHeadUI{

    self.title = kLocalized(@"已点单");
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kScreenWidth, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    [headImageView setImage:[UIImage imageNamed:@"gyhs_staff_searchBackground"]];
    [headView addSubview:headImageView];
    
    float dishNameLableW = 200;
    float dishPriceLableW = 100;
    float dishPointLableW = 100;
    float reduceDishButtonW = 30;
    float addDishButtonW = 30;
    float dishNumLableW = 40;
    float deleteAndRecoverButtonW = 40;
    float spaceW = (kScreenWidth - dishNameLableW - dishPriceLableW - dishPointLableW - reduceDishButtonW - dishNumLableW - addDishButtonW - deleteAndRecoverButtonW) / 5;

    
    UILabel *dishNameLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, dishNameLableW, 20)];
    [dishNameLable initWithText:kLocalized(@"菜品名称") TextColor:[UIColor lightGrayColor] Font:[UIFont systemFontOfSize:18] TextAlignment:1];
    [headView addSubview:dishNameLable];
    
    UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + spaceW + dishNameLableW, 10, 20, 20)];
    [coinImageView setImage:[UIImage imageNamed:@"gyhe_coin_icon"]];
    [headView addSubview:coinImageView];
    
    UILabel *dishPriceLable = [[UILabel alloc] initWithFrame:CGRectMake(20 + spaceW + dishNameLableW, 10, dishPriceLableW, 20)];
    [dishPriceLable initWithText:kLocalized(@"单价") TextColor:[UIColor lightGrayColor] Font:[UIFont systemFontOfSize:18] TextAlignment:1];
    [headView addSubview:dishPriceLable];
    
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + spaceW * 2 + dishNameLableW + dishPriceLableW, 10, 20, 20)];
    [pointImageView setImage:[UIImage imageNamed:@"gyhe_point_icon"]];
    [headView addSubview:pointImageView];
    
    UILabel *dishPointLable = [[UILabel alloc] initWithFrame:CGRectMake(20 + spaceW * 2 + dishNameLableW + dishPriceLableW, 10, dishPriceLableW, 20)];
    [dishPointLable initWithText:kLocalized(@"积分") TextColor:[UIColor lightGrayColor] Font:[UIFont systemFontOfSize:18] TextAlignment:1];
    [headView addSubview:dishPointLable];

    UILabel *dishNumLable = [[UILabel alloc] initWithFrame:CGRectMake(20 + spaceW * 3 + dishNameLableW + dishPriceLableW + dishPointLableW, 10, dishPriceLableW, 20)];
    [dishNumLable initWithText:kLocalized(@"数量") TextColor:[UIColor lightGrayColor] Font:[UIFont systemFontOfSize:18] TextAlignment:1];
    [headView addSubview:dishNumLable];
    
    UILabel *oprateLable = [[UILabel alloc] initWithFrame:CGRectMake(20 + spaceW * 4 + dishNameLableW + dishPriceLableW + dishPointLableW + dishNumLableW + addDishButtonW, 10, dishPriceLableW, 20)];
    [oprateLable initWithText:kLocalized(@"操作") TextColor:[UIColor lightGrayColor] Font:[UIFont systemFontOfSize:18] TextAlignment:1];
    [headView addSubview:oprateLable];
}

- (void)createTableViewUI{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 94, kScreenWidth, kScreenHeight - 94 - 50 - 90)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GYHEAlTakeDishesTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"alTakeDishesTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)createFooterUI{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 50 - 44 - 40, kScreenWidth, 50)];
    footerView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:221 / 255.0 blue:223 / 255.0 alpha:1.0];
    [self.view addSubview:footerView];
    
    UILabel *numTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 60, 20)];
    [numTitleLable initWithText:kLocalized(@"数量：") TextColor:[UIColor blackColor] Font:[UIFont systemFontOfSize:18] TextAlignment:2];
    [footerView addSubview:numTitleLable];
    
    self.numLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numTitleLable.frame), 15, 60, 20)];
    [self.numLable initWithText:@"100" TextColor:[UIColor blackColor] Font:[UIFont systemFontOfSize:18] TextAlignment:0];
    [footerView addSubview:self.numLable];
    
    UILabel *totalAccountTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.numLable.frame) + 10, 15, 60, 20)];
    [totalAccountTitleLable initWithText:kLocalized(@"总额：")  TextColor:[UIColor blackColor] Font:[UIFont systemFontOfSize:18] TextAlignment:2];
    [footerView addSubview:totalAccountTitleLable];
    
    UIImageView *coinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalAccountTitleLable.frame), 15, 20, 20)];
    [coinImageView setImage:[UIImage imageNamed:@"gyhe_coin_icon"]];
    [footerView addSubview:coinImageView];
    
    self.totalAccountLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(coinImageView.frame), 15, 60, 20)];
    [self.totalAccountLable initWithText:@"100.00" TextColor:[UIColor redColor] Font:[UIFont systemFontOfSize:18] TextAlignment:0];
    [footerView addSubview:self.totalAccountLable];
    
    UILabel *pointTitleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalAccountLable.frame) + 10, 15, 60, 20)];
    [pointTitleLable initWithText:kLocalized(@"积分：")  TextColor:[UIColor blackColor] Font:[UIFont systemFontOfSize:18] TextAlignment:2];
    [footerView addSubview:pointTitleLable];
    
    UIImageView *pointImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pointTitleLable.frame), 15, 20, 20)];
    [pointImageView setImage:[UIImage imageNamed:@"gyhe_point_icon"]];
    [footerView addSubview:pointImageView];
    
    self.pointLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pointImageView.frame), 15, 60, 20)];
    [self.pointLable initWithText:@"100.00" TextColor:[UIColor redColor] Font:[UIFont systemFontOfSize:18] TextAlignment:0];
    [footerView addSubview:self.pointLable];
    
    UIButton *orderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    orderButton.frame = CGRectMake(kScreenWidth - 120, 10, 100, 30);
    orderButton.backgroundColor = [UIColor redColor];
    [orderButton setTitle:kLocalized(@"下单")  forState:UIControlStateNormal];
    orderButton.layer.cornerRadius = 6;
    [footerView addSubview:orderButton];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GYHEAlTakeDishesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"alTakeDishesTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



@end
