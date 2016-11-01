//
//  GYHSConsumeListCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSConsumeListCell.h"
#import "GYHSPointCheckModel.h"
#import "GYHSPublicMethod.h"
#define kLeftWidth kDeviceProportion(10)
#define kLineHeight kDeviceProportion(1)
@interface GYHSConsumeListCell ()
@property (weak, nonatomic) IBOutlet UILabel* transTime;
@property (weak, nonatomic) IBOutlet UILabel* hsPerNo;
@property (weak, nonatomic) IBOutlet UILabel* realAmount;
@property (weak, nonatomic) IBOutlet UILabel* pointLabel;
@property (weak, nonatomic) IBOutlet UILabel* cashLabel;
@property (weak, nonatomic) IBOutlet UILabel* remarkLabel;
@end
@implementation GYHSConsumeListCell


- (void)setModel:(GYHSPointCheckModel*)model
{
    _model = model;
    self.transTime.text = [model.sourceTransDate substringToIndex:10];
    self.hsPerNo.text = [GYUtils formatCardNo:model.perResNo];
    self.realAmount.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
    switch (model.checkType) {
    case kPointCheckPoint:
        self.pointLabel.text = [GYHSPublicMethod keepPointDecimal:model.pointRate];
        self.cashLabel.text = [GYHSPublicMethod keepTwoDecimal:model.perPoint];
//        self.remarkLabel.text = [GYHSPublicMethod transWithChannelType:model.channelType];
       self.remarkLabel.text = model.remark;
        break;
    case kPointCheckCancel:
        self.pointLabel.text = [GYHSPublicMethod keepTwoDecimal:model.perPoint];
        self.cashLabel.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
        self.remarkLabel.text = [GYHSPublicMethod keepTwoDecimal:model.entPoint];
        break;
    case kPointCheckReturn:
        self.pointLabel.text = [GYHSPublicMethod keepTwoDecimal:model.perPoint];
        self.cashLabel.text = [GYHSPublicMethod keepTwoDecimal:model.transAmount];
        self.remarkLabel.text = [GYHSPublicMethod keepTwoDecimal:model.entPoint];
        break;
        
    default:
        break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 添加分割线
- (UIView*)bindingWithView:(UIView*)view frame:(CGRect)frame
{
    UIView* vPass = [[UIView alloc] initWithFrame:frame];
    vPass.backgroundColor = [UIColor whiteColor];
    for (NSInteger i = 0; i < frame.size.width; i += 2) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(i, frame.size.height / 2, 1, 1)];
        v.backgroundColor = [UIColor grayColor];
        [vPass addSubview:v];
    }
    [view addSubview:vPass];
    
    return vPass;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    UIView* lineView = [self bindingWithView:self frame:CGRectMake(kLeftWidth, self.height - kLineHeight, self.width - 2 * kLeftWidth, kLineHeight)];
    [self addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker* make) {
        make.left.equalTo(self).offset(kLeftWidth);
        make.right.equalTo(self).offset(-kLeftWidth);
        make.bottom.equalTo(self).offset(-kLineHeight);
        make.height.mas_equalTo(kLineHeight);
    }];
}

@end
