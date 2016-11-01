//
//  GYHSPointView.m
//
//  Created by apple on 16/7/27.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSPointView.h"
#import "GYSettingHttpTool.h"
#define kLeftWidth kDeviceProportion(10)
#define kBUttonHeight kDeviceProportion(41)
#define kLineWidth kDeviceProportion(3)
#define kButtonTag 100
#define kDividNumber 2
@interface GYHSPointView ()
@property (nonatomic, strong) NSArray<NSString*>* pointArray;
@property (nonatomic, assign) NSInteger selectFlag;
@property (nonatomic, strong) NSMutableArray* buttonArr;
@end
@implementation GYHSPointView

#pragma mark - load
- (NSMutableArray*)buttonArr
{
    if (_buttonArr == nil) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray*)array
{
    if (self = [super initWithFrame:frame]) {
        self.pointArray = [@[ kLocalized(@"GYHS_Point_Point_Rate") ] arrayByAddingObjectsFromArray:array];
        self.backgroundColor = kDefaultVCBackgroundColor;
        [self setup];
        //积分比率设置注册，修改通知
        [kDefaultNotificationCenter addObserver:self
                                       selector:@selector(getPoint)
                                           name:
                                               GYSetPointSuccesssNotification
                                         object:nil];
    }
    return self;
}

#pragma mark - setup
- (void)setup
{
    self.size = CGSizeMake(self.width, (self.pointArray.count + 1) / kDividNumber * kBUttonHeight + (self.pointArray.count + 1) / kDividNumber * kLineWidth);
    for (int i = 0; i < self.pointArray.count; i++) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i % kDividNumber * (self.width - kLineWidth) / kDividNumber + (i % kDividNumber ? kLineWidth : 0), i / kDividNumber * kBUttonHeight + (i / kDividNumber * kLineWidth), (self.width - kLineWidth) / kDividNumber, kBUttonHeight);
        button.backgroundColor = [UIColor whiteColor];
        button.tag = kButtonTag + i;
        [button setTitleColor:kGray878787 forState:UIControlStateNormal];
        if (i == 0) {
            //积分比例
            button.enabled = NO;
            [button setTitle:self.pointArray[i] forState:UIControlStateNormal];
            [button setTitleColor:kBlue177EFD forState:UIControlStateNormal];
        } else {
            //格式化
            [button setTitle:[NSString stringWithFormat:@"%.4f", self.pointArray[i].doubleValue] forState:UIControlStateNormal];
            [button setBackgroundImage:[self buttonImageStrech:@"gyhs_point_noselect"] forState:UIControlStateNormal];
        }
        if (i == 1) {
            self.selectFlag = button.tag;
            [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
            [button setTitleColor:kRedE40011 forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gyhs_point_default"] forState:UIControlStateNormal];
            [button setBackgroundImage:[self buttonImageStrech:@"gyhs_point_select"] forState:UIControlStateNormal];
            
            self.pointStr = button.titleLabel.text;
        }
        
        [self.buttonArr addObject:button];
        [button addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

#pragma mark - 修改积分比例通知
- (void)getPoint
{
    [GYSettingHttpTool getEntPointRateList:^(id responsObject) {
        self.pointArray = [@[ kLocalized(@"GYHS_Point_Point_Rate") ] arrayByAddingObjectsFromArray:responsObject];
        [self reloadBtnTitle];
    }
                                   failure:^{
                                   }];
}

- (void)reloadBtnTitle
{
    for (int i = 0; i < self.pointArray.count; i++) {
        UIButton* button = self.buttonArr[i];
        [button setTitle:self.pointArray[i] forState:UIControlStateNormal];
    }
    if (_block) {
        _block(self.pointArray[self.selectFlag - kButtonTag]);
    }

}

#pragma mark - selectClick
- (void)selectClick:(UIButton*)button
{
    UIButton* currectBtn = [self viewWithTag:button.tag];
    UIButton* lastBtn = [self viewWithTag:self.selectFlag];
    if (!self.selectFlag) {
        [currectBtn setTitleColor:kRedE40011 forState:UIControlStateNormal];
        [currectBtn setBackgroundImage:[self buttonImageStrech:@"gyhs_point_select"] forState:UIControlStateNormal];
    } else {
        [lastBtn setTitleColor:kGray878787 forState:UIControlStateNormal];
        [lastBtn setBackgroundImage:[self buttonImageStrech:@"gyhs_point_noselect"] forState:UIControlStateNormal];
        
        [currectBtn setTitleColor:kRedE40011 forState:UIControlStateNormal];
        [currectBtn setBackgroundImage:[self buttonImageStrech:@"gyhs_point_select"] forState:UIControlStateNormal];
    }
    self.selectFlag = button.tag;
    if (_block) {
        _block(currectBtn.titleLabel.text);
    }
}

- (UIImage*)buttonImageStrech:(NSString*)imagename
{
    UIImage* btnImage = [UIImage imageNamed:imagename];
    CGFloat btnImageW = btnImage.size.width * 0.5;
    CGFloat btnImageH = btnImage.size.height * 0.5;
    UIImage* newBtnImage = [btnImage resizableImageWithCapInsets:UIEdgeInsetsMake(btnImageH, btnImageW, btnImageH, btnImageW) resizingMode:UIImageResizingModeStretch];
    return newBtnImage;
}

- (void)dealloc
{
    [kDefaultNotificationCenter removeObserver:self];
    
}
@end
