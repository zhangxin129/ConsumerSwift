//
//  GYHSAddAddressCell.h
//  HSConsumer
//
//  Created by lizp on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSAddAddressCellIdentifier @"GYHSAddAddressCell"

#import <UIKit/UIKit.h>

@class GYAddressModel;
@interface GYHSAddAddressCell : UITableViewCell

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITextField *detailTextField;
@property (nonatomic,strong) UITextView *addressTextView;
@property (nonatomic,strong) UIImageView *arrowImageView;


//@property (nonatomic, strong) GYAddressModel *model;
-(void)refreshTitle:(NSString *)title detail:(NSString *)detail address:(NSString *)address;

@end
