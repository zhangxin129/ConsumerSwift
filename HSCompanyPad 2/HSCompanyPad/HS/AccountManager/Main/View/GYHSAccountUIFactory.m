//
//  GYHSCompanyAccountInputView.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSAccountUIFactory.h"
#import <GYKit/UIView+Extension.h>
#import <GYKit/UIView+Extension.h>
#import <BlocksKit/BlocksKit.h>
#import "GYTextField.h"

#define kImageLeftwidth kDeviceProportion(10)
#define kFieldLeftWidth kDeviceProportion(7)
#define kImageSize kDeviceProportion(26)
#define kFieldHeight kDeviceProportion(26)
//重新定义宏
#define kLabelLeftwidth kDeviceProportion(15)
#define kLabelTotalwidth kDeviceProportion(80)
#define kSmallImageSize kDeviceProportion(8)
#define kWordsSpace kDeviceProportion(8)
#define kWordsTopSpace kDeviceProportion(10)

//后面添加的
#define kCommonTopSpace kDeviceProportion(25)
#define kCommonLeftSpace kDeviceProportion(49)
#define kCommonPicSizeWH kDeviceProportion(72)
#define kLabelTopSpace kDeviceProportion(13)

#define kSamllPicSizeWH kDeviceProportion(26)
#define kSamllPicLeftSpace kDeviceProportion(20)
#define kLitterPicSizeWH kDeviceProportion(20)
#define kRemoveBankCardInfo  1444
@interface GYHSAccountUIFactory () <UITextFieldDelegate>
@end

@implementation GYHSAccountUIFactory

//给定边框类型
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.customBorderType = UIViewCustomBorderTypeBottom;
}

#pragma mark-----第一个小方框

- (instancetype)initKVImageViewWithFrame:(CGRect)frame imageName:(NSString *)imageName title:(NSString *)title value:(NSString *)value valueColor:(UIColor *)color
{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftwidth, 0, kImageSize, kImageSize)];
        imageView.centerY = self.size.height / 2; //定位中间
        imageView.image   = [UIImage imageNamed:imageName];
        [self addSubview:imageView];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = title;
        [self addSubview:titleLabel];
        titleLabel.font      = kFont32; //具体多大的字体?
        titleLabel.textColor = kGray333333;
        CGSize labelSize = [self giveLabelWith:titleLabel.font
                                      nsstring:titleLabel.text];
        @weakify(self);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(imageView.mas_right).offset(kFieldLeftWidth);
            make.width.equalTo(@(labelSize.width + 1));
            make.height.equalTo(@(labelSize.height));
            make.centerY.equalTo(self.mas_centerY);
        }];
        titleLabel.textAlignment   = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceProportion(110) - kDeviceProportion(10), 0, frame.size.width - kDeviceProportion(110), frame.size.height)];
        valueLabel.text            = value;
        valueLabel.textColor       = color;
        valueLabel.font            = kFont32;
        valueLabel.textAlignment   = NSTextAlignmentRight;
        valueLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:valueLabel];
        self.valueLabel      = valueLabel;
        self.backgroundColor = kWhiteFFFFFF;
    }

    return self;
}

