//
//  mainViewController.m
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/29.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "mainViewController.h"
#import "KTSideViewController.h"
#import "FirstViewController.h"
#import "SecontViewController.h"
#import "NaviViewController.h"

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    FirstViewController *firstVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    NaviViewController *secondVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NaviViewController"];
    
    KTSideViewController *containerVC = [[KTSideViewController alloc]initWithBackViewContorller:secondVC
                                                                            FrontViewController:firstVC];
    //[containerVC setNeedDisappearViews:@[firstVC.headerView]];
    SecontViewController *back = (SecontViewController *)secondVC.topViewController;
    back.delegate = containerVC;
    
    [self addChildViewController:containerVC];
    [self.view addSubview:containerVC.view];
}

@end
