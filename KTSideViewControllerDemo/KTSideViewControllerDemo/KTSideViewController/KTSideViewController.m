//
//  KTSideViewController.m
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "KTSideViewController.h"
@interface KTSideViewController ()
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;
@end

@implementation KTSideViewController

- (instancetype)initWithBackViewContorller:(UIViewController *)backVC FrontViewController:(UIViewController *)frontVC {
    self = [super init];
    if (self) {
        [self addChildViewController:frontVC];
        [self addChildViewController:backVC];
        [self.view addSubview:self.childViewControllers[1].view];
        [self.view addSubview:self.childViewControllers[0].view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"load  %@",self.childViewControllers);
    
    

}

@end
