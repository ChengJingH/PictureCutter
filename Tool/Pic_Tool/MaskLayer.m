//
//  MaskLayer.m
//  Tool
//
//  Created by walen on 2019/4/8.
//  Copyright © 2019 walen. All rights reserved.
//

#import "MaskLayer.h"

@implementation MaskLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    //颜色覆盖
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    CGContextFillRect(ctx, self.frame);
    
    //透明区域
    CGRect holeRect = CGRectMake((self.frame.size.width-300)/2.0, (self.frame.size.height-300)/2.0, 300, 300);
    CGRect holeiInterSection = CGRectIntersection(holeRect, self.frame);
    
    CGContextClearRect(ctx, holeiInterSection);
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
//    //中间镂空的矩形框
//    CGRect myRect = self.contentFrame;
//    //背景
//    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
//    //镂空
//    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:myRect];
//    [path appendPath:circlePath];
//    [path setUsesEvenOddFillRule:YES];
//
//    CAShapeLayer *fillLayer = [CAShapeLayer layer];
//    fillLayer.path = path.CGPath;
//    fillLayer.fillRule = kCAFillRuleEvenOdd;//中间镂空的关键点 填充规则
//    fillLayer.fillColor = [UIColor grayColor].CGColor;
//    fillLayer.opacity = 0.5;
//    [self.layer addSublayer:fillLayer];
    
}


@end
