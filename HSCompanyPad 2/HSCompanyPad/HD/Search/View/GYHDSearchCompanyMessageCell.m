//
//  GYHDSearchCompanyMessageCell.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchCompanyMessageCell.h"

@implementation GYHDSearchCompanyMessageCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectShowView=[[UIView alloc]init];
        self.selectShowView.backgroundColor=[UIColor colorWithRed:48/255.0 green:152/255.0 blue:229/255.0 alpha:1.0];
        self.selectShowView.hidden=YES;
        [self.contentView addSubview:self.selectShowView];
        
        [self.selectShowView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(3);
            
        }];
        
        _iconImage=[[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 46, 46)];
        
        [self.contentView addSubview:_iconImage];
        
        _nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iconImage.frame)+10, 12, 325-CGRectGetMaxX(_iconImage.frame)-20, 20)];
        
        _nameLabel.font=[UIFont systemFontOfSize:16.0];
        
        _nameLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_nameLabel];
        
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(_nameLabel.frame.origin.x, CGRectGetMaxY(_nameLabel.frame)+5, _nameLabel.frame.size.width, 20)];
        
        _contentLabel.numberOfLines=0;
        
        _contentLabel.font=[UIFont systemFontOfSize:14.0];
        
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_contentLabel];
        
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
-(void)refreshWithModel:(GYHDSearchMessageListModel*)model{
    
    if ([model.msgType isEqualToString:@"9"]) {
        
        if ([model.pullMsgType isEqualToString:@"1"]) {
            
            _iconImage.image=[UIImage imageNamed:@"gyhd_message_icon_xtxx"];
            
            
        }else if ([model.pullMsgType isEqualToString:@"2"]){
            
            
            _iconImage.image=[UIImage imageNamed:@"gyhd_message_icon_ddxx"];
            
            
        }else if([model.pullMsgType isEqualToString:@"3"]){
            
            _iconImage.image=[UIImage imageNamed:@"gyhd_message_icon_fwxx"];
            
        }
        
         [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"nil"] forState:UIControlStateNormal];
    }
    
    if ([model.msgType isEqualToString:@"10"]) {
        
        
        if ([model.iconUrl hasPrefix:@"http"]) {
            
            [_iconImage setImageWithURL:[NSURL URLWithString:model.iconUrl] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
        }else{
            
            [_iconImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",globalData.loginModel.picUrl,model.iconUrl]] placeholder:[UIImage imageNamed:@"gyhd_defaultheadimg"] options:kNilOptions completion:nil];
        }
        
        if ([model.friendUserType isEqualToString:@"c"]) {
            
            [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_card_icon"] forState:UIControlStateNormal];
            
        }else if ([model.friendUserType isEqualToString:@"nc"]){
            
            [self.cardholderButton setBackgroundImage:[UIImage imageNamed:@"gyhd_nocard_icon"] forState:UIControlStateNormal];
            
        }

    }
    
    _nameLabel.text=model.titleName;
    
    NSString*str=[NSString stringWithFormat:@"%ld条与%@的相关记录",model.countrow,model.keyWord];
    
    _contentLabel.text=str;
    
    if (model.isSelect) {
        
        self.selectShowView.hidden=NO;
        
        self.contentView.backgroundColor=kDefaultVCBackgroundColor;
        
    }else{
        
        self.selectShowView.hidden=YES;
        
        self.contentView.backgroundColor=[UIColor whiteColor];
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
