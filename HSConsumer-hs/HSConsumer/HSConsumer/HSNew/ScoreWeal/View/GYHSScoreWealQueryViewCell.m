//
//  GYHSScoreWealQueryViewCell.m
//  HSConsumer
//
//  Created by lizp on 16/9/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSScoreWealQueryViewCell.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSScoreWealQueryViewCell()

@property (nonatomic,strong) UILabel *appleOrder;
@property (nonatomic,strong) UILabel *appleTime;
@property (nonatomic,strong) UILabel *wealType;
@property (nonatomic,strong) UILabel *result;
@property (nonatomic,strong) UILabel *account;
@property (nonatomic,strong) UILabel *appleOrderValue;
@property (nonatomic,strong) UILabel *appleTimeValue;
@property (nonatomic,strong) UILabel *wealTypeValue;
@property (nonatomic,strong) UILabel *resultValue;
@property (nonatomic,strong) UILabel *accountValue;
@property (nonatomic,strong) UIButton *detailBtn;
@property (nonatomic,assign) CGRect rect;

@end

@implementation GYHSScoreWealQueryViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

 

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        self.rect = frame;
        [self setUp];
    }
    return self;
}

-(void)setUp {
    
    UIColor *titleColor = UIColorFromRGB(0x666666);
    UIFont *titleFont = kScoreWealQueryViewCellFont;

    self.appleOrder = [[UILabel alloc] init];
    self.appleOrder.textAlignment = NSTextAlignmentLeft;
    self.appleOrder.textColor = titleColor;
    self.appleOrder.font = titleFont;
    [self addSubview:self.appleOrder];
    self.appleOrder.text = kLocalized(@"GYHS_Weal_ApplicationNo");
    
    self.appleTime = [[UILabel alloc] init];
    self.appleTime.textAlignment = NSTextAlignmentLeft;
    self.appleTime.textColor = titleColor;
    self.appleTime.font = titleFont;
    [self addSubview:self.appleTime];
    self.appleTime.text = kLocalized(@"GYHS_Weal_ApplyTime");
    
    self.wealType = [[UILabel alloc] init];
    self.wealType.textAlignment = NSTextAlignmentLeft;
    self.wealType.textColor = titleColor;
    self.wealType.font = titleFont;
    [self addSubview:self.wealType];
    self.wealType.text = kLocalized(@"GYHS_Weal_WelfareCategory");
    
    self.result = [[UILabel alloc] init];
    self.result.textAlignment = NSTextAlignmentLeft;
    self.result.textColor = titleColor;
    self.result.font = titleFont;
    [self addSubview:self.result];
    self.result.text = kLocalized(@"GYHS_Weal_ReviewResults");
    
    self.account = [[UILabel alloc] init];
    self.account.textAlignment = NSTextAlignmentLeft;
    self.account.textColor = titleColor;
    self.account.font = titleFont;
    [self addSubview:self.account];
    self.account.text = kLocalized(@"GYHS_Weal_ApprovalAmount");
    
    
    UIColor *valueColor = UIColorFromRGB(0x333333);
    UIFont *valueFont = kScoreWealQueryViewCellFont;
    
    self.appleOrderValue = [[UILabel alloc] init];
    self.appleOrderValue.textAlignment = NSTextAlignmentRight ;
    self.appleOrderValue.textColor = valueColor;
    self.appleOrderValue.font = valueFont;
    [self  addSubview:self.appleOrderValue];
    
    self.appleTimeValue = [[UILabel alloc] init];
    self.appleTimeValue.textAlignment = NSTextAlignmentRight ;
    self.appleTimeValue.textColor = valueColor;
    self.appleTimeValue.font = valueFont;
    [self  addSubview:self.appleTimeValue];
    
    self.appleOrderValue = [[UILabel alloc] init];
    self.appleOrderValue.textAlignment = NSTextAlignmentRight ;
    self.appleOrderValue.textColor = valueColor;
    self.appleOrderValue.font = valueFont;
    [self  addSubview:self.appleOrderValue];
    
    self.wealTypeValue = [[UILabel alloc] init];
    self.wealTypeValue.textAlignment = NSTextAlignmentRight ;
    self.wealTypeValue.textColor = valueColor;
    self.wealTypeValue.font = valueFont;
    [self  addSubview:self.wealTypeValue];
    
    self.resultValue = [[UILabel alloc] init];
    self.resultValue.textAlignment = NSTextAlignmentRight ;
    self.resultValue.textColor = valueColor;
    self.resultValue.font = valueFont;
    [self  addSubview:self.resultValue];
    
    self.accountValue = [[UILabel alloc] init];
    self.accountValue.textAlignment = NSTextAlignmentRight ;
    self.accountValue.textColor = valueColor;
    self.accountValue.font = valueFont;
    [self  addSubview:self.accountValue];
    
    self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.detailBtn.userInteractionEnabled = NO;
    self.detailBtn.backgroundColor   = [UIColor clearColor];
    [self.detailBtn setTitle:kLocalized(@"GYHS_Weal_CheckDetails") forState:UIControlStateNormal];
    [self.detailBtn setTitleColor:UIColorFromRGB(0x1d7dd6) forState:UIControlStateNormal];
    self.detailBtn.titleLabel.font =  kScoreWealQueryViewCellFont;
    self.detailBtn.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:self.detailBtn];
    
    self.layer.borderColor = UIColorFromRGB(0xebebeb).CGColor;
    self.layer.borderWidth = 0.5;
    
    [self settingFrame];
}

