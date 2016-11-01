//
//  UIViewController+Category.m
//  HSCompanyPad
//
//  Created by User on 16/8/3.
//  Copyright © 2016年 net.hsxt.HSCompanyPad. All rights reserved.
//

#import "UIViewController+Category.h"
@implementation UIViewController (Category)


- (UIDocumentInteractionController *)fileController {
    

      UIDocumentInteractionController*  fileController = [[UIDocumentInteractionController alloc]init];
    
        fileController.delegate = self;
    
        return fileController;
}

-(BOOL)readFile:(NSString*)fileName FromLocalPath:(NSString*)localPath{

    NSURL *fileUrl =[NSURL fileURLWithPath:localPath];
    
    UIDocumentInteractionController*fileVC= [self fileController];
    
    fileVC.URL= fileUrl;
    
    return [fileVC presentPreviewAnimated:YES];
    
}

-(BOOL)readFileFromLocalURL:(NSURL*)localUrl{
    
    UIDocumentInteractionController*fileVC= [self fileController];
    
    fileVC.URL= localUrl;
    
    return [fileVC presentPreviewAnimated:YES];
}


#pragma mark - UIDocumentInteractionController Delegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    
    return  self;
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application {
    
    DDLogInfo(@"Starting to send this puppy to %@", application);
}

- (void)documentInteractionController:(UIDocumentInteractionController *)controller didEndSendingToApplication:(NSString *)application {
    
    DDLogInfo(@"We're done sending the document.");
}

- (void)documentInteractionControllerDidDismissOptionsMenu:(UIDocumentInteractionController *)controller{

    DDLogInfo(@"did dimiss menu");
}

@end
