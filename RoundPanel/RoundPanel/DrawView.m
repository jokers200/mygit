//
//  DrawView.m
//  myproduct
//
//  Created by gliu on 15/7/22.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "DrawView.h"
#import "RotationLayer.h"
#import "CALayer+Animation.h"

@interface DrawView ()<UIGestureRecognizerDelegate>
{
    CAReplicatorLayer* reLayer;
    NSArray* lineArray;
    NSInteger number;
    NSInteger currentNumber;
    BOOL     animating;
    RotationLayer* rotationLayer;
    CAShapeLayer* roundLayer;
    CAShapeLayer* outerRoundLayer;
    CAShapeLayer* outerBottomRoundLayer;
    UIImageView*  indicatorView;
    UIImageView*  indicatorRightView;
    CATextLayer*  textLayer;
}
@end

@implementation DrawView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.shouldRasterize = YES;
        self.layer.allowsEdgeAntialiasing = YES;

        [self setupButtonAndGesture];
        [self setupReplicatorLayer];
        [self setupInnerCircleLayer];
        [self setupRotationLayer];
        [self setupCircleLayer];
        [self setupRoundPoint];
        [self setupTrangelView];
        [self setupTextLayer];
    }
    return self;
}

- (void)setupButtonAndGesture
{
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    [self addGestureRecognizer:pan];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 60, 50, 50);
    [button setTitle:@"start" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)setupReplicatorLayer
{
    CGRect frame = self.frame;
    reLayer = [CAReplicatorLayer layer];
    reLayer.position = self.center;
    reLayer.instanceColor = [[UIColor yellowColor]CGColor];
    reLayer.bounds = CGRectMake(0, 0, frame.size.width/2, frame.size.height/2);
    reLayer.instanceCount = 60;
    CGFloat angle = (2.0f * M_PI) / (reLayer.instanceCount);
    CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0f, 0.0f, 1.0f);
    reLayer.instanceTransform = instanceRotation;
    reLayer.shouldRasterize = YES;
    [self.layer addSublayer:reLayer];
    
    CALayer* sublayer = [CALayer layer];
    sublayer.bounds = CGRectMake(0, 0, 3, 10);
    sublayer.backgroundColor = [[UIColor redColor]CGColor];
    sublayer.position = (CGPoint){reLayer.bounds.size.width/2,10};
    sublayer.shouldRasterize = YES;
    [reLayer addSublayer:sublayer];
}

- (void)setupRotationLayer
{
    CGRect frame = self.frame;
    rotationLayer = [[RotationLayer alloc]init];
    rotationLayer.position = CGPointMake(self.center.x, self.center.y);
    rotationLayer.bounds = CGRectIntegral(CGRectMake(0, 0, frame.size.width - 160, frame.size.height - 160));
    rotationLayer.anchorPointZ = -40;
    rotationLayer.backgroundColor = [[UIColor clearColor]CGColor];
    CATransform3D  transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0/300;
    //        transform3D.m43 = 20;
    rotationLayer.transform = transform3D;
    [self.layer addSublayer:rotationLayer];
    [rotationLayer setNeedsDisplay];
}

- (void)setupInnerCircleLayer
{
    CGRect frame = self.frame;
    roundLayer = [CAShapeLayer layer];
    roundLayer.position = CGPointMake(self.center.x, self.center.y);
    roundLayer.bounds = CGRectIntegral(CGRectMake(0, 0, frame.size.width - 200, frame.size.height - 200));
    roundLayer.anchorPointZ = -60;
    roundLayer.backgroundColor = [[UIColor clearColor]CGColor];
    roundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(roundLayer.bounds.size.width/2,roundLayer.bounds.size.height/2) radius:(frame.size.width - 160)/2 startAngle:-M_PI endAngle:M_PI clockwise:YES].CGPath;
    roundLayer.lineWidth = 2;
    roundLayer.strokeColor = [[UIColor whiteColor]CGColor];
    roundLayer.fillColor = [[UIColor clearColor]CGColor];
    roundLayer.shouldRasterize = YES;
    roundLayer.allowsEdgeAntialiasing = YES;
    [self.layer addSublayer:roundLayer];
}

