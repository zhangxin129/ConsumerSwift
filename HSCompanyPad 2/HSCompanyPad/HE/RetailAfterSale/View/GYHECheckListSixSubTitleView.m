//
//  GYHECheckListSixSubTitleView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/10.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHECheckListSixSubTitleView.h"
#import <GYKit/UIView+Extension.h>

#define kBtnHeight kDeviceProportion(12)
#define kLineWide  kDeviceProportion(1)  //定义一个间隔线的宽度
#define kImageWH  kDeviceProportion(15)
#define kLabelSpace  kDeviceProportion(5)
#define kLabelTitleFont  kFont24

@implementation GYHECheckListSixSubTitleView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setArray:(NSArray *)array
{
    for (UIButton * button in self.subviews) {
        [button removeFromSuperview];
    }
    
    _array = array;
    [self setUI:_array];
}

- (void)setUI:(NSArray *)array
{
    //CGFloat btnheight = 35;
    //如果数组是六个
    if (6 == array.count) {
        NSArray* arrleng = @[@(kDeviceProportion(115)),@(kDeviceProportion(260)),@( kDeviceProportion(150)),@(kDeviceProportion(150)),@(kDeviceProportion(210)),@(kDeviceProportion(115.5))];
        float leng = 0.0;
        for (int i = 0; i < array.count; i++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            float wid = [arrleng[i] floatValue];
            button.frame = CGRectMake(leng, kDeviceProportion(10), wid, kBtnHeight);
            //            if (i == array.count - 1) {
            //                button.width = btnwidth * 2;
            //            }
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            
            UIView* butTailView = [[UIView alloc] initWithFrame:CGRectMake(button.frame.origin.x + button.frame.size.width - kDeviceProportion(1), 0, kDeviceProportion(1), self.frame.size.height)];
            butTailView.backgroundColor = kGrayCFCFDA;
            [button addSubview:butTailView];
            
            
            button.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            [self addSubview:button];
            leng += wid;
            
        }
        
    }
//    else
//    {   //这是按四个小标题来设置的
//        NSArray* arrleng = @[@(kDeviceProportion(200)),@(kDeviceProportion(200)),@(kDeviceProportion(200)),@(kDeviceProportion(404))];
//        float leng = 0.0;
//        for (int i = 0; i < array.count; i++) {
//            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
//            float wid = [arrleng[i] floatValue];
//            button.frame = CGRectMake(leng, kDeviceProportion(10), wid, kBtnHeight);
//            //            if (i == array.count - 1) {
//            //                button.width = btnwidth * 2;
//            //            }
//            [button setTitle:array[i] forState:UIControlStateNormal];
//            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//            
//            
//            button.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
//            [self addSubview:button];
//            leng += wid;
//            
//        }
//        
//    }
}

#pragma mark-----里面带点图片
-(void)setSixTitle{
    //1
    UIView* firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor clearColor];
    [self addSubview:firstView];
    @weakify(self);
    [firstView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(kDeviceProportion(115)));
    }];
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = kGrayE3E3EA.CGColor;
    
    UILabel* firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.text = @"序号";
    firstLabel.textColor = kGray777777;
    firstLabel.font = kLabelTitleFont;
    CGSize firstSize = [self giveLabelWith:firstLabel.font nsstring:firstLabel.text];
    [firstView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(firstSize.width + 1));
        make.height.equalTo(@(firstSize.height + 1));
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    
//    UIView* first = [[UIView alloc] init];
//    first.backgroundColor = kGray777777;
//    [firstView addSubview:first];
////    UIView* first = [[UIView alloc] initWithFrame:CGRectMake(firstView.frame.origin.x + firstView.frame.size.width - kLineWide, 0, kLineWide, firstView.frame.size.height)];
//    [first mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(firstView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(firstView.mas_right).offset( - kLineWide);
//    }];
    
    
    //2
    UIView* secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor clearColor];
    [self addSubview:secondView];
    
    [secondView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(firstView.mas_right);
        make.width.equalTo(@(kDeviceProportion(260)));
    }];
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* secondLabel = [[UILabel alloc] init];
    [secondView addSubview:secondLabel];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text = @"流水号";
    secondLabel.textColor = kGray777777;
    secondLabel.font = kLabelTitleFont;
    CGSize secondSize = [self giveLabelWith:secondLabel.font nsstring:secondLabel.text];
    
    [secondLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(secondSize.width + 1));
        make.height.equalTo(@(secondSize.height + 1));
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY);
    }];
    
