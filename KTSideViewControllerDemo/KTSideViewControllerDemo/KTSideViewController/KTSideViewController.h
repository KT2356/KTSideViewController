//
//  KTSideViewController.h
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - public protocol method
@protocol KTSideViewControllerDelegate <NSObject>
- (void)showBackViewController;
@end

@interface KTSideViewController : UIViewController<KTSideViewControllerDelegate>

//init
- (instancetype)initWithBackViewContorller:(UIViewController *)backVC
                       FrontViewController:(UIViewController *)frontVC;

@end
