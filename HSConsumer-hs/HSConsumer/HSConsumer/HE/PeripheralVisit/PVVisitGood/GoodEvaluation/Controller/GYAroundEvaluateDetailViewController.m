//
//  GYAroundEvaluateDetailViewController.m
//  HSConsumer
//
//  Created by apple on 15-2-12.
//  @深圳市归一科技研发有限公司_iOS
//  @版权所有  禁止传播
//  @级别：绝密
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYAroundEvaluateDetailViewController.h"
#import "GYGoodComments.h"
#import "GYMyCommentTableViewCell.h"

#define Count 8
@interface GYAroundEvaluateDetailViewController ()

@end

@implementation GYAroundEvaluateDetailViewController

    {
    UITableView* tvEvaluationTalbe;

    UILabel* lbNoResultTip;

    int currentPage;

    int totalCount;

    int totalPage;

    BOOL isUpFresh;
}

#pragma mark 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    _marrDatasource = [NSMutableArray array];
    currentPage = 1;
    tvEvaluationTalbe = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 80 - 64 + 40)];
    [self.view addSubview:tvEvaluationTalbe];
    tvEvaluationTalbe.backgroundColor = [UIColor whiteColor];
    tvEvaluationTalbe.delegate = self;
    tvEvaluationTalbe.dataSource = self;
    [tvEvaluationTalbe registerNib:[UINib nibWithNibName:NSStringFromClass([GYMyCommentTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    tvEvaluationTalbe.tableFooterView = [[UIView alloc] init];
    [self loadDataFromNetwork];

    //    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
    //
    //        //        请求数据
    //
    //        [self headerRereshing];
    //
    //    }];
    GYRefreshHeader* header = [GYRefreshHeader headerWithRefreshingBlock:^{
        
        //        请求数据
        
        [self headerRereshing];

    }];

    //    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
    //
    //        [self footerRereshing];
    //
    //    }];
    GYRefreshFooter* footer = [GYRefreshFooter footerWithRefreshingBlock:^{
        
        [self footerRereshing];

    }];

    //    设定表格视图 头部 尾部
    tvEvaluationTalbe.mj_header = header;
    tvEvaluationTalbe.mj_footer = footer;
}

- (void)loadDataFromNetwork
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:self.strGoodId forKey:@"itemID"];
    [dict setValue:[NSString stringWithFormat:@"%d", Count] forKey:@"count"];
    [dict setValue:[NSString stringWithFormat:@"%d", currentPage] forKey:@"currentPage"];
    [dict setValue:self.EvaluteStatus forKey:@"status"];

    GYNetRequest * request = [[GYNetRequest alloc] initWithBlock:GetEvaluationInfoUrl parameters:dict requestMethod:GYNetRequestMethodGET requestSerializer:GYNetRequestSerializerHTTP respondBlock:^(NSDictionary *responseObject, NSError *error) {
        
        if (!error) {
            NSDictionary *resonpseDic = responseObject;
            
            NSString *retCode = [NSString stringWithFormat:@"%@", resonpseDic[@"retCode"]];
            
            if ([retCode isEqualToString:@"200"]) {
                NSMutableArray *dataSource = [NSMutableArray array];
                for (NSDictionary *tempDict in resonpseDic[@"data"]) {
                    totalCount = [resonpseDic[@"rows"] intValue];
                    totalPage = [resonpseDic [@"totalPage"] intValue];
                    GYGoodComments *model = [[GYGoodComments alloc] init];
                    model.strUserName = kSaftToNSString(tempDict[@"name"]);
                    model.strIdstring = kSaftToNSString(tempDict[@"id"]);
                    model.strComments = kSaftToNSString(tempDict[@"content"]);
                    model.strGoodName = kSaftToNSString(tempDict[@"gName"]);
                    model.strGoodType = kSaftToNSString(tempDict[@"gType"]);
                    model.strTime = kSaftToNSString(tempDict[@"time"]);////////by liss
                    
                    model.strUserIconURL = [NSString stringWithFormat:@"%@",kSaftToNSString(tempDict[@"buyHeadPic"])];
                    
                    if (isUpFresh) {
                        [dataSource addObject:model];
                    } else {
                        [_marrDatasource addObject:model];
                        
                    }
                    
                }
                
                if (isUpFresh) {
                    
                    [_marrDatasource removeAllObjects];
                    _marrDatasource = dataSource;
                    
                }
                if (_marrDatasource.count <= 0) {
                    
                    tvEvaluationTalbe.mj_footer.hidden = YES;
                    UIView *background = [[UIView alloc] initWithFrame:tvEvaluationTalbe.frame];
                    UILabel *lbTips = [[UILabel alloc] init];
                    lbTips.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100 + 60);
                    lbTips.textColor = kCellItemTitleColor;
                    lbTips.font = [UIFont systemFontOfSize:15.0];
                    lbTips.backgroundColor = [UIColor clearColor];
                    lbTips.bounds = CGRectMake(0, 0, 210, 40);
                    lbTips.textAlignment = NSTextAlignmentCenter;
                    lbTips.text = kLocalized(@"GYHE_SurroundVisit_NoRelevantEvaluation");
                    UIImageView *imgvNoResult = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_no_result.png"]];
                    imgvNoResult.center = CGPointMake(kScreenWidth/2, kScreenHeight/2 - 100);
                    imgvNoResult.bounds = CGRectMake(0, 0, 52, 59);
                    [background addSubview:imgvNoResult];
                    
                    [background addSubview:lbTips];
                    tvEvaluationTalbe.backgroundView = background;
                    tvEvaluationTalbe.backgroundView.hidden = NO;
                    
                    [tvEvaluationTalbe.mj_header endRefreshing];
                    [tvEvaluationTalbe.mj_footer endRefreshing];
                    
                } else {
                    
                    tvEvaluationTalbe.backgroundView.hidden = YES;
                }
                
                //                  _marrDatasource = (NSMutableArray *)[[_marrDatasource reverseObjectEnumerator] allObjects];
                [tvEvaluationTalbe reloadData];
                
                currentPage += 1;
                
                if (currentPage <= totalPage) {
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [tvEvaluationTalbe.mj_header endRefreshing];
                    [tvEvaluationTalbe.mj_footer endRefreshing];
                    
                } else {
                    [tvEvaluationTalbe.mj_header endRefreshing];
                    [tvEvaluationTalbe.mj_footer endRefreshing];
                    [tvEvaluationTalbe.mj_footer endRefreshingWithNoMoreData];//必须要放在reload后面
                }
                
            }
            
        }else {
            [GYUtils parseNetWork:error resultBlock:nil];
        }
        
    }];
    [request start];
    
}


#pragma mark tableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{

    return _marrDatasource.count;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if(_marrDatasource.count > indexPath.row) {
        GYGoodComments* model = _marrDatasource[indexPath.row];
        CGFloat height = 123;
        if (model.contentHeight > 44) {
            height = 123 - 44 + model.contentHeight;
        }
        return height;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifer = @"cell";
    GYMyCommentTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[GYMyCommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    if(_marrDatasource.count > indexPath.row) {
        GYGoodComments* model = _marrDatasource[indexPath.row];
        [cell refreshUIWithModel:model];
    }
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark 自定义方法
//开始进入刷新状态
- (void)headerRereshing
{
    isUpFresh = YES;
    
    currentPage = 1;
    
    [self loadDataFromNetwork];
}

- (void)footerRereshing
{
    
    isUpFresh = NO;
    if (currentPage <= totalPage) {
        [self loadDataFromNetwork];
    }
}


@end
