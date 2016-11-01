//
//  GYHDUploadDocumentsCell.m
//  HSConsumer
//
//  Created by xiaoxh on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDUploadDocumentsCell.h"

@interface GYHDUploadDocumentsCell ()
@property (weak, nonatomic) IBOutlet UILabel *documentLb;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UILabel *clickUploadLb;
@property (weak, nonatomic) IBOutlet UILabel *figureLb;
@property (weak, nonatomic) IBOutlet UIImageView *figureImageView;
@property (nonatomic, strong) NSIndexPath* cellIndexPath;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageView;


@end
@implementation GYHDUploadDocumentsCell

- (void)awakeFromNib {
    self.leftView.layer.cornerRadius = 5.0;
    self.rightView.layer.cornerRadius = 5.0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(uploadDocuments)];
    [self.leftView addGestureRecognizer:tap];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(columnPicture)];
    [self.rightView addGestureRecognizer:tap1];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(void)title:(NSString *)title columnPicture:(NSString *)columnPicture uploadDocument:(UIImage*)uploadDocument tag:(NSIndexPath*)indexPath
{
   self.documentLb.text = title;
   [self.figureImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?custId=%@&token=%@&isPub=1&channel=4", globalData.loginModel.picUrl, columnPicture, globalData.loginModel.custId, globalData.loginModel.token]] placeholder:[UIImage imageNamed:@"msg_imgph"] options:kNilOptions completion:nil];
    if (uploadDocument) {
        self.uploadImageView.image = uploadDocument;
        self.clickUploadLb.hidden = YES;
        self.addImageView.hidden = YES;
    }
    self.cellIndexPath = indexPath;
}
//上传图片
-(void)uploadDocuments
{
    if ([_uploadDocumentDelegate respondsToSelector:@selector(uploadDocument:)]) {
        [self.uploadDocumentDelegate uploadDocument:self.cellIndexPath];
    }
}
//示列图片
-(void)columnPicture
{
    if ([_uploadDocumentDelegate respondsToSelector:@selector(columnPicture:)]) {
        [self.uploadDocumentDelegate columnPicture:self.cellIndexPath];
    }
}
@end
