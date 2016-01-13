//
//  KTSideViewController.m
//  KTSideViewControllerDemo
//
//  Created by KT on 15/12/11.
//  Copyright © 2015年 KT. All rights reserved.
//

#import "KTSideViewController.h"
#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

static const float kFirstViewShownwidth = 200.0f;

@interface KTSideViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *frontView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *tapGeatureMaskView;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIPanGestureRecognizer *maskPan;
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
        [self addFrontPageShadow];
    }
    return self;
}

#pragma mark - private methods
- (void)addFrontPageShadow {
    self.frontView.layer.shadowOffset = CGSizeZero;
    self.frontView.layer.shadowOpacity = 0.7f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    self.frontView.layer.shadowPath = shadowPath.CGPath;
}

- (void)showBackViewController {
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.1
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         _frontView.center = CGPointMake(kScreenWidth*3/2 - kFirstViewShownwidth, _frontView.center.y);
                     } completion:^(BOOL finished) {
                         [self addTapMaskView];
                     }];
}

- (void)addPanGesture {
    _pan              = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _pan.delegate     = self;
    _maskPan          = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    _maskPan.delegate = self;
    _tap              = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    _tap.cancelsTouchesInView = NO;
    [_backView addGestureRecognizer:_pan];
}

- (void)addTapMaskView {
    [_backView addSubview:self.tapGeatureMaskView];
    [self.tapGeatureMaskView addGestureRecognizer:_tap];
    [self.tapGeatureMaskView addGestureRecognizer:_maskPan];
}

//去掉MaskView
- (void)removeTapMaskView {
    [_backView removeGestureRecognizer:_tap];
    [self.tapGeatureMaskView addGestureRecognizer:_maskPan];
    [self.tapGeatureMaskView removeFromSuperview];
    self.tapGeatureMaskView = nil;
}


#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == _pan) {
        CGPoint translatedPoint = [gestureRecognizer locationInView:_backView];
        return translatedPoint.x > kScreenWidth - 50;
    }  else if (gestureRecognizer == _maskPan) {
        CGPoint translatedPoint = [gestureRecognizer locationInView:_tapGeatureMaskView];
        return translatedPoint.x > kScreenWidth - 50 -200;
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
                         _frontView.center = CGPointMake(kScreenWidth *3/2, _frontView.center.y);
                     } completion:^(BOOL finished) {
                         [self removeTapMaskView];
                     }];
}

- (void)gestureTranslation:(UIPanGestureRecognizer *)recognizer position:(float)x {
    _frontView.center = CGPointMake(x, _frontView.center.y);
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translatedPoint = [recognizer translationInView:_backView];
    CGFloat x = translatedPoint.x;
    //限制左拉距离
    if (x <= -kFirstViewShownwidth) {
        x = -kFirstViewShownwidth;
    }
    if (x < 0 && recognizer == _pan) {
        [self gestureTranslation:recognizer position:x +kScreenWidth*3/2];
    }
    if (x > 0 && recognizer == _maskPan) {
        [self gestureTranslation:recognizer position:x +kScreenWidth*3/2 -200];
    }
    
    if ([recognizer state] == UIGestureRecognizerStateEnded){
        if (x <= -kFirstViewShownwidth/3 && recognizer == _pan) {
            [UIView animateWithDuration:0.3 animations:^{
                [self gestureTranslation:recognizer position:-kFirstViewShownwidth + kScreenWidth*3/2];
            } completion:^(BOOL finished) {
                [self addTapMaskView];
            }];
        } else if (x < 0 && x > -kFirstViewShownwidth && recognizer == _pan) {
            [UIView animateWithDuration:0.3 animations:^{
                [self gestureTranslation:recognizer position:kScreenWidth * 3/2];
            }];
        }
        else if (x > 0 && recognizer == _maskPan){
            [UIView animateWithDuration:0.3 animations:^{
                [self gestureTranslation:recognizer position:kScreenWidth * 3/2];
            } completion:^(BOOL finished) {
                [self removeTapMaskView];
            }];
        }
    }
}

#pragma makr - setter/getter
- (void)setFrontView:(UIView *)frontView {
    _frontView = frontView;
    _frontView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:_frontView];
}

- (void)setBackView:(UIView *)backView {
    _backView = backView;
    [self.view addSubview:_backView];
}

- (UIView *)tapGeatureMaskView {
    if (!_tapGeatureMaskView ) {
        _tapGeatureMaskView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       kScreenWidth - kFirstViewShownwidth,
                                                                       [UIScreen mainScreen].bounds.size.height)];
        _tapGeatureMaskView.backgroundColor = [UIColor clearColor];
    }
    return _tapGeatureMaskView;
}

@end
