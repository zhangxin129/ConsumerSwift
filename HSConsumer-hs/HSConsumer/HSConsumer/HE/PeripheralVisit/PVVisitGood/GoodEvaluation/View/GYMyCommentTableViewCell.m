//
//  GYMyCommentTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-2.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMyCommentTableViewCell.h"

@implementation GYMyCommentTableViewCell {

    __weak IBOutlet UILabel* lbCellTitle; //titile 名称

    __weak IBOutlet UIImageView* imgFrontPicture; //title 前面的图片

    __weak IBOutlet UILabel* lbComments; //评论内容lb

    __weak IBOutlet UILabel* lbGoodType; //商品类型，土豪金

    __weak IBOutlet UILabel* lbGoodName; //商品名称 iPhone 5s
    __weak IBOutlet UILabel* toptime; ///顶部时间
}

- (void)awakeFromNib
{
    // Initialization code
    lbCellTitle.textColor = kCellItemTitleColor;
    lbComments.textColor = kCellItemTitleColor;
    lbGoodName.textColor = kCellItemTextColor;
    lbGoodType.textColor = kCellItemTextColor;
    toptime.textColor = kCellItemTextColor;
    imgFrontPicture.layer.cornerRadius = imgFrontPicture.frame.size.width / 2;
    imgFrontPicture.clipsToBounds = YES;

    lbCellTitle.adjustsFontSizeToFitWidth = YES;
    toptime.adjustsFontSizeToFitWidth = YES;
    lbGoodType.adjustsFontSizeToFitWidth = YES;
    lbGoodName.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUIWithModel:(GYGoodComments*)model
{
    lbCellTitle.text = model.strUserName;
    DDLogDebug(@"%@-----username", model.strUserName);
    lbComments.text = model.strComments;
    // add by songjk调整内容高度
    CGRect frame = CGRectMake(13, 48, kScreenWidth - 13 * 2, 44); // 根据xib得出原先frame 防止重用影响
    lbComments.frame = frame;
    if (frame.size.height < model.contentHeight) {
        frame.size.height = model.contentHeight;
        lbComments.frame = frame;
    }
    //    lbGoodName.text=model.strGoodName;
    lbGoodName.text = model.strTime;
    lbGoodType.text = model.strGoodType;
    NSRange range = NSMakeRange(0, 10);
    NSString* prefix = [model.strTime substringWithRange:range];

    toptime.text = [model.strTime isKindOfClass:[NSNull class]] ? @"" : [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_SurroundVisit_Time"), prefix];
    
    [imgFrontPicture setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.strUserIconURL]] placeholder:[UIImage imageNamed:@"sp_appraise.png"]];
}

@end
