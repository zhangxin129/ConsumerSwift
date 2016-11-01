//
//  CellViewDetailCell.m
//  HSConsumer
//
//  Created by apple on 14-11-19.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "CellViewDetailCell.h"
#import "CellDetailRow.h"

@implementation CellViewDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        CGRect btnFrame = CGRectMake(170, 175, 90, 30);
        self.labelShowDetails = [[UILabel alloc] initWithFrame:btnFrame];
        [self.labelShowDetails setTextColor:kCorlorFromRGBA(200, 200, 200, 1)];
        [self.labelShowDetails setTextAlignment:NSTextAlignmentCenter];
        [self.labelShowDetails setBackgroundColor:kClearColor];

        CGRect tbvFrame = CGRectMake(0, 0, kScreenWidth, 225);
        self.tableView = [[UITableView alloc] initWithFrame:tbvFrame style:UITableViewStylePlain];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;

        [self addSubview:self.tableView];
        [self addSubview:self.labelShowDetails];
        self.arrDataSource = [NSMutableArray array];
        [self.tableView registerNib:[UINib nibWithNibName:@"CellDetailRow" bundle:kDefaultBundle] forCellReuseIdentifier:kCellDetailRowIdentifier];
    }

    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Table view data source and delegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrDataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    NSInteger row = indexPath.row;
    CellDetailRow* cell = [tableView dequeueReusableCellWithIdentifier:kCellDetailRowIdentifier];

    if (!cell) {
        cell = [[CellDetailRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellDetailRowIdentifier];
    }

    cell.accessoryType = UITableViewCellAccessoryNone;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (indexPath.row == 0 && [self.type isEqualToString:@"0"]) { //type 判断是系统日志的cell还是详单列表的cell
        cell.lbTitle.font = [UIFont systemFontOfSize:18];
        [cell.lbTitle setTextColor:kCellItemTitleColor];
    }
    else {
        [cell.lbTitle setFont:[UIFont systemFontOfSize:15.0f]];
        [cell.lbTitle setTextColor:kCellItemTextColor];
    }
    cell.lbTitle.text = self.arrDataSource[row][@"title"];
    
    cell.lbValue.text = self.arrDataSource[row][@"value"];
//    CGSize size = [GYUtils sizeForString:self.arrDataSource[row][@"value"] font:[UIFont systemFontOfSize:15.0] width:kScreenWidth - 70];
//    self.labelheight = size.height;
    [cell setBackgroundColor:[UIColor clearColor]];

    [cell.lbValue setFont:[UIFont systemFontOfSize:15.0f]];

    [cell.lbValue setTextColor:kCellItemTextColor];

    if ([cell.lbTitle.text isEqualToString:kLocalized(@"GYHS_BP_Spending")]) {
        [cell.lbValue setTextColor:kNumGreenColor];
        [cell.lbValue setFont:[UIFont systemFontOfSize:16.0f]];
    }
    else if ([cell.lbTitle.text isEqualToString:kLocalized(@"GYHS_BP_Income")]) {
        [cell.lbValue setTextColor:kNumRednColor];
        [cell.lbValue setFont:[UIFont systemFontOfSize:16.0f]];
    }

    //设置title高亮的颜色
    if (self.rowTitleHighlightedProperty) {

        [self.rowTitleHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            if ([(NSArray *) obj count] > 1) {
                if ([cell.lbTitle.text isEqualToString:obj[0]]) {//Title的颜色
                    [cell.lbTitle setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];
                }
            }
        }];
    }
    else
        [cell.lbTitle setTextColor:kCellItemTitleColor];

    //设置value高亮的颜色
    if (self.rowValueHighlightedProperty) {
        [self.rowValueHighlightedProperty enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
            if ([(NSArray *) obj count] > 1) {
                if ([cell.lbTitle.text isEqualToString:obj[0]]) {//value的颜色
                    [cell.lbValue setFont:[UIFont systemFontOfSize:16.0f]];
                    [cell.lbValue setTextColor:kCorlorFromHexcode(strtoul([obj[1] UTF8String], 0, 0))];

                    if ([(NSArray *) obj count] > 2 && [obj[2] boolValue]) {//为真是格式化货币值

                        NSString *value = [GYUtils formatCurrencyStyle:[cell.lbValue.text doubleValue]];
                        if ([cell.lbValue.text hasPrefix:@"+"]) {

                            value = [NSString stringWithFormat:@"+%@", value];
                        }

                        cell.lbValue.text = value;
                    }
                }
            }
        }];
    }
    else {
        [cell.lbValue setTextColor:kCellItemTextColor];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.type isEqualToString:@"0"]) { //type 判断是系统日志的cell还是详单列表的cell
        if ([self.arrDataSource[indexPath.row][@"realHeight"] integerValue]>0) {
            return [self.arrDataSource[indexPath.row][@"realHeight"] integerValue];
        }
        return 26;
    }
    else {
        CGFloat minHeight = 16;
        return self.cellSubCellRowHeight > minHeight ? self.cellSubCellRowHeight : minHeight;
    }
}

@end
