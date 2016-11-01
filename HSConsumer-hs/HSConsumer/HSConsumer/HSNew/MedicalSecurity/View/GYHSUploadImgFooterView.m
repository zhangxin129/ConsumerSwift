//
//  GYHSUploadImgFooterView.m
//  HSConsumer
//
//  Created by lizp on 2016/10/18.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSUploadImgFooterView.h"
#import "YYKit.h"
#import "GYHSTools.h"

@interface GYHSUploadImgFooterView()





@end

@implementation GYHSUploadImgFooterView

-(instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self ;
}

-(void)setUp {
    
    CGFloat leftEdge = 15;
    CGFloat topEdge = 10;
    CGFloat textHeight = 15;
    UIFont *font =kUploadImgFooterFont;
    UIColor *color = [UIColor lightGrayColor];

    self.applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.applyBtn.frame = CGRectMake(leftEdge, 16, kScreenWidth - 2*leftEdge, 41);
    [self.applyBtn setBackgroundImage:[UIImage imageNamed:@"gyhs_nextbtn"] forState:UIControlStateNormal];
    self.applyBtn.layer.cornerRadius = 20.5;
    self.applyBtn.clipsToBounds = YES;
    [self.applyBtn setTitle:kLocalized(@"GYHS_BP_Now_Apply") forState:UIControlStateNormal];
    [self addSubview:self.applyBtn];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftEdge, self.applyBtn.bottom + 16, kScreenWidth - 2*leftEdge, textHeight)];
    tipLabel.text = kLocalized(@"资料附件上传说明:");
    tipLabel.font = font;
    tipLabel.textColor = color;
    [self addSubview:tipLabel];

    
    UIView *round1 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, tipLabel.bottom  + topEdge + (textHeight - 7)/2, 7, 7)];
    round1.layer.cornerRadius = 3.5;
    round1.clipsToBounds = YES;
    round1.backgroundColor  = [UIColor redColor];
    [self addSubview:round1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:kLocalized(@"标注红色*的为必填选项;")];
    text.color = color;
    text.font = font;
    [text setColor:[UIColor redColor] range:NSMakeRange(4, 1)];

    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(round1.right + 5, tipLabel.bottom + topEdge, kScreenWidth - round1.right - 5 -leftEdge, textHeight)];
    label1.numberOfLines = 0;
    label1.font = font;
    label1.attributedText = text;
    [self addSubview:label1];
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth - round1.right - 5 -leftEdge, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize size = rect.size;
    label1.frame = CGRectMake(label1.origin.x, label1.origin.y, size.width, size.height);
    
    UIView *round2 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, label1.bottom  + topEdge + (textHeight - 7)/2, 7, 7)];
    round2.layer.cornerRadius = 3.5;
    round2.clipsToBounds = YES;
    round2.backgroundColor  = [UIColor redColor];
    [self addSubview:round2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(round2.right + 5, label1.bottom + topEdge, kScreenWidth - round2.right - 5 -leftEdge, textHeight)];
    label2.font = font;
    label2.numberOfLines = 0;
    label2.text = kLocalized(@"资料附件图片要求必须是清晰,仅jpg、png、jpeg、bmp格式图片而且不能超过2M;");
    label2.textColor = color;
    [self addSubview:label2];
    
    size = [GYUtils sizeForString:label2.text  font:font width:kScreenWidth - round2.right - 5 -leftEdge];
    label2.frame = CGRectMake(label2.origin.x, label2.origin.y, size.width, size.height);
    
    UIView *round3 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, label2.bottom  + topEdge + (textHeight - 7)/2, 7, 7)];
    round3.layer.cornerRadius = 3.5;
    round3.clipsToBounds = YES;
    round3.backgroundColor  = [UIColor redColor];
    [self addSubview:round3];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(round3.right + 5, label2.bottom + topEdge, kScreenWidth - round3.right - 5 -leftEdge, textHeight)];
    label3.font = font;
    label3.numberOfLines = 0;
    label3.text = kLocalized(@"住院病历须加盖医疗机构公章;须到医院病案室复印;入院记录、医嘱单、手术记录、出院记录及相关检验报告单;");
    label3.textColor = color;
    [self addSubview:label3];
    
    size = [GYUtils sizeForString:label3.text  font:font width:kScreenWidth - round3.right - 5 -leftEdge];
    label3.frame = CGRectMake(label3.origin.x, label3.origin.y, size.width, size.height);
    
    
    UIView *round4 = [[UIView alloc] initWithFrame:CGRectMake(leftEdge, label3.bottom  + topEdge + (textHeight - 7)/2, 7, 7)];
    round4.layer.cornerRadius = 3.5;
    round4.clipsToBounds = YES;
    round4.backgroundColor  = [UIColor redColor];
    [self addSubview:round4];
    
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(round3.right + 5, label3.bottom + topEdge, kScreenWidth - round4.right - 5 -leftEdge, textHeight)];
    label4.font = font;
    label4.numberOfLines = 0;
    label4.text = kLocalized(@"急诊住院须出具医院急诊证明,门诊医疗不属于互生免费医疗补贴计划。");
    label4.textColor = color;
    [self addSubview:label4];
    
    size = [GYUtils sizeForString:label4.text  font:font width:kScreenWidth - round3.right - 5 -leftEdge];
    label4.frame = CGRectMake(label4.origin.x, label4.origin.y, size.width, size.height);
        
}


@end
