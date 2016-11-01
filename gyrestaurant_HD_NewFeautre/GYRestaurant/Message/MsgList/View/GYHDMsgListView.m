//
//  GYHDMsgListView.m
//  HSEnterprise
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 guiyi. All rights reserved.
//

#import "GYHDMsgListView.h"
#import "GYOrderMessageListModel.h"
#import "GYHDMsgListCell.h"
#import "GYHDMsgShowPageController.h"
#import "GYHDMessageCenter.h"
#import "GYMsgListContentController.h"
@interface GYHDMsgListView()<UITableViewDataSource,UITableViewDelegate,GYHDMsgListCellDelegate>
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, assign) CGFloat rowHight;
@end

@implementation GYHDMsgListView

- (UITableView *)tableView {
    
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 86, self.frame.size.width, self.frame.size.height-86) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[GYHDMsgListCell class] forCellReuseIdentifier:@"GYHDMsgListCell"];
        [self addSubview:tableView];
        _tableView = tableView;
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
        [self setup];
    }
    return self;
}

- (void)setup {
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 86)];
    headerView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 56, 56)];
    iconImageView.layer.cornerRadius = 8;
    iconImageView.layer.masksToBounds = YES;
    iconImageView.backgroundColor = [UIColor redColor];
    [headerView addSubview:iconImageView];
    self.iconImageView = iconImageView;
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) + 10, 32, 100, 22)];
    titleLabel.font = [UIFont systemFontOfSize:22.0];
    [headerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [self addSubview: headerView];
    self.headerView = headerView;
}
#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GYHDMsgListCell *cell = [tableView dequeueReusableCellWithIdentifier: @"GYHDMsgListCell"];
    GYOrderMessageListModel*model=self.dataSource[indexPath.row];
    cell.model=model;
    cell.delegate=self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        GYOrderMessageListModel*model=self.dataSource[indexPath.row];
    
    if (!model.isShowAllContent) {
        
        return 121;

    }
   self.rowHight= [Utils heightForString:model.messageListContent font:[UIFont systemFontOfSize:16.0] width:self.frame.size.width-40];
    return 121+self.rowHight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

        GYOrderMessageListModel*model=self.dataSource[indexPath.row];
    
    [[GYHDMessageCenter sharedInstance]ClearUnreadPushMessageWithCard:globalData.loginModel.custId messageId:model.ID];
    model.readStatus=@"0";
    [self.tableView reloadData];
    if (model.isShowPage) {
        GYHDMsgShowPageController*vc=[[GYHDMsgShowPageController alloc]init];
        vc.pageUrl=model.pageUrl;
        [self.showPage.navigationController pushViewController:vc animated:YES];
    }else{
        
        GYMsgListContentController*vc=[[GYMsgListContentController alloc]init];
        
        vc.model=model;
        
        [self.showPage.navigationController pushViewController:vc animated:YES];
    }
}

-(void)reFreshCellRowHight:(CGFloat)rowHight{
    
    [self.tableView reloadData];
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (void)setImage:(NSString *)image {
    self.iconImageView.image = [UIImage imageNamed:image];
}

- (void)setColor:(UIColor *)color {
    self.titleLabel.textColor = color;
//    [self.headerView addBottomBorderWithBorderWidth:1.0 andBorderColor:color];
//    [self.headerView setBottomBorderInset:YES];
    self.headerView.customBorderColor = color;
    self.headerView.customBorderType = UIViewCustomBorderTypeBottom;
    
}

@end
