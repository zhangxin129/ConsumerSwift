//
//  GYHDCustomerListView.m
//  HSEnterprise
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDCustomerListView.h"
#import "GYHDCustomerInfoViewController.h"
#import "GYHDCustomerCell.h"
#import "GYHDChatViewController.h"
#import "GYHDCustomerViewController.h"
#import "GYHDChatViewController.h"
#import "GYHDDataBaseCenter.h"
@interface GYHDCustomerListView()<UITableViewDataSource,UITableViewDelegate,GYHDCustomerDelegate>
@end

@implementation GYHDCustomerListView

- (UITableView *)tableView {

    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:self.frame style:UITableViewStylePlain];
        tableView.frame = self.bounds;
        tableView.rowHeight = 67;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[GYHDCustomerCell class] forCellReuseIdentifier:@"GYCustomerCell"];
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.dataSource= [NSMutableArray array];
      
    }
    return self;
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHDCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYCustomerCell"];
    
//    cell.headBlock=^(GYHDCustomerModel*model){
//    
//        [self headClick:model];
//        
//    };
    cell.delegate=self;
    
      NSString*customerIndex=[[NSUserDefaults standardUserDefaults] objectForKey:@"customerIndex"];
  
    GYHDCustomerModel*model=self.dataSource[indexPath.row];
    
    if ([model.Friend_CustID isEqualToString:customerIndex]) {
        
        model.isSelect=YES;
        model.messageUnreadCount=@"";
        [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:model.MSG_Card];
    }else{
    
        model.isSelect=NO;
    }
    
    [cell refreshUIWithModle:model];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource>0) {
        
        self.dele.view.hidden=NO;
    }
    
    GYHDCustomerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    for (GYHDCustomerModel*model in self.dataSource) {
        
        model.isSelect=NO;
    }

    GYHDCustomerModel*model=self.dataSource[indexPath.row];
    
    if (cell.delegate && [cell.delegate respondsToSelector:@selector(refreshChatViewControllerWithModel:)]) {
        
        
        [cell.delegate refreshChatViewControllerWithModel:model];
        
    }
    
    [[GYHDDataBaseCenter sharedInstance] ClearUnreadMessageWithCard:model.MSG_Card];
    
    model.messageUnreadCount=@"";
    model.isSelect =YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:model.Friend_CustID forKey:@"customerIndex"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
    
}

//点击进入客户信息 列表头像改为从点击聊天界面头像进入客户信息界面
-(void)headClick:(GYHDCustomerModel*)model{
    
//    GYHDCustomerInfoViewController*vc=[[GYHDCustomerInfoViewController alloc]init];
//    vc.model=model;
//    [self.delegate.navigationController pushViewController:vc animated:YES];
    
}

-(void)refreshChatViewControllerWithModel:(GYHDCustomerModel *)model{
    self.dele.isFromSearch=NO;
    self.dele.messageCard=model.Friend_CustID;
    self.dele.model=model;
    self.dele.leftHeadIconStr=model.Friend_Icon;
    self.dele.rightHeadIconStr=globalData.loginModel.headPic;
}
@end
