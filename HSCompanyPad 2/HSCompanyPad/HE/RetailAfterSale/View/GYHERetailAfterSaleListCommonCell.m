//
//  GYHERetailAfterSaleListCommonCell.m
//  HSCompanyPad
//
//  Created by 吴文超 on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHERetailAfterSaleListCommonCell.h"
#import "GYHESaleAfterModel.h"

#define kTitleLabelTop kDeviceProportion(10)
#define kTitleLabelHeight kDeviceProportion(30)
#define kTitleLabelGap kDeviceProportion(10)
#define kTitleLabelLeftGap kDeviceProportion(7)
//定义一个间隔450
#define kLongGap kDeviceProportion(225)
#define kCommonTitleColor  kGray777777  //订单号 营业点等的字体颜色 kGray777777
#define kShowTitleColor  kGray333333    //自定义的数据源内容显示字体颜色
#define kLabelTextFont  kFont24
#define kLabelCustomHeight kDeviceProportion(80)

static NSString* const GYTableViewCellID = @"GYHERetailAfterSaleListCommonCell";
@implementation GYHERetailAfterSaleListCommonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    GYHERetailAfterSaleListCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:GYTableViewCellID];
    if (!cell) {
        cell = [[GYHERetailAfterSaleListCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:GYTableViewCellID];
    }
    return cell;
}




#pragma mark-----生成八个内容的表单元格
-(instancetype)createEightInformationWithOrderNumber:(NSString*)orderNumber operatingAdress:(NSString*)operatingAdress serialNumber:(NSString*)serialNumber afterSaleServiceNumber:(NSString*)serviceNumber HSNumber:(NSString*)HSNum applicationType:(NSString*)applicationType applicationTime:(NSString*)applicationTime stateType:(NSString*)stateType{
    
//先做一个view  放tabel
    UIView* view0 = [[UIView alloc] init];
    view0.backgroundColor = kGrayDBDBEA;
    view0.layer.borderWidth = 1;
    view0.layer.borderColor = kGrayE3E3EA.CGColor;
    [self.contentView addSubview:view0];
    @weakify(self);
    [view0 mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(kTitleLabelTop);
        make.height.equalTo(@(kTitleLabelHeight));
    }];

    UILabel* label1 = [[UILabel alloc] init];
    label1.textAlignment = NSTextAlignmentLeft;
    label1.backgroundColor = [UIColor clearColor];
    label1.text = @"订单号:";
    label1.textColor = kCommonTitleColor;
    label1.font = kLabelTextFont;
    CGSize Size1 = [self giveLabelWith:label1.font nsstring:label1.text];
    [view0 addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(Size1.width + 1));
        make.height.equalTo(@(Size1.height + 1));
        make.left.equalTo(view0).offset(kTitleLabelLeftGap);
        make.centerY.equalTo(view0.mas_centerY);
    }];
    
    UILabel* label2 = [[UILabel alloc] init];
    label2.textAlignment = NSTextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
    label2.text = orderNumber;
    label2.textColor = kShowTitleColor;
    label2.font = kLabelTextFont;
    CGSize Size2 = [self giveLabelWith:label2.font nsstring:label2.text];
    [view0 addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(Size2.width + 1));
        make.height.equalTo(@(Size2.height + 1));
        make.left.equalTo(label1.mas_right).offset(kTitleLabelGap);
        make.centerY.equalTo(view0.mas_centerY);
    }];
    
 //kLongGap
    UILabel* label3 = [[UILabel alloc] init];
    label3.textAlignment = NSTextAlignmentLeft;
    label3.backgroundColor = [UIColor clearColor];
    label3.text = @"营业点:";
    label3.textColor = kCommonTitleColor;
    label3.font = kLabelTextFont;
    CGSize Size3 = [self giveLabelWith:label3.font nsstring:label3.text];
    [view0 addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(Size3.width + 1));
        make.height.equalTo(@(Size3.height + 1));
        make.left.equalTo(view0).offset(kTitleLabelLeftGap + kLongGap);
        make.centerY.equalTo(view0.mas_centerY);
    }];
    
    UILabel* label4 = [[UILabel alloc] init];
    label4.textAlignment = NSTextAlignmentLeft;
    label4.backgroundColor = [UIColor clearColor];
    label4.text = operatingAdress;
    label4.textColor = kShowTitleColor;
    label4.font = kLabelTextFont;
    CGSize Size4 = [self giveLabelWith:label4.font nsstring:label4.text];
    [view0 addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(Size4.width + 1));
        make.height.equalTo(@(Size4.height + 1));
        make.left.equalTo(label3.mas_right).offset(kTitleLabelGap);
        make.centerY.equalTo(view0.mas_centerY);
    }];

 //再加6个view
