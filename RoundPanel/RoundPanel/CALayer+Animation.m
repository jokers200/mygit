//
//  CALayer+Animation.m
//  KWPlayer
//
//  Created by LiuGang on 16/3/7.
//  Copyright © 2016年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import "CALayer+Animation.h"

@implementation CALayer (Animation)
//暂停layer上面的动画
- (void)pauseAnimation
{
    CFTimeInterval pausedTime = [self convertTime:CACurrentMediaTime() fromLayer:nil];
    self.speed = 0.0;
    self.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeAniamtion
{
    CFTimeInterval pausedTime = [self timeOffset];
    self.speed = 1.0;
    self.timeOffset = 0.0;
    self.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.beginTime = timeSincePause;
}
@end