- (void)setupCircleLayer
{
    CGRect frame = self.frame;
    outerRoundLayer = [CAShapeLayer layer];
    outerRoundLayer.position = CGPointMake(self.center.x, self.center.y);
    outerRoundLayer.bounds = CGRectIntegral(CGRectMake(0, 0, frame.size.width - 100, frame.size.height - 100));
    outerRoundLayer.anchorPointZ = -20;
    outerRoundLayer.backgroundColor = [[UIColor clearColor]CGColor];
    
    outerRoundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(outerRoundLayer.bounds.size.width/2,outerRoundLayer.bounds.size.height/2) radius:(frame.size.width - 120)/2 startAngle:-M_PI endAngle:0 clockwise:YES].CGPath;
    outerRoundLayer.lineWidth = 5;
    outerRoundLayer.strokeColor = [[UIColor whiteColor]CGColor];
    outerRoundLayer.fillColor = [[UIColor clearColor]CGColor];
    outerRoundLayer.shouldRasterize = YES;
    outerRoundLayer.allowsEdgeAntialiasing = YES;
    outerRoundLayer.masksToBounds = YES;
    outerRoundLayer.allowsGroupOpacity = YES;
    outerRoundLayer.edgeAntialiasingMask = 0x0f;
    [self.layer addSublayer:outerRoundLayer];
    
    outerBottomRoundLayer = [CAShapeLayer layer];
    outerBottomRoundLayer.position = CGPointMake(self.center.x, self.center.y);
    outerBottomRoundLayer.bounds = CGRectIntegral(CGRectMake(0, 0, frame.size.width - 100, frame.size.height - 100));
    outerBottomRoundLayer.anchorPointZ = -20;
    outerBottomRoundLayer.backgroundColor = [[UIColor clearColor]CGColor];
    
    outerBottomRoundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(outerBottomRoundLayer.bounds.size.width/2,outerBottomRoundLayer.bounds.size.height/2) radius:(frame.size.width - 120)/2 startAngle:0 endAngle:M_PI clockwise:YES].CGPath;
    outerBottomRoundLayer.lineWidth = 5;
    outerBottomRoundLayer.strokeColor = [[UIColor whiteColor]CGColor];
    outerBottomRoundLayer.fillColor = [[UIColor clearColor]CGColor];
    outerBottomRoundLayer.shouldRasterize = YES;
    outerBottomRoundLayer.allowsEdgeAntialiasing = YES;
    outerBottomRoundLayer.masksToBounds = YES;
    outerBottomRoundLayer.allowsGroupOpacity = YES;
    outerBottomRoundLayer.edgeAntialiasingMask = 0x0f;
    [self.layer addSublayer:outerBottomRoundLayer];
}

- (void)setupRoundPoint
{
    CGSize size = CGRectInset(outerRoundLayer.bounds, -10, -10).size;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor]CGColor]);
    CGContextTranslateCTM(context, size.width/2, size.height/2);
    CGFloat radius = MIN(size.width/2, size.height/2)-5;
    NSInteger total = 36;
    for (int i = 1; i <= total ; i++) {
        // Drawing code
        CGContextRotateCTM(context, 2*M_PI/total);
        UIBezierPath*path=[UIBezierPath bezierPathWithRect:CGRectMake(-2, -1*radius, 4, 10)];
        if (i%3==0) {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-5, -1*radius-5, 10, 10) cornerRadius:5];
            CGContextSetFillColorWithColor(context, [[UIColor blueColor]CGColor]);
        }
        else
        {
            path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-2, -1*radius-2, 4, 4) cornerRadius:2];
            CGContextSetFillColorWithColor(context, [[UIColor blueColor]CGColor]);
        }
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathFill);
    }
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
    imageView.layer.anchorPointZ = -10;
    [self addSubview:imageView];
    imageView.center = self.center;
}

- (void)setupTextLayer
{
    textLayer = [CATextLayer layer];
    textLayer.string = @"--%";
    UIFont* font = [UIFont systemFontOfSize:42];
    textLayer.font = CFBridgingRetain(font);
    textLayer.anchorPointZ = -100;
    textLayer.backgroundColor = [[UIColor clearColor]CGColor];
    textLayer.bounds = CGRectMake(0, 0, 150, font.lineHeight);
    textLayer.position = self.center;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen]scale];
    [self.layer addSublayer:textLayer];
}

