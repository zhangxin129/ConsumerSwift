//
//  GYHSMyContactInfoFirstSectionCell.m
//  HSCompanyPad
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHSMyContactInfoFirstSectionCell.h"
#import "GYHSMyContactInfoMainModel.h"

@interface GYHSMyContactInfoFirstSectionCell ()

@property (weak, nonatomic) IBOutlet UILabel* titleLabel;
@property (weak, nonatomic) IBOutlet UILabel* contentLabel;
@property (strong, nonatomic) NSArray* titleArray;

@end

@implementation GYHSMyContactInfoFirstSectionCell

- (void)awakeFromNib
{
    
    self.contentLabel.textColor = kGray333333;
    self.contentLabel.font = kFont32;
    
    self.titleLabel.textColor = kGray666666;
    self.titleLabel.font = kFont32;
}



- (NSArray*)titleArray
{
    if (!_titleArray) {
        _titleArray = @[ kLocalized(@"GYHS_Myhs_Contacts_Name_Colon"),
                         
                         kLocalized(@"GYHS_Myhs_Contacts_Phone_Colon"), kLocalized(@"GYHS_Myhs_Leagel_Name_Colon"), kLocalized(@"GYHS_Myhs_Leagel_Phone_Colon") ];
    }
    return _titleArray;
}

- (void)setIndexPath:(NSIndexPath*)indexPath
{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0: {
            self.contentView.customBorderType = UIViewCustomBorderTypeTop | UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.titleLabel.text = self.titleArray[indexPath.row];
            self.contentLabel.text = self.model.contactName;
        } break;
        case 1:{
            self.contentView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.titleLabel.text = self.titleArray[indexPath.row];
            self.contentLabel.text = self.model.contactPhone;
        }break;
        case 2: {
            self.contentView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.titleLabel.text = self.titleArray[indexPath.row];
            self.contentLabel.text = self.model.creName;
        } break;
        case 3: {
            self.contentView.customBorderType = UIViewCustomBorderTypeRight | UIViewCustomBorderTypeLeft|UIViewCustomBorderTypeBottom;
            self.contentView.customBorderColor = kGrayE3E3EA;
            self.contentView.customBorderLineWidth = @1;
            self.titleLabel.text = self.titleArray[indexPath.row];
            self.contentLabel.text = self.model.legalPersonPhone;
        } break;
        default:
            break;
    }
}

@end
