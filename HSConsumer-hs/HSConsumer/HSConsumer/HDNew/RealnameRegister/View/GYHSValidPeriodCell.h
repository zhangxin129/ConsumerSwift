//
//  GYHSValidPeriodCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/8/17.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSValidPeriodDelegate <NSObject>
@optional

- (void)chooseSelectButtonValidPeriod:(UIButton*)btn;//点击长期
- (void)tfDidBegin:(NSIndexPath*)indexPath;//弹出时间选择器
@end
@interface GYHSValidPeriodCell : UITableViewCell

@property (nonatomic,weak)id<GYHSValidPeriodDelegate> periodDelegate;
-(void)LbLeftlabelText:(NSString*)LbLeftlabel
      placeholderlbText:(NSString*)placeholderlb
         tftextFieldText:(NSString*)tftextField
         textFieldClick:(BOOL)textViewClick
         tag:(NSIndexPath*)indexPath;

@end
