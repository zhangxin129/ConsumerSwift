//
//  GYHEVisitListCell.h
//  HSConsumer
//
//  Created by kuser on 16/9/22.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GYHEVisitListModel;

@interface GYHEVisitListCell : UITableViewCell

@property (nonatomic, strong) GYHEVisitListModel *model;
@property (strong, nonatomic) IBOutlet UIImageView *iconImage;//示例图片
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;   //标题
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;//子标题
@property (strong, nonatomic) IBOutlet UILabel *detailAddressLabel;//详细地址
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;    //地址
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;   //距离

@end