//    UIView* second = [[UIView alloc] init];
//    second.backgroundColor = kGray777777;
//    [secondView addSubview:second];
//    [second mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(secondView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(secondView.mas_right).offset( - kLineWide);
//    }];
    
    // 小图30 间隔10
    //3
    UIView* thirdView = [[UIView alloc] init];
    thirdView.backgroundColor = [UIColor clearColor];
    [self addSubview:thirdView];
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(secondView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* thirdLabel = [[UILabel alloc] init];
    [thirdView addSubview:thirdLabel];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.text = @"金额";
    thirdLabel.textColor = kGray777777;
    thirdLabel.font = kLabelTitleFont;
    CGSize thirdSize = [self giveLabelWith:thirdLabel.font nsstring:thirdLabel.text];
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(thirdSize.width + 1));
        make.height.equalTo(@(thirdSize.height + 1));
        make.centerX.mas_equalTo(thirdView.centerX + (kImageWH + kLabelSpace) * 0.5);
        make.centerY.equalTo(thirdView.mas_centerY);
    }];
    UIImageView* imageV1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_coin_icon"]];
    [thirdView addSubview:imageV1];
    [imageV1 mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(kImageWH));
        make.height.equalTo(@(kImageWH));
        make.right.equalTo(thirdLabel.mas_left).offset(-kLabelSpace);
        make.centerY.equalTo(thirdView.mas_centerY);
    }];
    
//    UIView* third = [[UIView alloc] init];
//    third.backgroundColor = kGray777777;
//    [thirdView addSubview:third];
//    [third mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(thirdView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(thirdView.mas_right).offset( - kLineWide);
//    }];
    
    
    //4
    UIView* fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fourthView];
    
    [fourthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(thirdView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    fourthView.layer.borderWidth = 1;
    fourthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fourthLabel = [[UILabel alloc] init];
    [fourthView addSubview:fourthLabel];
    fourthLabel.textAlignment = NSTextAlignmentCenter;
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.text = @"积分";
    fourthLabel.textColor = kGray777777;
    fourthLabel.font = kLabelTitleFont;
    CGSize fourthSize = [self giveLabelWith:fourthLabel.font nsstring:fourthLabel.text];
    
    [fourthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fourthSize.width + 1));
        make.height.equalTo(@(fourthSize.height + 1));
        make.centerX.mas_equalTo(fourthView.centerX + (kImageWH + kLabelSpace) * 0.5);
        make.centerY.equalTo(fourthView.mas_centerY);
    }];
    UIImageView* imageV2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhe_point_icon"]];
    [fourthView addSubview:imageV2];
    [imageV2 mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(kImageWH));
        make.height.equalTo(@(kImageWH));
        make.right.equalTo(fourthLabel.mas_left).offset(-kLabelSpace);
        make.centerY.equalTo(fourthView.mas_centerY);
    }];
    
//    UIView* fourth = [[UIView alloc] init];
//    fourth.backgroundColor = kGray777777;
//    [fourthView addSubview:fourth];
//    [fourth mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(fourthView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(fourthView.mas_right).offset( - kLineWide);
//    }];
    
    //5
    UIView* fifthView = [[UIView alloc] init];
    fifthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fifthView];
    
    [fifthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(fourthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(210)));
    }];
    fifthView.layer.borderWidth = 1;
    fifthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fifthLabel = [[UILabel alloc] init];
    [fifthView addSubview:fifthLabel];
    fifthLabel.textAlignment = NSTextAlignmentCenter;
    fifthLabel.backgroundColor = [UIColor clearColor];
    fifthLabel.text = @"交易日期";
    fifthLabel.textColor = kGray777777;
    fifthLabel.font = kLabelTitleFont;
    CGSize fifthSize = [self giveLabelWith:fifthLabel.font nsstring:fifthLabel.text];
    
    [fifthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fifthSize.width + 1));
        make.height.equalTo(@(fifthSize.height + 1));
        make.centerX.equalTo(fifthView.mas_centerX);
        make.centerY.equalTo(fifthView.mas_centerY);
    }];
    
