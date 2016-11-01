//
//  GYHDAddFriendTableViewCell.m
//  HSConsumer
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDAddFriendTableViewCell.h"
#import "GYHDMessageCenter.h"
@interface GYHDAddFriendTableViewCell()
@property(nonatomic,strong)UIImageView *arrowView;
@end
@implementation GYHDAddFriendTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setup];
        
    }

    return self;
}

-(void)setup{

    self.iconImgView=[[UIImageView alloc]init];
    
    [self.contentView addSubview:self.iconImgView];
    
    
    self.titleLabel=[[UILabel alloc]init];
    
    self.titleLabel.font= [UIFont systemFontOfSize:20.0];
     
    [self.contentView addSubview:self.titleLabel];
     
    
    self.contentLabel=[[UILabel alloc]init];
    
    self.contentLabel.textColor=[UIColor colorWithRed:186/255.0f green:186/255.0f blue:186/255.0f alpha:1];

    self.contentLabel.font=[UIFont systemFontOfSize:14.0];
    
    [self.contentView addSubview:self.contentLabel];
    
    self.arrowView=[[UIImageView alloc]init];
    
    self.arrowView.image=[UIImage imageNamed:@"gyhd_cell_arrow_right_icon"];
    
    [self.contentView addSubview:self.arrowView];
    
    __weak __typeof(self) wself = self;
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(20);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    
    [self.iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(44);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(44);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wself.iconImgView.mas_right).offset(10);
        make.right.equalTo(wself.arrowView.mas_left).offset(-10);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(20);
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(wself.iconImgView.mas_right).offset(10);
        make.right.equalTo(wself.arrowView.mas_left).offset(-10);
        make.top.mas_equalTo(wself.titleLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(20);
        
    }];

}
@end
