//
//  GridView.m
//  Tool
//
//  Created by walen on 2019/4/2.
//  Copyright © 2019 walen. All rights reserved.
//

#import "GridView.h"

@implementation GridView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加手势
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction)];
//        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)panAction
{
    NSLog(@"");
    
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    
}


@end
