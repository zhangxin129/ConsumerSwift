//
//  GYEasybuyEvaluationCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyEvaluationCell.h"
//#import "UIImageView+WebCache.h"
//#import "GYHESharedData.h"

@interface GYEasybuyEvaluationCell ()

@property (weak, nonatomic) IBOutlet UIImageView* headImgView;
@property (weak, nonatomic) IBOutlet UILabel* nameLabel;
@property (weak, nonatomic) IBOutlet UILabel* timeLabel;

@property (weak, nonatomic) IBOutlet UILabel* detailTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel* sizeLabel;

@end

@implementation GYEasybuyEvaluationCell

- (void)awakeFromNib
{
    // Initialization code
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.width / 2;
    
    self.headImgView.clipsToBounds = YES;
}

- (void)setModel:(GYEasybuyEvaluationModel*)model
{
    _model = model;
    _nameLabel.text = model.name;
    NSArray* arr = [model.time componentsSeparatedByString:@" "];
    _timeLabel.text = [NSString stringWithFormat:@"%@:%@", kLocalized(@"GYHE_Easybuy_time"), arr.firstObject];

    _msgLabel.text = model.content;

    _detailTimeLabel.text = model.time;
    _sizeLabel.text = model.gType;
    
    [_headImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.buyHeadPic]] placeholder:[UIImage imageNamed:@"sp_appraise.png"]];
}

@end
