//
//  GYHEShopDetailBusinessImgView.m
//  HSConsumer
//
//  Created by xiongyn on 16/10/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEShopDetailBusinessImgView.h"

@interface GYHEShopDetailBusinessImgView()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;


@end

@implementation GYHEShopDetailBusinessImgView

- (void)awakeFromNib {
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = [_introduceLab.text boundingRectWithSize:CGSizeMake(kScreenWidth - 50 - 34, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil];
    _height.constant = CGRectGetMinY(_introduceLab.frame) + rect.size.height + 30;
//    _height.constant = CGRectGetMaxY(_introduceLab.frame);
}

@end
