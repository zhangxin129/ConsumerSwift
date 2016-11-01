//
//  GYHSRightGenaralCell.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/1.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

//右边表视图的相应的自定义单元
#import "GYHSRightGenaralCell.h"

#import "GYHSNewButton.h"

//定义一个偏移
#define kCommonDev kDeviceProportion(75)
#define kCommonRemoveTag 331

static NSString* const GYTableViewCellID = @"GYHSRightGenaralCell";
@implementation GYHSRightGenaralCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    GYHSRightGenaralCell *cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell) {
        cell = [[GYHSRightGenaralCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:GYTableViewCellID];

    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return self;
}

#pragma mark-----创建第一种自定义的cell
- (instancetype)createNeedCustomShowDetailWith:(UIColor*)color
{
    [self setupShowDetailUIWithColor:(UIColor*)color];
    
    return self;
}

//生成一个只显示右边一排明细查询的文字及图标
- (void)setupShowDetailUIWithColor:(UIColor*)color
{
    self.userInteractionEnabled = YES;
    UIImageView* imageViewArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewArrow]; //需要先添加到父图层
    @weakify(self);
    [imageViewArrow mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.right.equalTo(self).offset(kDeviceProportion(-40));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        make.top.equalTo(self).offset(kDeviceProportion(25) + kNavigationHeight);
    }];
    
    
    imageViewArrow.image = [UIImage imageNamed:@"gyhs_smallarrow_blue"];
    imageViewArrow.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapOne)];
    [imageViewArrow addGestureRecognizer:tap1];
    
    
    
    //添加明显查询的文字label
    UILabel* textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:textLabel]; //需要先添加到父图层
    textLabel.text = kLocalized(@"GYHS_StaffManager_CheckDetails");
    
    textLabel.font = kFont48;
    
    CGSize sizelabel = [self giveLabelWith:textLabel.font nsstring:textLabel.text];
    
    CGFloat nameH = sizelabel.height;
    CGFloat nameW = sizelabel.width;
    textLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapOne)];
    [textLabel addGestureRecognizer:tap];
    //根据宽高 做约束
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.right.equalTo(imageViewArrow.mas_left).offset(kDeviceProportion(-5));
        make.width.equalTo(@(nameW));
        make.height.equalTo(@(nameH));
        //make.bottom.equalTo(imageViewArrow.mas_bottom);
        make.centerY.equalTo(imageViewArrow.mas_centerY);
    }];
    textLabel.textAlignment = NSTextAlignmentRight; //设置右边对齐
    textLabel.textColor = kBlue0A59C2;
    
    
    //再添加放大镜
    UIImageView* imageViewSearch = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewSearch]; //需要先添加到父图层
    
    [imageViewSearch mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(textLabel.mas_left).offset(kDeviceProportion(-5));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        //make.bottom.equalTo(textLabel.mas_bottom);
        make.centerY.equalTo(textLabel.mas_centerY);
    }];
    imageViewSearch.image = [UIImage imageNamed:@"gyhs_small_searchpic_blue"];
    imageViewSearch.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapOne)];
    [imageViewSearch addGestureRecognizer:tap2];
    
}

