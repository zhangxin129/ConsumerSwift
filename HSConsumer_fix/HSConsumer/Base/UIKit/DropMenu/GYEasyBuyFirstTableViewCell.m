//
//  FirstTableViewCell.m
//  DropDownDemo
//
//  Created by apple on 14-11-27.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "GYEasyBuyFirstTableViewCell.h"

@implementation GYEasyBuyFirstTableViewCell {

    __weak IBOutlet UILabel* lbTitle;
}

- (void)awakeFromNib
{
    //  self.imgFrontPicture.image=[UIImage imageNamed:@"3.png"];
    self.imgFrontPicture.backgroundColor = kNavigationBarColor;
    self.imgFrontPicture.hidden = YES;
    self.backgroundColor = kDefaultVCBackgroundColor;
}

- (void)setSelectPicture:(BOOL)selected
{
    if (selected) {
        self.imgFrontPicture.hidden = NO;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    else {
        self.imgFrontPicture.hidden = YES;
    }
    //代理将图片传到tableview中，用于实现单选图片
    if (_delegate && [_delegate respondsToSelector:@selector(sendSelectedPictureToVC:)]) {
        [_delegate sendSelectedPictureToVC:self.imgFrontPicture];
    }
}

- (void)refreshUIWith:(NSString*)title
{
    lbTitle.text = title;
}

@end
