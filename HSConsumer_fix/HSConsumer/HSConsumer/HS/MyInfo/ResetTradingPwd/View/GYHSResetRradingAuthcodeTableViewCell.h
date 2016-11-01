//
//  GYHSResetRradingAutoCodeTableViewCell.h
//  HSConsumer
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSResetRradingAuthcodeTableViewCellIdentifier @"GYHSResetRradingAuthcodeTableViewCell"

#import <UIKit/UIKit.h>



@interface GYHSResetRradingAuthcodeTableViewCell : UITableViewCell

@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UITextField *value;
@property (nonatomic,copy) NSString *authcodeStr;



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

-(void)refreshDataWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;

@end
