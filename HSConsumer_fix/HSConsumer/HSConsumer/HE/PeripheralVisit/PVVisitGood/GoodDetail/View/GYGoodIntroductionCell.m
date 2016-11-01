//
//  GYGoodIntroductionCell.m
//  HSConsumer
//
//  Created by Apple03 on 15-5-18.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYGoodIntroductionCell.h"
#import "GYGoodIntroductionModel.h"

@interface GYGoodIntroductionCell ()
@property (nonatomic, weak) UILabel* tvDetail;
@property (nonatomic, weak) UIView* introduceBgView;
@end

@implementation GYGoodIntroductionCell

+ (instancetype)cellWithTableView:(UITableView*)tableView
{

    GYGoodIntroductionCell* cell = [tableView dequeueReusableCellWithIdentifier:strDetailIdent];
    if (cell == nil) {
        cell = [[GYGoodIntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strDetailIdent];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView * introduceBgView = [[UIView alloc]init];
        introduceBgView.backgroundColor = kIntroduceBackgroundColor;
        [self.contentView addSubview:introduceBgView];
        self.introduceBgView = introduceBgView;
        
        UILabel* tvDetail = [[UILabel alloc] init];
        tvDetail.numberOfLines = 0;
        tvDetail.backgroundColor = kIntroduceBackgroundColor;
        tvDetail.font = kDetailFont;
        [self.introduceBgView addSubview:tvDetail];
        self.tvDetail = tvDetail;
    }
    return self;
}

- (void)setModel:(GYGoodIntroductionModel*)model
{
    _model = model;

    if([self.model.strData isEqualToString:@""])
    {
        self.tvDetail.text = kLocalized(@"GYHE_SurroundVisit_GoodsNoDetailIntroduce");
    }else{
        
         self.tvDetail.text = [NSString stringWithFormat:@"%@", self.model.strData];
    }
    self.tvDetail.font = [UIFont systemFontOfSize:13];
    [self layoutSubviews];
}

- (void)layoutSubviews
{

    [super layoutSubviews];
    CGFloat height = 30;
    
    self.introduceBgView.frame = CGRectMake(0, 0, kScreenWidth, self.model.fHight > height ? (self.model.fHight + 20) : (self.model.fHight + 30));
    
    self.tvDetail.frame = CGRectMake(18, 0, kScreenWidth-30, self.model.fHight > height ? (self.model.fHight + 20) : (self.model.fHight + 30));

    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(self.tvDetail.frame));
}

@end
