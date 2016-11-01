//
//  GYEasyBuySecondeTableViewCell.m
//  HSConsumer
//
//  Created by apple on 14-12-1.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasyBuySecondeTableViewCell.h"

@implementation GYEasyBuySecondeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    [self.btnSelected setBackgroundImage:[UIImage imageNamed:@"gyhe_check_mark_red.png"] forState:UIControlStateNormal];
    self.btnSelected.hidden = YES;
}

- (void)refreshUIWith:(NSString*)title
{
    self.lbTitle.text = title;
}

- (void)selectOneRow
{
    self.lbTitle.textColor = kNavigationBarColor;
    self.btnSelected.hidden = NO;
    //代理给tableview，实现单选 第二个SECTION中 .
    if (_delegate && [_delegate respondsToSelector:@selector(sendDataWithTitle:WithSelectedBtn:)]) {
        [_delegate sendDataWithTitle:self.lbTitle WithSelectedBtn:self.btnSelected];
    }
}

//还原cell的默认状态。
- (void)nonSelectOneRow
{
    self.lbTitle.textColor = kCellItemTitleColor;
    self.btnSelected.hidden = YES;

}

@end