#pragma mark-----第二个小方框
//创建 带 输入转出积分数的 小方框
- (instancetype)initInputViewWithFrame:(CGRect)frame title:(NSString *)words placeholder:(NSString *)placeholder
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = words;
        [self addSubview:titleLabel];
        titleLabel.font      = kFont32; //具体多大的字体?
        titleLabel.textColor = kGray666666;
        CGSize labelSize = [self giveLabelWith:titleLabel.font
                                      nsstring:titleLabel.text];

        @weakify(self);
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self).offset(kLabelLeftwidth);
            make.width.equalTo(@(kLabelTotalwidth)); //????????
            make.height.equalTo(@(labelSize.height));
            make.centerY.equalTo(self.mas_centerY);
        }];

        titleLabel.textAlignment   = NSTextAlignmentLeft;
        titleLabel.backgroundColor = [UIColor clearColor];

        //2 设定输入框
        GYTextField *textfield = [[GYTextField alloc] init]; //给定输入框的大小位置
        textfield.placeholder     = placeholder; //预留文字
        textfield.textColor       = kGray333333;
        textfield.inputView       = [[UIView alloc] initWithFrame:CGRectZero];
        textfield.clearButtonMode = UITextFieldViewModeWhileEditing; //边上的清除标记
        [textfield addTarget:self
                      action:@selector(textChange:)
            forControlEvents:UIControlEventAllEvents];
        [self addSubview:textfield];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            
            @strongify(self);
            make.left.equalTo(titleLabel.mas_right).offset(kLabelLeftwidth);
            make.right.equalTo(self);
            make.top.bottom.equalTo(self);
            
        }];
        self.textField       = textfield;
        self.backgroundColor = kWhiteFFFFFF;
    }
    return self;
}

- (void)textChange:(GYTextField *)textField
{
    if (textField.isEditing)
    {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor redColor] CGColor];
    }
    else
    {
        self.layer.borderWidth = 0;
    }
}

#pragma mark-----第四个小方框 (小标示 后面是 实时显示敲入的数字)
//生成左右两边各一个的标签 后面用
- (instancetype)initImageValueViewWithFrame:(CGRect)frame imageName:(NSString *)imageName value:(NSString *)value

{
    if (self = [super initWithFrame:frame])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kImageLeftwidth, 0, kImageSize, kImageSize)]; //直接硬编码给定图片大小位置
        imageView.centerY = self.size.height / 2; //定位中间
        imageView.image   = [UIImage imageNamed:imageName];
        [self addSubview:imageView];

        //2 设置自定义视图上的label
        UILabel *label = [[UILabel alloc] init];
        label.text = value;
        [self addSubview:label];
        label.font      = kFont32;
        label.textColor = kGray333333;
        self.valueLabel = label;
        CGSize labelSize = [self giveLabelWith:label.font
                                      nsstring:label.text];

        @weakify(self);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(imageView.mas_right).offset(kFieldLeftWidth);
            make.width.equalTo(@(kLabelTotalwidth * 2));
            make.height.equalTo(@(labelSize.height));
            make.centerY.equalTo(self.mas_centerY);
        }];

        label.textAlignment   = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];

        self.backgroundColor = kWhiteFFFFFF; //?????
    }
    return self;
}

#pragma mark-----第五个小方框
- (void)initWithFrame:(CGRect)frame showTipsWords:(NSString *)tips
{
    self.frame = frame;
    //1 设置第一个label

    UILabel *label = [[UILabel alloc] init];
    label.text = kLocalized(@"GYHS_Account_The_Tips"); //GYHS_Account_The_Tips
    [self addSubview:label];
    label.font      = kFont24;
    label.textColor = kGray999999;
    CGSize labelSize = [self giveLabelWith:label.font
                                  nsstring:label.text];

    @weakify(self);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(labelSize.width + 1));     //????????
        make.height.equalTo(@(labelSize.height));
        make.top.equalTo(self).offset(kWordsTopSpace);
    }];

    label.textAlignment   = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = [UIColor grayColor];

    //2 设定下面的小图 和 提示信息
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:kLocalized(@"gyhs_small_point_icon")];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(kSmallImageSize));     //????????
        make.height.equalTo(@(kSmallImageSize));
        make.top.equalTo(label.mas_bottom).offset(kWordsSpace + 4);
    }];

    UILabel *label2 = [[UILabel alloc] init];
    label2.text = tips;
    [self addSubview:label2];
    label2.font          = kFont24;
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat contentW = frame.size.width - kImageLeftwidth * 2 - kSmallImageSize;

    CGRect tmpRectDown = [label2.text
                          boundingRectWithSize:CGSizeMake(contentW, 1000)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:label2.font, NSFontAttributeName, nil]
                                       context:nil];

    // 高度H
    CGFloat contentHDown = tmpRectDown.size.height;

    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(imageView.mas_right).offset(kImageLeftwidth - kDeviceProportion(5));
        make.width.equalTo(@(contentW));     //????????
        make.height.equalTo(@(contentHDown + 2));
        make.top.equalTo(label.mas_bottom).offset(kWordsSpace);
    }];

    label2.textAlignment   = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor       = kGray999999;

    self.backgroundColor = kWhiteFFFFFF;
}


