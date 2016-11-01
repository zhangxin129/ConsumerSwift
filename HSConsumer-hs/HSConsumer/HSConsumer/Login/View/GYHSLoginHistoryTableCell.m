//
//  GYHSLoginHistoryTableCell.m
//  GYHSConsumer_MyHS
//
//  Created by wangfd on 16/4/6.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHSLoginHistoryTableCell.h"

@interface GYHSLoginHistoryTableCell ()
@property (weak, nonatomic) IBOutlet UIImageView* userImage;
@property (weak, nonatomic) IBOutlet UILabel* numberLable;

@property (strong, nonatomic) NSString* hsNumber;

@end

@implementation GYHSLoginHistoryTableCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellValue:(NSString*)imageName value:(NSString*)value
{

    if (![GYUtils checkStringInvalid:imageName]) {
        if ([imageName hasPrefix:@"http"]) {
            [self.userImage setImageWithURL:[NSURL URLWithString:imageName] placeholder:[UIImage imageNamed:@"hs_icon_real_name_no"] options:kNilOptions completion:nil];
        }
        else {
            self.userImage.image = [UIImage imageNamed:imageName];
        }
    }

    self.hsNumber = value;
    self.numberLable.text = value;
}

- (IBAction)deleteButtonAction:(UIButton*)sender
{
    if ([self.cellDelegate respondsToSelector:@selector(deleteButtonAction:)]) {
        [self.cellDelegate deleteButtonAction:self.hsNumber];
    }
}

@end
