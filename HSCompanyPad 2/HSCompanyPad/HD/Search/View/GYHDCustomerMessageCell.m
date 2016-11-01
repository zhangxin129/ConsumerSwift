//
//  GYHDCustomerMessageCell.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCustomerMessageCell.h"

@implementation GYHDCustomerMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 46, 46)];
        
        [self.contentView addSubview:_iconImage];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame)+10, 12, 325-CGRectGetMaxX(_iconImage.frame)-20, 20)];
        
        _nameLabel.font=[UIFont systemFontOfSize:16.0];
        
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_nameLabel];
        
        
        _hsCardLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+5, _nameLabel.frame.size.width, 20)];
        
        _hsCardLabel.numberOfLines=0;
        
        _hsCardLabel.font=[UIFont systemFontOfSize:14.0];
        
        _hsCardLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_hsCardLabel];
        
        self.cardholderButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.cardholderButton];
        
        @weakify(self);
        
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
            make.right.mas_lessThanOrEqualTo(-10);
        }];
    }
    
    return self;
}
-(void)refreshWithModel:(GYHDSearchCustomerListModel *)model{
    
    if ([model.iconUrl hasPrefix:@"http"]) {
        
        [_iconImage setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }else{
    
        [_iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.iconUrl]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
    }

    NSAttributedString*nameAttStr= [self attributeStringWithContent:model.name keyWords:@[model.keyWord]];
    
    _nameLabel.attributedText=nameAttStr;
    
//    _timeLabel.text=model.time;
    
    if (model.hsCardNum!=nil && model.hsCardNum.length>0) {
        
        NSAttributedString*hsCardAttStr= [self attributeStringWithContent:[NSString stringWithFormat:@"%@:%@",kLocalized(@"GYHD_Alternate_Number"),model.hsCardNum] keyWords:@[model.keyWord]];
        
        _hsCardLabel.attributedText=hsCardAttStr;
    }
    
    if ([model.friendUserType isEqualToString:@"c"]) {
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_card_icon"] forState:UIControlStateNormal];
        
    }else if ([model.friendUserType isEqualToString:@"nc"]){
        
        [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nocard_icon"] forState:UIControlStateNormal];
        
    }
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
