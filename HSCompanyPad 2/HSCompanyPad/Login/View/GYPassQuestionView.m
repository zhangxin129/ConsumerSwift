//
//  GYPassQuestionView.m
//  HSCompanyPad
//
//  Created by User on 16/8/4.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "GYPassQuestionView.h"
#import "GYSelectedButton.h"
#import <GYKit/UIView+Extension.h>
#import "GYShowPullDownViewVC.h"
#import "GYNetwork.h"
#import "GYNetAPiMacro.h"
#import "GYSetSafeSetQuestionModel.h"

@interface GYPassQuestionView (){

    GYShowPullDownViewVC *toolVC;
}

@property (nonatomic, strong) NSMutableArray* qustionArray;
@property (nonatomic, assign) NSInteger selectQuestionIndex;
@end

@implementation GYPassQuestionView


#pragma mark - lazy load

- (NSMutableArray*)qustionArray
{
    if (!_qustionArray) {
        _qustionArray = [NSMutableArray array];
    }
    return _qustionArray;
}


-(void)awakeFromNib{

    
        [self.questionBtn addTarget:self action:@selector(getListQuestionAction:) forControlEvents:UIControlEventTouchUpInside];
    
        [self.questionBackView addSubview:  self.questionBtn];
        
        @weakify(self);
        [self.questionBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.questionBackView.mas_top);
            make.left.equalTo(self.questionImageView.mas_right).offset(10);
            make.height.equalTo(self.questionBackView);
            make.right.mas_equalTo(0);
        }];
        
    [self.questionBtn setTitle:kLocalized(@"GYHS_Login_Please_Select_Question") forState:UIControlStateNormal];
    self.questionBtn.titleLabel.font = kFont18;
    
    _questionImageView.customBorderType = UIViewCustomBorderTypeRight;
    _answerImageView.customBorderType = UIViewCustomBorderTypeRight;
    [self setDeaultBackLine:self.questionBackView];
    [self setDeaultBackLine:self.answerBackView];
    
    //获取问题列表
    [self getListQuestionRequest];
}

-(void)setDeaultBackLine:(UIView*)view{
    
    view.layer.borderWidth=1;
    
    view.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    view.backgroundColor =[UIColor clearColor];
    
}

-(void)getListQuestionAction:(UIButton*)button{
    
    //如果初次加载成功，则调用临时数组，否则重新加载网络请求
    if (self.qustionArray.count > 0) {
        NSMutableArray* array = [NSMutableArray array];
        for (GYSetSafeSetQuestionModel* model in self.qustionArray) {
            [array addObject:model.question];
        }
        //此处要设为全局变量，否则会不响应回调
        toolVC = [[GYShowPullDownViewVC alloc] initWithView:button PullDownArray:array direction:UIPopoverArrowDirectionUp];
        @weakify(self);
        toolVC.selectBlock = ^(NSInteger index) {
            @strongify(self);
            self.selectQuestionIndex = index;
            self.answerTF.text = nil;
            [self.questionBtn setTitle:array[index] forState:UIControlStateNormal];
        };

    }
    else {
    
        [self getListQuestionRequest];
    }
    
}

#pragma mark -获取密保问题列表method

-(void)getListQuestionRequest{

    [GYNetwork GET:GY_HSDOMAINAPPENDING(GYHSListPwdQuestion) parameter:nil success:^(id returnValue) {
        if (kHTTPSuccessResponse(returnValue)) {
            NSArray *array = [GYSetSafeSetQuestionModel arrayOfModelsFromDictionaries:returnValue[GYNetWorkDataKey] error:nil];
            for (GYSetSafeSetQuestionModel *model in array) {
                [self.qustionArray addObject:model];
            }
        } else {

        }  
    } failure:^(NSError* error){
        
       
    } isIndicator:YES];
}
@end
