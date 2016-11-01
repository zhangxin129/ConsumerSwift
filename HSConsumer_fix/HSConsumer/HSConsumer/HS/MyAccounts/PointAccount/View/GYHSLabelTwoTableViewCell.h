//
//  GYHSLabelTwoTableViewCell.h
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSLabelTwoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* detLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* titleLabelWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* spacing;
@property (weak, nonatomic) IBOutlet UILabel *bottomlb;
@property (weak, nonatomic) IBOutlet UILabel *toplb;

@end
