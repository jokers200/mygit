//
//  CALayer+Animation.h
//
 
#import <QuartzCore/QuartzCore.h>

@interface CALayer (Animation)
//暂停layer上面的动画
- (void)pauseAnimation;
//继续layer上面的动画
- (void)resumeAniamtion;
@end
