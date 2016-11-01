//
//  GYHSScoreWealQueryViewCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSScoreWealQueryViewCellIdentifier @"GYHSScoreWealQueryViewCell"

#import <UIKit/UIKit.h>

@interface GYHSScoreWealQueryViewCell : UITableViewCell


-(void)refreshOrder:(NSString *)order time:(NSString *)time type:(NSString *)type result:(NSString *)result account:(NSString *)account;

@end
