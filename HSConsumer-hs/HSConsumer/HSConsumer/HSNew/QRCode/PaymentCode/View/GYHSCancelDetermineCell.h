//
//  GYHSCancelDetermineCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHSCancelDetermineDelegate <NSObject>
@optional

- (void)cancelLimitation;
- (void)determineLimitation;

@end
@interface GYHSCancelDetermineCell : UITableViewCell
@property (nonatomic,weak)id<GYHSCancelDetermineDelegate> cancelDetermineDelegate;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *determineBtn;
@end
