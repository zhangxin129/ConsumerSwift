//
//  GYHDNewFriendsCell.h
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHDContactsListModel.h"
@interface GYHDNewFriendsCell : UITableViewCell
@property(nonatomic,strong)UIImageView*iconImgView;
@property(nonatomic,strong)UILabel    *nameLabel;
@property(nonatomic,strong)UILabel    *contentLabel;
@property(nonatomic,strong)UIButton   *addStateBtn;
@property(nonatomic,strong)GYHDContactsListModel*model;
-(void)refreshUIWith:(GYHDContactsListModel*)model;
@end
