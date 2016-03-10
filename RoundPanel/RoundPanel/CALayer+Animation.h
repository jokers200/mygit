//
//  CALayer+Animation.h
//  KWPlayer
//
//  Created by LiuGang on 16/3/7.
//  Copyright © 2016年 Kuwo Beijing Co., Ltd. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Animation)
//暂停layer上面的动画
- (void)pauseAnimation;
//继续layer上面的动画
- (void)resumeAniamtion;
@end
