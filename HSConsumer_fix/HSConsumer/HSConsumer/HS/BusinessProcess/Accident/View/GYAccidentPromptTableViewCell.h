//
//  GYAccidentPromptTableViewCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/7/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHSbtnAccidentInfoShowDelegate <NSObject>
@optional
- (void)btnAccidentInfoShow;
@end

@interface GYAccidentPromptTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *tipLable;
@property (weak, nonatomic) IBOutlet UIImageView *warnImageView;
@property (weak, nonatomic) IBOutlet UILabel *warmLable;


@property (weak , nonatomic)id<GYHSbtnAccidentInfoShowDelegate> btnAccidentInfoShowDelegate;

@end
