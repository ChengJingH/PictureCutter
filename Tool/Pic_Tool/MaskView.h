//
//  MaskView.h
//  Tool
//
//  Created by walen on 2019/4/2.
//  Copyright © 2019 walen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridView.h"
#import "RotateLayer.h"

NS_ASSUME_NONNULL_BEGIN

@interface MaskView : UIView

@property (nonatomic,assign)KRotateAngleType rotateType;

- (UIImage *)clipImage;

- (void)rotateImage;

- (void)resetImage;

@end

NS_ASSUME_NONNULL_END
