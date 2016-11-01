//
//  GYHDSearchMessageListCell.m
//  GYRestaurant
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchMessageListCell.h"

@implementation GYHDSearchMessageListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-465, 20)];
        
        bgView.backgroundColor=kDefaultVCBackgroundColor;
        
        [self.contentView addSubview:bgView];
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 30, 46, 46)];
        
        [self.contentView addSubview:_iconImage];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-465-240, 34, 200, 15)];
        
        _timeLabel.textAlignment=NSTextAlignmentRight;
        
        _timeLabel.font=[UIFont systemFontOfSize:16.0];
        _timeLabel.textColor = [UIColor colorWithHex:0x999999];
        [self.contentView addSubview:_timeLabel];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame)+10, 32, kScreenWidth-465-CGRectGetMaxX(_iconImage.frame)-10-240, 20)];
        _nameLabel.textColor = [UIColor colorWithHex:0x333333];
        _nameLabel.font=[UIFont systemFontOfSize:16.0];
        
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_nameLabel];
        
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+5, _nameLabel.frame.size.width, 20)];
        
        _contentLabel.numberOfLines=0;
        
        _contentLabel.font=[UIFont systemFontOfSize:14.0];
        
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        _contentLabel.textColor = [UIColor colorWithHex:0x999999];
        [self.contentView addSubview:_contentLabel];
        
        self.pushImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gyhd_message_push_icon"]];
        [self.contentView addSubview:self.pushImageView];
        
        @weakify(self);
        [self.pushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.centerY.equalTo(self.timeLabel);
            make.left.equalTo(self.timeLabel.mas_right).offset(12);
        }];
        
        self.cardholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.cardholderButton];
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.iconImage).offset(2);
            make.left.equalTo(self.iconImage.mas_right).offset(10);
            make.height.mas_equalTo(20);
        }];
        
        [self.cardholderButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.left.equalTo(self.nameLabel.mas_right).offset(5);
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.right.lessThanOrEqualTo(self.timeLabel.mas_left).offset(-10);
        }];

    }
    
    return self;
}
-(void)refreshWithGYHDSearchCompanyMessageModel:(GYHDSearchCompanyMessageModel *)model{
    
    if ([model.msgIcon hasPrefix:@"http"]) {
        
        [_iconImage setImageWithURL:[NSURL URLWithString:model.msgIcon] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }else{
        
        [_iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.msgIcon]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }

    
    _nameLabel.text=model.msgNote;
    
    _timeLabel.text=model.time;
    
    NSAttributedString*contentAttStr= [self attributeStringWithContent:model.content keyWords:@[model.kerWord]];
    
    _contentLabel.attributedText=contentAttStr;
    
    if ([model.friendUserType isEqualToString:@"c"]) {
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_card_icon"] forState:UIControlStateNormal];
        
    }else if ([model.friendUserType isEqualToString:@"nc"]){
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nocard_icon"] forState:UIControlStateNormal];
        
    }else{
        
        [self.cardholderButton setBackgroundImage:nil forState:UIControlStateNormal];
    
    }
    
    
}

-(void)refreshWithGYHDSearchPushMessageModel:(GYHDSearchPushMessageModel*)model{

    if ([model.msgMainType isEqualToString:@"1"]) {
        
        _iconImage.image=[UIImage imageNamed:@"gyhd_message_icon_xtxx"];
        
    }else if ([model.msgMainType isEqualToString:@"2"]){

        _iconImage.image=[UIImage imageNamed:@"gyhd_message_icon_ddxx"];

    }else{
    
        _iconImage.image=[UIImage imageNamed:@"gyhd_message_icon_fwxx"];
    }
 
    _nameLabel.text=model.titleName;
    
    _timeLabel.text=model.time;
    
    NSAttributedString*contentAttStr= [self attributeStringWithContent:model.content keyWords:@[model.kerWord]];
    
    _contentLabel.attributedText=contentAttStr;
    
     [self.cardholderButton setBackgroundImage:nil forState:UIControlStateNormal];
}

-(NSAttributedString *)attributeStringWithContent:(NSString *)content keyWords:(NSArray *)keyWords

{
    
    UIColor *color=[UIColor colorWithRed:0 green:143/255.0 blue:215/255.0 alpha:1.0 ];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    
    if (keyWords) {
        
        [keyWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            NSMutableString *tmpString=[NSMutableString stringWithString:content];
            
            NSRange range=[content rangeOfString:obj];
            
            NSInteger location=0;
            
            while (range.length>0) {
                
                [attString addAttribute:(NSString*)NSForegroundColorAttributeName value:color range:NSMakeRange(location+range.location, range.length)];
                
                location+=(range.location+range.length);
                
                NSString *tmp= [tmpString substringWithRange:NSMakeRange(range.location+range.length, content.length-location)];
                
                tmpString=[NSMutableString stringWithString:tmp];
                
                range=[tmp rangeOfString:obj];
                
            }
            
            
            
        }];
        
    }
    return attString;
    
}


@end
