//
//  GYHDContactsMarkCell.h
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDContactsMarkListModel.h"
@interface GYHDContactsMarkCell : UITableViewCell
-(void)refreshUIWith:(GYHDContactsMarkListModel*)model;
@end
