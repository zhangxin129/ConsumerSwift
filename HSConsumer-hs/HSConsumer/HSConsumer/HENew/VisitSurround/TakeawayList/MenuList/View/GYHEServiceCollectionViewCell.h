//
//  GYHEServiceCollectionViewCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/9/26.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GYHEServiceCollectionDelegate <NSObject>

-(void)serviceBtn:(UIButton*)btn indexPath:(NSIndexPath*)indexPath;

@end
@interface GYHEServiceCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,weak)id<GYHEServiceCollectionDelegate> serviceDelegate;
@end