//    UIView* view2 = [[UIView alloc] init];
//    view2.backgroundColor = kGrayDBDBEA;
//    view2.layer.borderWidth = 1;
//    view2.layer.borderColor = kGrayE3E3EA.CGColor;
//    [self.contentView addSubview:view2];
//    
//    [view2 mas_makeConstraints:^(MASConstraintMaker* make) {
//        @strongify(self);
//        make.left.bottom.equalTo(self);
//        make.width.equalTo(@(kTitleLabelHeight));
//        make.height.equalTo(@(kTitleLabelHeight));
//    }];
    
    //1
    UIView* firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:firstView];
    
    [firstView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.bottom.equalTo(self);
        make.width.equalTo(@(kDeviceProportion(115)));
        make.top.equalTo(view0.mas_bottom);
        //make.height.equalTo(@(kLabelCustomHeight));
    }];
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = kGrayE3E3EA.CGColor;
    
    UILabel* firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.text = serialNumber;
    firstLabel.textColor = kShowTitleColor;
    firstLabel.font = kLabelTextFont;
    CGSize firstSize = [self giveLabelWith:firstLabel.font nsstring:firstLabel.text];
    [firstView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(firstSize.width + 1));
        make.height.equalTo(@(firstSize.height + 1));
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    
    
    
    //2
    UIView* secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:secondView];
    
    [secondView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(view0.mas_bottom);
        make.left.equalTo(firstView.mas_right);
        make.width.equalTo(@(kDeviceProportion(260)));
    }];
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* secondLabel = [[UILabel alloc] init];
    [secondView addSubview:secondLabel];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text = serviceNumber;
    secondLabel.textColor = kShowTitleColor;
    secondLabel.font = kLabelTextFont;
    CGSize secondSize = [self giveLabelWith:secondLabel.font nsstring:secondLabel.text];
    
    [secondLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(secondSize.width + 1));
        make.height.equalTo(@(secondSize.height + 1));
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY);
    }];
    
    
    //3
    UIView* thirdView = [[UIView alloc] init];
    thirdView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:thirdView];
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(view0.mas_bottom);
        make.left.equalTo(secondView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* thirdLabel = [[UILabel alloc] init];
    [thirdView addSubview:thirdLabel];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.text = HSNum;
    thirdLabel.textColor = kShowTitleColor;
    thirdLabel.font = kLabelTextFont;
    CGSize thirdSize = [self giveLabelWith:thirdLabel.font nsstring:thirdLabel.text];
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(thirdSize.width + 1));
        make.height.equalTo(@(thirdSize.height + 1));
        make.centerX.mas_equalTo(thirdView.centerX );
        make.centerY.equalTo(thirdView.mas_centerY);
    }];
    
    
    
    
    //4
    UIView* fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:fourthView];
    
    [fourthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(view0.mas_bottom);
        make.left.equalTo(thirdView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    fourthView.layer.borderWidth = 1;
    fourthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fourthLabel = [[UILabel alloc] init];
    [fourthView addSubview:fourthLabel];
    fourthLabel.textAlignment = NSTextAlignmentCenter;
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.text = applicationType;
    fourthLabel.textColor = kShowTitleColor;
    fourthLabel.font = kLabelTextFont;
    CGSize fourthSize = [self giveLabelWith:fourthLabel.font nsstring:fourthLabel.text];
    
    [fourthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fourthSize.width + 1));
        make.height.equalTo(@(fourthSize.height + 1));
        make.centerX.mas_equalTo(fourthView.centerX );
        make.centerY.equalTo(fourthView.mas_centerY);
    }];
    
    
    //5
    UIView* fifthView = [[UIView alloc] init];
    fifthView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:fifthView];
    
    [fifthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(view0.mas_bottom);
        make.left.equalTo(fourthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(210)));
    }];
    fifthView.layer.borderWidth = 1;
    fifthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fifthLabel = [[UILabel alloc] init];
    [fifthView addSubview:fifthLabel];
    fifthLabel.textAlignment = NSTextAlignmentCenter;
    fifthLabel.backgroundColor = [UIColor clearColor];
    fifthLabel.text = applicationTime;
    fifthLabel.textColor = kShowTitleColor;
    fifthLabel.font = kLabelTextFont;
    CGSize fifthSize = [self giveLabelWith:fifthLabel.font nsstring:fifthLabel.text];
    
    [fifthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fifthSize.width + 1));
        make.height.equalTo(@(fifthSize.height + 1));
        make.centerX.equalTo(fifthView.mas_centerX);
        make.centerY.equalTo(fifthView.mas_centerY);
    }];
    
    
    //6
    UIView* sixthView = [[UIView alloc] init];
    sixthView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:sixthView];
    
    [sixthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(view0.mas_bottom);
        make.left.equalTo(fifthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(115.5)));
    }];
    sixthView.layer.borderWidth = 1;
    sixthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* sixthLabel = [[UILabel alloc] init];
    [sixthView addSubview:sixthLabel];
    sixthLabel.textAlignment = NSTextAlignmentCenter;
    sixthLabel.backgroundColor = [UIColor clearColor];
    sixthLabel.text = stateType;
    sixthLabel.textColor = kBlue0A59C2;
    sixthLabel.font = kFont28;
    CGSize sixthSize = [self giveLabelWith:sixthLabel.font nsstring:sixthLabel.text];
    
    [sixthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(sixthSize.width + 1));
        make.height.equalTo(@(sixthSize.height + 1));
        make.centerX.equalTo(sixthView.mas_centerX);
        make.centerY.equalTo(sixthView.mas_centerY);
    }];
    
    return self;
}