- (void)initTwoTipsWithFrame:(CGRect)frame showTipsWords:(NSString *)tips andAnotherWords:(NSString *)tipsTwo
{
    self.frame = frame;
    //1 设置第一个label
    
    UILabel *label = [[UILabel alloc] init];
    label.text = kLocalized(@"GYHS_Account_The_Tips"); //GYHS_Account_The_Tips
    [self addSubview:label];
    label.font      = kFont24;
    label.textColor = kGray999999;
    CGSize labelSize = [self giveLabelWith:label.font
                                  nsstring:label.text];
    
    @weakify(self);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(labelSize.width + 1));     //????????
        make.height.equalTo(@(labelSize.height));
        make.top.equalTo(self).offset(kWordsTopSpace);
    }];
    
    label.textAlignment   = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];
    label.textColor       = [UIColor grayColor];
    
    //2 设定下面的小图 和 提示信息
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:kLocalized(@"gyhs_small_point_icon")];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(kSmallImageSize));     //????????
        make.height.equalTo(@(kSmallImageSize));
        make.top.equalTo(label.mas_bottom).offset(kWordsSpace + 4);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = tips;
    [self addSubview:label2];
    label2.font          = kFont24;
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat contentW = frame.size.width - kImageLeftwidth * 2 - kSmallImageSize;
    
    CGRect tmpRectDown = [label2.text
                          boundingRectWithSize:CGSizeMake(contentW, 1000)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:label2.font, NSFontAttributeName, nil]
                          context:nil];
    
    // 高度H
    CGFloat contentHDown = tmpRectDown.size.height;
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(imageView.mas_right).offset(kImageLeftwidth - kDeviceProportion(5));
        make.width.equalTo(@(contentW));     //????????
        make.height.equalTo(@(contentHDown + 2));
        make.top.equalTo(label.mas_bottom).offset(kWordsSpace);
    }];
    
    label2.textAlignment   = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor       = kGray999999;
    
    
    UIImageView *imageView2 = [[UIImageView alloc] init];
    [self addSubview:imageView2];
    imageView2.image = [UIImage imageNamed:kLocalized(@"gyhs_small_point_icon")];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(kSmallImageSize));     //????????
        make.height.equalTo(@(kSmallImageSize));
        make.top.equalTo(imageView.mas_bottom).offset(kWordsSpace + 7);
    }];
    
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = tipsTwo;
    [self addSubview:label3];
    label3.font          = kFont24;
    label3.numberOfLines = 0;
    label3.lineBreakMode = NSLineBreakByWordWrapping;

    
    CGRect tmpRectDown2 = [label3.text
                          boundingRectWithSize:CGSizeMake(contentW, 1000)
                          options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:[NSDictionary dictionaryWithObjectsAndKeys:label3.font, NSFontAttributeName, nil]
                          context:nil];
    
    // 高度H
    CGFloat contentHDown2 = tmpRectDown2.size.height;
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(imageView2.mas_right).offset(kImageLeftwidth - kDeviceProportion(5));
        make.width.equalTo(@(contentW));     //????????
        make.height.equalTo(@(contentHDown2 + 2));
        make.top.equalTo(label2.mas_bottom).offset(kWordsSpace);
    }];
    
    label3.textAlignment   = NSTextAlignmentLeft;
    label3.backgroundColor = [UIColor clearColor];
    label3.textColor       = kGray999999;

    self.backgroundColor = kWhiteFFFFFF;
}




