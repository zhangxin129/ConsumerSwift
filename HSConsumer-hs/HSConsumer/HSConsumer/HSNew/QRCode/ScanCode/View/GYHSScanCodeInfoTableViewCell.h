//
//  GYHSScanCodeInfoTableViewCell.h
//  HSConsumer
//
//  Created by admin on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHSScanCodeInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (nonatomic,assign) BOOL isKeepDecimal;//是否能输入小数且保留两位小数
@end
