//
//  GYSetSafeSetQuestionModel.h
//  HSCompanyPad
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GYSetSafeSetQuestionModel : JSONModel

@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *question;

@end
