//
//  GYCountrySelectionViewController.m
//  HSConsumer
//
//  Created by apple on 15-3-10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCountrySelectionViewController.h"
#import "GYAddressData.h"


@interface GYCountrySelectionViewController ()

@end

@implementation GYCountrySelectionViewController

{
    __weak IBOutlet UITableView* tvCountrySelection;
 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_RealName_Select_Nationality");
    self.marrSourceData = [[GYAddressData shareInstance] selectAllCountrys];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.marrSourceData];
    for ( GYAddressCountryModel * model  in array) {
        if ([model.countryNo isEqualToString:@"156"]) {
            NSInteger index = [self.marrSourceData indexOfObject:model];
            [self.marrSourceData exchangeObjectAtIndex:0 withObjectAtIndex:index];
            
        }
    }
}

#pragma mark DataSourceDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.marrSourceData.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 44.0f;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    GYAddressCountryModel* model  = nil;
    if (self.marrSourceData.count > indexPath.row) {
        model  = self.marrSourceData[indexPath.row];
    }
 
    cell.textLabel.text =model.countryName;
    cell.accessoryView = nil;

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    GYAddressCountryModel* MOD = nil;
    if (self.marrSourceData.count > indexPath.row) {
        MOD = self.marrSourceData[indexPath.row];
    }

    if (_Delegate && [_Delegate respondsToSelector:@selector(selectNationalityModel:)]) {
        [_Delegate selectNationalityModel:MOD];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
