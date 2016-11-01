//
//  GYHDLeftLocationCell.h
//  company
//
//  Created by User on 16/7/20.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GYHDChatModel.h"
#import "GYHDChatDelegate.h"
#import "GYHDDataBaseCenter.h"
#import "GYHDSessionRecordModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface GYHDLeftLocationCell : UITableViewCell

//地址图片
@property (nonatomic,strong) UIImageView *locImageView;
//聊天背景图片
@property(nonatomic, strong) UIImageView *chatbackgroundView;

@property(nonatomic, strong) UIView *chatWhiteView;//白色背景


@property(nonatomic, strong) UIImageView *iconImageView;
/**接收时间*/
@property (nonatomic, strong) UILabel* chatRecvTimeLabel;

@property(nonatomic, strong)UILabel *nameLabel;
@property(nonatomic, strong)UILabel *contentLabel;

/**图片*/
//@property(nonatomic, strong) UIImageView *chatPictureImageView;
/**发送内容状态*/
@property(nonatomic, strong) UIButton *chatStateButton;

@property(nonatomic, weak) id<GYHDChatDelegate> delegate;

@property (nonatomic,strong) BMKPoiInfo *pointInfo;
@property(nonatomic, weak) GYHDChatModel *chatModel;
@property (nonatomic, strong)GYHDSessionRecordModel * sessionModel;
@end
