//
//  GYHSServerTimeCell.h
//  HSConsumer
//
//  Created by zhengcx on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYHSServerDetailAllModel;

@interface GYHSServerTimeCell : UITableViewCell

@property (nonatomic, strong) GYHSServerDetailAllModel* model;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* distanceLeftConstraint; //距离左边点的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint* distanceRightConstraint; //距离右边点的距离

@property (strong, nonatomic) IBOutlet UILabel* topFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel* topSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel* topThirdLabel;
@property (strong, nonatomic) IBOutlet UILabel* topForthLabel;
@property (strong, nonatomic) IBOutlet UILabel* bottomFirstLabel;
@property (strong, nonatomic) IBOutlet UILabel* bottomSecondLabel;
@property (strong, nonatomic) IBOutlet UILabel* bottomThirdLabel;
@property (strong, nonatomic) IBOutlet UILabel* bottomForthLabel;
@property (strong, nonatomic) IBOutlet UIButton* backGroundBlueBtn; //头部背景蓝色
@property (strong, nonatomic) IBOutlet UIView* lineView;

@end
