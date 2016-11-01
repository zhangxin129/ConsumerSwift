//
//  GYHSResetTradingTableViewCell.m
//  HSConsumer
//
//  Created by lizp on 16/8/15.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSResetTradingTableViewCell.h"

@interface GYHSResetTradingTableViewCell()

@end

@implementation GYHSResetTradingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    

    self.layer.borderWidth = 0.5;
    self.layer.borderColor =  kDefaultViewBorderColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)refreshDataWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder indexPaht:(NSIndexPath *)indexPath {

    self.title.text = title;
    self.value.placeholder = placeHolder;
    if(indexPath.row == 2) {
        [self.value addTarget:self action:@selector(valueEditingChange:) forControlEvents:UIControlEventEditingChanged];
    }
}

-(void)valueEditingChange:(UITextField *)textFeild {

    if(textFeild.text.length == 6) {
        [textFeild endEditing:NO];
        return;
    }
    
}

@end
