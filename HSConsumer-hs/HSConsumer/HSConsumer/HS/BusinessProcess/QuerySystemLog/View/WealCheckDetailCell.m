//
//  WealCheckDetailCell.m
//  HSConsumer
//
//  Created by 00 on 15-3-16.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "WealCheckDetailCell.h"
//#import "GYImgVC.h"
#import "GYPhotoGroupView.h"
#import "GYHSScoreWealImageShowViewController.h"

@interface WealCheckDetailCell ()
@property (nonatomic, strong) NSMutableArray* photos;
@end

@implementation WealCheckDetailCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)btnClick:(id)sender
{
    
    GYHSScoreWealImageShowViewController *showVC  = [[GYHSScoreWealImageShowViewController alloc] init];
    showVC.arrImg = self.arrImg;
    showVC.view.frame = self.vc.view.frame;
    showVC.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    [self.vc addChildViewController:showVC];
    [self.vc.view addSubview:showVC.view];
    

}



-(void)lbTitlefont:(UIFont *)lbTitlefont lbContentfont:(UIFont *)lbContentfont
{
    self.lbTitle.font = lbTitlefont;
    self.lbContent.font = lbContentfont;
}
@end
