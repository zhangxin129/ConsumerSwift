//
//  GYCertificationTypeViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-9.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYCertificationTypeViewController.h"
#import "GYCertificationType.h"

@interface GYCertificationTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView* tvCertificationTable;

@end

@implementation GYCertificationTypeViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_RealName_Select_Documents");
    _marrDataSoure = [NSMutableArray array];

    GYCertificationType* model = [[GYCertificationType alloc] init];
    model.strCretIdstring = kCertypeIdentify;
    model.selectIndex = [kCertypeIdentify integerValue] - 1;
    model.strCretype = kLocalized(@"GYHS_RealName_Id_Card");
    GYCertificationType* model2 = [[GYCertificationType alloc] init];
    model2.strCretIdstring = kCertypePassport;
    model2.selectIndex = [kCertypePassport integerValue] - 1;
    model2.strCretype = kLocalized(@"GYHS_RealName_Passport");
    GYCertificationType* model3 = [[GYCertificationType alloc] init];
    model3.strCretIdstring = kCertypeBusinessLicence;
    model3.selectIndex = [kCertypeBusinessLicence integerValue] - 1;
    model3.strCretype = kLocalized(@"GYHS_RealName_The_Business_License");
    [_marrDataSoure addObject:model];
    [_marrDataSoure addObject:model2];
    [_marrDataSoure addObject:model3];

    [self.tvCertificationTable reloadData];
    return;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return _marrDataSoure.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    GYCertificationType* mod = nil;
    if (_marrDataSoure.count > indexPath.row) {
        mod = _marrDataSoure[indexPath.row];
    }
    cell.textLabel.text = mod.strCretype;

    if (self.selectIndex == indexPath.row) {

        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else {

        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.tintColor = kNavigationBarColor; //Checkmark沟的颜色和cell的前景色一直

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GYCertificationType* mod = nil;
    if (_marrDataSoure.count > indexPath.row) {
        mod = _marrDataSoure[indexPath.row];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectDataWithMod:)]) {
        [_delegate sendSelectDataWithMod:mod];
        [self.navigationController popViewControllerAnimated:YES];
    }

}

@end
