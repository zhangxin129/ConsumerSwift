//
//  GYShopIntegrationCell.m
//  HSConsumer
//
//  Created by apple on 15/11/12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYShopIntegrationCell.h"
#import "GYSearchShopsMainModel.h"

@implementation GYShopIntegrationCell

- (void)awakeFromNib
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myGes:)];
    UITapGestureRecognizer* top = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cilck:)];

    _leftImageView.tag = 108;
    _leftImageView.userInteractionEnabled = YES;
    [_leftImageView addGestureRecognizer:top];
    [_rightImageView addGestureRecognizer:tap];
}

- (void)setPicArr:(NSMutableArray*)picArr
{
    if (picArr.count > 0) {

        _picArr = picArr;

        for (NSInteger i = 0; i < _picArr.count; i++) {
            NSDictionary* dic = _picArr[i];
            NSString* urlName = dic[@"picAddr"];
            if ([GYUtils checkStringInvalid:urlName]) {
                continue;
            }

            if (i == 0) {
                if ([urlName hasPrefix:@"http"]) {
                    [_leftImageView setImageWithURL:[NSURL URLWithString:urlName] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
                }
                else {
                    _leftImageView.image = [UIImage imageNamed:urlName];
                }
            }

            if ([urlName hasPrefix:@"http"]) {
                [_rightImageView setImageWithURL:[NSURL URLWithString:urlName] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
            }
            else {
                _rightImageView.image = [UIImage imageNamed:urlName];
            }
        }
    }
}

- (void)cilck:(UITapGestureRecognizer*)tap
{

    NSInteger index = tap.view.tag - 108;
    if(_picArr.count > index) {
        NSDictionary* dic = _picArr[index];
        
        if (_block) {
            _block(tap.view.tag, dic[@"id"]);
        }
    }
   
}

- (void)myGes:(UITapGestureRecognizer*)tap
{
    NSInteger index = tap.view.tag - 108;
    if(_picArr.count > index) {
        NSDictionary* dic = _picArr[index];
        
        if (_block) {
            _block(tap.view.tag, dic[@"id"]);
        }
    }
    
}

@end
