//
//  GYConfirmOrdersCell.h
//  HSConsumer
//
//  Created by appleliss on 15/10/14.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGYConfirmOrdersCell @"kGYConfirmOrdersCell"
@protocol GYConfirmOrdersCellDelegate <NSObject>
- (void)gYConfirmOrdersCellDelegateSelected:(NSString*)rows;
@end

@interface GYConfirmOrdersCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* titleName;
@property (weak, nonatomic) IBOutlet UIImageView* iamgesssss;
@property (strong, nonatomic) NSString* rows;
@property (nonatomic) BOOL selectType;
@property (weak, nonatomic) id<GYConfirmOrdersCellDelegate> selectedDelegat;
+ (instancetype)cellWithTableView:(UITableView*)tableView andtitleName:(NSString*)titleName andImageName:(NSString*)imageName;
@end
