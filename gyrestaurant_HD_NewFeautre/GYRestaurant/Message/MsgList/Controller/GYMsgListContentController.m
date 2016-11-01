//
//  GYMsgListContentController.m
//  GYRestaurant
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYMsgListContentController.h"
#import "GYHDNavView.h"
@interface GYMsgListContentController ()<GYHDNavViewDelegate>

@end

@implementation GYMsgListContentController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    
    self.navigationController.navigationBar.hidden=YES;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消息内容";
      self.view.backgroundColor=[UIColor whiteColor];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    label.font=[UIFont systemFontOfSize:32];
    
    label.textAlignment=NSTextAlignmentCenter;
    label.numberOfLines=0;
    label.text=self.model.messageListContent;

    [self.view addSubview:label];
    [self setupNav];
}
-(void)setupNav{
    
    GYHDNavView *navView = [[GYHDNavView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth ,64)];
    navView.delegate = self;
    [self.view addSubview:navView];
    
}
- (void)GYHDNavViewGoBackAction {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
