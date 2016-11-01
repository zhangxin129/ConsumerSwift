//
//  GYHDMessageCell.h
//  HSCompanyPad
//
//  Created by shiang on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDAllMsgListModel.h"

@interface GYHDMessageGroupCell : UITableViewCell
-(void)refreshUIWithModle:(GYHDAllMsgListModel*)model;
@end
