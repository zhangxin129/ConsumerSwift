//
//  GYHealthUploadImgCollectionViewCell.m
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHealthUploadImgCollectionViewCell.h"

@implementation GYHealthUploadImgCollectionViewCell

- (void)awakeFromNib
{
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.mybtn setTitle:kLocalized(@"GYHS_BP_ColumnPicture") forState:UIControlStateNormal];
    [self.mybtn addTarget:self action:@selector(columnpicture:) forControlEvents:UIControlEventTouchUpInside];

    self.myimageView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picture)];
    [self.myimageView addGestureRecognizer:tap];
}

- (void)setDemoBtnState:(BOOL)state
{
    if (state) {
        self.mybtn.hidden = NO;
        [self.mybtn setBackgroundImage:[UIImage imageNamed:@"hs_btn_imgbg_normal"] forState:UIControlStateNormal];
        [self.mybtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else {
        self.mybtn.hidden = YES;
        [self.mybtn setBackgroundImage:[UIImage imageNamed:@"hs_btn_imgbg_click"] forState:UIControlStateNormal];
        [self.mybtn setTitleColor:kDefaultVCBackgroundColor forState:UIControlStateNormal];
    }
}

- (void)columnpicture:(UIButton*)btn
{
    if (_colum) {
        _colum();
    }
}

- (void)picture {
    _pic();
}

@end
