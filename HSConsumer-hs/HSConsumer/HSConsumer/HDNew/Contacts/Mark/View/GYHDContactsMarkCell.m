//
//  GYHDContactsMarkCell.m
//  HSConsumer
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDContactsMarkCell.h"
#import "GYHDMessageCenter.h"
@interface GYHDContactsMarkCell()
@property(nonatomic,strong)UILabel    *nameLabel;
@property(nonatomic,strong)UILabel    *contentLabel;
@end
@implementation GYHDContactsMarkCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.nameLabel=[[UILabel alloc]init];
        
        self.nameLabel.font= [UIFont systemFontOfSize:20.0];
        
        [self.contentView addSubview:self.nameLabel];
        __weak __typeof(self) wself = self;
        
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(12);
            make.height.mas_equalTo(32);
            
        }];
        
        self.contentLabel=[[UILabel alloc]init];
        
        self.contentLabel.textColor=[UIColor grayColor];
        
        self.contentLabel.font=[UIFont systemFontOfSize:18.0];
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(12);
            make.right.mas_equalTo(-12);
            make.top.mas_equalTo(wself.nameLabel.mas_bottom).offset(5);
            make.bottom.mas_equalTo(-12);
            
        }];
        
    }
    return self;
}

-(void)refreshUIWith:(GYHDContactsMarkListModel*)model{

    self.nameLabel.text=[NSString stringWithFormat:@"%@(%ld)",model.title,model.markListArray.count];
    
    NSString*nameStr=[model.markListArray componentsJoinedByString:@","];
    
    self.contentLabel.text=nameStr;

}
@end
