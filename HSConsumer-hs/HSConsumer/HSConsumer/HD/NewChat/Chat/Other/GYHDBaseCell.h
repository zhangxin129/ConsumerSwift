//
//  GYHDBaseCell.h
//  HSConsumer
//
//  Created by shiang on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHDBaseCell : UITableViewCell
/**左边ImageView*/
@property (nonatomic, weak) UIImageView* leftImageView;
/**左上Label*/
@property (nonatomic, weak) UILabel* leftTopLabel;
/**右上Label*/
@property (nonatomic, weak) UILabel* leftBottomLabel;
/**右上Label*/
@property (nonatomic, weak) UILabel* rightTopLabel;
@end
