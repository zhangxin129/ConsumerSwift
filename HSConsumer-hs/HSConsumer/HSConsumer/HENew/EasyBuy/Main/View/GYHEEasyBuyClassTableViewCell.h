//
//  GYHEEasyBuyClassTableViewCell.h
//  HSConsumer
//
//  Created by chenwy on 16/9/30.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEEasyBuyClassTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *separateLineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *separateLineHeight;

- (void)updateStateWithIndex:(BOOL)isSelected;

@end
