//
//  GYPOSVolumeCell.h
//  company
//
//  Created by apple on 16/6/24.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSPointVolumeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel* textNumber;
@property (weak, nonatomic) IBOutlet UIView* lineView;
@property (weak, nonatomic) IBOutlet UILabel *faceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@end