#pragma mark-----第六个小方框(输入8位数字密码)
- (instancetype)initPasswordViewWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        GYTextField *textField = [[GYTextField alloc] init];
        [self addSubview:textField];
        self.textField = textField;
        @weakify(self);
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);

            make.left.right.top.bottom.equalTo(self);

        }];
        _textField.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"GYHS_Account_Please_Enter_A_8_Transaction_Password") //
                                                                                        attributes:@{ NSFontAttributeName : kFont32, NSForegroundColorAttributeName : kRedE40011 }];
        _textField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
        UIImage *image              = [UIImage imageNamed:kLocalized(@"comman_inputPasswordsIcon")];
        NSTextAttachment *imageMent = [[NSTextAttachment alloc] init];
        imageMent.image  = image;
        imageMent.bounds = CGRectMake(10, -7, image.size.width, image.size.height);
        NSAttributedString *imageAttr =
            [NSAttributedString attributedStringWithAttachment:imageMent];
        [placeholder appendAttributedString:imageAttr];
        _textField.attributedPlaceholder = placeholder;
        _textField.clearButtonMode       = UITextFieldViewModeAlways;

        self.backgroundColor = kWhiteFFFFFF;
    }
    return self;
}

//创建一个 类似中国银行 尾号多少多少字样的通用样式 (前面有logo 中间有带借记卡之类的字样) //
- (void)initBankCardViewWithImageName:(NSString *)imageName title:(NSString *)title bankCardType:(NSString *)bankCardType value:(NSString *)value
{


    //应该动态创建
    for (int i = 0; i < 4; i++)
    {
        UIView *view = [self viewWithTag:kRemoveBankCardInfo];
        if (view)
        {
            [view removeFromSuperview];
        }
    }
    self.backgroundColor = kWhiteFFFFFF;
    UIImageView *imageview = [[UIImageView alloc] init];
    [self addSubview:imageview];
    imageview.tag             = kRemoveBankCardInfo;
    imageview.image           = [UIImage imageNamed:imageName]; //imagename
    imageview.backgroundColor = [UIColor whiteColor];    //测试
    @weakify(self);
    [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.height.equalTo(@(kDeviceProportion(26)));
        make.left.equalTo(self).offset(kDeviceProportion(5));
        make.centerY.equalTo(self.mas_centerY);
    }];
    //显示什么银行
    UILabel *statuLb1 = [[UILabel alloc] init];
    [self addSubview:statuLb1];
    statuLb1.tag  = kRemoveBankCardInfo;
    statuLb1.font = kFont36;

    statuLb1.text = title;
    CGSize label1Size = [self giveLabelWith:statuLb1.font
                                   nsstring:statuLb1.text];
    [statuLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.width.equalTo(@(label1Size.width + 1));
        make.height.equalTo(@(label1Size.height));
        make.left.equalTo(imageview.mas_right).offset(kDeviceProportion(5));
        make.centerY.equalTo(self.mas_centerY);
    }];

    statuLb1.backgroundColor = [UIColor clearColor];
    statuLb1.textColor       = kGray333333;
    statuLb1.textAlignment   = NSTextAlignmentLeft;
    self.titleLabel          = statuLb1;

    //显示什么账户类型(卡类型)
    UILabel *smallStatuLb1 = [[UILabel alloc] init];
    [self addSubview:smallStatuLb1];
    smallStatuLb1.tag  = kRemoveBankCardInfo;
    smallStatuLb1.font = kFont32;
    //此处应该是根据传值来进行显示  bankCardType
    smallStatuLb1.text = [self giveBankCardType:bankCardType];
    CGSize smallStatuLb1Size = [self giveLabelWith:smallStatuLb1.font
                                          nsstring:smallStatuLb1.text];

    [smallStatuLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.width.equalTo(@(smallStatuLb1Size.width + 1));
        make.height.equalTo(@(smallStatuLb1Size.height));
        make.left.equalTo(statuLb1.mas_right).offset(kDeviceProportion(0));
        make.bottom.equalTo(statuLb1.mas_bottom);
    }];

    smallStatuLb1.backgroundColor = kClearColor;
    smallStatuLb1.textColor       = kGray999999;
    smallStatuLb1.textAlignment   = NSTextAlignmentLeft;






    UILabel *statuLb2 = [[UILabel alloc] init];

    [self addSubview:statuLb2];
    statuLb2.tag       = kRemoveBankCardInfo;
    statuLb2.font      = kFont32;
    statuLb2.textColor = kGray333333;
    statuLb2.text      = value;
    CGSize label2Size = [self giveLabelWith:statuLb2.font
                                   nsstring:statuLb2.text];
    [statuLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.bottom.equalTo(self);
        make.width.equalTo(@(label2Size.width + 1));
        make.right.equalTo(self.mas_right).offset(-kDeviceProportion(10));
    }];
    statuLb2.textAlignment   = NSTextAlignmentRight;
    self.valueLabel          = statuLb2;
    statuLb2.backgroundColor = [UIColor clearColor];

}