#pragma mark-----生成六个内容的表单元格
-(instancetype)createSixInformationWithserialNumber:(NSString*)serialNumber afterSaleServiceNumber:(NSString*)serviceNumber amountOfMoney:(NSString*)money accumulatedPoints:(NSString*)accumulatedPoints applicationTime:(NSString*)applicationTime stateType:(NSString*)stateType{
    
    //1
    UIView* firstView = [[UIView alloc] init];
    firstView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:firstView];
    @weakify(self);
    [firstView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.left.bottom.equalTo(self);
        make.width.equalTo(@(kDeviceProportion(115)));
        make.top.equalTo(self);
        //make.height.equalTo(@(kLabelCustomHeight));
    }];
    firstView.layer.borderWidth = 1;
    firstView.layer.borderColor = kGrayE3E3EA.CGColor;
    
    UILabel* firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.backgroundColor = [UIColor clearColor];
    firstLabel.text = serialNumber;
    firstLabel.textColor = kShowTitleColor;
    firstLabel.font = kLabelTextFont;
    CGSize firstSize = [self giveLabelWith:firstLabel.font nsstring:firstLabel.text];
    [firstView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(firstSize.width + 1));
        make.height.equalTo(@(firstSize.height + 1));
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY);
    }];
    
    
    
    //2
    UIView* secondView = [[UIView alloc] init];
    secondView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:secondView];
    
    [secondView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(firstView.mas_right);
        make.width.equalTo(@(kDeviceProportion(260)));
    }];
    secondView.layer.borderWidth = 1;
    secondView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* secondLabel = [[UILabel alloc] init];
    [secondView addSubview:secondLabel];
    secondLabel.textAlignment = NSTextAlignmentCenter;
    secondLabel.backgroundColor = [UIColor clearColor];
    secondLabel.text = serviceNumber;
    secondLabel.textColor = kShowTitleColor;
    secondLabel.font = kLabelTextFont;
    CGSize secondSize = [self giveLabelWith:secondLabel.font nsstring:secondLabel.text];
    
    [secondLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(secondSize.width + 1));
        make.height.equalTo(@(secondSize.height + 1));
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY);
    }];
    
    
    //3
    UIView* thirdView = [[UIView alloc] init];
    thirdView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:thirdView];
    
    [thirdView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(secondView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    thirdView.layer.borderWidth = 1;
    thirdView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* thirdLabel = [[UILabel alloc] init];
    [thirdView addSubview:thirdLabel];
    thirdLabel.textAlignment = NSTextAlignmentCenter;
    thirdLabel.backgroundColor = [UIColor clearColor];
    thirdLabel.text = money;
    thirdLabel.textColor = kShowTitleColor;
    thirdLabel.font = kLabelTextFont;
    CGSize thirdSize = [self giveLabelWith:thirdLabel.font nsstring:thirdLabel.text];
    
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(thirdSize.width + 1));
        make.height.equalTo(@(thirdSize.height + 1));
        make.centerX.mas_equalTo(thirdView.centerX );
        make.centerY.equalTo(thirdView.mas_centerY);
    }];
    
    
    
    
    //4
    UIView* fourthView = [[UIView alloc] init];
    fourthView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:fourthView];
    
    [fourthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(thirdView.mas_right);
        make.width.equalTo(@(kDeviceProportion(150)));
    }];
    fourthView.layer.borderWidth = 1;
    fourthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fourthLabel = [[UILabel alloc] init];
    [fourthView addSubview:fourthLabel];
    fourthLabel.textAlignment = NSTextAlignmentCenter;
    fourthLabel.backgroundColor = [UIColor clearColor];
    fourthLabel.text = accumulatedPoints;
    fourthLabel.textColor = kShowTitleColor;
    fourthLabel.font = kLabelTextFont;
    CGSize fourthSize = [self giveLabelWith:fourthLabel.font nsstring:fourthLabel.text];
    
    [fourthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fourthSize.width + 1));
        make.height.equalTo(@(fourthSize.height + 1));
        make.centerX.mas_equalTo(fourthView.centerX );
        make.centerY.equalTo(fourthView.mas_centerY);
    }];
    
    
    //5
    UIView* fifthView = [[UIView alloc] init];
    fifthView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:fifthView];
    
    [fifthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(fourthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(210)));
    }];
    fifthView.layer.borderWidth = 1;
    fifthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* fifthLabel = [[UILabel alloc] init];
    [fifthView addSubview:fifthLabel];
    fifthLabel.textAlignment = NSTextAlignmentCenter;
    fifthLabel.backgroundColor = [UIColor clearColor];
    fifthLabel.text = applicationTime;
    fifthLabel.textColor = kShowTitleColor;
    fifthLabel.font = kLabelTextFont;
    CGSize fifthSize = [self giveLabelWith:fifthLabel.font nsstring:fifthLabel.text];
    
    [fifthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(fifthSize.width + 1));
        make.height.equalTo(@(fifthSize.height + 1));
        make.centerX.equalTo(fifthView.mas_centerX);
        make.centerY.equalTo(fifthView.mas_centerY);
    }];
    
    
    //6
    UIView* sixthView = [[UIView alloc] init];
    sixthView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:sixthView];
    
    [sixthView mas_makeConstraints:^(MASConstraintMaker* make) {
        @strongify(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
        make.left.equalTo(fifthView.mas_right);
        make.width.equalTo(@(kDeviceProportion(115.5)));
    }];
    sixthView.layer.borderWidth = 1;
    sixthView.layer.borderColor = kGrayE3E3EA.CGColor;
    UILabel* sixthLabel = [[UILabel alloc] init];
    [sixthView addSubview:sixthLabel];
    sixthLabel.textAlignment = NSTextAlignmentCenter;
    sixthLabel.backgroundColor = [UIColor clearColor];
    sixthLabel.text = stateType;
    sixthLabel.textColor = kBlue0A59C2;
    sixthLabel.font = kFont28;
    CGSize sixthSize = [self giveLabelWith:sixthLabel.font nsstring:sixthLabel.text];
    sixthLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(transReturnModel:)];
    [sixthLabel addGestureRecognizer:tap];
    [sixthLabel mas_makeConstraints:^(MASConstraintMaker* make) {
        
        make.width.equalTo(@(sixthSize.width + 1));
        make.height.equalTo(@(sixthSize.height + 1));
        make.centerX.equalTo(sixthView.mas_centerX);
        make.centerY.equalTo(sixthView.mas_centerY);
    }];

    return self;
}

-(void)setModel:(GYHESaleAfterModel *)model{
    _model = model;
}
- (void)transReturnModel:(UITapGestureRecognizer *)tap{
    if ([self.delegate respondsToSelector:@selector(transReturnModel:)]) {
        [self.delegate transReturnModel:_model];
    }
}

- (CGSize)giveLabelWith:(UIFont*)fnt nsstring:(NSString*)string
{
    UILabel* label = [[UILabel alloc] init];
    
    label.text = string;
    
    
    return [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
}

@end