#pragma mark-----创建第二种自定义的cell
- (instancetype)createNeedCustomWithLeftLabelString:(NSString*)stringLeft leftColor:(UIColor*)leftColor leftFont:(UIFont*)leftFont rightLabelString:(NSString*)stringRight rightColor:(UIColor*)rightColor rightFont:(UIFont*)rightFont
{
    [self setupTwoLabelUIWithLeftLabelString:stringLeft leftColor:leftColor leftFont:leftFont rightLabelString:stringRight rightColor:rightColor rightFont:rightFont];
    
    return self;
}
- (void)setupTwoLabelUIWithLeftLabelString:(NSString*)stringLeft leftColor:(UIColor*)leftColor leftFont:(UIFont*)leftFont rightLabelString:(NSString*)stringRight rightColor:(UIColor*)rightColor rightFont:(UIFont*)rightFont
{
    for (int i = 0; i < 2; i++) {
        UIView* view = [self.contentView viewWithTag:kCommonRemoveTag];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    UILabel* statuLb = [[UILabel alloc] init];
    [self.contentView addSubview:statuLb];
    statuLb.tag = kCommonRemoveTag;
    statuLb.backgroundColor = [UIColor clearColor];
    @weakify(self);
    [statuLb mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(kDeviceProportion(177));
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    statuLb.textColor = leftColor;
    statuLb.font = leftFont;
    statuLb.textAlignment = NSTextAlignmentLeft;
    statuLb.text = stringLeft;
    
    UILabel* statuLbTwo = [[UILabel alloc] init];
    [self.contentView addSubview:statuLbTwo];
    statuLbTwo.tag = kCommonRemoveTag;
    [statuLbTwo mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.right.equalTo(self).offset(kDeviceProportion(-177));
        
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    statuLbTwo.backgroundColor = [UIColor clearColor];
    
    statuLbTwo.textColor = rightColor;
    statuLbTwo.font = rightFont;
    statuLbTwo.textAlignment = NSTextAlignmentRight;
    statuLbTwo.text = [GYUtils formatCurrencyStyle: stringRight.doubleValue];
}

#pragma mark-----创建第三种自定义的cell



- (void)initWithLeftImageName:(NSString*)leftImagName leftTitle:(NSString*)leftTitleStr  rightImageName:(NSString*)rightImagName rightTitle:(NSString*)rightTitleStr
{
//    if (self = [super init]) {
        //左边的图片 文字
        GYHSNewButton* buttonOne = [[GYHSNewButton alloc] initWithFrame:CGRectMake(kDeviceProportion(177), 0, kDeviceProportion(250) , kDeviceProportion(90)) normalWithImageName:leftImagName selectedWithImageName:leftImagName setTitleString:leftTitleStr normalTitleColor:kGray333333 selectedTitleColor:kGray333333];
        [self.contentView addSubview:buttonOne];
        buttonOne.tag = 0;
        [buttonOne addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        //右边的图片 文字
        GYHSNewButton* buttonTwo = [[GYHSNewButton alloc] initWithFrame:CGRectMake(kDeviceProportion(177) + kDeviceProportion(250) + kCommonDev, 0, kDeviceProportion(250) - kCommonDev, kDeviceProportion(90)) normalWithImageName:rightImagName selectedWithImageName:rightImagName setTitleString:rightTitleStr normalTitleColor:kGray333333 selectedTitleColor:kGray333333];
        [self.contentView addSubview:buttonTwo];
        buttonTwo.tag = 1;
        [buttonTwo addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        

//    }

    
//    return self;
}



#pragma mark-----创建第四种自定义的cell
- (instancetype)createNeedCustomWithDscripritionWords
{
    [self setupDesriptionWordsUI];
    return self;
}
- (void)setupDesriptionWordsUI
{
    
    UILabel* uplabel = [[UILabel alloc] init];
    [self.contentView addSubview:uplabel];
    uplabel.text = kLocalized(@"GYHS_StaffManager_Tip:");
    uplabel.textColor = kGray333333;
    uplabel.font = kFont42;
    CGSize sizelabel = [self giveLabelWith:uplabel.font nsstring:uplabel.text];
    
    CGFloat nameH = sizelabel.height;
    CGFloat nameW = sizelabel.width;
    @weakify(self);
    [uplabel mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(kDeviceProportion(177));
        
        make.width.equalTo(@(nameW + 1));
        make.height.equalTo(@(nameH));
        make.top.equalTo(self).offset(kDeviceProportion(20));
    }];
    uplabel.textAlignment = NSTextAlignmentLeft;
    uplabel.backgroundColor = [UIColor clearColor];
    
    //下面的小图标
    UIImageView* smallImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:smallImageView];
    [smallImageView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(kDeviceProportion(187));
        
        make.width.mas_equalTo(kDeviceProportion(8));
        make.height.mas_equalTo(kDeviceProportion(8));
        make.top.equalTo(uplabel.mas_bottom).offset(kDeviceProportion(15));
    }];
    smallImageView.image = [UIImage imageNamed:@"gyhs_small_tipspic_red"];
    
    //label加载一段话
    UILabel* descriptionLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descriptionLabel];
    
    descriptionLabel.text = [NSString stringWithFormat:@"%@%@%@",kLocalized(@"GYHS_StaffManager_AvailableNumberOfPoints = PointsAccountRemainder -"),globalData.config.pointSave,kLocalized(@"GYHS_StaffManager_(AtLeastOfPoints)")];
    // 宽度W
    CGFloat contentW = kDeviceProportion(472);
    // label的字体 HelveticaNeue  Courier
    UIFont* fnt = kFont42;
    descriptionLabel.font = fnt;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabel.textColor = kGray333333;
    CGSize tmpRect = [self giveLabelWith:descriptionLabel.font nsstring:descriptionLabel.text];
    
    
    
    // 高度H
    CGFloat contentH = tmpRect.height;
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(smallImageView.mas_right).offset(kDeviceProportion(10));
        
        make.width.equalTo(@(contentW ));
        make.height.equalTo(@(contentH + 1));
        make.top.equalTo(uplabel.mas_bottom).offset(kDeviceProportion(10));
    }];
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    
    //下面的第二个小图标
    UIImageView* smallImageViewdown = [[UIImageView alloc] init];
    [self.contentView addSubview:smallImageViewdown];
    [smallImageViewdown mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.equalTo(self).offset(kDeviceProportion(187));
        
        make.width.equalTo(@(8));
        make.height.equalTo(@(8));
        make.top.equalTo(smallImageView.mas_top).offset(contentH + 1 +kDeviceProportion(10));
    }];
    smallImageViewdown.image = [UIImage imageNamed:@"gyhs_small_tipspic_red"];
    
    //最下面label加载一段话
    UILabel* descriptionLabelDown = [[UILabel alloc] init];
    [self.contentView addSubview:descriptionLabelDown];
    
    descriptionLabelDown.text = kLocalized(@"GYHS_StaffManager_AtTheEndOfTheIntegralIsUsedToEnsure");
    
    // label的字体
    UIFont* fntt = kFont42;
    descriptionLabelDown.font = fntt;
    descriptionLabelDown.numberOfLines = 0;
    descriptionLabelDown.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionLabelDown.textColor = kGray333333;
    CGRect tmpRectDown = [descriptionLabelDown.text boundingRectWithSize:CGSizeMake(contentW, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:fntt, NSFontAttributeName, nil] context:nil];
    
    // 高度H
    CGFloat contentHDown = tmpRectDown.size.height;
    [descriptionLabelDown mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(smallImageViewdown.mas_right).offset(kDeviceProportion(10));
        
        make.width.equalTo(@(contentW));
        make.height.equalTo(@(contentHDown + 1));
        make.top.equalTo(descriptionLabel.mas_bottom).offset(kDeviceProportion(10));
    }];
    descriptionLabelDown.textAlignment =  NSTextAlignmentLeft;
    
    
    
}

