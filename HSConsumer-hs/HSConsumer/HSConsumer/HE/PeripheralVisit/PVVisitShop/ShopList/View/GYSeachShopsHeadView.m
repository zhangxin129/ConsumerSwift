//
//  GYSeachShopsHeadView.m
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYSeachShopsHeadView.h"
#import "GYAppDelegate.h"
#import "GYSearchShopsMainModel.h"
@implementation GYSeachShopsHeadView {

    UIImageView* _headImgView;
}
- (instancetype)initWithFrame:(CGRect)frame
{

    if (self = [super initWithFrame:frame]) {

        _topArr = [NSMutableArray array];
        _btnArr = [NSMutableArray array];
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, kWindow.bounds.size.width, 160)];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
    }

    return self;
}

- (void)setTopArr:(NSMutableArray*)topArr
{
    if (topArr.count > 0) {
        _topArr = topArr;

        // 移除前一次的试图
        [_headImgView removeFromSuperview];
        _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindow.bounds.size.width, 80)];

        NSDictionary* dic = _topArr[0];

        NSString* fileName = dic[@"picAddr"];
        if ([fileName hasPrefix:@"http"]) {
            [_headImgView setImageWithURL:[NSURL URLWithString:fileName] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
        }
        else {
            _headImgView.image = [UIImage imageNamed:fileName];
        }

        _headImgView.tag = 99;
        _headImgView.backgroundColor = [UIColor lightGrayColor];
        _headImgView.userInteractionEnabled = YES;

        UITapGestureRecognizer* tapBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGes:)];
        [_headImgView addGestureRecognizer:tapBottom];
        [self addSubview:_headImgView];
    }
}

- (void)setBtnArr:(NSMutableArray*)btnArr
{
    if (btnArr.count > 0) {
        for (UIView* view in _bgView.subviews) {
            [view removeFromSuperview];
        }

        _btnArr = btnArr;

        // 计算左右间隙
        CGFloat distance_x = (kWindow.bounds.size.width - 45 * 4 - 40) / 3;
        //计算上下间隙
        CGFloat distance_y = 20;

        for (NSInteger i = 0; i < 2; i++) {

            for (NSInteger j = 0; j < 4; j++) {

                UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(20 + (distance_x + 45) * j, 10 + (distance_y + 60) * i, 45, 45)];
                imgView.tag = 4 * i + j + 100;

                imgView.userInteractionEnabled = YES;
                NSDictionary* dic = _btnArr[4 * i + j];

                NSString* fileName = dic[@"picAddr"];
                if ([fileName hasPrefix:@"http"]) {
                    [imgView setImageWithURL:[NSURL URLWithString:fileName] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
                }
                else {
                    imgView.image = [UIImage imageNamed:fileName];
                }

                UITapGestureRecognizer* tapBottom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGes:)];

                [imgView addGestureRecognizer:tapBottom];

                [_bgView addSubview:imgView];

                UILabel* lab = [[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x, CGRectGetMaxY(imgView.frame) + 5, 45, 15)];

                lab.text = dic[@"categoryName"];

                lab.textAlignment = NSTextAlignmentCenter;

                lab.font = [UIFont systemFontOfSize:12];

                [_bgView addSubview:lab];
            }
        }
    }
}

- (void)myGes:(UITapGestureRecognizer*)tap
{

    NSInteger index;
    NSDictionary* model;

    if (tap.view.tag >= 100) {

        index = tap.view.tag - 100;
        if(_btnArr.count > index)
            model = _btnArr[index];
    }

    if (_block) {

        _block(tap.view.tag, model);
    }


}

@end
