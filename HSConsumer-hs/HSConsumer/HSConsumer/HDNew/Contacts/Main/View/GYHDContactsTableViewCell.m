//
//  GYHDContactsTableViewCell.m
//  HSConsumer
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDContactsTableViewCell.h"
#import "GYHDMessageCenter.h"
@implementation GYHDContactsTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.iconImgView=[[UIImageView alloc]init];
        self.iconImgView.userInteractionEnabled=YES;
        UITapGestureRecognizer*tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headClick)];
        
        [self.iconImgView addGestureRecognizer:tap];
        [self.contentView addSubview:self.iconImgView];
        
        [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(10);
            make.width.mas_equalTo(44);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(44);
        }];
        
        self.nameLabel=[[UILabel alloc]init];
        
        self.nameLabel.font= [UIFont systemFontOfSize:20.0];
        
        [self.contentView addSubview:self.nameLabel];
        __weak __typeof(self) wself = self;

        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wself.iconImgView.mas_right).offset(10);
            make.right.mas_equalTo(10);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(20);
            
        }];
        
        self.contentLabel=[[UILabel alloc]init];
        
        self.contentLabel.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];
        
        self.contentLabel.font=[UIFont systemFontOfSize:14.0];
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(wself.iconImgView.mas_right).offset(10);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(wself.nameLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
            
        }];

    }
    return self;
}

-(void)refreshUIWith:(GYHDContactsListModel*)model{
    
    _model=model;

    [self.iconImgView setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:[UIImage imageNamed:@"gyhd_contants_deafultheadportrait_icon"]];
    
    self.nameLabel.text=model.name;
    
    self.contentLabel.text=model.content;

}

-(void)headClick{

    if (self.block) {
        
        self.block(self.model);
    }

}
@end
