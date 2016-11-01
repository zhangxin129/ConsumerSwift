//
//  GYHSTableViewWarmCell.h
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSTableViewWarmCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* redImage;
@property (weak, nonatomic) IBOutlet UILabel* label;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* labelspacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeigth;

@end
