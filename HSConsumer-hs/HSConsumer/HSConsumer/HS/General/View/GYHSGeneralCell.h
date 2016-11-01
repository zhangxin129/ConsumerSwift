//
//  GYHSGeneralCell.h
//  GYHSConsumer_MyHS
//
//  Created by liss on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSGeneralCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* title;
@property (weak, nonatomic) IBOutlet UIImageView* languangeImg;
@property (weak, nonatomic) IBOutlet UILabel* detileLab;
@property (weak, nonatomic) IBOutlet UIImageView* rightImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right;




@end
