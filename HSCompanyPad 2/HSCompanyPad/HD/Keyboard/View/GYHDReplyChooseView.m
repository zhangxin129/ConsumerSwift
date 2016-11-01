//
//  GYHDReplyChooseView.m
//  HSCompanyPad
//
//  Created by wangbiao on 16/8/11.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDReplyChooseView.h"
#import "GYHDReplyChooseCell.h"
#import "GYHDReplyModel.h"
#import "GYHDNetWorkTool.h"
@interface GYHDReplyChooseView ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong)UITableView *replyTableView;


@end

@implementation GYHDReplyChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.replyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.replyTableView.dataSource = self;
    self.replyTableView.delegate = self;
    self.replyTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.replyTableView.rowHeight = UITableViewAutomaticDimension;
    self.replyTableView.estimatedRowHeight = 240;
    [self.replyTableView registerClass:[GYHDReplyChooseCell class] forCellReuseIdentifier:NSStringFromClass([GYHDReplyChooseCell class])];
    [self addSubview:self.replyTableView];
    
    [self.replyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
//    [self loadData];
}

- (void)loadData {
    
    @weakify(self);
    [[GYHDNetWorkTool sharedInstance] queryQuickReplyMsgByCustIdWithDict:nil RequetResult:^(NSArray *resultArry) {
        @strongify(self);
        DDLogInfo(@"%@",resultArry);
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *replyDict in resultArry) {
            GYHDReplyModel *model = [[GYHDReplyModel alloc] init];
            model.titleString =  replyDict[GYHDDataBaseCenterQuickReplyTitle];
            model.createTimeString = replyDict[GYHDDataBaseCenterQuickReplyCreateTimeStr];
            model.updateTimeString =  replyDict[GYHDDataBaseCenterQuickReplyUpdateTimeStr];
            model.contentString =  replyDict[GYHDDataBaseCenterQuickReplyContent];
            model.messageID =  replyDict[GYHDDataBaseCenterQuickReplyMsgId];
            model.isDefault =  replyDict[GYHDDataBaseCenterQuickReplyIsDefault];
            model.entCustID =  replyDict[GYHDDataBaseCenterQuickReplyCustId];
            [array addObject:model];
        }
        self.dataArray = array;
        [self.replyTableView reloadData];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GYHDReplyChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GYHDReplyChooseCell class])];
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GYHDReplyModel *model = self.dataArray[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(GYHDReplyChooseView:DidSelectWithString:)]) {
        [self.delegate GYHDReplyChooseView:self DidSelectWithString: model.contentString];
    }
    DDLogInfo(@"%@",model.contentString);
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.replyTableView reloadData];
}

@end
