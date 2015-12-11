//
//  KTSideViewController.m
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "KTSideViewController.h"
#define kKTSileViewMinShownWidth 65
#define kScreenWidth             [UIScreen mainScreen].bounds.size.width

@interface KTSideViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) NSArray *needDisappearViews;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@end

@implementation KTSideViewController

#pragma mark - public methods
- (instancetype)initWithBackViewContorller:(UIViewController *)backVC FrontViewController:(UIViewController *)frontVC {
    self = [super init];
    if (self) {
        [self addChildViewController:frontVC];
        [self addChildViewController:backVC];
        [self setBackView:backVC.view];
        [self setFrontView:frontVC.view];
        [self addPanGesture];
        [self addNotification];
    }
    return self;
}

- (void)setNeedDisappearViews:(NSArray *)needDisappearViews {
    if (_needDisappearViews) {
        _needDisappearViews = [[NSArray alloc] init];
    }
    _needDisappearViews = needDisappearViews;
}

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBackViewController) name:@"KTSideViewShouldShowBackVC" object:nil];
}

- (void)showBackViewController {
    [UIView animateWithDuration:0.3 animations:^{
        _pan.view.center = CGPointMake(kScreenWidth*3/2 - kKTSileViewMinShownWidth, _pan.view.center.y);
        [_pan setTranslation:CGPointMake(0, 0) inView:_frontView];
        if (_needDisappearViews && _needDisappearViews.count > 0) {
            for (UIView *view in _needDisappearViews) {
                view.alpha = 0;
            }
        }
    }];
}

- (void)addPanGesture {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _pan.delegate = self;
    
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    _tap.delegate = self;
    _tap.cancelsTouchesInView = NO;
    [_frontView addGestureRecognizer:_tap];
    [_frontView addGestureRecognizer:_pan];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _pan) {
        CGPoint translatedPoint = [gestureRecognizer locationInView:_frontView];
        return translatedPoint.x < kKTSileViewMinShownWidth;
    } else {
        return gestureRecognizer.view.center.x == kScreenWidth*3/2 - kKTSileViewMinShownWidth ? YES : NO;
    }
}


- (void)handleTapGesture:(UIPanGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3                                                                                                                                                                                               animations:^{
        _pan.view.center = CGPointMake(kScreenWidth/2, _pan.view.center.y);
        [_pan setTranslation:CGPointMake(0, 0) inView:_frontView];
        if (_needDisappearViews && _needDisappearViews.count > 0) {
            for (UIView *view in _needDisappearViews) {
                view.alpha = 1;
            }
        }
    }];
}

- (void)gestureTranslation:(UIPanGestureRecognizer *)recognizer position:(float)x {
    recognizer.view.center = CGPointMake(x, recognizer.view.center.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:_frontView];
    if (_needDisappearViews && _needDisappearViews.count > 0) {
        for (UIView *view in _needDisappearViews) {
            view.alpha = 1 - (x - 160)/(kScreenWidth - kKTSileViewMinShownWidth);
        }
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:_frontView];
    CGFloat x = recognizer.view.center.x + translatedPoint.x;
    
    if (x > kScreenWidth*3/2 - kKTSileViewMinShownWidth) {
        x = kScreenWidth*3/2 - kKTSileViewMinShownWidth;
    }
    if (x < kScreenWidth/2 ) {
        x = kScreenWidth/2;
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded){
        if (x >= kScreenWidth) {
            x = kScreenWidth*3/2 - kKTSileViewMinShownWidth;
        } else {
            x = kScreenWidth/2;
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self gestureTranslation:recognizer position:x];
        }];
        return;
    }
    [self gestureTranslation:recognizer position:x];
}

#pragma makr - setter/getter
- (void)setFrontView:(UIView *)frontView {
    if (!_frontView) {
        _frontView = [[UIView alloc] init];
    }
    _frontView = frontView;
    [self.view addSubview:_frontView];
}

- (void)setBackView:(UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    _backView = backView;
    [self.view addSubview:_backView];
}

@end
