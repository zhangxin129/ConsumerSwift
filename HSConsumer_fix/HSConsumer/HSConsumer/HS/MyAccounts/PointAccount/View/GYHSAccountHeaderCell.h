//
//  GYHSAccountHeaderCell.h
//  GYHSConsumer_MyHS
//
//  Created by ios007 on 16/3/21.
//  Copyright © 2016 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYHSHeaderModel.h"
@interface GYHSAccountHeaderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* linelabel;
@property (weak, nonatomic) IBOutlet UIImageView* titleImage;
@property (weak, nonatomic) IBOutlet UILabel* topLabel;
@property (weak, nonatomic) IBOutlet UILabel* centerLabel;
@property (weak, nonatomic) IBOutlet UILabel* bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel* toprightLabel;
@property (weak, nonatomic) IBOutlet UILabel* centerRightLabel;
@property (weak, nonatomic) IBOutlet UILabel* bottomRightLabel;
@property (nonatomic, copy) GYHSHeaderModel* headerModel;
@end
