//
//  GYHEGoodsWebView.m
//  HSConsumer
//
//  Created by lizp on 16/9/29.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHEGoodsWebView.h"

@implementation GYHEGoodsWebView

-(instancetype)initWithFrame:(CGRect)frame {

    if(self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(void)setUp {

    self.userInteractionEnabled = YES;
    [self addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

//尾部
-(UIView *)addFooterView {

    self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
    NSURL *url = [NSURL URLWithString:self.model.picWordDetails];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    return self.webView;
}


#pragma mark - get or set 
-(UITableView *)tableView {

    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    }
    return _tableView;
}

-(void)setModel:(GYHEGoodsDetailsModel *)model {

    
    self.tableView.tableFooterView = [self addFooterView];
}

@end
