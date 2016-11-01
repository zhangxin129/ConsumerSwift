//
//  UITableView+GYExtendSeparator.m
//  HSConsumer
//
//  Created by apple on 15-4-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "UITableView+GYExtendSeparator.h"

@implementation UITableView (GYExtendSeparator)

- (void)tableviewExtendSeparator
{

    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {

        [self setSeparatorInset:UIEdgeInsetsZero];
    }

    //            if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
    //
    //                [self setLayoutMargins:UIEdgeInsetsZero];
    //
    //            }
}

- (void)tableView:(UITableView*)tableView willDisplayCell:(UITableViewCell*)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {

        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    //    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
    //
    //        [cell setLayoutMargins:UIEdgeInsetsZero];
    //
    //    }
}

@end
