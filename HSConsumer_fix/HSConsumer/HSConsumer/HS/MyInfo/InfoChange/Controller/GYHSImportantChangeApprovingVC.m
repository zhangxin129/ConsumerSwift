//
//  GYHSImportantChangeApprovingVC.m
//  HSConsumer
//
//  Created by apple on 15-3-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSImportantChangeApprovingVC.h"
#import "YYKit.h"

@implementation GYHSImportantChangeApprovingVC {
    __weak IBOutlet UIImageView* vimgPicture;
    __weak IBOutlet UILabel* lbWarming;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = kLocalized(@"GYHS_MyInfo_Important_Informatiron_Change");

    vimgPicture.frame = CGRectMake(kScreenWidth * 0.4, 155, kScreenWidth * 0.2, kScreenWidth * 0.2);

    lbWarming.frame = CGRectMake(15, CGRectGetMaxY(vimgPicture.frame) + 15, kScreenWidth - 30, 200);
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", kLocalized(@"GYHS_MyInfo_Important_Information_Change_Request_Processing_Unable_Accept_This_Business")]];
    text.color = UIColorFromRGB(0x5A5A5A);
    text.font = [UIFont systemFontOfSize:15];
    text.lineSpacing = 10.0f;
    text.alignment = NSTextAlignmentLeft;
    lbWarming.numberOfLines = 0;
    lbWarming.attributedText = text;

    CGSize size = [self adaptiveWithWidth:lbWarming.frame.size.width label:lbWarming];
    lbWarming.frame = CGRectMake(lbWarming.frame.origin.x, lbWarming.frame.origin.y, size.width, size.height);
}

- (CGSize)adaptiveWithWidth:(CGFloat)width label:(UILabel*)label
{

    label.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    return size;
}

@end
