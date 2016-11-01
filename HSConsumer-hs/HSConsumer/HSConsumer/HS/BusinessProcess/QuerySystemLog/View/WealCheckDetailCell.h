//
//  WealCheckDetailCell.h
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WealCheckDetailCell : UITableViewCell

@property (strong, nonatomic) UINavigationController* nc;
@property (weak,nonatomic) UIViewController *vc;

@property (weak, nonatomic) IBOutlet UILabel* lbTitle;

@property (weak, nonatomic) IBOutlet UILabel* lbContent;

@property (copy, nonatomic) NSString* imgUrl;
@property (copy, nonatomic) NSArray* arrImg;

@property (weak, nonatomic) IBOutlet UIButton* btn;

- (IBAction)btnClick:(id)sender;
-(void)lbTitlefont:(UIFont*)lbTitlefont lbContentfont:(UIFont*)lbContentfont;//控制两个lb的字体大小


@end
