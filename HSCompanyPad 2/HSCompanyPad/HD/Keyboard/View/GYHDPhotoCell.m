//
//  GYHDPhotoCell.m
//  HSConsumer
//
//  Created by shiang on 16/2/22.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPhotoCell.h"
#import "GYHDPhotoModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GYHDPhotoCell ()
/**显示图片状态*/
@property(nonatomic, weak)UIImageView *photoImageView;
/**图片选中状态按钮*/
@property(nonatomic, weak)UIButton *photoSelectButton;
@end
int selectImageCount = 0;
@implementation GYHDPhotoCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return self;
    self.backgroundColor = [UIColor blackColor];
    [self setup];
    return self;
}

- (void)setup
{

    // 图片控制器
    UIImageView *photoImageView = [[UIImageView alloc] init];
    photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    photoImageView.clipsToBounds = YES;
    [self addSubview:photoImageView];
    _photoImageView = photoImageView;
    [photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    @weakify(self);
    // 选中按钮
    UIButton *photoSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoSelectButton setImage:[UIImage imageNamed:@"gyhd_choose_btn_normal"] forState:UIControlStateNormal];
    [photoSelectButton setImage:[UIImage imageNamed:@"gyhd_choose_btn_select"] forState:UIControlStateSelected];
    [photoSelectButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:photoSelectButton];
    _photoSelectButton = photoSelectButton;
    [photoSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.right.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40.0f, 40.0f));
    }];
    
}


- (void)photoButtonClick:(UIButton *)button
{
    
    self.photoModel.photoSelectStates = button.selected = ! button.selected;
    if (button.selected) {
        if (selectImageCount>9-1) {
            self.photoModel.photoSelectStates = button.selected = ! button.selected;
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            [window makeToast:kLocalized(@"GYHD_SelectUp_To_9_Pictures") duration:0.25f position:CSToastPositionCenter];
        } else {
            selectImageCount++;
        }
    }else {
        selectImageCount--;
    }
}

- (void)setPhotoModel:(GYHDPhotoModel *)photoModel
{
    _photoModel = photoModel;
    self.photoImageView.image = photoModel.photoThumbnailImage;
    self.photoSelectButton.selected = photoModel.photoSelectStates;
}

- (void)dealloc {
    selectImageCount = 0;
}
@end