- (NSString *)giveBankCardType:(NSString *)bankCardType
{
    if ([bankCardType isEqualToString:kLocalized(@"DR_CARD")])
    {
        return kLocalized(@"GYHS_Account_Debit_Card");
    }
    else if ([bankCardType isEqualToString:kLocalized(@"CR_CARD")])
    {
        return kLocalized(@"GYHS_Account_Loan_Card");
    }
    else if ([bankCardType isEqualToString:kLocalized(@"PASSBOOK")])
    {
        return kLocalized(@"GYHS_Account_Passbook");
    }
    else if ([bankCardType isEqualToString:kLocalized(@"CORP_ACCT")])
    {
        return kLocalized(@"GYHS_Account_Public_Account");
    }
    else
    {
        return @"";
    }
}

#pragma mark-----自定义一左右两边 字体和颜色都自定义的标签
//生成左右两边各一个的标签 后面用
- (instancetype)initKVCustomViewWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value valueColor:(UIColor *)valueColor isOKButton:(BOOL)isOKButton
{
    if (self = [super initWithFrame:frame])
    {
        self.frame                  = frame;
        self.userInteractionEnabled = YES;
        //1 设置第一个label

        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        [self addSubview:label];
        label.font = kFont32;
        CGSize labelSize = [self giveLabelWith:label.font
                                      nsstring:label.text];

        @weakify(self);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self).offset(kLabelLeftwidth);
            make.width.equalTo(@(labelSize.width + 2));
            make.height.equalTo(@(labelSize.height));
            make.centerY.equalTo(self.mas_centerY);
        }];

        label.textAlignment   = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.textColor       = kGray999999;

        //2 设定第二个label
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = value;
        [self addSubview:label2];
        label2.font = kFont32;
        CGSize labelSize2 = [self giveLabelWith:label2.font
                                       nsstring:label2.text];
        if (!isOKButton)
        {
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);
                make.left.equalTo(label.mas_right).offset(kImageLeftwidth + kDeviceProportion(5));
                make.width.equalTo(@(kLabelTotalwidth * 2)); //
                make.height.equalTo(@(labelSize2.height));
                make.centerY.equalTo(self.mas_centerY);
            }];
            label2.textAlignment = NSTextAlignmentLeft;
        }
        else
        {
            [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
                @strongify(self);

                make.right.equalTo(self).offset(kImageLeftwidth - 20);
                make.width.equalTo(@(kLabelTotalwidth * 3)); //
                make.height.equalTo(@(labelSize2.height));
                make.centerY.equalTo(self.mas_centerY);
            }];
            label2.textAlignment = NSTextAlignmentRight;
        }

        self.valueLabel = label2;

        label2.backgroundColor = [UIColor clearColor];
        label2.textColor       = valueColor;
        self.backgroundColor   = kWhiteFFFFFF;
    }
    return self;
}

