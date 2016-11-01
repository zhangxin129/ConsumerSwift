//
//  GYHDContactsTableViewCell.h
//  HSConsumer
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDContactsListModel.h"
typedef void (^headClickBlock) (GYHDContactsListModel*model);
@interface GYHDContactsTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImgView;
@property(nonatomic,strong)UILabel    *nameLabel;
@property(nonatomic,strong)UILabel    *contentLabel;
@property(nonatomic,strong)GYHDContactsListModel*model;
@property(nonatomic,copy)headClickBlock    block;
-(void)refreshUIWith:(GYHDContactsListModel*)model;
@end
