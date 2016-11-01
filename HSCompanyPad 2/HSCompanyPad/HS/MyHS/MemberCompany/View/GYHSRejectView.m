//
//  GYHSRejectView.m
//
//  Created by apple on 16/8/10.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSRejectView.h"
#import "GYHSEdgeLabel.h"
#define kEdgeSets UIEdgeInsetsMake(8, 8, 8, 8)
#define kLeftWidth 329
#define kBorderColor [UIColor colorWithRed:200 / 255.0f green:200 / 255.0f blue:200 / 255.0f alpha:1]

@interface GYHSRejectView ()
@property (nonatomic, weak) GYHSEdgeLabel* finalLab;
@property (nonatomic, weak) UITextView* suggestView;
@property (nonatomic, weak) GYHSEdgeLabel* opinionLab;
@property (nonatomic, weak) GYHSEdgeLabel* dateLab;
@property (nonatomic, weak) GYHSEdgeLabel* timeLab;

@end
@implementation GYHSRejectView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

#pragma mark - setUI
- (void)setUI
{
    //审批结果
    GYHSEdgeLabel* finalLab = [[GYHSEdgeLabel alloc] initWithFrame:CGRectMake(kLeftWidth, 75, 100, 30)];
    finalLab.edgeInsets = kEdgeSets;
    finalLab.backgroundColor = kGrayF7F7F7;
    finalLab.textColor = kGray666666;
    finalLab.font = kFont32;
    finalLab.layer.borderWidth = 1;
    finalLab.layer.borderColor = kBorderColor.CGColor;
    [self addSubview:finalLab];
    self.finalLab = finalLab;
    
    GYHSEdgeLabel* label = [[GYHSEdgeLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(finalLab.frame) - 100 - 20, CGRectGetMinY(finalLab.frame), 100, 30)];
    label.edgeInsets = kEdgeSets;
    label.text = kLocalized(@"GYHS_Myhs_Apply_Result_Colon");
    label.font = kFont32;
    label.textAlignment = NSTextAlignmentRight;
    [self addSubview:label];
    
    //审批意见
    UITextView* suggestView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMinX(finalLab.frame), CGRectGetMaxY(finalLab.frame) + 25, 450, 120)];
    suggestView.userInteractionEnabled = NO;
    suggestView.backgroundColor = kGrayF7F7F7;
    suggestView.textColor = kGray666666;
    suggestView.font = kFont32;
    suggestView.layer.borderWidth = 1;
    suggestView.layer.borderColor = kBorderColor.CGColor;
    [self addSubview:suggestView];
    self.suggestView = suggestView;
    
    GYHSEdgeLabel* opinionLab = [[GYHSEdgeLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(suggestView.frame) - 100 - 20, CGRectGetMinY(suggestView.frame), 100, 30)];
    opinionLab.edgeInsets = kEdgeSets;
    opinionLab.text = kLocalized(@"GYHS_Myhs_Apply_Opinion_Colon");
    opinionLab.font = kFont32;
    opinionLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:opinionLab];
    self.opinionLab = opinionLab;
    
    //审批日期
    GYHSEdgeLabel* dateLab = [[GYHSEdgeLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(finalLab.frame),CGRectGetMaxY(suggestView.frame) + 25, 100, 30)];
    dateLab.edgeInsets = kEdgeSets;
    dateLab.backgroundColor = kGrayF7F7F7;
    dateLab.textColor = kGray666666;
    dateLab.font = kFont32;
    dateLab.layer.borderWidth = 1;
    dateLab.layer.borderColor = kBorderColor.CGColor;
    [self addSubview:dateLab];
    self.dateLab = dateLab;
    
    GYHSEdgeLabel* timeLab = [[GYHSEdgeLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(dateLab.frame) - 100 - 20, CGRectGetMinY(dateLab.frame), 100, 30)];
    timeLab.edgeInsets = kEdgeSets;
    timeLab.text = kLocalized(@"GYHS_Myhs_Apply_Time_Colon");
    timeLab.font = kFont32;
    timeLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:timeLab];
    self.timeLab = timeLab;
}

#pragma mark - setter
- (void)setRejectStr:(NSString*)rejectStr
{
    _rejectStr = rejectStr;
    self.finalLab.text = rejectStr;
    CGSize suggestSize = [self.finalLab.text boundingRectWithSize:CGSizeMake(self.finalLab.width + 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    self.finalLab.size = suggestSize;
    [self.finalLab sizeToFit];
    self.suggestView.y = CGRectGetMaxY(self.finalLab.frame) + 25;
    self.opinionLab.y = CGRectGetMinY(self.suggestView.frame);
}

- (void)setOpinionStr:(NSString*)opinionStr
{
    _opinionStr = opinionStr;
    self.suggestView.text = opinionStr;
    CGSize suggestSize = [self.suggestView.text boundingRectWithSize:CGSizeMake(self.suggestView.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    if (suggestSize.height > 120) {
        self.suggestView.height = suggestSize.height + 30;
    }
    self.dateLab.y = CGRectGetMaxY(self.suggestView.frame) + 25;
    self.timeLab.y = CGRectGetMinY(self.dateLab.frame);
}

- (void)setTimeStr:(NSString *)timeStr
{
    _timeStr = timeStr;
    self.dateLab.text = timeStr;
    CGSize suggestSize = [self.dateLab.text boundingRectWithSize:CGSizeMake(self.dateLab.width + 16, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:kFont32, NSFontAttributeName, nil] context:nil].size;
    self.dateLab.size = suggestSize;
    [self.dateLab sizeToFit];

}
@end
