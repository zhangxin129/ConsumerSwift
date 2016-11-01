//
//  GYualificationTableViewCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYualificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbcontent;//保障内容
@property (weak, nonatomic) IBOutlet UILabel *lbTime;//保障时间
@property (weak, nonatomic) IBOutlet UILabel *SecurityQualificationlb;//是否有保障资格

-(void)lbcontenttext:(NSString*)lbcontenttext lbcontentColor:(UIColor*)lbcontentColor
       lbTimetext:(NSString*)lbTimetext lbTimeColor:(UIColor*)lbTimeColor
       SecurityQualificationlbtext:(NSString*)SecurityQualificationlbtext SecurityQualificationlbColor:(UIColor*)SecurityQualificationlbColor;

@end
