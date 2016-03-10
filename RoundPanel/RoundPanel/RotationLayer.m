//
//  RotationLayer.m
//  myproduct
//
//  Created by gliu on 15/7/27.
//  Copyright (c) 2015年 . All rights reserved.
//

#import "RotationLayer.h"

@implementation RotationLayer

- (instancetype)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self) {
        if ([layer isKindOfClass:[RotationLayer class]]) {
            _total = 60;
        }
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allowsEdgeAntialiasing = YES;
        self.shouldRasterize = YES;
        _total = 60;
    }
    return self;
}

+ (instancetype)layer
{
    return [[RotationLayer alloc]init];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextRef context = ctx;
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetStrokeColorWithColor(context, [[UIColor orangeColor]CGColor]);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    CGFloat radius = MIN(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    NSInteger total = self.total;
    NSLog(@"%ld  %f",(long)total, _scanPosition);
    for (int i = 1; i <= total ; i++) {
        // Drawing code
        CGContextRotateCTM(context, 2*M_PI/total);
        UIBezierPath*path=[UIBezierPath bezierPathWithRect:CGRectMake(-2, -1*radius, 4, 10)];
        //        [path closePath];//将起点与结束点相连接
        CGContextAddPath(context, path.CGPath);
        if (i > self.scanPosition) {
            CGContextSetStrokeColorWithColor(context, [[UIColor brownColor]CGColor]);
            CGContextSetFillColorWithColor(context, [[UIColor brownColor]CGColor]);
        }
        else
        {
            if (i%5) {
                CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor]CGColor]);
                CGContextSetFillColorWithColor(context, [[UIColor magentaColor]CGColor]);
            }else{
                CGContextSetStrokeColorWithColor(context, [[UIColor redColor]CGColor]);
                CGContextSetFillColorWithColor(context, [[UIColor yellowColor]CGColor]);
            }
        }
        CGContextDrawPath(context, kCGPathFill);
    }
    CGContextRestoreGState(context);
}


//- (id<CAAction>)actionForKey:(NSString *)event
//{
//    if ([event isEqualToString:@"scanPosition"]) {
//        CABasicAnimation* animation = [CABasicAnimation animation];
//        return animation;
//    }
//    return [super actionForKey:event];
//}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:NSStringFromSelector(@selector(scanPosition))]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)setTotal:(NSInteger)total
{
    _total = total;
    if (total == 0) {
        NSLog(@"total ==0");
    }
}
@end
