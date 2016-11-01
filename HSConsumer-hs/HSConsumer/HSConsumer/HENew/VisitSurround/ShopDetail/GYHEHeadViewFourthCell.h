//
//  GYHEHeadViewFourthCell.h
//  HSConsumer
//
//  Created by 吴文超 on 16/10/9.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYHEHeadViewFourthCell : UITableViewCell

//显示 联系人 三个字
@property (weak, nonatomic) IBOutlet UILabel *contactPersonLabel;


//姓名标签 传递名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//电话标签
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;

//地址标签 注意在赋值文本的时候 前面加地址:
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@property (weak, nonatomic) IBOutlet UIView *lineView;








@end
