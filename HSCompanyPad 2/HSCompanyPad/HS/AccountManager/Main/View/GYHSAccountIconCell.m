//
//  GYHSAccountIconCell.m
//  HSCompanyPad
//
//  Created by sqm on 16/8/25.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//
#define kCommonTopSpace kDeviceProportion(25)
#define kCommonLeftSpace kDeviceProportion(49)
#define kCommonPicSizeWH kDeviceProportion(72)
#import "GYHSAccountIconCell.h"
#import "GYHSAccountIconModel.h"
static NSString *const GYTableViewCellID = @"GYHSAccountIconCell";
@interface GYHSAccountIconCell ()
@property (nonatomic, weak) UIImageView *icon;
@property (nonatomic, weak) UILabel *title;
@end
@implementation GYHSAccountIconCell
#pragma instance
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    GYHSAccountIconCell *cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell)
    {
        cell = [[GYHSAccountIconCell alloc]initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier :GYTableViewCellID];
    }
    return cell;
}

#pragma mark - overWrite
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style
                    reuseIdentifier :reuseIdentifier])
    {
        [self initView];
    }
    return self;
}

/**
 *  初始化视图
 */
- (void)initView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.contentView
     addSubview:imageView];
    self.icon           = imageView;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UILabel *label = [[UILabel alloc]init];
    label.textAlignment   = NSTextAlignmentCenter;
    label.backgroundColor = kClearColor;
    label.font            = kFont42;
    [self.contentView
     addSubview:label];
    self.title = label;
}

//set方法
- (void)setModel:(GYHSAccountIconModel *)model
{
    _model      = model;
    _title.text = model.title;
    _icon.image = [UIImage imageNamed:model.unSelectedImage];
}

- (void)setSelect:(BOOL)select
{
    _select = select;
    if (select)
    {
        _icon.image           = [UIImage imageNamed:self.model.selectedImage];
        _title.textColor      = kBlue0A59C2;
        self.customBorderType = UIViewCustomBorderTypeNone;
    }
    else
    {
        _icon.image           = [UIImage imageNamed:self.model.unSelectedImage];
        _title.textColor      = kGray888888;
        self.customBorderType = UIViewCustomBorderTypeAll;
    }
}

/**
 *  子视图更新
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.cellNumber == 3)
    {
        self.icon.frame = CGRectMake(kCommonLeftSpace, kDeviceProportion(51), kCommonPicSizeWH, kCommonPicSizeWH);
    }
    else if (self.cellNumber == 4)
    {
        self.icon.frame = CGRectMake(kCommonLeftSpace, kCommonTopSpace, kCommonPicSizeWH, kCommonPicSizeWH);
    }
    else
    {
        self.icon.frame = CGRectMake(kCommonLeftSpace, kCommonTopSpace, kCommonPicSizeWH, kCommonPicSizeWH);    //这个假如是按两个cell的状态 暂时不知道两个的状态下是怎样的
    }
    self.title.frame      = CGRectMake(0, CGRectGetMaxY(self.icon.frame) + 10, self.width, 40);
    self.customBorderType = UIViewCustomBorderTypeAll;
}

@end
