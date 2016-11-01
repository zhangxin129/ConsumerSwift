//
//  GYGetPhotoView.m
//  HSConsumer
//
//  Created by kuser on 16/7/28.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGetPhotoView.h"

@implementation GYGetPhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.bgColor.backgroundColor = kCorlorFromHexcode(0xDCDCDC);
    self.takePhotoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.getBlumBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];

   [self.takePhotoBtn setTitleColor:kCorlorFromHexcode(0X333333) forState:UIControlStateNormal];
   [self.takePhotoBtn setTitleColor:kCorlorFromHexcode(0X333333) forState:UIControlStateSelected];
   [self.getBlumBtn setTitleColor:kCorlorFromHexcode(0X333333) forState:UIControlStateNormal];
   [self.getBlumBtn setTitleColor:kCorlorFromHexcode(0X333333) forState:UIControlStateSelected];
    [self.cancelBtn setTitleColor:kCorlorFromHexcode(0X333333) forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:kCorlorFromHexcode(0X333333) forState:UIControlStateSelected];
    
    [self.takePhotoBtn addTarget:self action:@selector(takePhotoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.getBlumBtn addTarget:self action:@selector(getBlumBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
}



-(void)takePhotoBtnClick
{
    if ([self.delegate respondsToSelector:@selector(takePhotoBtnClickDelegate)]) {
        [self.delegate takePhotoBtnClickDelegate];
    }
}

-(void)getBlumBtnClick
{
    if ([self.delegate respondsToSelector:@selector(getBlumBtnClickDelegate)]) {
        [self.delegate getBlumBtnClickDelegate];
    }
}

-(void)cancelBtnClick
{
    if ([self.delegate respondsToSelector:@selector(cancelBtnClickDelegate)]) {
        [self.delegate cancelBtnClickDelegate];
    }
}

@end
