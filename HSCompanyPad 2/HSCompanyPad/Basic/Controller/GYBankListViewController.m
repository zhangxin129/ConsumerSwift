//
//  GYBankListViewController.m
//
//
//  Created by apple on 14-11-3.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYBankListViewController.h"
#import "GYHSmyhsHttpTool.h"
#import <MJExtension/MJExtension.h>
static NSString* const GYTableViewCellID = @"GYBankListViewController";

#define DEFAULTKEYS [self.nameDictionary.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)]

#define ALPHA_ARRAY [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil]


#import <GYKit/GYPinYinConvertTool.h>
@interface GYBankListViewController () <UITextFieldDelegate>

@end

@implementation GYBankListViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}


#pragma mark tableviewdatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return DEFAULTKEYS.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[section]];
        
        if (arr) {
            return DEFAULTKEYS[section];
        } else {
        
            return nil;
        }
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{

    return 1.0;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[section]];
        if (arr) {
            return arr.count;
        } else {
            return 0;
        }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYTableViewCellID];
    }
      cell.textLabel.textColor = kGray333333;
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[indexPath.section]];
        BankModel* mod = arr[indexPath.row];
        cell.textLabel.text = mod.bankName;
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView
{

    return DEFAULTKEYS;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
        NSArray* arr = [self.nameDictionary objectForKey:DEFAULTKEYS[indexPath.section]];
        
        BankModel* mod = arr[indexPath.row];
        
        if (_delegate && [_delegate respondsToSelector:@selector(getBank:)]) {
        
            [_delegate getBank:mod];
        }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
