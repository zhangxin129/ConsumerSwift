//
//  GYHSHealthPlanViewCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/19.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSHealthPlanViewCellIdentifier @"GYHSHealthPlanViewCell"

#import <UIKit/UIKit.h>

@interface GYHSHealthPlanViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLael;//标题
@property (nonatomic,strong) UITextField *detailTextField;//子标题
@property (nonatomic,strong) UIButton *arrowBtn;//箭头图片

-(void)refreshTitle:(NSString *)title placeholder:(NSString *)placeholder;

@end
