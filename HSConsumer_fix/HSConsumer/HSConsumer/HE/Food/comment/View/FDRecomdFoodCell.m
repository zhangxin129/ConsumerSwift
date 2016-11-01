//
//  FDRecomdFoodCell.m
//  HSConsumer
//
//  Created by apple on 15/12/25.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "FDRecomdFoodCell.h"

@implementation FDRecomdFoodCell

- (void)awakeFromNib
{
}

- (void)setModel:(FDSubmitCommitOrderDetailFoodModel*)model
{

    _model = model;

    _foodName.text = model.foodName;

    _reconmCount.text = [NSString stringWithFormat:@"%@%@", model.recommendationItemCount, kLocalized(@"GYHE_Food_PeopleRecomment")];

    _addImgeView.hidden = YES;

    if (model.picUrl != nil) {

        NSData* jsonData = [model.picUrl dataUsingEncoding:NSUTF8StringEncoding];

        NSArray* arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

        NSDictionary* dict;
        for (NSInteger i = 0; i < arr.count; i++) {

            if (i == 0) {

                dict = arr[i];
            }
        }

        NSArray* tempArr = dict[@"mobile"];

        NSString* picStr;

        for (NSInteger j = 0; j < tempArr.count; j++) {

            if (j == 0) {

                picStr = tempArr[j][@"name"];
            }
        }

        picStr = [NSString stringWithFormat:@"%@%@", globalData.tfsDomain, picStr];

        [_foodPic setImageWithURL:[NSURL URLWithString:picStr] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    }
}

- (void)setRecomdModel:(FDRecomdModel*)recomdModel
{

    _recomdModel = recomdModel;

    _foodName.text = recomdModel.recomFood;

    _reconmCount.text = [NSString stringWithFormat:@"%ld%@", (long)recomdModel.cont, kLocalized(@"GYHE_Food_PeopleRecomment")];

    if (recomdModel.pics != nil) {

        NSData* jsonData = [recomdModel.pics dataUsingEncoding:NSUTF8StringEncoding];

        NSArray* arr = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];

        NSDictionary* dict;
        for (NSInteger i = 0; i < arr.count; i++) {

            if (i == 0) {

                dict = arr[i];
            }
        }

        NSArray* tempArr = dict[@"mobile"];

        NSString* picStr;

        for (NSInteger j = 0; j < tempArr.count; j++) {

            if (j == 0) {

                picStr = tempArr[j][@"name"];
            }
        }

        picStr = [NSString stringWithFormat:@"%@%@", globalData.tfsDomain, picStr];

        [_foodPic setImageWithURL:[NSURL URLWithString:picStr] placeholder:[UIImage imageNamed:@"gycommon_image_placeholder"] options:kNilOptions completion:nil];
    }

}

@end
