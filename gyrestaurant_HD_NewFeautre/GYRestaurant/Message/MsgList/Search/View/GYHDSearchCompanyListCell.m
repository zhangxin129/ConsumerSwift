//
//  GYHDSearchCompanyListCell.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchCompanyListCell.h"

@implementation GYHDSearchCompanyListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(40, 20, 80, 80)];
        
        [self.contentView addSubview:_iconImage];
        
//        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-240, 24, 200, 15)];
//        
//        _timeLabel.textAlignment=NSTextAlignmentRight;
//        
//        _timeLabel.font=[UIFont systemFontOfSize:16.0];
//        
//        [self.contentView addSubview:_timeLabel];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame)+10, 22, kScreenWidth-CGRectGetMaxX(_iconImage.frame)-10-240, 20)];
        
        _nameLabel.font=[UIFont systemFontOfSize:20.0];
        
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_nameLabel];
        
        
        _roleLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+10, _nameLabel.frame.size.width, 20)];
        
        _roleLabel.font=[UIFont systemFontOfSize:14.0];
        
        _roleLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_roleLabel];
        
        
        _phoneLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_roleLabel.frame)+10, _nameLabel.frame.size.width, 20)];
        
        _phoneLabel.font=[UIFont systemFontOfSize:14.0];
        
        _phoneLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_phoneLabel];
        
    }
    
    return self;
}
-(void)refreshWithModel:(GYHDSearchCompanyListModel *)model{
    
    if ([model.icon hasPrefix:@"http"]) {
        
        [_iconImage setImageWithURL:[NSURL URLWithString:model.icon] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    }else{
        
        [_iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.icon]] placeholder:[UIImage imageNamed:@"defaultheadimg"] options:kNilOptions completion:nil];
    }

    NSString *titleStr=[NSString stringWithFormat:@"%@(%@)",model.operaName,model.userName];
    NSAttributedString*contentAttStr= [self attributeStringWithContent:titleStr keyWords:@[model.kerWord]];
    
    _nameLabel.attributedText=contentAttStr;
  
    _roleLabel.text=model.roleName;
    
    _phoneLabel.text=[NSString stringWithFormat:@"电话:%@",model.operPhone];
    
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
