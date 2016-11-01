//
//  GYHealthUploadImgCollectionViewCell.h
//  HSConsumer
//
//  Created by apple on 16/1/6.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^Columnpicture)(void);
typedef void (^Picture)(void);
@interface GYHealthUploadImgCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView* myimageView;
@property (weak, nonatomic) IBOutlet UILabel* mylb; //所需要上传的资料
@property (weak, nonatomic) IBOutlet UIButton* mybtn; //示列图片
@property (nonatomic, copy) Columnpicture colum;
@property (nonatomic, copy) Picture pic;

- (void) setDemoBtnState:(BOOL) state;

@end
