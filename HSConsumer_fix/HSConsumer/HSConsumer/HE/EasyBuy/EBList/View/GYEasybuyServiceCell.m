//
//  GYEasybuyServiceCell.m
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYEasybuyServiceCell.h"

@interface GYEasybuyServiceCell ()
@property (weak, nonatomic) IBOutlet UIImageView* selectedImgView;
@property (weak, nonatomic) IBOutlet UILabel* titleLab;

@end

@implementation GYEasybuyServiceCell

- (void)awakeFromNib
{
    // Initialization code
    _selectedImgView.image = [UIImage imageNamed:@"gyhe_select_icon"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setModel:(GYEasybuySortModel*)model
{
    _model = model;

    _selectedImgView.hidden = !model.isSelected;
    _titleLab.text = model.title;
    _titleLab.textColor = model.isSelected ? [UIColor redColor] : [UIColor blackColor];
}

@end
