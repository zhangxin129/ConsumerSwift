//
//  GYPasswordTextFieldCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYPasswordTextFieldCellIdentifier @"GYPasswordTextFieldCell"

#import <UIKit/UIKit.h>

@interface GYPasswordTextFieldCell : UITableViewCell

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UITextField* detailTextField;
@property (nonatomic, strong) UIButton* codeButton;
@property (nonatomic, strong) UIView* lineView;

- (void)refleshTitle:(NSString*)title placehold:(NSString*)placehold detail:(NSString*)detail codeTitle:(NSString*)codeTitle;

@end
