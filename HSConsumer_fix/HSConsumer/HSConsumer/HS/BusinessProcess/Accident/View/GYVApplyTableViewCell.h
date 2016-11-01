//
//  GYVApplyTableViewCell.h
//  HSConsumer
//
//  Created by xiaoxh on 16/7/27.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GYHSbtnDieDeletage <NSObject>
-(void)btnDie;
@end

@protocol GYHSbtnMedicalDeletage <NSObject>

-(void)btnMedical;

@end

@interface GYVApplyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton* btnDie;
@property (weak, nonatomic) IBOutlet UIButton* btnMedical;
@property (weak, nonatomic) IBOutlet UILabel *accidentHarmlb;//身故保障金
@property (weak, nonatomic) IBOutlet UILabel *dielb;//意外伤害保障金
@property (weak, nonatomic) id<GYHSbtnDieDeletage> btnDieDeletage;
@property (weak, nonatomic) id<GYHSbtnMedicalDeletage> btnMedicalDeletage;
@end
