//
//  GYHDContactsHeadCell.m
//  HSConsumer
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDContactsHeadCell.h"
#import "GYHDMessageCenter.h"
@implementation GYHDContactsHeadCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImgView=[[UIImageView alloc]init];
        
        [self.contentView addSubview:self.iconImgView];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(32);
            make.centerY.equalTo(self.contentView);
            make.height.mas_equalTo(32);
        }];
        
        self.titleLabel=[[UILabel alloc]init];
        
        self.titleLabel.font= [UIFont systemFontOfSize:20.0];
        
        [self.contentView addSubview:self.titleLabel];
        __weak __typeof(self) wself = self;
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.iconImgView.mas_right).offset(15);
            make.right.mas_equalTo(10);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

@end
