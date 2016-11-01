//
//  GYHSImageSixlabelCell.h
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSImageSixlabelCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView* img;
@property (weak, nonatomic) IBOutlet UILabel* toptitleLabel;
@property (weak, nonatomic) IBOutlet UILabel* bonusNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* circulationLabel;
@property (weak, nonatomic) IBOutlet UILabel* circulationNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* directionalNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel* directionalLabel;

@end
