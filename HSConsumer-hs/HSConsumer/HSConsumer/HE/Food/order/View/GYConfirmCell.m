//
//  GYConfirmCell.m
//  HSConsumer
//
//  Created by appleliss on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYConfirmCell.h"

@implementation GYConfirmCell

- (void)awakeFromNib
{

    self.cellTextFile.delegate = self;
    self.title.text = kLocalized(@"GYHE_Food_NumberOfEatingPeople");
    self.cellTextFile.placeholder = kLocalized(@"GYHE_Food_InputPeopleNumber");
    self.cellTextFile.placeholder = kLocalized(@"GYHE_Food_PleaseInputPhoneNumber");
}

+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath andtitleName:(NSString*)titleName
{
    GYConfirmCell* cell = [tableView dequeueReusableCellWithIdentifier:@"kGYConfirmCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([GYConfirmCell class]) owner:nil options:nil] lastObject];
    }
    cell.title.text = titleName;
    if (indexPath.row == 0) {
        cell.cellTextFile.placeholder = kLocalized(@"GYHE_Food_InputPeopleNumber");
    }
    else {
        //        cell.cellTextFile.placeholder =kLocalized(@"fd_order_All_importConsume") ;
        cell.cellTextFile.placeholder = kLocalized(@"GYHE_Food_PleaseInputPhoneNumber");
    }
    cell.indexPath = indexPath;
    return cell;
}

- (void)setModel:(GYcellModel*)model
{
    _model = [[GYcellModel alloc] init];
    _model = model;
    //self.cellTextFile.text=_model.valueString;
    //self.cellTextFile.placeholder = _model.valueString;
    self.title.text = _model.titleString;
}

- (void)textFieldDidBeginEditing:(UITextField*)textField
{
    [textField becomeFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField*)textField
{
    if ([_textFielDelegat respondsToSelector:@selector(gYConfirmCellDelegateTextField:andIndexPath:)]) {
        [_textFielDelegat gYConfirmCellDelegateTextField:self.cellTextFile.text andIndexPath:self.indexPath];
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

@end
