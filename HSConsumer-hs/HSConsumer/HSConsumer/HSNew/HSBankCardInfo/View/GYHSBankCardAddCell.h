//
//  GYHSBankCardAddCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//


#define kGYHSBankCardAddCellIdentifier @"GYHSBankCardAddCell"

#import <UIKit/UIKit.h>

@interface GYHSBankCardAddCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *detailTextField;
@property (nonatomic,strong) UIImageView *selectImageView;
@property (nonatomic,strong) UISwitch *defaultSwitch;
@property (nonatomic,strong) UIButton *areaBtn;  //增加背景点击范围


-(void)refreshTitle:(NSString *)title placeholder:(NSString *)placeholder detail:(NSString *)detail;

@end
