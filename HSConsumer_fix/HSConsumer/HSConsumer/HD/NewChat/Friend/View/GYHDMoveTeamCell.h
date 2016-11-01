//
//  GYHDMoveTeamCell.h
//  HSConsumer
//
//  Created by shiang on 16/3/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHDMoveTeamModel;
@interface GYHDMoveTeamCell : UITableViewCell
/**选择模型*/
@property (nonatomic, weak) GYHDMoveTeamModel* teamModel;
//@property(nonatomic, weak)NSString *selectTitle;
@end
