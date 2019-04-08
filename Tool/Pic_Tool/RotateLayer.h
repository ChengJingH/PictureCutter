//
//  RotateLayer.h
//  Tool
//
//  Created by walen on 2019/4/4.
//  Copyright © 2019 walen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    KRotateAngle_360 = 0,
    KRotateAngle_90 = 1,
    KRotateAngle_180 = 2,
    KRotateAngle_270 = 3
} KRotateAngleType;

@interface RotateLayer : CALayer<CAAnimationDelegate>
{
    CGPoint p_point;
    CGRect tmp_rect;
    UIImage *tmp_image;
    
    int record_angle;//记录旋转角
}

//屏幕计时器
@property (nonatomic,weak)CADisplayLink *displayLink;

//绘制
- (void)drawMaskImage:(UIImage *)img andRect:(CGRect)rect;

//旋转
- (void)rotateLayer;

@end

NS_ASSUME_NONNULL_END