#pragma mark-----创建第五种自定义cell
//中间一个货币转银行
-(instancetype)createNeedCustomWithMidOneButtonImageName:(NSString*)imageStr Title:(NSString*)titleStr Tag:(NSInteger)tag leftTitleColor:(UIColor*)color{
    [self setupOneButtonUIImageName:imageStr Title:titleStr Tag:tag leftTitleColor:color];
    return self;
    
}
-(void)setupOneButtonUIImageName:(NSString*)imageStr Title:(NSString*)titleStr Tag:(NSInteger)tag leftTitleColor:(UIColor*)color{
    //左边的图片 文字
    GYHSNewButton* buttonOne = [[GYHSNewButton alloc] initWithFrame:CGRectMake(kDeviceProportion(300), 0, kDeviceProportion(250) - kDeviceProportion(50), kDeviceProportion(90)) normalWithImageName:imageStr selectedWithImageName:imageStr setTitleString:titleStr normalTitleColor:color selectedTitleColor:kRedE50012];
    [self.contentView addSubview:buttonOne];
    buttonOne.tag = tag;
    [buttonOne addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark-----创建第六种自定义的cell 左边是投资回报率 右边是红色的查询明细
-(instancetype)createNeedCustomDividendYear:(NSString*)dividendYear LeftShowDetailPercentage:(NSString*)numStr numberColor:(UIColor*)numberColor rightShowColor:(UIColor*)showColor{
    [self setupOneButtonUIWithDividendYear:dividendYear LeftShowDetailPercentage:numStr numberColor:numberColor rightShowColor:showColor];
    return self;
}
-(void)setupOneButtonUIWithDividendYear:(NSString*)dividendYear LeftShowDetailPercentage:(NSString*)numStr numberColor:(UIColor*)numberColor rightShowColor:(UIColor*)showColor{
    for (int i = 0; i < 5; i++) {
        UIView* view = [self.contentView viewWithTag:kCommonRemoveTag];
        if (view) {
            [view removeFromSuperview];
        }
    }
    
    //添加左边的投资回报率
    UILabel* labelLeft = [[UILabel alloc] init];
    [self.contentView addSubview:labelLeft];
    labelLeft.tag = kCommonRemoveTag;
    labelLeft.text = [NSString stringWithFormat:@"%@%@",dividendYear,kLocalized(@"GYHS_StaffManager_Annualreturninvestment:")];
    labelLeft.font = kFont48;
    CGSize leftLabelSize = [self giveLabelWith:labelLeft.font nsstring:labelLeft.text];
    @weakify(self);
    [labelLeft mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.left.equalTo(self).offset(kDeviceProportion(40));
        make.width.equalTo(@(leftLabelSize.width + 1));
        make.height.equalTo(@(leftLabelSize.height));
        make.top.equalTo(self).offset(kDeviceProportion(25) + kNavigationHeight);
    }];
    labelLeft.textAlignment = NSTextAlignmentLeft;
    labelLeft.backgroundColor = [UIColor clearColor];
    labelLeft.textColor = kBlue0A59C2;
    //后面显示数字的
    UILabel* labelNum = [[UILabel alloc] init];
    [self.contentView addSubview:labelNum];
    labelNum.tag = kCommonRemoveTag;
    labelNum.text = numStr;
    labelNum.font = kFont48;
    CGSize numLabelSize = [self giveLabelWith:labelNum.font nsstring:labelNum.text];
    
    [labelNum mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.left.equalTo(labelLeft.mas_right).offset(kDeviceProportion(20));
        make.width.equalTo(@(numLabelSize.width + 1));
        make.height.equalTo(@(numLabelSize.height));
        make.top.equalTo(self).offset(kDeviceProportion(25) + kNavigationHeight);
    }];
    labelNum.textAlignment = NSTextAlignmentLeft;
    labelNum.backgroundColor = [UIColor clearColor];
    labelNum.textColor = numberColor;
    
    
    
    
    UIImageView* imageViewArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewArrow]; //需要先添加到父图层
    imageViewArrow.tag = kCommonRemoveTag;
    [imageViewArrow mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.right.equalTo(self).offset(kDeviceProportion(-40));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        make.top.equalTo(self).offset(kDeviceProportion(25) + kNavigationHeight);
    }];
    
    
    //放红色的小箭头
    imageViewArrow.image = [UIImage imageNamed:@"gyhs_smallarrow_red"];
    
    
    self.userInteractionEnabled = YES;
    
    //添加明显查询的文字label
    UILabel* textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:textLabel]; //需要先添加到父图层
    textLabel.tag = kCommonRemoveTag;
    textLabel.text = kLocalized(@"GYHS_StaffManager_CheckDetails");
    textLabel.font = kFont48;
    CGSize sizelabel = [self giveLabelWith:textLabel.font nsstring:textLabel.text];
    
    CGFloat nameH = sizelabel.height;
    CGFloat nameW = sizelabel.width;
    textLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doTapTwo)];
    [textLabel addGestureRecognizer:tap];
    //根据宽高 做约束
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(imageViewArrow.mas_left).offset(kDeviceProportion(-5));
        make.width.equalTo(@(nameW));
        make.height.equalTo(@(nameH));
        //make.bottom.equalTo(imageViewArrow.mas_bottom);
        make.centerY.equalTo(imageViewArrow.mas_centerY);
    }];
    textLabel.textAlignment = NSTextAlignmentRight; //设置右边对齐
    
    
    
    textLabel.textColor = showColor;
    
    
    //再添加放大镜
    UIImageView* imageViewSearch = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewSearch]; //需要先添加到父图层
    imageViewSearch.tag = kCommonRemoveTag;
    [imageViewSearch mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(textLabel.mas_left).offset(kDeviceProportion(-5));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        //make.bottom.equalTo(textLabel.mas_bottom);
        make.centerY.equalTo(textLabel.mas_centerY);
    }];
    
    
    //添加红色的搜索图标
    imageViewSearch.image = [UIImage imageNamed:@"gyhs_small_searchpic_red"];
    
    
    
    
}

