//
//  GYHSCellTypeImagelabel.h
//  company
//
//  Created by apple on 14-11-12.
//  Copyright (c) 2014年 guiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSCellTypeImagelabel : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView* ivCellImage; //cell的图标
@property (strong, nonatomic) IBOutlet UIImageView* ivCellRightArrow; //cell右箭头

@property (strong, nonatomic) IBOutlet UILabel* lbCellLabel; //cell label
@property (weak, nonatomic) IBOutlet UILabel *bottomlb;

@end
