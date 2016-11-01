//
//  GYBaseControlCell.m
//  GYBaseController
//
//  Created by kuser on 16/9/8.
//  Copyright © 2016年 hsxt. All rights reserved.
//

#import "GYBaseControlCell.h"

@interface GYBaseControlCell()


@end

@implementation GYBaseControlCell

- (void)awakeFromNib {
    // Initialization code
   
    [self.inputArrowBtn setBackgroundImage:[UIImage imageNamed:@"gy_hd_red_up_arrow"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
    
}

@end