//    UIView* fifth = [[UIView alloc] init];
//    fifth.backgroundColor = kGray777777;
//    [fifthView addSubview:fifth];
//    [fifth mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(fifthView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(fifthView.mas_right).offset( - kLineWide);
//    }];
    
    //6
    UIView* sixthView = [[UIView alloc] init];
    sixthView.backgroundColor = [UIColor clearColor];
    [self addSubview:sixthView];
    
    [sixthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(fifthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(115.5)));
    }];
    sixthView.layer.borderWidth = 1;
    sixthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* sixthLabel = [[UILabel alloc] init];
    [sixthView addSubview:sixthLabel];
    sixthLabel.textAlignment = NSTextAlignmentCenter;
    sixthLabel.backgroundColor = [UIColor clearColor];
    sixthLabel.text = @"操作";
    sixthLabel.textColor = kGray777777;
    sixthLabel.font = kLabelTitleFont;
    CGSize sixthSize = [self giveLabelWith:sixthLabel.font nsstring:sixthLabel.text];
    
    [sixthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(sixthSize.width + 1));
        make.height.equalTo(@(sixthSize.height + 1));
        make.centerX.equalTo(sixthView.mas_centerX);
        make.centerY.equalTo(sixthView.mas_centerY);
    }];
    
//    UIView* sixth = [[UIView alloc] init];
//    sixth.backgroundColor = kGray777777;
//    [sixthView addSubview:sixth];
//    [sixth mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(sixthView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(sixthView.mas_right).offset( - kLineWide);
//    }];
    
}

#pragma mark-----最通常的6标题设置
-(void)setSixCommonTitle{
    //1
    UIView* firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor clearColor];
    [self addSubview:firstView];
    @weakify(self);
    [firstView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(kDeviceProportion(115)));
    }];
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = kGrayE3E3EA.CGColor;
    
    UILabel* firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.text = @"序号";
    firstLabel.textColor = kGray777777;
    firstLabel.font = kLabelTitleFont;
    CGSize firstSize = [self giveLabelWith:firstLabel.font nsstring:firstLabel.text];
    [firstView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(firstSize.width + 1));
        make.height.equalTo(@(firstSize.height + 1));
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    
//    UIView* first = [[UIView alloc] init];
//    first.backgroundColor = kGray777777;
//    [firstView addSubview:first];
//    //    UIView* first = [[UIView alloc] initWithFrame:CGRectMake(firstView.frame.origin.x + firstView.frame.size.width - kLineWide, 0, kLineWide, firstView.frame.size.height)];
//    [first mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(firstView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(firstView.mas_right).offset( - kLineWide);
//    }];
    
    
    //2
    UIView* secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor clearColor];
    [self addSubview:secondView];
    
    [secondView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(firstView.mas_right);
        make.width.equalTo(@(kDeviceProportion(260)));
    }];
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* secondLabel = [[UILabel alloc] init];
    [secondView addSubview:secondLabel];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text = @"售后单号";
    secondLabel.textColor = kGray777777;
    secondLabel.font = kLabelTitleFont;
    CGSize secondSize = [self giveLabelWith:secondLabel.font nsstring:secondLabel.text];
    
    [secondLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(secondSize.width + 1));
        make.height.equalTo(@(secondSize.height + 1));
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY);
    }];
    
//    UIView* second = [[UIView alloc] init];
//    second.backgroundColor = kGray777777;
//    [secondView addSubview:second];
//    [second mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(secondView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(secondView.mas_right).offset( - kLineWide);
//    }];
    
    // 小图30 间隔10
    //3
    UIView* thirdView = [[UIView alloc] init];
    thirdView.backgroundColor = [UIColor clearColor];
    [self addSubview:thirdView];
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(secondView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* thirdLabel = [[UILabel alloc] init];
    [thirdView addSubview:thirdLabel];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.text = @"互生号";
    thirdLabel.textColor = kGray777777;
    thirdLabel.font = kLabelTitleFont;
    CGSize thirdSize = [self giveLabelWith:thirdLabel.font nsstring:thirdLabel.text];
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(thirdSize.width + 1));
        make.height.equalTo(@(thirdSize.height + 1));
        make.centerX.mas_equalTo(thirdView.centerX );
        make.centerY.equalTo(thirdView.mas_centerY);
    }];
    
    
