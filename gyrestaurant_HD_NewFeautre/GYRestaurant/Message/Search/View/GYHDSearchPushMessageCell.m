//
//  GYHDSearchPushMessageCell.m
//  GYRestaurant
//
//  Created by apple on 16/6/21.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchPushMessageCell.h"

@implementation GYHDSearchPushMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 20, kScreenWidth-280, 40)];
        
        _titleLabel.textAlignment=NSTextAlignmentLeft;
        
        _titleLabel.font=[UIFont systemFontOfSize:20.0];
        
        [self.contentView addSubview:_titleLabel];
        
        _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-240, 24, 200, 15)];
        
        _timeLabel.textAlignment=NSTextAlignmentRight;
        
        _timeLabel.font=[UIFont systemFontOfSize:16.0];
        
        [self.contentView addSubview:_timeLabel];
        
        _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_titleLabel.frame)+20, _titleLabel.frame.size.width, self.frame.size.height-70)];
        
        _contentLabel.numberOfLines=0;
        
        _contentLabel.font=[UIFont systemFontOfSize:16.0];
        
        _contentLabel.textAlignment=NSTextAlignmentLeft;
        
        [self.contentView addSubview:_contentLabel];
        
    }

    return self;
}
-(void)refreshWithModel:(GYHDSearchPushMessageModel *)model{
    
    NSAttributedString*titleAttStr= [self attributeStringWithContent:model.titleName keyWords:@[model.kerWord]];
    _titleLabel.attributedText=titleAttStr;
    
    _timeLabel.text=model.time;
    
    NSAttributedString*contentAttStr= [self attributeStringWithContent:model.content keyWords:@[model.kerWord]];
    
    _contentLabel.attributedText=contentAttStr;
    
    
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
