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
@property (nonatomic, strong) UIView *tapGeatureMaskView;
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
        [self addFrontPageShadow];
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
- (void)addFrontPageShadow {
    self.frontView.layer.shadowOffset = CGSizeZero;
    self.frontView.layer.shadowOpacity = 0.7f;
    
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.frontView.layer.shadowPath = shadowPath.CGPath;
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBackViewController) name:@"KTSideViewShouldShowBackVC" object:nil];
}

- (void)showBackViewController {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _pan.view.center = CGPointMake(kScreenWidth*3/2 - kKTSileViewMinShownWidth, _pan.view.center.y);
                         [_pan setTranslation:CGPointMake(0, 0) inView:_frontView];
                         if (_needDisappearViews && _needDisappearViews.count > 0) {
                             for (UIView *view in _needDisappearViews) {
                                 view.alpha = 0;
                             }
                         }
                     } completion:^(BOOL finished) {
                         [self addTapMaskView];
                     }];
}

- (void)addPanGesture {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _pan.delegate = self;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    _tap.cancelsTouchesInView = NO;
    [_frontView addGestureRecognizer:_pan];
}

//为了屏蔽TapGesture 下面按钮的响应，增加MaskView
- (void)addTapMaskView {
    [_frontView addSubview:self.tapGeatureMaskView];
    [self.tapGeatureMaskView addGestureRecognizer:_tap];
}

//去掉MaskView
- (void)removeTapMaskView {
    [_frontView removeGestureRecognizer:_tap];
    [self.tapGeatureMaskView removeFromSuperview];
    self.tapGeatureMaskView = nil;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _pan) {
        CGPoint translatedPoint = [gestureRecognizer locationInView:_frontView];
        return translatedPoint.x < kKTSileViewMinShownWidth;
    } else {
        return NO;
    }
}

//通过protocol 调用
- (void)handleTapGesture:(UIPanGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         _pan.view.center = CGPointMake(kScreenWidth/2, _pan.view.center.y);
                         [_pan setTranslation:CGPointMake(0, 0) inView:_frontView];
                         if (_needDisappearViews && _needDisappearViews.count > 0) {
                             for (UIView *view in _needDisappearViews) {
                                 view.alpha = 1;
                             }
                         }
                     } completion:^(BOOL finished) {
                         [self removeTapMaskView];
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
            [self addTapMaskView];
        } else {
            x = kScreenWidth/2;
            [self removeTapMaskView];
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

- (UIView *)tapGeatureMaskView {
    if (!_tapGeatureMaskView ) {
        _tapGeatureMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kKTSileViewMinShownWidth, [UIScreen mainScreen].bounds.size.height)];
        _tapGeatureMaskView.backgroundColor = [UIColor clearColor];
    }
    return _tapGeatureMaskView;
}

@end
