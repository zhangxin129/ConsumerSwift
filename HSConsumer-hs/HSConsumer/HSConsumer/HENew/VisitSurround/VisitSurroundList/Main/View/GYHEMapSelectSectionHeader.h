//
//  GYHEMapSelectSectionHeader.h
//  HSConsumer
//
//  Created by zhengcx on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEMapSelectSectionHeader : UIView

@property (strong, nonatomic) IBOutlet UIImageView *iconImage;  //小图标
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;     //标题
@property (nonatomic, assign)NSInteger typeNumber;  //1 我的附近 2  附近地址

@end
