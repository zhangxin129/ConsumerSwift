//
//  GYHDPopMessageTopView.m
//  HSConsumer
//
//  Created by shiang on 16/1/29.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPopMessageTopView.h"
#import "GYHDMessageCenter.h"

@interface GYHDPopMessageTopView () <UITableViewDataSource, UITableViewDelegate>
/**
 * 选择控制器
 */
@property (nonatomic, weak) UITableView* choseView;
/**
 * 消息数组
 */
@property (nonatomic, strong) NSArray* messageArray;
@end

@implementation GYHDPopMessageTopView

- (instancetype)initWithMessageArray:(NSArray*)array;
{
    self = [super init];
    if (!self)
        return self;
    _messageArray = array;
    UITableView* choseView = [[UITableView alloc] init];
    //    choseView.separatorColor = [UIColor redColor];
    //    choseView.separatorInset = UIEdgeInsetsMake(0,-100, 0, 0);
    //    choseView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    choseView.scrollEnabled = NO;
    choseView.delegate = self;
    choseView.dataSource = self;
    [self addSubview:choseView];
    WS(weakSelf);
    [choseView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.top.bottom.left.right.equalTo(weakSelf);
    }];
    _choseView = choseView;

    return self;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellID = @"CellID";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    if (!indexPath.row) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithRed:250.0f / 255.0f green:60.0f / 255.0f blue:40.0f / 255.0f alpha:1.0f];
        cell.userInteractionEnabled = NO;
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = self.messageArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 46.0f;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSString* messageString = self.messageArray[indexPath.row];
    if (self.block) {
        self.block(messageString);
    }
}

@end
