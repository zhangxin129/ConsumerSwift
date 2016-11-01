//
//  QMMapCell.m
//  萌约
//
//  Created by QiMENG on 1/13/15.
//  Copyright (c) 2015 LongVisionMedia. All rights reserved.
//

#import "GYHDMapCell.h"

@implementation GYHDMapCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        
        UIImageView*imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        imgView.image=[UIImage imageNamed:@"gyhd_msg_location_select"];
        
        self.accessoryView = imgView;

    }else {
        
        self.accessoryView = nil;
    }
    

}

@end
