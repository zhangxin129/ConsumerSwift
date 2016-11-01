//
//  GYHDStaffInfoViewCell.m
//  GYRestaurant
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDStaffInfoViewCell.h"
@implementation GYHDStaffInfoViewCell

- (void)awakeFromNib {

}

-(instancetype)initWithFrame:(CGRect)frame{

    if (self=[super initWithFrame:frame]) {
        
        self.titleLael=[[UILabel alloc]init];
        self.titleLael.backgroundColor=[UIColor yellowColor];
        self.titleLael.font=[UIFont systemFontOfSize:20];
        self.titleLael.textAlignment=NSTextAlignmentCenter;
        [self addSubview:self.titleLael];
        [self.titleLael mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(30);
        }];
    
        self.contentLabel=[[UILabel alloc]init];
        self.contentLabel.textAlignment=NSTextAlignmentCenter;
        self.contentLabel.font=[UIFont systemFontOfSize:20];
        [self addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLael.mas_right).offset(10);
            make.top.mas_equalTo(0);
        }];
        
    }

    return self;

}
@end
