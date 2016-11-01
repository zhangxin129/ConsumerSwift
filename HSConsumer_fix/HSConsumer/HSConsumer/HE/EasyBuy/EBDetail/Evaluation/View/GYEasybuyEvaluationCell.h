//
//  GYEasybuyEvaluationCell.h
//  GYHSConsumer_Easybuy
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYEasybuyEvaluationModel.h"

@interface GYEasybuyEvaluationCell : UITableViewCell

@property (nonatomic, strong) GYEasybuyEvaluationModel* model;
@property (weak, nonatomic) IBOutlet UILabel* msgLabel;

@end
