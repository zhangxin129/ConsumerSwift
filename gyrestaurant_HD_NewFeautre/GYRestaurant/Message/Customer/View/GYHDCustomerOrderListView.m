//
//  GYHDCustomerOrderListView.m
//  HSEnterprise
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCustomerOrderListView.h"
#import "GYHDCustomerOrderListCell.h"
#import "GYOrderInDetailViewController.h"
@interface GYHDCustomerOrderListView()<UITableViewDataSource,UITableViewDelegate,GYHDCustomerOrderListCellDelegate>
@end

@implementation GYHDCustomerOrderListView

- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        tableView.frame = self.bounds;
        tableView.rowHeight = 150.0;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[GYHDCustomerOrderListCell class] forCellReuseIdentifier:@"GYHDCustomerOrderListCell"];
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (void)setup {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 41)];
    headerView.backgroundColor = kDefaultVCBackgroundColor;
    
    UIImageView *blueImageView = [[UIImageView alloc]init];
    blueImageView.image = [UIImage imageNamed:@"icon_ts"];
    [headerView addSubview:blueImageView];
    [blueImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.left.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(4, 20));
    }];
    
    UILabel *baceInfoLabel = [[UILabel alloc]init];
    baceInfoLabel.text = @"订单信息";
    baceInfoLabel.textColor = [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0];
    baceInfoLabel.font = [UIFont systemFontOfSize:20.0];
    [headerView addSubview:baceInfoLabel];
    [baceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blueImageView.mas_right).offset(18);
        make.bottom.mas_equalTo(-10);
        make.right.mas_equalTo(-12);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [self addSubview:headerView];
    self.tableView.frame=CGRectMake(0, CGRectGetMaxY(headerView.frame), self.frame.size.width, self.frame.size.height-41);
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"GYHDCustomerOrderListCell";
    GYHDCustomerOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.dataSource.count>0) {
        
        GYHDCustomerOrderListModel*model=self.dataSource[indexPath.row];
        [cell refreshUIWithModel:model];
        cell.delegate=self;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = kDefaultVCBackgroundColor;
    return cell;
    
}

-(void)pushOrderDetailWithModel:(GYHDCustomerOrderListModel *)model{

    GYOrderInDetailViewController*vc=[[GYOrderInDetailViewController alloc]init];
    
    NSMutableDictionary*dict=[NSMutableDictionary dictionary];
    
    if (model.userId==nil) {
        
        [dict setObject:@"" forKey:@"userId"];
        
    }else{
    
        [dict setObject:model.userId forKey:@"userId"];
    }

    if (model.orderId==nil) {
        
         [dict setObject:@""forKey:@"orderId"];
    }else{
    
        [dict setObject:model.orderId forKey:@"orderId"];
    }
    
    vc.infoDic=dict;
    vc.status=model.orderStatusN;
    vc.strType=model.orderTypeStr;
    [self.delegate.navigationController pushViewController:vc animated:YES];
    
}
@end