-(void)settingFrame {

    CGFloat leftEdge = 15;
    CGFloat topEdge = 10;
    CGFloat rightEdge = 15;
    CGFloat textHeight  = 11;
    CGFloat leftWidth = 120;
    CGFloat cellWidth = self.rect.size.width;
    self.appleOrder.frame = CGRectMake(leftEdge, topEdge, leftWidth -leftEdge, textHeight);
    self.appleTime.frame = CGRectMake(leftEdge, self.appleOrder.bottom + topEdge, leftWidth -leftEdge, textHeight);
    self.wealType.frame = CGRectMake(leftEdge, self.appleTime.bottom +topEdge, leftWidth -leftEdge, textHeight);
    self.result.frame = CGRectMake(leftEdge, self.wealType.bottom +topEdge, leftWidth -leftEdge, textHeight     );
    self.account.frame = CGRectMake(leftEdge, self.result.bottom +topEdge, leftWidth -leftEdge, textHeight);
    
    self.appleOrderValue.frame = CGRectMake(leftWidth, topEdge, cellWidth -leftWidth -rightEdge, textHeight);
    self.appleTimeValue.frame = CGRectMake(leftWidth, self.appleOrderValue.bottom +topEdge, cellWidth - leftWidth -rightEdge, textHeight);
    self.wealTypeValue.frame = CGRectMake(leftWidth, self.appleTimeValue.bottom + topEdge, cellWidth - leftWidth -rightEdge, textHeight);
    self.resultValue.frame = CGRectMake(leftWidth, self.wealTypeValue.bottom +topEdge, cellWidth -leftWidth - rightEdge, textHeight);
    self.accountValue.frame = CGRectMake(leftWidth , self.resultValue.bottom +topEdge  ,cellWidth -leftWidth -rightEdge ,textHeight);
    
    self.detailBtn.frame = CGRectMake(cellWidth/2 -30, self.account.bottom + 15, 60, textHeight);
}

-(void)refreshOrder:(NSString *)order time:(NSString *)time type:(NSString *)type result:(NSString *)result account:(NSString *)account {

    self.appleOrderValue.text = order;
    self.appleTimeValue.text = time;
    self.wealTypeValue.text = type;
    self.resultValue.text = result;
    self.accountValue.text = [GYUtils formatCurrencyStyle:[account doubleValue]];
    
}

@end
