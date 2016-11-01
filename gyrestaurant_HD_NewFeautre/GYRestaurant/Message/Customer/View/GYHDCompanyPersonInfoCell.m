//
//  GYHDCompanyPersonInfoCell.m
//  GYRestaurant
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDCompanyPersonInfoCell.h"
@interface GYHDCompanyPersonInfoCell ()<UITextFieldDelegate>

@end
@implementation GYHDCompanyPersonInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.rowNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 50, 60)];
        self.rowNameLabel.textAlignment=NSTextAlignmentCenter;
        self.rowNameLabel.font=[UIFont systemFontOfSize:20];
        [self.contentView addSubview:self.rowNameLabel];
        
        self.rowTF=[[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.rowNameLabel.frame)+50, 0, kScreenWidth-500, 60)];
        self.rowTF.delegate=self;
        
        [self.contentView addSubview:self.rowTF];
        
    }
    return self;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if ([self.rowNameLabel.text isEqualToString:@"性别"] || [self.rowNameLabel.text isEqualToString:@"地区"]) {
        [self.rowTF endEditing:YES];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(getRowName:TFtext:)]) {
        
        [_delegate getRowName:self.rowNameLabel.text TFtext:@""];
    }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (_delegate && [_delegate respondsToSelector:@selector(getRowName:TFtext:)]) {
        
        [_delegate getRowName:self.rowNameLabel.text TFtext:self.rowTF.text];
    }
    
    return YES;
}

-(void)refreshWithDict:(NSDictionary*)dict{

    self.rowNameLabel.text=dict[@"rowName"];
    self.rowTF.text=dict[@"rowTFStr"];
    if (self.rowTF.text.length<=0) {
        
        self.rowTF.placeholder=[NSString stringWithFormat:@"请输入您的%@",self.rowNameLabel.text];
    }
    
    if ([dict[@"rowName"] isEqualToString:@"性别"]) {
        if ([dict[@"rowTFStr"] isEqualToString:@"1"]) {
            
            self.rowTF.text= @"男";
            
        }else if ([dict[@"rowTFStr"] isEqualToString:@"0"]){
        
            self.rowTF.text = @"女";
        }else{
        
            self.rowTF.text = @"不限";
        }
        
    }

}

@end