#pragma mark-----自定义二 生成三句话的提示框
- (void)initWithFrame:(CGRect)frame showTipsWordsOne:(NSString *)tipsOne tipsWordsTwo:(NSString *)tipsTwo tipsWordsThree:(NSString *)tipsThree
{
    self.frame = frame;
    //1 设置第一个label

    UILabel *label = [[UILabel alloc] init];
    label.text = kLocalized(@"GYHS_Account_The_Tips");
    [self addSubview:label];
    label.font      = kFont24; //
    label.textColor = kGray999999;
    CGSize labelSize = [self giveLabelWith:label.font
                                  nsstring:label.text];

    @weakify(self);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(labelSize.width + 1));     //
        make.height.equalTo(@(labelSize.height));
        make.top.equalTo(self).offset(kWordsTopSpace);
    }];

    label.textAlignment   = NSTextAlignmentLeft;
    label.backgroundColor = [UIColor clearColor];

    //2 设定下面的小图 和 提示信息
    UIImageView *imageView = [[UIImageView alloc] init];
    [self addSubview:imageView];
    imageView.image = [UIImage imageNamed:kLocalized(@"gyhs_small_point_icon")];

    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(kSmallImageSize));     //
        make.height.equalTo(@(kSmallImageSize));
        make.top.equalTo(label.mas_bottom).offset(kWordsSpace + 4);
    }];

    //第一句话
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = tipsOne;
    [self addSubview:label2];
    label2.font          = kFont24;
    label2.textColor     = kGray999999;
    label2.numberOfLines = 0;
    label2.lineBreakMode = NSLineBreakByWordWrapping;
    CGFloat contentW = frame.size.width - kImageLeftwidth * 2 - kSmallImageSize;

    CGRect tmpRectDown = [label2.text
                          boundingRectWithSize:CGSizeMake(contentW, 1000)
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:[NSDictionary dictionaryWithObjectsAndKeys:label2.font, NSFontAttributeName, nil]
                                       context:nil];

    CGFloat contentHDown = tmpRectDown.size.height;
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(imageView.mas_right).offset(kImageLeftwidth - kDeviceProportion(5));
        make.width.equalTo(@(contentW));     //
        make.height.equalTo(@(contentHDown));
        make.top.equalTo(label.mas_bottom).offset(kWordsSpace);
    }];

    label2.textAlignment   = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];

    //3 设定下面的小图 和 提示信息
    UIImageView *imageView2 = [[UIImageView alloc] init];
    [self addSubview:imageView2];
    imageView2.image = [UIImage imageNamed:kLocalized(@"gyhs_small_point_icon")];

    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(kSmallImageSize));     //
        make.height.equalTo(@(kSmallImageSize));
        make.top.equalTo(label2.mas_bottom).offset(kWordsSpace + 2);
    }];

    //第二句话
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = tipsTwo;
    [self addSubview:label3];
    label3.font          = kFont24;
    label3.textColor     = kGray999999;
    label3.numberOfLines = 0;
    label3.lineBreakMode = NSLineBreakByWordWrapping;

    CGRect tmpRectDown2 = [label3.text
                           boundingRectWithSize:CGSizeMake(contentW, 1000)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:label2.font, NSFontAttributeName, nil]
                                        context:nil];

    CGFloat contentHDown2 = tmpRectDown2.size.height;
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(imageView2.mas_right).offset(kImageLeftwidth - kDeviceProportion(5));
        make.width.equalTo(@(contentW));     //
        make.height.equalTo(@(contentHDown2));
        make.top.equalTo(label2.mas_bottom).offset(kWordsSpace);
    }];

    label3.textAlignment   = NSTextAlignmentLeft;
    label3.backgroundColor = [UIColor clearColor];

    //4 设定下面的小图 和 提示信息
    UIImageView *imageView3 = [[UIImageView alloc] init];
    [self addSubview:imageView3];
    imageView3.image = [UIImage imageNamed:kLocalized(@"gyhs_small_point_icon")];

    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.equalTo(self).offset(kImageLeftwidth);
        make.width.equalTo(@(kSmallImageSize));     //????????
        make.height.equalTo(@(kSmallImageSize));
        make.top.equalTo(label3.mas_bottom).offset(kWordsSpace + 1);
    }];

    //第二句话
    UILabel *label4 = [[UILabel alloc] init];
    label4.text = tipsThree;
    [self addSubview:label4];
    label4.font          = kFont24; //
    label4.textColor     = kGray999999;
    label4.numberOfLines = 0;
    label4.lineBreakMode = NSLineBreakByWordWrapping;

    CGRect tmpRectDown3 = [label4.text
                           boundingRectWithSize:CGSizeMake(contentW, 1000)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:[NSDictionary dictionaryWithObjectsAndKeys:label4.font, NSFontAttributeName, nil]
                                        context:nil];

    CGFloat contentHDown3 = tmpRectDown3.size.height;
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        //@strongify(self);
        make.left.equalTo(imageView3.mas_right).offset(kImageLeftwidth - kDeviceProportion(5));
        make.width.equalTo(@(contentW));     //????????
        make.height.equalTo(@(contentHDown3));
        make.top.equalTo(label3.mas_bottom).offset(kWordsSpace);
    }];

    label4.textAlignment   = NSTextAlignmentLeft;
    label4.backgroundColor = [UIColor clearColor];

    self.backgroundColor = kWhiteFFFFFF;
}

