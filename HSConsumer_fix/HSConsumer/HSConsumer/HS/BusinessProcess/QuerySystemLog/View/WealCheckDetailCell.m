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
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.arrImg.count; i++) {
        GYPhotoGroupItem* item = [[GYPhotoGroupItem alloc] init];
        item.largeImageURL = [NSURL URLWithString:kSaftToNSString([NSURL URLWithString:self.arrImg[i]])];
        [items addObject:item];
    }

    GYPhotoGroupView* v = [[GYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:self toContainer:self.nc.view animated:YES completion:nil];
}

-(void)lbTitlefont:(UIFont *)lbTitlefont lbContentfont:(UIFont *)lbContentfont
{
    self.lbTitle.font = lbTitlefont;
    self.lbContent.font = lbContentfont;
}
@end
