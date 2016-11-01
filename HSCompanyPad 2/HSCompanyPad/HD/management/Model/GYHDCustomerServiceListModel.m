//
//  GYHDCustomerServiceListModel.m
//  HSCompanyPad
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYHDCustomerServiceListModel.h"

@implementation GYHDCustomerServiceListModel
/*

 @property(nonatomic,copy)NSString*sessionId;//会话id
 @property(nonatomic,copy)NSString*sessionState;//会话状态
 @property(nonatomic,strong)NSMutableArray*customerServiceListArray;//客服数组
 @property(nonatomic,strong)NSMutableArray*sessionTimeListArray;//时间数组
 */

-(void)initWithDict:(NSDictionary *)dict{

    self.sessionId=dict[@"sessionId"];
    self.sessionState=dict[@"sessionStatus"];
    NSMutableArray*customerServiceListArray=[NSMutableArray array];
    NSMutableArray *sessionTimeListArray=[NSMutableArray array];
    
    for (NSDictionary*dic in dict[@"csOperRecordList"]) {
        
        NSString*consumerSeStr=dic[@"csOperNickName"];
        NSString*operStr=dic[@"csOperNo"];
        NSString*customerServiceStr=[NSString stringWithFormat:@"%@(%@)",consumerSeStr,operStr];
        [customerServiceListArray addObject:customerServiceStr];
        
        NSString*timeStr=dic[@"sessionTime"];
        
        NSDate *sendData = [[NSDate alloc]
                            initWithTimeIntervalSince1970:timeStr.longLongValue / 1000];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *sendDateString = [formatter stringFromDate:sendData];
        
        [sessionTimeListArray addObject:sendDateString];
    }
    self.customerServiceListStr=[customerServiceListArray componentsJoinedByString:@"\r\n"];
    
    self.sessionTimeListStr =[sessionTimeListArray componentsJoinedByString:@"   "];
  
}
@end
