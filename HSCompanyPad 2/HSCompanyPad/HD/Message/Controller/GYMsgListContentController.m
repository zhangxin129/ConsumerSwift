//
//  GYMsgListContentController.m
//  GYRestaurant
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMsgListContentController.h"

@interface GYMsgListContentController ()

@end

@implementation GYMsgListContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=kLocalized(@"GYHD_Message_Content");
    self.view.backgroundColor=[UIColor whiteColor];
    UILabel*label=[[UILabel alloc]init];
    label.font=[UIFont systemFontOfSize:32];
    
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.text=self.model.messageListContent;
    
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.left.right.mas_equalTo(0);
        
    }];
    
   
}

@end
