//
//  GYViewControllerLog.m
//  Pods
//
//  Created by zhangqy on 16/3/28.
//
//



#import "GYViewControllerLog.h"
#import "Aspects.h"



@implementation GYViewControllerLog
//+ (void)load {
//    NSArray *exceptionClassNames = @[@"UIInputWindowController", @"UINavigationController", @"UIViewController", @"UITabBarController"];
//    [UIViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id < AspectInfo > aspectInfo){
//        id obj = [aspectInfo instance];
//        NSString *objClassName = NSStringFromClass([obj class]);
//
//        for (NSString *name in exceptionClassNames) {
//            if ([name isEqualToString:objClassName]) {
//                return;
//            }
//        }
//        GYVCLifeLog(@"%@加载了", obj);
//    } error:nil];
//
//
//    [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id < AspectInfo > aspectInfo){
//        id obj = [aspectInfo instance];
//        NSString *objClassName = NSStringFromClass([obj class]);
//
//        for (NSString *name in exceptionClassNames) {
//            if ([name isEqualToString:objClassName]) {
//                return;
//            }
//        }
//        GYVCLifeLog(@"%@销毁了", obj);
//    } error:nil];
//}

@end