- (void)setupTrangelView
{
    UIGraphicsBeginImageContext(CGSizeMake(20, 20));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor]CGColor]);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 20, 0);
    CGContextAddLineToPoint(context, 10, 20);
    CGContextAddLineToPoint(context, 0, 0);
    CGContextFillPath(context);
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    indicatorView = [[UIImageView alloc]initWithImage:image];
    indicatorView.layer.anchorPointZ = outerRoundLayer.anchorPointZ;
    indicatorView.hidden = YES;
    [self addSubview:indicatorView];
    
    indicatorRightView = [[UIImageView alloc]initWithImage:image];
    indicatorRightView.layer.anchorPointZ = outerRoundLayer.anchorPointZ;
    indicatorRightView.hidden = YES;
    [self addSubview:indicatorRightView];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShouldAntialias(context, YES);
    CGContextSetAllowsAntialiasing(context, YES);
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor]CGColor]);
    CGContextSetLineWidth(context, 5);
    CGContextAddPath(context, [UIBezierPath bezierPathWithArcCenter:self.center radius:(self.frame.size.width-20)/2 startAngle:-M_PI endAngle:M_PI clockwise:YES].CGPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

- (void)pan:(UIPanGestureRecognizer*)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
          
            CGPoint translation = [gesture translationInView:self];

            CGFloat angle = M_PI * translation.y * -1/180;
            if (angle > M_PI_2) {
                angle = M_PI_2;
            }

            CATransform3D transform = CATransform3DRotate(self.layer.sublayerTransform,angle, 1, 0, 0);
            if (transform.m23 > 0.7) {
                transform = CATransform3DMakeRotation(M_PI_2/2, 1, 0, 0);
            }
            else if (transform.m23 < 0){
                transform = CATransform3DIdentity;
            }
            self.layer.sublayerTransform = transform;
            
            [gesture setTranslation:CGPointZero inView:self];
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            
//            CGPoint velocity = [pan velocityInView:self.view];
//            [self addDecayPositionAnimationWithVelocity:velocity];
            break;
        }
            
        default:
            break;
    }
}


- (void)buttonPressed:(UIButton*)button
{
    if (animating) {
        animating = NO;
        [self pauseAnimation];
    }
    else
    {
        animating = YES;
        [self doAnimate];
        [self resumeAniamtion];
    }
    NSString* text = animating?@"stop":@"start";
    [button setTitle:text forState:UIControlStateNormal];
}

- (void)pauseAnimation
{
    [outerBottomRoundLayer pauseAnimation];
    [outerRoundLayer pauseAnimation];
    [indicatorRightView.layer pauseAnimation];
    [indicatorView.layer pauseAnimation];
    [rotationLayer pauseAnimation];
}

- (void)resumeAniamtion
{
    [outerBottomRoundLayer resumeAniamtion];
    [outerRoundLayer resumeAniamtion];
    [indicatorRightView.layer resumeAniamtion];
    [indicatorView.layer resumeAniamtion];
    [rotationLayer resumeAniamtion];
}

- (void)doAnimate
{
    animating = YES;
    if (rotationLayer.animationKeys.count == 0) {
        [self setScanPosition:@0.90 animate:YES];
        [self addTrangleAnimation];
        [self addStrokeCircleAniamtion];
    }

    return;
}

