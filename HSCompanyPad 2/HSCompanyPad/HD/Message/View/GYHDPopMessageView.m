//
//  GYHDPopMessageView.m
//  company
//
//  Created by Yejg on 16/6/16.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPopMessageView.h"
#import "GYHDMessageCenter.h"
static NSString * const GYTableViewCellID = @"GYHDPopMessageTopView";

@interface GYHDPopMessageView ()<UITableViewDataSource,UITableViewDelegate>
/**
 * 选择控制器
 */
@property(nonatomic,weak)UITableView *choseView;
/**
 * 消息数组
 */
@property(nonatomic,strong)NSArray *messageArray;

@end

@implementation GYHDPopMessageView

- (instancetype)initWithMessageArray:(NSArray *)array {
    self = [super init];
    if (!self)
        return  self;
    _messageArray = array;
    UITableView *choseView = [[UITableView alloc] init];
    choseView.scrollEnabled = NO;
    choseView.delegate = self;
    choseView.dataSource = self;
    [self addSubview:choseView];
    @weakify(self);
    [choseView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.left.right.equalTo(self);
    }];
    _choseView = choseView;
    
    return  self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  self.messageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYTableViewCellID];
    }
    if (!indexPath.row) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font=[UIFont systemFontOfSize:24];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:143/255.0 blue:215/255.0 alpha:1.0];
        cell.userInteractionEnabled = NO;
    } else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment=NSTextAlignmentCenter;
        cell.textLabel.font=[UIFont systemFontOfSize:24];
    }
    cell.textLabel.text = self.messageArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  70.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *messageString = self.messageArray[indexPath.row];
    if (self.block) {
        self.block(messageString);
    }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    
    if([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableView setSeparatorInset:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
    if([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [tableView setLayoutMargins:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, -10,0,0)];
        
    }
    
}
@end