#pragma mark-----另外的一个
-(instancetype)createNeedCustomShowDetailWithNoNavigationHeightFirstShowColor:(UIColor*)color{
    [self setupShowDetailUIWithNoNavigationHeightFirstShowColor:color];
    
    return self;
}
-(void)setupShowDetailUIWithNoNavigationHeightFirstShowColor:(UIColor*)color{
    UIImageView* imageViewArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewArrow]; //需要先添加到父图层
    @weakify(self);
    [imageViewArrow mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.right.equalTo(self).offset(kDeviceProportion(-40));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        make.top.equalTo(self).offset(kDeviceProportion(25));
    }];
    imageViewArrow.image = [UIImage imageNamed:@"gyhs_smallarrow_blue"];
    
    self.userInteractionEnabled = YES;
    
    //添加明显查询的文字label
    UILabel* textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:textLabel]; //需要先添加到父图层
    textLabel.text = kLocalized(@"GYHS_StaffManager_CheckDetails");
    textLabel.font = kFont48;
    CGSize sizelabel = [self giveLabelWith:textLabel.font nsstring:textLabel.text];
    
    CGFloat nameH = sizelabel.height;
    CGFloat nameW = sizelabel.width;
    textLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapThreeWithTag)];
    [textLabel addGestureRecognizer:tap];
    //根据宽高 做约束
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(imageViewArrow.mas_left).offset(kDeviceProportion(-5));
        make.width.equalTo(@(nameW));
        make.height.equalTo(@(nameH));
        make.centerY.equalTo(imageViewArrow.mas_centerY);
    }];
    textLabel.textAlignment = NSTextAlignmentRight; //设置右边对齐
    textLabel.textColor = kBlue0A59C2;
    
    
    //再添加放大镜
    UIImageView* imageViewSearch = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewSearch]; //需要先添加到父图层
    
    [imageViewSearch mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(textLabel.mas_left).offset(kDeviceProportion(-5));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        make.centerY.equalTo(textLabel.mas_centerY);
    }];
    
    
    imageViewSearch.image = [UIImage imageNamed:@"gyhs_small_searchpic_blue"];
    
    
}
#pragma mark-----复制上面的 修改tag值
-(instancetype)createNeedCustomShowDetailWithNoNavigationHeightSecondShowColor:(UIColor*)color{
    [self setupShowDetailUIWithNoNavigationHeightSecondShowColor:color];
    
    return self;
}
-(void)setupShowDetailUIWithNoNavigationHeightSecondShowColor:(UIColor*)color{
    UIImageView* imageViewArrow = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewArrow]; //需要先添加到父图层
    @weakify(self);
    [imageViewArrow mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        
        make.right.equalTo(self).offset(kDeviceProportion(-40));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        make.top.equalTo(self).offset(kDeviceProportion(25));
    }];
    
    
    imageViewArrow.image = [UIImage imageNamed:@"gyhs_smallarrow_blue"];
    
    self.userInteractionEnabled = YES;
    
    //添加明显查询的文字label
    UILabel* textLabel = [[UILabel alloc] init];
    [self.contentView addSubview:textLabel]; //需要先添加到父图层
    textLabel.text = kLocalized(@"GYHS_StaffManager_CheckDetails");
    textLabel.font = kFont48;
    CGSize sizelabel = [self giveLabelWith:textLabel.font nsstring:textLabel.text];
    
    CGFloat nameH = sizelabel.height;
    CGFloat nameW = sizelabel.width;
    textLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapFourWithTag)];
    [textLabel addGestureRecognizer:tap];
    //根据宽高 做约束
    [textLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(imageViewArrow.mas_left).offset(kDeviceProportion(-5));
        make.width.equalTo(@(nameW));
        make.height.equalTo(@(nameH));
        make.centerY.equalTo(imageViewArrow.mas_centerY);
    }];
    textLabel.textAlignment = NSTextAlignmentRight; //设置右边对齐
    
    textLabel.textColor = kBlue0A59C2;
    
    
    //再添加放大镜
    UIImageView* imageViewSearch = [[UIImageView alloc] init];
    [self.contentView addSubview:imageViewSearch]; //需要先添加到父图层
    
    [imageViewSearch mas_makeConstraints:^(MASConstraintMaker* make) {
        
        
        make.right.equalTo(textLabel.mas_left).offset(kDeviceProportion(-5));
        make.width.height.equalTo(@(kDeviceProportion(21)));
        make.centerY.equalTo(textLabel.mas_centerY);
    }];
    
    
    imageViewSearch.image = [UIImage imageNamed:@"gyhs_small_searchpic_blue"];
    
    
}




#pragma mark-----响应Button的事件
//响应Button的事件
-(void)click:(GYHSNewButton*)sender{
    
    [self.delegate rightGenaralCell:self didClickCellButtonWithTag:sender.tag];
    
}

-(void)doTapOne{
    [self.delegate rightGenaralCell:self didClickLabelWithTag:100];
}

-(void)doTapTwo{
    [self.delegate rightGenaralCell:self didClickLabelWithTag:400];
}

-(void)doTapThreeWithTag{
    [self.delegate rightGenaralCell:self didClickLabelWithTag:401];
}
-(void)doTapFourWithTag{
    [self.delegate rightGenaralCell:self didClickLabelWithTag:402];
}
/**
 *   提取一个公用的方法
 */
//给一个label的字符串 返回自适应文本宽高
-(CGSize)giveLabelWith:(UIFont* )fnt  nsstring:(NSString* )string{
    UILabel* label = [[UILabel alloc] init];
    
    label.text = string;
    
    
    return [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
}



@end