- (void)addStrokeCircleAniamtion
{
    if (outerRoundLayer.animationKeys.count > 0) {
        return;
    }
    CABasicAnimation* outterRoundStrokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    outterRoundStrokeAnimation.fromValue = @0.0;
    outterRoundStrokeAnimation.toValue = @1;
    outterRoundStrokeAnimation.duration = 2.0;
    outterRoundStrokeAnimation.repeatCount = HUGE_VALF;
    outterRoundStrokeAnimation.autoreverses = YES;
    
    CABasicAnimation* outterRoundRotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    outterRoundRotateAnimation.fromValue = @-M_PI;
    outterRoundRotateAnimation.toValue = @M_PI;
    outterRoundRotateAnimation.duration = 2.0;
    outterRoundRotateAnimation.repeatCount = HUGE_VALF;
    outterRoundRotateAnimation.autoreverses = YES;
    
    CAAnimationGroup* group = [CAAnimationGroup animation];
    group.animations = @[outterRoundStrokeAnimation,outterRoundRotateAnimation];
    group.duration = 2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    group.repeatCount = HUGE_VALF;
    group.autoreverses = YES;
    [outerRoundLayer addAnimation:group forKey:@"animate"];
    [outerBottomRoundLayer addAnimation:group forKey:@"animate"];
}

- (void)addTrangleAnimation
{
    indicatorView.hidden = NO;
    indicatorRightView.hidden = NO;
    if (indicatorView.layer.animationKeys.count > 0) {
        return;
    }
    {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.center.x - 150, self.center.y - 150, 300, 300)];
        path = [UIBezierPath bezierPathWithArcCenter:self.center radius:150 startAngle:-M_PI_4 endAngle:M_PI_4 clockwise:YES];
        animation.path = path.CGPath;
        animation.duration = 2.0;
        animation.repeatCount = HUGE_VALF;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.calculationMode = kCAAnimationLinear;
        animation.autoreverses = YES;
        animation.rotationMode =  kCAAnimationRotateAuto;
        
        CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAnimation.fromValue = @1;
        basicAnimation.toValue = @0.5;
        basicAnimation.duration = 2.0;
        basicAnimation.repeatCount = HUGE_VALF;
        basicAnimation.autoreverses = YES;
        
        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.animations = @[animation,basicAnimation];
        group.duration = 2;
        group.repeatCount = HUGE_VALF;
        group.autoreverses = YES;
        [indicatorView.layer addAnimation:group forKey:@"animate"];
        
    }
    
    {
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(self.center.x - 150, self.center.y - 150, 300, 300)];
        
        path = [UIBezierPath bezierPathWithArcCenter:self.center radius:150 startAngle:M_PI*3/4 endAngle:-M_PI*3/4  clockwise:YES];
        animation.path = path.CGPath;
        animation.duration = 2.0;
        animation.repeatCount = HUGE_VALF;
        animation.calculationMode = kCAAnimationLinear;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.autoreverses = YES;
        animation.rotationMode =  kCAAnimationRotateAuto;
        
        CABasicAnimation* basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        basicAnimation.fromValue = @0.5;
        basicAnimation.toValue = @1.0;
        basicAnimation.duration = 2.0;
        basicAnimation.repeatCount = HUGE_VALF;
        basicAnimation.autoreverses = YES;
        
        CAAnimationGroup* group = [CAAnimationGroup animation];
        group.animations = @[animation,basicAnimation];
        group.duration = 2;
        group.repeatCount = HUGE_VALF;
        group.autoreverses = YES;
        [indicatorRightView.layer addAnimation:group forKey:@"animate"];
    }
}

- (void)setScanPosition:(NSNumber*)position animate:(BOOL)animate
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"scanPosition"];
    animation.fromValue = [NSNumber numberWithInteger:rotationLayer.scanPosition];
    animation.toValue = [NSNumber numberWithInteger:rotationLayer.total*[position floatValue]];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = labs([animation.toValue integerValue] - [animation.fromValue integerValue]) *4/60;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [rotationLayer addAnimation:animation forKey:@"currentAnimation"];
    rotationLayer.scanPosition = rotationLayer.total*[position floatValue];
//    [rotationLayer setNeedsDisplay];
    textLayer.string = [NSString stringWithFormat:@"%.02f%%",[position floatValue]*100];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!animating) {
        return;
    }
    if (flag && [anim isKindOfClass:[CABasicAnimation class]] &&[((CABasicAnimation*)anim).keyPath isEqualToString:@"scanPosition"]){
        [self startRatationLayerAnimation];
    }
}

- (void)startRatationLayerAnimation
{
    CGFloat position = (CGFloat)(random()%100)/100;
    [self performSelector:@selector(setScanPosition:animate:) withObject:[NSNumber numberWithFloat:position]];
}
@end
