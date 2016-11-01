//
//  GYHDCompanyListView.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCompanyListView.h"
#import "GYHDSaleListGrounpModel.h"
@interface GYHDCompanyListView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UIButton *checkAllOperatorBtn;
@property (nonatomic,assign) BOOL backColor;
@end
@implementation GYHDCompanyListView

- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.checkAllOperatorBtn.frame.size.height, self.frame.size.width, self.frame.size.height-44) style:UITableViewStylePlain];
        tableView.rowHeight = 87;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _dataSource=[[NSMutableArray alloc]init];
        _companyOperatorArr=[NSMutableArray array];
        
        self.checkAllOperatorBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        self.checkAllOperatorBtn.frame=CGRectMake(0, 0, self.frame.size.width, 87);
        
        [self.checkAllOperatorBtn setTitle:@"所有操作员" forState:UIControlStateNormal];
        self.checkAllOperatorBtn .titleEdgeInsets=UIEdgeInsetsMake(0,-140, 0, 0);
//        self.checkAllOperatorBtn.titleLabel.textAlignment=NSTextAlignmentLeft;
        [self.checkAllOperatorBtn setTitleColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.checkAllOperatorBtn addTarget:self action:@selector(checkClick) forControlEvents:UIControlEventTouchUpInside];
        
          NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
        
        self.checkAllOperatorBtn.backgroundColor=[UIColor whiteColor];
        
        if ([indexstr integerValue]==-1) {
            
            self.checkAllOperatorBtn.backgroundColor=[UIColor colorWithRed:196.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
        }
        
        [self addSubview:self.checkAllOperatorBtn];
        
        [self.tableView reloadData];
        
    }
    return self;
}

-(void)checkClick{
    

    self.checkAllOperatorBtn.backgroundColor=[UIColor colorWithRed:196.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
   
    if (_delegate && [_delegate respondsToSelector:@selector(refreshSaleListViewWithArry:)]) {
        
        [_delegate refreshSaleListViewWithArry:self.companyOperatorArr];
    }
    NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
    
    indexstr=[NSString stringWithFormat:@"%d",-1];
    
    [[NSUserDefaults standardUserDefaults] setObject:indexstr forKey:@"selectIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.backColor=YES;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"msgCompanyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    GYHDSaleListGrounpModel*model=self.dataSource[indexPath.row];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text =model.OperatorRelationName;
        nameLabel.textAlignment=NSTextAlignmentLeft;
        nameLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
        nameLabel.font = [UIFont systemFontOfSize:18];
        [cell addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(20);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
        
        }
    if (self.backColor) {
        
        cell.backgroundColor=[UIColor whiteColor];
        
    }
    
    NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
    
    if ([indexstr integerValue]==indexPath.row) {
        
        cell.backgroundColor=[UIColor colorWithRed:196.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:196.0/255.0 green:235.0/255.0 blue:255.0/255.0 alpha:1.0];
    self.checkAllOperatorBtn.backgroundColor=[UIColor whiteColor];
    GYHDSaleListGrounpModel*model=self.dataSource[indexPath.row];
    
    if (_delegate&&[_delegate respondsToSelector:@selector(refreshSaleListViewWithModel:)]) {
        
        [_delegate refreshSaleListViewWithModel:model];
        
    }
    
    NSString*indexstr=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectIndex"];
    
    indexstr=[NSString stringWithFormat:@"%ld",indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setObject:indexstr forKey:@"selectIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.backColor=YES;
    
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    

}

@end
