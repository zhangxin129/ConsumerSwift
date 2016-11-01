//
//  GYHSAccountHSBHeaderCell.h
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/3/26.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "GYHSHeaderModel.h"
@interface GYHSAccountHSBHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomRightLetConstraint;
@property (weak, nonatomic) IBOutlet UIImageView* headerImage;
@property (weak, nonatomic) IBOutlet UILabel* topLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel* topRightLabel;
@property (weak, nonatomic) IBOutlet UILabel* bottomLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel* bottomRightlabel;
@property (weak, nonatomic) IBOutlet UILabel* line;

@end
