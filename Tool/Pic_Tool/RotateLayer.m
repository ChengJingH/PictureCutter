//
//  RotateLayer.m
//  Tool
//
//  Created by walen on 2019/4/4.
//  Copyright © 2019 walen. All rights reserved.
//

#import "RotateLayer.h"

@implementation RotateLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        //背景颜色
        self.backgroundColor = [UIColor blackColor].CGColor;
        
        //计时器
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(rotateAnimal)];
        [self.displayLink  addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [self.displayLink setPaused:YES];
    }
    return self;
}

//旋转层
- (void)drawInContext:(CGContextRef)ctx
{
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -self.bounds.size.height);
    
    CGContextTranslateCTM(ctx, self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    CGContextRotateCTM(ctx, M_PI_2/90.0*r_count);

    CGContextTranslateCTM(ctx, p_point.x, -p_point.y);
    
    CGContextDrawImage(ctx, tmp_rect, tmp_image.CGImage);
    
    //绘制边框
    CGContextBeginPath(ctx);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 2);
    CGContextMoveToPoint(ctx, -150-p_point.x, 150+p_point.y);
    CGContextAddLineToPoint(ctx, 150-p_point.x, 150+p_point.y);
    CGContextAddLineToPoint(ctx, 150-p_point.x, -150+p_point.y);
    CGContextAddLineToPoint(ctx, -150-p_point.x, -150+p_point.y);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

}

static int r_count = 0;
- (void)rotateAnimal
{
    r_count ++;
    if (r_count >= record_angle + 90) {
        [self.displayLink setPaused:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ListenRotateStatus" object:nil];
        
        //防止数据越界
        if (r_count > 360) {
            r_count -= 360;
        }
    }
    
    [self setNeedsDisplay];
}

- (void)rotateLayer
{
    record_angle = r_count;
    [self.displayLink setPaused:NO];
}

- (void)drawMaskImage:(UIImage *)img andRect:(CGRect)rect
{
//    NSLog(@"%@",NSStringFromCGRect(rect));
    p_point = CGPointMake(rect.origin.x, rect.origin.y);

    tmp_image = [UIImage imageNamed:@"timg.jpeg"];
    tmp_rect = CGRectMake(-rect.size.width/2.0, -rect.size.height/2.0, rect.size.width, rect.size.height);
//        tmp_rect = CGRectMake(-450, -300, 900, 600);

//    NSLog(@"%@",NSStringFromCGRect(tmp_rect));

    [self setNeedsDisplay];
}



@end