#pragma mark-----设置添加银行卡

//封装银行账户 其他银行账户 箭头类型的view
- (instancetype)initChooseViewWithFrame:(CGRect)frame title:(NSString *)title value:(NSString *)value smallArrowColor:(BOOL)isBlue
{
    if (self = [super initWithFrame:frame])
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = title;
        [self addSubview:label];
        label.font = kFont32;
        CGSize labelSize = [self giveLabelWith:label.font
                                      nsstring:label.text];
        @weakify(self);
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self).offset(kDeviceProportion(10));
            make.width.equalTo(@(labelSize.width + 2)); //????????
            make.height.equalTo(@(labelSize.height));
            make.centerY.equalTo(self.mas_centerY);
        }];
        label.textAlignment   = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor clearColor];
        label.textColor       = kGray333333;

        //设置右边的箭头

        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        if (isBlue)
        {
            imageView.image = [UIImage imageNamed:kLocalized(@"gyhs_smallarrow_blue")];
        }
        else
        {
            imageView.image = [UIImage imageNamed:kLocalized(@"gyhs_smallarrow_red")];
        }
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(self).offset(-kDeviceProportion(10));
            make.width.equalTo(@(kDeviceProportion(26))); //????????
            make.height.equalTo(@(kDeviceProportion(26)));
            make.centerY.equalTo(self.mas_centerY);
        }];
        imageView.userInteractionEnabled = YES;

        //2 设定第二个label
        UILabel *label2 = [[UILabel alloc] init];
        label2.text = value;

        self.valueLabel = label2;
        [self addSubview:label2];
        label2.font = kFont32;
        CGSize labelSize2 = [self giveLabelWith:label2.font
                                       nsstring:label2.text];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.right.equalTo(imageView.mas_left).offset(-kDeviceProportion(10));
            make.width.equalTo(@(labelSize2.width + 1)); //
            make.height.equalTo(@(labelSize2.height));
            make.centerY.equalTo(self.mas_centerY);
        }];
        label2.textAlignment   = NSTextAlignmentRight;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor       = kBlue0A59C1;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(turnToAnotherView)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = kWhiteFFFFFF;
    }
    return self;
}

- (void)turnToAnotherView
{
    if ([self.delegate
         respondsToSelector:@selector(hsAccountUITurnToBankList:)])
    {
        [self.delegate
         hsAccountUITurnToBankList:self];
    }
}

//给一个label的字符串 返回自适应文本宽高
- (CGSize)giveLabelWith:(UIFont *)fnt nsstring:(NSString *)string
{
    UILabel *label = [[UILabel alloc] init];

    label.text = string;


    return [label.text
            sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt, NSFontAttributeName, nil]];
}

@end
