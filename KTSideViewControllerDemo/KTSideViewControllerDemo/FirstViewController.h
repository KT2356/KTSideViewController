//
//  FirstViewController.h
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTSideViewController.h"

@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) id<KTSideViewControllerDelegate> delegate;
@end
