//
//  GYConfirmCell.h
//  HSConsumer
//
//  Created by appleliss on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYcellModel.h"
@protocol GYConfirmCellDelegate <NSObject>
- (void)gYConfirmCellDelegateTextField:(NSString*)string andIndexPath:(NSIndexPath*)indexPath;
//-(void)gyGYMealTimeCellDelegate:(NSString *)sting andIndexPath:(NSIndexPath *)indexPath;
@end

@interface GYConfirmCell : UITableViewCell <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UITextField* cellTextFile;
@property (weak, nonatomic) id<GYConfirmCellDelegate> textFielDelegat;
@property (strong, nonatomic) NSIndexPath* indexPath;
@property (strong, nonatomic) NSString* string;
@property (strong, nonatomic) GYcellModel* model;
+ (instancetype)cellWithTableView:(UITableView*)tableView andindes:(NSIndexPath*)indexPath andtitleName:(NSString*)titleName;
@end
