//
//  GYHSMyCompanyInfoCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyCompanyInfoCell.h"

@interface GYHSMyCompanyInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* contentLabel;

@end

@implementation GYHSMyCompanyInfoCell

- (void)awakeFromNib
{
    self.titleLabel.textColor = kGray666666;
    self.contentLabel.textColor = kGray333333;
}




- (void)setTitle:(NSString*)title
{
    _title = title;
    self.titleLabel.text = title;
}

- (void)setContent:(NSString*)content
{
    _content = content;
    self.contentLabel.text = content;
}

- (void)setIndexPath:(NSIndexPath*)indexPath
{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0: {
            self.contentView.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;

        } break;
        case 1:{
            self.contentView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
           
        }break;
        case 2: {
            self.contentView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            
        } break;
        case 3: {
            self.contentView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            
        } break;
        default:
            break;
    }
}


@end
