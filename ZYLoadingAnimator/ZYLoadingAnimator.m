//
//  ZYLoadingAnimator.m
//  ZYLoading
//
//  Created by macOfEthan on 17/12/11.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

#define ZY_LINE_WIDTH 4
#define ZY_LINE_COLOR [UIColor redColor]

#import "ZYLoadingAnimator.h"
#import "CALayer+ZYTextAnimationGenerator.h"

@interface ZYLoadingAnimator()
@property (nonatomic, strong) ZYLoadingAnimator *animator;


@property (nonatomic, strong) CADisplayLink *circleDisplayLink;
@property (nonatomic, strong) CADisplayLink *textDisplayLink;


@property (nonatomic, assign) CGFloat startAngle;
@property (nonatomic, assign) CGFloat endAngle;
@property (nonatomic, assign) CGFloat circleProgress;
@property (nonatomic, assign) CGFloat textProgress;


@property (nonatomic, strong) CALayer *animateLayer;
@property (nonatomic, strong) CAShapeLayer *circleLayer;
@property (nonatomic, strong) CAShapeLayer *textLayer;


@end

@implementation ZYLoadingAnimator

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
    
    self.circleLayer.strokeColor =  _tintColor.CGColor;
    self.textLayer.strokeColor = _tintColor.CGColor;
}

- (CADisplayLink *)circleDisplayLink
{
    if (!_circleDisplayLink) {
        self.circleDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(circleDisplayLink:)];
    }
    return _circleDisplayLink;
}

- (CADisplayLink *)textDisplayLink
{
    if (!_textDisplayLink) {
        self.textDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(textDisplayLink:)];
    }
    return _textDisplayLink;
}

- (CALayer *)animateLayer
{
    if (!_animateLayer) {
        self.animateLayer = [[CALayer alloc] init];
        self.animateLayer.frame = self.bounds;
        [self.layer addSublayer:self.animateLayer];
    }
    return _animateLayer;
}

- (CAShapeLayer *)circleLayer
{
    if (!_circleLayer) {
        self.circleLayer = [[CAShapeLayer alloc] init];
        self.circleLayer.fillColor = [UIColor clearColor].CGColor;
        self.circleLayer.strokeColor = ZY_LINE_COLOR.CGColor;
        self.circleLayer.lineWidth = ZY_LINE_WIDTH;
        self.circleLayer.lineCap = kCALineCapRound;
        [self.animateLayer addSublayer:self.circleLayer];
    }
    return _circleLayer;
}

- (CAShapeLayer *)textLayer
{
    if (!_textLayer) {
        
        self.textLayer = [self.circleLayer setupAnimationTextLayerWithText:@"loadding..." fontSize:18 fontColor:ZY_LINE_COLOR];
    }
    return _textLayer;
}

- (void)layoutSubviews
{
    self.circleLayer.frame = self.animateLayer.bounds;
    self.textLayer.frame = CGRectMake(18, CGRectGetHeight(self.frame)/2-12, CGRectGetWidth(self.frame)/2-30, CGRectGetHeight(self.frame)/2-30);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.circleDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [self.textDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        self.circleDisplayLink.paused = YES;
        self.textDisplayLink.paused = YES;
    }
    return self;
}


- (void)configLayer
{
    _startAngle = -M_PI_2;
    _endAngle = _startAngle + _circleProgress * M_PI *2;
    
    if (_endAngle >= M_PI) {
        
        //起点在剩余最后1/4的时间里跑完2π需要的速度 越来越大
        CGFloat speed = 1 - (1 - _circleProgress)/0.25;
        
        _startAngle = -M_PI_2 + speed * M_PI * 2;
    }
    
    CGFloat radius = CGRectGetWidth(self.bounds)/2 - ZY_LINE_WIDTH;
    CGFloat centerX = CGRectGetWidth(self.bounds)/2;
    CGFloat centerY = CGRectGetHeight(self.bounds)/2;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:_startAngle endAngle:_endAngle clockwise:YES];
    self.circleLayer.path = circlePath.CGPath;
}

- (void)circleDisplayLink:(CADisplayLink *)displayLink
{
    _circleProgress += [self loaddingSpeed];
    
    if (_circleProgress >= 1) {
        _circleProgress = 0;
    }
    
    self.textLayer.strokeEnd = 1;
    
    [self configLayer];
}

- (CGFloat)loaddingSpeed
{
    if (_endAngle > M_PI) {
        return 0.5/60.0f;
    }
    return 2/60.0f;
}

- (void)textDisplayLink:(CADisplayLink *)displayLink
{
    _textProgress += 0.01;
    
    if (_textProgress >= 1.5) {
        
        _textProgress = -0.5;
    }
    
    self.textLayer.strokeEnd = _textProgress;
}


- (void)start
{
    [self.circleDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.textDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    self.circleDisplayLink.paused = NO;
    self.textDisplayLink.paused = NO;
    
    [self setNeedsLayout];
    
    if (self.tintColor) {
        self.circleLayer.strokeColor =  self.tintColor.CGColor;
        self.textLayer.strokeColor = self.tintColor.CGColor;
    }
}

- (void)stop
{
    self.circleDisplayLink.paused = YES;
    self.textDisplayLink.paused = YES;
    
    _endAngle = 0;
    _startAngle = 0;
    _circleProgress = 0;
    _textProgress = 0;
    _circleDisplayLink = nil;
    _textDisplayLink = nil;
    
    [self.circleLayer removeFromSuperlayer];
    _circleLayer = nil;
    [self.textLayer removeFromSuperlayer];
    _textLayer = nil;
}

static ZYLoadingAnimator *animator = nil;

+ (instancetype)shareAnimator
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        animator = [ZYLoadingAnimator new];
    });
    
    return animator;
}

- (instancetype)showLoaddingAnimatorInView:(UIView *)targetView tintColor:(UIColor *)tintColor
{
    _animator = [[ZYLoadingAnimator alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _animator.tintColor = tintColor;
    _animator.center = targetView.center;
    [targetView addSubview:_animator];
    
    [_animator start];
    
    return _animator;
}

- (void)hiddenLoaddingAnimator
{
    [_animator removeFromSuperview];
    _animator = nil;
}


@end
