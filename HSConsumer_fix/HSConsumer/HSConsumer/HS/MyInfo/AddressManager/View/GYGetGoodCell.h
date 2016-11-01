//
//  GYGetGoodCell.h
//  HSConsumer
//
//  Created by lizp on 16/3/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYAddressModel;
@interface GYGetGoodCell : UITableViewCell

@property (nonatomic, strong) GYAddressModel* model;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, strong) UIView* editingView;
@property (nonatomic, assign) BOOL isFood;

@end
