//
//  GYHDChatHeadView.m
//  GYRestaurant
//
//  Created by apple on 16/6/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDChatHeadView.h"

@implementation GYHDChatHeadView
/*
 @property(nonatomic,strong)UIImageView*iconImg;//商品图片
 @property(nonatomic,strong)UILabel*nameLabel;//商品名
 @property(nonatomic,strong)UILabel*descripLabel;//商品描述
 @property(nonatomic,strong)UIImageView*hsiconImg;//互生币图标
 @property(nonatomic,strong)UILabel*hsCoinLabel;//互生币
 @property(nonatomic,strong)UIImageView*integrateImg;//积分图标
 @property(nonatomic,strong)UILabel*integrateLabel;//积分
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _iconImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 80, 80)];
        
        [self addSubview:_iconImg];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImg.frame)+15, _iconImg.frame.origin.y, kScreenWidth-350-CGRectGetMaxX(_iconImg.frame)-30, 20)];
        
        _nameLabel.font=[UIFont systemFontOfSize:20.0];
        
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        
        [self addSubview:_nameLabel];
        
        _descripLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+10,kScreenWidth-350-CGRectGetMaxX(_iconImg.frame)-30, 20)];
        
        _descripLabel.textAlignment=NSTextAlignmentLeft;
        
        _descripLabel.font=[UIFont systemFontOfSize:16.0];
        
        [self addSubview:_descripLabel];
        
        
        _hsiconImg=[[UIImageView alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_descripLabel.frame)+12, 30, 30)];
        
        _hsiconImg.image=[UIImage imageNamed:@"icon-hsb"];
        
        [self addSubview:_hsiconImg];
        
        _hsCoinLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_hsiconImg.frame)+10, _hsiconImg.frame.origin.y+2,80, 20)];
        
        _hsCoinLabel.textColor=[UIColor redColor];
        
        _hsCoinLabel.font=[UIFont systemFontOfSize:18.0];
        
        [self addSubview:_hsCoinLabel];
        
        _integrateImg=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_hsCoinLabel.frame)+15, _hsCoinLabel.frame.origin.y-1, 30, 25)];
        
        _integrateImg.image=[UIImage imageNamed:@"icon-pv"];
        
        [self addSubview:_integrateImg];
        
        _integrateLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_integrateImg.frame)+10, _hsCoinLabel.frame.origin.y, 100, 20)];
        
        _integrateLabel.textColor=[UIColor colorWithRed:0 green:143/255.0 blue:215.0/255.0 alpha:1.0];
        _integrateLabel.font=[UIFont systemFontOfSize:18.0];
        
        [self addSubview:_integrateLabel];
        
        
    }
    return self;
}

-(void)setChatShopModel:(GYHDNewChatModel *)chatShopModel{

    _chatShopModel=chatShopModel;
    
     [self.iconImg setImageWithURL:[NSURL URLWithString:chatShopModel.iconUrl] placeholder:[UIImage imageNamed:@"ep_placeholder_image_type1"] options:kNilOptions completion:nil];
    
    _nameLabel.text=@"商品名字段显示";
    _descripLabel.text=@"商品描述字段显示";
    
    _hsCoinLabel.text=@"6299.00";
    
    _integrateLabel.text=@"60.00";
    
    
}

@end
