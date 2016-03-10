//
//  RotationLayer.h
//  myproduct
//
//  Created by gliu on 15/7/27.
//  Copyright (c) 2015年 tendyron. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RotationLayer : CALayer
@property (nonatomic,assign) CGFloat scanPosition;
@property (nonatomic,assign) NSInteger total;
@end
