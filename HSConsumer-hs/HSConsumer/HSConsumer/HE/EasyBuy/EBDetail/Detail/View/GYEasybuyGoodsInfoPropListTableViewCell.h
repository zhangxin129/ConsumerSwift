//
//  GYEasybuyGoodsInfoPropListTableViewCell.h
//  HSConsumer
//
//  Created by zhangqy on 15/11/17.
//  Copyright © 2015年 GYKJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuyGoodsInfoModel.h"
@interface GYEasybuyGoodsInfoPropListTableViewCell : UITableViewCell

@property (weak, nonatomic) GYEasybuyGoodsinfoPropListModel* model;
//@property (assign, nonatomic) CGFloat height;
@property (nonatomic, copy) NSString* selectedStr;
//属性id和按钮下标
@property (nonatomic, copy) void (^block)(NSString*,NSInteger);
@property (strong, nonatomic) IBOutlet UIView* btnView;
@end