//    UIView* third = [[UIView alloc] init];
//    third.backgroundColor = kGray777777;
//    [thirdView addSubview:third];
//    [third mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(thirdView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(thirdView.mas_right).offset( - kLineWide);
//    }];
    
    
    //4
    UIView* fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fourthView];
    
    [fourthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(thirdView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    fourthView.layer.borderWidth = 1;
    fourthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fourthLabel = [[UILabel alloc] init];
    [fourthView addSubview:fourthLabel];
    fourthLabel.textAlignment = NSTextAlignmentCenter;
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.text = @"申请类型";
    fourthLabel.textColor = kGray777777;
    fourthLabel.font = kLabelTitleFont;
    CGSize fourthSize = [self giveLabelWith:fourthLabel.font nsstring:fourthLabel.text];
    
    [fourthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fourthSize.width + 1));
        make.height.equalTo(@(fourthSize.height + 1));
        make.centerX.mas_equalTo(fourthView.centerX );
        make.centerY.equalTo(fourthView.mas_centerY);
    }];
    
//    UIView* fourth = [[UIView alloc] init];
//    fourth.backgroundColor = kGray777777;
//    [fourthView addSubview:fourth];
//    [fourth mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(fourthView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(fourthView.mas_right).offset( - kLineWide);
//    }];
    
    //5
    UIView* fifthView = [[UIView alloc] init];
    fifthView.backgroundColor = [UIColor clearColor];
    [self addSubview:fifthView];
    
    [fifthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(fourthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(210)));
    }];
    fifthView.layer.borderWidth = 1;
    fifthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fifthLabel = [[UILabel alloc] init];
    [fifthView addSubview:fifthLabel];
    fifthLabel.textAlignment = NSTextAlignmentCenter;
    fifthLabel.backgroundColor = [UIColor clearColor];
    fifthLabel.text = @"申请时间";
    fifthLabel.textColor = kGray777777;
    fifthLabel.font = kLabelTitleFont;
    CGSize fifthSize = [self giveLabelWith:fifthLabel.font nsstring:fifthLabel.text];
    
    [fifthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fifthSize.width + 1));
        make.height.equalTo(@(fifthSize.height + 1));
        make.centerX.equalTo(fifthView.mas_centerX);
        make.centerY.equalTo(fifthView.mas_centerY);
    }];
    
//    UIView* fifth = [[UIView alloc] init];
//    fifth.backgroundColor = kGray777777;
//    [fifthView addSubview:fifth];
//    [fifth mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(fifthView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(fifthView.mas_right).offset( - kLineWide);
//    }];
    
    //6
    UIView* sixthView = [[UIView alloc] init];
    sixthView.backgroundColor = [UIColor clearColor];
    [self addSubview:sixthView];
    
    [sixthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.left.equalTo(fifthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(115.5)));
    }];
    sixthView.layer.borderWidth = 1;
    sixthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* sixthLabel = [[UILabel alloc] init];
    [sixthView addSubview:sixthLabel];
    sixthLabel.textAlignment = NSTextAlignmentCenter;
    sixthLabel.backgroundColor = [UIColor clearColor];
    sixthLabel.text = @"状态";
    sixthLabel.textColor = kGray777777;
    sixthLabel.font = kLabelTitleFont;
    CGSize sixthSize = [self giveLabelWith:sixthLabel.font nsstring:sixthLabel.text];
    
    [sixthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(sixthSize.width + 1));
        make.height.equalTo(@(sixthSize.height + 1));
        make.centerX.equalTo(sixthView.mas_centerX);
        make.centerY.equalTo(sixthView.mas_centerY);
    }];
    
//    UIView* sixth = [[UIView alloc] init];
//    sixth.backgroundColor = kGray777777;
//    [sixthView addSubview:sixth];
//    [sixth mas_makeConstraints:^(MASConstraintMaker* make) {
//        
//        make.top.bottom.equalTo(sixthView);
//        make.width.equalTo(@(kLineWide));
//        make.right.equalTo(sixthView.mas_right).offset( - kLineWide);
//    }];

}




- (CGSize)giveLabelWith:(UIFont*)fnt nsstring:(NSString*)string
{
    UILabel* label = [[UILabel alloc] init];
    
    label.text = string;
    
    
    return [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
}


@end
