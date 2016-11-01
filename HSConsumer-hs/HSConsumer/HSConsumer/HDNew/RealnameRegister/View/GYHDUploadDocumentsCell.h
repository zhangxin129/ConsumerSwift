//
//  GYHDUploadDocumentsCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/13.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHDUploadDocumentDelegate <NSObject>
@optional
- (void)uploadDocument:(NSIndexPath*)indexPath;
- (void)columnPicture:(NSIndexPath*)indexPath;
@end
@interface GYHDUploadDocumentsCell : UITableViewCell
@property(nonatomic,weak)id<GYHDUploadDocumentDelegate> uploadDocumentDelegate;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
-(void)title:(NSString*)title columnPicture:(NSString*)columnPicture uploadDocument:(UIImage*)uploadDocument tag:(NSIndexPath*)indexPath;

@end
