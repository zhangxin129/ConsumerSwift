//
//  GYHDPushSetCell.m
//  company
//
//  Created by User on 16/7/5.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDPushSetCell.h"

@implementation GYHDPushSetCell

- (void)awakeFromNib {
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{


    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setUp];
        
    }
    return self;
}

-(void)setUp{

    kWEAKSELF;
    
    _nameLabel=[[UILabel alloc]init];
    
    _nameLabel.font=[UIFont systemFontOfSize:20.0];
    
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(80);
        
        make.left.mas_equalTo(20);
        
        make.centerY.equalTo(weakSelf);
    }];
    
    
    _switchView =[[GYHDSwitch alloc]init];
    _switchView.on=YES;
    _switchView.onTintColor =[UIColor colorWithRed:0 green:145/255.0 blue:215/255.0 alpha:1];
    
    [self.contentView addSubview:_switchView];
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(weakSelf).offset(-24);
        make.centerY.equalTo(weakSelf);
        make.width.mas_equalTo(100);
        
    }];
    
    _contentLabel=[[UILabel alloc]init];
    
    _contentLabel.font=[UIFont systemFontOfSize:20.0];
    
    [self.contentView addSubview:_contentLabel];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(weakSelf);
        make.left.mas_equalTo(weakSelf.nameLabel.mas_right).offset(10);
        make.right.mas_equalTo(weakSelf.switchView.mas_left).offset(-10);
        
    }];

}
@end
