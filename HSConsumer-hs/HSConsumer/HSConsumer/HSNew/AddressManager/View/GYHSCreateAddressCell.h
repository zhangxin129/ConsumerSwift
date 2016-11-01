//
//  GYHSCreateAddressCell.h
//  HSConsumer
//
//  Created by lizp on 2016/10/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#define kGYHSCreateAddressCellTag 500
#define kGYHSCreateAddressCellIdentifier @"GYHSCreateAddressCell"

#import <UIKit/UIKit.h>

@interface GYHSCreateAddressCell : UITableViewCell

@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UITextView *addressTextView;


-(void)refreshPlaceholder:(NSString *)placeholder detail:(NSString *)detail textField:(NSString *)textField;


@end
