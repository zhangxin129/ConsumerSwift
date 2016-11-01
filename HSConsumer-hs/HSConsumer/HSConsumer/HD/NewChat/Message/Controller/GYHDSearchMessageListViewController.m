//
//  GYHDSearchMessageListViewController.m
//  HSConsumer
//
//  Created by shiang on 16/7/7.
//  Copyright © 2016年 SHENZHEN GUIYI SCIENCE AND TECHNOLOGY DEVELOP CO.,LTD. All rights reserved.
//

#import "GYHDSearchMessageListViewController.h"
#import "GYHDSearchMessageListCell.h"
#import "GYHDMessageCenter.h"
#import "GYEPOrderDetailViewController.h"
#import "GYOrderDetailsViewController.h"
#import "GYHDHSPlatformViewController.h"
#import "GYHDBindHSViewController.h"
#import "GYHDChatViewController.h"

@interface GYHDSearchMessageListViewController () <UITableViewDataSource, UITableViewDelegate>;

@property(nonatomic, strong)NSArray *dataArray;
@property(nonatomic, strong)UITableView *listTableView;

@end

@implementation GYHDSearchMessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.listTableView registerClass:[GYHDSearchMessageListCell class] forCellReuseIdentifier:@"GYHDSearchMessageListCellID"];
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listTableView.rowHeight = 68.0f;
    [self.view addSubview:self.listTableView];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    // Do any additional setup after loading the view.
}
- (void)setSearchDict:(NSDictionary *)searchDict {
    _searchDict = searchDict;
    NSString *searchString = searchDict[@"searchString"];
    NSArray *array =  [[GYHDMessageCenter sharedInstance] searchMessageListWithString:searchString custID:searchDict[@"custID"]];
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        GYHDSearchMessageListModel *model = [[GYHDSearchMessageListModel alloc] initWithDict:dict];

        NSString* pattern = searchString;
        NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
        // 2.测试字符串
        NSArray* results = [regex matchesInString:model.detailString options:0 range:NSMakeRange(0, model.detailString.length)];
        // 3.遍历结果
        NSTextCheckingResult* result = [results firstObject];
        NSMutableAttributedString* attName = [[NSMutableAttributedString alloc] initWithString:model.detailString];
        NSMutableDictionary* attDict = [NSMutableDictionary dictionary];
        attDict[NSForegroundColorAttributeName] = [UIColor redColor];
        [attName setAttributes:attDict range:result.range];
        model.detailAttributedString = attName;
        
        
        NSString* enmojiPattern = @"\\[[0-9]{3}\\]";
        NSRegularExpression* emojiRegex = [[NSRegularExpression alloc] initWithPattern:enmojiPattern options:0 error:nil];
        // 2.测试字符串
        NSArray* enmojiResults = [emojiRegex matchesInString:model.detailString options:0 range:NSMakeRange(0, model.detailString.length)];
        // 3.遍历结果
        [enmojiResults enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSTextCheckingResult* result, NSUInteger idx, BOOL* _Nonnull stop) {
            NSString *imageName = [[model.detailString substringWithRange:result.range] substringWithRange:NSMakeRange(1, 3)];
            NSTextAttachment *textAtt = [[NSTextAttachment alloc] init];
            UIImage *image = [UIImage imageNamed:imageName];
            if (image) {
                textAtt.image = image;
                textAtt.bounds = CGRectMake(0, 0, 10, 10);
                NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAtt];
                [model.detailAttributedString replaceCharactersInRange:result.range withAttributedString:att];
            }
        }];
        
        
        self.title =  model.nameString;
        [dataArray addObject:model];
    }
    _dataArray = dataArray;
    [self.listTableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GYHDSearchMessageListModel *model = self.dataArray[indexPath.row];
    GYHDSearchMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GYHDSearchMessageListCellID"];
    cell.model = model;
    return  cell;
}


- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [self pushNextViewControllerWithIndexPath:indexPath];
}

/**
 * 跳转到下个一控制器
 */
- (void)pushNextViewControllerWithIndexPath:(NSIndexPath*)indexPath
{
    GYHDSearchMessageListModel* messageModel = self.dataArray[indexPath.row];
    NSInteger code = messageModel.custID.integerValue;
    NSDictionary* contentDict = [GYUtils stringToDictionary:messageModel.messageBody];
    UIViewController* pushNextViewController = nil;
    if (code == GYHDProtobufMessage02001 || code == GYHDProtobufMessage02002 || code == GYHDProtobufMessage02003 || code == GYHDProtobufMessage02004 || code == GYHDProtobufMessage02005 || code == GYHDProtobufMessage02006 || code == GYHDProtobufMessage02007 || code == GYHDProtobufMessage02008) {
        GYEPOrderDetailViewController* vc = kLoadVcFromClassStringName(NSStringFromClass([GYEPOrderDetailViewController class]));
        vc.orderID = contentDict[@"orderId"];
        vc.dicDataSource = nil;
        vc.navigationItem.title = kLocalized(@"GYHD_order_detail");
        pushNextViewController = vc;
    }
    else if (code == GYHDProtobufMessage02021 || code == GYHDProtobufMessage02022 || code == GYHDProtobufMessage02023 || code == GYHDProtobufMessage02024 || code == GYHDProtobufMessage02025 || code == GYHDProtobufMessage02026 || code == GYHDProtobufMessage02027 || code == GYHDProtobufMessage02028 || code == GYHDProtobufMessage02029) {
        GYOrderDetailsViewController* orderDetail = kLoadVcFromClassStringName(NSStringFromClass([GYOrderDetailsViewController class]));
        orderDetail.orderId = contentDict[@"orderId"];
        orderDetail.moderType = contentDict[@"msg_repast_type"];
        pushNextViewController = orderDetail;
    }
    else if (code == GYHDProtobufMessage01001 || code == GYHDProtobufMessage01002) {
        NSDictionary* subContDict = [GYUtils stringToDictionary:contentDict[@"msg_content"]];
        GYHDHSPlatformViewController* hsplatFormViewController = [[GYHDHSPlatformViewController alloc] init];
        hsplatFormViewController.urlString = subContDict[@"pageUrl"];
        pushNextViewController = hsplatFormViewController;
    }
//    else if (code == GYHDProtobufMessage01009) {
//        GYHDBindHSViewController* bindHSViewController = [[GYHDBindHSViewController alloc] init];
//        bindHSViewController.messageBody = messageModel.messageBody;
//        bindHSViewController.messageID = messageModel.messageID;
//        pushNextViewController = bindHSViewController;
//    }
    if (messageModel.custID.length > 10) {
        GYHDChatViewController *chatViewController =[[GYHDChatViewController alloc] init];
        chatViewController.messageCard = messageModel.custID;
        chatViewController.searchID = messageModel.messageID;
        pushNextViewController = chatViewController;
    }
    [self.navigationController pushViewController:pushNextViewController animated:YES];
}

@end
