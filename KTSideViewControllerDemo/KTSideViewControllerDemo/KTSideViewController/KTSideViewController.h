//
//  KTSideViewController.h
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KTSideViewController : UIViewController

- (instancetype)initWithBackViewContorller:(UIViewController *)backVC
                       FrontViewController:(UIViewController *)frontVC;

//设置需要隐藏的view
- (void)setNeedDisappearViews:(NSArray *)needDisappearViews;

/**
 *  @author KT, 2015-12-11 15:38:19
 *
 *  notification 自页面点击用于显示背景viewcontroller
 */
/*---- @"KTSideViewShouldShowBackVC" ----*/
@end
